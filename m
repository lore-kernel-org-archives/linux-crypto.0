Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A41C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 17:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0388F20645
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 17:39:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mWZMXD2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbfFXRjW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 13:39:22 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:51233 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbfFXRjW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 13:39:22 -0400
Received: by mail-wm1-f52.google.com with SMTP id 207so199624wma.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 10:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ynFIMn+6TN2cPawLGFkoRWgCAGYQqRbJZUBKk5aR5VM=;
        b=mWZMXD2Mz4jzRorcmsKQnFyKELh8iJoJ3F8tCEPfq3IcyHFyHt4tcCdGbBpMQ0wm+W
         21+sKKG72OT7ohBCLAXWWOwHWqRDxM0tiUXn1lUizu8V1HIbb78QmOt6VEj0Phm3pyWX
         oYT1CSWuOu07rArFvHbAiQxHVXkPvHWF3Iz0WFG1p4aIP+1PDaAn0ewDX9goAOJDNMG+
         wvxJE3/7cyRTNEjX7yTdYTMKvKP3fgPG9cyXODDY/Cw91VWYJovF5iWcsOjbLcMC0VMx
         vIM2MLxcJryVvPuaGzeoi9IjDCuEQ5BZazjxc7Jpc2rBx+wdLysOSPYASqfZaap6hqfB
         rxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ynFIMn+6TN2cPawLGFkoRWgCAGYQqRbJZUBKk5aR5VM=;
        b=G85C+vQ1jVyKcGzfJD24yyO5nmuMXgXjrVht86cv44f5Jt7nlMf8/4NylTeO4pfChY
         Zbun88zBzcVHvWNUErttnxkjS8DHlv3Ob1+o1eVhQ7PwXvC8kfcE99qUc/SkCCsoiTvY
         u5NVBTTaagOA7biWWswSlp8vs7OQUZXAN0YmkHPxy2Ux8KiXia+szIMi20ja8B/ZncBE
         0lg0kbnYlru9hnZRTmTXfc3fbX/t1Nkrhi9c6TNYGbut3MvuKE7VPf2F55fAxpHWkNMi
         54Ov2NBFA0gD249ozMO423MUTdzN9nvijADrzITSHzdUrLOM6SMfyvwAVrHS5ZOYLciM
         jvcA==
X-Gm-Message-State: APjAAAVvqknYirL/Vk1U2RyuQepFsQK8hhjLb8fm2Bgl9ln8E+s1o0BA
        xbU7ZUjqNPzVxgelL7GL37892kV5Il8=
X-Google-Smtp-Source: APXvYqzeT8aIw1zjffCkg7nnMDCbXCRp84dpV4Xom+X6rWl9uZbVncv9UcLFrE2VtfeaRJrr+VZLbQ==
X-Received: by 2002:a05:600c:20d:: with SMTP id 13mr16668238wmi.141.1561397958935;
        Mon, 24 Jun 2019 10:39:18 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-10-211.w90-88.abo.wanadoo.fr. [90.88.131.211])
        by smtp.gmail.com with ESMTPSA id s10sm260787wmf.8.2019.06.24.10.39.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 10:39:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        linux-arm-kernel@lists.infradead.org, steve.capper@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm64/aes-ce - add 5 way interleave routines
Date:   Mon, 24 Jun 2019 19:38:30 +0200
Message-Id: <20190624173831.8375-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624173831.8375-1-ard.biesheuvel@linaro.org>
References: <20190624173831.8375-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation of tweaking the accelerated AES chaining mode routines
to be able to use a 5-way stride, implement the core routines to
support processing 5 blocks of input at a time. While at it, drop
the 2 way versions, which have been unused for a while now.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce.S    | 58 ++++++++++++--------
 arch/arm64/crypto/aes-modes.S | 16 ++++++
 arch/arm64/crypto/aes-neon.S  | 46 +---------------
 3 files changed, 52 insertions(+), 68 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 143070510809..0fca5f463406 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -52,7 +52,7 @@
 	load_round_keys	\rounds, \temp
 	.endm
 
-	.macro		do_enc_Nx, de, mc, k, i0, i1, i2, i3
+	.macro		do_enc_Nx, de, mc, k, i0, i1, i2, i3, i4
 	aes\de		\i0\().16b, \k\().16b
 	aes\mc		\i0\().16b, \i0\().16b
 	.ifnb		\i1
@@ -63,27 +63,34 @@
 	aes\mc		\i2\().16b, \i2\().16b
 	aes\de		\i3\().16b, \k\().16b
 	aes\mc		\i3\().16b, \i3\().16b
+	.ifnb		\i4
+	aes\de		\i4\().16b, \k\().16b
+	aes\mc		\i4\().16b, \i4\().16b
+	.endif
 	.endif
 	.endif
 	.endm
 
