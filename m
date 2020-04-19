Return-Path: <SRS0=r6//=6D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DE5C2BA2B
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Apr 2020 07:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B7A421974
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Apr 2020 07:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgDSHLN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Apr 2020 03:11:13 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:4377 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgDSHLN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Apr 2020 03:11:13 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.15]) by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee25e9bf98210d-b83fb; Sun, 19 Apr 2020 15:10:58 +0800 (CST)
X-RM-TRANSID: 2ee25e9bf98210d-b83fb
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.1.172.61])
        by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee85e9bf980792-fc83d;
        Sun, 19 Apr 2020 15:10:58 +0800 (CST)
X-RM-TRANSID: 2ee85e9bf980792-fc83d
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Shengju Zhang <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] crypto: Delete redundant variable definition
Date:   Sun, 19 Apr 2020 15:12:45 +0800
Message-Id: <20200419071245.3924-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The variable "i" is redundant to be assigned a value
of zero,because it's assigned in the for loop, so remove
redundant one here.

Signed-off-by: Shengju Zhang <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

---
 drivers/crypto/bcm/cipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index c8b940854..5db23c18c 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4724,7 +4724,6 @@ static int spu_dt_read(struct platform_device *pdev)
 	spu->spu_type = matched_spu_type->type;
 	spu->spu_subtype = matched_spu_type->subtype;
 
-	i = 0;
 	for (i = 0; (i < MAX_SPUS) && ((spu_ctrl_regs =
 		platform_get_resource(pdev, IORESOURCE_MEM, i)) != NULL); i++) {
 
-- 
2.20.1.windows.1



