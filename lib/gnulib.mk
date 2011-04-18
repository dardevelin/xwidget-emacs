## DO NOT EDIT! GENERATED AUTOMATICALLY!
## Process this file with automake to produce Makefile.in.
# Copyright (C) 2002-2011 Free Software Foundation, Inc.
#
# This file is free software, distributed under the terms of the GNU
# General Public License.  As a special exception to the GNU General
# Public License, this file may be distributed as part of a program
# that contains a configuration script generated by Autoconf, under
# the same distribution terms as the rest of that program.
#
# Generated by gnulib-tool.
# Reproduce by: gnulib-tool --import --dir=. --lib=libgnu --source-base=lib --m4-base=m4 --doc-base=doc --tests-base=tests --aux-dir=. --makefile-name=gnulib.mk --no-libtool --macro-prefix=gl --no-vc-files careadlinkat crypto/md5 dtoastr filemode getloadavg getopt-gnu ignore-value intprops lstat mktime readlink socklen stdio strftime symlink sys_stat


MOSTLYCLEANFILES += core *.stackdump

noinst_LIBRARIES += libgnu.a

libgnu_a_SOURCES =
libgnu_a_LIBADD = $(gl_LIBOBJS)
libgnu_a_DEPENDENCIES = $(gl_LIBOBJS)
EXTRA_libgnu_a_SOURCES =

## begin gnulib module allocator

libgnu_a_SOURCES += allocator.c

EXTRA_DIST += allocator.h

## end   gnulib module allocator

## begin gnulib module arg-nonnull

# The BUILT_SOURCES created by this Makefile snippet are not used via #include
# statements but through direct file reference. Therefore this snippet must be
# present in all Makefile.am that need it. This is ensured by the applicability
# 'all' defined above.

BUILT_SOURCES += arg-nonnull.h
# The arg-nonnull.h that gets inserted into generated .h files is the same as
# build-aux/arg-nonnull.h, except that it has the copyright header cut off.
arg-nonnull.h: $(top_srcdir)/./arg-nonnull.h
	$(AM_V_GEN)rm -f $@-t $@ && \
	sed -n -e '/GL_ARG_NONNULL/,$$p' \
	  < $(top_srcdir)/./arg-nonnull.h \
	  > $@-t && \
	mv $@-t $@
MOSTLYCLEANFILES += arg-nonnull.h arg-nonnull.h-t

ARG_NONNULL_H=arg-nonnull.h

EXTRA_DIST += $(top_srcdir)/./arg-nonnull.h

## end   gnulib module arg-nonnull

## begin gnulib module c++defs

# The BUILT_SOURCES created by this Makefile snippet are not used via #include
# statements but through direct file reference. Therefore this snippet must be
# present in all Makefile.am that need it. This is ensured by the applicability
# 'all' defined above.

BUILT_SOURCES += c++defs.h
# The c++defs.h that gets inserted into generated .h files is the same as
# build-aux/c++defs.h, except that it has the copyright header cut off.
c++defs.h: $(top_srcdir)/./c++defs.h
	$(AM_V_GEN)rm -f $@-t $@ && \
	sed -n -e '/_GL_CXXDEFS/,$$p' \
	  < $(top_srcdir)/./c++defs.h \
	  > $@-t && \
	mv $@-t $@
MOSTLYCLEANFILES += c++defs.h c++defs.h-t

CXXDEFS_H=c++defs.h

EXTRA_DIST += $(top_srcdir)/./c++defs.h

## end   gnulib module c++defs

## begin gnulib module careadlinkat

libgnu_a_SOURCES += careadlinkat.c

EXTRA_DIST += careadlinkat.h

## end   gnulib module careadlinkat

## begin gnulib module crypto/md5


EXTRA_DIST += md5.c md5.h

EXTRA_libgnu_a_SOURCES += md5.c

## end   gnulib module crypto/md5

## begin gnulib module dosname


EXTRA_DIST += dosname.h

## end   gnulib module dosname

## begin gnulib module dtoastr

libgnu_a_SOURCES += dtoastr.c

EXTRA_DIST += ftoastr.c ftoastr.h

EXTRA_libgnu_a_SOURCES += ftoastr.c

## end   gnulib module dtoastr

## begin gnulib module filemode


EXTRA_DIST += filemode.c filemode.h

EXTRA_libgnu_a_SOURCES += filemode.c

## end   gnulib module filemode

## begin gnulib module getloadavg


EXTRA_DIST += getloadavg.c

EXTRA_libgnu_a_SOURCES += getloadavg.c

## end   gnulib module getloadavg

## begin gnulib module getopt-posix

BUILT_SOURCES += $(GETOPT_H)

# We need the following in order to create <getopt.h> when the system
# doesn't have one that works with the given compiler.
getopt.h: getopt.in.h $(top_builddir)/config.status $(ARG_NONNULL_H)
	$(AM_V_GEN)rm -f $@-t $@ && \
	{ echo '/* DO NOT EDIT! GENERATED AUTOMATICALLY! */'; \
	  sed -e 's|@''HAVE_GETOPT_H''@|$(HAVE_GETOPT_H)|g' \
	      -e 's|@''INCLUDE_NEXT''@|$(INCLUDE_NEXT)|g' \
	      -e 's|@''PRAGMA_SYSTEM_HEADER''@|@PRAGMA_SYSTEM_HEADER@|g' \
	      -e 's|@''PRAGMA_COLUMNS''@|@PRAGMA_COLUMNS@|g' \
	      -e 's|@''NEXT_GETOPT_H''@|$(NEXT_GETOPT_H)|g' \
	      -e '/definition of _GL_ARG_NONNULL/r $(ARG_NONNULL_H)' \
	      < $(srcdir)/getopt.in.h; \
	} > $@-t && \
	mv -f $@-t $@
MOSTLYCLEANFILES += getopt.h getopt.h-t

EXTRA_DIST += getopt.c getopt.in.h getopt1.c getopt_int.h

EXTRA_libgnu_a_SOURCES += getopt.c getopt1.c

## end   gnulib module getopt-posix

## begin gnulib module gettext-h

libgnu_a_SOURCES += gettext.h

## end   gnulib module gettext-h

## begin gnulib module ignore-value

libgnu_a_SOURCES += ignore-value.h

## end   gnulib module ignore-value

## begin gnulib module intprops


EXTRA_DIST += intprops.h

## end   gnulib module intprops

## begin gnulib module lstat


EXTRA_DIST += lstat.c

EXTRA_libgnu_a_SOURCES += lstat.c

## end   gnulib module lstat

## begin gnulib module mktime


EXTRA_DIST += mktime-internal.h mktime.c

EXTRA_libgnu_a_SOURCES += mktime.c

## end   gnulib module mktime

## begin gnulib module readlink


EXTRA_DIST += readlink.c

EXTRA_libgnu_a_SOURCES += readlink.c

## end   gnulib module readlink

## begin gnulib module stat


EXTRA_DIST += stat.c

EXTRA_libgnu_a_SOURCES += stat.c

## end   gnulib module stat

## begin gnulib module stdbool

BUILT_SOURCES += $(STDBOOL_H)

