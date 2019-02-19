Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F4BC4360F
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 14:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B35F21736
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 14:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbfBSO5K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:57:10 -0500
Received: from inva020.nxp.com ([92.121.34.13]:40470 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbfBSO5K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 09:57:10 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DF9201A02B1;
        Tue, 19 Feb 2019 15:57:08 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D359E1A012E;
        Tue, 19 Feb 2019 15:57:08 +0100 (CET)
Received: from enigma.ea.freescale.net (enigma.ea.freescale.net [10.171.81.110])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 784502061F;
        Tue, 19 Feb 2019 15:57:08 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx <linux-imx@nxp.com>
Subject: [PATCH 2/3] crypto: caam - fix DMA mapping xcbc key twice
Date:   Tue, 19 Feb 2019 16:56:56 +0200
Message-Id: <20190219145657.2267-3-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.16.2
In-Reply-To: <20190219145657.2267-1-horia.geanta@nxp.com>
References: <20190219145657.2267-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix a side effect of adding xcbc support, which leads to DMA mapping the
key twice.

Fixes: 12b8567f6fa4 ("crypto: caam - add support for xcbc(aes)")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 2c5aca59229b..a71408f36654 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1897,8 +1897,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	}
 
 	dma_addr = dma_map_single_attrs(ctx->jrdev, ctx->sh_desc_update,
-					offsetof(struct caam_hash_ctx,
-						 sh_desc_update_dma),
+					offsetof(struct caam_hash_ctx, key),
 					ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (dma_mapping_error(ctx->jrdev, dma_addr)) {
 		dev_err(ctx->jrdev, "unable to map shared descriptors\n");
-- 
2.16.2

