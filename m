From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 7/7] hwrng: core: Remove two unused include
Date: Sat, 10 Dec 2016 09:27:21 +0800
Message-ID: <201612100950.bdkh8hGZ%fengguang.wu@intel.com>
References: <1481293299-21697-7-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Cc: kbuild-all@01.org, mpm@selenic.com, herbert@gondor.apana.org.au,
        arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481293299-21697-7-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Corentin,

[auto build test ERROR on char-misc/char-misc-testing]
[also build test ERROR on v4.9-rc8 next-20161209]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Corentin-Labbe/hwrng-core-do-not-use-multiple-blank-lines/20161210-072632
config: i386-randconfig-x007-201649 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/linkage.h:4:0,
                    from include/linux/kernel.h:6,
                    from include/linux/delay.h:10,
                    from drivers/char/hw_random/core.c:13:
   drivers/char/hw_random/core.c: In function 'rng_dev_open':
>> drivers/char/hw_random/core.c:169:11: error: dereferencing pointer to incomplete type 'struct file'
     if ((filp->f_mode & FMODE_READ) == 0)
              ^
   include/linux/compiler.h:149:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/char/hw_random/core.c:169:2: note: in expansion of macro 'if'
     if ((filp->f_mode & FMODE_READ) == 0)
     ^~
>> drivers/char/hw_random/core.c:169:22: error: 'FMODE_READ' undeclared (first use in this function)
     if ((filp->f_mode & FMODE_READ) == 0)
                         ^
   include/linux/compiler.h:149:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/char/hw_random/core.c:169:2: note: in expansion of macro 'if'
     if ((filp->f_mode & FMODE_READ) == 0)
     ^~
   drivers/char/hw_random/core.c:169:22: note: each undeclared identifier is reported only once for each function it appears in
     if ((filp->f_mode & FMODE_READ) == 0)
                         ^
   include/linux/compiler.h:149:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/char/hw_random/core.c:169:2: note: in expansion of macro 'if'
     if ((filp->f_mode & FMODE_READ) == 0)
     ^~
>> drivers/char/hw_random/core.c:171:21: error: 'FMODE_WRITE' undeclared (first use in this function)
     if (filp->f_mode & FMODE_WRITE)
                        ^
   include/linux/compiler.h:149:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
   drivers/char/hw_random/core.c:171:2: note: in expansion of macro 'if'
     if (filp->f_mode & FMODE_WRITE)
     ^~
   drivers/char/hw_random/core.c: In function 'rng_dev_read':
>> drivers/char/hw_random/core.c:221:23: error: 'O_NONBLOCK' undeclared (first use in this function)
        !(filp->f_flags & O_NONBLOCK));
                          ^~~~~~~~~~
   drivers/char/hw_random/core.c: At top level:
