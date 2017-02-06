From: kbuild test robot <lkp@intel.com>
Subject: Re: crypto: atmel - Fix authenc compile test warnings
Date: Tue, 7 Feb 2017 00:58:58 +0800
Message-ID: <201702070003.jTWzwRF2%fengguang.wu@intel.com>
References: <20170206090340.GA9531@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170206090340.GA9531@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

[auto build test WARNING on cryptodev/master]
[also build test WARNING on v4.10-rc7 next-20170206]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Herbert-Xu/crypto-atmel-Fix-authenc-compile-test-warnings/20170206-171201
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> drivers/crypto/atmel-tdes.c:157:25: sparse: incompatible types in comparison expression (different type sizes)
   drivers/crypto/atmel-tdes.c:528:25: sparse: incompatible types in comparison expression (different type sizes)
   drivers/crypto/atmel-tdes.c:529:25: sparse: incompatible types in comparison expression (different type sizes)
   In file included from drivers/crypto/atmel-tdes.c:17:0:
   drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_sg_copy':
   include/linux/kernel.h:753:16: warning: comparison of distinct pointer types lacks a cast
     (void) (&min1 == &min2);   \
                   ^
   include/linux/kernel.h:756:2: note: in expansion of macro '__min'
     __min(typeof(x), typeof(y),   \
     ^~~~~
   drivers/crypto/atmel-tdes.c:157:11: note: in expansion of macro 'min'
      count = min(count, buflen);
              ^~~
   In file included from include/linux/printk.h:6:0,
                    from include/linux/kernel.h:13,
                    from drivers/crypto/atmel-tdes.c:17:
   drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_crypt_pdc_stop':
   include/linux/kern_levels.h:4:18: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'size_t {aka long unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:10:18: note: in expansion of macro 'KERN_SOH'
    #define KERN_ERR KERN_SOH "3" /* error conditions */
                     ^~~~~~~~
   include/linux/printk.h:292:9: note: in expansion of macro 'KERN_ERR'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~
   drivers/crypto/atmel-tdes.c:339:4: note: in expansion of macro 'pr_err'
       pr_err("not all data converted: %u\n", count);
       ^~~~~~
   drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_buff_init':
   drivers/crypto/atmel-tdes.c:364:26: warning: format '%d' expects argument of type 'int', but argument 3 has type 'size_t {aka long unsigned int}' [-Wformat=]
      dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
                             ^
   drivers/crypto/atmel-tdes.c:372:26: warning: format '%d' expects argument of type 'int', but argument 3 has type 'size_t {aka long unsigned int}' [-Wformat=]
      dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
                             ^
   In file included from drivers/crypto/atmel-tdes.c:17:0:
   drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_crypt_start':
   include/linux/kernel.h:753:16: warning: comparison of distinct pointer types lacks a cast
     (void) (&min1 == &min2);   \
                   ^
   include/linux/kernel.h:756:2: note: in expansion of macro '__min'
     __min(typeof(x), typeof(y),   \
     ^~~~~
   drivers/crypto/atmel-tdes.c:528:11: note: in expansion of macro 'min'
      count = min(dd->total, sg_dma_len(dd->in_sg));
              ^~~
   include/linux/kernel.h:753:16: warning: comparison of distinct pointer types lacks a cast
     (void) (&min1 == &min2);   \
                   ^
   include/linux/kernel.h:756:2: note: in expansion of macro '__min'
     __min(typeof(x), typeof(y),   \
     ^~~~~
   drivers/crypto/atmel-tdes.c:529:11: note: in expansion of macro 'min'
      count = min(count, sg_dma_len(dd->out_sg));
              ^~~
   In file included from include/linux/printk.h:6:0,
                    from include/linux/kernel.h:13,
                    from drivers/crypto/atmel-tdes.c:17:
   drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_crypt_dma_stop':
   include/linux/kern_levels.h:4:18: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'size_t {aka long unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:10:18: note: in expansion of macro 'KERN_SOH'
    #define KERN_ERR KERN_SOH "3" /* error conditions */
                     ^~~~~~~~
   include/linux/printk.h:292:9: note: in expansion of macro 'KERN_ERR'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~
   drivers/crypto/atmel-tdes.c:664:5: note: in expansion of macro 'pr_err'
        pr_err("not all data converted: %u\n", count);
        ^~~~~~

vim +157 drivers/crypto/atmel-tdes.c

13802005 Nicolas Royer 2012-07-01  141  	struct list_head	dev_list;
13802005 Nicolas Royer 2012-07-01  142  	spinlock_t		lock;
13802005 Nicolas Royer 2012-07-01  143  };
13802005 Nicolas Royer 2012-07-01  144  
13802005 Nicolas Royer 2012-07-01  145  static struct atmel_tdes_drv atmel_tdes = {
13802005 Nicolas Royer 2012-07-01  146  	.dev_list = LIST_HEAD_INIT(atmel_tdes.dev_list),
13802005 Nicolas Royer 2012-07-01  147  	.lock = __SPIN_LOCK_UNLOCKED(atmel_tdes.lock),
13802005 Nicolas Royer 2012-07-01  148  };
13802005 Nicolas Royer 2012-07-01  149  
13802005 Nicolas Royer 2012-07-01  150  static int atmel_tdes_sg_copy(struct scatterlist **sg, size_t *offset,
13802005 Nicolas Royer 2012-07-01  151  			void *buf, size_t buflen, size_t total, int out)
13802005 Nicolas Royer 2012-07-01  152  {
13802005 Nicolas Royer 2012-07-01  153  	unsigned int count, off = 0;
13802005 Nicolas Royer 2012-07-01  154  
13802005 Nicolas Royer 2012-07-01  155  	while (buflen && total) {
13802005 Nicolas Royer 2012-07-01  156  		count = min((*sg)->length - *offset, total);
13802005 Nicolas Royer 2012-07-01 @157  		count = min(count, buflen);
13802005 Nicolas Royer 2012-07-01  158  
13802005 Nicolas Royer 2012-07-01  159  		if (!count)
13802005 Nicolas Royer 2012-07-01  160  			return off;
13802005 Nicolas Royer 2012-07-01  161  
13802005 Nicolas Royer 2012-07-01  162  		scatterwalk_map_and_copy(buf + off, *sg, *offset, count, out);
13802005 Nicolas Royer 2012-07-01  163  
13802005 Nicolas Royer 2012-07-01  164  		off += count;
13802005 Nicolas Royer 2012-07-01  165  		buflen -= count;

:::::: The code at line 157 was first introduced by commit
:::::: 13802005d8f2db244ec1f5d7f6923de8f7a463db crypto: atmel - add Atmel DES/TDES driver

:::::: TO: Nicolas Royer <nicolas@eukrea.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
