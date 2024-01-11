Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D134215AC2
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 12:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WC8Br4CZ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-33770774fe4so2121783f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 04:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704976419; x=1705581219; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gsbXqpi9ULnrk+17fUSwxAvQV2SegrOTXEZgPPiuxxY=;
        b=WC8Br4CZibpnKlLkRXjel96w0Ao+AkCqaP5H/ynrBGslJiB9eIkf/uKh50ceoVJ5MP
         LVPJB5b6HH1iATFWWVwN8A6gVp+rvvy5R6XzXM9iRqZab/p/o3EFFnxifrHWboNEHBLu
         vFdHIDfM4GZkXPW2gTsNn5l/+0OQj+zDkf0hK0rej24xWnostjlGz4cWu6fma8VMyKU+
         kQYVb8swNEg2ZNDI/hx6yLStdK+oJ68ebuzWFblMQBB57CRjqVypFX6NpLoTMCEeQgKG
         HZndB8AxP5a/bFDB6A4GH+M+XiiVvVL7uOPIVzYMB5V/eNLlC7MyKsY41f+vydyKwaiY
         mX9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976419; x=1705581219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gsbXqpi9ULnrk+17fUSwxAvQV2SegrOTXEZgPPiuxxY=;
        b=lhrs6S9YJV7uQZL0gl3En3rXTpo/KwxjqEK6p4DmmwduHrfk/GVHsLpqmHmhMLEDhL
         abOOim7bFA6ygO2wzGfYIOFZCKCc67g+ObpfmyaSfnVQvB9D0Va0MZDvg1ZSyzCizKRZ
         7C//Wv3J4PFaqflJDRBN8/HjPjktD98luVuAxijAktzS8zpPTjrhNAYPlbQDPnFNybXm
         xATNZ3OK+Jr4IwpjEeyuUrSBGm7Uqj88PfzznHgfNSpeCR03zTpwubuxQn3BLH+Wyth9
         K1H8VE0yGywjMQHcOUyxdGQYCrmRnW1SBVaONBjEogywmb2Jx5NzBEL+GKEDf0yzzpnR
         6GaA==
X-Gm-Message-State: AOJu0Yznx99oqx4FusqauOJmPY1M5fOS4FQXEi3/Ue43lGMrjiOg9PVQ
	caycdTs2y2wrl9nc4q2jlCE8bqjViAKRVzTvmBHc3mmbUkGCeKf2ofDJweCpOb0rWc15R1wuCZ8
	ji49YOypyFDFGIzNmySvDXBminInWU/kV6PlI5For11ff5INimXgj6EIVN1wzxi+QYOyYQoU=
X-Google-Smtp-Source: AGHT+IGZp3rZxcW6bq2OIhBvBAHr4dmfmsZ4GhwsvHccNRC8bNAK7xqSVfWZf2gjvw+ImFtAG6Jzadue
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a5d:5a1a:0:b0:337:8f8a:7ea4 with SMTP id
 bq26-20020a5d5a1a000000b003378f8a7ea4mr87wrb.3.1704976419187; Thu, 11 Jan
 2024 04:33:39 -0800 (PST)
Date: Thu, 11 Jan 2024 13:33:10 +0100
In-Reply-To: <20240111123302.589910-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111123302.589910-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3906; i=ardb@kernel.org;
 h=from:subject; bh=MZfjFiuAXpOqcK82PSkc20GbzzFi3AmIpe6u5XzRKDY=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXX+A9bMbJuV8s//7i9l28y0RrLuCvPPhP1z64/8U23uu
 8xbeXZ7RykLgxgHg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZiIdA/D/5ptM8s0W1bGFlyo
 mzpffeUEkXNuQn++T9v/QK1UR0fY+gTDf8eCjpwFzx6tLunS1GKP2CpaN3uy+4lPAe8NIxxerFd q4QQA
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111123302.589910-17-ardb+git@google.com>
Subject: [PATCH 7/8] crypto: arm64/aes-ccm - Merge encrypt and decrypt asm routines
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The encryption and decryption code paths are mostly identical, except
for a small difference where the plaintext input into the MAC is taken
from either the input or the output block.

We can factor this in quite easily using a vector bit select, and a few
additional XORs, without the need for branches. This way, we can use the
same asm helper on the encrypt and decrypt code paths.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 41 +++++++++-----------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index 0ec59fc4ef3e..75be3157bae1 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -60,7 +60,7 @@ SYM_FUNC_START(ce_aes_ccm_final)
 	ret
 SYM_FUNC_END(ce_aes_ccm_final)
 
