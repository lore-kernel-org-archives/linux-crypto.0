Return-Path: <SRS0=KXmQ=WY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4002BC3A5A1
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 06:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2034B22CF5
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 06:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfH1Ghl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 02:37:41 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:42182 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726376AbfH1Gh1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 02:37:27 -0400
X-UUID: 1825b6b15721413db17fdb3e7714b78a-20190828
X-UUID: 1825b6b15721413db17fdb3e7714b78a-20190828
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <vic.wu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1076583874; Wed, 28 Aug 2019 14:37:23 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 28 Aug 2019 14:37:29 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 28 Aug 2019 14:37:29 +0800
From:   Vic Wu <vic.wu@mediatek.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ryder Lee <ryder.lee@mediatek.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Vic Wu <vic.wu@mediatek.com>
Subject: [PATCH 3/5] crypto: mediatek: only treat EBUSY as transient if backlog
Date:   Wed, 28 Aug 2019 14:37:14 +0800
Message-ID: <20190828063716.22689-3-vic.wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190828063716.22689-1-vic.wu@mediatek.com>
References: <20190828063716.22689-1-vic.wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

The driver was treating -EBUSY as indication of queueing to backlog
without checking that backlog is enabled for the request.

Fix it by checking request flags.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Vic Wu <vic.wu@mediatek.com>
---
 drivers/crypto/mediatek/mtk-sha.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 2226f12d..1ecef3b5 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -781,7 +781,9 @@ static int mtk_sha_finup(struct ahash_request *req)
 	ctx->flags |= SHA_FLAGS_FINUP;
 
 	err1 = mtk_sha_update(req);
-	if (err1 == -EINPROGRESS || err1 == -EBUSY)
+	if (err1 == -EINPROGRESS ||
+	    (err1 == -EBUSY && (ahash_request_flags(req) &
+				CRYPTO_TFM_REQ_MAY_BACKLOG)))
 		return err1;
 	/*
 	 * final() has to be always called to cleanup resources
-- 
2.17.1

