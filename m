Return-Path: <SRS0=iDha=6J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C41C54FCB
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Apr 2020 14:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95765206B9
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Apr 2020 14:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgDYOXm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Apr 2020 10:23:42 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:12211 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgDYOXm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Apr 2020 10:23:42 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.17]) by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee75ea447abee9-4b265; Sat, 25 Apr 2020 22:22:35 +0800 (CST)
X-RM-TRANSID: 2ee75ea447abee9-4b265
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.3.208.31])
        by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee95ea447a77f2-8235e;
        Sat, 25 Apr 2020 22:22:35 +0800 (CST)
X-RM-TRANSID: 2ee95ea447a77f2-8235e
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] crypto: bcm - Remove the unnecessary cast for PTR_ERR().
Date:   Sat, 25 Apr 2020 22:22:58 +0800
Message-Id: <20200425142258.9052-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It's not necessary to specify 'int' casting for PTR_ERR().

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/crypto/bcm/cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 91db553e6..99ece630f 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4436,7 +4436,7 @@ static int spu_mb_init(struct device *dev)
 	for (i = 0; i < iproc_priv.spu.num_chan; i++) {
 		iproc_priv.mbox[i] = mbox_request_channel(mcl, i);
 		if (IS_ERR(iproc_priv.mbox[i])) {
-			err = (int)PTR_ERR(iproc_priv.mbox[i]);
+			err = PTR_ERR(iproc_priv.mbox[i]);
 			dev_err(dev,
 				"Mbox channel %d request failed with err %d",
 				i, err);
-- 
2.20.1.windows.1



