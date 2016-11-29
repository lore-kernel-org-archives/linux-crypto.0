From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-next: build failure after merge of the crypto tree
Date: Tue, 29 Nov 2016 15:08:40 +0800
Message-ID: <20161129070840.GA5113__30600.3541955308$1480406954$gmane$org@gondor.apana.org.au>
References: <20161129115529.41f9f0b5@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36858 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755221AbcK2IJK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 03:09:10 -0500
Received: from [192.168.128.4] (helo=gondobar)
        by fornost.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1cBdTO-0007WB-BL
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2016 19:09:06 +1100
Received: from herbert by gondobar with local (Exim 4.84_2)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1cBdTJ-0001Rs-9v
        for linux-crypto@vger.kernel.org; Tue, 29 Nov 2016 16:09:01 +0800
Content-Disposition: inline
In-Reply-To: <20161129115529.41f9f0b5@canb.auug.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 29, 2016 at 11:55:29AM +1100, Stephen Rothwell wrote:
> Hi Herbert,
> 
> After merging the crypto tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> ERROR: "simd_skcipher_free" [arch/arm/crypto/aes-arm-ce.ko] undefined!
> ERROR: "simd_skcipher_create_compat" [arch/arm/crypto/aes-arm-ce.ko] undefined!
> ERROR: "simd_skcipher_free" [arch/arm/crypto/aes-arm-bs.ko] undefined!
> ERROR: "simd_skcipher_create_compat" [arch/arm/crypto/aes-arm-bs.ko] undefined!
> 
> Caused by commits
> 
>   da40e7a4ba4d ("crypto: aes-ce - Convert to skcipher")
>   211f41af534a ("crypto: aesbs - Convert to skcipher")
> 
> Missing dependencies?
> 
> I have used the crypto tree from next-20161128 for today.

Indeed.  This patch should fix the problem.

---8<---
Subject: crypto: arm/aes - Select SIMD in Kconfig

The skcipher conversion for ARM missed the select on CRYPTO_SIMD,
causing build failures if SIMD was not otherwise enabled.

Fixes: da40e7a4ba4d ("crypto: aes-ce - Convert to skcipher")
Fixes: 211f41af534a ("crypto: aesbs - Convert to skcipher")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 27ed1b1..8134888 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -105,7 +105,7 @@ config CRYPTO_AES_ARM_CE
 	tristate "Accelerated AES using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_ALGAPI
-	select CRYPTO_ABLK_HELPER
+	select CRYPTO_SIMD
 	help
 	  Use an implementation of AES in CBC, CTR and XTS modes that uses
 	  ARMv8 Crypto Extensions
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 5f4a617..c5ce39c 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -48,14 +48,14 @@ config CRYPTO_AES_ARM64_CE_BLK
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES_ARM64_CE
-	select CRYPTO_ABLK_HELPER
+	select CRYPTO_SIMD
 
 config CRYPTO_AES_ARM64_NEON_BLK
 	tristate "AES in ECB/CBC/CTR/XTS modes using NEON instructions"
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES
-	select CRYPTO_ABLK_HELPER
+	select CRYPTO_SIMD
 
 config CRYPTO_CRC32_ARM64
 	tristate "CRC32 and CRC32C using optional ARMv8 instructions"
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
