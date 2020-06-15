Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A14AC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 11:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7296E206D7
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 11:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgFOLhl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 07:37:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49144 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbgFOLhk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 07:37:40 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jknQo-0007BX-Ey; Mon, 15 Jun 2020 21:37:39 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 15 Jun 2020 21:37:38 +1000
Date:   Mon, 15 Jun 2020 21:37:38 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tero Kristo <t-kristo@ti.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: omap-sham - Fix sparse/compiler warnings
Message-ID: <20200615113738.GB20552@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes sparse endianness warnings as well as compiler
warnings on 64-bit hosts.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 82691a057d2a..954d703f2981 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -357,10 +357,10 @@ static void omap_sham_copy_ready_hash(struct ahash_request *req)
 
 	if (big_endian)
 		for (i = 0; i < d; i++)
-			hash[i] = be32_to_cpu(in[i]);
+			hash[i] = be32_to_cpup((__be32 *)in + i);
 	else
 		for (i = 0; i < d; i++)
-			hash[i] = le32_to_cpu(in[i]);
+			hash[i] = le32_to_cpup((__le32 *)in + i);
 }
 
 static int omap_sham_hw_init(struct omap_sham_dev *dd)
@@ -522,7 +522,7 @@ static int omap_sham_xmit_cpu(struct omap_sham_dev *dd, size_t length,
 	int mlen;
 	struct sg_mapping_iter mi;
 
-	dev_dbg(dd->dev, "xmit_cpu: digcnt: %d, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_cpu: digcnt: %zd, length: %zd, final: %d\n",
 						ctx->digcnt, length, final);
 
 	dd->pdata->write_ctrl(dd, length, final, 0);
@@ -588,7 +588,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, size_t length,
 	struct dma_slave_config cfg;
 	int ret;
 
-	dev_dbg(dd->dev, "xmit_dma: digcnt: %d, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_dma: digcnt: %zd, length: %zd, final: %d\n",
 						ctx->digcnt, length, final);
 
 	if (!dma_map_sg(dd->dev, ctx->sg, ctx->sg_len, DMA_TO_DEVICE)) {
@@ -871,7 +871,7 @@ static int omap_sham_prepare_request(struct ahash_request *req, bool update)
 		nbytes += req->nbytes - rctx->offset;
 
 	dev_dbg(rctx->dd->dev,
-		"%s: nbytes=%d, bs=%d, total=%d, offset=%d, bufcnt=%d\n",
+		"%s: nbytes=%d, bs=%d, total=%d, offset=%d, bufcnt=%zd\n",
 		__func__, nbytes, bs, rctx->total, rctx->offset,
 		rctx->bufcnt);
 
@@ -932,7 +932,7 @@ static int omap_sham_update_dma_stop(struct omap_sham_dev *dd)
 	return 0;
 }
 
-struct omap_sham_dev *omap_sham_find_dev(struct omap_sham_reqctx *ctx)
+static struct omap_sham_dev *omap_sham_find_dev(struct omap_sham_reqctx *ctx)
 {
 	struct omap_sham_dev *dd;
 
@@ -1023,7 +1023,7 @@ static int omap_sham_update_req(struct omap_sham_dev *dd)
 	bool final = (ctx->flags & BIT(FLAGS_FINUP)) &&
 			!(dd->flags & BIT(FLAGS_HUGE));
 
-	dev_dbg(dd->dev, "update_req: total: %u, digcnt: %d, final: %d",
+	dev_dbg(dd->dev, "update_req: total: %u, digcnt: %zd, final: %d",
 		ctx->total, ctx->digcnt, final);
 
 	if (ctx->total < get_block_size(ctx) ||
@@ -1036,7 +1036,7 @@ static int omap_sham_update_req(struct omap_sham_dev *dd)
 		err = omap_sham_xmit_dma(dd, ctx->total, final);
 
 	/* wait for dma completion before can take more data */
-	dev_dbg(dd->dev, "update: err: %d, digcnt: %d\n", err, ctx->digcnt);
+	dev_dbg(dd->dev, "update: err: %d, digcnt: %zd\n", err, ctx->digcnt);
 
 	return err;
 }
@@ -1097,7 +1097,7 @@ static int omap_sham_finish(struct ahash_request *req)
 			err = omap_sham_finish_hmac(req);
 	}
 
-	dev_dbg(dd->dev, "digcnt: %d, bufcnt: %d\n", ctx->digcnt, ctx->bufcnt);
+	dev_dbg(dd->dev, "digcnt: %zd, bufcnt: %zd\n", ctx->digcnt, ctx->bufcnt);
 
 	return err;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