# We need the following in order to create <stdbool.h> when the system
# doesn't have one that works.
if GL_GENERATE_STDBOOL_H
stdbool.h: stdbool.in.h $(top_builddir)/config.status
	$(AM_V_GEN)rm -f $@-t $@ && \
	{ echo '/* DO NOT EDIT! GENERATED AUTOMATICALLY! */'; \
	  sed -e 's/@''HAVE__BOOL''@/$(HAVE__BOOL)/g' < $(srcdir)/stdbool.in.h; \
	} > $@-t && \
	mv $@-t $@
else
stdbool.h: $(top_builddir)/config.status
	rm -f $@
endif
MOSTLYCLEANFILES += stdbool.h stdbool.h-t

EXTRA_DIST += stdbool.in.h

## end   gnulib module stdbool

## begin gnulib module stddef

BUILT_SOURCES += $(STDDEF_H)

# We need the following in order to create <stddef.h> when the system
# doesn't have one that works with the given compiler.
if GL_GENERATE_STDDEF_H
stddef.h: stddef.in.h $(top_builddir)/config.status
	$(AM_V_GEN)rm -f $@-t $@ && \
	{ echo '/* DO NOT EDIT! GENERATED AUTOMATICALLY! */' && \
	  sed -e 's|@''INCLUDE_NEXT''@|$(INCLUDE_NEXT)|g' \
	      -e 's|@''PRAGMA_SYSTEM_HEADER''@|@PRAGMA_SYSTEM_HEADER@|g' \
	      -e 's|@''PRAGMA_COLUMNS''@|@PRAGMA_COLUMNS@|g' \
	      -e 's|@''NEXT_STDDEF_H''@|$(NEXT_STDDEF_H)|g' \
	      -e 's|@''HAVE_WCHAR_T''@|$(HAVE_WCHAR_T)|g' \
	      -e 's|@''REPLACE_NULL''@|$(REPLACE_NULL)|g' \
	      < $(srcdir)/stddef.in.h; \
	} > $@-t && \
	mv $@-t $@
else
stddef.h: $(top_builddir)/config.status
	rm -f $@
endif
MOSTLYCLEANFILES += stddef.h stddef.h-t

EXTRA_DIST += stddef.in.h

## end   gnulib module stddef

## begin gnulib module stdint

BUILT_SOURCES += $(STDINT_H)

# We need the following in order to create <stdint.h> when the system
# doesn't have one that works with the given compiler.
if GL_GENERATE_STDINT_H
stdint.h: stdint.in.h $(top_builddir)/config.status
	$(AM_V_GEN)rm -f $@-t $@ && \
	{ echo '/* DO NOT EDIT! GENERATED AUTOMATICALLY! */'; \
	  sed -e 's/@''HAVE_STDINT_H''@/$(HAVE_STDINT_H)/g' \
	      -e 's|@''INCLUDE_NEXT''@|$(INCLUDE_NEXT)|g' \
	      -e 's|@''PRAGMA_SYSTEM_HEADER''@|@PRAGMA_SYSTEM_HEADER@|g' \
	      -e 's|@''PRAGMA_COLUMNS''@|@PRAGMA_COLUMNS@|g' \
	      -e 's|@''NEXT_STDINT_H''@|$(NEXT_STDINT_H)|g' \
	      -e 's/@''HAVE_SYS_TYPES_H''@/$(HAVE_SYS_TYPES_H)/g' \
	      -e 's/@''HAVE_INTTYPES_H''@/$(HAVE_INTTYPES_H)/g' \
	      -e 's/@''HAVE_SYS_INTTYPES_H''@/$(HAVE_SYS_INTTYPES_H)/g' \
	      -e 's/@''HAVE_SYS_BITYPES_H''@/$(HAVE_SYS_BITYPES_H)/g' \
	      -e 's/@''HAVE_WCHAR_H''@/$(HAVE_WCHAR_H)/g' \
	      -e 's/@''HAVE_LONG_LONG_INT''@/$(HAVE_LONG_LONG_INT)/g' \
	      -e 's/@''HAVE_UNSIGNED_LONG_LONG_INT''@/$(HAVE_UNSIGNED_LONG_LONG_INT)/g' \
	      -e 's/@''APPLE_UNIVERSAL_BUILD''@/$(APPLE_UNIVERSAL_BUILD)/g' \
	      -e 's/@''BITSIZEOF_PTRDIFF_T''@/$(BITSIZEOF_PTRDIFF_T)/g' \
	      -e 's/@''PTRDIFF_T_SUFFIX''@/$(PTRDIFF_T_SUFFIX)/g' \
	      -e 's/@''BITSIZEOF_SIG_ATOMIC_T''@/$(BITSIZEOF_SIG_ATOMIC_T)/g' \
	      -e 's/@''HAVE_SIGNED_SIG_ATOMIC_T''@/$(HAVE_SIGNED_SIG_ATOMIC_T)/g' \
	      -e 's/@''SIG_ATOMIC_T_SUFFIX''@/$(SIG_ATOMIC_T_SUFFIX)/g' \
	      -e 's/@''BITSIZEOF_SIZE_T''@/$(BITSIZEOF_SIZE_T)/g' \
	      -e 's/@''SIZE_T_SUFFIX''@/$(SIZE_T_SUFFIX)/g' \
	      -e 's/@''BITSIZEOF_WCHAR_T''@/$(BITSIZEOF_WCHAR_T)/g' \
	      -e 's/@''HAVE_SIGNED_WCHAR_T''@/$(HAVE_SIGNED_WCHAR_T)/g' \
	      -e 's/@''WCHAR_T_SUFFIX''@/$(WCHAR_T_SUFFIX)/g' \
	      -e 's/@''BITSIZEOF_WINT_T''@/$(BITSIZEOF_WINT_T)/g' \
	      -e 's/@''HAVE_SIGNED_WINT_T''@/$(HAVE_SIGNED_WINT_T)/g' \
	      -e 's/@''WINT_T_SUFFIX''@/$(WINT_T_SUFFIX)/g' \
	      < $(srcdir)/stdint.in.h; \
	} > $@-t && \
	mv $@-t $@
else
stdint.h: $(top_builddir)/config.status
	rm -f $@
endif
MOSTLYCLEANFILES += stdint.h stdint.h-t

EXTRA_DIST += stdint.in.h

## end   gnulib module stdint

## begin gnulib module stdio

BUILT_SOURCES += stdio.h

