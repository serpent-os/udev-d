module udev.binding;

import core.stdc.stdarg;
import core.sys.posix.sys.types;

extern (C):
@nogc:
nothrow:

struct udev;
udev* udev_ref (udev* udev);
udev* udev_unref (udev* udev);
udev* udev_new ();
void udev_set_log_fn (
    udev* udev,
    void function (udev* udev, int priority, const(char)* file, int line, const(char)* fn, const(char)* format, va_list args) log_fn);
int udev_get_log_priority (udev* udev);
void udev_set_log_priority (udev* udev, int priority);
void* udev_get_userdata (udev* udev);
void udev_set_userdata (udev* udev, void* userdata);

struct udev_list_entry;
udev_list_entry* udev_list_entry_get_next (udev_list_entry* list_entry);
udev_list_entry* udev_list_entry_get_by_name (udev_list_entry* list_entry, const(char)* name);
const(char)* udev_list_entry_get_name (udev_list_entry* list_entry);
const(char)* udev_list_entry_get_value (udev_list_entry* list_entry);

struct udev_device;
udev_device* udev_device_ref (udev_device* udev_device);
udev_device* udev_device_unref (udev_device* udev_device);
udev* udev_device_get_udev (udev_device* udev_device);
udev_device* udev_device_new_from_syspath (udev* udev, const(char)* syspath);
udev_device* udev_device_new_from_devnum (udev* udev, char type, dev_t devnum);
udev_device* udev_device_new_from_subsystem_sysname (udev* udev, const(char)* subsystem, const(char)* sysname);
udev_device* udev_device_new_from_device_id (udev* udev, const(char)* id);
udev_device* udev_device_new_from_environment (udev* udev);

udev_device* udev_device_get_parent (udev_device* udev_device);
udev_device* udev_device_get_parent_with_subsystem_devtype (
    udev_device* udev_device,
    const(char)* subsystem,
    const(char)* devtype);

const(char)* udev_device_get_devpath (udev_device* udev_device);
const(char)* udev_device_get_subsystem (udev_device* udev_device);
const(char)* udev_device_get_devtype (udev_device* udev_device);
const(char)* udev_device_get_syspath (udev_device* udev_device);
const(char)* udev_device_get_sysname (udev_device* udev_device);
const(char)* udev_device_get_sysnum (udev_device* udev_device);
const(char)* udev_device_get_devnode (udev_device* udev_device);
int udev_device_get_is_initialized (udev_device* udev_device);
udev_list_entry* udev_device_get_devlinks_list_entry (udev_device* udev_device);
udev_list_entry* udev_device_get_properties_list_entry (udev_device* udev_device);
udev_list_entry* udev_device_get_tags_list_entry (udev_device* udev_device);
udev_list_entry* udev_device_get_current_tags_list_entry (udev_device* udev_device);
udev_list_entry* udev_device_get_sysattr_list_entry (udev_device* udev_device);
const(char)* udev_device_get_property_value (udev_device* udev_device, const(char)* key);
const(char)* udev_device_get_driver (udev_device* udev_device);
dev_t udev_device_get_devnum (udev_device* udev_device);
const(char)* udev_device_get_action (udev_device* udev_device);
ulong udev_device_get_seqnum (udev_device* udev_device);
ulong udev_device_get_usec_since_initialized (udev_device* udev_device);
const(char)* udev_device_get_sysattr_value (udev_device* udev_device, const(char)* sysattr);
int udev_device_set_sysattr_value (udev_device* udev_device, const(char)* sysattr, const(char)* value);
int udev_device_has_tag (udev_device* udev_device, const(char)* tag);
int udev_device_has_current_tag (udev_device* udev_device, const(char)* tag);

struct udev_monitor;
udev_monitor* udev_monitor_ref (udev_monitor* udev_monitor);
udev_monitor* udev_monitor_unref (udev_monitor* udev_monitor);
udev* udev_monitor_get_udev (udev_monitor* udev_monitor);

udev_monitor* udev_monitor_new_from_netlink (udev* udev, const(char)* name);

