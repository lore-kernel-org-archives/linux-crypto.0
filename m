Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57597C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3780720693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfG3Mik (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:38:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41874 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbfG3Mik (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 08:38:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCE2A81DF1;
        Tue, 30 Jul 2019 12:38:39 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 742425D6B2;
        Tue, 30 Jul 2019 12:38:38 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC 1/3] crypto/sha256: Factor out the parts of base API that don't use shash_desc
Date:   Tue, 30 Jul 2019 14:38:33 +0200
Message-Id: <20190730123835.10283-2-hdegoede@redhat.com>
In-Reply-To: <20190730123835.10283-1-hdegoede@redhat.com>
References: <20190730123835.10283-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 30 Jul 2019 12:38:39 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

I want to expose a minimal SHA256 API that can be used without the
depending on the crypto core.  To prepare for this, factor out the
meat of the sha256_base_*() helpers.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 include/crypto/sha256_base.h | 53 ++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
index 59159bc944f5..5317946a813a 100644
--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -15,10 +15,8 @@
 typedef void (sha256_block_fn)(struct sha256_state *sst, u8 const *src,
 			       int blocks);
 
-static inline int sha224_base_init(struct shash_desc *desc)
+static inline void sha224_init_direct(struct sha256_state *sctx)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
 	sctx->state[0] = SHA224_H0;
 	sctx->state[1] = SHA224_H1;
 	sctx->state[2] = SHA224_H2;
@@ -28,14 +26,16 @@ static inline int sha224_base_init(struct shash_desc *desc)
 	sctx->state[6] = SHA224_H6;
 	sctx->state[7] = SHA224_H7;
 	sctx->count = 0;
+}
 
+static inline int sha224_base_init(struct shash_desc *desc)
+{
+	sha224_init_direct(shash_desc_ctx(desc));
 	return 0;
 }
 
-static inline int sha256_base_init(struct shash_desc *desc)
+static inline void sha256_init_direct(struct sha256_state *sctx)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
 	sctx->state[0] = SHA256_H0;
 	sctx->state[1] = SHA256_H1;
 	sctx->state[2] = SHA256_H2;
@@ -45,16 +45,19 @@ static inline int sha256_base_init(struct shash_desc *desc)
 	sctx->state[6] = SHA256_H6;
 	sctx->state[7] = SHA256_H7;
 	sctx->count = 0;
+}
 
+static inline int sha256_base_init(struct shash_desc *desc)
+{
+	sha256_init_direct(shash_desc_ctx(desc));
 	return 0;
 }
 
-static inline int sha256_base_do_update(struct shash_desc *desc,
-					const u8 *data,
-					unsigned int len,
-					sha256_block_fn *block_fn)
+static inline void __sha256_base_do_update(struct sha256_state *sctx,
+					   const u8 *data,
+					   unsigned int len,
+					   sha256_block_fn *block_fn)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
 	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
 
 	sctx->count += len;
@@ -83,15 +86,21 @@ static inline int sha256_base_do_update(struct shash_desc *desc,
 	}
 	if (len)
 		memcpy(sctx->buf + partial, data, len);
+}
 
+static inline int sha256_base_do_update(struct shash_desc *desc,
+					const u8 *data,
+					unsigned int len,
+					sha256_block_fn *block_fn)
+{
+	__sha256_base_do_update(shash_desc_ctx(desc), data, len, block_fn);
 	return 0;
 }
 
-static inline int sha256_base_do_finalize(struct shash_desc *desc,
-					  sha256_block_fn *block_fn)
+static inline void sha256_do_finalize_direct(struct sha256_state *sctx,
+					     sha256_block_fn *block_fn)
 {
 	const int bit_offset = SHA256_BLOCK_SIZE - sizeof(__be64);
-	struct sha256_state *sctx = shash_desc_ctx(desc);
 	__be64 *bits = (__be64 *)(sctx->buf + bit_offset);
 	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
 
@@ -106,14 +115,18 @@ static inline int sha256_base_do_finalize(struct shash_desc *desc,
 	memset(sctx->buf + partial, 0x0, bit_offset - partial);
 	*bits = cpu_to_be64(sctx->count << 3);
 	block_fn(sctx, sctx->buf, 1);
+}
 
+static inline int sha256_base_do_finalize(struct shash_desc *desc,
+					  sha256_block_fn *block_fn)
+{
+	sha256_do_finalize_direct(shash_desc_ctx(desc), block_fn);
 	return 0;
 }
 
-static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
+static inline void __sha256_base_finish(struct sha256_state *sctx,
+					unsigned int digest_size, u8 *out)
 {
-	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
-	struct sha256_state *sctx = shash_desc_ctx(desc);
 	__be32 *digest = (__be32 *)out;
 	int i;
 
@@ -121,5 +134,11 @@ static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
 		put_unaligned_be32(sctx->state[i], digest++);
 
 	*sctx = (struct sha256_state){};
+}
+
+static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
+{
+	__sha256_base_finish(shash_desc_ctx(desc),
+			     crypto_shash_digestsize(desc->tfm), out);
 	return 0;
 }
-- 
2.21.0

