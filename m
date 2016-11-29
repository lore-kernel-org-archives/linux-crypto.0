From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-next: build failure after merge of the crypto tree
Date: Tue, 29 Nov 2016 16:43:33 +0800
Message-ID: <20161129084333.GA5705@gondor.apana.org.au>
References: <20161129115529.41f9f0b5@canb.auug.org.au>
 <20161129070840.GA5113@gondor.apana.org.au>
 <DB4PR04MB084718B8EB90B061EA144C02988D0@DB4PR04MB0847.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60269 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753935AbcK2IoR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 03:44:17 -0500
Content-Disposition: inline
In-Reply-To: <DB4PR04MB084718B8EB90B061EA144C02988D0@DB4PR04MB0847.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 29, 2016 at 08:34:08AM +0000, Horia Geantă wrote:
>
> > Fixes: da40e7a4ba4d ("crypto: aes-ce - Convert to skcipher")
> > Fixes: 211f41af534a ("crypto: aesbs - Convert to skcipher")
> The fix for this commit is missing.
> CRYPTO_AES_ARM_BS also needs to select CRYPTO_SIMD.

Thanks.  I'll add this patch on top:

---8<---
Subject: crypto: arm/aes - Add missing SIMD select for aesbs

This patch adds one more missing SIMD select for AES_ARM_BS.  It
also changes selects on ALGAPI to BLKCIPHER.

Fixes: 211f41af534a ("crypto: aesbs - Convert to skcipher")
Reported-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 8134888..dd90e38 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -88,9 +88,9 @@ config CRYPTO_AES_ARM
 config CRYPTO_AES_ARM_BS
 	tristate "Bit sliced AES using NEON instructions"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_ALGAPI
 	select CRYPTO_AES_ARM
-	select CRYPTO_ABLK_HELPER
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_SIMD
 	help
 	  Use a faster and more secure NEON based implementation of AES in CBC,
 	  CTR and XTS modes
@@ -104,7 +104,7 @@ config CRYPTO_AES_ARM_BS
 config CRYPTO_AES_ARM_CE
 	tristate "Accelerated AES using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 	select CRYPTO_SIMD
 	help
 	  Use an implementation of AES in CBC, CTR and XTS modes that uses
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
