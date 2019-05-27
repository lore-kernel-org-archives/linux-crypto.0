Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C430BC04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5A172182B
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfE0Ov5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 10:51:57 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:43077 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbfE0Ov5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 10:51:57 -0400
X-Originating-IP: 90.88.147.134
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 139731C0017;
        Mon, 27 May 2019 14:51:50 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, igall@marvell.com
Subject: [PATCH 09/14] crypto: inside-secure - fix zeroing of the request in ahash_exit_inv
Date:   Mon, 27 May 2019 16:51:01 +0200
Message-Id: <20190527145106.8693-10-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190527145106.8693-1-antoine.tenart@bootlin.com>
References: <20190527145106.8693-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A request is zeroed in safexcel_ahash_exit_inv(). This request total
size is EIP197_AHASH_REQ_SIZE while the memset zeroing it uses
sizeof(struct ahash_request), which happens to be less than
EIP197_AHASH_REQ_SIZE. This patch fixes it.

Fixes: f6beaea30487 ("crypto: inside-secure - authenc(hmac(sha256), cbc(aes)) support")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index a79a73bb3969..ba0732fd4ed4 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -487,7 +487,7 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
 
-	memset(req, 0, sizeof(struct ahash_request));
+	memset(req, 0, EIP197_AHASH_REQ_SIZE);
 
 	/* create invalidation request */
 	init_completion(&result.completion);
-- 
2.21.0

