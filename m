From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 2/4] crypto: Add akcipher_set_reqsize() function
Date: Wed, 21 Jun 2017 17:47:53 -0500
Message-ID: <20170621224753.15132.10644.stgit@taos.amd.com>
References: <20170621224655.15132.20473.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0053.outbound.protection.outlook.com ([104.47.36.53]:40247
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751755AbdFUWsE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 18:48:04 -0400
In-Reply-To: <20170621224655.15132.20473.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 include/crypto/internal/akcipher.h |    6 ++++++
 1 file changed, 6 insertions(+)

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