# We need the following in order to create <stdio.h> when the system
# doesn't have one that works with the given compiler.
stdio.h: stdio.in.h $(top_builddir)/config.status $(CXXDEFS_H) $(ARG_NONNULL_H) $(WARN_ON_USE_H)
	$(AM_V_GEN)rm -f $@-t $@ && \
	{ echo '/* DO NOT EDIT! GENERATED AUTOMATICALLY! */' && \
	  sed -e 's|@''INCLUDE_NEXT''@|$(INCLUDE_NEXT)|g' \
	      -e 's|@''PRAGMA_SYSTEM_HEADER''@|@PRAGMA_SYSTEM_HEADER@|g' \
	      -e 's|@''PRAGMA_COLUMNS''@|@PRAGMA_COLUMNS@|g' \
	      -e 's|@''NEXT_STDIO_H''@|$(NEXT_STDIO_H)|g' \
	      -e 's|@''GNULIB_DPRINTF''@|$(GNULIB_DPRINTF)|g' \
	      -e 's|@''GNULIB_FCLOSE''@|$(GNULIB_FCLOSE)|g' \
	      -e 's|@''GNULIB_FFLUSH''@|$(GNULIB_FFLUSH)|g' \
	      -e 's|@''GNULIB_FGETC''@|$(GNULIB_FGETC)|g' \
	      -e 's|@''GNULIB_FGETS''@|$(GNULIB_FGETS)|g' \
	      -e 's|@''GNULIB_FOPEN''@|$(GNULIB_FOPEN)|g' \
	      -e 's|@''GNULIB_FPRINTF''@|$(GNULIB_FPRINTF)|g' \
	      -e 's|@''GNULIB_FPRINTF_POSIX''@|$(GNULIB_FPRINTF_POSIX)|g' \
	      -e 's|@''GNULIB_FPURGE''@|$(GNULIB_FPURGE)|g' \
	      -e 's|@''GNULIB_FPUTC''@|$(GNULIB_FPUTC)|g' \
	      -e 's|@''GNULIB_FPUTS''@|$(GNULIB_FPUTS)|g' \
	      -e 's|@''GNULIB_FREAD''@|$(GNULIB_FREAD)|g' \
	      -e 's|@''GNULIB_FREOPEN''@|$(GNULIB_FREOPEN)|g' \
	      -e 's|@''GNULIB_FSCANF''@|$(GNULIB_FSCANF)|g' \
	      -e 's|@''GNULIB_FSEEK''@|$(GNULIB_FSEEK)|g' \
	      -e 's|@''GNULIB_FSEEKO''@|$(GNULIB_FSEEKO)|g' \
	      -e 's|@''GNULIB_FTELL''@|$(GNULIB_FTELL)|g' \
	      -e 's|@''GNULIB_FTELLO''@|$(GNULIB_FTELLO)|g' \
	      -e 's|@''GNULIB_FWRITE''@|$(GNULIB_FWRITE)|g' \
	      -e 's|@''GNULIB_GETC''@|$(GNULIB_GETC)|g' \
	      -e 's|@''GNULIB_GETCHAR''@|$(GNULIB_GETCHAR)|g' \
	      -e 's|@''GNULIB_GETDELIM''@|$(GNULIB_GETDELIM)|g' \
	      -e 's|@''GNULIB_GETLINE''@|$(GNULIB_GETLINE)|g' \
	      -e 's|@''GNULIB_GETS''@|$(GNULIB_GETS)|g' \
	      -e 's|@''GNULIB_OBSTACK_PRINTF''@|$(GNULIB_OBSTACK_PRINTF)|g' \
	      -e 's|@''GNULIB_OBSTACK_PRINTF_POSIX''@|$(GNULIB_OBSTACK_PRINTF_POSIX)|g' \
	      -e 's|@''GNULIB_PERROR''@|$(GNULIB_PERROR)|g' \
	      -e 's|@''GNULIB_POPEN''@|$(GNULIB_POPEN)|g' \
	      -e 's|@''GNULIB_PRINTF''@|$(GNULIB_PRINTF)|g' \
	      -e 's|@''GNULIB_PRINTF_POSIX''@|$(GNULIB_PRINTF_POSIX)|g' \
	      -e 's|@''GNULIB_PUTC''@|$(GNULIB_PUTC)|g' \
	      -e 's|@''GNULIB_PUTCHAR''@|$(GNULIB_PUTCHAR)|g' \
	      -e 's|@''GNULIB_PUTS''@|$(GNULIB_PUTS)|g' \
	      -e 's|@''GNULIB_REMOVE''@|$(GNULIB_REMOVE)|g' \
	      -e 's|@''GNULIB_RENAME''@|$(GNULIB_RENAME)|g' \
	      -e 's|@''GNULIB_RENAMEAT''@|$(GNULIB_RENAMEAT)|g' \
	      -e 's|@''GNULIB_SCANF''@|$(GNULIB_SCANF)|g' \
	      -e 's|@''GNULIB_SNPRINTF''@|$(GNULIB_SNPRINTF)|g' \
	      -e 's|@''GNULIB_SPRINTF_POSIX''@|$(GNULIB_SPRINTF_POSIX)|g' \
	      -e 's|@''GNULIB_STDIO_H_NONBLOCKING''@|$(GNULIB_STDIO_H_NONBLOCKING)|g' \
	      -e 's|@''GNULIB_STDIO_H_SIGPIPE''@|$(GNULIB_STDIO_H_SIGPIPE)|g' \
	      -e 's|@''GNULIB_TMPFILE''@|$(GNULIB_TMPFILE)|g' \
	      -e 's|@''GNULIB_VASPRINTF''@|$(GNULIB_VASPRINTF)|g' \
	      -e 's|@''GNULIB_VDPRINTF''@|$(GNULIB_VDPRINTF)|g' \
	      -e 's|@''GNULIB_VFPRINTF''@|$(GNULIB_VFPRINTF)|g' \
	      -e 's|@''GNULIB_VFPRINTF_POSIX''@|$(GNULIB_VFPRINTF_POSIX)|g' \
	      -e 's|@''GNULIB_VFSCANF''@|$(GNULIB_VFSCANF)|g' \
	      -e 's|@''GNULIB_VSCANF''@|$(GNULIB_VSCANF)|g' \
	      -e 's|@''GNULIB_VPRINTF''@|$(GNULIB_VPRINTF)|g' \
	      -e 's|@''GNULIB_VPRINTF_POSIX''@|$(GNULIB_VPRINTF_POSIX)|g' \
	      -e 's|@''GNULIB_VSNPRINTF''@|$(GNULIB_VSNPRINTF)|g' \
	      -e 's|@''GNULIB_VSPRINTF_POSIX''@|$(GNULIB_VSPRINTF_POSIX)|g' \
	      < $(srcdir)/stdio.in.h | \
	  sed -e 's|@''HAVE_DECL_FPURGE''@|$(HAVE_DECL_FPURGE)|g' \
	      -e 's|@''HAVE_DECL_FSEEKO''@|$(HAVE_DECL_FSEEKO)|g' \
	      -e 's|@''HAVE_DECL_FTELLO''@|$(HAVE_DECL_FTELLO)|g' \
	      -e 's|@''HAVE_DECL_GETDELIM''@|$(HAVE_DECL_GETDELIM)|g' \
	      -e 's|@''HAVE_DECL_GETLINE''@|$(HAVE_DECL_GETLINE)|g' \
	      -e 's|@''HAVE_DECL_OBSTACK_PRINTF''@|$(HAVE_DECL_OBSTACK_PRINTF)|g' \
	      -e 's|@''HAVE_DECL_SNPRINTF''@|$(HAVE_DECL_SNPRINTF)|g' \
	      -e 's|@''HAVE_DECL_VSNPRINTF''@|$(HAVE_DECL_VSNPRINTF)|g' \
	      -e 's|@''HAVE_DPRINTF''@|$(HAVE_DPRINTF)|g' \
	      -e 's|@''HAVE_FSEEKO''@|$(HAVE_FSEEKO)|g' \
	      -e 's|@''HAVE_FTELLO''@|$(HAVE_FTELLO)|g' \
	      -e 's|@''HAVE_RENAMEAT''@|$(HAVE_RENAMEAT)|g' \
	      -e 's|@''HAVE_VASPRINTF''@|$(HAVE_VASPRINTF)|g' \
	      -e 's|@''HAVE_VDPRINTF''@|$(HAVE_VDPRINTF)|g' \
	      -e 's|@''REPLACE_DPRINTF''@|$(REPLACE_DPRINTF)|g' \
	      -e 's|@''REPLACE_FCLOSE''@|$(REPLACE_FCLOSE)|g' \
	      -e 's|@''REPLACE_FFLUSH''@|$(REPLACE_FFLUSH)|g' \
	      -e 's|@''REPLACE_FOPEN''@|$(REPLACE_FOPEN)|g' \
	      -e 's|@''REPLACE_FPRINTF''@|$(REPLACE_FPRINTF)|g' \
	      -e 's|@''REPLACE_FPURGE''@|$(REPLACE_FPURGE)|g' \
	      -e 's|@''REPLACE_FREOPEN''@|$(REPLACE_FREOPEN)|g' \
	      -e 's|@''REPLACE_FSEEK''@|$(REPLACE_FSEEK)|g' \
	      -e 's|@''REPLACE_FSEEKO''@|$(REPLACE_FSEEKO)|g' \
	      -e 's|@''REPLACE_FTELL''@|$(REPLACE_FTELL)|g' \
	      -e 's|@''REPLACE_FTELLO''@|$(REPLACE_FTELLO)|g' \
	      -e 's|@''REPLACE_GETDELIM''@|$(REPLACE_GETDELIM)|g' \
	      -e 's|@''REPLACE_GETLINE''@|$(REPLACE_GETLINE)|g' \
	      -e 's|@''REPLACE_OBSTACK_PRINTF''@|$(REPLACE_OBSTACK_PRINTF)|g' \
	      -e 's|@''REPLACE_PERROR''@|$(REPLACE_PERROR)|g' \
	      -e 's|@''REPLACE_POPEN''@|$(REPLACE_POPEN)|g' \
	      -e 's|@''REPLACE_PRINTF''@|$(REPLACE_PRINTF)|g' \
	      -e 's|@''REPLACE_REMOVE''@|$(REPLACE_REMOVE)|g' \
	      -e 's|@''REPLACE_RENAME''@|$(REPLACE_RENAME)|g' \
	      -e 's|@''REPLACE_RENAMEAT''@|$(REPLACE_RENAMEAT)|g' \
	      -e 's|@''REPLACE_SNPRINTF''@|$(REPLACE_SNPRINTF)|g' \
	      -e 's|@''REPLACE_SPRINTF''@|$(REPLACE_SPRINTF)|g' \
	      -e 's|@''REPLACE_STDIO_READ_FUNCS''@|$(REPLACE_STDIO_READ_FUNCS)|g' \
	      -e 's|@''REPLACE_STDIO_WRITE_FUNCS''@|$(REPLACE_STDIO_WRITE_FUNCS)|g' \
	      -e 's|@''REPLACE_TMPFILE''@|$(REPLACE_TMPFILE)|g' \
	      -e 's|@''REPLACE_VASPRINTF''@|$(REPLACE_VASPRINTF)|g' \
	      -e 's|@''REPLACE_VDPRINTF''@|$(REPLACE_VDPRINTF)|g' \
	      -e 's|@''REPLACE_VFPRINTF''@|$(REPLACE_VFPRINTF)|g' \
	      -e 's|@''REPLACE_VPRINTF''@|$(REPLACE_VPRINTF)|g' \
	      -e 's|@''REPLACE_VSNPRINTF''@|$(REPLACE_VSNPRINTF)|g' \
	      -e 's|@''REPLACE_VSPRINTF''@|$(REPLACE_VSPRINTF)|g' \
	      -e 's|@''ASM_SYMBOL_PREFIX''@|$(ASM_SYMBOL_PREFIX)|g' \
	      -e '/definitions of _GL_FUNCDECL_RPL/r $(CXXDEFS_H)' \
	      -e '/definition of _GL_ARG_NONNULL/r $(ARG_NONNULL_H)' \
	      -e '/definition of _GL_WARN_ON_USE/r $(WARN_ON_USE_H)'; \
	} > $@-t && \
	mv $@-t $@
