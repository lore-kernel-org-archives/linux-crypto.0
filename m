Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6268115AD1
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 12:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rIpAcpR8"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5f9e5455db1so38300657b3.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 04:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704976421; x=1705581221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eklahTTMpbyoQkh7ltPW8pyjirh03W9lGutuGnzNM/Y=;
        b=rIpAcpR8n6942ZzKqoHH0yHjCUFWmGpjjijuKZn+BFroxIDPfFng17emOgoIXQvqnQ
         0EzzABSmd/XGOlsKUHo8BktSkSO2TtfOVzc70KrVBiSJnKb51xcM2z16szIPSHBTxSJX
         wSM698Ui+L1+CbuHa1oDlofuNR8yAB8PtGYUuaCX6WD/vwEjQQUesBw46s3G6+NOutDa
         b0qQHNjFA7vYYoo3yau56TMtH2S8Ol2Vo0y7F4EwI+bd0WB7g2XD8KjwFPYfLsBhkFZu
         THtYAe7R3LcT7cUS/RrJXS1TEtNiG1A8ooUI4Iuub2wI808NKaq/ayF6wLUFG4ITpJbp
         X+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976421; x=1705581221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eklahTTMpbyoQkh7ltPW8pyjirh03W9lGutuGnzNM/Y=;
        b=oouEM1alj9UI5hIIRjYzP2NDPDlCtzlduS+Z9/youz7t6QrRzOf4SHHie2eQHNYsmD
         2zo6BMqonYUij/FaYbAMe1AjpTWTzOQrMdNzZQ6HbcrJECMcaXroSvka7DQFlsoPmDXq
         iDdJaiDrOm5ToJ/aauNwzaOa00ED5X4LHWHoIIxRMBscQuvos4U4Ro+sgTU75I9bkdAC
         cPRQNJj41ce5//1YU7Jyqcd8KYbiEYngoBDgYtW/srVF5CWpal4tOVaL1+hPExpytIlk
         OYlgjs/aj5H2wgcppQZrFSSam8cSwPkMCI4TxiBh9Jt+J0+e77ZCG8gzj2P5nNSz0C8r
         Cmjw==
X-Gm-Message-State: AOJu0YzYcEhx1PGIxp2xR5QSBhN3TObURbi8c1dS14Oh5gD8G829T/qZ
	Jo2bGeu/YbiZM1moIvjsLGfiUC3uL6weFuC5uesZcQvsNAKYUN/+TN6t6GUNcsEYnWrVClGi9AJ
	j4wbHLhZ46oh8d+D+MrqVr48YyBjhS/dUpA0DSfDTEH0mrYlxILap2oJaLZelHWGhZFK88dE=
X-Google-Smtp-Source: AGHT+IGO1eSQPerE9rze0TtrTlYckOhcTkXthLkkw+Wb2njY8VSyqGcPni83vwBLeIRXw1aCHS3Lt5um
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a0d:f902:0:b0:5e3:5f02:360a with SMTP id
 j2-20020a0df902000000b005e35f02360amr174268ywf.9.1704976421349; Thu, 11 Jan
 2024 04:33:41 -0800 (PST)
Date: Thu, 11 Jan 2024 13:33:11 +0100
In-Reply-To: <20240111123302.589910-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111123302.589910-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5402; i=ardb@kernel.org;
 h=from:subject; bh=NB9jjOWrNbjzPCu01cSMqRp50yxJ8npXTVcNG1ZF/t8=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXX+A7Y3HvdOBuaG5wnK+T46vOr94vZHPXnNT1octyr+L
 t5SVnq0o5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExk+naG/06rghbbNdim3//B
 e2DFDVurGxxeK2L37nyYP/Xh/hvpbQmMDJuSa6V9X6++yK/5oUR/upzLj3sfriksFv2QHblTWIl JmQMA
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111123302.589910-18-ardb+git@google.com>
Subject: [PATCH 8/8] crypto: arm64/aes-ccm - Merge finalization into
 en/decrypt asm helper
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The C glue code already infers whether or not the current iteration is
the final one, by comparing walk.nbytes with walk.total. This means we
can easily inform the asm helper of this as well, by conditionally
passing a pointer to the original IV, which is used in the finalization
of the MAC. This removes the need for a separate call into the asm code
to perform the finalization.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 32 ++++++++------------
 arch/arm64/crypto/aes-ce-ccm-glue.c | 27 ++++++++---------
 2 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index 75be3157bae1..c0d89f8ae4c4 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -44,28 +44,12 @@
 	aese	\vb\().16b, v4.16b
 	.endm
 
-	/*
-	 * void ce_aes_ccm_final(u8 mac[], u8 const ctr[], u8 const rk[],
-	 * 			 u32 rounds);
-	 */
-SYM_FUNC_START(ce_aes_ccm_final)
-	ld1	{v0.16b}, [x0]			/* load mac */
-	ld1	{v1.16b}, [x1]			/* load 1st ctriv */
-
-	aes_encrypt	v0, v1, w3
-
-	/* final round key cancels out */
-	eor	v0.16b, v0.16b, v1.16b		/* en-/decrypt the mac */
-	st1	{v0.16b}, [x0]			/* store result */
-	ret
-SYM_FUNC_END(ce_aes_ccm_final)
-
 SYM_FUNC_START_LOCAL(aes_ccm_do_crypt)
 	load_round_keys	x3, w4, x10
 
