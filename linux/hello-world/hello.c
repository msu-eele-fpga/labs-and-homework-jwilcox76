#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Joshua Wilcox");

static int __init init_function(void){
    printk(KERN_INFO "Hello, world\n");
    return 0;
}


static void __exit cleanup_function(void){
    printk(KERN_INFO "Goodbye, cruel world\n");
}

module_init(init_function);
module_exit(cleanup_function);