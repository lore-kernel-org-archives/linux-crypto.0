Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23FF2C842
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 17:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705597679; cv=none; b=thiBS5RL/iL+3o5uFId5+1wlEpqs1CfEiAWCOnn+9o2lPB+ThrwLdwb3dNyHnoqMXxSxG+/ycIzPEJ21WkTOGjwHyITTkkve/pjmHIkou1ASeBqP1/OUdKbUlCcXG70rl+H8T1kGkIvwhXgchCEh7G5rkyIQNAlzajPJ/7R4orY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705597679; c=relaxed/simple;
	bh=K5rNQyrGYBNM4tuICSMgnyjR0smFKeJ7PyYe4DkbrUI=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=AcrLJOCzwAzQnAfReMLu4VZaGHt2MpxHXjheD72wcE+FFtDO1D/OSw8OuTHmI0HV9RHdJPLtUet4m9iOFrAJsEd0i6ugnGfDNTTmbJU1Kxl5zjWIh+tWYfg8gA6wodWCbxaT4vbipJO8o0g83k6ji3cVyGlM5NX4r94KH9Y1Ed8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fLZBvaVA; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fLZBvaVA"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-337ad48edf8so2943614f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 09:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705597676; x=1706202476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=acy82ql0ys5q2HlzSPX79aRI8SY/9cNbtRBfVJLqGZ0=;
        b=fLZBvaVAUnsUDA01KW7TjFFRT3wt61bCavvdneyudy8wskDV8btkP7x/05AnIW6elr
         JClQXjbYUpN1hhhxXwyjxqv84sl7EO8HaZDfth7EpogXj6KMdJQlxXzil1sOEWVjttrz
         sOlGg3Aj5S6YcH+PcF268cuqt0JNq3yXf1EzvS7SO+pZ/n5ow6hHC8jJ/JF3EKaqhv2e
         x5QlldPkl7Wyi6z6deNywXeJuNNBLtXZdVS5vl7EbU1C9cQz2fDxCLD8pEu2IHVx0wTu
         GpJyw+RKXlWpSfSwmCVD6mZbNHWO5H1hGhukY4vpyGIXRtWCSK2GNTNtceFz9z2NMFev
         yR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705597676; x=1706202476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=acy82ql0ys5q2HlzSPX79aRI8SY/9cNbtRBfVJLqGZ0=;
        b=iPl6RiHToGItkr3FzPdytPCnjk+SrwUQhz9omVmMSnB4yTHFSXR3cCqOvgTllfNA1v
         rqMA9Xa75ndEbA9LRk6IW/3Psb74A69t+9DmUmzVOSHpcCI4u/NvzGMNF7As0RuTvFve
         Ck4N7ml+rpYCViP503axqjR7Ob6fUCEUHbh/e04yPpGWJs9cEVysTsldU0AzOZWigwpL
         lCKbWXnns646x0UI0w2Fu0ifNuMq4VBvC7XgDbMW5bgVL/thKqzR/j6JcT++3Am30JL1
         qRbRP+3+RLwVpkE96RCxysdSmNUfnnQFGr6ZtdiIf/OBXUcRu3NK6qIpUef0fTCti3w9
         184A==
X-Gm-Message-State: AOJu0YxqpfLHxuRbwLO/haD9fK3xH0kiiMKQ+RO+PtuR7u/9X/0B+DZs
	J5tuboYjdR4HP+TsxAc6sQJfs+nEIvt9edJv4HH+V9afobUEpBnQIY6H0sXRxbgIvunng6TNq+j
	ba9P6jM1WGTil6kaw8JbsKjDQMVdjDupkqVVJFrsfjf6SlmrhXAGzFjH9JTzXYvk8Hf6oYoNYwb
	AzZrmrLn1HLOfCfyfv7IhpVwNLBCIgeQ==
X-Google-Smtp-Source: AGHT+IHL6F+ouXye7Uuy2+7YSiXzxvFuXChMh9R0NbuPg/jCvfX27Bc5a4dJull84IXlchQQpOBYOMXL
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:6000:1d82:b0:337:7b7a:6538 with SMTP id
 bk2-20020a0560001d8200b003377b7a6538mr5541wrb.0.1705597676131; Thu, 18 Jan
 2024 09:07:56 -0800 (PST)
