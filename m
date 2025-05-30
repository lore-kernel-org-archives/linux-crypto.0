Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B542F235079;
	Fri, 30 May 2025 16:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748621423; cv=none; b=tD3veXPr459F4PDJb6RogKsLa4JDwwGYtdRUNCdU+zHlmCqBOL7byPCiQeT47vnIAXKYYg1t4Tmk6dNsVyXOkvU6llRqqP6m2KDi+r0nNWcUaf5X5QRwy3E5XLd5vCmIXNBwCOLFWUrwDY8hidX/XbOOMWF+xRYkRNlkCo5714E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748621423; c=relaxed/simple;
	bh=HrdqjSxm8EooDpiNXtzK0jxkcPuOsCkYBWG/5ijU9Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CD5FzBMT3OOlMC/qo6HRwEZh/R+yhW5bU8F1Bf7ad39t9Hl9VSHtgajF4AgWUKIBe5XW7x1K4UiY1Rc4F0S1Oc/byQWOY/JBVXQL85BLNQ4dk5TPKLy5pS5DRVvwyXZfuKAWs9fcUd/24NBoU+/Igw/Q7tw7v5gtUg54FO+1pLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rENlBUYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rENlBUYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5F3C4CEE9;
	Fri, 30 May 2025 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748621423;
	bh=HrdqjSxm8EooDpiNXtzK0jxkcPuOsCkYBWG/5ijU9Vs=;
	h=From:To:Cc:Subject:Date:From;
	b=rENlBUYwKHO69VBi1tQWKmiFmZKnZkVvbn5HBMT3R64ZgNRBclAKQkB/9eMyW/pKk
	 uohi9UOcylwxV1RCNjbGiCFdkUBAipd/F5KH1jfJyZjnBBb6B9aGp0EblFKvPX2KHR
	 hdJ7E1KATkw9G7mzMT7ugxwZ2pC5nk/TBrgJ7sAgaE4NSMI5X8bm/2EcYjMOx79mSC
	 lrudjoTV35igerXVBEFaThQ7dsDxrM9DH36pFn1tktsxlfnOXDrfO6udw3u9WyvZh7
	 F/P864zWPv4vZ3QYq/1c361XXgW68Dlc7YXVY5xpBJ9Wce2ES+xewr3dL54PxwcCUn
	 HuG3XXOrGNAfw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto/crc32: register only one shash_alg
Date: Fri, 30 May 2025 09:09:40 -0700
Message-ID: <20250530160940.12761-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Stop unnecessarily registering a "crc32-generic" shash_alg when a
"crc32-$(ARCH)" shash_alg is registered too.

While every algorithm does need to have a generic implementation to
ensure uniformity of support across platforms, that doesn't mean that we
need to make the generic implementation available through crypto_shash
when an optimized implementation is also available.

Registering the generic shash_alg did allow users of the crypto_shash or
crypto_ahash APIs to request the generic implementation specifically,
instead of an optimized one.  However, the only known use case for that
was the differential fuzz tests in crypto/testmgr.c.  Equivalent test
coverage is now provided by crc_kunit.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'm planning to take this through the crc tree.

 crypto/crc32.c | 69 ++++++++------------------------------------------
 1 file changed, 11 insertions(+), 58 deletions(-)

diff --git a/crypto/crc32.c b/crypto/crc32.c
index cc371d42601fd..b61d5663d0bac 100644
--- a/crypto/crc32.c
+++ b/crypto/crc32.c
@@ -57,33 +57,16 @@ static int crc32_init(struct shash_desc *desc)
 static int crc32_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
 	u32 *crcp = shash_desc_ctx(desc);
 
-	*crcp = crc32_le_base(*crcp, data, len);
-	return 0;
-}
-
-static int crc32_update_arch(struct shash_desc *desc, const u8 *data,
-			     unsigned int len)
-{
-	u32 *crcp = shash_desc_ctx(desc);
-
 	*crcp = crc32_le(*crcp, data, len);
 	return 0;
 }
 
 /* No final XOR 0xFFFFFFFF, like crc32_le */
