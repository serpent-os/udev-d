/*
 * SPDX-FileCopyrightText: Copyright © 2020-2023 Serpent OS Developers
 *
 * SPDX-License-Identifier: Zlib
 */

/**
 * udevd
 *
 * Enumeration of devices
 *
 * Authors: Copyright © 2020-2023 Serpent OS Developers
 * License: Zlib
 */

module udevd;

public import udevd.binding;
import std.exception : errnoEnforce, enforce;
import core.stdc.stdio : puts;

unittest
{
    auto d = udev_new().errnoEnforce;
    auto enu = d.udev_enumerate_new.errnoEnforce;
    scope (exit)
    {
        enu.udev_enumerate_unref();
        d.udev_unref();
    }
    immutable ret = enu.udev_enumerate_scan_devices();
    enforce(ret >= 0);
    for (auto li = enu.udev_enumerate_get_list_entry(); li !is null; li = li
            .udev_list_entry_get_next)
    {
        const name = li.udev_list_entry_get_name;
        name.puts;
    }
}
