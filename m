Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC64CDB483
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjJSFyP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjJSFyO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB29FE
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A4BC433C9
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694852;
        bh=GdWvwxtyPRuZpFGX2Ept5lwoZL6uqZnLAjrR6ZlAoHQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hHx70JNvyiSRekfPyCK10QDoaEgC8JbeeeiC7agLALKoqGSyPfGFMJWUExTrcFn9N
         i48omFfyrtTu37AJidLPdYPMx5JGeGvH0u+ZUOOS9qXmvrx87GUxRmQLLeICtl0T67
         AkXt9FY4cZBt9h3DAtIEydd52pS2H1vCHTs/omVJsvOeTSIhrCumz7yFAto8JEZDAQ
         yE+Hj6FKb1tFm3PKucr4qWn015dylcDqWXgUR/0j+TKkvLyA4VOY6Q40+rsy8SmE+R
         BD9ERX1MXhe0YO9cNTvBrw2WP/L7pNf1bt6CfoQHESDSmqldvzQZ/kAAjCmCfwoFj/
         9jlx3TMgXDArA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 01/17] crypto: sparc/crc32c - stop using the shash alignmask
Date:   Wed, 18 Oct 2023 22:53:27 -0700
Message-ID: <20231019055343.588846-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

As far as I can tell, "crc32c-sparc64" is the only "shash" algorithm in
the kernel that sets a nonzero alignmask and actually relies on it to
get the crypto API to align the inputs and outputs.  This capability is
not really useful, though.  To unblock removing the support for
alignmask from shash_alg, this patch updates crc32c-sparc64 to no longer
use the alignmask.  This means doing 8-byte alignment of the data when
doing an update, using get_unaligned_le32() when setting a non-default
initial CRC, and using put_unaligned_le32() to output the final CRC.

Partially tested with:

    export ARCH=sparc64 CROSS_COMPILE=sparc64-linux-gnu-
    make sparc64_defconfig
    echo CONFIG_CRYPTO_CRC32C_SPARC64=y >> .config
    echo '# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set' >> .config
    echo CONFIG_DEBUG_KERNEL=y >> .config
    echo CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y >> .config
    make olddefconfig
    make -j$(getconf _NPROCESSORS_ONLN)
    qemu-system-sparc64 -kernel arch/sparc/boot/image  -nographic

However, qemu doesn't actually support the sparc CRC32C instructions, so
for the test I temporarily replaced crc32c_sparc64() with __crc32c_le()
and made sparc64_has_crc32c_opcode() always return true.  So essentially
I tested the glue code, not the actual SPARC part which is unchanged.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/sparc/crypto/crc32c_glue.c | 45 ++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/sparc/crypto/crc32c_glue.c b/arch/sparc/crypto/crc32c_glue.c
index 82efb7f81c288..688db0dcb97d9 100644
--- a/arch/sparc/crypto/crc32c_glue.c
+++ b/arch/sparc/crypto/crc32c_glue.c
@@ -13,97 +13,101 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/crc32.h>
 
 #include <crypto/internal/hash.h>
 
 #include <asm/pstate.h>
 #include <asm/elf.h>
+#include <asm/unaligned.h>
 
 #include "opcodes.h"
 
 /*
  * Setting the seed allows arbitrary accumulators and flexible XOR policy
  * If your algorithm starts with ~0, then XOR with ~0 before you set
  * the seed.
  */
 static int crc32c_sparc64_setkey(struct crypto_shash *hash, const u8 *key,
 				 unsigned int keylen)
 {
 	u32 *mctx = crypto_shash_ctx(hash);
 
 	if (keylen != sizeof(u32))
 		return -EINVAL;
-	*mctx = le32_to_cpup((__le32 *)key);
+	*mctx = get_unaligned_le32(key);
 	return 0;
 }
 
 static int crc32c_sparc64_init(struct shash_desc *desc)
 {
 	u32 *mctx = crypto_shash_ctx(desc->tfm);
 	u32 *crcp = shash_desc_ctx(desc);
 
 	*crcp = *mctx;
 
 	return 0;
 }
 
 extern void crc32c_sparc64(u32 *crcp, const u64 *data, unsigned int len);
 
