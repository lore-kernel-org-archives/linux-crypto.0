From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Duplicated module names
Date: Fri, 29 Jan 2016 18:20:17 +0800
Message-ID: <20160129102017.GA17353@gondor.apana.org.au>
References: <87h9hxrkvs.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lucas.de.marchi@gmail.com, samson.yeung@oracle.com,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, airlied@linux.ie,
	tomi.valkeinen@ti.com, kyungmin.park@samsung.com,
	gregkh@linuxfoundation.org, lgirdwood@gmail.com, broonie@kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45933 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbcA2KVT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 05:21:19 -0500
Content-Disposition: inline
In-Reply-To: <87h9hxrkvs.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> I think we could rename it to crypto_crc32, but I don't think it's the
> only one.  Marco, I think depmod should probably FAIL if two modules
> have the same name, which would at least find such problems.

This patch renames it to crc32_generic.

---8<---
Subject: crypto: crc32 - Rename generic implementation

The generic crc32 implementation is currently called crc32.  This
is a problem because it clashes with the lib implementation of crc32.

This patch renames the crypto crc32 to crc32_generic so that it is
consistent with crc32c.  An alias for the driver is also added.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Makefile b/crypto/Makefile
index ffe18c9..059de1b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -100,7 +100,7 @@ obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
-obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
+obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
 obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_common.o crct10dif_generic.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
diff --git a/crypto/crc32.c b/crypto/crc32_generic.c
similarity index 98%
rename from crypto/crc32.c
rename to crypto/crc32_generic.c
index 187ded2..aa2a25f 100644
--- a/crypto/crc32.c
+++ b/crypto/crc32_generic.c
@@ -131,7 +131,7 @@ static struct shash_alg alg = {
 	.digestsize	= CHKSUM_DIGEST_SIZE,
 	.base		= {
 		.cra_name		= "crc32",
-		.cra_driver_name	= "crc32-table",
+		.cra_driver_name	= "crc32-generic",
 		.cra_priority		= 100,
 		.cra_blocksize		= CHKSUM_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(u32),
@@ -157,3 +157,4 @@ MODULE_AUTHOR("Alexander Boyko <alexander_boyko@xyratex.com>");
 MODULE_DESCRIPTION("CRC32 calculations wrapper for lib/crc32");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CRYPTO("crc32");
+MODULE_ALIAS_CRYPTO("crc32-generic");
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
