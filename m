Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021CEC282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 18:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6A26218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 18:27:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="hl6687nM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfAXS1W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:27:22 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39538 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAXS1W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 13:27:22 -0500
Received: by mail-wm1-f65.google.com with SMTP id y8so4106117wmi.4
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 10:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=usyANgO+md6MAxAYC+xPQ71SM8cvmj1kbE42YVBL7tM=;
        b=hl6687nMxC/Lvjr/tM2DjrjI/c8ecYNEFmGYcpWIz77p8QVJs+H+jeO7eVzqdxvccp
         mTMjUSf5HKVBt5Zic8+nAiGOYWobjoBpdi5d5nsFkkGsb42uTDGMuzhsyH06T4Yk6AE3
         jnTYDN0edqWfUgdVxi/XmW+dAlLOU3jED3uRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=usyANgO+md6MAxAYC+xPQ71SM8cvmj1kbE42YVBL7tM=;
        b=cn8va3o4vYbEUpyUCxWLzPXWRhgZrTx7NXyvlVNj7+5RDGRfUkAth7kaK6frJGRe7s
         r9Q2cOE+PFJEQUGZ3ciVxtuNGrPRHesrX/uO/h0kpYTEGVSjHehvTp6y9+zJmiVGQaxT
         USisBf494T3jn46tCGCJguRkNbBihsNkaHxmEQz/YY/fx/e9e4Dkup4y/OQedSzeNg3l
         Anvb8KVlEO2NHb8GvrQGwB3JGsIyChvaZcGiXomxXUDliAqFMwmd8m6SlQdHgJOruyiL
         4Zj37+ZSQaqB4StJNrq4C2jMaaIR18bqKIrv4OKbOkCkNJPtW9vEz4tZlb7AUNj/kG8V
         x/OQ==
X-Gm-Message-State: AJcUukfz+Wgz3Wtnv6RqlSGJIdRoOyAdtv3Ar99copnNqaLX5vBq6wDy
        sHZVYW47xMXUubE9sFYRtmGqQwN1n5rpag==
X-Google-Smtp-Source: ALg8bN6umYxuDwtCZR0kXhWSQn62gKlMp2P3bU8k5ex8ORyT9rov7POdD0GGVR8hsIOR3tcpeqO83Q==
X-Received: by 2002:a1c:e044:: with SMTP id x65mr3685792wmg.86.1548354439745;
        Thu, 24 Jan 2019 10:27:19 -0800 (PST)
Received: from dogfood.home ([2a01:cb1d:112:6f00:bcd4:806e:230a:673e])
        by smtp.gmail.com with ESMTPSA id 202sm73247138wmt.8.2019.01.24.10.27.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 10:27:18 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm/crct10dif - revert to C code for short inputs
Date:   Thu, 24 Jan 2019 19:27:11 +0100
Message-Id: <20190124182712.7142-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190124182712.7142-1-ard.biesheuvel@linaro.org>
References: <20190124182712.7142-1-ard.biesheuvel@linaro.org>
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
code reading before the input pointer, which could potentially
result in crashes when dealing with less than 16 bytes of input
at the start of a page which is preceded by an unmapped page.

So update the glue code to only invoke the NEON routine if the
input is more than 16 bytes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/crct10dif-ce-core.S | 20 ++++++++---------
 arch/arm/crypto/crct10dif-ce-glue.c | 23 +++++---------------
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
index ce45ba0c0687..3fd13d7c842c 100644
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
@@ -150,7 +150,7 @@ CPU_LE(	vrev64.8	q7, q7			)
 	veor.8		q0, q0, q10
 
 	adr		ip, rk3
-	vld1.64		{q10}, [ip, :128]	// xmm10 has rk3 and rk4
+	vld1.64		{q10}, [ip]	// xmm10 has rk3 and rk4
 
 	//
 	// we subtract 256 instead of 128 to save one instruction from the loop
@@ -167,7 +167,7 @@ CPU_LE(	vrev64.8	q7, q7			)
 _fold_64_B_loop:
 
 	.macro		fold64, reg1, reg2
-	vld1.64		{q11-q12}, [arg2, :128]!
+	vld1.64		{q11-q12}, [arg2]!
 
 	vmull.p64	q8, \reg1\()h, d21
 	vmull.p64	\reg1, \reg1\()l, d20
@@ -203,13 +203,13 @@ CPU_LE(	vrev64.8	q12, q12		)
 	// constants
 
 	adr		ip, rk9
-	vld1.64		{q10}, [ip, :128]!
+	vld1.64		{q10}, [ip]!
 
 	.macro		fold16, reg, rk
 	vmull.p64	q8, \reg\()l, d20
 	vmull.p64	\reg, \reg\()h, d21
 	.ifnb		\rk
-	vld1.64		{q10}, [ip, :128]!
+	vld1.64		{q10}, [ip]!
 	.endif
 	veor.8		q7, q7, q8
 	veor.8		q7, q7, \reg
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

