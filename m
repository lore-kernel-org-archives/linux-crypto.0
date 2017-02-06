From: kbuild test robot <lkp@intel.com>
Subject: Re: crypto: atmel - Fix authenc compile test warnings
Date: Mon, 6 Feb 2017 20:54:46 +0800
Message-ID: <201702062049.67jAS5S9%fengguang.wu@intel.com>
References: <20170206090340.GA9531@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
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


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Herbert,

[auto build test WARNING on cryptodev/master]
[also build test WARNING on v4.10-rc7 next-20170206]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Herbert-Xu/crypto-atmel-Fix-authenc-compile-test-warnings/20170206-171201
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: ia64-allmodconfig (attached as .config)
compiler: ia64-linux-gcc (GCC) 6.2.0
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=ia64 

All warnings (new ones prefixed by >>):

   In file included from drivers/crypto/atmel-tdes.c:17:0:
   drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_sg_copy':
   include/linux/kernel.h:753:16: warning: comparison of distinct pointer types lacks a cast
     (void) (&min1 == &min2);   \
                   ^
   include/linux/kernel.h:756:2: note: in expansion of macro '__min'
     __min(typeof(x), typeof(y),   \
     ^~~~~
>> drivers/crypto/atmel-tdes.c:157:11: note: in expansion of macro 'min'
      count = min(count, buflen);
              ^~~
   In file included from include/linux/printk.h:6:0,
                    from include/linux/kernel.h:13,
                    from drivers/crypto/atmel-tdes.c:17:
   drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_crypt_pdc_stop':
>> include/linux/kern_levels.h:4:18: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'size_t {aka long unsigned int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:10:18: note: in expansion of macro 'KERN_SOH'
    #define KERN_ERR KERN_SOH "3" /* error conditions */
                     ^~~~~~~~
   include/linux/printk.h:292:9: note: in expansion of macro 'KERN_ERR'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~
>> drivers/crypto/atmel-tdes.c:339:4: note: in expansion of macro 'pr_err'
       pr_err("not all data converted: %u\n", count);
       ^~~~~~
   drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_buff_init':
>> drivers/crypto/atmel-tdes.c:364:26: warning: format '%d' expects argument of type 'int', but argument 3 has type 'size_t {aka long unsigned int}' [-Wformat=]
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
>> include/linux/kern_levels.h:4:18: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'size_t {aka long unsigned int}' [-Wformat=]
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

vim +/min +157 drivers/crypto/atmel-tdes.c

13802005 Nicolas Royer  2012-07-01   11   * by the Free Software Foundation.
13802005 Nicolas Royer  2012-07-01   12   *
13802005 Nicolas Royer  2012-07-01   13   * Some ideas are from omap-aes.c drivers.
13802005 Nicolas Royer  2012-07-01   14   */
13802005 Nicolas Royer  2012-07-01   15  
13802005 Nicolas Royer  2012-07-01   16  
13802005 Nicolas Royer  2012-07-01  @17  #include <linux/kernel.h>
13802005 Nicolas Royer  2012-07-01   18  #include <linux/module.h>
13802005 Nicolas Royer  2012-07-01   19  #include <linux/slab.h>
13802005 Nicolas Royer  2012-07-01   20  #include <linux/err.h>
13802005 Nicolas Royer  2012-07-01   21  #include <linux/clk.h>
13802005 Nicolas Royer  2012-07-01   22  #include <linux/io.h>
13802005 Nicolas Royer  2012-07-01   23  #include <linux/hw_random.h>
13802005 Nicolas Royer  2012-07-01   24  #include <linux/platform_device.h>
13802005 Nicolas Royer  2012-07-01   25  
13802005 Nicolas Royer  2012-07-01   26  #include <linux/device.h>
13802005 Nicolas Royer  2012-07-01   27  #include <linux/init.h>
13802005 Nicolas Royer  2012-07-01   28  #include <linux/errno.h>
13802005 Nicolas Royer  2012-07-01   29  #include <linux/interrupt.h>
13802005 Nicolas Royer  2012-07-01   30  #include <linux/irq.h>
13802005 Nicolas Royer  2012-07-01   31  #include <linux/scatterlist.h>
13802005 Nicolas Royer  2012-07-01   32  #include <linux/dma-mapping.h>
84c8976b Nicolas Ferre  2013-10-15   33  #include <linux/of_device.h>
13802005 Nicolas Royer  2012-07-01   34  #include <linux/delay.h>
13802005 Nicolas Royer  2012-07-01   35  #include <linux/crypto.h>
13802005 Nicolas Royer  2012-07-01   36  #include <linux/cryptohash.h>
13802005 Nicolas Royer  2012-07-01   37  #include <crypto/scatterwalk.h>
13802005 Nicolas Royer  2012-07-01   38  #include <crypto/algapi.h>
13802005 Nicolas Royer  2012-07-01   39  #include <crypto/des.h>
13802005 Nicolas Royer  2012-07-01   40  #include <crypto/hash.h>
13802005 Nicolas Royer  2012-07-01   41  #include <crypto/internal/hash.h>
1f858040 Nicolas Royer  2013-02-20   42  #include <linux/platform_data/crypto-atmel.h>
13802005 Nicolas Royer  2012-07-01   43  #include "atmel-tdes-regs.h"
13802005 Nicolas Royer  2012-07-01   44  
13802005 Nicolas Royer  2012-07-01   45  /* TDES flags  */
1f858040 Nicolas Royer  2013-02-20   46  #define TDES_FLAGS_MODE_MASK		0x00ff
13802005 Nicolas Royer  2012-07-01   47  #define TDES_FLAGS_ENCRYPT	BIT(0)
13802005 Nicolas Royer  2012-07-01   48  #define TDES_FLAGS_CBC		BIT(1)
13802005 Nicolas Royer  2012-07-01   49  #define TDES_FLAGS_CFB		BIT(2)
13802005 Nicolas Royer  2012-07-01   50  #define TDES_FLAGS_CFB8		BIT(3)
13802005 Nicolas Royer  2012-07-01   51  #define TDES_FLAGS_CFB16	BIT(4)
13802005 Nicolas Royer  2012-07-01   52  #define TDES_FLAGS_CFB32	BIT(5)
1f858040 Nicolas Royer  2013-02-20   53  #define TDES_FLAGS_CFB64	BIT(6)
1f858040 Nicolas Royer  2013-02-20   54  #define TDES_FLAGS_OFB		BIT(7)
13802005 Nicolas Royer  2012-07-01   55  
13802005 Nicolas Royer  2012-07-01   56  #define TDES_FLAGS_INIT		BIT(16)
13802005 Nicolas Royer  2012-07-01   57  #define TDES_FLAGS_FAST		BIT(17)
13802005 Nicolas Royer  2012-07-01   58  #define TDES_FLAGS_BUSY		BIT(18)
1f858040 Nicolas Royer  2013-02-20   59  #define TDES_FLAGS_DMA		BIT(19)
13802005 Nicolas Royer  2012-07-01   60  
1f858040 Nicolas Royer  2013-02-20   61  #define ATMEL_TDES_QUEUE_LENGTH	50
13802005 Nicolas Royer  2012-07-01   62  
13802005 Nicolas Royer  2012-07-01   63  #define CFB8_BLOCK_SIZE		1
13802005 Nicolas Royer  2012-07-01   64  #define CFB16_BLOCK_SIZE	2
13802005 Nicolas Royer  2012-07-01   65  #define CFB32_BLOCK_SIZE	4
13802005 Nicolas Royer  2012-07-01   66  
1f858040 Nicolas Royer  2013-02-20   67  struct atmel_tdes_caps {
1f858040 Nicolas Royer  2013-02-20   68  	bool	has_dma;
1f858040 Nicolas Royer  2013-02-20   69  	u32		has_cfb_3keys;
1f858040 Nicolas Royer  2013-02-20   70  };
13802005 Nicolas Royer  2012-07-01   71  
13802005 Nicolas Royer  2012-07-01   72  struct atmel_tdes_dev;
13802005 Nicolas Royer  2012-07-01   73  
13802005 Nicolas Royer  2012-07-01   74  struct atmel_tdes_ctx {
13802005 Nicolas Royer  2012-07-01   75  	struct atmel_tdes_dev *dd;
13802005 Nicolas Royer  2012-07-01   76  
13802005 Nicolas Royer  2012-07-01   77  	int		keylen;
13802005 Nicolas Royer  2012-07-01   78  	u32		key[3*DES_KEY_SIZE / sizeof(u32)];
13802005 Nicolas Royer  2012-07-01   79  	unsigned long	flags;
1f858040 Nicolas Royer  2013-02-20   80  
1f858040 Nicolas Royer  2013-02-20   81  	u16		block_size;
13802005 Nicolas Royer  2012-07-01   82  };
13802005 Nicolas Royer  2012-07-01   83  
13802005 Nicolas Royer  2012-07-01   84  struct atmel_tdes_reqctx {
13802005 Nicolas Royer  2012-07-01   85  	unsigned long mode;
13802005 Nicolas Royer  2012-07-01   86  };
13802005 Nicolas Royer  2012-07-01   87  
1f858040 Nicolas Royer  2013-02-20   88  struct atmel_tdes_dma {
1f858040 Nicolas Royer  2013-02-20   89  	struct dma_chan			*chan;
1f858040 Nicolas Royer  2013-02-20   90  	struct dma_slave_config dma_conf;
1f858040 Nicolas Royer  2013-02-20   91  };
1f858040 Nicolas Royer  2013-02-20   92  
13802005 Nicolas Royer  2012-07-01   93  struct atmel_tdes_dev {
13802005 Nicolas Royer  2012-07-01   94  	struct list_head	list;
13802005 Nicolas Royer  2012-07-01   95  	unsigned long		phys_base;
13802005 Nicolas Royer  2012-07-01   96  	void __iomem		*io_base;
13802005 Nicolas Royer  2012-07-01   97  
13802005 Nicolas Royer  2012-07-01   98  	struct atmel_tdes_ctx	*ctx;
13802005 Nicolas Royer  2012-07-01   99  	struct device		*dev;
13802005 Nicolas Royer  2012-07-01  100  	struct clk			*iclk;
13802005 Nicolas Royer  2012-07-01  101  	int					irq;
13802005 Nicolas Royer  2012-07-01  102  
13802005 Nicolas Royer  2012-07-01  103  	unsigned long		flags;
13802005 Nicolas Royer  2012-07-01  104  	int			err;
13802005 Nicolas Royer  2012-07-01  105  
13802005 Nicolas Royer  2012-07-01  106  	spinlock_t		lock;
13802005 Nicolas Royer  2012-07-01  107  	struct crypto_queue	queue;
13802005 Nicolas Royer  2012-07-01  108  
13802005 Nicolas Royer  2012-07-01  109  	struct tasklet_struct	done_task;
13802005 Nicolas Royer  2012-07-01  110  	struct tasklet_struct	queue_task;
13802005 Nicolas Royer  2012-07-01  111  
13802005 Nicolas Royer  2012-07-01  112  	struct ablkcipher_request	*req;
13802005 Nicolas Royer  2012-07-01  113  	size_t				total;
13802005 Nicolas Royer  2012-07-01  114  
13802005 Nicolas Royer  2012-07-01  115  	struct scatterlist	*in_sg;
1f858040 Nicolas Royer  2013-02-20  116  	unsigned int		nb_in_sg;
13802005 Nicolas Royer  2012-07-01  117  	size_t				in_offset;
13802005 Nicolas Royer  2012-07-01  118  	struct scatterlist	*out_sg;
1f858040 Nicolas Royer  2013-02-20  119  	unsigned int		nb_out_sg;
13802005 Nicolas Royer  2012-07-01  120  	size_t				out_offset;
13802005 Nicolas Royer  2012-07-01  121  
13802005 Nicolas Royer  2012-07-01  122  	size_t	buflen;
13802005 Nicolas Royer  2012-07-01  123  	size_t	dma_size;
13802005 Nicolas Royer  2012-07-01  124  
13802005 Nicolas Royer  2012-07-01  125  	void	*buf_in;
13802005 Nicolas Royer  2012-07-01  126  	int		dma_in;
13802005 Nicolas Royer  2012-07-01  127  	dma_addr_t	dma_addr_in;
1f858040 Nicolas Royer  2013-02-20  128  	struct atmel_tdes_dma	dma_lch_in;
13802005 Nicolas Royer  2012-07-01  129  
13802005 Nicolas Royer  2012-07-01  130  	void	*buf_out;
13802005 Nicolas Royer  2012-07-01  131  	int		dma_out;
13802005 Nicolas Royer  2012-07-01  132  	dma_addr_t	dma_addr_out;
1f858040 Nicolas Royer  2013-02-20  133  	struct atmel_tdes_dma	dma_lch_out;
1f858040 Nicolas Royer  2013-02-20  134  
1f858040 Nicolas Royer  2013-02-20  135  	struct atmel_tdes_caps	caps;
1f858040 Nicolas Royer  2013-02-20  136  
1f858040 Nicolas Royer  2013-02-20  137  	u32	hw_version;
13802005 Nicolas Royer  2012-07-01  138  };
13802005 Nicolas Royer  2012-07-01  139  
13802005 Nicolas Royer  2012-07-01  140  struct atmel_tdes_drv {
13802005 Nicolas Royer  2012-07-01  141  	struct list_head	dev_list;
13802005 Nicolas Royer  2012-07-01  142  	spinlock_t		lock;
13802005 Nicolas Royer  2012-07-01  143  };
13802005 Nicolas Royer  2012-07-01  144  
13802005 Nicolas Royer  2012-07-01  145  static struct atmel_tdes_drv atmel_tdes = {
13802005 Nicolas Royer  2012-07-01  146  	.dev_list = LIST_HEAD_INIT(atmel_tdes.dev_list),
13802005 Nicolas Royer  2012-07-01  147  	.lock = __SPIN_LOCK_UNLOCKED(atmel_tdes.lock),
13802005 Nicolas Royer  2012-07-01  148  };
13802005 Nicolas Royer  2012-07-01  149  
13802005 Nicolas Royer  2012-07-01  150  static int atmel_tdes_sg_copy(struct scatterlist **sg, size_t *offset,
13802005 Nicolas Royer  2012-07-01  151  			void *buf, size_t buflen, size_t total, int out)
13802005 Nicolas Royer  2012-07-01  152  {
13802005 Nicolas Royer  2012-07-01  153  	unsigned int count, off = 0;
13802005 Nicolas Royer  2012-07-01  154  
13802005 Nicolas Royer  2012-07-01  155  	while (buflen && total) {
13802005 Nicolas Royer  2012-07-01  156  		count = min((*sg)->length - *offset, total);
13802005 Nicolas Royer  2012-07-01 @157  		count = min(count, buflen);
13802005 Nicolas Royer  2012-07-01  158  
13802005 Nicolas Royer  2012-07-01  159  		if (!count)
13802005 Nicolas Royer  2012-07-01  160  			return off;
13802005 Nicolas Royer  2012-07-01  161  
13802005 Nicolas Royer  2012-07-01  162  		scatterwalk_map_and_copy(buf + off, *sg, *offset, count, out);
13802005 Nicolas Royer  2012-07-01  163  
13802005 Nicolas Royer  2012-07-01  164  		off += count;
13802005 Nicolas Royer  2012-07-01  165  		buflen -= count;
13802005 Nicolas Royer  2012-07-01  166  		*offset += count;
13802005 Nicolas Royer  2012-07-01  167  		total -= count;
13802005 Nicolas Royer  2012-07-01  168  
13802005 Nicolas Royer  2012-07-01  169  		if (*offset == (*sg)->length) {
13802005 Nicolas Royer  2012-07-01  170  			*sg = sg_next(*sg);
13802005 Nicolas Royer  2012-07-01  171  			if (*sg)
13802005 Nicolas Royer  2012-07-01  172  				*offset = 0;
13802005 Nicolas Royer  2012-07-01  173  			else
13802005 Nicolas Royer  2012-07-01  174  				total = 0;
13802005 Nicolas Royer  2012-07-01  175  		}
13802005 Nicolas Royer  2012-07-01  176  	}
13802005 Nicolas Royer  2012-07-01  177  
13802005 Nicolas Royer  2012-07-01  178  	return off;
13802005 Nicolas Royer  2012-07-01  179  }
13802005 Nicolas Royer  2012-07-01  180  
13802005 Nicolas Royer  2012-07-01  181  static inline u32 atmel_tdes_read(struct atmel_tdes_dev *dd, u32 offset)
13802005 Nicolas Royer  2012-07-01  182  {
13802005 Nicolas Royer  2012-07-01  183  	return readl_relaxed(dd->io_base + offset);
13802005 Nicolas Royer  2012-07-01  184  }
13802005 Nicolas Royer  2012-07-01  185  
13802005 Nicolas Royer  2012-07-01  186  static inline void atmel_tdes_write(struct atmel_tdes_dev *dd,
13802005 Nicolas Royer  2012-07-01  187  					u32 offset, u32 value)
13802005 Nicolas Royer  2012-07-01  188  {
13802005 Nicolas Royer  2012-07-01  189  	writel_relaxed(value, dd->io_base + offset);
13802005 Nicolas Royer  2012-07-01  190  }
13802005 Nicolas Royer  2012-07-01  191  
13802005 Nicolas Royer  2012-07-01  192  static void atmel_tdes_write_n(struct atmel_tdes_dev *dd, u32 offset,
13802005 Nicolas Royer  2012-07-01  193  					u32 *value, int count)
13802005 Nicolas Royer  2012-07-01  194  {
13802005 Nicolas Royer  2012-07-01  195  	for (; count--; value++, offset += 4)
13802005 Nicolas Royer  2012-07-01  196  		atmel_tdes_write(dd, offset, *value);
13802005 Nicolas Royer  2012-07-01  197  }
13802005 Nicolas Royer  2012-07-01  198  
13802005 Nicolas Royer  2012-07-01  199  static struct atmel_tdes_dev *atmel_tdes_find_dev(struct atmel_tdes_ctx *ctx)
13802005 Nicolas Royer  2012-07-01  200  {
13802005 Nicolas Royer  2012-07-01  201  	struct atmel_tdes_dev *tdes_dd = NULL;
13802005 Nicolas Royer  2012-07-01  202  	struct atmel_tdes_dev *tmp;
13802005 Nicolas Royer  2012-07-01  203  
13802005 Nicolas Royer  2012-07-01  204  	spin_lock_bh(&atmel_tdes.lock);
13802005 Nicolas Royer  2012-07-01  205  	if (!ctx->dd) {
13802005 Nicolas Royer  2012-07-01  206  		list_for_each_entry(tmp, &atmel_tdes.dev_list, list) {
13802005 Nicolas Royer  2012-07-01  207  			tdes_dd = tmp;
13802005 Nicolas Royer  2012-07-01  208  			break;
13802005 Nicolas Royer  2012-07-01  209  		}
13802005 Nicolas Royer  2012-07-01  210  		ctx->dd = tdes_dd;
13802005 Nicolas Royer  2012-07-01  211  	} else {
13802005 Nicolas Royer  2012-07-01  212  		tdes_dd = ctx->dd;
13802005 Nicolas Royer  2012-07-01  213  	}
13802005 Nicolas Royer  2012-07-01  214  	spin_unlock_bh(&atmel_tdes.lock);
13802005 Nicolas Royer  2012-07-01  215  
13802005 Nicolas Royer  2012-07-01  216  	return tdes_dd;
13802005 Nicolas Royer  2012-07-01  217  }
13802005 Nicolas Royer  2012-07-01  218  
13802005 Nicolas Royer  2012-07-01  219  static int atmel_tdes_hw_init(struct atmel_tdes_dev *dd)
13802005 Nicolas Royer  2012-07-01  220  {
9d83d299 LABBE Corentin 2015-10-02  221  	int err;
9d83d299 LABBE Corentin 2015-10-02  222  
9d83d299 LABBE Corentin 2015-10-02  223  	err = clk_prepare_enable(dd->iclk);
9d83d299 LABBE Corentin 2015-10-02  224  	if (err)
9d83d299 LABBE Corentin 2015-10-02  225  		return err;
13802005 Nicolas Royer  2012-07-01  226  
13802005 Nicolas Royer  2012-07-01  227  	if (!(dd->flags & TDES_FLAGS_INIT)) {
13802005 Nicolas Royer  2012-07-01  228  		atmel_tdes_write(dd, TDES_CR, TDES_CR_SWRST);
13802005 Nicolas Royer  2012-07-01  229  		dd->flags |= TDES_FLAGS_INIT;
13802005 Nicolas Royer  2012-07-01  230  		dd->err = 0;
13802005 Nicolas Royer  2012-07-01  231  	}
13802005 Nicolas Royer  2012-07-01  232  
13802005 Nicolas Royer  2012-07-01  233  	return 0;
13802005 Nicolas Royer  2012-07-01  234  }
13802005 Nicolas Royer  2012-07-01  235  
1f858040 Nicolas Royer  2013-02-20  236  static inline unsigned int atmel_tdes_get_version(struct atmel_tdes_dev *dd)
1f858040 Nicolas Royer  2013-02-20  237  {
1f858040 Nicolas Royer  2013-02-20  238  	return atmel_tdes_read(dd, TDES_HW_VERSION) & 0x00000fff;
1f858040 Nicolas Royer  2013-02-20  239  }
1f858040 Nicolas Royer  2013-02-20  240  
1f858040 Nicolas Royer  2013-02-20  241  static void atmel_tdes_hw_version_init(struct atmel_tdes_dev *dd)
1f858040 Nicolas Royer  2013-02-20  242  {
1f858040 Nicolas Royer  2013-02-20  243  	atmel_tdes_hw_init(dd);
1f858040 Nicolas Royer  2013-02-20  244  
1f858040 Nicolas Royer  2013-02-20  245  	dd->hw_version = atmel_tdes_get_version(dd);
1f858040 Nicolas Royer  2013-02-20  246  
1f858040 Nicolas Royer  2013-02-20  247  	dev_info(dd->dev,
1f858040 Nicolas Royer  2013-02-20  248  			"version: 0x%x\n", dd->hw_version);
1f858040 Nicolas Royer  2013-02-20  249  
1f858040 Nicolas Royer  2013-02-20  250  	clk_disable_unprepare(dd->iclk);
1f858040 Nicolas Royer  2013-02-20  251  }
1f858040 Nicolas Royer  2013-02-20  252  
1f858040 Nicolas Royer  2013-02-20  253  static void atmel_tdes_dma_callback(void *data)
1f858040 Nicolas Royer  2013-02-20  254  {
1f858040 Nicolas Royer  2013-02-20  255  	struct atmel_tdes_dev *dd = data;
1f858040 Nicolas Royer  2013-02-20  256  
1f858040 Nicolas Royer  2013-02-20  257  	/* dma_lch_out - completed */
1f858040 Nicolas Royer  2013-02-20  258  	tasklet_schedule(&dd->done_task);
1f858040 Nicolas Royer  2013-02-20  259  }
1f858040 Nicolas Royer  2013-02-20  260  
13802005 Nicolas Royer  2012-07-01  261  static int atmel_tdes_write_ctrl(struct atmel_tdes_dev *dd)
13802005 Nicolas Royer  2012-07-01  262  {
13802005 Nicolas Royer  2012-07-01  263  	int err;
13802005 Nicolas Royer  2012-07-01  264  	u32 valcr = 0, valmr = TDES_MR_SMOD_PDC;
13802005 Nicolas Royer  2012-07-01  265  
13802005 Nicolas Royer  2012-07-01  266  	err = atmel_tdes_hw_init(dd);
13802005 Nicolas Royer  2012-07-01  267  
13802005 Nicolas Royer  2012-07-01  268  	if (err)
13802005 Nicolas Royer  2012-07-01  269  		return err;
13802005 Nicolas Royer  2012-07-01  270  
1f858040 Nicolas Royer  2013-02-20  271  	if (!dd->caps.has_dma)
1f858040 Nicolas Royer  2013-02-20  272  		atmel_tdes_write(dd, TDES_PTCR,
1f858040 Nicolas Royer  2013-02-20  273  			TDES_PTCR_TXTDIS | TDES_PTCR_RXTDIS);
13802005 Nicolas Royer  2012-07-01  274  
13802005 Nicolas Royer  2012-07-01  275  	/* MR register must be set before IV registers */
13802005 Nicolas Royer  2012-07-01  276  	if (dd->ctx->keylen > (DES_KEY_SIZE << 1)) {
13802005 Nicolas Royer  2012-07-01  277  		valmr |= TDES_MR_KEYMOD_3KEY;
13802005 Nicolas Royer  2012-07-01  278  		valmr |= TDES_MR_TDESMOD_TDES;
13802005 Nicolas Royer  2012-07-01  279  	} else if (dd->ctx->keylen > DES_KEY_SIZE) {
13802005 Nicolas Royer  2012-07-01  280  		valmr |= TDES_MR_KEYMOD_2KEY;
13802005 Nicolas Royer  2012-07-01  281  		valmr |= TDES_MR_TDESMOD_TDES;
13802005 Nicolas Royer  2012-07-01  282  	} else {
13802005 Nicolas Royer  2012-07-01  283  		valmr |= TDES_MR_TDESMOD_DES;
13802005 Nicolas Royer  2012-07-01  284  	}
13802005 Nicolas Royer  2012-07-01  285  
13802005 Nicolas Royer  2012-07-01  286  	if (dd->flags & TDES_FLAGS_CBC) {
13802005 Nicolas Royer  2012-07-01  287  		valmr |= TDES_MR_OPMOD_CBC;
13802005 Nicolas Royer  2012-07-01  288  	} else if (dd->flags & TDES_FLAGS_CFB) {
13802005 Nicolas Royer  2012-07-01  289  		valmr |= TDES_MR_OPMOD_CFB;
13802005 Nicolas Royer  2012-07-01  290  
13802005 Nicolas Royer  2012-07-01  291  		if (dd->flags & TDES_FLAGS_CFB8)
13802005 Nicolas Royer  2012-07-01  292  			valmr |= TDES_MR_CFBS_8b;
13802005 Nicolas Royer  2012-07-01  293  		else if (dd->flags & TDES_FLAGS_CFB16)
13802005 Nicolas Royer  2012-07-01  294  			valmr |= TDES_MR_CFBS_16b;
13802005 Nicolas Royer  2012-07-01  295  		else if (dd->flags & TDES_FLAGS_CFB32)
13802005 Nicolas Royer  2012-07-01  296  			valmr |= TDES_MR_CFBS_32b;
1f858040 Nicolas Royer  2013-02-20  297  		else if (dd->flags & TDES_FLAGS_CFB64)
1f858040 Nicolas Royer  2013-02-20  298  			valmr |= TDES_MR_CFBS_64b;
13802005 Nicolas Royer  2012-07-01  299  	} else if (dd->flags & TDES_FLAGS_OFB) {
13802005 Nicolas Royer  2012-07-01  300  		valmr |= TDES_MR_OPMOD_OFB;
13802005 Nicolas Royer  2012-07-01  301  	}
13802005 Nicolas Royer  2012-07-01  302  
13802005 Nicolas Royer  2012-07-01  303  	if ((dd->flags & TDES_FLAGS_ENCRYPT) || (dd->flags & TDES_FLAGS_OFB))
13802005 Nicolas Royer  2012-07-01  304  		valmr |= TDES_MR_CYPHER_ENC;
13802005 Nicolas Royer  2012-07-01  305  
13802005 Nicolas Royer  2012-07-01  306  	atmel_tdes_write(dd, TDES_CR, valcr);
13802005 Nicolas Royer  2012-07-01  307  	atmel_tdes_write(dd, TDES_MR, valmr);
13802005 Nicolas Royer  2012-07-01  308  
13802005 Nicolas Royer  2012-07-01  309  	atmel_tdes_write_n(dd, TDES_KEY1W1R, dd->ctx->key,
13802005 Nicolas Royer  2012-07-01  310  						dd->ctx->keylen >> 2);
13802005 Nicolas Royer  2012-07-01  311  
13802005 Nicolas Royer  2012-07-01  312  	if (((dd->flags & TDES_FLAGS_CBC) || (dd->flags & TDES_FLAGS_CFB) ||
13802005 Nicolas Royer  2012-07-01  313  		(dd->flags & TDES_FLAGS_OFB)) && dd->req->info) {
13802005 Nicolas Royer  2012-07-01  314  		atmel_tdes_write_n(dd, TDES_IV1R, dd->req->info, 2);
13802005 Nicolas Royer  2012-07-01  315  	}
13802005 Nicolas Royer  2012-07-01  316  
13802005 Nicolas Royer  2012-07-01  317  	return 0;
13802005 Nicolas Royer  2012-07-01  318  }
13802005 Nicolas Royer  2012-07-01  319  
1f858040 Nicolas Royer  2013-02-20  320  static int atmel_tdes_crypt_pdc_stop(struct atmel_tdes_dev *dd)
13802005 Nicolas Royer  2012-07-01  321  {
13802005 Nicolas Royer  2012-07-01  322  	int err = 0;
13802005 Nicolas Royer  2012-07-01  323  	size_t count;
13802005 Nicolas Royer  2012-07-01  324  
13802005 Nicolas Royer  2012-07-01  325  	atmel_tdes_write(dd, TDES_PTCR, TDES_PTCR_TXTDIS|TDES_PTCR_RXTDIS);
13802005 Nicolas Royer  2012-07-01  326  
13802005 Nicolas Royer  2012-07-01  327  	if (dd->flags & TDES_FLAGS_FAST) {
13802005 Nicolas Royer  2012-07-01  328  		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
13802005 Nicolas Royer  2012-07-01  329  		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
13802005 Nicolas Royer  2012-07-01  330  	} else {
13802005 Nicolas Royer  2012-07-01  331  		dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
13802005 Nicolas Royer  2012-07-01  332  					   dd->dma_size, DMA_FROM_DEVICE);
13802005 Nicolas Royer  2012-07-01  333  
13802005 Nicolas Royer  2012-07-01  334  		/* copy data */
13802005 Nicolas Royer  2012-07-01  335  		count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,
13802005 Nicolas Royer  2012-07-01  336  				dd->buf_out, dd->buflen, dd->dma_size, 1);
13802005 Nicolas Royer  2012-07-01  337  		if (count != dd->dma_size) {
13802005 Nicolas Royer  2012-07-01  338  			err = -EINVAL;
13802005 Nicolas Royer  2012-07-01 @339  			pr_err("not all data converted: %u\n", count);
13802005 Nicolas Royer  2012-07-01  340  		}
13802005 Nicolas Royer  2012-07-01  341  	}
13802005 Nicolas Royer  2012-07-01  342  

:::::: The code at line 157 was first introduced by commit
:::::: 13802005d8f2db244ec1f5d7f6923de8f7a463db crypto: atmel - add Atmel DES/TDES driver

:::::: TO: Nicolas Royer <nicolas@eukrea.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--PNTmBPCT7hxwcZjr
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
6P8B0yAEPMHGAgA=

--PNTmBPCT7hxwcZjr--
