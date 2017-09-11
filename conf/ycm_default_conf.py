import os
import ycm_core # pylint: disable=F0401

# pylint: disable=import-error
from ycmd.completers.cpp.clang_completer import CLANG_FILETYPES

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm', '.blk' ]
HEADER_EXTENSIONS = [ '.h', '.hxx', '.hpp', '.hh' ]
SPECIAL_FLAGS = { '.blk' : [ '-xc' ] }

def create_database(compilation_database_folder):
    if not os.path.exists(compilation_database_folder):
        return None
    return ycm_core.CompilationDatabase(compilation_database_folder)


def directory_of_this_script():
    return os.path.dirname(os.path.abspath( __file__ ))


def make_relative_paths_in_flags_absolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith( '/' ):
                new_flag = os.path.join( working_directory, flag )

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith( path_flag ):
                path = flag[ len( path_flag ): ]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append( new_flag )
    return new_flags


def is_header_file(filename):
    extension = os.path.splitext(filename)[1]
    return extension in HEADER_EXTENSIONS


def clang_supported_file_types(completer):
    return SOURCE_EXTENSIONS


def fix_file_type_flags(filename, flags):
    extension = os.path.splitext(filename)[1]
    try:
        flags.extend(SPECIAL_FLAGS[extension])
    except KeyError:
        pass


class YcmDefaultConf(object):
    def __init__(self, flags, compilation_database_folder):
        CLANG_FILETYPES.update(SOURCE_EXTENSIONS)
        self.flags = make_relative_paths_in_flags_absolute(
            flags, directory_of_this_script())
        self.database = create_database(compilation_database_folder)

    def get_compilation_info_for_file(self, filename):
        if not is_header_file(filename):
            return self.database.GetCompilationInfoForFile(filename)

        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            source_file = basename + extension
            if not os.path.exists(source_file):
                continue
            compilation_info = self.database.GetCompilationInfoForFile(
                source_file)
            if compilation_info.compiler_flags_:
                return compilation_info
        return None

    def make_flags_for_file(self):
        def _with_database(filename):
            compilation_info = self.get_compilation_info_for_file(filename)
            if not compilation_info:
                return None

            return make_relative_paths_in_flags_absolute(
                compilation_info.compiler_flags_,
                compilation_info.compiler_working_dir_)

        def _without_database(filename):
            return self.flags

        def _func(filename):
            flags = _with_database(filename) if self.database else \
                    _without_database(filename)

            fix_file_type_flags(filename, flags)

            return {'flags': flags, 'do_cache': True}
        return _func

if __name__ != 'ycm_default_conf':
    CONF = YcmDefaultConf(['-O0'], '')
    FlagsForFile = CONF.make_flags_for_file() # pylint: disable=C0103
