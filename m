Return-Path: <SRS0=aQ9n=XM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56195C4CEC9
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 08:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3491921881
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 08:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389207AbfIQIuT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 04:50:19 -0400
Received: from foss.arm.com ([217.140.110.172]:53120 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389188AbfIQIuT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 04:50:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD84E28;
        Tue, 17 Sep 2019 01:50:18 -0700 (PDT)
Received: from e111045-lin.cambridge.arm.com (e120756.arm.com [10.1.39.60])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C4B63F575;
        Tue, 17 Sep 2019 01:50:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@arm.com>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm/aes-ce - build for v8 architecture explicitly
Date:   Tue, 17 Sep 2019 09:50:00 +0100
Message-Id: <20190917085001.792-1-ard.biesheuvel@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

The NEON/Crypto Extensions based AES implementation for 32-bit ARM
can be built in a kernel that targets ARMv6 CPUs and higher, even
though the actual code will not be able to run on that generation,
but it allows for a portable image to be generated that can will
use the special instructions only when they are available.

Since those instructions are part of a FPU profile rather than a
CPU profile, we don't override the architecture in the assembler
code, and most of the scalar code is simple enough to be ARMv6
compatible. However, that changes with commit c61b1607ed4fbbf2,
which introduces calls to the movw/movt instructions, which are
v7+ only.

So override the architecture in the .S file to armv8-a, which
matches the architecture specification in the crypto-neon-fp-armv8
FPU specificier that we already using. Note that using armv7-a
here may trigger an issue with the upcoming Clang 10 release,
which no longer permits .arch/.fpu combinations it views as
incompatible.

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: c61b1607ed4fbbf2("crypto: arm/aes-ce - implement ciphertext stealing ...")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-core.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index b978cdf133af..4d1707388d94 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -9,6 +9,7 @@
 #include <asm/assembler.h>
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 	.align		3
 
-- 
2.17.1

