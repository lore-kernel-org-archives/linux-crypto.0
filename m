From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 2/4] crypto: Add akcipher_set_reqsize() function
Date: Mon, 17 Jul 2017 15:16:21 -0500
Message-ID: <150032258166.102878.18033026127718459404.stgit@sosxen.amd.com>
References: <150032218639.102878.17376499349231172712.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0063.outbound.protection.outlook.com ([104.47.32.63]:21746
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751318AbdGQUQ1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 16:16:27 -0400
In-Reply-To: <150032218639.102878.17376499349231172712.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 0 files changed

diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
index 479a0078f0f7..805686ba2be4 100644
--- a/include/crypto/internal/akcipher.h
+++ b/include/crypto/internal/akcipher.h
@@ -38,6 +38,12 @@ static inline void *akcipher_request_ctx(struct akcipher_request *req)
 	return req->__ctx;
 }
 
+static inline void akcipher_set_reqsize(struct crypto_akcipher *akcipher,
+					unsigned int reqsize)
+{
+	crypto_akcipher_alg(akcipher)->reqsize = reqsize;
+}
+
 static inline void *akcipher_tfm_ctx(struct crypto_akcipher *tfm)
 {
 	return tfm->base.__crt_ctx;
