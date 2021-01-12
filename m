Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A11C433E9
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 19:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 727A42311F
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 19:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406898AbhALTaO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jan 2021 14:30:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437055AbhALTaO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jan 2021 14:30:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49F3622DFA;
        Tue, 12 Jan 2021 19:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610479773;
        bh=NLW/QZd9T34+Xnz1opdp5aqXlcuwVhASNBm1Tf0Nil8=;
        h=From:To:Cc:Subject:Date:From;
        b=R+MA5BCRSLiVO7+zw7McxDwmHecg8x6GnB7yUgnsCrlksV54W7qqASyhMmLOng2Q6
         Yv9GTQW2VifbEQCJZsmUzt+FRHVXrshzvcJ3oTSNPDl6jzAtBLUUKFRW08CCl2A6AJ
         d4WTBEH0vbHV11KkwkDwFubdJWfpuUyDUaIXux+VVmaUnXcrl7FTYbcsiR16LzKYrA
         aPPoiIYY98UXFChID0jJygi+AxDDvdFp1LUdx3q2ok5aWQ4z+TF843DaTJdoNxSqvO
         5HPrDRpxG6XSAtN/SRzQSwYYkTdPfBiZ7Z8t3YrQaK1YlHE4dPvEQ8iQfZBwtFILvY
         qK83sImnmF84w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Theodore Ts'o <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH RESEND] random: initialize ChaCha20 constants with correct endianness
Date:   Tue, 12 Jan 2021 11:29:27 -0800
Message-Id: <20210112192927.70596-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

On big endian CPUs, the ChaCha20-based CRNG is using the wrong
endianness for the ChaCha20 constants.

This doesn't matter cryptographically, but technically it means it's not
ChaCha20 anymore.  Fix it to always use the standard constants.

Cc: linux-crypto@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Andrew, please consider taking this patch since the maintainer has been
ignoring it for 4 months
(https://lkml.kernel.org/lkml/20200916045013.142179-1-ebiggers@kernel.org/T/#u).


 drivers/char/random.c   | 4 ++--
 include/crypto/chacha.h | 9 +++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index bbc5098b1a81f..4037a1e0fb748 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -809,7 +809,7 @@ static bool __init crng_init_try_arch_early(struct crng_state *crng)
 
 static void __maybe_unused crng_initialize_secondary(struct crng_state *crng)
 {
-	memcpy(&crng->state[0], "expand 32-byte k", 16);
+	chacha_init_consts(crng->state);
 	_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
 	crng_init_try_arch(crng);
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
@@ -817,7 +817,7 @@ static void __maybe_unused crng_initialize_secondary(struct crng_state *crng)
 
 static void __init crng_initialize_primary(struct crng_state *crng)
 {
-	memcpy(&crng->state[0], "expand 32-byte k", 16);
+	chacha_init_consts(crng->state);
 	_extract_entropy(&input_pool, &crng->state[4], sizeof(__u32) * 12, 0);
 	if (crng_init_try_arch_early(crng) && trust_cpu) {
 		invalidate_batched_entropy();
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 3a1c72fdb7cf5..dabaee6987186 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -47,13 +47,18 @@ static inline void hchacha_block(const u32 *state, u32 *out, int nrounds)
 		hchacha_block_generic(state, out, nrounds);
 }
 
-void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv);
-static inline void chacha_init_generic(u32 *state, const u32 *key, const u8 *iv)
+static inline void chacha_init_consts(u32 *state)
 {
 	state[0]  = 0x61707865; /* "expa" */
 	state[1]  = 0x3320646e; /* "nd 3" */
 	state[2]  = 0x79622d32; /* "2-by" */
 	state[3]  = 0x6b206574; /* "te k" */
+}
+
+void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv);
+static inline void chacha_init_generic(u32 *state, const u32 *key, const u8 *iv)
+{
+	chacha_init_consts(state);
 	state[4]  = key[0];
 	state[5]  = key[1];
 	state[6]  = key[2];
-- 
2.30.0

