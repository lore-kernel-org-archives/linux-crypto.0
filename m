From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 2/13] crct10dif.c:undefined reference to
 `crypto_register_shash'
Date: Tue, 14 May 2013 14:56:07 +0800
Message-ID: <20130514065607.GA20953@gondor.apana.org.au>
References: <5191d74e.8BmjhOylQ1jkg8HR%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>, kbuild-all@01.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:47018 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751177Ab3ENG4N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 May 2013 02:56:13 -0400
Content-Disposition: inline
In-Reply-To: <5191d74e.8BmjhOylQ1jkg8HR%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 14, 2013 at 02:18:54PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   78cdfaf27bf1a3d5c8c9907c72f1a32dafe0ec04
> commit: e3a0f01adfccf883a14df83f81a2b37d03d6926d [2/13] crypto: crct10dif - Wrap crc_t10dif function all to use crypto transform framework
> config: i386-randconfig-x10-0513 (attached as .config)
> 
> All error/warnings:
> 
>    crypto/built-in.o: In function `crct10dif_mod_init':
> >> crct10dif.c:(.init.text+0x9): undefined reference to `crypto_register_shash'
>    crypto/built-in.o: In function `crct10dif_mod_fini':
> >> crct10dif.c:(.exit.text+0x9): undefined reference to `crypto_unregister_shash'
>    lib/built-in.o: In function `crc_t10dif':
>    (.text+0x1047a): undefined reference to `crypto_shash_update'
>    lib/built-in.o: In function `crc_t10dif_update_lib':
>    (.text+0x104b6): undefined reference to `crypto_alloc_shash'
>    lib/built-in.o: In function `crc_t10dif_update_lib':
>    (.text+0x1052e): undefined reference to `crypto_destroy_tfm'
>    lib/built-in.o: In function `crc_t10dif_update_lib':
>    (.text+0x10540): undefined reference to `crypto_destroy_tfm'
>    lib/built-in.o: In function `crc_t10dif_mod_fini':
>    crc-t10dif.c:(.exit.text+0x10): undefined reference to `crypto_destroy_tfm'

Oops, I forgot to take out the dependency.

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 68de618..d1ca631 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -378,7 +378,6 @@ config CRYPTO_CRC32_PCLMUL
 
 config CRYPTO_CRCT10DIF
 	tristate "CRCT10DIF algorithm"
-	depends on CRC_T10DIF
 	select CRYPTO_HASH
 	help
 	  CRC T10 Data Integrity Field computation is being cast as

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