-static void crc32c_compute(u32 *crcp, const u64 *data, unsigned int len)
+static u32 crc32c_compute(u32 crc, const u8 *data, unsigned int len)
 {
-	unsigned int asm_len;
-
-	asm_len = len & ~7U;
-	if (asm_len) {
-		crc32c_sparc64(crcp, data, asm_len);
-		data += asm_len / 8;
-		len -= asm_len;
+	unsigned int n = -(uintptr_t)data & 7;
+
+	if (n) {
+		/* Data isn't 8-byte aligned.  Align it. */
+		n = min(n, len);
+		crc = __crc32c_le(crc, data, n);
+		data += n;
+		len -= n;
+	}
+	n = len & ~7U;
+	if (n) {
+		crc32c_sparc64(&crc, (const u64 *)data, n);
+		data += n;
+		len -= n;
 	}
 	if (len)
-		*crcp = __crc32c_le(*crcp, (const unsigned char *) data, len);
+		crc = __crc32c_le(crc, data, len);
+	return crc;
 }
 
 static int crc32c_sparc64_update(struct shash_desc *desc, const u8 *data,
 				 unsigned int len)
 {
 	u32 *crcp = shash_desc_ctx(desc);
 
-	crc32c_compute(crcp, (const u64 *) data, len);
-
+	*crcp = crc32c_compute(*crcp, data, len);
 	return 0;
 }
 
-static int __crc32c_sparc64_finup(u32 *crcp, const u8 *data, unsigned int len,
-				  u8 *out)
+static int __crc32c_sparc64_finup(const u32 *crcp, const u8 *data,
+				  unsigned int len, u8 *out)
 {
-	u32 tmp = *crcp;
-
-	crc32c_compute(&tmp, (const u64 *) data, len);
-
-	*(__le32 *) out = ~cpu_to_le32(tmp);
+	put_unaligned_le32(~crc32c_compute(*crcp, data, len), out);
 	return 0;
 }
 
 static int crc32c_sparc64_finup(struct shash_desc *desc, const u8 *data,
 				unsigned int len, u8 *out)
 {
 	return __crc32c_sparc64_finup(shash_desc_ctx(desc), data, len, out);
 }
 
 static int crc32c_sparc64_final(struct shash_desc *desc, u8 *out)
 {
 	u32 *crcp = shash_desc_ctx(desc);
 
-	*(__le32 *) out = ~cpu_to_le32p(crcp);
+	put_unaligned_le32(~*crcp, out);
 	return 0;
 }
 
 static int crc32c_sparc64_digest(struct shash_desc *desc, const u8 *data,
 				 unsigned int len, u8 *out)
 {
 	return __crc32c_sparc64_finup(crypto_shash_ctx(desc->tfm), data, len,
 				      out);
 }
 
@@ -128,21 +132,20 @@ static struct shash_alg alg = {
 	.digest			=	crc32c_sparc64_digest,
 	.descsize		=	sizeof(u32),
 	.digestsize		=	CHKSUM_DIGEST_SIZE,
 	.base			=	{
 		.cra_name		=	"crc32c",
 		.cra_driver_name	=	"crc32c-sparc64",
 		.cra_priority		=	SPARC_CR_OPCODE_PRIORITY,
 		.cra_flags		=	CRYPTO_ALG_OPTIONAL_KEY,
 		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
 		.cra_ctxsize		=	sizeof(u32),
-		.cra_alignmask		=	7,
 		.cra_module		=	THIS_MODULE,
 		.cra_init		=	crc32c_sparc64_cra_init,
 	}
 };
 
 static bool __init sparc64_has_crc32c_opcode(void)
 {
 	unsigned long cfr;
 
 	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
-- 
2.42.0

