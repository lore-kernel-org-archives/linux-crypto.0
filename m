Return-Path: <SRS0=/mkk=BM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DF0C433DF
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Aug 2020 14:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CB332075B
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Aug 2020 14:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgHBO45 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Aug 2020 10:56:57 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:54639 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgHBO45 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Aug 2020 10:56:57 -0400
Received: from localhost.localdomain ([93.22.148.198])
        by mwinf5d42 with ME
        id Aewq230024H42jh03ewqx1; Sun, 02 Aug 2020 16:56:55 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 02 Aug 2020 16:56:55 +0200
X-ME-IP: 93.22.148.198
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        chohnstaedt@innominate.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: ixp4xx - Fix the size used in a 'dma_free_coherent()' call
Date:   Sun,  2 Aug 2020 16:56:48 +0200
Message-Id: <20200802145648.699335-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update the size used in 'dma_free_coherent()' in order to match the one
used in the corresponding 'dma_alloc_coherent()', in 'setup_crypt_desc()'.

Fixes: 81bef0150074 ("crypto: ixp4xx - Hardware crypto support for IXP4xx CPUs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/ixp4xx_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index f478bb0a566a..276012e7c482 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -528,7 +528,7 @@ static void release_ixp_crypto(struct device *dev)
 
 	if (crypt_virt) {
 		dma_free_coherent(dev,
-			NPE_QLEN_TOTAL * sizeof( struct crypt_ctl),
+			NPE_QLEN * sizeof(struct crypt_ctl),
 			crypt_virt, crypt_phys);
 	}
 }
-- 
2.25.1

