# Snapperoo

A small, bare essentials utility for taking Btrfs snapshots.

Snapperoo is designed to be the bare minimum required to automatically take Btrfs snapshots and delete old snapshots according to a retention policy.

## Dependencies

- btrfs
- bash
- [jq](https://stedolan.github.io/jq/)

## Configuration

Snapperoo is configured using a fairly simple JSON file.
By default, this is read from `/etc/snapperoo.json`, but can be specified manually by setting the `SNAPPEROO_CONFIG` environment variable.

### Example

This assumes a filesystem layout similar to that which is [described here](https://wiki.archlinux.org/index.php/Snapper#Suggested_filesystem_layout).

The following is an exaple of a configuration that will keep:
  - 7 daily and 52 weekly snapshots of `/`, stored in `/.snapshots/root`
  - 24 hourly and 7 daily snapshots of `/home`, stored in `/.snaphsots/home`

```json
[
  {
    "source": "/",
    "target": "/.snapshots/root",
    "schedules": {
      "daily": {
        "retention_count": 7
      },
      "weekly": {
        "retention_count": 52
      }
    }
  },
  {
    "source": "/home",
    "target": "/.snapshots/home",
    "schedules": {
      "hourly": {
        "retention_count": 24
      },
      "daily": {
        "retention_count": 7
      }
    }
  }
]
```

## Invocation

Snapperoo is designed to be invoked according to the desired schedules, with the current schedule being passed as a single parameter.

E.g. for a daily schedule as per the above configuration, `snapper daily` should be called once per day.

The scheduling of the snapshots is the responsibility of the job scheduler, Snapperoo simply takes snapshots when requested and removes any that are deemed to be old.
This also allows Snapperoo to be triggered by other events, e.g. package or configuration updates, using an appropriately named "schedule".

### Systemd

Templated Systemd units are included for scheduling time based snapshots using Systemd.
Schedules are limited to time specifications that are supported by `OnCalendar` (see `systemd.timer(5)` and `systemd.time(7)`).

E.g. in order to take hourly, daily and weekly snapshots for the above configuration, the following timers should be enabled:
```sh
systemctl enable snapperoo@hourly.timer
systemctl enable snapperoo@daily.timer
systemctl enable snapperoo@weekly.timer
```
