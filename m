Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B0FC43461
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 10:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76E5D613BD
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 10:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhEUKWk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 06:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234454AbhEUKWh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 06:22:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90CC9613BE;
        Fri, 21 May 2021 10:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621592475;
        bh=BENSWZ9IGinJ9DApFd7Een4c2HMopl9cTHAw0uG/+Bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKjnEzPvyqwhbN/cZtdnnnrKxdbBBwZ5q0FRKvfHc1+hvgwe31+w5jxwzSe0uDrcR
         oAQBbIC9CBtGj45/oN4xiENq2qx87BG2zlsh7XMzYS0aXzJJ6px1XI/UpgvvHkSyGK
         OX1F4YEmUW4kE1MaZNXRcyOTs+fONR0AmBSwHm0ZTgi8Rfk4vVpaHsCRImCQZkmFX8
         8rxr743gRGhy2Xw92fkaDdE52oGVygLu8ONxWjhMREqIz9PG4bRZ74duZIfZEHp+UM
         ZTy+imvT939Tj0oLd84BZ5NRavraLmsJrB2FpkgyywpFsgNJ8Mj+ZjTnTI/PDy2QRh
         xgc6GygPvhEvg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v5 5/5] crypto: arm64/aes-ccm - avoid by-ref argument for ce_aes_ccm_auth_data
Date:   Fri, 21 May 2021 12:20:53 +0200
Message-Id: <20210521102053.66609-6-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210521102053.66609-1-ardb@kernel.org>
References: <20210521102053.66609-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With the SIMD code path removed, we can clean up the CCM auth-only path
a bit further, by passing the 'macp' input buffer pointer by value,
rather than by reference, and taking the output value from the
function's return value.

This way, the compiler is no longer forced to allocate macp on the
stack. This is not expected to make any difference in practice, it just
makes for slightly cleaner code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 23 ++++++++++----------
 arch/arm64/crypto/aes-ce-ccm-glue.c | 17 +++++----------
 2 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index 8adff299fcd3..b03f7f71f893 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -12,22 +12,21 @@
 	.arch	armv8-a+crypto
 
 	/*
-	 * void ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
-	 *			     u32 *macp, u8 const rk[], u32 rounds);
+	 * u32 ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
+	 *			    u32 macp, u8 const rk[], u32 rounds);
 	 */
 SYM_FUNC_START(ce_aes_ccm_auth_data)
-	ldr	w8, [x3]			/* leftover from prev round? */
 	ld1	{v0.16b}, [x0]			/* load mac */
-	cbz	w8, 1f
-	sub	w8, w8, #16
+	cbz	w3, 1f
+	sub	w3, w3, #16
 	eor	v1.16b, v1.16b, v1.16b
 0:	ldrb	w7, [x1], #1			/* get 1 byte of input */
 	subs	w2, w2, #1
-	add	w8, w8, #1
+	add	w3, w3, #1
 	ins	v1.b[0], w7
 	ext	v1.16b, v1.16b, v1.16b, #1	/* rotate in the input bytes */
 	beq	8f				/* out of input? */
-	cbnz	w8, 0b
+	cbnz	w3, 0b
 	eor	v0.16b, v0.16b, v1.16b
 1:	ld1	{v3.4s}, [x4]			/* load first round key */
 	prfm	pldl1strm, [x1]
@@ -62,7 +61,7 @@ SYM_FUNC_START(ce_aes_ccm_auth_data)
 	beq	10f
 	adds	w2, w2, #16
 	beq	10f
-	mov	w8, w2
+	mov	w3, w2
 7:	ldrb	w7, [x1], #1
 	umov	w6, v0.b[0]
 	eor	w6, w6, w7
@@ -71,15 +70,15 @@ SYM_FUNC_START(ce_aes_ccm_auth_data)
 	beq	10f
 	ext	v0.16b, v0.16b, v0.16b, #1	/* rotate out the mac bytes */
 	b	7b
-8:	cbz	w8, 91f
-	mov	w7, w8
-	add	w8, w8, #16
+8:	cbz	w3, 91f
+	mov	w7, w3
+	add	w3, w3, #16
 9:	ext	v1.16b, v1.16b, v1.16b, #1
 	adds	w7, w7, #1
 	bne	9b
 91:	eor	v0.16b, v0.16b, v1.16b
 	st1	{v0.16b}, [x0]
-10:	str	w8, [x3]
+10:	mov	w0, w3
 	ret
 SYM_FUNC_END(ce_aes_ccm_auth_data)
 
diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 8effd18429ac..d4e87b4e348f 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -29,8 +29,8 @@ static int num_rounds(struct crypto_aes_ctx *ctx)
 	return 6 + ctx->key_length / 4;
 }
 
-asmlinkage void ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
-				     u32 *macp, u32 const rk[], u32 rounds);
+asmlinkage u32 ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
+				    u32 macp, u32 const rk[], u32 rounds);
 
 asmlinkage void ce_aes_ccm_encrypt(u8 out[], u8 const in[], u32 cbytes,
 				   u32 const rk[], u32 rounds, u8 mac[],
@@ -96,13 +96,6 @@ static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
 	return 0;
 }
 
-static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
-			   u32 abytes, u32 *macp)
-{
-	ce_aes_ccm_auth_data(mac, in, abytes, macp, key->key_enc,
-			     num_rounds(key));
-}
-
 static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -122,7 +115,8 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 		ltag.len = 6;
 	}
 
-	ccm_update_mac(ctx, mac, (u8 *)&ltag, ltag.len, &macp);
+	macp = ce_aes_ccm_auth_data(mac, (u8 *)&ltag, ltag.len, macp,
+				    ctx->key_enc, num_rounds(ctx));
 	scatterwalk_start(&walk, req->src);
 
 	do {
@@ -134,7 +128,8 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 			n = scatterwalk_clamp(&walk, len);
 		}
 		p = scatterwalk_map(&walk);
-		ccm_update_mac(ctx, mac, p, n, &macp);
+		macp = ce_aes_ccm_auth_data(mac, p, n, macp, ctx->key_enc,
+					    num_rounds(ctx));
 		len -= n;
 
 		scatterwalk_unmap(p);
-- 
2.20.1

