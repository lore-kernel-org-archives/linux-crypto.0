Return-Path: <SRS0=71ZY=QE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B70C282C8
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 16:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 343A021917
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548691238;
	bh=1VAohnKiya4g5VjOyawo6jnbnD5skO8VZIIALqDiiOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iGfOiGSqtk57Gc7vXAcZSWVMZp/sEj7aGinejaIbJSS/jGBjYW9zoED/eNAMQMcsx
	 8swwsgflMqIW6LDW18w8gKMgNpB5FbSgB/VLj6Qp7ft1peK8uRVP57EfzyIhInJZgY
	 y3FtGSC9j5QwRo+bu25eCUvIl9p0nsv22QBI2Ueg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbfA1QAf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:00:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730809AbfA1QAf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 11:00:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 375112175B;
        Mon, 28 Jan 2019 16:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691234;
        bh=1VAohnKiya4g5VjOyawo6jnbnD5skO8VZIIALqDiiOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifHD1L8I6EZ9vz3W+TPFYtLPxN576SsFzvDdGRT0+vZTSr8tx+WxJsdCB3RH66FuX
         OAUaqsEFyFbaJEIkP/SfZgMZwMeQ0/9FiBcZHC7/U87BtjX1AI+o0dAjb/LX1LTwXz
         nyabmCzt1e9Ch0XY3VsNuT1C4Nbl+fBBeDcTeRIs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 026/258] crypto: aes_ti - disable interrupts while accessing S-box
Date:   Mon, 28 Jan 2019 10:55:32 -0500
Message-Id: <20190128155924.51521-26-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 0a6a40c2a8c184a2fb467efacfb1cd338d719e0b ]

In the "aes-fixed-time" AES implementation, disable interrupts while
accessing the S-box, in order to make cache-timing attacks more
difficult.  Previously it was possible for the CPU to be interrupted
while the S-box was loaded into L1 cache, potentially evicting the
cachelines and causing later table lookups to be time-variant.

In tests I did on x86 and ARM, this doesn't affect performance
significantly.  Responsiveness is potentially a concern, but interrupts
are only disabled for a single AES block.

Note that even after this change, the implementation still isn't
necessarily guaranteed to be constant-time; see
https://cr.yp.to/antiforgery/cachetiming-20050414.pdf for a discussion
of the many difficulties involved in writing truly constant-time AES
software.  But it's valuable to make such attacks more difficult.

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/Kconfig  |  3 ++-
 crypto/aes_ti.c | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 59e32623a7ce..0fb9586766a7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1056,7 +1056,8 @@ config CRYPTO_AES_TI
 	  8 for decryption), this implementation only uses just two S-boxes of
 	  256 bytes each, and attempts to eliminate data dependent latencies by
 	  prefetching the entire table into the cache at the start of each
-	  block.
+	  block. Interrupts are also disabled to avoid races where cachelines
+	  are evicted when the CPU is interrupted to do something else.
 
 config CRYPTO_AES_586
 	tristate "AES cipher algorithms (i586)"
diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
index 03023b2290e8..1ff9785b30f5 100644
--- a/crypto/aes_ti.c
+++ b/crypto/aes_ti.c
@@ -269,6 +269,7 @@ static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	const u32 *rkp = ctx->key_enc + 4;
 	int rounds = 6 + ctx->key_length / 4;
 	u32 st0[4], st1[4];
+	unsigned long flags;
 	int round;
 
 	st0[0] = ctx->key_enc[0] ^ get_unaligned_le32(in);
@@ -276,6 +277,12 @@ static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	st0[2] = ctx->key_enc[2] ^ get_unaligned_le32(in + 8);
 	st0[3] = ctx->key_enc[3] ^ get_unaligned_le32(in + 12);
 
+	/*
+	 * Temporarily disable interrupts to avoid races where cachelines are
+	 * evicted when the CPU is interrupted to do something else.
+	 */
+	local_irq_save(flags);
+
 	st0[0] ^= __aesti_sbox[ 0] ^ __aesti_sbox[128];
 	st0[1] ^= __aesti_sbox[32] ^ __aesti_sbox[160];
 	st0[2] ^= __aesti_sbox[64] ^ __aesti_sbox[192];
@@ -300,6 +307,8 @@ static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	put_unaligned_le32(subshift(st1, 1) ^ rkp[5], out + 4);
 	put_unaligned_le32(subshift(st1, 2) ^ rkp[6], out + 8);
 	put_unaligned_le32(subshift(st1, 3) ^ rkp[7], out + 12);
+
+	local_irq_restore(flags);
 }
 
 static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
@@ -308,6 +317,7 @@ static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	const u32 *rkp = ctx->key_dec + 4;
 	int rounds = 6 + ctx->key_length / 4;
 	u32 st0[4], st1[4];
+	unsigned long flags;
 	int round;
 
 	st0[0] = ctx->key_dec[0] ^ get_unaligned_le32(in);
@@ -315,6 +325,12 @@ static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	st0[2] = ctx->key_dec[2] ^ get_unaligned_le32(in + 8);
 	st0[3] = ctx->key_dec[3] ^ get_unaligned_le32(in + 12);
 
+	/*
+	 * Temporarily disable interrupts to avoid races where cachelines are
+	 * evicted when the CPU is interrupted to do something else.
+	 */
+	local_irq_save(flags);
+
 	st0[0] ^= __aesti_inv_sbox[ 0] ^ __aesti_inv_sbox[128];
 	st0[1] ^= __aesti_inv_sbox[32] ^ __aesti_inv_sbox[160];
 	st0[2] ^= __aesti_inv_sbox[64] ^ __aesti_inv_sbox[192];
@@ -339,6 +355,8 @@ static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	put_unaligned_le32(inv_subshift(st1, 1) ^ rkp[5], out + 4);
 	put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[6], out + 8);
 	put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[7], out + 12);
+
+	local_irq_restore(flags);
 }
 
 static struct crypto_alg aes_alg = {
-- 
2.19.1

