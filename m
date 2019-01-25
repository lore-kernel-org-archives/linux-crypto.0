Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C7CC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 08:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 204872184B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 08:49:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="JsBZ6fDn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbfAYItX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:49:23 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37449 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfAYItX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 03:49:23 -0500
Received: by mail-wr1-f65.google.com with SMTP id s12so9372622wrt.4
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jan 2019 00:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/v31AH8ksTfHDYNKI/9rR22EhE+xJdER9lUWsya6zvU=;
        b=JsBZ6fDndDz/OC6Hiu3/H1urS8F+4YM7fZuaOoWb5W8qSbC+9/0IHs0JGry4dVCHjJ
         V5WyYVyKb3KJD2GHq/RZNKKUc/hc0W+Z83bUPaJ5GpSIu2XdiYuwPlrzlBQWjT4z0s7m
         iTeGXWPCrlTMKBO5TdcGZkV9bEkCloY5HGhok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/v31AH8ksTfHDYNKI/9rR22EhE+xJdER9lUWsya6zvU=;
        b=Q29DOEzlKMHLV08RBGbNQXpsWXoS4rqVudr1o6WhNUXcbXF/798ZSsiUutwi6UUo5/
         xfVH86TlndktwnDS+Zl1Xo+O5Ru03tYoD6YYVw9z6OaVdWiMJgHPL32SHdUCr00FHAUO
         hj/SNMrj+XG+sjhjcZudFSbnoIG4b4wcmwhQLYz89OQJAtpiQ0fnKJPD0ylLZnwY4VNQ
         rTPm31iz4KWRzTCC1MijQpx787pSY5WYE0pSU26zIPTsh6iYvTh9lnJ5eXr6oo/r9t+i
         kKVNC2pHXif9ZX/FkdMLp60JoN08EQC3ce3v/CQpe+bT56Mi40Py4mNUyOAQm0vEkXVr
         cB7g==
X-Gm-Message-State: AHQUAuZvXdwVShGSRjwOlQoKqOvNab18cjtHIWdqfjbTC9pskAtswA0u
        /n9lfW7PIZS13FTg35jhBxQ8vQ1XtKCk8A==
X-Google-Smtp-Source: AHgI3IY1ilh618BB3E6JTEodDgZTrk1FVE4NUdP7Yn2pZYkASrhnA/YEqUVRPEBHo69qV3dMpfGbEg==
X-Received: by 2002:adf:ef88:: with SMTP id d8mr1476396wro.163.1548406161156;
        Fri, 25 Jan 2019 00:49:21 -0800 (PST)
Received: from dogfood.home ([2a01:cb1d:112:6f00:bcd4:806e:230a:673e])
        by smtp.gmail.com with ESMTPSA id 125sm112594574wmm.26.2019.01.25.00.49.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 00:49:20 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/4] crypto: arm/crct10dif - revert to C code for short inputs
Date:   Fri, 25 Jan 2019 09:49:12 +0100
Message-Id: <20190125084915.25411-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
References: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SIMD routine ported from x86 used to have a special code path
for inputs < 16 bytes, which got lost somewhere along the way.
Instead, the current glue code aligns the input pointer to permit
the NEON routine to use special versions of the vld1 instructions
that assume 16 byte alignment, but this could result in inputs of
less than 16 bytes to be passed in. This not only fails the new
extended tests that Eric has implemented, it also results in the
code reading past the end of the input, which could potentially
result in crashes when dealing with less than 16 bytes of input
at the end of a page which is followed by an unmapped page.

So update the glue code to only invoke the NEON routine if the
input is more than 16 bytes.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 1d481f1cd892 ("crypto: arm/crct10dif - port x86 SSE implementation to ARM")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/crct10dif-ce-core.S | 14 ++++++------
 arch/arm/crypto/crct10dif-ce-glue.c | 23 +++++---------------
 2 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
index ce45ba0c0687..16019b5961e7 100644
--- a/arch/arm/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -124,10 +124,10 @@ ENTRY(crc_t10dif_pmull)
 	vext.8		q10, qzr, q0, #4
 
 	// receive the initial 64B data, xor the initial crc value
-	vld1.64		{q0-q1}, [arg2, :128]!
-	vld1.64		{q2-q3}, [arg2, :128]!
-	vld1.64		{q4-q5}, [arg2, :128]!
-	vld1.64		{q6-q7}, [arg2, :128]!
+	vld1.64		{q0-q1}, [arg2]!
+	vld1.64		{q2-q3}, [arg2]!
+	vld1.64		{q4-q5}, [arg2]!
+	vld1.64		{q6-q7}, [arg2]!
 CPU_LE(	vrev64.8	q0, q0			)
 CPU_LE(	vrev64.8	q1, q1			)
 CPU_LE(	vrev64.8	q2, q2			)
@@ -167,7 +167,7 @@ CPU_LE(	vrev64.8	q7, q7			)
 _fold_64_B_loop:
 
 	.macro		fold64, reg1, reg2
-	vld1.64		{q11-q12}, [arg2, :128]!
+	vld1.64		{q11-q12}, [arg2]!
 
 	vmull.p64	q8, \reg1\()h, d21
 	vmull.p64	\reg1, \reg1\()l, d20
@@ -238,7 +238,7 @@ _16B_reduction_loop:
 	vmull.p64	q7, d15, d21
 	veor.8		q7, q7, q8
 
-	vld1.64		{q0}, [arg2, :128]!
+	vld1.64		{q0}, [arg2]!
 CPU_LE(	vrev64.8	q0, q0		)
 	vswp		d0, d1
 	veor.8		q7, q7, q0
@@ -335,7 +335,7 @@ _less_than_128:
 	vmov.i8		q0, #0
 	vmov		s3, arg1_low32		// get the initial crc value
 
-	vld1.64		{q7}, [arg2, :128]!
+	vld1.64		{q7}, [arg2]!
 CPU_LE(	vrev64.8	q7, q7		)
 	vswp		d14, d15
 	veor.8		q7, q7, q0
diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
index d428355cf38d..14c19c70a841 100644
--- a/arch/arm/crypto/crct10dif-ce-glue.c
+++ b/arch/arm/crypto/crct10dif-ce-glue.c
@@ -35,26 +35,15 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int length)
 {
 	u16 *crc = shash_desc_ctx(desc);
-	unsigned int l;
 
-	if (!may_use_simd()) {
-		*crc = crc_t10dif_generic(*crc, data, length);
+	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
+		kernel_neon_begin();
+		*crc = crc_t10dif_pmull(*crc, data, length);
+		kernel_neon_end();
 	} else {
-		if (unlikely((u32)data % CRC_T10DIF_PMULL_CHUNK_SIZE)) {
-			l = min_t(u32, length, CRC_T10DIF_PMULL_CHUNK_SIZE -
-				  ((u32)data % CRC_T10DIF_PMULL_CHUNK_SIZE));
-
-			*crc = crc_t10dif_generic(*crc, data, l);
-
-			length -= l;
-			data += l;
-		}
-		if (length > 0) {
-			kernel_neon_begin();
-			*crc = crc_t10dif_pmull(*crc, data, length);
-			kernel_neon_end();
-		}
+		*crc = crc_t10dif_generic(*crc, data, length);
 	}
+
 	return 0;
 }
 
-- 
2.17.1