-	/* up to 4 interleaved encryption rounds with the same round key */
-	.macro		round_Nx, enc, k, i0, i1, i2, i3
+	/* up to 5 interleaved encryption rounds with the same round key */
+	.macro		round_Nx, enc, k, i0, i1, i2, i3, i4
 	.ifc		\enc, e
-	do_enc_Nx	e, mc, \k, \i0, \i1, \i2, \i3
+	do_enc_Nx	e, mc, \k, \i0, \i1, \i2, \i3, \i4
 	.else
-	do_enc_Nx	d, imc, \k, \i0, \i1, \i2, \i3
+	do_enc_Nx	d, imc, \k, \i0, \i1, \i2, \i3, \i4
 	.endif
 	.endm
 
-	/* up to 4 interleaved final rounds */
-	.macro		fin_round_Nx, de, k, k2, i0, i1, i2, i3
+	/* up to 5 interleaved final rounds */
+	.macro		fin_round_Nx, de, k, k2, i0, i1, i2, i3, i4
 	aes\de		\i0\().16b, \k\().16b
 	.ifnb		\i1
 	aes\de		\i1\().16b, \k\().16b
 	.ifnb		\i3
 	aes\de		\i2\().16b, \k\().16b
 	aes\de		\i3\().16b, \k\().16b
+	.ifnb		\i4
+	aes\de		\i4\().16b, \k\().16b
+	.endif
 	.endif
 	.endif
 	eor		\i0\().16b, \i0\().16b, \k2\().16b
@@ -92,47 +99,52 @@
 	.ifnb		\i3
 	eor		\i2\().16b, \i2\().16b, \k2\().16b
 	eor		\i3\().16b, \i3\().16b, \k2\().16b
+	.ifnb		\i4
+	eor		\i4\().16b, \i4\().16b, \k2\().16b
+	.endif
 	.endif
 	.endif
 	.endm
 
-	/* up to 4 interleaved blocks */
-	.macro		do_block_Nx, enc, rounds, i0, i1, i2, i3
+	/* up to 5 interleaved blocks */
+	.macro		do_block_Nx, enc, rounds, i0, i1, i2, i3, i4
 	cmp		\rounds, #12
 	blo		2222f		/* 128 bits */
 	beq		1111f		/* 192 bits */
-	round_Nx	\enc, v17, \i0, \i1, \i2, \i3
-	round_Nx	\enc, v18, \i0, \i1, \i2, \i3
-1111:	round_Nx	\enc, v19, \i0, \i1, \i2, \i3
-	round_Nx	\enc, v20, \i0, \i1, \i2, \i3
+	round_Nx	\enc, v17, \i0, \i1, \i2, \i3, \i4
+	round_Nx	\enc, v18, \i0, \i1, \i2, \i3, \i4
+1111:	round_Nx	\enc, v19, \i0, \i1, \i2, \i3, \i4
+	round_Nx	\enc, v20, \i0, \i1, \i2, \i3, \i4
 2222:	.irp		key, v21, v22, v23, v24, v25, v26, v27, v28, v29
-	round_Nx	\enc, \key, \i0, \i1, \i2, \i3
+	round_Nx	\enc, \key, \i0, \i1, \i2, \i3, \i4
 	.endr
-	fin_round_Nx	\enc, v30, v31, \i0, \i1, \i2, \i3
+	fin_round_Nx	\enc, v30, v31, \i0, \i1, \i2, \i3, \i4
 	.endm
 
 	.macro		encrypt_block, in, rounds, t0, t1, t2
 	do_block_Nx	e, \rounds, \in
 	.endm
 
-	.macro		encrypt_block2x, i0, i1, rounds, t0, t1, t2
-	do_block_Nx	e, \rounds, \i0, \i1
-	.endm
-
 	.macro		encrypt_block4x, i0, i1, i2, i3, rounds, t0, t1, t2
 	do_block_Nx	e, \rounds, \i0, \i1, \i2, \i3
 	.endm
 
-	.macro		decrypt_block, in, rounds, t0, t1, t2
-	do_block_Nx	d, \rounds, \in
+	.macro		encrypt_block5x, i0, i1, i2, i3, i4, rounds, t0, t1, t2
+	do_block_Nx	e, \rounds, \i0, \i1, \i2, \i3, \i4
 	.endm
 
-	.macro		decrypt_block2x, i0, i1, rounds, t0, t1, t2
-	do_block_Nx	d, \rounds, \i0, \i1
+	.macro		decrypt_block, in, rounds, t0, t1, t2
+	do_block_Nx	d, \rounds, \in
 	.endm
 
 	.macro		decrypt_block4x, i0, i1, i2, i3, rounds, t0, t1, t2
 	do_block_Nx	d, \rounds, \i0, \i1, \i2, \i3
 	.endm
 
+	.macro		decrypt_block5x, i0, i1, i2, i3, i4, rounds, t0, t1, t2
+	do_block_Nx	d, \rounds, \i0, \i1, \i2, \i3, \i4
+	.endm
+
+#define MAX_STRIDE	5
+
 #include "aes-modes.S"
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 4ebc61375aa6..0dbeaf2ce9b1 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -13,6 +13,10 @@
 	.text
 	.align		4
 
