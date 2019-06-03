Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAC0C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBEB32070B
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559540843;
	bh=N1ClOOSjsm461VFvXMbJnQxOXiM5sx90mSRbvlFZQss=;
	h=From:To:Subject:Date:List-ID:From;
	b=sClNP/ogCKtyMeDXglTNQkZ6NQr0umuhX2PvI7o8Row0p576hrqiV9l6asz77OdrF
	 N4FCwVnrRt9y6Aak82h2gbozwy73CDWSdaurPgXmyLF20n9ceIAD2QjsAE4i4Wzg3y
	 Q2ny46iSR4lhZ2FLYBQdbn/KNH90JYEwPIzguL3w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfFCFrX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 01:47:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfFCFrX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 01:47:23 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4011127739
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 05:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559540842;
        bh=N1ClOOSjsm461VFvXMbJnQxOXiM5sx90mSRbvlFZQss=;
        h=From:To:Subject:Date:From;
        b=xIYplkV/w5eZ0arsRdwRqfMoWzyYOVqvFId0rZ+Wb9+9XqhHSoIBCubYaZtm9Vtdx
         Wm9xAXGl1ic4fMziCWtC8gbbjXkkGJv0vc0mYd7v0B/b5MiWZPLZhy0nk8SBrMrP14
         jYeNHUn3miciWjQTOLhJ4st6wJB81aS3FfUc8DAs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: chacha - constify ctx and iv arguments
Date:   Sun,  2 Jun 2019 22:47:14 -0700
Message-Id: <20190603054714.6477-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Constify the ctx and iv arguments to crypto_chacha_init() and the
various chacha*_stream_xor() functions.  This makes it clear that they
are not modified.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/chacha-neon-glue.c   | 2 +-
 arch/arm64/crypto/chacha-neon-glue.c | 2 +-
 arch/x86/crypto/chacha_glue.c        | 2 +-
 crypto/chacha_generic.c              | 4 ++--
 include/crypto/chacha.h              | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/crypto/chacha-neon-glue.c b/arch/arm/crypto/chacha-neon-glue.c
index 48a89537b8283..a8e9b534c8da5 100644
--- a/arch/arm/crypto/chacha-neon-glue.c
+++ b/arch/arm/crypto/chacha-neon-glue.c
@@ -63,7 +63,7 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 }
 
 static int chacha_neon_stream_xor(struct skcipher_request *req,
-				  struct chacha_ctx *ctx, u8 *iv)
+				  const struct chacha_ctx *ctx, const u8 *iv)
 {
 	struct skcipher_walk walk;
 	u32 state[16];
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index 82029cda2e77a..1495d2b18518d 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -60,7 +60,7 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 }
 
 static int chacha_neon_stream_xor(struct skcipher_request *req,
-				  struct chacha_ctx *ctx, u8 *iv)
+				  const struct chacha_ctx *ctx, const u8 *iv)
 {
 	struct skcipher_walk walk;
 	u32 state[16];
diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index 4967ad620775b..7276b7ef14ec4 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -128,7 +128,7 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 }
 
 static int chacha_simd_stream_xor(struct skcipher_walk *walk,
-				  struct chacha_ctx *ctx, u8 *iv)
+				  const struct chacha_ctx *ctx, const u8 *iv)
 {
 	u32 *state, state_buf[16 + 2] __aligned(8);
 	int next_yield = 4096; /* bytes until next FPU yield */
diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index d2ec04997832e..d283bd3bdb607 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -36,7 +36,7 @@ static void chacha_docrypt(u32 *state, u8 *dst, const u8 *src,
 }
 
 static int chacha_stream_xor(struct skcipher_request *req,
-			     struct chacha_ctx *ctx, u8 *iv)
+			     const struct chacha_ctx *ctx, const u8 *iv)
 {
 	struct skcipher_walk walk;
 	u32 state[16];
@@ -60,7 +60,7 @@ static int chacha_stream_xor(struct skcipher_request *req,
 	return err;
 }
 
-void crypto_chacha_init(u32 *state, struct chacha_ctx *ctx, u8 *iv)
+void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv)
 {
 	state[0]  = 0x61707865; /* "expa" */
 	state[1]  = 0x3320646e; /* "nd 3" */
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 1fc70a69d5508..d1e723c6a37dd 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -41,7 +41,7 @@ static inline void chacha20_block(u32 *state, u8 *stream)
 }
 void hchacha_block(const u32 *in, u32 *out, int nrounds);
 
-void crypto_chacha_init(u32 *state, struct chacha_ctx *ctx, u8 *iv);
+void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv);
 
 int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keysize);
-- 
2.21.0

