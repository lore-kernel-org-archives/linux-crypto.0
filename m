Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A3CC5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D1AC2247C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215826;
	bh=oY5bChmb31BnZHHggHNCbZqt2aBSQf4ihex8je/iPcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oFta8wfCf72VZTBaIbJM5olvYzaflCi/a9fIF+4qzYv7bhTya7CUnt73/wGBw6fp5
	 G4xMfhpBZFJAqcJwsNsAs9c/BJtjJ01d6AgIVDVFsCsAakOVL3Ptl+Cb3i2DCP2uvi
	 L7mH07igSe4I5hO5Be2ndqTRTcXgZq7Zy3DBp+T8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732343AbfKHMXp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfKHMXp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:45 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0745C2247A;
        Fri,  8 Nov 2019 12:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215824;
        bh=oY5bChmb31BnZHHggHNCbZqt2aBSQf4ihex8je/iPcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TL4i8kp7ke2jL0rJ3vY2voqkbGTKWTjHh4ZradCGn5msCC7v/7AwyJlJafuDIRZbV
         b2+kUS0pB4U+xiUxifIUBWzy/pCIe7of/tZhx4x41DuBs8vt5PF8cvuN+raFCBhkqu
         uXV9FxqLxg35FjaPJt/Uvo92e62Dz5fFPZT9kZNQ=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 15/34] crypto: poly1305 - expose init/update/final library interface
Date:   Fri,  8 Nov 2019 13:22:21 +0100
Message-Id: <20191108122240.28479-16-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose the existing generic Poly1305 code via a init/update/final
library interface so that callers are not required to go through
the crypto API's shash abstraction to access it. At the same time,
make some preparations so that the library implementation can be
superseded by an accelerated arch-specific version in the future.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/poly1305_generic.c | 22 +-----
 include/crypto/poly1305.h | 38 +++++++++-
 lib/crypto/Kconfig        | 26 +++++++
 lib/crypto/poly1305.c     | 74 ++++++++++++++++++++
 4 files changed, 138 insertions(+), 22 deletions(-)

diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index f3fcd9578a47..afe9a9e576dd 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -85,31 +85,11 @@ EXPORT_SYMBOL_GPL(crypto_poly1305_update);
 int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-	__le32 digest[4];
-	u64 f = 0;
 
 	if (unlikely(!dctx->sset))
 		return -ENOKEY;
 
-	if (unlikely(dctx->buflen)) {
-		dctx->buf[dctx->buflen++] = 1;
-		memset(dctx->buf + dctx->buflen, 0,
-		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_core_blocks(&dctx->h, dctx->r, dctx->buf, 1, 0);
-	}
-
-	poly1305_core_emit(&dctx->h, digest);
-
-	/* mac = (h + s) % (2^128) */
-	f = (f >> 32) + le32_to_cpu(digest[0]) + dctx->s[0];
-	put_unaligned_le32(f, dst + 0);
-	f = (f >> 32) + le32_to_cpu(digest[1]) + dctx->s[1];
-	put_unaligned_le32(f, dst + 4);
-	f = (f >> 32) + le32_to_cpu(digest[2]) + dctx->s[2];
-	put_unaligned_le32(f, dst + 8);
-	f = (f >> 32) + le32_to_cpu(digest[3]) + dctx->s[3];
-	put_unaligned_le32(f, dst + 12);
-
+	poly1305_final_generic(dctx, dst);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_poly1305_final);
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index 36b5886cb50c..74c6e1cd73ee 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -35,7 +35,43 @@ struct poly1305_desc_ctx {
 	/* accumulator */
 	struct poly1305_state h;
 	/* key */
-	struct poly1305_key r[1];
+	struct poly1305_key r[CONFIG_CRYPTO_LIB_POLY1305_RSIZE];
 };
 
+void poly1305_init_arch(struct poly1305_desc_ctx *desc, const u8 *key);
+void poly1305_init_generic(struct poly1305_desc_ctx *desc, const u8 *key);
+
+static inline void poly1305_init(struct poly1305_desc_ctx *desc, const u8 *key)
+{
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
+		poly1305_init_arch(desc, key);
+	else
+		poly1305_init_generic(desc, key);
+}
+
+void poly1305_update_arch(struct poly1305_desc_ctx *desc, const u8 *src,
+			  unsigned int nbytes);
+void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
+			     unsigned int nbytes);
+
+static inline void poly1305_update(struct poly1305_desc_ctx *desc,
+				   const u8 *src, unsigned int nbytes)
+{
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
+		poly1305_update_arch(desc, src, nbytes);
+	else
+		poly1305_update_generic(desc, src, nbytes);
+}
+
+void poly1305_final_arch(struct poly1305_desc_ctx *desc, u8 *digest);
+void poly1305_final_generic(struct poly1305_desc_ctx *desc, u8 *digest);
+
+static inline void poly1305_final(struct poly1305_desc_ctx *desc, u8 *digest)
+{
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
+		poly1305_final_arch(desc, digest);
+	else
+		poly1305_final_generic(desc, digest);
+}
+
 #endif
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index c4882d29879e..a731ea36bd5c 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -37,8 +37,34 @@ config CRYPTO_LIB_CHACHA
 config CRYPTO_LIB_DES
 	tristate
 
