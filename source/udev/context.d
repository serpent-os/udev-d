/*
 * SPDX-FileCopyrightText: Copyright © 2020-2023 Serpent OS Developers
 *
 * SPDX-License-Identifier: Zlib
 */

/**
 * udev.context
 *
 * Access the global udev context
 *
 * Authors: Copyright © 2020-2023 Serpent OS Developers
 * License: Zlib
 */

module udev.context;

static import udev.binding;
public import std.typecons : safeRefCounted, borrow;

/**
 * Wraps `udev*` to provide a context type
 */
public struct Context
{

    @disable this();

    /**
     * Decrease udev context refcount
     */
    ~this() @trusted
    {
        if (handle !is null)
        {
            handle = udev.binding.udev_unref(handle);
        }
    }

private:

    /**
     * Copy a udev context by increasing the refcount
     *
     * Params:
     *   other = The other udev Context
     */
    this(ref Context other) @trusted
    {
        this.handle = udev.binding.udev_ref(other.handle);
    }

    udev.binding.udev* handle;
}

/**
 * Create a new udev context
 *
 * Returns: Context initialised with new udev*
 */
auto context() @trusted
{
    Context c = {handle: udev.binding.udev_new()};
    return c;
}

@safe unittest
{
    import std.stdio : writeln;

    auto c = context.safeRefCounted;
}