int udev_monitor_enable_receiving (udev_monitor* udev_monitor);
int udev_monitor_set_receive_buffer_size (udev_monitor* udev_monitor, int size);
int udev_monitor_get_fd (udev_monitor* udev_monitor);
udev_device* udev_monitor_receive_device (udev_monitor* udev_monitor);

int udev_monitor_filter_add_match_subsystem_devtype (
    udev_monitor* udev_monitor,
    const(char)* subsystem,
    const(char)* devtype);
int udev_monitor_filter_add_match_tag (udev_monitor* udev_monitor, const(char)* tag);
int udev_monitor_filter_update (udev_monitor* udev_monitor);
int udev_monitor_filter_remove (udev_monitor* udev_monitor);

struct udev_enumerate;
udev_enumerate* udev_enumerate_ref (udev_enumerate* udev_enumerate);
udev_enumerate* udev_enumerate_unref (udev_enumerate* udev_enumerate);
udev* udev_enumerate_get_udev (udev_enumerate* udev_enumerate);
udev_enumerate* udev_enumerate_new (udev* udev);

int udev_enumerate_add_match_subsystem (udev_enumerate* udev_enumerate, const(char)* subsystem);
int udev_enumerate_add_nomatch_subsystem (udev_enumerate* udev_enumerate, const(char)* subsystem);
int udev_enumerate_add_match_sysattr (udev_enumerate* udev_enumerate, const(char)* sysattr, const(char)* value);
int udev_enumerate_add_nomatch_sysattr (udev_enumerate* udev_enumerate, const(char)* sysattr, const(char)* value);
int udev_enumerate_add_match_property (udev_enumerate* udev_enumerate, const(char)* property, const(char)* value);
int udev_enumerate_add_match_sysname (udev_enumerate* udev_enumerate, const(char)* sysname);
int udev_enumerate_add_match_tag (udev_enumerate* udev_enumerate, const(char)* tag);
int udev_enumerate_add_match_parent (udev_enumerate* udev_enumerate, udev_device* parent);
int udev_enumerate_add_match_is_initialized (udev_enumerate* udev_enumerate);
int udev_enumerate_add_syspath (udev_enumerate* udev_enumerate, const(char)* syspath);

int udev_enumerate_scan_devices (udev_enumerate* udev_enumerate);
int udev_enumerate_scan_subsystems (udev_enumerate* udev_enumerate);

udev_list_entry* udev_enumerate_get_list_entry (udev_enumerate* udev_enumerate);

struct udev_queue;
udev_queue* udev_queue_ref (udev_queue* udev_queue);
udev_queue* udev_queue_unref (udev_queue* udev_queue);
udev* udev_queue_get_udev (udev_queue* udev_queue);
udev_queue* udev_queue_new (udev* udev);
ulong udev_queue_get_kernel_seqnum (udev_queue* udev_queue);
ulong udev_queue_get_udev_seqnum (udev_queue* udev_queue);
int udev_queue_get_udev_is_active (udev_queue* udev_queue);
int udev_queue_get_queue_is_empty (udev_queue* udev_queue);
int udev_queue_get_seqnum_is_finished (udev_queue* udev_queue, ulong seqnum);
int udev_queue_get_seqnum_sequence_is_finished (
    udev_queue* udev_queue,
    ulong start,
    ulong end);
int udev_queue_get_fd (udev_queue* udev_queue);
int udev_queue_flush (udev_queue* udev_queue);
udev_list_entry* udev_queue_get_queued_list_entry (udev_queue* udev_queue);

struct udev_hwdb;
udev_hwdb* udev_hwdb_new (udev* udev);
udev_hwdb* udev_hwdb_ref (udev_hwdb* hwdb);
udev_hwdb* udev_hwdb_unref (udev_hwdb* hwdb);
udev_list_entry* udev_hwdb_get_properties_list_entry (udev_hwdb* hwdb, const(char)* modalias, uint flags);

int udev_util_encode_string (const(char)* str, char* str_enc, size_t len);