>> drivers/char/hw_random/core.c:272:21: error: variable 'rng_chrdev_ops' has initializer but incomplete type
    static const struct file_operations rng_chrdev_ops = {
                        ^~~~~~~~~~~~~~~
>> drivers/char/hw_random/core.c:273:2: error: unknown field 'owner' specified in initializer
     .owner  = THIS_MODULE,
     ^
   In file included from include/linux/linkage.h:6:0,
                    from include/linux/kernel.h:6,
                    from include/linux/delay.h:10,
                    from drivers/char/hw_random/core.c:13:
   include/linux/export.h:37:21: warning: excess elements in struct initializer
    #define THIS_MODULE ((struct module *)0)
                        ^
>> drivers/char/hw_random/core.c:273:12: note: in expansion of macro 'THIS_MODULE'
     .owner  = THIS_MODULE,
               ^~~~~~~~~~~
   include/linux/export.h:37:21: note: (near initialization for 'rng_chrdev_ops')
    #define THIS_MODULE ((struct module *)0)
                        ^
>> drivers/char/hw_random/core.c:273:12: note: in expansion of macro 'THIS_MODULE'
     .owner  = THIS_MODULE,
               ^~~~~~~~~~~
>> drivers/char/hw_random/core.c:274:2: error: unknown field 'open' specified in initializer
     .open  = rng_dev_open,
     ^
>> drivers/char/hw_random/core.c:274:11: warning: excess elements in struct initializer
     .open  = rng_dev_open,
              ^~~~~~~~~~~~
   drivers/char/hw_random/core.c:274:11: note: (near initialization for 'rng_chrdev_ops')
>> drivers/char/hw_random/core.c:275:2: error: unknown field 'read' specified in initializer
     .read  = rng_dev_read,
     ^
   drivers/char/hw_random/core.c:275:11: warning: excess elements in struct initializer
     .read  = rng_dev_read,
              ^~~~~~~~~~~~
   drivers/char/hw_random/core.c:275:11: note: (near initialization for 'rng_chrdev_ops')
>> drivers/char/hw_random/core.c:276:2: error: unknown field 'llseek' specified in initializer
     .llseek  = noop_llseek,
     ^
>> drivers/char/hw_random/core.c:276:13: error: 'noop_llseek' undeclared here (not in a function)
     .llseek  = noop_llseek,
                ^~~~~~~~~~~
   drivers/char/hw_random/core.c:276:13: warning: excess elements in struct initializer
   drivers/char/hw_random/core.c:276:13: note: (near initialization for 'rng_chrdev_ops')
>> drivers/char/hw_random/core.c:272:37: error: storage size of 'rng_chrdev_ops' isn't known
    static const struct file_operations rng_chrdev_ops = {
                                        ^~~~~~~~~~~~~~

vim +169 drivers/char/hw_random/core.c

92c7987e7 Corentin Labbe    2016-12-09    7   * Please read Documentation/hw_random.txt for details on use.
92c7987e7 Corentin Labbe    2016-12-09    8   *
92c7987e7 Corentin Labbe    2016-12-09    9   * This software may be used and distributed according to the terms
92c7987e7 Corentin Labbe    2016-12-09   10   * of the GNU General Public License, incorporated herein by reference.
844dd05fe Michael Buesch    2006-06-26   11   */
844dd05fe Michael Buesch    2006-06-26   12  
b70f09c75 Corentin Labbe    2016-12-09  @13  #include <linux/delay.h>
844dd05fe Michael Buesch    2006-06-26   14  #include <linux/device.h>
b70f09c75 Corentin Labbe    2016-12-09   15  #include <linux/err.h>
844dd05fe Michael Buesch    2006-06-26   16  #include <linux/hw_random.h>
844dd05fe Michael Buesch    2006-06-26   17  #include <linux/kernel.h>
be4000bc4 Torsten Duwe      2014-06-14   18  #include <linux/kthread.h>
b70f09c75 Corentin Labbe    2016-12-09   19  #include <linux/miscdevice.h>
b70f09c75 Corentin Labbe    2016-12-09   20  #include <linux/module.h>
d9e797261 Kees Cook         2014-03-03   21  #include <linux/random.h>
b70f09c75 Corentin Labbe    2016-12-09   22  #include <linux/slab.h>
b70f09c75 Corentin Labbe    2016-12-09   23  #include <linux/uaccess.h>
844dd05fe Michael Buesch    2006-06-26   24  
844dd05fe Michael Buesch    2006-06-26   25  #define RNG_MODULE_NAME		"hw_random"
844dd05fe Michael Buesch    2006-06-26   26  
844dd05fe Michael Buesch    2006-06-26   27  static struct hwrng *current_rng;
be4000bc4 Torsten Duwe      2014-06-14   28  static struct task_struct *hwrng_fill;
844dd05fe Michael Buesch    2006-06-26   29  static LIST_HEAD(rng_list);
9372b35e1 Rusty Russell     2014-12-08   30  /* Protects rng_list and current_rng */
844dd05fe Michael Buesch    2006-06-26   31  static DEFINE_MUTEX(rng_mutex);
9372b35e1 Rusty Russell     2014-12-08   32  /* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
9372b35e1 Rusty Russell     2014-12-08   33  static DEFINE_MUTEX(reading_mutex);
9996508b3 Ian Molton        2009-12-01   34  static int data_avail;
be4000bc4 Torsten Duwe      2014-06-14   35  static u8 *rng_buffer, *rng_fillbuf;
0f734e6e7 Torsten Duwe      2014-06-14   36  static unsigned short current_quality;
0f734e6e7 Torsten Duwe      2014-06-14   37  static unsigned short default_quality; /* = 0; default to "off" */
be4000bc4 Torsten Duwe      2014-06-14   38  
be4000bc4 Torsten Duwe      2014-06-14   39  module_param(current_quality, ushort, 0644);
be4000bc4 Torsten Duwe      2014-06-14   40  MODULE_PARM_DESC(current_quality,
be4000bc4 Torsten Duwe      2014-06-14   41  		 "current hwrng entropy estimation per mill");
0f734e6e7 Torsten Duwe      2014-06-14   42  module_param(default_quality, ushort, 0644);
0f734e6e7 Torsten Duwe      2014-06-14   43  MODULE_PARM_DESC(default_quality,
0f734e6e7 Torsten Duwe      2014-06-14   44  		 "default entropy content of hwrng per mill");
be4000bc4 Torsten Duwe      2014-06-14   45  
ff77c150f Herbert Xu        2014-12-23   46  static void drop_current_rng(void);
90ac41bd4 Herbert Xu        2014-12-23   47  static int hwrng_init(struct hwrng *rng);
be4000bc4 Torsten Duwe      2014-06-14   48  static void start_khwrngd(void);
f7f154f12 Rusty Russell     2013-03-05   49  
d3cc79964 Amit Shah         2014-07-10   50  static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
d3cc79964 Amit Shah         2014-07-10   51  			       int wait);
d3cc79964 Amit Shah         2014-07-10   52  
f7f154f12 Rusty Russell     2013-03-05   53  static size_t rng_buffer_size(void)
f7f154f12 Rusty Russell     2013-03-05   54  {
f7f154f12 Rusty Russell     2013-03-05   55  	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
f7f154f12 Rusty Russell     2013-03-05   56  }
844dd05fe Michael Buesch    2006-06-26   57  
d3cc79964 Amit Shah         2014-07-10   58  static void add_early_randomness(struct hwrng *rng)
d3cc79964 Amit Shah         2014-07-10   59  {
d3cc79964 Amit Shah         2014-07-10   60  	int bytes_read;
6d4952d9d Andrew Lutomirski 2016-10-17   61  	size_t size = min_t(size_t, 16, rng_buffer_size());
d3cc79964 Amit Shah         2014-07-10   62  
9372b35e1 Rusty Russell     2014-12-08   63  	mutex_lock(&reading_mutex);
6d4952d9d Andrew Lutomirski 2016-10-17   64  	bytes_read = rng_get_data(rng, rng_buffer, size, 1);
9372b35e1 Rusty Russell     2014-12-08   65  	mutex_unlock(&reading_mutex);
d3cc79964 Amit Shah         2014-07-10   66  	if (bytes_read > 0)
6d4952d9d Andrew Lutomirski 2016-10-17   67  		add_device_randomness(rng_buffer, bytes_read);
d3cc79964 Amit Shah         2014-07-10   68  }
d3cc79964 Amit Shah         2014-07-10   69  
3a2c0ba5a Rusty Russell     2014-12-08   70  static inline void cleanup_rng(struct kref *kref)
3a2c0ba5a Rusty Russell     2014-12-08   71  {
3a2c0ba5a Rusty Russell     2014-12-08   72  	struct hwrng *rng = container_of(kref, struct hwrng, ref);
3a2c0ba5a Rusty Russell     2014-12-08   73  
3a2c0ba5a Rusty Russell     2014-12-08   74  	if (rng->cleanup)
3a2c0ba5a Rusty Russell     2014-12-08   75  		rng->cleanup(rng);
a027f30d7 Rusty Russell     2014-12-08   76  
77584ee57 Herbert Xu        2014-12-23   77  	complete(&rng->cleanup_done);
3a2c0ba5a Rusty Russell     2014-12-08   78  }
3a2c0ba5a Rusty Russell     2014-12-08   79  
90ac41bd4 Herbert Xu        2014-12-23   80  static int set_current_rng(struct hwrng *rng)
3a2c0ba5a Rusty Russell     2014-12-08   81  {
90ac41bd4 Herbert Xu        2014-12-23   82  	int err;
90ac41bd4 Herbert Xu        2014-12-23   83  
3a2c0ba5a Rusty Russell     2014-12-08   84  	BUG_ON(!mutex_is_locked(&rng_mutex));
90ac41bd4 Herbert Xu        2014-12-23   85  
90ac41bd4 Herbert Xu        2014-12-23   86  	err = hwrng_init(rng);
90ac41bd4 Herbert Xu        2014-12-23   87  	if (err)
90ac41bd4 Herbert Xu        2014-12-23   88  		return err;
90ac41bd4 Herbert Xu        2014-12-23   89  
ff77c150f Herbert Xu        2014-12-23   90  	drop_current_rng();
3a2c0ba5a Rusty Russell     2014-12-08   91  	current_rng = rng;
90ac41bd4 Herbert Xu        2014-12-23   92  
90ac41bd4 Herbert Xu        2014-12-23   93  	return 0;
3a2c0ba5a Rusty Russell     2014-12-08   94  }
3a2c0ba5a Rusty Russell     2014-12-08   95  
3a2c0ba5a Rusty Russell     2014-12-08   96  static void drop_current_rng(void)
3a2c0ba5a Rusty Russell     2014-12-08   97  {
3a2c0ba5a Rusty Russell     2014-12-08   98  	BUG_ON(!mutex_is_locked(&rng_mutex));
3a2c0ba5a Rusty Russell     2014-12-08   99  	if (!current_rng)
3a2c0ba5a Rusty Russell     2014-12-08  100  		return;
3a2c0ba5a Rusty Russell     2014-12-08  101  
3a2c0ba5a Rusty Russell     2014-12-08  102  	/* decrease last reference for triggering the cleanup */
3a2c0ba5a Rusty Russell     2014-12-08  103  	kref_put(&current_rng->ref, cleanup_rng);
3a2c0ba5a Rusty Russell     2014-12-08  104  	current_rng = NULL;
3a2c0ba5a Rusty Russell     2014-12-08  105  }
3a2c0ba5a Rusty Russell     2014-12-08  106  
3a2c0ba5a Rusty Russell     2014-12-08  107  /* Returns ERR_PTR(), NULL or refcounted hwrng */
3a2c0ba5a Rusty Russell     2014-12-08  108  static struct hwrng *get_current_rng(void)
3a2c0ba5a Rusty Russell     2014-12-08  109  {
3a2c0ba5a Rusty Russell     2014-12-08  110  	struct hwrng *rng;
3a2c0ba5a Rusty Russell     2014-12-08  111  
3a2c0ba5a Rusty Russell     2014-12-08  112  	if (mutex_lock_interruptible(&rng_mutex))
3a2c0ba5a Rusty Russell     2014-12-08  113  		return ERR_PTR(-ERESTARTSYS);
3a2c0ba5a Rusty Russell     2014-12-08  114  
3a2c0ba5a Rusty Russell     2014-12-08  115  	rng = current_rng;
3a2c0ba5a Rusty Russell     2014-12-08  116  	if (rng)
3a2c0ba5a Rusty Russell     2014-12-08  117  		kref_get(&rng->ref);
3a2c0ba5a Rusty Russell     2014-12-08  118  
3a2c0ba5a Rusty Russell     2014-12-08  119  	mutex_unlock(&rng_mutex);
3a2c0ba5a Rusty Russell     2014-12-08  120  	return rng;
3a2c0ba5a Rusty Russell     2014-12-08  121  }
3a2c0ba5a Rusty Russell     2014-12-08  122  
3a2c0ba5a Rusty Russell     2014-12-08  123  static void put_rng(struct hwrng *rng)
3a2c0ba5a Rusty Russell     2014-12-08  124  {
3a2c0ba5a Rusty Russell     2014-12-08  125  	/*
3a2c0ba5a Rusty Russell     2014-12-08  126  	 * Hold rng_mutex here so we serialize in case they set_current_rng
3a2c0ba5a Rusty Russell     2014-12-08  127  	 * on rng again immediately.
3a2c0ba5a Rusty Russell     2014-12-08  128  	 */
3a2c0ba5a Rusty Russell     2014-12-08  129  	mutex_lock(&rng_mutex);
3a2c0ba5a Rusty Russell     2014-12-08  130  	if (rng)
3a2c0ba5a Rusty Russell     2014-12-08  131  		kref_put(&rng->ref, cleanup_rng);
3a2c0ba5a Rusty Russell     2014-12-08  132  	mutex_unlock(&rng_mutex);
3a2c0ba5a Rusty Russell     2014-12-08  133  }
3a2c0ba5a Rusty Russell     2014-12-08  134  
90ac41bd4 Herbert Xu        2014-12-23  135  static int hwrng_init(struct hwrng *rng)
844dd05fe Michael Buesch    2006-06-26  136  {
15b66cd54 Herbert Xu        2014-12-23  137  	if (kref_get_unless_zero(&rng->ref))
15b66cd54 Herbert Xu        2014-12-23  138  		goto skip_init;
15b66cd54 Herbert Xu        2014-12-23  139  
d3cc79964 Amit Shah         2014-07-10  140  	if (rng->init) {
d3cc79964 Amit Shah         2014-07-10  141  		int ret;
d3cc79964 Amit Shah         2014-07-10  142  
d3cc79964 Amit Shah         2014-07-10  143  		ret =  rng->init(rng);
d3cc79964 Amit Shah         2014-07-10  144  		if (ret)
d3cc79964 Amit Shah         2014-07-10  145  			return ret;
d3cc79964 Amit Shah         2014-07-10  146  	}
15b66cd54 Herbert Xu        2014-12-23  147  
15b66cd54 Herbert Xu        2014-12-23  148  	kref_init(&rng->ref);
15b66cd54 Herbert Xu        2014-12-23  149  	reinit_completion(&rng->cleanup_done);
15b66cd54 Herbert Xu        2014-12-23  150  
15b66cd54 Herbert Xu        2014-12-23  151  skip_init:
d3cc79964 Amit Shah         2014-07-10  152  	add_early_randomness(rng);
be4000bc4 Torsten Duwe      2014-06-14  153  
0f734e6e7 Torsten Duwe      2014-06-14  154  	current_quality = rng->quality ? : default_quality;
506bf0c04 Keith Packard     2015-03-18  155  	if (current_quality > 1024)
506bf0c04 Keith Packard     2015-03-18  156  		current_quality = 1024;
0f734e6e7 Torsten Duwe      2014-06-14  157  
0f734e6e7 Torsten Duwe      2014-06-14  158  	if (current_quality == 0 && hwrng_fill)
0f734e6e7 Torsten Duwe      2014-06-14  159  		kthread_stop(hwrng_fill);
be4000bc4 Torsten Duwe      2014-06-14  160  	if (current_quality > 0 && !hwrng_fill)
be4000bc4 Torsten Duwe      2014-06-14  161  		start_khwrngd();
be4000bc4 Torsten Duwe      2014-06-14  162  
844dd05fe Michael Buesch    2006-06-26  163  	return 0;
844dd05fe Michael Buesch    2006-06-26  164  }
844dd05fe Michael Buesch    2006-06-26  165  
844dd05fe Michael Buesch    2006-06-26  166  static int rng_dev_open(struct inode *inode, struct file *filp)
844dd05fe Michael Buesch    2006-06-26  167  {
844dd05fe Michael Buesch    2006-06-26  168  	/* enforce read-only access to this chrdev */
844dd05fe Michael Buesch    2006-06-26 @169  	if ((filp->f_mode & FMODE_READ) == 0)
844dd05fe Michael Buesch    2006-06-26  170  		return -EINVAL;
844dd05fe Michael Buesch    2006-06-26 @171  	if (filp->f_mode & FMODE_WRITE)
844dd05fe Michael Buesch    2006-06-26  172  		return -EINVAL;
844dd05fe Michael Buesch    2006-06-26  173  	return 0;
844dd05fe Michael Buesch    2006-06-26  174  }
844dd05fe Michael Buesch    2006-06-26  175  
9996508b3 Ian Molton        2009-12-01  176  static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
9996508b3 Ian Molton        2009-12-01  177  			int wait) {
9996508b3 Ian Molton        2009-12-01  178  	int present;
9996508b3 Ian Molton        2009-12-01  179  
9372b35e1 Rusty Russell     2014-12-08  180  	BUG_ON(!mutex_is_locked(&reading_mutex));
9996508b3 Ian Molton        2009-12-01  181  	if (rng->read)
9996508b3 Ian Molton        2009-12-01  182  		return rng->read(rng, (void *)buffer, size, wait);
9996508b3 Ian Molton        2009-12-01  183  
9996508b3 Ian Molton        2009-12-01  184  	if (rng->data_present)
9996508b3 Ian Molton        2009-12-01  185  		present = rng->data_present(rng, wait);
9996508b3 Ian Molton        2009-12-01  186  	else
9996508b3 Ian Molton        2009-12-01  187  		present = 1;
9996508b3 Ian Molton        2009-12-01  188  
9996508b3 Ian Molton        2009-12-01  189  	if (present)
9996508b3 Ian Molton        2009-12-01  190  		return rng->data_read(rng, (u32 *)buffer);
9996508b3 Ian Molton        2009-12-01  191  
9996508b3 Ian Molton        2009-12-01  192  	return 0;
9996508b3 Ian Molton        2009-12-01  193  }
9996508b3 Ian Molton        2009-12-01  194  
844dd05fe Michael Buesch    2006-06-26  195  static ssize_t rng_dev_read(struct file *filp, char __user *buf,
844dd05fe Michael Buesch    2006-06-26  196  			    size_t size, loff_t *offp)
844dd05fe Michael Buesch    2006-06-26  197  {
844dd05fe Michael Buesch    2006-06-26  198  	ssize_t ret = 0;
984e976f5 Patrick McHardy   2007-11-21  199  	int err = 0;
9996508b3 Ian Molton        2009-12-01  200  	int bytes_read, len;
3a2c0ba5a Rusty Russell     2014-12-08  201  	struct hwrng *rng;
844dd05fe Michael Buesch    2006-06-26  202  
844dd05fe Michael Buesch    2006-06-26  203  	while (size) {
3a2c0ba5a Rusty Russell     2014-12-08  204  		rng = get_current_rng();
3a2c0ba5a Rusty Russell     2014-12-08  205  		if (IS_ERR(rng)) {
3a2c0ba5a Rusty Russell     2014-12-08  206  			err = PTR_ERR(rng);
844dd05fe Michael Buesch    2006-06-26  207  			goto out;
9996508b3 Ian Molton        2009-12-01  208  		}
3a2c0ba5a Rusty Russell     2014-12-08  209  		if (!rng) {
844dd05fe Michael Buesch    2006-06-26  210  			err = -ENODEV;
3a2c0ba5a Rusty Russell     2014-12-08  211  			goto out;
844dd05fe Michael Buesch    2006-06-26  212  		}
984e976f5 Patrick McHardy   2007-11-21  213  
1ab87298c Jiri Slaby        2015-11-27  214  		if (mutex_lock_interruptible(&reading_mutex)) {
1ab87298c Jiri Slaby        2015-11-27  215  			err = -ERESTARTSYS;
1ab87298c Jiri Slaby        2015-11-27  216  			goto out_put;
1ab87298c Jiri Slaby        2015-11-27  217  		}
9996508b3 Ian Molton        2009-12-01  218  		if (!data_avail) {
3a2c0ba5a Rusty Russell     2014-12-08  219  			bytes_read = rng_get_data(rng, rng_buffer,
f7f154f12 Rusty Russell     2013-03-05  220  				rng_buffer_size(),
9996508b3 Ian Molton        2009-12-01 @221  				!(filp->f_flags & O_NONBLOCK));
893f11286 Ralph Wuerthner   2008-04-17  222  			if (bytes_read < 0) {
893f11286 Ralph Wuerthner   2008-04-17  223  				err = bytes_read;
9372b35e1 Rusty Russell     2014-12-08  224  				goto out_unlock_reading;
9996508b3 Ian Molton        2009-12-01  225  			}
9996508b3 Ian Molton        2009-12-01  226  			data_avail = bytes_read;
893f11286 Ralph Wuerthner   2008-04-17  227  		}
844dd05fe Michael Buesch    2006-06-26  228  
9996508b3 Ian Molton        2009-12-01  229  		if (!data_avail) {
9996508b3 Ian Molton        2009-12-01  230  			if (filp->f_flags & O_NONBLOCK) {
9996508b3 Ian Molton        2009-12-01  231  				err = -EAGAIN;
9372b35e1 Rusty Russell     2014-12-08  232  				goto out_unlock_reading;
9996508b3 Ian Molton        2009-12-01  233  			}
9996508b3 Ian Molton        2009-12-01  234  		} else {
9996508b3 Ian Molton        2009-12-01  235  			len = data_avail;
9996508b3 Ian Molton        2009-12-01  236  			if (len > size)
9996508b3 Ian Molton        2009-12-01  237  				len = size;
9996508b3 Ian Molton        2009-12-01  238  
9996508b3 Ian Molton        2009-12-01  239  			data_avail -= len;
9996508b3 Ian Molton        2009-12-01  240  
9996508b3 Ian Molton        2009-12-01  241  			if (copy_to_user(buf + ret, rng_buffer + data_avail,
9996508b3 Ian Molton        2009-12-01  242  								len)) {
844dd05fe Michael Buesch    2006-06-26  243  				err = -EFAULT;
9372b35e1 Rusty Russell     2014-12-08  244  				goto out_unlock_reading;
9996508b3 Ian Molton        2009-12-01  245  			}
9996508b3 Ian Molton        2009-12-01  246  
9996508b3 Ian Molton        2009-12-01  247  			size -= len;
9996508b3 Ian Molton        2009-12-01  248  			ret += len;
844dd05fe Michael Buesch    2006-06-26  249  		}
844dd05fe Michael Buesch    2006-06-26  250  
9372b35e1 Rusty Russell     2014-12-08  251  		mutex_unlock(&reading_mutex);
3a2c0ba5a Rusty Russell     2014-12-08  252  		put_rng(rng);
9996508b3 Ian Molton        2009-12-01  253  
844dd05fe Michael Buesch    2006-06-26  254  		if (need_resched())
844dd05fe Michael Buesch    2006-06-26  255  			schedule_timeout_interruptible(1);
9996508b3 Ian Molton        2009-12-01  256  
9996508b3 Ian Molton        2009-12-01  257  		if (signal_pending(current)) {
844dd05fe Michael Buesch    2006-06-26  258  			err = -ERESTARTSYS;
844dd05fe Michael Buesch    2006-06-26  259  			goto out;
844dd05fe Michael Buesch    2006-06-26  260  		}
9996508b3 Ian Molton        2009-12-01  261  	}
844dd05fe Michael Buesch    2006-06-26  262  out:
844dd05fe Michael Buesch    2006-06-26  263  	return ret ? : err;
3a2c0ba5a Rusty Russell     2014-12-08  264  
9372b35e1 Rusty Russell     2014-12-08  265  out_unlock_reading:
9372b35e1 Rusty Russell     2014-12-08  266  	mutex_unlock(&reading_mutex);
1ab87298c Jiri Slaby        2015-11-27  267  out_put:
3a2c0ba5a Rusty Russell     2014-12-08  268  	put_rng(rng);
3a2c0ba5a Rusty Russell     2014-12-08  269  	goto out;
844dd05fe Michael Buesch    2006-06-26  270  }
844dd05fe Michael Buesch    2006-06-26  271  
62322d255 Arjan van de Ven  2006-07-03 @272  static const struct file_operations rng_chrdev_ops = {
844dd05fe Michael Buesch    2006-06-26 @273  	.owner		= THIS_MODULE,
844dd05fe Michael Buesch    2006-06-26 @274  	.open		= rng_dev_open,
844dd05fe Michael Buesch    2006-06-26 @275  	.read		= rng_dev_read,
6038f373a Arnd Bergmann     2010-08-15 @276  	.llseek		= noop_llseek,
844dd05fe Michael Buesch    2006-06-26  277  };
844dd05fe Michael Buesch    2006-06-26  278  
0daa7a0af Takashi Iwai      2015-02-02  279  static const struct attribute_group *rng_dev_groups[];

:::::: The code at line 169 was first introduced by commit
:::::: 844dd05fec172d98b0dacecd9b9e9f6595204c13 [PATCH] Add new generic HW RNG core

:::::: TO: Michael Buesch <mb@bu3sch.de>
:::::: CC: Linus Torvalds <torvalds@g5.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--wRRV7LY7NUeQGEoC
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--wRRV7LY7NUeQGEoC--
