Return-Path: <SRS0=uwZS=4S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE04C3F2CD
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Mar 2020 23:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9C4720CC7
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Mar 2020 23:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=agner.ch header.i=@agner.ch header.b="KYU+jEIv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgCAXhU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Mar 2020 18:37:20 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:51666 "EHLO
        mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgCAXhU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Mar 2020 18:37:20 -0500
Received: from zyt.lan (unknown [IPv6:2a02:169:3df5::564])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 17AB65C3CEF;
        Mon,  2 Mar 2020 00:37:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1583105838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=uEXP2A+ZFevJutYapB5Olb+X7MOi5DcNCS5e20uoEP8=;
        b=KYU+jEIvnTWc3/fWFLC+Vly+OrhuCyPaGadSfgb23VeMF7Y7XySy8A2q0Q6WIINgwNXoja
        +FdmYKg6spUdRBgV+sSk/eT5fxH+33lsOih/Wsx1M/TjdAs9AOplfU8ixGuf57A0EeyCJl
        jtuUzSDDzBg6wcTv5yR0lQtVZASr8VI=
From:   Stefan Agner <stefan@agner.ch>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux@armlinux.org.uk, manojgupta@google.com, jiancai@google.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH] crypto: arm/ghash-ce - define fpu before fpu registers are referenced
Date:   Mon,  2 Mar 2020 00:37:14 +0100
Message-Id: <c41cc67321d0b366e356440e6dbc9eceb1babfe4.1583105749.git.stefan@agner.ch>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Building ARMv7 with Clang's integrated assembler leads to errors such
as:
arch/arm/crypto/ghash-ce-core.S:34:11: error: register name expected
 t3l .req d16
          ^

Since no FPU has selected yet Clang considers d16 not a valid register.
Moving the FPU directive on-top allows Clang to parse the registers and
allows to successfully build this file with Clang's integrated assembler.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/crypto/ghash-ce-core.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
index 534c9647726d..9f51e3fa4526 100644
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -8,6 +8,9 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
+	.arch		armv8-a
+	.fpu		crypto-neon-fp-armv8
+
 	SHASH		.req	q0
 	T1		.req	q1
 	XL		.req	q2
@@ -88,8 +91,6 @@
 	T3_H		.req	d17
 
 	.text
-	.arch		armv8-a
-	.fpu		crypto-neon-fp-armv8
 
 	.macro		__pmull_p64, rd, rn, rm, b1, b2, b3, b4
 	vmull.p64	\rd, \rn, \rm
-- 
2.25.1

