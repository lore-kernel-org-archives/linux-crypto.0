Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B07C77B73
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Apr 2023 14:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjDSO0q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Apr 2023 10:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjDSO0p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2023 10:26:45 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA4BC172
        for <linux-crypto@vger.kernel.org>; Wed, 19 Apr 2023 07:26:11 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id q5so17201887wmo.4
        for <linux-crypto@vger.kernel.org>; Wed, 19 Apr 2023 07:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681914368; x=1684506368;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JeZNA1s0QESP/I0CqxVMnzYwGVuCPAunM/8r509Fe9w=;
        b=ShYYRDYCGQc99t8l2LBANPb2KPl6FYJ/5rLLIlr+3iIn1nHXCsMf4hGejSQOch/iW/
         KLpdrkwNzuaTyHCMVmD7SRamW7oNIwqrQxddFKuoYjuWaeWs1JctAxvvF+FVkoCR5Xmk
         EsjvFK1/q9h+Z46Fz0f7p6Er60x57Bhfe76eECK8ykW0ocL22TW+KW30LsboBIN9nl1N
         3fgoDWK/zC+RMJUFVqA4ACiOOldMhuVvGsgHQsZbBuP13xPWcbOIzIGiD0jP1z7b2lSJ
         H19z+Gm8Yj2/gpsCFTa0Kq3ks8UzOQfQwbggkHmzn4dxtVcCiDcS+6zBGChjWOVIlQCU
         F/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681914368; x=1684506368;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JeZNA1s0QESP/I0CqxVMnzYwGVuCPAunM/8r509Fe9w=;
        b=HOsG38iRjTVf9TJZdagqBkPDdC/eagkyD/onx1/PrwrhuF4Db369WNuLajJIPF2Z5N
         7jraTO1to3uQqPnF/wRAdzvkQMj4c2w6ErpjMge9p42EdsFkUcSB8I3rjWbckGlBSEAs
         UL8EGEc5FNpe6QR6kbBQgaWsz5llxIvnx1Lm5oUpSvqoRqwmgOt7qPhF8c40M3S3gx9r
         Da/y8vpZFmNyK3o2cJ3xV2fZ3czBUmKunbHCNxi13EvQQIYxSnJPTYB0KrEPPg6TlxYt
         mQy9f+7fjqtAk/alWTBTKn54q8D5qG6seu/jasiKfQykUwS9M7WQB5wRrjvwEPogQPg+
         MWYQ==
X-Gm-Message-State: AAQBX9dTiwwoTZwjzxE08c4b1SOfXOKaELoO3b97aUDLyQb4FdzsBSvn
        t3L4HbzwSvC91xtBXuzGgnDeew==
X-Google-Smtp-Source: AKy350YovrybGst8hzvGzmZDFWnh2USQWtHYaasH+1FyJ6ozgojeUQ2NlRYNyrYogEORRcf/pt5p1Q==
X-Received: by 2002:a1c:7c04:0:b0:3ed:2ae9:6c75 with SMTP id x4-20020a1c7c04000000b003ed2ae96c75mr16934529wmc.37.1681914368188;
        Wed, 19 Apr 2023 07:26:08 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c211300b003f17316ab46sm2343548wml.13.2023.04.19.07.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 07:26:07 -0700 (PDT)
Date:   Wed, 19 Apr 2023 17:26:04 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linus Walleij <linusw@kernel.org>, Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: ixp4xx - silence uninitialized variable warning
Message-ID: <7de7d932-d01b-4ada-ae07-827c32438e00@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Smatch complains that "dma" is uninitialized if dma_pool_alloc() fails.
This is true, but also harmless.  Anyway, move the assignment after the
error checking to silence this warning.

Fixes: 586d492f2856 ("crypto: ixp4xx - fix building wiht 64-bit dma_addr_t")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index ed15379a9818..4a18095ae5d8 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -1175,9 +1175,9 @@ static int aead_perform(struct aead_request *req, int encrypt,
 		/* The 12 hmac bytes are scattered,
 		 * we need to copy them into a safe buffer */
 		req_ctx->hmac_virt = dma_pool_alloc(buffer_pool, flags, &dma);
-		crypt->icv_rev_aes = dma;
 		if (unlikely(!req_ctx->hmac_virt))
 			goto free_buf_dst;
+		crypt->icv_rev_aes = dma;
 		if (!encrypt) {
 			scatterwalk_map_and_copy(req_ctx->hmac_virt,
 						 req->src, cryptlen, authsize, 0);
-- 
2.39.2

