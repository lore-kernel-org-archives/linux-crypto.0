Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5F3C4151A
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71237222A1
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550131462;
	bh=sprNmgjGPhovkGLy/OMNb7jw08pmHS84QG8EZNCIbFg=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YK/11NECdLC/boMwTXeBWuvLNUEeeE2qbewv1AmG4rCG6UV/yv/1l4Z/McIWG+ahf
	 rY0BrXfdb41W8UBsX53l1qhBU8kgUoLYUi0UrDRJxGyCWZ+BTWNuMeQef9p9VhyMd/
	 RNOyMYZcslHZd30VK5CpdNRneEld+nc9YAElTrO4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfBNIEV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394097AbfBNIET (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 03:04:19 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F098222D9;
        Thu, 14 Feb 2019 08:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550131458;
        bh=sprNmgjGPhovkGLy/OMNb7jw08pmHS84QG8EZNCIbFg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cJwSn5bxOx1wqNA0qZ0O7g4pDEGZ6bRZO4YIJ1xEXV+Z44v8n29D+/F5NInNZXeOO
         VdD1YU6GOO4dlbmBugj9s0R+7t+wmy+yWJzIn8ne+U5UO25jKoVeIxlPQYoedGd2cR
         m4dqkaasyd7hF+MjayvO17V6+w1BjwALr98aZy60=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/6] crypto: arm/aes-ce - update IV after partial final CTR block
Date:   Thu, 14 Feb 2019 00:03:55 -0800
Message-Id: <20190214080355.8112-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214080355.8112-1-ebiggers@kernel.org>
References: <20190214080355.8112-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make the arm ctr-aes-ce algorithm update the IV buffer to contain the
next counter after processing a partial final block, rather than leave
it as the last counter.  This makes ctr-aes-ce pass the updated AES-CTR
tests.  This change also makes the code match the arm64 version in
arch/arm64/crypto/aes-modes.S more closely.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/aes-ce-core.S | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index ba8e6a32fdc9..bc53bcaa772e 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -317,25 +317,27 @@ ENTRY(ce_aes_ctr_encrypt)
 .Lctrloop:
 	vmov		q0, q6
 	bl		aes_encrypt
-	subs		r4, r4, #1
-	bmi		.Lctrtailblock		@ blocks < 0 means tail block
-	vld1.8		{q3}, [r1]!
-	veor		q3, q0, q3
-	vst1.8		{q3}, [r0]!
 
 	adds		r6, r6, #1		@ increment BE ctr
 	rev		ip, r6
 	vmov		s27, ip
 	bcs		.Lctrcarry
-	teq		r4, #0
+
+.Lctrcarrydone:
+	subs		r4, r4, #1
+	bmi		.Lctrtailblock		@ blocks < 0 means tail block
+	vld1.8		{q3}, [r1]!
+	veor		q3, q0, q3
+	vst1.8		{q3}, [r0]!
 	bne		.Lctrloop
+
 .Lctrout:
-	vst1.8		{q6}, [r5]
+	vst1.8		{q6}, [r5]		@ return next CTR value
 	pop		{r4-r6, pc}
 
 .Lctrtailblock:
-	vst1.8		{q0}, [r0, :64]		@ return just the key stream
-	pop		{r4-r6, pc}
+	vst1.8		{q0}, [r0, :64]		@ return the key stream
+	b		.Lctrout
 
 .Lctrcarry:
 	.irp		sreg, s26, s25, s24
@@ -344,11 +346,9 @@ ENTRY(ce_aes_ctr_encrypt)
 	adds		ip, ip, #1
 	rev		ip, ip
 	vmov		\sreg, ip
-	bcc		0f
+	bcc		.Lctrcarrydone
 	.endr
-0:	teq		r4, #0
-	beq		.Lctrout
-	b		.Lctrloop
+	b		.Lctrcarrydone
 ENDPROC(ce_aes_ctr_encrypt)
 
 	/*
-- 
2.20.1

