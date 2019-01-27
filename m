Return-Path: <SRS0=Rknj=QD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FBDC282C0
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0BC12184E
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="iJ9ozE/N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfA0JRQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jan 2019 04:17:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55647 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfA0JRQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jan 2019 04:17:16 -0500
Received: by mail-wm1-f67.google.com with SMTP id y139so10644314wmc.5
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jan 2019 01:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E1b+RzfgoGRiRm1hKJ0ZbQ3LFQyMbA6410V+FseCjyQ=;
        b=iJ9ozE/N27xwQOzWq7nlQW2d0IrPfNr2Gs8VqAGzKTnDMW59Pw5NN+60LgbeqyP5vj
         KfVrLrHOxuwuzk8A0utvgEHbyPUyp94Ck5akrJDiJZcG2SihZZuXhHUjTi2+3twaTVLh
         CBVm1GMjf0MnXWxxsAQbKdttlPf3SX0w/jMWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E1b+RzfgoGRiRm1hKJ0ZbQ3LFQyMbA6410V+FseCjyQ=;
        b=Ye99qyq4Pqg19XOS7OQW+AhGD4TU9necwm1Pb7lyUrlh5BxIzsWuyvtvSN76BPv5+Z
         j/p5/2OopEULc2LC/iNG4mQmqRcHzKC7HtRnpKlRdyItMRyGncLQzH/+Qv/E3tKzaoH3
         KN6og4XJlYdmpP2iWA/MsqoLikcGI8n1tqdQaVXNJzLGP5KlsPK7d0+/BmiilkUf0NCy
         E51h7g75qDRpqcUTzannZ/ZOm1Ut37SvFgxP0bvk9K8tvZd+fkSzqgt2T+BcXRRjxWYF
         XabTnM24MqHxhdXwe9TfGwrF0ZBXlmXSLF8A+RFNX6frCy9oe4En1IcSbAcClPHbyCRM
         ZNhA==
X-Gm-Message-State: AJcUukc5ieS6COhnXdgNiik5Wy70gYCuVU8kknrgqYaFdhPqe/Mx8+eE
        C+/VjCK5dUfuaGfFCScxQx5MDbfcBfcNPQ==
X-Google-Smtp-Source: ALg8bN5ttMJ9+aLqKK9h/dQ/8ab3iRGNT7X0ujUH88UurMDKKh+5rSPKHXNk6GnRKx8KCFLGXW/F1Q==
X-Received: by 2002:a1c:7d06:: with SMTP id y6mr12720895wmc.7.1548580634492;
        Sun, 27 Jan 2019 01:17:14 -0800 (PST)
Received: from sudo.home ([2a01:cb1d:112:6f00:887d:32e9:9391:d3bf])
        by smtp.gmail.com with ESMTPSA id o5sm45397013wrw.46.2019.01.27.01.17.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 01:17:13 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 1/4] crypto: arm/crct10dif - revert to C code for short inputs
Date:   Sun, 27 Jan 2019 10:16:52 +0100
Message-Id: <20190127091655.6262-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
References: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
input is at least 16 bytes.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
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
2.20.1

