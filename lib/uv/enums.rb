module UV
  extend FFI::Library
  # (Not documented)
  #
  # ## Options:
  #
  # @method `enum_errno`
  # @return [Symbol]
  # @scope class
  #
  enum :errno, [
  ]

  # (Not documented)
  #
  # ## Options:
  # :uv_unknown_req ::
  #
  # :uv_req ::
  #
  # :uv_connect ::
  #
  # :uv_write ::
  #
  # :uv_shutdown ::
  #
  # :uv_udp_send ::
  #
  # :uv_fs ::
  #
  # :uv_work ::
  #
  # :uv_getaddrinfo ::
  #
  # :uv_req_type_max ::
  #
  #
  # @method `enum_req_type`
  # @return [Symbol]
  # @scope class
  #
  enum :req_type, [
    :uv_unknown_req, 0,
    :uv_req, 1,
    :uv_connect, 2,
    :uv_write, 3,
    :uv_shutdown, 4,
    :uv_udp_send, 5,
    :uv_fs, 6,
    :uv_work, 7,
    :uv_getaddrinfo, 8,
    :uv_req_type_max, 9
  ]

  # (Not documented)
  #
  # ## Options:
  # :uv_leave_group ::
  #
  # :uv_join_group ::
  #
  #
  # @method `enum_membership`
  # @return [Symbol]
  # @scope class
  #
  enum :membership, [
    :uv_leave_group, 0,
    :uv_join_group, 1
  ]

  # UDP support.
  #
  # ## Options:
  # :uv_udp_ipv6only ::
  #   Disables dual stack mode. Used with uv_udp_bind6().
  # :uv_udp_partial ::
  #   Indicates message was truncated because read buffer was too small. The
  #   remainder was discarded by the OS. Used in uv_udp_recv_cb.
  #
  # @method `enum_udp_flags`
  # @return [Symbol]
  # @scope class
  #
  enum :udp_flags, [
    :uv_udp_ipv6only, 1,
    :uv_udp_partial, 2
  ]

  # (Not documented)
  #
  # ## Options:
  # :uv_readable ::
  #
  # :uv_writable ::
  #
  #
  # @method `enum_poll_event`
  # @return [Symbol]
  # @scope class
  #
  enum :poll_event, [
    :uv_readable, 1,
    :uv_writable, 2
  ]

  # uv_spawn() options
  #
  # ## Options:
  # :uv_ignore ::
  #
  # :uv_create_pipe ::
  #
  # :uv_inherit_fd ::
  #
  # :uv_inherit_stream ::
  #
  # :uv_readable_pipe ::
  #   When UV_CREATE_PIPE is specified, UV_READABLE_PIPE and UV_WRITABLE_PIPE
  #   determine the direction of flow, from the child process' perspective. Both
  #   flags may be specified to create a duplex data stream.
  # :uv_writable_pipe ::
  #
  #
  # @method `enum_stdio_flags`
  # @return [Symbol]
  # @scope class
  #
  enum :stdio_flags, [
    :uv_ignore, 0,
    :uv_create_pipe, 1,
    :uv_inherit_fd, 2,
    :uv_inherit_stream, 4,
    :uv_readable_pipe, 16,
    :uv_writable_pipe, 32
  ]

  # File System Methods.
  #
  # The uv_fs_* functions execute a blocking system call asynchronously (in a
  # thread pool) and call the specified callback in the specified loop after
  # completion. If the user gives NULL as the callback the blocking system
  # call will be called synchronously. req should be a pointer to an
  # uninitialized uv_fs_t object.
  #
  # uv_fs_req_cleanup() must be called after completion of the uv_fs_
  # function to free any internal memory allocations associated with the
  # request.
  #
  # ## Options:
  # :uv_fs_unknown ::
  #
  # :uv_fs_custom ::
  #
  # :uv_fs_open ::
  #
  # :uv_fs_close ::
  #
  # :uv_fs_read ::
  #
  # :uv_fs_write ::
  #
  # :uv_fs_sendfile ::
  #
  # :uv_fs_stat ::
  #
  # :uv_fs_lstat ::
  #
  # :uv_fs_fstat ::
  #
  # :uv_fs_ftruncate ::
  #
  # :uv_fs_utime ::
  #
  # :uv_fs_futime ::
  #
  # :uv_fs_chmod ::
  #
  # :uv_fs_fchmod ::
  #
  # :uv_fs_fsync ::
  #
  # :uv_fs_fdatasync ::
  #
  # :uv_fs_unlink ::
  #
  # :uv_fs_rmdir ::
  #
  # :uv_fs_mkdir ::
  #
  # :uv_fs_rename ::
  #
  # :uv_fs_readdir ::
  #
  # :uv_fs_link ::
  #
  # :uv_fs_symlink ::
  #
  # :uv_fs_readlink ::
  #
  # :uv_fs_chown ::
  #
  # :uv_fs_fchown ::
  #
  #
  # @method `enum_fs_type`
  # @return [Symbol]
  # @scope class
  #
  enum :fs_type, [
    :uv_fs_unknown, -1,
    :uv_fs_custom, 0,
    :uv_fs_open, 1,
    :uv_fs_close, 2,
    :uv_fs_read, 3,
    :uv_fs_write, 4,
    :uv_fs_sendfile, 5,
    :uv_fs_stat, 6,
    :uv_fs_lstat, 7,
    :uv_fs_fstat, 8,
    :uv_fs_ftruncate, 9,
    :uv_fs_utime, 10,
    :uv_fs_futime, 11,
    :uv_fs_chmod, 12,
    :uv_fs_fchmod, 13,
    :uv_fs_fsync, 14,
    :uv_fs_fdatasync, 15,
    :uv_fs_unlink, 16,
    :uv_fs_rmdir, 17,
    :uv_fs_mkdir, 18,
    :uv_fs_rename, 19,
    :uv_fs_readdir, 20,
    :uv_fs_link, 21,
    :uv_fs_symlink, 22,
    :uv_fs_readlink, 23,
    :uv_fs_chown, 24,
    :uv_fs_fchown, 25
  ]

  # (Not documented)
  #
  # ## Options:
  # :uv_rename ::
  #
  # :uv_change ::
  #
  #
  # @method `enum_fs_event`
  # @return [Symbol]
  # @scope class
  #
  enum :fs_event, [
    :uv_rename, 1,
    :uv_change, 2
  ]

  # Flags to be passed to uv_fs_event_init.
  #
  # ## Options:
  # :uv_fs_event_watch_entry ::
  #   By default, if the fs event watcher is given a directory name, we will
  #   watch for all events in that directory. This flags overrides this behavior
  #   and makes fs_event report only changes to the directory entry itself. This
  #   flag does not affect individual files watched.
  #   This flag is currently not implemented yet on any backend.
  # :uv_fs_event_stat ::
  #   By default uv_fs_event will try to use a kernel interface such as inotify
  #   or kqueue to detect events. This may not work on remote filesystems such
  #   as NFS mounts. This flag makes fs_event fall back to calling stat() on a
  #   regular interval.
  #   This flag is currently not implemented yet on any backend.
  # :uv_fs_event_recursive ::
  #   By default, event watcher, when watching directory, is not registering
  #   (is ignoring) changes in it's subdirectories.
  #   This flag will override this behaviour on platforms that support it.
  #
  # @method `enum_fs_event_flags`
  # @return [Symbol]
  # @scope class
  #
  enum :fs_event_flags, [
    :uv_fs_event_watch_entry, 1,
    :uv_fs_event_stat, 2,
    :uv_fs_event_recursive, 3
  ]

  # (Not documented)
  #
  # ## Options:
  # :uv_unknown_handle ::
  #
  # :uv_async ::
  #
  # :uv_check ::
  #
  # :uv_fs_event ::
  #
  # :uv_fs_poll ::
  #
  # :uv_handle ::
  #
  # :uv_idle ::
  #
  # :uv_named_pipe ::
  #
  # :uv_poll ::
  #
  # :uv_prepare ::
  #
  # :uv_process ::
  #
  # :uv_stream ::
  #
  # :uv_tcp ::
  #
  # :uv_timer ::
  #
  # :uv_tty ::
  #
  # :uv_udp ::
  #
  # :uv_signal ::
  #
  # :uv_file ::
  #
  # :uv_handle_type_max ::
  #
  #
  # @method `enum_handle_type`
  # @return [Symbol]
  # @scope class
  #
  enum :handle_type, [
    :uv_unknown_handle, 0,
    :uv_async, 1,
    :uv_check, 2,
    :uv_fs_event, 3,
    :uv_fs_poll, 4,
    :uv_handle, 5,
    :uv_idle, 6,
    :uv_named_pipe, 7,
    :uv_poll, 8,
    :uv_prepare, 9,
    :uv_process, 10,
    :uv_stream, 11,
    :uv_tcp, 12,
    :uv_timer, 13,
    :uv_tty, 14,
    :uv_udp, 15,
    :uv_signal, 16,
    :uv_file, 17,
    :uv_handle_type_max, 18
  ]

  # These are the flags that can be used for the uv_process_options.flags field.
  #
  # ## Options:
  # :uv_process_setuid ::
  #   Set the child process' user id. The user id is supplied in the `uid` field
  #   of the options struct. This does not work on windows; setting this flag
  #   will cause uv_spawn() to fail.
  # :uv_process_setgid ::
  #   Set the child process' group id. The user id is supplied in the `gid`
  #   field of the options struct. This does not work on windows; setting this
  #   flag will cause uv_spawn() to fail.
  # :uv_process_windows_verbatim_arguments ::
  #   Do not wrap any arguments in quotes, or perform any other escaping, when
  #   converting the argument list into a command line string. This option is
  #   only meaningful on Windows systems. On unix it is silently ignored.
  # :uv_process_detached ::
  #   Spawn the child process in a detached state - this will make it a process
  #   group leader, and will effectively enable the child to keep running after
  #   the parent exits.  Note that the child process will still keep the
  #   parent's event loop alive unless the parent process calls uv_unref() on
  #   the child's process handle.
  # :uv_process_windows_hide ::
  #   Hide the subprocess console window that would normally be created. This
  #   option is only meaningful on Windows systems. On unix it is silently
  #   ignored.
  #
  # @method `enum_process_flags`
  # @return [Symbol]
  # @scope class
  #
  enum :process_flags, [
    :uv_process_setuid, 1,
    :uv_process_setgid, 2,
    :uv_process_windows_verbatim_arguments, 4,
    :uv_process_detached, 8,
    :uv_process_windows_hide, 16
  ]

  # (Not documented)
  #
  # ## Options:
  # :uv_run_default ::
  #
  # :uv_run_once ::
  #
  # :uv_run_nowait ::
  #
  #
  # @method `enum_run_mode`
  # @return [Symbol]
  # @scope class
  #
  enum :run_mode, [
    :uv_run_default, 0,
    :uv_run_once, 1,
    :uv_run_nowait, 2
  ]

end
