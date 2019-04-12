Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6745C282CE
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 09:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C09FE2084D
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 09:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfDLJYF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:24:05 -0400
Received: from lucky1.263xmail.com ([211.157.147.130]:41796 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbfDLJYE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 05:24:04 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Apr 2019 05:24:03 EDT
Received: from zhangzj?rock-chips.com (unknown [192.168.167.227])
        by lucky1.263xmail.com (Postfix) with ESMTP id 5B32A57ADD;
        Fri, 12 Apr 2019 17:17:59 +0800 (CST)
X-263anti-spam: KSV:0;BIG:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ADDR-CHECKED4: 1
X-ABS-CHECKED: 0
X-SKE-CHECKED: 0
X-ANTISPAM-LEVEL: 2
Received: from localhost.localdomain (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P17415T139908156503808S1555060675278447_;
        Fri, 12 Apr 2019 17:17:57 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <eb94528928ae988c19551cf5313cfd32>
X-RL-SENDER: zhangzj@rock-chips.com
X-SENDER: zhangzj@rock-chips.com
X-LOGIN-NAME: zhangzj@rock-chips.com
X-FST-TO: herbert@gondor.apana.org.au
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From:   Zhang Zhijie <zhangzj@rock-chips.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     zhangzj@rock-chips.com, heiko@sntech.de, ebiggers@google.com,
        huangtao@rock-chips.com, stable@vger.kernel.org
Subject: [PATCH] crypto: rockchip - update IV buffer to contain the next IV
Date:   Fri, 12 Apr 2019 17:16:33 +0800
Message-Id: <20190412091633.32697-1-zhangzj@rock-chips.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Kernel Crypto API request output the next IV data to
IV buffer for CBC implementation. So the last block data of
ciphertext should be copid into assigned IV buffer.

Reported-by: Eric Biggers <ebiggers@google.com>
Fixes: 433cd2c617bf ("crypto: rockchip - add crypto driver for rk3288")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Zhang Zhijie <zhangzj@rock-chips.com>

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
index 02dac6ae7e53..7564b4c41afc 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -250,9 +250,14 @@ static int rk_set_data_start(struct rk_crypto_info *dev)
 	u8 *src_last_blk = page_address(sg_page(dev->sg_src)) +
 		dev->sg_src->offset + dev->sg_src->length - ivsize;
 
-	/* store the iv that need to be updated in chain mode */
-	if (ctx->mode & RK_CRYPTO_DEC)
+	/* Store the iv that need to be updated in chain mode.
+	 * And update the IV buffer to contain the next IV for decryption mode.
+	 */
+	if (ctx->mode & RK_CRYPTO_DEC) {
 		memcpy(ctx->iv, src_last_blk, ivsize);
+		sg_pcopy_to_buffer(dev->first, dev->src_nents, req->info,
+				   ivsize, dev->total - ivsize);
+	}
 
 	err = dev->load_data(dev, dev->sg_src, dev->sg_dst);
 	if (!err)
@@ -288,13 +293,19 @@ static void rk_iv_copyback(struct rk_crypto_info *dev)
 	struct ablkcipher_request *req =
 		ablkcipher_request_cast(dev->async_req);
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct rk_cipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 	u32 ivsize = crypto_ablkcipher_ivsize(tfm);
 
-	if (ivsize == DES_BLOCK_SIZE)
-		memcpy_fromio(req->info, dev->reg + RK_CRYPTO_TDES_IV_0,
-			      ivsize);
-	else if (ivsize == AES_BLOCK_SIZE)
-		memcpy_fromio(req->info, dev->reg + RK_CRYPTO_AES_IV_0, ivsize);
+	/* Update the IV buffer to contain the next IV for encryption mode. */
+	if (!(ctx->mode & RK_CRYPTO_DEC)) {
+		if (dev->aligned) {
+			memcpy(req->info, sg_virt(dev->sg_dst) +
+				dev->sg_dst->length - ivsize, ivsize);
+		} else {
+			memcpy(req->info, dev->addr_vir +
+				dev->count - ivsize, ivsize);
+		}
+	}
 }
 
 static void rk_update_iv(struct rk_crypto_info *dev)
-- 
2.17.1



