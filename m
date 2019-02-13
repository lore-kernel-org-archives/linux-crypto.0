Return-Path: <SRS0=2+RY=QU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B868AC282CE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 08:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93B2D222C0
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 08:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403804AbfBMIcE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Feb 2019 03:32:04 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:55360 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733179AbfBMIcE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Feb 2019 03:32:04 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2019 03:32:02 EST
Received: from zhangzj?rock-chips.com (unknown [192.168.167.41])
        by regular1.263xmail.com (Postfix) with ESMTP id 21788400;
        Wed, 13 Feb 2019 16:25:45 +0800 (CST)
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
Received: from localhost.localdomain (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P20138T140378590148352S1550046325362301_;
        Wed, 13 Feb 2019 16:25:44 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <747d10dbc1b910663d1d01d3c6ce9de3>
X-RL-SENDER: zhangzj@rock-chips.com
X-SENDER: zhangzj@rock-chips.com
X-LOGIN-NAME: zhangzj@rock-chips.com
X-FST-TO: herbert@gondor.apana.org.au
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From:   zhangzj@rock-chips.com
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     heiko@sntech.de, ebiggers@google.com, huangtao@rock-chips.com,
        Zhang Zhijie <zhangzj@rock-chips.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] crypto: rockchip - update new iv to device in multiple operations
Date:   Wed, 13 Feb 2019 16:24:39 +0800
Message-Id: <20190213082439.22138-2-zhangzj@rock-chips.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213082439.22138-1-zhangzj@rock-chips.com>
References: <20190213082439.22138-1-zhangzj@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Zhang Zhijie <zhangzj@rock-chips.com>

For chain mode in cipher(eg. AES-CBC/DES-CBC), the iv is continuously
updated in the operation. The new iv value should be written to device
register by software.

Reported-by: Eric Biggers <ebiggers@google.com>
Fixes: 433cd2c617bf ("crypto: rockchip - add crypto driver for rk3288")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Zhang Zhijie <zhangzj@rock-chips.com>
---
 drivers/crypto/rockchip/rk3288_crypto.h       |  1 +
 .../rockchip/rk3288_crypto_ablkcipher.c       | 34 +++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 417c445d8dea..54ee5b3ed9db 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -245,6 +245,7 @@ struct rk_cipher_ctx {
 	struct rk_crypto_info		*dev;
 	unsigned int			keylen;
 	u32				mode;
+	u8				iv[AES_BLOCK_SIZE];
 };
 
 enum alg_type {
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
index fe2fc6c7b51b..02dac6ae7e53 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -242,6 +242,17 @@ static void crypto_dma_start(struct rk_crypto_info *dev)
 static int rk_set_data_start(struct rk_crypto_info *dev)
 {
 	int err;
+	struct ablkcipher_request *req =
+		ablkcipher_request_cast(dev->async_req);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct rk_cipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	u32 ivsize = crypto_ablkcipher_ivsize(tfm);
+	u8 *src_last_blk = page_address(sg_page(dev->sg_src)) +
+		dev->sg_src->offset + dev->sg_src->length - ivsize;
+
+	/* store the iv that need to be updated in chain mode */
+	if (ctx->mode & RK_CRYPTO_DEC)
+		memcpy(ctx->iv, src_last_blk, ivsize);
 
 	err = dev->load_data(dev, dev->sg_src, dev->sg_dst);
 	if (!err)
@@ -286,6 +297,28 @@ static void rk_iv_copyback(struct rk_crypto_info *dev)
 		memcpy_fromio(req->info, dev->reg + RK_CRYPTO_AES_IV_0, ivsize);
 }
 
+static void rk_update_iv(struct rk_crypto_info *dev)
+{
+	struct ablkcipher_request *req =
+		ablkcipher_request_cast(dev->async_req);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct rk_cipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	u32 ivsize = crypto_ablkcipher_ivsize(tfm);
+	u8 *new_iv = NULL;
+
+	if (ctx->mode & RK_CRYPTO_DEC) {
+		new_iv = ctx->iv;
+	} else {
+		new_iv = page_address(sg_page(dev->sg_dst)) +
+			 dev->sg_dst->offset + dev->sg_dst->length - ivsize;
+	}
+
+	if (ivsize == DES_BLOCK_SIZE)
+		memcpy_toio(dev->reg + RK_CRYPTO_TDES_IV_0, new_iv, ivsize);
+	else if (ivsize == AES_BLOCK_SIZE)
+		memcpy_toio(dev->reg + RK_CRYPTO_AES_IV_0, new_iv, ivsize);
+}
+
 /* return:
  *	true	some err was occurred
  *	fault	no err, continue
@@ -307,6 +340,7 @@ static int rk_ablk_rx(struct rk_crypto_info *dev)
 		}
 	}
 	if (dev->left_bytes) {
+		rk_update_iv(dev);
 		if (dev->aligned) {
 			if (sg_is_last(dev->sg_src)) {
 				dev_err(dev->dev, "[%s:%d] Lack of data\n",
-- 
2.17.1



