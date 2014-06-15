module UV
  # (Not documented)
  #
  # ## Fields:
  # :exit_cb ::
  #   (Proc(callback_exit_cb)) Called after the process exits.
  # :file ::
  #   (String) Path to program to execute.
  # :args ::
  #   (FFI::Pointer(**CharS)) Command line arguments. args(0) should be the path to the program. On
  #   Windows this uses CreateProcess which concatenates the arguments into a
  #   string this can cause some strange errors. See the note at
  #   windows_verbatim_arguments.
  # :env ::
  #   (FFI::Pointer(**CharS)) This will be set as the environ variable in the subprocess. If this is
  #   NULL then the parents environ will be used.
  # :cwd ::
  #   (String) If non-null this represents a directory the subprocess should execute
  #   in. Stands for current working directory.
  # :flags ::
  #   (Integer) Various flags that control how uv_spawn() behaves. See the definition of
  #   `enum uv_process_flags` below.
  # :stdio_count ::
  #   (Integer) The `stdio` field points to an array of uv_stdio_container_t structs that
  #   describe the file descriptors that will be made available to the child
  #   process. The convention is that stdio(0) points to stdin, fd 1 is used for
  #   stdout, and fd 2 is stderr.
  #
  #   Note that on windows file descriptors greater than 2 are available to the
  #   child process only if the child processes uses the MSVCRT runtime.
  # :stdio ::
  #   (StdioContainer)
  # :uid ::
  #   (Integer) Libuv can change the child process' user/group id. This happens only when
  #   the appropriate bits are set in the flags fields. This is not supported on
  #   windows; uv_spawn() will fail and set the error to UV_ENOTSUP.
  # :gid ::
  #   (Integer)
  class ProcessOptions < FFI::Struct
    layout :exit_cb, :exit_cb,
           :file, :string,
           :args, :pointer,
           :env, :pointer,
           :cwd, :string,
           :flags, :uint,
           :stdio_count, :int,
           :stdio, StdioContainer,
           :uid, :uint,
           :gid, :uint
  end

end
