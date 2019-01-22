Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89749C282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 648E0217D6
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbfAVP0d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:26:33 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50445 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbfAVP0c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:26:32 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <rhi@pengutronix.de>)
        id 1glxwb-0003YI-Vs; Tue, 22 Jan 2019 16:26:29 +0100
Received: from rhi by dude.hi.pengutronix.de with local (Exim 4.92-RC4)
        (envelope-from <rhi@pengutronix.de>)
        id 1glxwZ-0000AF-DQ; Tue, 22 Jan 2019 16:26:27 +0100
From:   Roland Hieber <rhi@pengutronix.de>
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org
Cc:     Roland Hieber <r.hieber@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Roland Hieber <rhi@pengutronix.de>
Subject: [PATCH 1/2] crypto: caam - fix indentation of goto label
Date:   Tue, 22 Jan 2019 16:26:08 +0100
Message-Id: <20190122152609.31774-1-rhi@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: rhi@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Roland Hieber <rhi@pengutronix.de>
---
 drivers/crypto/caam/caamhash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index bb1a2cdf19512..b65e2e54c5625 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -801,7 +801,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 #endif
 
 	return ret;
- unmap_ctx:
+unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_BIDIRECTIONAL);
 	kfree(edesc);
 	return ret;
-- 
2.20.1

