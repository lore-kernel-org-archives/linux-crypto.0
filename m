From: Harsh Jain <harshjain.prof@gmail.com>
Subject: [PATCH 1/1] crypto:drbg- Fixes panic in wait_for_completion call.
Date: Thu, 25 May 2017 20:53:47 +0530
Message-ID: <ea78b839-5717-2edb-c073-82fa82a0b403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34376 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966414AbdEYPXz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 11:23:55 -0400
Received: by mail-pf0-f193.google.com with SMTP id w69so39915910pfk.1
        for <linux-crypto@vger.kernel.org>; Thu, 25 May 2017 08:23:55 -0700 (PDT)
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Initialise ctr_completion variable before use.

Signed-off-by: Harsh Jain <harshjain.prof@gmail.com>
---
 crypto/drbg.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index fa749f4..f1db29d 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1840,6 +1840,7 @@ static int drbg_kcapi_init(struct crypto_tfm *tfm)
     struct drbg_state *drbg = crypto_tfm_ctx(tfm);
 
     mutex_init(&drbg->drbg_mutex);
+    init_completion(&drbg->ctr_completion);
 
     return 0;
 }
-- 
1.7.10.1
