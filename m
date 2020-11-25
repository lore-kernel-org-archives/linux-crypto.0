Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADED2C5519F
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 07:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3416A208B8
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 07:22:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTzoJ7Sv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgKYHWY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 02:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbgKYHWY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 02:22:24 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 206E120857;
        Wed, 25 Nov 2020 07:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606288943;
        bh=JkkXUobeOFJVhogiCBWd6tAQXnktbFv/uDDp/Lhar/g=;
        h=From:To:Cc:Subject:Date:From;
        b=uTzoJ7SvhHKTzgCo8lO/NNrLT8oHCBbbPLNfGSAQLIWesFFzmhep5+uhTxS3xq1tS
         8DABJLrt4mvO+YiM39otg/OgkV+htafEaneumESfDaGFwsubZ56qGIo6QuQgQSNWly
         D0jqruuypFiuZXhSNqH4xNUR0Lu9Pol/ycuXyKqw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: arm/aes-ce - work around Cortex-A72 erratum #1655431
Date:   Wed, 25 Nov 2020 08:22:16 +0100
Message-Id: <20201125072216.892-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ARM Cortex-A72 cores running in 32-bit mode are affected by a silicon
erratum (1655431: ELR recorded incorrectly on interrupt taken between
cryptographic instructions in a sequence [0]) where the second instruction
of a AES instruction pair may execute twice if an interrupt is taken right
after the first instruction consumes an input register of which a single
32-bit lane has been updated the last time it was modified.

This is not such a rare occurrence as it may seem: in counter mode, only
the least significant 32-bit word is incremented in the absence of a
carry, which makes our counter mode implementation susceptible to the
erratum.

So let's shuffle the counter assignments around a bit so that the most
recent updates when the AES instruction pair executes are 128-bit wide.

[0] ARM-EPM-012079 v11.0 Cortex-A72 MPCore Software Developers Errata Notice

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/aes-ce-core.S | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index 4d1707388d94..c0ef9680d90b 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -386,20 +386,20 @@ ENTRY(ce_aes_ctr_encrypt)
 .Lctrloop4x:
 	subs		r4, r4, #4
 	bmi		.Lctr1x
-	add		r6, r6, #1
+	add		ip, r6, #1
 	vmov		q0, q7
+	rev		ip, ip
+	add		lr, r6, #2
+	vmov		s31, ip
+	add		ip, r6, #3
+	rev		lr, lr
 	vmov		q1, q7
-	rev		ip, r6
-	add		r6, r6, #1
+	vmov		s31, lr
+	rev		ip, ip
 	vmov		q2, q7
-	vmov		s7, ip
-	rev		ip, r6
-	add		r6, r6, #1
+	vmov		s31, ip
+	add		r6, r6, #4
 	vmov		q3, q7
-	vmov		s11, ip
-	rev		ip, r6
-	add		r6, r6, #1
-	vmov		s15, ip
 	vld1.8		{q4-q5}, [r1]!
 	vld1.8		{q6}, [r1]!
 	vld1.8		{q15}, [r1]!
-- 
2.17.1

