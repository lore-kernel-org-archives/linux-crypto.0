Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96885C43334
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jun 2022 09:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357294AbiFVJLB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jun 2022 05:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357295AbiFVJKN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jun 2022 05:10:13 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A7D3A1B8;
        Wed, 22 Jun 2022 02:09:07 -0700 (PDT)
X-QQ-mid: bizesmtp77t1655888863t5pmq0n3
Received: from localhost.localdomain ( [125.70.163.206])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 22 Jun 2022 17:07:37 +0800 (CST)
X-QQ-SSF: 0100000000200020B000B00A0000000
X-QQ-FEAT: /NKu/xdr8AQDBRQ6O3p2bxOKEJ6cXFlahxtKVL8oF+qNg+FD298vxpSnKP2Oc
        TuS5R7AbQUAvSaXjGwKlDRcyVCsoMN8etzVTMehVk8rRXON+/iOvrJXENp+BLqHTTxKyVRt
        ku9xnHeY/MxtWNJPvKHrI405adZTSePDgrpJwR0/gxbCPf52VhK1KSZvVxhX6aIvL5zoUy3
        0cM2O3v2A60tHzsgINJ/Nw2FybRfft9HQaxGMUNhnlKHe+CxUR9QINQbeBqE7OoNayXMMLM
        TpmMmDg70dyJU5fUv6sZLr7TJRAQVegyy+EDJRvRR6zjnFLjalFGrrKZPW6COF+V4/eZMF6
        jPSbch+ylFWXTpa5mstdzBWq76MjA==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] arm64: crypto:Fix typo in comment
Date:   Wed, 22 Jun 2022 17:07:30 +0800
Message-Id: <20220622090730.44050-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam10
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 arch/arm64/crypto/aes-neon.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
index e47d3ec2cfb4..9de7fbc797af 100644
--- a/arch/arm64/crypto/aes-neon.S
+++ b/arch/arm64/crypto/aes-neon.S
@@ -66,7 +66,7 @@
 	prepare		crypto_aes_inv_sbox, .LReverse_ShiftRows, \temp
 	.endm
 
-	/* apply SubBytes transformation using the the preloaded Sbox */
+	/* apply SubBytes transformation using the preloaded Sbox */
 	.macro		sub_bytes, in
 	sub		v9.16b, \in\().16b, v15.16b
 	tbl		\in\().16b, {v16.16b-v19.16b}, \in\().16b
-- 
2.36.1

