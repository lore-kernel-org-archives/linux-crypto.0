Return-Path: <SRS0=sSQu=EN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DF8C388F9
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Nov 2020 19:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0A0F20B1F
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Nov 2020 19:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604778925;
	bh=hmrDuXQkrWo95PWTIUv1IpwMHJcGVMlBRtsK7yhlz04=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ZpAY1pK6qTGFJ3DoWRDAx1fF32FvMhqndrmaAgVAO/luMEuUgrJgeFp4ETr07E+7q
	 7P6xEOKk5Z/a4aWIAJ7cQwB3chJsvnA5J7zXUkCJj242w6H80XZTh3OSEyDV2Rd2Eh
	 fNCXx3KImPqZ6UE/dYp9j34H8u1ZYfsOdTzKcaN8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKGTzY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Nov 2020 14:55:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgKGTzY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Nov 2020 14:55:24 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1989520885;
        Sat,  7 Nov 2020 19:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604778923;
        bh=hmrDuXQkrWo95PWTIUv1IpwMHJcGVMlBRtsK7yhlz04=;
        h=From:To:Cc:Subject:Date:From;
        b=PprBt71dg559ZMx7PTHrf4yfXbZAHrn72Erse2PpbRCmqyF57NUxP/ME02OfJfUJY
         UvPSbc/2HRMOlptLuxMhM8lsXyVewD/E4tYtxKDnIXgzt53U4LqtGU7G+j0gzvJP4j
         RXEyzomLGJSxvf1YD2DclKeGoyYYEybMSh/dSdkg=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: aegis128/neon - optimize tail block handling
Date:   Sat,  7 Nov 2020 20:55:16 +0100
Message-Id: <20201107195516.13952-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Avoid copying the tail block via a stack buffer if the total size
exceeds a single AEGIS block. In this case, we can use overlapping
loads and stores and NEON permutation instructions instead, which
leads to a modest performance improvement on some cores (< 5%),
and is slightly cleaner. Note that we still need to use a stack
buffer if the entire input is smaller than 16 bytes, given that
we cannot use 16 byte NEON loads and stores safely in this case.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/aegis128-neon-inner.c | 88 +++++++++++++++++---
 1 file changed, 75 insertions(+), 13 deletions(-)

diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
index 2a660ac1bc3a..81cc7383e54b 100644
--- a/crypto/aegis128-neon-inner.c
+++ b/crypto/aegis128-neon-inner.c
@@ -173,10 +173,46 @@ void crypto_aegis128_update_neon(void *state, const void *msg)
 	aegis128_save_state_neon(st, state);
 }
 
+#ifdef CONFIG_ARM
+/*
+ * AArch32 does not provide these intrinsics natively because it does not
+ * implement the underlying instructions. AArch32 only provides 64-bit
+ * wide vtbl.8/vtbx.8 instruction, so use those instead.
+ */
+static uint8x16_t vqtbl1q_u8(uint8x16_t a, uint8x16_t b)
+{
+	union {
+		uint8x16_t	val;
+		uint8x8x2_t	pair;
+	} __a = { a };
+
+	return vcombine_u8(vtbl2_u8(__a.pair, vget_low_u8(b)),
+			   vtbl2_u8(__a.pair, vget_high_u8(b)));
+}
+
+static uint8x16_t vqtbx1q_u8(uint8x16_t v, uint8x16_t a, uint8x16_t b)
+{
+	union {
+		uint8x16_t	val;
+		uint8x8x2_t	pair;
+	} __a = { a };
+
+	return vcombine_u8(vtbx2_u8(vget_low_u8(v), __a.pair, vget_low_u8(b)),
+			   vtbx2_u8(vget_high_u8(v), __a.pair, vget_high_u8(b)));
+}
+#endif
+
+static const uint8_t permute[] __aligned(64) = {
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+};
+
 void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
 					unsigned int size)
 {
 	struct aegis128_state st = aegis128_load_state_neon(state);
+	const int short_input = size < AEGIS_BLOCK_SIZE;
 	uint8x16_t msg;
 
 	preload_sbox();
@@ -186,7 +222,8 @@ void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
 
 		msg = vld1q_u8(src);
 		st = aegis128_update_neon(st, msg);
-		vst1q_u8(dst, msg ^ s);
+		msg ^= s;
+		vst1q_u8(dst, msg);
 
 		size -= AEGIS_BLOCK_SIZE;
 		src += AEGIS_BLOCK_SIZE;
@@ -195,13 +232,26 @@ void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
 
 	if (size > 0) {
 		uint8x16_t s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
-		uint8_t buf[AEGIS_BLOCK_SIZE] = {};
+		uint8_t buf[AEGIS_BLOCK_SIZE];
+		const void *in = src;
+		void *out = dst;
+		uint8x16_t m;
 
-		memcpy(buf, src, size);
-		msg = vld1q_u8(buf);
-		st = aegis128_update_neon(st, msg);
-		vst1q_u8(buf, msg ^ s);
-		memcpy(dst, buf, size);
+		if (__builtin_expect(short_input, 0))
+			in = out = memcpy(buf + AEGIS_BLOCK_SIZE - size, src, size);
+
+		m = vqtbl1q_u8(vld1q_u8(in + size - AEGIS_BLOCK_SIZE),
+			       vld1q_u8(permute + 32 - size));
+
+		st = aegis128_update_neon(st, m);
+
+		vst1q_u8(out + size - AEGIS_BLOCK_SIZE,
+			 vqtbl1q_u8(m ^ s, vld1q_u8(permute + size)));
+
+		if (__builtin_expect(short_input, 0))
+			memcpy(dst, out, size);
+		else
+			vst1q_u8(out - AEGIS_BLOCK_SIZE, msg);
 	}
 
 	aegis128_save_state_neon(st, state);
@@ -211,6 +261,7 @@ void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
 					unsigned int size)
 {
 	struct aegis128_state st = aegis128_load_state_neon(state);
+	const int short_input = size < AEGIS_BLOCK_SIZE;
 	uint8x16_t msg;
 
 	preload_sbox();
@@ -228,14 +279,25 @@ void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
 	if (size > 0) {
 		uint8x16_t s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
 		uint8_t buf[AEGIS_BLOCK_SIZE];
+		const void *in = src;
+		void *out = dst;
+		uint8x16_t m;
 
-		vst1q_u8(buf, s);
-		memcpy(buf, src, size);
-		msg = vld1q_u8(buf) ^ s;
-		vst1q_u8(buf, msg);
-		memcpy(dst, buf, size);
+		if (__builtin_expect(short_input, 0))
+			in = out = memcpy(buf + AEGIS_BLOCK_SIZE - size, src, size);
 
-		st = aegis128_update_neon(st, msg);
+		m = s ^ vqtbx1q_u8(s, vld1q_u8(in + size - AEGIS_BLOCK_SIZE),
+				   vld1q_u8(permute + 32 - size));
+
+		st = aegis128_update_neon(st, m);
+
+		vst1q_u8(out + size - AEGIS_BLOCK_SIZE,
+			 vqtbl1q_u8(m, vld1q_u8(permute + size)));
+
+		if (__builtin_expect(short_input, 0))
+			memcpy(dst, out, size);
+		else
+			vst1q_u8(out - AEGIS_BLOCK_SIZE, msg);
 	}
 
 	aegis128_save_state_neon(st, state);
-- 
2.17.1