MOSTLYCLEANFILES += stdio.h stdio.h-t

EXTRA_DIST += stdio.in.h

## end   gnulib module stdio

## begin gnulib module stdlib

BUILT_SOURCES += stdlib.h

# We need the following in order to create <stdlib.h> when the system
# doesn't have one that works with the given compiler.
stdlib.h: stdlib.in.h $(top_builddir)/config.status $(CXXDEFS_H) $(ARG_NONNULL_H) $(WARN_ON_USE_H)
	$(AM_V_GEN)rm -f $@-t $@ && \
	{ echo '/* DO NOT EDIT! GENERATED AUTOMATICALLY! */' && \
	  sed -e 's|@''INCLUDE_NEXT''@|$(INCLUDE_NEXT)|g' \
	      -e 's|@''PRAGMA_SYSTEM_HEADER''@|@PRAGMA_SYSTEM_HEADER@|g' \
	      -e 's|@''PRAGMA_COLUMNS''@|@PRAGMA_COLUMNS@|g' \
	      -e 's|@''NEXT_STDLIB_H''@|$(NEXT_STDLIB_H)|g' \
	      -e 's|@''GNULIB__EXIT''@|$(GNULIB__EXIT)|g' \
	      -e 's|@''GNULIB_ATOLL''@|$(GNULIB_ATOLL)|g' \
	      -e 's|@''GNULIB_CALLOC_POSIX''@|$(GNULIB_CALLOC_POSIX)|g' \
	      -e 's|@''GNULIB_CANONICALIZE_FILE_NAME''@|$(GNULIB_CANONICALIZE_FILE_NAME)|g' \
	      -e 's|@''GNULIB_GETLOADAVG''@|$(GNULIB_GETLOADAVG)|g' \
	      -e 's|@''GNULIB_GETSUBOPT''@|$(GNULIB_GETSUBOPT)|g' \
	      -e 's|@''GNULIB_GRANTPT''@|$(GNULIB_GRANTPT)|g' \
	      -e 's|@''GNULIB_MALLOC_POSIX''@|$(GNULIB_MALLOC_POSIX)|g' \
	      -e 's|@''GNULIB_MBTOWC''@|$(GNULIB_MBTOWC)|g' \
	      -e 's|@''GNULIB_MKDTEMP''@|$(GNULIB_MKDTEMP)|g' \
	      -e 's|@''GNULIB_MKOSTEMP''@|$(GNULIB_MKOSTEMP)|g' \
	      -e 's|@''GNULIB_MKOSTEMPS''@|$(GNULIB_MKOSTEMPS)|g' \
	      -e 's|@''GNULIB_MKSTEMP''@|$(GNULIB_MKSTEMP)|g' \
	      -e 's|@''GNULIB_MKSTEMPS''@|$(GNULIB_MKSTEMPS)|g' \
	      -e 's|@''GNULIB_PTSNAME''@|$(GNULIB_PTSNAME)|g' \
	      -e 's|@''GNULIB_PUTENV''@|$(GNULIB_PUTENV)|g' \
	      -e 's|@''GNULIB_RANDOM_R''@|$(GNULIB_RANDOM_R)|g' \
	      -e 's|@''GNULIB_REALLOC_POSIX''@|$(GNULIB_REALLOC_POSIX)|g' \
	      -e 's|@''GNULIB_REALPATH''@|$(GNULIB_REALPATH)|g' \
	      -e 's|@''GNULIB_RPMATCH''@|$(GNULIB_RPMATCH)|g' \
	      -e 's|@''GNULIB_SETENV''@|$(GNULIB_SETENV)|g' \
	      -e 's|@''GNULIB_STRTOD''@|$(GNULIB_STRTOD)|g' \
	      -e 's|@''GNULIB_STRTOLL''@|$(GNULIB_STRTOLL)|g' \
	      -e 's|@''GNULIB_STRTOULL''@|$(GNULIB_STRTOULL)|g' \
	      -e 's|@''GNULIB_SYSTEM_POSIX''@|$(GNULIB_SYSTEM_POSIX)|g' \
	      -e 's|@''GNULIB_UNLOCKPT''@|$(GNULIB_UNLOCKPT)|g' \
	      -e 's|@''GNULIB_UNSETENV''@|$(GNULIB_UNSETENV)|g' \
	      -e 's|@''GNULIB_WCTOMB''@|$(GNULIB_WCTOMB)|g' \
	      < $(srcdir)/stdlib.in.h | \
	  sed -e 's|@''HAVE__EXIT''@|$(HAVE__EXIT)|g' \
	      -e 's|@''HAVE_ATOLL''@|$(HAVE_ATOLL)|g' \
	      -e 's|@''HAVE_CANONICALIZE_FILE_NAME''@|$(HAVE_CANONICALIZE_FILE_NAME)|g' \
	      -e 's|@''HAVE_DECL_GETLOADAVG''@|$(HAVE_DECL_GETLOADAVG)|g' \
	      -e 's|@''HAVE_GETSUBOPT''@|$(HAVE_GETSUBOPT)|g' \
	      -e 's|@''HAVE_GRANTPT''@|$(HAVE_GRANTPT)|g' \
	      -e 's|@''HAVE_MKDTEMP''@|$(HAVE_MKDTEMP)|g' \
	      -e 's|@''HAVE_MKOSTEMP''@|$(HAVE_MKOSTEMP)|g' \
	      -e 's|@''HAVE_MKOSTEMPS''@|$(HAVE_MKOSTEMPS)|g' \
	      -e 's|@''HAVE_MKSTEMP''@|$(HAVE_MKSTEMP)|g' \
	      -e 's|@''HAVE_MKSTEMPS''@|$(HAVE_MKSTEMPS)|g' \
	      -e 's|@''HAVE_PTSNAME''@|$(HAVE_PTSNAME)|g' \
	      -e 's|@''HAVE_RANDOM_H''@|$(HAVE_RANDOM_H)|g' \
	      -e 's|@''HAVE_RANDOM_R''@|$(HAVE_RANDOM_R)|g' \
	      -e 's|@''HAVE_REALPATH''@|$(HAVE_REALPATH)|g' \
	      -e 's|@''HAVE_RPMATCH''@|$(HAVE_RPMATCH)|g' \
	      -e 's|@''HAVE_DECL_SETENV''@|$(HAVE_DECL_SETENV)|g' \
	      -e 's|@''HAVE_STRTOD''@|$(HAVE_STRTOD)|g' \
	      -e 's|@''HAVE_STRTOLL''@|$(HAVE_STRTOLL)|g' \
	      -e 's|@''HAVE_STRTOULL''@|$(HAVE_STRTOULL)|g' \
	      -e 's|@''HAVE_STRUCT_RANDOM_DATA''@|$(HAVE_STRUCT_RANDOM_DATA)|g' \
	      -e 's|@''HAVE_SYS_LOADAVG_H''@|$(HAVE_SYS_LOADAVG_H)|g' \
	      -e 's|@''HAVE_UNLOCKPT''@|$(HAVE_UNLOCKPT)|g' \
	      -e 's|@''HAVE_DECL_UNSETENV''@|$(HAVE_DECL_UNSETENV)|g' \
	      -e 's|@''REPLACE_CALLOC''@|$(REPLACE_CALLOC)|g' \
	      -e 's|@''REPLACE_CANONICALIZE_FILE_NAME''@|$(REPLACE_CANONICALIZE_FILE_NAME)|g' \
	      -e 's|@''REPLACE_MALLOC''@|$(REPLACE_MALLOC)|g' \
	      -e 's|@''REPLACE_MBTOWC''@|$(REPLACE_MBTOWC)|g' \
	      -e 's|@''REPLACE_MKSTEMP''@|$(REPLACE_MKSTEMP)|g' \
	      -e 's|@''REPLACE_PUTENV''@|$(REPLACE_PUTENV)|g' \
	      -e 's|@''REPLACE_REALLOC''@|$(REPLACE_REALLOC)|g' \
	      -e 's|@''REPLACE_REALPATH''@|$(REPLACE_REALPATH)|g' \
	      -e 's|@''REPLACE_SETENV''@|$(REPLACE_SETENV)|g' \
	      -e 's|@''REPLACE_STRTOD''@|$(REPLACE_STRTOD)|g' \
	      -e 's|@''REPLACE_UNSETENV''@|$(REPLACE_UNSETENV)|g' \
	      -e 's|@''REPLACE_WCTOMB''@|$(REPLACE_WCTOMB)|g' \
	      -e '/definitions of _GL_FUNCDECL_RPL/r $(CXXDEFS_H)' \
	      -e '/definition of _GL_ARG_NONNULL/r $(ARG_NONNULL_H)' \
	      -e '/definition of _GL_WARN_ON_USE/r $(WARN_ON_USE_H)'; \
	} > $@-t && \
	mv $@-t $@
