Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53547C32751
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 15:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F03221E6C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 15:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388810AbfHGPvg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 11:51:36 -0400
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:46383 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388758AbfHGPvg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 11:51:36 -0400
Received: from localhost.localdomain ([86.218.179.140])
        by mwinf5d35 with ME
        id mFrR20003328hQe03FrRek; Wed, 07 Aug 2019 17:51:33 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 07 Aug 2019 17:51:33 +0200
X-ME-IP: 86.218.179.140
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     atul.gupta@chelsio.com, herbert@gondor.apana.org.au,
        zhongjiang@huawei.com, ganeshgr@chelsio.com, davem@davemloft.net,
        tglx@linutronix.de, bigeasy@linutronix.de
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: chtls - use 'skb_put_zero()' instead of re-implementing it
Date:   Wed,  7 Aug 2019 17:40:14 +0200
Message-Id: <20190807154014.22548-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

'skb_put()+memset()' is equivalent to 'skb_put_zero()'
Use the latter because it is less verbose and it hides the internals of the
sk_buff structure.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/chelsio/chtls/chtls_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 635bb4b447fb..830b238da77e 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -218,9 +218,8 @@ static int chtls_get_skb(struct chtls_dev *cdev)
 	if (!cdev->askb)
 		return -ENOMEM;
 
-	skb_put(cdev->askb, sizeof(struct tcphdr));
+	skb_put_zero(cdev->askb, sizeof(struct tcphdr));
 	skb_reset_transport_header(cdev->askb);
-	memset(cdev->askb->data, 0, cdev->askb->len);
 	return 0;
 }
 
-- 
2.20.1

