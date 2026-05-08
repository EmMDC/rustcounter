#include <linux/module.h>
#include <linux/export-internal.h>
#include <linux/compiler.h>

MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__section(".gnu.linkonce.this_module") = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};



static const struct modversion_info ____versions[]
__used __section("__versions") = {
	{ 0xca2eebaa, "_RNvNtCsj9bqJNU6tGA_6kernel5print11call_printk" },
	{ 0x77acc8f8, "_copy_from_iter" },
	{ 0xb9464b01, "_copy_to_iter" },
	{ 0x4a050e3f, "_RNvXsg_NtCscIHVMyPnRZn_4core3fmtbNtB5_7Display3fmt" },
	{ 0x46431e07, "_RNvXsm_NtCsj9bqJNU6tGA_6kernel3fmtyNtB5_7Display3fmt" },
	{ 0x64ac6a2c, "misc_deregister" },
	{ 0xb159381f, "misc_register" },
	{ 0xe9277052, "_RNvNtCsj9bqJNU6tGA_6kernel5error9to_result" },
	{ 0xd272d446, "__x86_return_thunk" },
	{ 0x52152a9a, "generic_file_open" },
	{ 0x18f7e105, "rust_helper_krealloc_node_align" },
	{ 0xe63769e7, "module_layout" },
};

static const u32 ____version_ext_crcs[]
__used __section("__version_ext_crcs") = {
	0x4a00bccb,
	0xca2eebaa,
	0x77acc8f8,
	0xd272d446,
	0xb697f210,
	0xb9464b01,
	0xd272d446,
	0x4a050e3f,
	0x46431e07,
	0x64ac6a2c,
	0xb159381f,
	0xe9277052,
	0xb52929e2,
	0xd272d446,
	0x52152a9a,
	0x18f7e105,
	0xe63769e7,
};
static const char ____version_ext_names[]
__used __section("__version_ext_names") =
	"_RNvNtNtCsj9bqJNU6tGA_6kernel5print14format_strings4INFO\0"
	"_RNvNtCsj9bqJNU6tGA_6kernel5print11call_printk\0"
	"_copy_from_iter\0"
	"_RNvNtNtCscIHVMyPnRZn_4core9panicking11panic_const24panic_const_add_overflow\0"
	"_RNvMsg_NtCsj9bqJNU6tGA_6kernel3strNtB5_7CString12try_from_fmt\0"
	"_copy_to_iter\0"
	"_RNvNtNtCscIHVMyPnRZn_4core9panicking11panic_const24panic_const_sub_overflow\0"
	"_RNvXsg_NtCscIHVMyPnRZn_4core3fmtbNtB5_7Display3fmt\0"
	"_RNvXsm_NtCsj9bqJNU6tGA_6kernel3fmtyNtB5_7Display3fmt\0"
	"misc_deregister\0"
	"misc_register\0"
	"_RNvNtCsj9bqJNU6tGA_6kernel5error9to_result\0"
	"_RNvNtCscIHVMyPnRZn_4core9panicking19assert_failed_inner\0"
	"__x86_return_thunk\0"
	"generic_file_open\0"
	"rust_helper_krealloc_node_align\0"
	"module_layout\0"
;

MODULE_INFO(depends, "");


MODULE_INFO(srcversion, "49747B87BE2220F76F7EC76");
