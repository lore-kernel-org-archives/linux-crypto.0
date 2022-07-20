Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8690C43334
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jul 2022 12:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiGTMIY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jul 2022 08:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiGTMIY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jul 2022 08:08:24 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F108352883;
        Wed, 20 Jul 2022 05:08:17 -0700 (PDT)
X-QQ-mid: bizesmtp89t1658318845tsiobkqm
Received: from harry-jrlc.. ( [182.148.15.157])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 20 Jul 2022 20:07:15 +0800 (CST)
X-QQ-SSF: 0100000000600030C000B00A0000020
X-QQ-FEAT: hJ5650VbgwCQmPp6NqHSO23DqJ2SgkjVfT10KlF04he/S0phvOifnwV9XMxd0
        4ZbgrrNL6nqFXPxEq7PQZhOeE3J8EPAY+lBT1JrxPFCv9f4dPi4+xbWg+Q0iSqYl3bO58Ts
        Cg/irCjX4tmD1GAqLQgineiq/eJm41f4Lm+7tDIsmah5oejPw3TARFPmdNfGsAYezFFYTkI
        YEM92fy2NxWpVRFUOlmCbz741fzf6a97g85OEUrXFRbgS6+i/uix9bvFz7bAwxpiJX8+y4F
        JRWoBhXfcGYEBwMMQWTOJKqMmoJJZ6iK33042QlZm3Widp5a96NqUEgPHfPhfByWar+ilJc
        ici6gFVOlTu8U7O0hxvcWbCraduvnfIpp2oyrvSJTTK8kotqoeLpnHmq+XcYrMSQRPFCFTy
X-QQ-GoodBg: 0
From:   Xin Gao <gaoxin@cdjrlc.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Xin Gao <gaoxin@cdjrlc.com>
Subject: [PATCH] crypto:repeated word: 'block'.
Date:   Wed, 20 Jul 2022 20:07:13 +0800
Message-Id: <20220720120713.3700-1-gaoxin@cdjrlc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

repeated word: 'block'.

Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
---
 arch/powerpc/crypto/aes-spe-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index e8dfe9fb0266..efab78a3a8f6 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -28,7 +28,7 @@
  * instructions per clock cycle using one 32/64 bit unit (SU1) and one 32
  * bit unit (SU2). One of these can be a memory access that is executed via
  * a single load and store unit (LSU). XTS-AES-256 takes ~780 operations per
- * 16 byte block block or 25 cycles per byte. Thus 768 bytes of input data
+ * 16 byte block or 25 cycles per byte. Thus 768 bytes of input data
  * will need an estimated maximum of 20,000 cycles. Headroom for cache misses
  * included. Even with the low end model clocked at 667 MHz this equals to a
  * critical time window of less than 30us. The value has been chosen to
-- 
2.30.2

