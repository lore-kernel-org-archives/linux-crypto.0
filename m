Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F0AC38142
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Jan 2023 08:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjAXI2r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Jan 2023 03:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjAXI2q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Jan 2023 03:28:46 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344EC1D910
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jan 2023 00:28:43 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pKEfX-003UIO-J0; Tue, 24 Jan 2023 16:28:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 24 Jan 2023 16:28:39 +0800
Date:   Tue, 24 Jan 2023 16:28:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Will Thomas <will.thomas@imgtec.com>,
        James Hartley <james.hartley@imgtec.com>
Subject: [PATCH] crypto: img-hash - Fix sparse endianness warning
Message-ID: <Y8+Wt4MK4roMeEjd@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use cpu_to_be32 instead of be32_to_cpu in img_hash_read_result_queue
to silence sparse.  The generated code should be identical.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 9629e98bd68b..e5ed098a154d 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -157,9 +157,9 @@ static inline void img_hash_write(struct img_hash_dev *hdev,
 	writel_relaxed(value, hdev->io_base + offset);
 }
 
-static inline u32 img_hash_read_result_queue(struct img_hash_dev *hdev)
+static inline __be32 img_hash_read_result_queue(struct img_hash_dev *hdev)
 {
-	return be32_to_cpu(img_hash_read(hdev, CR_RESULT_QUEUE));
+	return cpu_to_be32(img_hash_read(hdev, CR_RESULT_QUEUE));
 }
 
 static void img_hash_start(struct img_hash_dev *hdev, bool dma)
@@ -283,10 +283,10 @@ static int img_hash_finish(struct ahash_request *req)
 static void img_hash_copy_hash(struct ahash_request *req)
 {
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
-	u32 *hash = (u32 *)ctx->digest;
+	__be32 *hash = (__be32 *)ctx->digest;
 	int i;
 
-	for (i = (ctx->digsize / sizeof(u32)) - 1; i >= 0; i--)
+	for (i = (ctx->digsize / sizeof(*hash)) - 1; i >= 0; i--)
 		hash[i] = img_hash_read_result_queue(ctx->hdev);
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