MOSTLYCLEANFILES += stdlib.h stdlib.h-t

EXTRA_DIST += stdlib.in.h

## end   gnulib module stdlib

## begin gnulib module strftime


EXTRA_DIST += strftime.c strftime.h

EXTRA_libgnu_a_SOURCES += strftime.c

## end   gnulib module strftime

## begin gnulib module symlink


EXTRA_DIST += symlink.c

EXTRA_libgnu_a_SOURCES += symlink.c

## end   gnulib module symlink

## begin gnulib module sys_stat

BUILT_SOURCES += sys/stat.h

# We need the following in order to create <sys/stat.h> when the system
# has one that is incomplete.
sys/stat.h: sys_stat.in.h $(top_builddir)/config.status $(CXXDEFS_H) $(ARG_NONNULL_H) $(WARN_ON_USE_H)
	$(AM_V_at)$(MKDIR_P) sys
	$(AM_V_GEN)rm -f $@-t $@ && \
	{ echo '/* DO NOT EDIT! GENERATED AUTOMATICALLY! */'; \
	  sed -e 's|@''INCLUDE_NEXT''@|$(INCLUDE_NEXT)|g' \
	      -e 's|@''PRAGMA_SYSTEM_HEADER''@|@PRAGMA_SYSTEM_HEADER@|g' \
	      -e 's|@''PRAGMA_COLUMNS''@|@PRAGMA_COLUMNS@|g' \
	      -e 's|@''NEXT_SYS_STAT_H''@|$(NEXT_SYS_STAT_H)|g' \
	      -e 's|@''GNULIB_FCHMODAT''@|$(GNULIB_FCHMODAT)|g' \
	      -e 's|@''GNULIB_FSTATAT''@|$(GNULIB_FSTATAT)|g' \
	      -e 's|@''GNULIB_FUTIMENS''@|$(GNULIB_FUTIMENS)|g' \
	      -e 's|@''GNULIB_LCHMOD''@|$(GNULIB_LCHMOD)|g' \
	      -e 's|@''GNULIB_LSTAT''@|$(GNULIB_LSTAT)|g' \
	      -e 's|@''GNULIB_MKDIRAT''@|$(GNULIB_MKDIRAT)|g' \
	      -e 's|@''GNULIB_MKFIFO''@|$(GNULIB_MKFIFO)|g' \
	      -e 's|@''GNULIB_MKFIFOAT''@|$(GNULIB_MKFIFOAT)|g' \
	      -e 's|@''GNULIB_MKNOD''@|$(GNULIB_MKNOD)|g' \
	      -e 's|@''GNULIB_MKNODAT''@|$(GNULIB_MKNODAT)|g' \
	      -e 's|@''GNULIB_STAT''@|$(GNULIB_STAT)|g' \
	      -e 's|@''GNULIB_UTIMENSAT''@|$(GNULIB_UTIMENSAT)|g' \
	      -e 's|@''HAVE_FCHMODAT''@|$(HAVE_FCHMODAT)|g' \
	      -e 's|@''HAVE_FSTATAT''@|$(HAVE_FSTATAT)|g' \
	      -e 's|@''HAVE_FUTIMENS''@|$(HAVE_FUTIMENS)|g' \
	      -e 's|@''HAVE_LCHMOD''@|$(HAVE_LCHMOD)|g' \
	      -e 's|@''HAVE_LSTAT''@|$(HAVE_LSTAT)|g' \
	      -e 's|@''HAVE_MKDIRAT''@|$(HAVE_MKDIRAT)|g' \
	      -e 's|@''HAVE_MKFIFO''@|$(HAVE_MKFIFO)|g' \
	      -e 's|@''HAVE_MKFIFOAT''@|$(HAVE_MKFIFOAT)|g' \
	      -e 's|@''HAVE_MKNOD''@|$(HAVE_MKNOD)|g' \
	      -e 's|@''HAVE_MKNODAT''@|$(HAVE_MKNODAT)|g' \
	      -e 's|@''HAVE_UTIMENSAT''@|$(HAVE_UTIMENSAT)|g' \
	      -e 's|@''REPLACE_FSTAT''@|$(REPLACE_FSTAT)|g' \
	      -e 's|@''REPLACE_FSTATAT''@|$(REPLACE_FSTATAT)|g' \
	      -e 's|@''REPLACE_FUTIMENS''@|$(REPLACE_FUTIMENS)|g' \
	      -e 's|@''REPLACE_LSTAT''@|$(REPLACE_LSTAT)|g' \
	      -e 's|@''REPLACE_MKDIR''@|$(REPLACE_MKDIR)|g' \
	      -e 's|@''REPLACE_MKFIFO''@|$(REPLACE_MKFIFO)|g' \
	      -e 's|@''REPLACE_MKNOD''@|$(REPLACE_MKNOD)|g' \
	      -e 's|@''REPLACE_STAT''@|$(REPLACE_STAT)|g' \
	      -e 's|@''REPLACE_UTIMENSAT''@|$(REPLACE_UTIMENSAT)|g' \
	      -e '/definitions of _GL_FUNCDECL_RPL/r $(CXXDEFS_H)' \
	      -e '/definition of _GL_ARG_NONNULL/r $(ARG_NONNULL_H)' \
	      -e '/definition of _GL_WARN_ON_USE/r $(WARN_ON_USE_H)' \
	      < $(srcdir)/sys_stat.in.h; \
	} > $@-t && \
	mv $@-t $@
