Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AB6C38142
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjAaICE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjAaIB5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:01:57 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F68A41B6D
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:01:56 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlaT-005vfG-RY; Tue, 31 Jan 2023 16:01:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:01:53 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:01:53 +0800
Subject: [PATCH 5/32] crypto: akcipher - Use crypto_request_complete
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        linux-arm-kernel@axis.com,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        George Cherian <gcherian@marvell.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com, Thara Gopinath <thara.gopinath@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Message-Id: <E1pMlaT-005vfG-RY@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the crypto_request_complete helper instead of calling the
completion function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/akcipher.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
index aaf1092b93b8..a0fba4b2eccf 100644
--- a/include/crypto/internal/akcipher.h
+++ b/include/crypto/internal/akcipher.h
@@ -69,7 +69,7 @@ static inline void *akcipher_tfm_ctx_dma(struct crypto_akcipher *tfm)
 static inline void akcipher_request_complete(struct akcipher_request *req,
 					     int err)
 {
-	req->base.complete(&req->base, err);
+	crypto_request_complete(&req->base, err);
 }
 
 static inline const char *akcipher_alg_name(struct crypto_akcipher *tfm)