Date: Thu, 18 Jan 2024 18:06:37 +0100
In-Reply-To: <20240118170628.3049797-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240118170628.3049797-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5931; i=ardb@kernel.org;
 h=from:subject; bh=4wALGXEGRak98LWDvH8ri947m6Dxgwb64gGS29g676g=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXVl1NzER7f27mDilzv79crslq+zbpXul542UXLxJSvfJ
 bHPl8xN6ihlYRDjYJAVU2QRmP333c7TE6VqnWfJwsxhZQIZwsDFKQATefiGkaFhAces9x+Vbhe8
 cjl6aaX6juJNohzLl4tYTrj+pMF+5fUohr/yfB/nLi0+93vpiU017LPWmzi03zPTO33f3TZV+5B jVz4DAA==
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240118170628.3049797-18-ardb+git@google.com>
Subject: [PATCH v2 8/8] crypto: arm64/aes-ccm - Merge finalization into
 en/decrypt asm helpers
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The C glue code already infers whether or not the current iteration is
the final one, by comparing walk.nbytes with walk.total. This means we
can easily inform the asm helpers of this as well, by conditionally
passing a pointer to the original IV, which is used in the finalization
of the MAC. This removes the need for a separate call into the asm code
to perform the finalization.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 40 +++++++++-----------
 arch/arm64/crypto/aes-ce-ccm-glue.c | 27 ++++++-------
 2 files changed, 29 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index bf3a888a5615..f2624238fd95 100644
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
 	.macro	aes_ccm_do_crypt,enc
 	load_round_keys	x3, w4, x10
 
-	cbz	x2, 5f
-	ldr	x8, [x6, #8]			/* load lower ctr */
 	ld1	{v0.16b}, [x5]			/* load mac */
+	cbz	x2, ce_aes_ccm_final
+	ldr	x8, [x6, #8]			/* load lower ctr */
 CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 0:	/* outer loop */
 	ld1	{v1.8b}, [x6]			/* load upper ctr */
@@ -90,9 +74,10 @@ CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 	st1	{v6.16b}, [x0], #16		/* write output block */
 	bne	0b
 CPU_LE(	rev	x8, x8			)
-	st1	{v0.16b}, [x5]			/* store mac */
 	str	x8, [x6, #8]			/* store lsb end of ctr (BE) */
-5:	ret
+	cbnz	x7, ce_aes_ccm_final
+	st1	{v0.16b}, [x5]			/* store mac */
+	ret
 	.endm
 
 SYM_FUNC_START_LOCAL(ce_aes_ccm_crypt_tail)
@@ -116,18 +101,27 @@ SYM_FUNC_START_LOCAL(ce_aes_ccm_crypt_tail)
 	tbl	v2.16b, {v2.16b}, v9.16b	/* copy plaintext to start of v2 */
 	eor	v0.16b, v0.16b, v2.16b		/* fold plaintext into mac */
 
-	st1	{v0.16b}, [x5]			/* store mac */
 	st1	{v7.16b}, [x0]			/* store output block */
+	cbz	x7, 0f
+
+SYM_INNER_LABEL(ce_aes_ccm_final, SYM_L_LOCAL)
+	ld1	{v1.16b}, [x7]			/* load 1st ctriv */
+
+	aes_encrypt	v0, v1, w4
+
+	/* final round key cancels out */
+	eor	v0.16b, v0.16b, v1.16b		/* en-/decrypt the mac */
+0:	st1	{v0.16b}, [x5]			/* store result */
 	ret
 SYM_FUNC_END(ce_aes_ccm_crypt_tail)
 
 	/*
 	 * void ce_aes_ccm_encrypt(u8 out[], u8 const in[], u32 cbytes,
 	 * 			   u8 const rk[], u32 rounds, u8 mac[],
-	 * 			   u8 ctr[]);
+	 * 			   u8 ctr[], u8 const final_iv[]);
 	 * void ce_aes_ccm_decrypt(u8 out[], u8 const in[], u32 cbytes,
 	 * 			   u8 const rk[], u32 rounds, u8 mac[],
-	 * 			   u8 ctr[]);
+	 * 			   u8 ctr[], u8 const final_iv[]);
 	 */
 SYM_FUNC_START(ce_aes_ccm_encrypt)
 	movi	v22.16b, #255
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
2.43.0.381.gb435a96ce8-goog