+config CRYPTO_LIB_POLY1305_RSIZE
+	int
+	default 1
+
+config CRYPTO_ARCH_HAVE_LIB_POLY1305
+	tristate
+	help
+	  Declares whether the architecture provides an arch-specific
+	  accelerated implementation of the Poly1305 library interface,
+	  either builtin or as a module.
+
 config CRYPTO_LIB_POLY1305_GENERIC
 	tristate
+	help
+	  This symbol can be depended upon by arch implementations of the
+	  Poly1305 library interface that require the generic code as a
+	  fallback, e.g., for SIMD implementations. If no arch specific
+	  implementation is enabled, this implementation serves the users
+	  of CRYPTO_LIB_POLY1305.
+
+config CRYPTO_LIB_POLY1305
+	tristate "Poly1305 library interface"
+	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
+	select CRYPTO_LIB_POLY1305_GENERIC if CRYPTO_ARCH_HAVE_LIB_POLY1305=n
+	help
+	  Enable the Poly1305 library interface. This interface may be fulfilled
+	  by either the generic implementation or an arch-specific one, if one
+	  is available and enabled.
 
 config CRYPTO_LIB_SHA256
 	tristate
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index f019a57dbc1b..32ec293c65ae 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -154,5 +154,79 @@ void poly1305_core_emit(const struct poly1305_state *state, void *dst)
 }
 EXPORT_SYMBOL_GPL(poly1305_core_emit);
 
+void poly1305_init_generic(struct poly1305_desc_ctx *desc, const u8 *key)
+{
+	poly1305_core_setkey(desc->r, key);
+	desc->s[0] = get_unaligned_le32(key + 16);
+	desc->s[1] = get_unaligned_le32(key + 20);
+	desc->s[2] = get_unaligned_le32(key + 24);
+	desc->s[3] = get_unaligned_le32(key + 28);
+	poly1305_core_init(&desc->h);
+	desc->buflen = 0;
+	desc->sset = true;
+	desc->rset = 1;
+}
+EXPORT_SYMBOL_GPL(poly1305_init_generic);
+
+void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
+			     unsigned int nbytes)
+{
+	unsigned int bytes;
+
+	if (unlikely(desc->buflen)) {
+		bytes = min(nbytes, POLY1305_BLOCK_SIZE - desc->buflen);
+		memcpy(desc->buf + desc->buflen, src, bytes);
+		src += bytes;
+		nbytes -= bytes;
+		desc->buflen += bytes;
+
+		if (desc->buflen == POLY1305_BLOCK_SIZE) {
+			poly1305_core_blocks(&desc->h, desc->r, desc->buf, 1, 1);
+			desc->buflen = 0;
+		}
+	}
+
+	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
+		poly1305_core_blocks(&desc->h, desc->r, src,
+				     nbytes / POLY1305_BLOCK_SIZE, 1);
+		src += nbytes - (nbytes % POLY1305_BLOCK_SIZE);
+		nbytes %= POLY1305_BLOCK_SIZE;
+	}
+
+	if (unlikely(nbytes)) {
+		desc->buflen = nbytes;
+		memcpy(desc->buf, src, nbytes);
+	}
+}
+EXPORT_SYMBOL_GPL(poly1305_update_generic);
+
+void poly1305_final_generic(struct poly1305_desc_ctx *desc, u8 *dst)
+{
+	__le32 digest[4];
+	u64 f = 0;
+
+	if (unlikely(desc->buflen)) {
+		desc->buf[desc->buflen++] = 1;
+		memset(desc->buf + desc->buflen, 0,
+		       POLY1305_BLOCK_SIZE - desc->buflen);
+		poly1305_core_blocks(&desc->h, desc->r, desc->buf, 1, 0);
+	}
+
+	poly1305_core_emit(&desc->h, digest);
+
+	/* mac = (h + s) % (2^128) */
+	f = (f >> 32) + le32_to_cpu(digest[0]) + desc->s[0];
+	put_unaligned_le32(f, dst + 0);
+	f = (f >> 32) + le32_to_cpu(digest[1]) + desc->s[1];
+	put_unaligned_le32(f, dst + 4);
+	f = (f >> 32) + le32_to_cpu(digest[2]) + desc->s[2];
+	put_unaligned_le32(f, dst + 8);
+	f = (f >> 32) + le32_to_cpu(digest[3]) + desc->s[3];
+	put_unaligned_le32(f, dst + 12);
+
+	*desc = (struct poly1305_desc_ctx){};
+}
+EXPORT_SYMBOL_GPL(poly1305_final_generic);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-- 
2.20.1

