Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDE9C433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 08:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 714FA20657
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 08:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgGPIHB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 04:07:01 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39808 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgGPIHA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 04:07:00 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jvyuu-0004Bv-7A; Thu, 16 Jul 2020 18:06:57 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Jul 2020 18:06:56 +1000
Date:   Thu, 16 Jul 2020 18:06:56 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: omap-aes - Fix sparse and compiler warnings
Message-ID: <20200716080656.GA19190@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes all the sparse and W=1 compiler warnings in the
driver.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 25154b74dcc6..4fd14d90cc40 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -139,7 +139,7 @@ int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 
 	for (i = 0; i < key32; i++) {
 		omap_aes_write(dd, AES_REG_KEY(dd, i),
-			__le32_to_cpu(dd->ctx->key[i]));
+			       (__force u32)cpu_to_le32(dd->ctx->key[i]));
 	}
 
 	if ((dd->flags & (FLAGS_CBC | FLAGS_CTR)) && dd->req->iv)
@@ -363,7 +363,7 @@ int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 {
 	int err;
 
-	pr_debug("total: %d\n", dd->total);
+	pr_debug("total: %zu\n", dd->total);
 
 	if (!dd->pio_only) {
 		err = dma_map_sg(dd->dev, dd->in_sg, dd->in_sg_len,
@@ -409,7 +409,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 {
-	pr_debug("total: %d\n", dd->total);
+	pr_debug("total: %zu\n", dd->total);
 
 	omap_aes_dma_stop(dd);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
