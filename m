Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25D0C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 846B921874
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552454136;
	bh=dADKUnSVG3rfqdhSW0LWNdj60ivQO/IRlbfO5L21RY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xUXOrnrBNxIDgQzVhejn7LbJGVFfxKu7/AucKP98DbgaoSY+ejbeIo+nWTcOYYnV4
	 ivAl0Iue4RR1tpcUNvw7lgfgCLcPKwsw43lkX/Q+wl5PgzyaGMGrRKVM2ZHYoAqy10
	 oevDK7zE+wXI9f8IwNh2syosHMxY6ic7k50Orbbs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfCMFPf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfCMFPf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 01:15:35 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 952B921841;
        Wed, 13 Mar 2019 05:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552454134;
        bh=dADKUnSVG3rfqdhSW0LWNdj60ivQO/IRlbfO5L21RY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFX/QrIy5NcnQ2YGiJB4Zn3EQ92zGzBjvghYw4FuTvUMK0CULT59Hv0HoimUW0N2f
         +qHBN/Hvtmu67MWrBBdDQtergqC8ZB5F6xTOcv9ch8EwP5hxHFAMt6GAlA/7pFXcCA
         ZFIkbKbRAgMIt3Xaq/GrvaxmWASpDu/RFyjGZle4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 2/8] crypto: arm64/gcm-aes-ce - fix no-NEON fallback code
Date:   Tue, 12 Mar 2019 22:12:46 -0700
Message-Id: <20190313051252.2917-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313051252.2917-1-ebiggers@kernel.org>
References: <20190313051252.2917-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The arm64 gcm-aes-ce algorithm is failing the extra crypto self-tests
following my patches to test the !may_use_simd() code paths, which
previously were untested.  The problem is that in the !may_use_simd()
case, an odd number of AES blocks can be processed within each step of
the skcipher_walk.  However, the skcipher_walk is being done with a
"stride" of 2 blocks and is advanced by an even number of blocks after
each step.  This causes the encryption to produce the wrong ciphertext
and authentication tag, and causes the decryption to incorrectly fail.

Fix it by only processing an even number of blocks per step.

Fixes: c2b24c36e0a3 ("crypto: arm64/aes-gcm-ce - fix scatterwalk API violation")
Fixes: 71e52c278c54 ("crypto: arm64/aes-ce-gcm - operate on two input blocks at a time")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/ghash-ce-glue.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 791ad422c427..089b09286da7 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -473,9 +473,11 @@ static int gcm_encrypt(struct aead_request *req)
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
 		while (walk.nbytes >= (2 * AES_BLOCK_SIZE)) {
-			int blocks = walk.nbytes / AES_BLOCK_SIZE;
+			const int blocks =
+				walk.nbytes / (2 * AES_BLOCK_SIZE) * 2;
 			u8 *dst = walk.dst.virt.addr;
 			u8 *src = walk.src.virt.addr;
+			int remaining = blocks;
 
 			do {
 				__aes_arm64_encrypt(ctx->aes_key.key_enc,
@@ -485,9 +487,9 @@ static int gcm_encrypt(struct aead_request *req)
 
 				dst += AES_BLOCK_SIZE;
 				src += AES_BLOCK_SIZE;
-			} while (--blocks > 0);
+			} while (--remaining > 0);
 
-			ghash_do_update(walk.nbytes / AES_BLOCK_SIZE, dg,
+			ghash_do_update(blocks, dg,
 					walk.dst.virt.addr, &ctx->ghash_key,
 					NULL, pmull_ghash_update_p64);
 
@@ -609,7 +611,7 @@ static int gcm_decrypt(struct aead_request *req)
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
 		while (walk.nbytes >= (2 * AES_BLOCK_SIZE)) {
-			int blocks = walk.nbytes / AES_BLOCK_SIZE;
+			int blocks = walk.nbytes / (2 * AES_BLOCK_SIZE) * 2;
 			u8 *dst = walk.dst.virt.addr;
 			u8 *src = walk.src.virt.addr;
 
-- 
2.21.0

