From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: authenc - Add Kconfig dependency on CRYPTO_NULL
Date: Tue, 4 Aug 2015 21:23:14 +0800
Message-ID: <20150804132314.GA30001@gondor.apana.org.au>
References: <201508042101.3gC1H0dE%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43747 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933244AbbHDNXX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 09:23:23 -0400
Content-Disposition: inline
In-Reply-To: <201508042101.3gC1H0dE%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 04, 2015 at 09:20:03PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   a4198fd4b487afc60810f5a12b994721df220022
> commit: 92d95ba91772279b6ef9c6e09661f67abcf27259 [91/97] crypto: authenc - Convert to new AEAD interface
> config: i386-randconfig-i0-201531 (attached as .config)
> reproduce:
>   git checkout 92d95ba91772279b6ef9c6e09661f67abcf27259
>   # save the attached .config to linux build tree
>   make ARCH=i386 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    crypto/built-in.o: In function `crypto_authenc_exit_tfm':
> >> authenc.c:(.text+0x19141): undefined reference to `crypto_put_default_null_skcipher'
>    crypto/built-in.o: In function `crypto_authenc_init_tfm':
> >> authenc.c:(.text+0x19198): undefined reference to `crypto_get_default_null_skcipher'

Thanks!

---8<---
CRYPTO_AUTHENC needs to depend on CRYPTO_NULL as authenc uses
null for copying.

Reported-by: Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 354bb69..ac7cc62 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -200,6 +200,7 @@ config CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_HASH
+	select CRYPTO_NULL
 	help
 	  Authenc: Combined mode wrapper for IPsec.
 	  This is required for IPSec.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
