Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987A6C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78F4920693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbfG3Mim (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:38:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38319 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbfG3Mil (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 08:38:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D6DD308FB93;
        Tue, 30 Jul 2019 12:38:41 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 096BB5D6B2;
        Tue, 30 Jul 2019 12:38:39 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC 2/3] crypto/sha256: Export a sha256_{init,update,final}_direct() API
Date:   Tue, 30 Jul 2019 14:38:34 +0200
Message-Id: <20190730123835.10283-3-hdegoede@redhat.com>
In-Reply-To: <20190730123835.10283-1-hdegoede@redhat.com>
References: <20190730123835.10283-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 30 Jul 2019 12:38:41 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

This provides a very simple interface for kernel code to use to do
synchronous, unaccelerated, virtual-address-based SHA256 hashing
without needing to create a crypto context.

Subsequent patches will make this work without building the crypto
core and will use to avoid making BPF-based tracing depend on
crypto.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 crypto/sha256_generic.c      | 31 ++++++++++++++++++++++++++-----
 include/crypto/sha.h         | 24 ++++++++++++++++++++++++
 include/crypto/sha256_base.h | 13 -------------
 3 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index b7502a96a0d4..4e7265e0b40d 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -235,24 +235,45 @@ static void sha256_generic_block_fn(struct sha256_state *sst, u8 const *src,
 	}
 }
 
+void sha256_update_direct(struct sha256_state *sctx, const u8 *data,
+			  unsigned int len)
+{
+	__sha256_base_do_update(sctx, data, len, sha256_generic_block_fn);
+}
+EXPORT_SYMBOL(sha256_update_direct);
+
 int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
-	return sha256_base_do_update(desc, data, len, sha256_generic_block_fn);
+	sha256_update_direct(shash_desc_ctx(desc), data, len);
+	return 0;
 }
 EXPORT_SYMBOL(crypto_sha256_update);
 
 static int sha256_final(struct shash_desc *desc, u8 *out)
 {
-	sha256_base_do_finalize(desc, sha256_generic_block_fn);
-	return sha256_base_finish(desc, out);
+	__sha256_final_direct(shash_desc_ctx(desc),
+			      crypto_shash_digestsize(desc->tfm), out);
+	return 0;
 }
 
+void __sha256_final_direct(struct sha256_state *sctx, unsigned int digest_size,
+			   u8 *out)
+{
+	sha256_do_finalize_direct(sctx, sha256_generic_block_fn);
+	__sha256_base_finish(sctx, digest_size, out);
+}
+EXPORT_SYMBOL(sha256_final_direct);
+
 int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *hash)
 {
-	sha256_base_do_update(desc, data, len, sha256_generic_block_fn);
-	return sha256_final(desc, hash);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+
+	sha256_update_direct(sctx, data, len);
+	__sha256_final_direct(sctx, digest_size, hash);
+	return 0;
 }
 EXPORT_SYMBOL(crypto_sha256_finup);
 
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 8a46202b1857..737a553afd27 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -93,6 +93,30 @@ struct sha512_state {
 	u8 buf[SHA512_BLOCK_SIZE];
 };
 
+static inline void sha256_init_direct(struct sha256_state *sctx)
+{
+	sctx->state[0] = SHA256_H0;
+	sctx->state[1] = SHA256_H1;
+	sctx->state[2] = SHA256_H2;
+	sctx->state[3] = SHA256_H3;
+	sctx->state[4] = SHA256_H4;
+	sctx->state[5] = SHA256_H5;
+	sctx->state[6] = SHA256_H6;
+	sctx->state[7] = SHA256_H7;
+	sctx->count = 0;
+}
+
+extern void sha256_update_direct(struct sha256_state *sctx, const u8 *data,
+				 unsigned int len);
+
+extern void __sha256_final_direct(struct sha256_state *sctx,
+				  unsigned int digest_size, u8 *out);
+
+static inline void sha256_final_direct(struct sha256_state *sctx, u8 *out)
+{
+	__sha256_final_direct(sctx, SHA256_DIGEST_SIZE, out);
+}
+
 struct shash_desc;
 
 extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
index 5317946a813a..0883928f87dd 100644
--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -34,19 +34,6 @@ static inline int sha224_base_init(struct shash_desc *desc)
 	return 0;
 }
 
-static inline void sha256_init_direct(struct sha256_state *sctx)
-{
-	sctx->state[0] = SHA256_H0;
-	sctx->state[1] = SHA256_H1;
-	sctx->state[2] = SHA256_H2;
-	sctx->state[3] = SHA256_H3;
-	sctx->state[4] = SHA256_H4;
-	sctx->state[5] = SHA256_H5;
-	sctx->state[6] = SHA256_H6;
-	sctx->state[7] = SHA256_H7;
-	sctx->count = 0;
-}
-
 static inline int sha256_base_init(struct shash_desc *desc)
 {
 	sha256_init_direct(shash_desc_ctx(desc));
-- 
2.21.0

