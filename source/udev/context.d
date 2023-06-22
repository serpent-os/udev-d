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
import udev.enumerator;
import udev.exc;

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

    /**
     * Returns: a new enumerator for this context
     */
    auto enumerator() @trusted
    {
        auto h = udev.binding.udev_enumerate_new(this.handle).enforce!UdevException;
        return Enumerator(h);
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
        this.handle = udev.binding.udev_ref(other.handle).enforce!UdevException;
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
    Context c = {handle: udev.binding.udev_new().enforce!UdevException};
    return c;
}

@safe unittest
{
    import std.stdio : writeln;

    auto c = context.safeRefCounted;
}