MOSTLYCLEANFILES += sys/stat.h sys/stat.h-t
MOSTLYCLEANDIRS += sys

EXTRA_DIST += sys_stat.in.h

## end   gnulib module sys_stat

## begin gnulib module time

BUILT_SOURCES += time.h

# We need the following in order to create <time.h> when the system
# doesn't have one that works with the given compiler.
time.h: time.in.h $(top_builddir)/config.status $(CXXDEFS_H) $(ARG_NONNULL_H) $(WARN_ON_USE_H)
	$(AM_V_GEN)rm -f $@-t $@ && \
	{ echo '/* DO NOT EDIT! GENERATED AUTOMATICALLY! */' && \
	  sed -e 's|@''INCLUDE_NEXT''@|$(INCLUDE_NEXT)|g' \
	      -e 's|@''PRAGMA_SYSTEM_HEADER''@|@PRAGMA_SYSTEM_HEADER@|g' \
	      -e 's|@''PRAGMA_COLUMNS''@|@PRAGMA_COLUMNS@|g' \
	      -e 's|@''NEXT_TIME_H''@|$(NEXT_TIME_H)|g' \
	      -e 's|@''GNULIB_MKTIME''@|$(GNULIB_MKTIME)|g' \
	      -e 's|@''GNULIB_NANOSLEEP''@|$(GNULIB_NANOSLEEP)|g' \
	      -e 's|@''GNULIB_STRPTIME''@|$(GNULIB_STRPTIME)|g' \
	      -e 's|@''GNULIB_TIMEGM''@|$(GNULIB_TIMEGM)|g' \
	      -e 's|@''GNULIB_TIME_R''@|$(GNULIB_TIME_R)|g' \
	      -e 's|@''HAVE_DECL_LOCALTIME_R''@|$(HAVE_DECL_LOCALTIME_R)|g' \
	      -e 's|@''HAVE_NANOSLEEP''@|$(HAVE_NANOSLEEP)|g' \
	      -e 's|@''HAVE_STRPTIME''@|$(HAVE_STRPTIME)|g' \
	      -e 's|@''HAVE_TIMEGM''@|$(HAVE_TIMEGM)|g' \
	      -e 's|@''REPLACE_LOCALTIME_R''@|$(REPLACE_LOCALTIME_R)|g' \
	      -e 's|@''REPLACE_MKTIME''@|$(REPLACE_MKTIME)|g' \
	      -e 's|@''REPLACE_NANOSLEEP''@|$(REPLACE_NANOSLEEP)|g' \
	      -e 's|@''REPLACE_TIMEGM''@|$(REPLACE_TIMEGM)|g' \
	      -e 's|@''PTHREAD_H_DEFINES_STRUCT_TIMESPEC''@|$(PTHREAD_H_DEFINES_STRUCT_TIMESPEC)|g' \
	      -e 's|@''SYS_TIME_H_DEFINES_STRUCT_TIMESPEC''@|$(SYS_TIME_H_DEFINES_STRUCT_TIMESPEC)|g' \
	      -e 's|@''TIME_H_DEFINES_STRUCT_TIMESPEC''@|$(TIME_H_DEFINES_STRUCT_TIMESPEC)|g' \
	      -e '/definitions of _GL_FUNCDECL_RPL/r $(CXXDEFS_H)' \
	      -e '/definition of _GL_ARG_NONNULL/r $(ARG_NONNULL_H)' \
	      -e '/definition of _GL_WARN_ON_USE/r $(WARN_ON_USE_H)' \
	      < $(srcdir)/time.in.h; \
	} > $@-t && \
	mv $@-t $@
MOSTLYCLEANFILES += time.h time.h-t

EXTRA_DIST += time.in.h

## end   gnulib module time

## begin gnulib module time_r


EXTRA_DIST += time_r.c

EXTRA_libgnu_a_SOURCES += time_r.c

## end   gnulib module time_r

## begin gnulib module unistd

BUILT_SOURCES += unistd.h

