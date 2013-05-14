From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 2/13] undefined reference to
 `crypto_shash_update'
Date: Tue, 14 May 2013 12:22:59 +0800
Message-ID: <20130514042259.GA20298@gondor.apana.org.au>
References: <5191b967.2QgbDFN8LBbn0tI6%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>, kbuild-all@01.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:59495 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751034Ab3ENEXG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 May 2013 00:23:06 -0400
Content-Disposition: inline
In-Reply-To: <5191b967.2QgbDFN8LBbn0tI6%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 14, 2013 at 12:11:19PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   b9d0b63e0349515938e42f85f9e7a1742ae919d1
> commit: f8ef7e01fe6ec9ffc0cef1044d385acb590ac106 [2/13] crypto: crct10dif - Wrap crc_t10dif function all to use crypto transform framework
> config: i386-randconfig-x10-0513 (attached as .config)
> 
> All error/warnings:
> 
>    lib/built-in.o: In function `crc_t10dif':
> >> (.text+0x1047a): undefined reference to `crypto_shash_update'
>    lib/built-in.o: In function `crc_t10dif_update_lib':
> >> (.text+0x104b6): undefined reference to `crypto_alloc_shash'
>    lib/built-in.o: In function `crc_t10dif_update_lib':
> >> (.text+0x1052e): undefined reference to `crypto_destroy_tfm'
>    lib/built-in.o: In function `crc_t10dif_update_lib':
> >> (.text+0x10540): undefined reference to `crypto_destroy_tfm'
>    lib/built-in.o: In function `crc_t10dif_mod_fini':
> >> crc-t10dif.c:(.exit.text+0x10): undefined reference to `crypto_destroy_tfm'

Thanks.  Should be fixed by the following patch which I've foloded
into the original changes.

diff --git a/lib/Kconfig b/lib/Kconfig
index fe01d41..0cee056 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -63,6 +63,7 @@ config CRC16
 
 config CRC_T10DIF
 	tristate "CRC calculation for the T10 Data Integrity Field"
+	select CRYPTO_CRCT10DIF
 	help
 	  This option is only needed if a module that's not in the
 	  kernel tree needs to calculate CRC checks for use with the

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