+	ld1	{v0.16b}, [x5]			/* load mac */
 	cbz	x2, 5f
 	ldr	x8, [x6, #8]			/* load lower ctr */
-	ld1	{v0.16b}, [x5]			/* load mac */
 CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 0:	/* outer loop */
 	ld1	{v1.8b}, [x6]			/* load upper ctr */
@@ -89,9 +73,9 @@ CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 
 	bne	0b
 CPU_LE(	rev	x8, x8			)
-	st1	{v0.16b}, [x5]			/* store mac */
 	str	x8, [x6, #8]			/* store lsb end of ctr (BE) */
-5:	ret
+5:	cbz	x7, 8f
+	b	7f
 
 6:	add	x1, x1, w2, sxtw		/* rewind the input pointer (w2 < 0) */
 	add	x0, x0, w2, sxtw		/* rewind the output pointer */
@@ -111,8 +95,16 @@ CPU_LE(	rev	x8, x8			)
 	eor	v0.16b, v0.16b, v22.16b		/* fold plaintext into mac */
 	tbx	v2.16b, {v6.16b}, v8.16b	/* insert output from previous iteration */
 
-	st1	{v0.16b}, [x5]			/* store mac */
 	st1	{v2.16b}, [x0]			/* store output block */
+	cbz	x7, 8f				/* time to finalize MAC? */
+7:	ld1	{v1.16b}, [x7]			/* load 1st ctriv */
+
+	aes_encrypt	v0, v1, w4
+
+	/* final round key cancels out */
+	eor	v0.16b, v0.16b, v1.16b		/* en-/decrypt the mac */
+
+8:	st1	{v0.16b}, [x5]			/* store mac */
 	ret
 SYM_FUNC_END(aes_ccm_do_crypt)
 
diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index ed3d79e05112..ce9b28e3c7d6 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -38,14 +38,11 @@ asmlinkage u32 ce_aes_mac_update(u8 const in[], u32 const rk[], int rounds,
 
 asmlinkage void ce_aes_ccm_encrypt(u8 out[], u8 const in[], u32 cbytes,
 				   u32 const rk[], u32 rounds, u8 mac[],
-				   u8 ctr[]);
+				   u8 ctr[], u8 const final_iv[]);
 
 asmlinkage void ce_aes_ccm_decrypt(u8 out[], u8 const in[], u32 cbytes,
 				   u32 const rk[], u32 rounds, u8 mac[],
-				   u8 ctr[]);
-
-asmlinkage void ce_aes_ccm_final(u8 mac[], u8 const ctr[], u32 const rk[],
-				 u32 rounds);
+				   u8 ctr[], u8 const final_iv[]);
 
 static int ccm_setkey(struct crypto_aead *tfm, const u8 *in_key,
 		      unsigned int key_len)
@@ -210,9 +207,12 @@ static int ccm_encrypt(struct aead_request *req)
 		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
 		u8 buf[AES_BLOCK_SIZE];
+		u8 *final_iv = NULL;
 
-		if (walk.nbytes == walk.total)
+		if (walk.nbytes == walk.total) {
 			tail = 0;
+			final_iv = orig_iv;
+		}
 
 		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
 			src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
@@ -220,14 +220,11 @@ static int ccm_encrypt(struct aead_request *req)
 
 		ce_aes_ccm_encrypt(dst, src, walk.nbytes - tail,
 				   ctx->key_enc, num_rounds(ctx),
-				   mac, walk.iv);
+				   mac, walk.iv, final_iv);
 
 		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
 			memcpy(walk.dst.virt.addr, dst, walk.nbytes);
 
-		if (walk.nbytes == walk.total)
-			ce_aes_ccm_final(mac, orig_iv, ctx->key_enc, num_rounds(ctx));
-
 		if (walk.nbytes) {
 			err = skcipher_walk_done(&walk, tail);
 		}
@@ -277,9 +274,12 @@ static int ccm_decrypt(struct aead_request *req)
 		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
 		u8 buf[AES_BLOCK_SIZE];
+		u8 *final_iv = NULL;
 
-		if (walk.nbytes == walk.total)
+		if (walk.nbytes == walk.total) {
 			tail = 0;
+			final_iv = orig_iv;
+		}
 
 		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
 			src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
@@ -287,14 +287,11 @@ static int ccm_decrypt(struct aead_request *req)
 
 		ce_aes_ccm_decrypt(dst, src, walk.nbytes - tail,
 				   ctx->key_enc, num_rounds(ctx),
-				   mac, walk.iv);
+				   mac, walk.iv, final_iv);
 
 		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
 			memcpy(walk.dst.virt.addr, dst, walk.nbytes);
 
-		if (walk.nbytes == walk.total)
-			ce_aes_ccm_final(mac, orig_iv, ctx->key_enc, num_rounds(ctx));
-
 		if (walk.nbytes) {
 			err = skcipher_walk_done(&walk, tail);
 		}
-- 
2.43.0.275.g3460e3d667-goog