-	.macro	aes_ccm_do_crypt,enc
+SYM_FUNC_START_LOCAL(aes_ccm_do_crypt)
 	load_round_keys	x3, w4, x10
 
 	cbz	x2, 5f
@@ -76,28 +76,24 @@ CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 
 	aes_encrypt	v0, v1, w4
 
+	eor	v0.16b, v0.16b, v5.16b		/* final round mac */
+	eor	v1.16b, v1.16b, v5.16b		/* final round enc */
 	subs	w2, w2, #16
 	bmi	6f				/* partial block? */
 	ld1	{v2.16b}, [x1], #16		/* load next input block */
-	.if	\enc == 1
-	eor	v2.16b, v2.16b, v5.16b		/* final round enc+mac */
-	eor	v6.16b, v1.16b, v2.16b		/* xor with crypted ctr */
-	.else
-	eor	v2.16b, v2.16b, v1.16b		/* xor with crypted ctr */
-	eor	v6.16b, v2.16b, v5.16b		/* final round enc */
-	.endif
-	eor	v0.16b, v0.16b, v2.16b		/* xor mac with pt ^ rk[last] */
+	eor	v6.16b, v2.16b, v1.16b		/* en/decrypt input block */
+	mov	v23.16b, v22.16b
+	bsl	v23.16b, v2.16b, v6.16b		/* select plaintext */
 	st1	{v6.16b}, [x0], #16		/* write output block */
+	eor	v0.16b, v0.16b, v23.16b		/* fold plaintext into mac */
+
 	bne	0b
 CPU_LE(	rev	x8, x8			)
 	st1	{v0.16b}, [x5]			/* store mac */
 	str	x8, [x6, #8]			/* store lsb end of ctr (BE) */
 5:	ret
 
-6:	eor	v0.16b, v0.16b, v5.16b		/* final round mac */
-	eor	v1.16b, v1.16b, v5.16b		/* final round enc */
-
-	add	x1, x1, w2, sxtw		/* rewind the input pointer (w2 < 0) */
+6:	add	x1, x1, w2, sxtw		/* rewind the input pointer (w2 < 0) */
 	add	x0, x0, w2, sxtw		/* rewind the output pointer */
 
 	adr_l	x8, .Lpermute			/* load permute vectors */
@@ -108,20 +104,17 @@ CPU_LE(	rev	x8, x8			)
 
 	ld1	{v2.16b}, [x1]			/* load a full block of input */
 	tbl	v1.16b, {v1.16b}, v7.16b	/* move keystream to end of register */
-	.if	\enc == 1
-	tbl	v7.16b, {v2.16b}, v9.16b	/* copy plaintext to start of v7 */
+	tbl	v7.16b, {v2.16b}, v9.16b	/* copy input block to start of v7 */
 	eor	v2.16b, v2.16b, v1.16b		/* encrypt partial input block */
-	.else
-	eor	v2.16b, v2.16b, v1.16b		/* decrypt partial input block */
-	tbl	v7.16b, {v2.16b}, v9.16b	/* copy plaintext to start of v7 */
-	.endif
-	eor	v0.16b, v0.16b, v7.16b		/* fold plaintext into mac */
+	tbl	v9.16b, {v2.16b}, v9.16b	/* copy output block to start of v9 */
+	bsl	v22.16b, v7.16b, v9.16b		/* select plaintext */
+	eor	v0.16b, v0.16b, v22.16b		/* fold plaintext into mac */
 	tbx	v2.16b, {v6.16b}, v8.16b	/* insert output from previous iteration */
 
 	st1	{v0.16b}, [x5]			/* store mac */
 	st1	{v2.16b}, [x0]			/* store output block */
 	ret
-	.endm
+SYM_FUNC_END(aes_ccm_do_crypt)
 
 	/*
 	 * void ce_aes_ccm_encrypt(u8 out[], u8 const in[], u32 cbytes,
@@ -132,11 +125,13 @@ CPU_LE(	rev	x8, x8			)
 	 * 			   u8 ctr[]);
 	 */
 SYM_FUNC_START(ce_aes_ccm_encrypt)
-	aes_ccm_do_crypt	1
+	movi	v22.16b, #255
+	b	aes_ccm_do_crypt
 SYM_FUNC_END(ce_aes_ccm_encrypt)
 
 SYM_FUNC_START(ce_aes_ccm_decrypt)
-	aes_ccm_do_crypt	0
+	movi	v22.16b, #0
+	b	aes_ccm_do_crypt
 SYM_FUNC_END(ce_aes_ccm_decrypt)
 
 	.section ".rodata", "a"
-- 
2.43.0.275.g3460e3d667-goog

