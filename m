From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 44/45] drivers/crypto/caam/caamrng.c:293:2:
 warning: passing argument 1 of 'caam_init_rng' from incompatible pointer
 type
Date: Fri, 21 Mar 2014 21:34:10 +0800
Message-ID: <20140321133410.GB24469@gondor.apana.org.au>
References: <53229935.5J5QhGQU1gPnTTIo%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nitesh Lal <NiteshNarayanLal@freescale.com>, kbuild-all@01.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ruchika Gupta <ruchika.gupta@freescale.com>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38806 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761016AbaCUNeR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Mar 2014 09:34:17 -0400
Content-Disposition: inline
In-Reply-To: <53229935.5J5QhGQU1gPnTTIo%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 14, 2014 at 01:52:53PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   26a05489ee0eb2a69b729438e63b1038b472fa57
> commit: 6e4e603a9a99c6e27a74c1a813a7c751d85a721d [44/45] crypto: caam - Dynamic memory allocation for caam_rng_ctx object
> config: make ARCH=powerpc corenet32_smp_defconfig
> 
> All warnings:
> 
>    drivers/crypto/caam/caamrng.c: In function 'caam_rng_init':
> >> drivers/crypto/caam/caamrng.c:293:2: warning: passing argument 1 of 'caam_init_rng' from incompatible pointer type [enabled by default]
>      caam_init_rng(&rng_ctx, dev);
>      ^
>    drivers/crypto/caam/caamrng.c:258:13: note: expected 'struct caam_rng_ctx *' but argument is of type 'struct caam_rng_ctx **'
>     static void caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
>                 ^
> 
> vim +/caam_init_rng +293 drivers/crypto/caam/caamrng.c
> 
> e24f7c9e Yuan Kang     2012-06-22  277  	hwrng_unregister(&caam_rng);
> 6e4e603a Nitesh Lal    2014-03-07  278  	kfree(rng_ctx);
> e24f7c9e Yuan Kang     2012-06-22  279  }
> e24f7c9e Yuan Kang     2012-06-22  280  
> e24f7c9e Yuan Kang     2012-06-22  281  static int __init caam_rng_init(void)
> e24f7c9e Yuan Kang     2012-06-22  282  {
> cfc6f11b Ruchika Gupta 2013-10-25  283  	struct device *dev;
> e24f7c9e Yuan Kang     2012-06-22  284  
> cfc6f11b Ruchika Gupta 2013-10-25  285  	dev = caam_jr_alloc();
> cfc6f11b Ruchika Gupta 2013-10-25  286  	if (IS_ERR(dev)) {
> cfc6f11b Ruchika Gupta 2013-10-25  287  		pr_err("Job Ring Device allocation for transform failed\n");
> cfc6f11b Ruchika Gupta 2013-10-25  288  		return PTR_ERR(dev);
> cfc6f11b Ruchika Gupta 2013-10-25  289  	}
> 6e4e603a Nitesh Lal    2014-03-07  290  	rng_ctx = kmalloc(sizeof(struct caam_rng_ctx), GFP_DMA);
> 6e4e603a Nitesh Lal    2014-03-07  291  	if (!rng_ctx)
> 6e4e603a Nitesh Lal    2014-03-07  292  		return -ENOMEM;
> cfc6f11b Ruchika Gupta 2013-10-25 @293  	caam_init_rng(&rng_ctx, dev);
> e24f7c9e Yuan Kang     2012-06-22  294  
> cfc6f11b Ruchika Gupta 2013-10-25  295  	dev_info(dev, "registering rng-caam\n");
> e24f7c9e Yuan Kang     2012-06-22  296  	return hwrng_register(&caam_rng);
> e24f7c9e Yuan Kang     2012-06-22  297  }
> e24f7c9e Yuan Kang     2012-06-22  298  
> e24f7c9e Yuan Kang     2012-06-22  299  module_init(caam_rng_init);
> e24f7c9e Yuan Kang     2012-06-22  300  module_exit(caam_rng_exit);
> e24f7c9e Yuan Kang     2012-06-22  301  
> 
> :::::: The code at line 293 was first introduced by commit
> :::::: cfc6f11b768a9bdda17aac280474de1f0e344fea crypto: caam - Modify the interface layers to use JR API's
> 
> :::::: TO: Ruchika Gupta <ruchika.gupta@freescale.com>
> :::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

I've add the following patch to fix this.

commit 85e0da925b2ddbf39a6cefb4e02ad51d0a0912c0
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Mar 21 21:32:54 2014 +0800

    crypto: caam - Fix first parameter to caam_init_rng
    
    Found by the kbuild test robot, the first argument to caam_init_rng
    has a spurious ampersand.
    
    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 403d8d5..3529b54 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -290,7 +290,7 @@ static int __init caam_rng_init(void)
 	rng_ctx = kmalloc(sizeof(struct caam_rng_ctx), GFP_DMA);
 	if (!rng_ctx)
 		return -ENOMEM;
-	caam_init_rng(&rng_ctx, dev);
+	caam_init_rng(rng_ctx, dev);
 
 	dev_info(dev, "registering rng-caam\n");
 	return hwrng_register(&caam_rng);

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