# We need the following in order to create an empty placeholder for
# <unistd.h> when the system doesn't have one.
unistd.h: unistd.in.h $(top_builddir)/config.status $(CXXDEFS_H) $(ARG_NONNULL_H) $(WARN_ON_USE_H)
	$(AM_V_GEN)rm -f $@-t $@ && \
	{ echo '/* DO NOT EDIT! GENERATED AUTOMATICALLY! */'; \
	  sed -e 's|@''HAVE_UNISTD_H''@|$(HAVE_UNISTD_H)|g' \
	      -e 's|@''INCLUDE_NEXT''@|$(INCLUDE_NEXT)|g' \
	      -e 's|@''PRAGMA_SYSTEM_HEADER''@|@PRAGMA_SYSTEM_HEADER@|g' \
	      -e 's|@''PRAGMA_COLUMNS''@|@PRAGMA_COLUMNS@|g' \
	      -e 's|@''NEXT_UNISTD_H''@|$(NEXT_UNISTD_H)|g' \
	      -e 's|@''GNULIB_CHOWN''@|$(GNULIB_CHOWN)|g' \
	      -e 's|@''GNULIB_CLOSE''@|$(GNULIB_CLOSE)|g' \
	      -e 's|@''GNULIB_DUP2''@|$(GNULIB_DUP2)|g' \
	      -e 's|@''GNULIB_DUP3''@|$(GNULIB_DUP3)|g' \
	      -e 's|@''GNULIB_ENVIRON''@|$(GNULIB_ENVIRON)|g' \
	      -e 's|@''GNULIB_EUIDACCESS''@|$(GNULIB_EUIDACCESS)|g' \
	      -e 's|@''GNULIB_FACCESSAT''@|$(GNULIB_FACCESSAT)|g' \
	      -e 's|@''GNULIB_FCHDIR''@|$(GNULIB_FCHDIR)|g' \
	      -e 's|@''GNULIB_FCHOWNAT''@|$(GNULIB_FCHOWNAT)|g' \
	      -e 's|@''GNULIB_FSYNC''@|$(GNULIB_FSYNC)|g' \
	      -e 's|@''GNULIB_FTRUNCATE''@|$(GNULIB_FTRUNCATE)|g' \
	      -e 's|@''GNULIB_GETCWD''@|$(GNULIB_GETCWD)|g' \
	      -e 's|@''GNULIB_GETDOMAINNAME''@|$(GNULIB_GETDOMAINNAME)|g' \
	      -e 's|@''GNULIB_GETDTABLESIZE''@|$(GNULIB_GETDTABLESIZE)|g' \
	      -e 's|@''GNULIB_GETGROUPS''@|$(GNULIB_GETGROUPS)|g' \
	      -e 's|@''GNULIB_GETHOSTNAME''@|$(GNULIB_GETHOSTNAME)|g' \
	      -e 's|@''GNULIB_GETLOGIN''@|$(GNULIB_GETLOGIN)|g' \
	      -e 's|@''GNULIB_GETLOGIN_R''@|$(GNULIB_GETLOGIN_R)|g' \
	      -e 's|@''GNULIB_GETPAGESIZE''@|$(GNULIB_GETPAGESIZE)|g' \
	      -e 's|@''GNULIB_GETUSERSHELL''@|$(GNULIB_GETUSERSHELL)|g' \
	      -e 's|@''GNULIB_LCHOWN''@|$(GNULIB_LCHOWN)|g' \
	      -e 's|@''GNULIB_LINK''@|$(GNULIB_LINK)|g' \
	      -e 's|@''GNULIB_LINKAT''@|$(GNULIB_LINKAT)|g' \
	      -e 's|@''GNULIB_LSEEK''@|$(GNULIB_LSEEK)|g' \
	      -e 's|@''GNULIB_PIPE''@|$(GNULIB_PIPE)|g' \
	      -e 's|@''GNULIB_PIPE2''@|$(GNULIB_PIPE2)|g' \
	      -e 's|@''GNULIB_PREAD''@|$(GNULIB_PREAD)|g' \
	      -e 's|@''GNULIB_PWRITE''@|$(GNULIB_PWRITE)|g' \
	      -e 's|@''GNULIB_READ''@|$(GNULIB_READ)|g' \
	      -e 's|@''GNULIB_READLINK''@|$(GNULIB_READLINK)|g' \
	      -e 's|@''GNULIB_READLINKAT''@|$(GNULIB_READLINKAT)|g' \
	      -e 's|@''GNULIB_RMDIR''@|$(GNULIB_RMDIR)|g' \
	      -e 's|@''GNULIB_SLEEP''@|$(GNULIB_SLEEP)|g' \
	      -e 's|@''GNULIB_SYMLINK''@|$(GNULIB_SYMLINK)|g' \
	      -e 's|@''GNULIB_SYMLINKAT''@|$(GNULIB_SYMLINKAT)|g' \
	      -e 's|@''GNULIB_TTYNAME_R''@|$(GNULIB_TTYNAME_R)|g' \
	      -e 's|@''GNULIB_UNISTD_H_GETOPT''@|$(GNULIB_UNISTD_H_GETOPT)|g' \
	      -e 's|@''GNULIB_UNISTD_H_NONBLOCKING''@|$(GNULIB_UNISTD_H_NONBLOCKING)|g' \
	      -e 's|@''GNULIB_UNISTD_H_SIGPIPE''@|$(GNULIB_UNISTD_H_SIGPIPE)|g' \
	      -e 's|@''GNULIB_UNLINK''@|$(GNULIB_UNLINK)|g' \
	      -e 's|@''GNULIB_UNLINKAT''@|$(GNULIB_UNLINKAT)|g' \
	      -e 's|@''GNULIB_USLEEP''@|$(GNULIB_USLEEP)|g' \
	      -e 's|@''GNULIB_WRITE''@|$(GNULIB_WRITE)|g' \
	      < $(srcdir)/unistd.in.h | \
	  sed -e 's|@''HAVE_CHOWN''@|$(HAVE_CHOWN)|g' \
	      -e 's|@''HAVE_DUP2''@|$(HAVE_DUP2)|g' \
	      -e 's|@''HAVE_DUP3''@|$(HAVE_DUP3)|g' \
	      -e 's|@''HAVE_EUIDACCESS''@|$(HAVE_EUIDACCESS)|g' \
	      -e 's|@''HAVE_FACCESSAT''@|$(HAVE_FACCESSAT)|g' \
	      -e 's|@''HAVE_FCHDIR''@|$(HAVE_FCHDIR)|g' \
	      -e 's|@''HAVE_FCHOWNAT''@|$(HAVE_FCHOWNAT)|g' \
	      -e 's|@''HAVE_FSYNC''@|$(HAVE_FSYNC)|g' \
	      -e 's|@''HAVE_FTRUNCATE''@|$(HAVE_FTRUNCATE)|g' \
	      -e 's|@''HAVE_GETDTABLESIZE''@|$(HAVE_GETDTABLESIZE)|g' \
	      -e 's|@''HAVE_GETGROUPS''@|$(HAVE_GETGROUPS)|g' \
	      -e 's|@''HAVE_GETHOSTNAME''@|$(HAVE_GETHOSTNAME)|g' \
	      -e 's|@''HAVE_GETLOGIN''@|$(HAVE_GETLOGIN)|g' \
	      -e 's|@''HAVE_GETPAGESIZE''@|$(HAVE_GETPAGESIZE)|g' \
	      -e 's|@''HAVE_LCHOWN''@|$(HAVE_LCHOWN)|g' \
	      -e 's|@''HAVE_LINK''@|$(HAVE_LINK)|g' \
	      -e 's|@''HAVE_LINKAT''@|$(HAVE_LINKAT)|g' \
	      -e 's|@''HAVE_PIPE''@|$(HAVE_PIPE)|g' \
	      -e 's|@''HAVE_PIPE2''@|$(HAVE_PIPE2)|g' \
	      -e 's|@''HAVE_PREAD''@|$(HAVE_PREAD)|g' \
	      -e 's|@''HAVE_PWRITE''@|$(HAVE_PWRITE)|g' \
	      -e 's|@''HAVE_READLINK''@|$(HAVE_READLINK)|g' \
	      -e 's|@''HAVE_READLINKAT''@|$(HAVE_READLINKAT)|g' \
	      -e 's|@''HAVE_SLEEP''@|$(HAVE_SLEEP)|g' \
	      -e 's|@''HAVE_SYMLINK''@|$(HAVE_SYMLINK)|g' \
	      -e 's|@''HAVE_SYMLINKAT''@|$(HAVE_SYMLINKAT)|g' \
	      -e 's|@''HAVE_UNLINKAT''@|$(HAVE_UNLINKAT)|g' \
	      -e 's|@''HAVE_USLEEP''@|$(HAVE_USLEEP)|g' \
	      -e 's|@''HAVE_DECL_ENVIRON''@|$(HAVE_DECL_ENVIRON)|g' \
	      -e 's|@''HAVE_DECL_FCHDIR''@|$(HAVE_DECL_FCHDIR)|g' \
	      -e 's|@''HAVE_DECL_GETDOMAINNAME''@|$(HAVE_DECL_GETDOMAINNAME)|g' \
	      -e 's|@''HAVE_DECL_GETLOGIN_R''@|$(HAVE_DECL_GETLOGIN_R)|g' \
	      -e 's|@''HAVE_DECL_GETPAGESIZE''@|$(HAVE_DECL_GETPAGESIZE)|g' \
	      -e 's|@''HAVE_DECL_GETUSERSHELL''@|$(HAVE_DECL_GETUSERSHELL)|g' \
	      -e 's|@''HAVE_DECL_TTYNAME_R''@|$(HAVE_DECL_TTYNAME_R)|g' \
	      -e 's|@''HAVE_OS_H''@|$(HAVE_OS_H)|g' \
	      -e 's|@''HAVE_SYS_PARAM_H''@|$(HAVE_SYS_PARAM_H)|g' \
	  | \
	  sed -e 's|@''REPLACE_CHOWN''@|$(REPLACE_CHOWN)|g' \
	      -e 's|@''REPLACE_CLOSE''@|$(REPLACE_CLOSE)|g' \
	      -e 's|@''REPLACE_DUP''@|$(REPLACE_DUP)|g' \
	      -e 's|@''REPLACE_DUP2''@|$(REPLACE_DUP2)|g' \
	      -e 's|@''REPLACE_FCHOWNAT''@|$(REPLACE_FCHOWNAT)|g' \
	      -e 's|@''REPLACE_GETCWD''@|$(REPLACE_GETCWD)|g' \
	      -e 's|@''REPLACE_GETDOMAINNAME''@|$(REPLACE_GETDOMAINNAME)|g' \
	      -e 's|@''REPLACE_GETLOGIN_R''@|$(REPLACE_GETLOGIN_R)|g' \
	      -e 's|@''REPLACE_GETGROUPS''@|$(REPLACE_GETGROUPS)|g' \
	      -e 's|@''REPLACE_GETPAGESIZE''@|$(REPLACE_GETPAGESIZE)|g' \
	      -e 's|@''REPLACE_LCHOWN''@|$(REPLACE_LCHOWN)|g' \
	      -e 's|@''REPLACE_LINK''@|$(REPLACE_LINK)|g' \
	      -e 's|@''REPLACE_LINKAT''@|$(REPLACE_LINKAT)|g' \
	      -e 's|@''REPLACE_LSEEK''@|$(REPLACE_LSEEK)|g' \
	      -e 's|@''REPLACE_PREAD''@|$(REPLACE_PREAD)|g' \
	      -e 's|@''REPLACE_PWRITE''@|$(REPLACE_PWRITE)|g' \
	      -e 's|@''REPLACE_READ''@|$(REPLACE_READ)|g' \
	      -e 's|@''REPLACE_READLINK''@|$(REPLACE_READLINK)|g' \
	      -e 's|@''REPLACE_RMDIR''@|$(REPLACE_RMDIR)|g' \
	      -e 's|@''REPLACE_SLEEP''@|$(REPLACE_SLEEP)|g' \
	      -e 's|@''REPLACE_SYMLINK''@|$(REPLACE_SYMLINK)|g' \
	      -e 's|@''REPLACE_TTYNAME_R''@|$(REPLACE_TTYNAME_R)|g' \
	      -e 's|@''REPLACE_UNLINK''@|$(REPLACE_UNLINK)|g' \
	      -e 's|@''REPLACE_UNLINKAT''@|$(REPLACE_UNLINKAT)|g' \
	      -e 's|@''REPLACE_USLEEP''@|$(REPLACE_USLEEP)|g' \
	      -e 's|@''REPLACE_WRITE''@|$(REPLACE_WRITE)|g' \
	      -e 's|@''UNISTD_H_HAVE_WINSOCK2_H''@|$(UNISTD_H_HAVE_WINSOCK2_H)|g' \
	      -e 's|@''UNISTD_H_HAVE_WINSOCK2_H_AND_USE_SOCKETS''@|$(UNISTD_H_HAVE_WINSOCK2_H_AND_USE_SOCKETS)|g' \
	      -e '/definitions of _GL_FUNCDECL_RPL/r $(CXXDEFS_H)' \
	      -e '/definition of _GL_ARG_NONNULL/r $(ARG_NONNULL_H)' \
	      -e '/definition of _GL_WARN_ON_USE/r $(WARN_ON_USE_H)'; \
	} > $@-t && \
	mv $@-t $@
MOSTLYCLEANFILES += unistd.h unistd.h-t

EXTRA_DIST += unistd.in.h

## end   gnulib module unistd

## begin gnulib module warn-on-use

BUILT_SOURCES += warn-on-use.h
# The warn-on-use.h that gets inserted into generated .h files is the same as
# build-aux/warn-on-use.h, except that it has the copyright header cut off.
warn-on-use.h: $(top_srcdir)/./warn-on-use.h
	$(AM_V_GEN)rm -f $@-t $@ && \
	sed -n -e '/^.ifndef/,$$p' \
	  < $(top_srcdir)/./warn-on-use.h \
	  > $@-t && \
	mv $@-t $@
MOSTLYCLEANFILES += warn-on-use.h warn-on-use.h-t

WARN_ON_USE_H=warn-on-use.h

EXTRA_DIST += $(top_srcdir)/./warn-on-use.h

## end   gnulib module warn-on-use


mostlyclean-local: mostlyclean-generic
	@for dir in '' $(MOSTLYCLEANDIRS); do \
	  if test -n "$$dir" && test -d $$dir; then \
	    echo "rmdir $$dir"; rmdir $$dir; \
	  fi; \
	done; \
	:
