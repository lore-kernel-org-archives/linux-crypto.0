Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF507C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 22:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C6B12075F
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 22:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgESWRh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 18:17:37 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51048 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgESWRg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 18:17:36 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8BC8E1A011F;
        Wed, 20 May 2020 00:17:34 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7CCC11A021B;
        Wed, 20 May 2020 00:17:34 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C76B320564;
        Wed, 20 May 2020 00:17:33 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH] crypto: engine - do not requeue in case of fatal error
Date:   Wed, 20 May 2020 01:17:25 +0300
Message-Id: <1589926645-32686-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now, in crypto-engine, if hardware queue is full (-ENOSPC),
requeue request regardless of MAY_BACKLOG flag.
If hardware throws any other error code (like -EIO, -EINVAL,
-ENOMEM, etc.) only MAY_BACKLOG requests are enqueued back into
crypto-engine's queue, since the others can be dropped.
The latter case can be fatal error, so those cannot be recovered from.
For example, in CAAM driver, -EIO is returned in case the job descriptor
is broken, so there is no possibility to fix the job descriptor.
Therefore, these errors might be fatal error, so we shouldn’t
requeue the request. This will just be pass back and forth between
crypto-engine and hardware.

Fixes: 6a89f492f8e5 ("crypto: engine - support for parallel requests based on retry mechanism")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/crypto_engine.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 412149e..3655d9d 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -169,13 +169,10 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		/*
 		 * If hardware queue is full (-ENOSPC), requeue request
 		 * regardless of backlog flag.
-		 * If hardware throws any other error code,
-		 * requeue only backlog requests.
 		 * Otherwise, unprepare and complete the request.
 		 */
 		if (!engine->retry_support ||
-		    ((ret != -ENOSPC) &&
-		    !(async_req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG))) {
+		    (ret != -ENOSPC)) {
 			dev_err(engine->dev,
 				"Failed to do one request from queue: %d\n",
 				ret);
-- 
2.1.0

