Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5D1C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF2D2182B
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfE0Ovw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 10:51:52 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:41959 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbfE0Ovv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 10:51:51 -0400
X-Originating-IP: 90.88.147.134
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 7A92CFF812;
        Mon, 27 May 2019 14:51:48 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, igall@marvell.com
Subject: [PATCH 14/14] crypto: inside-secure - do not rely on the hardware last bit for result descriptors
Date:   Mon, 27 May 2019 16:51:06 +0200
Message-Id: <20190527145106.8693-15-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190527145106.8693-1-antoine.tenart@bootlin.com>
References: <20190527145106.8693-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When performing a transformation the hardware is given result
descriptors to save the result data. Those result descriptors are
batched using a 'first' and a 'last' bit. There are cases were more
descriptors than needed are given to the engine, leading to the engine
only using some of them, and not setting the last bit on the last
descriptor we gave. This causes issues were the driver and the hardware
aren't in sync anymore about the number of result descriptors given (as
the driver do not give a pool of descriptor to use for any
transformation, but a pool of descriptors to use *per* transformation).

This patch fixes it by attaching the number of given result descriptors
to the requests, and by using this number instead of the 'last' bit
found on the descriptors to process them.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 .../crypto/inside-secure/safexcel_cipher.c    | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 6e193baccec7..8cdbdbe35681 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -51,6 +51,8 @@ struct safexcel_cipher_ctx {
 
 struct safexcel_cipher_req {
 	enum safexcel_cipher_direction direction;
+	/* Number of result descriptors associated to the request */
+	unsigned int rdescs;
 	bool needs_inv;
 };
 
@@ -351,7 +353,10 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 
 	*ret = 0;
 
-	do {
+	if (unlikely(!sreq->rdescs))
+		return 0;
+
+	while (sreq->rdescs--) {
 		rdesc = safexcel_ring_next_rptr(priv, &priv->ring[ring].rdr);
 		if (IS_ERR(rdesc)) {
 			dev_err(priv->dev,
@@ -364,7 +369,7 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 			*ret = safexcel_rdesc_check_errors(priv, rdesc);
 
 		ndesc++;
-	} while (!rdesc->last_seg);
+	}
 
 	safexcel_complete(priv, ring);
 
@@ -502,6 +507,7 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 				      int ring,
 				      struct crypto_async_request *base,
+				      struct safexcel_cipher_req *sreq,
 				      bool *should_complete, int *ret)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
@@ -510,7 +516,10 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 
 	*ret = 0;
 
-	do {
+	if (unlikely(!sreq->rdescs))
+		return 0;
+
+	while (sreq->rdescs--) {
 		rdesc = safexcel_ring_next_rptr(priv, &priv->ring[ring].rdr);
 		if (IS_ERR(rdesc)) {
 			dev_err(priv->dev,
@@ -523,7 +532,7 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 			*ret = safexcel_rdesc_check_errors(priv, rdesc);
 
 		ndesc++;
-	} while (!rdesc->last_seg);
+	}
 
 	safexcel_complete(priv, ring);
 
@@ -566,7 +575,7 @@ static int safexcel_skcipher_handle_result(struct safexcel_crypto_priv *priv,
 
 	if (sreq->needs_inv) {
 		sreq->needs_inv = false;
-		err = safexcel_handle_inv_result(priv, ring, async,
+		err = safexcel_handle_inv_result(priv, ring, async, sreq,
 						 should_complete, ret);
 	} else {
 		err = safexcel_handle_req_result(priv, ring, async, req->src,
@@ -607,7 +616,7 @@ static int safexcel_aead_handle_result(struct safexcel_crypto_priv *priv,
 
 	if (sreq->needs_inv) {
 		sreq->needs_inv = false;
-		err = safexcel_handle_inv_result(priv, ring, async,
+		err = safexcel_handle_inv_result(priv, ring, async, sreq,
 						 should_complete, ret);
 	} else {
 		err = safexcel_handle_req_result(priv, ring, async, req->src,
@@ -653,6 +662,8 @@ static int safexcel_skcipher_send(struct crypto_async_request *async, int ring,
 		ret = safexcel_send_req(async, ring, sreq, req->src,
 					req->dst, req->cryptlen, 0, 0, req->iv,
 					commands, results);
+
+	sreq->rdescs = *results;
 	return ret;
 }
 
@@ -675,6 +686,7 @@ static int safexcel_aead_send(struct crypto_async_request *async, int ring,
 					req->cryptlen, req->assoclen,
 					crypto_aead_authsize(tfm), req->iv,
 					commands, results);
+	sreq->rdescs = *results;
 	return ret;
 }
 
-- 
2.21.0

