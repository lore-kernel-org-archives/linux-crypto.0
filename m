Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53152C4724C
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 07:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A5B2208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 07:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588317367;
	bh=2WWABLAfQSHAtiABhm1NCd+qVC4oltSEqvQN2dWmToA=;
	h=From:To:Subject:Date:List-ID:From;
	b=AIzhL46a+ESoX3SQ8SKe9haValxY/q2E8DR4rydBcE9Kj90lqQFGLVXFNVdj87f36
	 p+A/T/KzDRq3A2X4ZfgccK3sQ3wrMkN13n1pT7tZhp29E2yqcpwdiKXL6jp1QXZ+dw
	 aycqgKlfvr7Mu7fVnjFyi6+N2QW5baT5CSz7NB9s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgEAHQG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 May 2020 03:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgEAHQG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 May 2020 03:16:06 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1DF5208C3
        for <linux-crypto@vger.kernel.org>; Fri,  1 May 2020 07:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588317365;
        bh=2WWABLAfQSHAtiABhm1NCd+qVC4oltSEqvQN2dWmToA=;
        h=From:To:Subject:Date:From;
        b=Gi71XfK4MdDg/YlTePf2gjCYFIai8OW/2Ll5lQUoZbjqtZPq+oqpOxZO7ThLgtsHW
         74DxVNr1Y9Cy9kgx4hPGQM9cjvufYRF79tgDn6LVi7bMJ1b86/qkdV6D8lxTnWFZyD
         xfQwFSj3VoiXmO55lX0PI5o0nraHv40TC6CORW9A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: lib/sha256 - return void
Date:   Fri,  1 May 2020 00:13:38 -0700
Message-Id: <20200501071338.777352-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The SHA-256 / SHA-224 library functions can't fail, so remove the
useless return value.

Also long as the declarations are being changed anyway, also fix some
parameter names in the declarations to match the definitions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/sha256_generic.c      | 14 +++++++++-----
 include/crypto/sha.h         | 20 ++++++++------------
 include/crypto/sha256_base.h |  6 ++++--
 lib/crypto/sha256.c          | 20 ++++++++------------
 4 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index f2d7095d4f2d64..88156e3e2a33e0 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -35,27 +35,31 @@ EXPORT_SYMBOL_GPL(sha256_zero_message_hash);
 
 static int crypto_sha256_init(struct shash_desc *desc)
 {
-	return sha256_init(shash_desc_ctx(desc));
+	sha256_init(shash_desc_ctx(desc));
+	return 0;
 }
 
 static int crypto_sha224_init(struct shash_desc *desc)
 {
-	return sha224_init(shash_desc_ctx(desc));
+	sha224_init(shash_desc_ctx(desc));
+	return 0;
 }
 
 int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
-	return sha256_update(shash_desc_ctx(desc), data, len);
+	sha256_update(shash_desc_ctx(desc), data, len);
+	return 0;
 }
 EXPORT_SYMBOL(crypto_sha256_update);
 
 static int crypto_sha256_final(struct shash_desc *desc, u8 *out)
 {
 	if (crypto_shash_digestsize(desc->tfm) == SHA224_DIGEST_SIZE)
-		return sha224_final(shash_desc_ctx(desc), out);
+		sha224_final(shash_desc_ctx(desc), out);
 	else
-		return sha256_final(shash_desc_ctx(desc), out);
+		sha256_final(shash_desc_ctx(desc), out);
+	return 0;
 }
 
 int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 5c2132c7190095..8db9e1a3eb0cf6 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -123,7 +123,7 @@ extern int crypto_sha512_finup(struct shash_desc *desc, const u8 *data,
  * For details see lib/crypto/sha256.c
  */
 
-static inline int sha256_init(struct sha256_state *sctx)
+static inline void sha256_init(struct sha256_state *sctx)
 {
 	sctx->state[0] = SHA256_H0;
 	sctx->state[1] = SHA256_H1;
@@ -134,14 +134,12 @@ static inline int sha256_init(struct sha256_state *sctx)
 	sctx->state[6] = SHA256_H6;
 	sctx->state[7] = SHA256_H7;
 	sctx->count = 0;
-
-	return 0;
 }
-extern int sha256_update(struct sha256_state *sctx, const u8 *input,
-			 unsigned int length);
-extern int sha256_final(struct sha256_state *sctx, u8 *hash);
+extern void sha256_update(struct sha256_state *sctx, const u8 *data,
+			  unsigned int len);
+extern void sha256_final(struct sha256_state *sctx, u8 *out);
 
-static inline int sha224_init(struct sha256_state *sctx)
+static inline void sha224_init(struct sha256_state *sctx)
 {
 	sctx->state[0] = SHA224_H0;
 	sctx->state[1] = SHA224_H1;
@@ -152,11 +150,9 @@ static inline int sha224_init(struct sha256_state *sctx)
 	sctx->state[6] = SHA224_H6;
 	sctx->state[7] = SHA224_H7;
 	sctx->count = 0;
-
-	return 0;
 }
-extern int sha224_update(struct sha256_state *sctx, const u8 *input,
-			 unsigned int length);
-extern int sha224_final(struct sha256_state *sctx, u8 *hash);
+extern void sha224_update(struct sha256_state *sctx, const u8 *data,
+			  unsigned int len);
+extern void sha224_final(struct sha256_state *sctx, u8 *out);
 
 #endif
diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
index cea60cff80bd87..6ded110783ae87 100644
--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -22,14 +22,16 @@ static inline int sha224_base_init(struct shash_desc *desc)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 
-	return sha224_init(sctx);
+	sha224_init(sctx);
+	return 0;
 }
 
 static inline int sha256_base_init(struct shash_desc *desc)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 
-	return sha256_init(sctx);
+	sha256_init(sctx);
+	return 0;
 }
 
 static inline int sha256_base_do_update(struct shash_desc *desc,
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 66cb04b0cf4e7e..2e621697c5c35c 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -206,7 +206,7 @@ static void sha256_transform(u32 *state, const u8 *input)
 	memzero_explicit(W, 64 * sizeof(u32));
 }
 
-int sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
+void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 {
 	unsigned int partial, done;
 	const u8 *src;
@@ -232,18 +232,16 @@ int sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 		partial = 0;
 	}
 	memcpy(sctx->buf + partial, src, len - done);
-
-	return 0;
 }
 EXPORT_SYMBOL(sha256_update);
 
-int sha224_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
+void sha224_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 {
-	return sha256_update(sctx, data, len);
+	sha256_update(sctx, data, len);
 }
 EXPORT_SYMBOL(sha224_update);
 
-static int __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
+static void __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
 {
 	__be32 *dst = (__be32 *)out;
 	__be64 bits;
@@ -268,19 +266,17 @@ static int __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
 
 	/* Zeroize sensitive information. */
 	memset(sctx, 0, sizeof(*sctx));
-
-	return 0;
 }
 
-int sha256_final(struct sha256_state *sctx, u8 *out)
+void sha256_final(struct sha256_state *sctx, u8 *out)
 {
-	return __sha256_final(sctx, out, 8);
+	__sha256_final(sctx, out, 8);
 }
 EXPORT_SYMBOL(sha256_final);
 
-int sha224_final(struct sha256_state *sctx, u8 *out)
+void sha224_final(struct sha256_state *sctx, u8 *out)
 {
-	return __sha256_final(sctx, out, 7);
+	__sha256_final(sctx, out, 7);
 }
 EXPORT_SYMBOL(sha224_final);
 
-- 
2.26.2

