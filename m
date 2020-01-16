Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E563DC33CB8
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 17:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDEFD246A9
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579195931;
	bh=qlxTtlN5xuOOnTNEZfsLFK+BikNN2h6MU/dqbxNxv24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hp87DQuadHcdEAHs9K5suPv8XUDI5w1vNfHUK6iz4oJPHErOEn53gPSq6ADpNoRLN
	 fEGi7HXVJu4AgRlKRCWP5pKl2qfPMv8SfuieR5TKS+hqLlNmFH9qnP2/AXyV1XLlpZ
	 IdHNZNJfleo8xSLNxpXjzIBXuajIk0ygMDAF7TLc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404695AbgAPRbG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:31:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404691AbgAPRbG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 12:31:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EE44246A9;
        Thu, 16 Jan 2020 17:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195865;
        bh=qlxTtlN5xuOOnTNEZfsLFK+BikNN2h6MU/dqbxNxv24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WcHiL3REflSSjWItgR9Sarr/g89EWO53GiL3tOaYkNebVkaT4LhWQzfuWAe4TJ3r8
         SVYP6XH8VIrG84h1+9xrt1iaFfeVRouBWbu8pSNwJhw4RbS25IvdPkwS8g93X+6XqI
         X3lAg7s3De6nj7frjfFuewSur6xUO8AXfCLagkBw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 362/371] crypto: sun4i-ss - fix big endian issues
Date:   Thu, 16 Jan 2020 12:23:54 -0500
Message-Id: <20200116172403.18149-305-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

[ Upstream commit d1d787bcebfe122a5bd443ae565696661e2e9656 ]

When testing BigEndian kernel, the sun4i-ss was failling all crypto
tests.
This patch fix endian issues with it.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 1a724263761b..2d178e013535 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -179,7 +179,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	 */
 	unsigned int i = 0, end, fill, min_fill, nwait, nbw = 0, j = 0, todo;
 	unsigned int in_i = 0;
-	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32] = {0}, wb = 0, v, ivmode = 0;
+	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32] = {0}, v, ivmode = 0;
 	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun4i_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
@@ -188,6 +188,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	struct sg_mapping_iter mi;
 	int in_r, err = 0;
 	size_t copied = 0;
+	__le32 wb = 0;
 
 	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%u h0=%0x",
 		__func__, crypto_tfm_alg_name(areq->base.tfm),
@@ -399,7 +400,7 @@ static int sun4i_hash(struct ahash_request *areq)
 
 		nbw = op->len - 4 * nwait;
 		if (nbw) {
-			wb = *(u32 *)(op->buf + nwait * 4);
+			wb = cpu_to_le32(*(u32 *)(op->buf + nwait * 4));
 			wb &= GENMASK((nbw * 8) - 1, 0);
 
 			op->byte_count += nbw;
@@ -408,7 +409,7 @@ static int sun4i_hash(struct ahash_request *areq)
 
 	/* write the remaining bytes of the nbw buffer */
 	wb |= ((1 << 7) << (nbw * 8));
-	bf[j++] = wb;
+	bf[j++] = le32_to_cpu(wb);
 
 	/*
 	 * number of space to pad to obtain 64o minus 8(size) minus 4 (final 1)
@@ -427,13 +428,13 @@ static int sun4i_hash(struct ahash_request *areq)
 
 	/* write the length of data */
 	if (op->mode == SS_OP_SHA1) {
-		__be64 bits = cpu_to_be64(op->byte_count << 3);
-		bf[j++] = lower_32_bits(bits);
-		bf[j++] = upper_32_bits(bits);
+		__be64 *bits = (__be64 *)&bf[j];
+		*bits = cpu_to_be64(op->byte_count << 3);
+		j += 2;
 	} else {
-		__le64 bits = op->byte_count << 3;
-		bf[j++] = lower_32_bits(bits);
-		bf[j++] = upper_32_bits(bits);
+		__le64 *bits = (__le64 *)&bf[j];
+		*bits = cpu_to_le64(op->byte_count << 3);
+		j += 2;
 	}
 	writesl(ss->base + SS_RXFIFO, bf, j);
 
@@ -475,7 +476,7 @@ static int sun4i_hash(struct ahash_request *areq)
 		}
 	} else {
 		for (i = 0; i < 4; i++) {
-			v = readl(ss->base + SS_MD0 + i * 4);
+			v = cpu_to_le32(readl(ss->base + SS_MD0 + i * 4));
 			memcpy(areq->result + i * 4, &v, 4);
 		}
 	}
-- 
2.20.1

