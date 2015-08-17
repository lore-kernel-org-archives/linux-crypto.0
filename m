From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 139/146] crypto/aead.c:770: undefined
 reference to `crypto_get_default_null_skcipher'
Date: Mon, 17 Aug 2015 17:45:27 +0800
Message-ID: <20150817094527.GA29021@gondor.apana.org.au>
References: <201508171715.GXkQw0mE%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46434 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbbHQJpe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 05:45:34 -0400
Content-Disposition: inline
In-Reply-To: <201508171715.GXkQw0mE%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 17, 2015 at 05:27:16PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   58268e58e63550e24dee7d6125078ab2a2a22272
> commit: 149a39717dcce3b6ba15285c9fc86e4423437e05 [139/146] crypto: aead - Add type-safe geniv init/exit helpers
> config: microblaze-mmu_defconfig (attached as .config)
> reproduce:
>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout 149a39717dcce3b6ba15285c9fc86e4423437e05
>   # save the attached .config to linux build tree
>   make.cross ARCH=microblaze 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    crypto/built-in.o: In function `aead_init_geniv':
> >> crypto/aead.c:770: undefined reference to `crypto_get_default_null_skcipher'
> >> crypto/aead.c:790: undefined reference to `crypto_put_default_null_skcipher'
>    crypto/built-in.o: In function `aead_exit_geniv':
>    crypto/aead.c:800: undefined reference to `crypto_put_default_null_skcipher'

Oops, this patch should fix the problem.

---8<---
Subject: crypto: null - Use NULL2 in Makefile

The Kconfig option NULL2 has been added as CRYPTO_MANAGER now
depends indirectly on NULL2.  However, the Makefile was not updated
to use the new option, resulting in potential build failures when
only NULL2 is enabled.

Fixes: 149a39717dcc ("crypto: aead - Add type-safe geniv init/exit helpers")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index a16a7e7..f6229ae 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -46,7 +46,7 @@ obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
-obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o
+obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
 obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
 obj-$(CONFIG_CRYPTO_RMD128) += rmd128.o
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
