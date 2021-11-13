Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDB9C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Nov 2021 06:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BAB66112E
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Nov 2021 06:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhKMGdr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Nov 2021 01:33:47 -0500
Received: from smtpbg126.qq.com ([106.55.201.22]:18538 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229487AbhKMGdq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Nov 2021 01:33:46 -0500
X-QQ-mid: bizesmtp53t1636785027tbx8xaqy
Received: from localhost.localdomain (unknown [125.69.41.88])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sat, 13 Nov 2021 14:30:25 +0800 (CST)
X-QQ-SSF: 01000000000000C0F000B00A0000000
X-QQ-FEAT: 2xJC0nfhYEoa6nV8L0JoP4JC50g8rN9TfoRuZ2twf0TsDz0SYtWSnej+9Hgym
        8hCTX6j1kS6/S+2VyXdt2P5dXj5rFVs4Ngm1RzmovFMK8iLGqrvNRNKjBG+jYQfujCm71vI
        TqFmn4pO5LPKCEMbpa4dtfIfUk3eCAdOP0IFbBX1QaXkLHeiTizMOPqKZJavdKwis04qkCk
        H7m9nDhKO447czrV7Zp/DZvxft1d+Crk6wG7MzuIfTb/OG3cmUaJFmTqVJkVdB4nSf2sSLt
        vQjSkENTR7nmWRXWMynThXMvhGzC6IhJFTksI9PDgO3T8+A6XC3woulnE2vGF/VNOc1MJjr
        zLpiGLgVOECAOAHSMJBHtJfFqA3PM7z6XiqPFKN
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     davem@davemloft.net
Cc:     herbert@gondor.apana.org.au, thomas.lendacky@amd.com,
        john.allen@amd.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] crypto: ccp: ccp-dev: no need to initialise statics to 0
Date:   Sat, 13 Nov 2021 14:30:23 +0800
Message-Id: <20211113063023.251246-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Static variables do not need to be initialized to 0.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/crypto/ccp/ccp-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 9ce4b68e9c48..c531d13d971f 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -31,7 +31,7 @@
 #define MAX_CCPS 32
 
 /* Limit CCP use to a specifed number of queues per device */
-static unsigned int nqueues = 0;
+static unsigned int nqueues;
 module_param(nqueues, uint, 0444);
 MODULE_PARM_DESC(nqueues, "Number of queues per CCP (minimum 1; default: all available)");
 
-- 
2.33.0

