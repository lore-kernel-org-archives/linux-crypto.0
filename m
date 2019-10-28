Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4B4CA9EA0
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 07:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 286EB205ED
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 07:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfJ1HpF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 03:45:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49918 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbfJ1HpF (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Mon, 28 Oct 2019 03:45:05 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iOzi4-0000fi-2o; Mon, 28 Oct 2019 15:45:04 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iOzi2-0002sx-G0; Mon, 28 Oct 2019 15:45:02 +0800
Date:   Mon, 28 Oct 2019 15:45:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     Ben Dooks <ben.dooks@codethink.co.uk>
Subject: crypto: atmel - Fix remaining endianess warnings
Message-ID: <20191028074502.awuog3greru5vmdg@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes the remaining sparse endianness warnings.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 33a76d1f4a6e..e82355ae85d8 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2048,7 +2048,7 @@ static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
 	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
 	bool enc = atmel_aes_is_encrypt(dd);
 	struct scatterlist *src, *dst;
-	u32 iv[AES_BLOCK_SIZE / sizeof(u32)];
+	__be32 iv[AES_BLOCK_SIZE / sizeof(u32)];
 	u32 emr;
 
 	if (is_async)
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 84cb8748a795..618b6856a12f 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -360,7 +360,7 @@ static size_t atmel_sha_append_sg(struct atmel_sha_reqctx *ctx)
 static void atmel_sha_fill_padding(struct atmel_sha_reqctx *ctx, int length)
 {
 	unsigned int index, padlen;
-	u64 bits[2];
+	__be64 bits[2];
 	u64 size[2];
 
 	size[0] = ctx->digcnt[0];
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
