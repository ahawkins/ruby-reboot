module SystemHelpers
  # Provide sys instead of system. System is a kernel method for making
  # system calls. There's no need to clobber that globally.
  def sys
    SYSTEM
  end
end

World SystemHelpers