+#ifndef MAX_STRIDE
+#define MAX_STRIDE	4
+#endif
+
 aes_encrypt_block4x:
 	encrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
 	ret
@@ -23,6 +27,18 @@ aes_decrypt_block4x:
 	ret
 ENDPROC(aes_decrypt_block4x)
 
+#if MAX_STRIDE == 5
+aes_encrypt_block5x:
+	encrypt_block5x	v0, v1, v2, v3, v4, w3, x2, x8, w7
+	ret
+ENDPROC(aes_encrypt_block5x)
+
+aes_decrypt_block5x:
+	decrypt_block5x	v0, v1, v2, v3, v4, w3, x2, x8, w7
+	ret
+ENDPROC(aes_decrypt_block5x)
+#endif
+
 	/*
 	 * aes_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		   int blocks)
diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
index 29100f692e8a..33bb6af309a3 100644
--- a/arch/arm64/crypto/aes-neon.S
+++ b/arch/arm64/crypto/aes-neon.S
@@ -117,26 +117,9 @@
 
 	/*
 	 * Interleaved versions: functionally equivalent to the
-	 * ones above, but applied to 2 or 4 AES states in parallel.
+	 * ones above, but applied to AES states in parallel.
 	 */
 
-	.macro		sub_bytes_2x, in0, in1
-	sub		v8.16b, \in0\().16b, v15.16b
-	tbl		\in0\().16b, {v16.16b-v19.16b}, \in0\().16b
-	sub		v9.16b, \in1\().16b, v15.16b
-	tbl		\in1\().16b, {v16.16b-v19.16b}, \in1\().16b
-	sub		v10.16b, v8.16b, v15.16b
-	tbx		\in0\().16b, {v20.16b-v23.16b}, v8.16b
-	sub		v11.16b, v9.16b, v15.16b
-	tbx		\in1\().16b, {v20.16b-v23.16b}, v9.16b
-	sub		v8.16b, v10.16b, v15.16b
-	tbx		\in0\().16b, {v24.16b-v27.16b}, v10.16b
-	sub		v9.16b, v11.16b, v15.16b
-	tbx		\in1\().16b, {v24.16b-v27.16b}, v11.16b
-	tbx		\in0\().16b, {v28.16b-v31.16b}, v8.16b
-	tbx		\in1\().16b, {v28.16b-v31.16b}, v9.16b
-	.endm
-
 	.macro		sub_bytes_4x, in0, in1, in2, in3
 	sub		v8.16b, \in0\().16b, v15.16b
 	tbl		\in0\().16b, {v16.16b-v19.16b}, \in0\().16b
@@ -215,25 +198,6 @@
 	eor		\in1\().16b, \in1\().16b, v11.16b
 	.endm
 
-	.macro		do_block_2x, enc, in0, in1, rounds, rk, rkp, i
-	ld1		{v15.4s}, [\rk]
-	add		\rkp, \rk, #16
-	mov		\i, \rounds
-1111:	eor		\in0\().16b, \in0\().16b, v15.16b	/* ^round key */
-	eor		\in1\().16b, \in1\().16b, v15.16b	/* ^round key */
-	movi		v15.16b, #0x40
-	tbl		\in0\().16b, {\in0\().16b}, v13.16b	/* ShiftRows */
-	tbl		\in1\().16b, {\in1\().16b}, v13.16b	/* ShiftRows */
-	sub_bytes_2x	\in0, \in1
-	subs		\i, \i, #1
-	ld1		{v15.4s}, [\rkp], #16
-	beq		2222f
-	mix_columns_2x	\in0, \in1, \enc
-	b		1111b
-2222:	eor		\in0\().16b, \in0\().16b, v15.16b	/* ^round key */
-	eor		\in1\().16b, \in1\().16b, v15.16b	/* ^round key */
-	.endm
-
 	.macro		do_block_4x, enc, in0, in1, in2, in3, rounds, rk, rkp, i
 	ld1		{v15.4s}, [\rk]
 	add		\rkp, \rk, #16
@@ -260,14 +224,6 @@
 	eor		\in3\().16b, \in3\().16b, v15.16b	/* ^round key */
 	.endm
 
-	.macro		encrypt_block2x, in0, in1, rounds, rk, rkp, i
-	do_block_2x	1, \in0, \in1, \rounds, \rk, \rkp, \i
-	.endm
-
-	.macro		decrypt_block2x, in0, in1, rounds, rk, rkp, i
-	do_block_2x	0, \in0, \in1, \rounds, \rk, \rkp, \i
-	.endm
-
 	.macro		encrypt_block4x, in0, in1, in2, in3, rounds, rk, rkp, i
 	do_block_4x	1, \in0, \in1, \in2, \in3, \rounds, \rk, \rkp, \i
 	.endm
-- 
2.20.1