-static int __crc32_finup(u32 *crcp, const u8 *data, unsigned int len,
-			 u8 *out)
-{
-	put_unaligned_le32(crc32_le_base(*crcp, data, len), out);
-	return 0;
-}
-
-static int __crc32_finup_arch(u32 *crcp, const u8 *data, unsigned int len,
-			      u8 *out)
+static int __crc32_finup(u32 *crcp, const u8 *data, unsigned int len, u8 *out)
 {
 	put_unaligned_le32(crc32_le(*crcp, data, len), out);
 	return 0;
 }
 
@@ -91,16 +74,10 @@ static int crc32_finup(struct shash_desc *desc, const u8 *data,
 		       unsigned int len, u8 *out)
 {
 	return __crc32_finup(shash_desc_ctx(desc), data, len, out);
 }
 
-static int crc32_finup_arch(struct shash_desc *desc, const u8 *data,
-		       unsigned int len, u8 *out)
-{
-	return __crc32_finup_arch(shash_desc_ctx(desc), data, len, out);
-}
-
 static int crc32_final(struct shash_desc *desc, u8 *out)
 {
 	u32 *crcp = shash_desc_ctx(desc);
 
 	put_unaligned_le32(*crcp, out);
@@ -111,72 +88,48 @@ static int crc32_digest(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
 	return __crc32_finup(crypto_shash_ctx(desc->tfm), data, len, out);
 }
 
-static int crc32_digest_arch(struct shash_desc *desc, const u8 *data,
-			     unsigned int len, u8 *out)
-{
-	return __crc32_finup_arch(crypto_shash_ctx(desc->tfm), data, len, out);
-}
-
-static struct shash_alg algs[] = {{
+static struct shash_alg alg = {
 	.setkey			= crc32_setkey,
 	.init			= crc32_init,
 	.update			= crc32_update,
 	.final			= crc32_final,
 	.finup			= crc32_finup,
 	.digest			= crc32_digest,
 	.descsize		= sizeof(u32),
 	.digestsize		= CHKSUM_DIGEST_SIZE,
 
 	.base.cra_name		= "crc32",
-	.base.cra_driver_name	= "crc32-generic",
 	.base.cra_priority	= 100,
 	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(u32),
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_init		= crc32_cra_init,
-}, {
-	.setkey			= crc32_setkey,
-	.init			= crc32_init,
-	.update			= crc32_update_arch,
-	.final			= crc32_final,
-	.finup			= crc32_finup_arch,
-	.digest			= crc32_digest_arch,
-	.descsize		= sizeof(u32),
-	.digestsize		= CHKSUM_DIGEST_SIZE,
-
-	.base.cra_name		= "crc32",
-	.base.cra_driver_name	= "crc32-" __stringify(ARCH),
-	.base.cra_priority	= 150,
-	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(u32),
-	.base.cra_module	= THIS_MODULE,
-	.base.cra_init		= crc32_cra_init,
-}};
-
-static int num_algs;
+};
 
 static int __init crc32_mod_init(void)
 {
-	/* register the arch flavor only if it differs from the generic one */
-	num_algs = 1 + ((crc32_optimizations() & CRC32_LE_OPTIMIZATION) != 0);
+	const char *driver_name =
+		(crc32_optimizations() & CRC32_LE_OPTIMIZATION) ?
+			"crc32-" __stringify(ARCH) :
+			"crc32-generic";
+
+	strscpy(alg.base.cra_driver_name, driver_name, CRYPTO_MAX_ALG_NAME);
 
-	return crypto_register_shashes(algs, num_algs);
+	return crypto_register_shash(&alg);
 }
 
 static void __exit crc32_mod_fini(void)
 {
-	crypto_unregister_shashes(algs, num_algs);
+	crypto_unregister_shash(&alg);
 }
 
 module_init(crc32_mod_init);
 module_exit(crc32_mod_fini);
 
 MODULE_AUTHOR("Alexander Boyko <alexander_boyko@xyratex.com>");
 MODULE_DESCRIPTION("CRC32 calculations wrapper for lib/crc32");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CRYPTO("crc32");
-MODULE_ALIAS_CRYPTO("crc32-generic");

base-commit: f66bc387efbee59978e076ce9bf123ac353b389c
-- 
2.49.0

