Return-Path: <SRS0=RIhc=ZC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0F1C43331
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Nov 2019 03:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89A6D215EA
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Nov 2019 03:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573355350;
	bh=lA9ReJAonRl749F32IGcIapOZ9Sgo4WuiE5TEmF+pk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=E8P59sWzJvLNH8iaaoprZb2jJdZfFWgG9wxWwMX5tffGVC2GpCejlhN7DhtQttqXi
	 OBehKxwKHPIQCIO3ZI/yWKjYBccLH7n3mkXNS1uW1fvUT+KN7mZBsHu6INcXddJMcc
	 G+QfB7/d8uQAsSMS1Nl6xOLTUAGBuLu77uSKPFGY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfKJDJJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 22:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727607AbfKJCon (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24D2E21655;
        Sun, 10 Nov 2019 02:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353882;
        bh=lA9ReJAonRl749F32IGcIapOZ9Sgo4WuiE5TEmF+pk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCIxnd088vXj38F2s3CYqB9r6TqK4+sA8x4taiQTiP9Bay5mb4gfTBoyZ6XkToBtr
         O8iyFA7/o3gJf8Zd0wuT64y+qj0DA3j6sVuadW9FlxkfeoRNAGVo3XW8+HNRTRLHfr
         bhWYQyUdYBre8EDIcZllx1Yh7WbBB/oNuAUGQKx0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Aloni <dan@kernelim.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 159/191] crypto: fix a memory leak in rsa-kcs1pad's encryption mode
Date:   Sat,  9 Nov 2019 21:39:41 -0500
Message-Id: <20191110024013.29782-159-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Dan Aloni <dan@kernelim.com>

[ Upstream commit 3944f139d5592790b70bc64f197162e643a8512b ]

The encryption mode of pkcs1pad never uses out_sg and out_buf, so
there's no need to allocate the buffer, which presently is not even
being freed.

CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-crypto@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Dan Aloni <dan@kernelim.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/rsa-pkcs1pad.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 9893dbfc1af45..812476e468213 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -261,15 +261,6 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
 	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
 
-	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
-	if (!req_ctx->out_buf) {
-		kfree(req_ctx->in_buf);
-		return -ENOMEM;
-	}
-
-	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
-			ctx->key_size, NULL);
-
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
 	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
 			pkcs1pad_encrypt_sign_complete_cb, req);
-- 
2.20.1

