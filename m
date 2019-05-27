Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07AAC04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAE14206BA
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfE0Ova (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 10:51:30 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:47897 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfE0Ov3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 10:51:29 -0400
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 4824D240006;
        Mon, 27 May 2019 14:51:23 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, igall@marvell.com
Subject: [PATCH 04/14] crypto: inside-secure - remove useless check
Date:   Mon, 27 May 2019 16:50:56 +0200
Message-Id: <20190527145106.8693-5-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190527145106.8693-1-antoine.tenart@bootlin.com>
References: <20190527145106.8693-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When sending an ahash request, the code checks for the extra variable
not to be 0. This check is useless as the extra variable can't be 0 at
this point (it is checked on the line just before).

This patch does not modify the driver behaviour in any way.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 24 +++++++++-----------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index a7cee9ed3789..58ce480690eb 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -230,19 +230,17 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 		if (!extra)
 			extra = crypto_ahash_blocksize(ahash);
 
-		if (extra) {
-			sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
-					   req->cache_next, extra,
-					   areq->nbytes - extra);
-
-			queued -= extra;
-			len -= extra;
-
-			if (!queued) {
-				*commands = 0;
-				*results = 0;
-				return 0;
-			}
+		sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
+				   req->cache_next, extra,
+				   areq->nbytes - extra);
+
+		queued -= extra;
+		len -= extra;
+
+		if (!queued) {
+			*commands = 0;
+			*results = 0;
+			return 0;
 		}
 	}
 
-- 
2.21.0

