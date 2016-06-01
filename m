From: Baolin Wang <baolin.wang@linaro.org>
Subject: [RFC v3 2/4] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Wed,  1 Jun 2016 12:58:05 +0800
Message-ID: <47e9ddd8c9ea9ad9e29c8cb027d19d8459ea1479.1464756501.git.baolin.wang@linaro.org>
References: <cover.1464756501.git.baolin.wang@linaro.org>
Cc: ebiggers3@gmail.com, js1304@gmail.com, tadeusz.struk@intel.com,
	smueller@chronox.de, standby24x7@gmail.com, shli@kernel.org,
	dan.j.williams@intel.com, martin.petersen@oracle.com,
	sagig@mellanox.com, kent.overstreet@gmail.com,
	keith.busch@intel.com, tj@kernel.org, ming.lei@canonical.com,
	broonie@kernel.org, arnd@arndb.de, linux-crypto@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, baolin.wang@linaro.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	dm-devel@redhat.com, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36608 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbcFAE6x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 00:58:53 -0400
Received: by mail-pf0-f176.google.com with SMTP id f144so7153763pfa.3
        for <linux-crypto@vger.kernel.org>; Tue, 31 May 2016 21:58:52 -0700 (PDT)
In-Reply-To: <cover.1464756501.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1464756501.git.baolin.wang@linaro.org>
References: <cover.1464756501.git.baolin.wang@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now some cipher hardware engines prefer to handle bulk block rather than one
sector (512 bytes) created by dm-crypt, cause these cipher engines can handle
the intermediate values (IV) by themselves in one bulk block. This means we
can increase the size of the request by merging request rather than always 512
bytes and thus increase the hardware engine processing speed.

So introduce 'CRYPTO_ALG_BULK' flag to indicate this cipher can support bulk
mode.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 include/crypto/skcipher.h |    7 +++++++
 include/linux/crypto.h    |    6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 0f987f5..d89d29a 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -519,5 +519,12 @@ static inline void skcipher_request_set_crypt(
 	req->iv = iv;
 }
 
+static inline unsigned int skcipher_is_bulk_mode(struct crypto_skcipher *sk_tfm)
+{
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(sk_tfm);
+
+	return crypto_tfm_alg_bulk(tfm);
+}
+
 #endif	/* _CRYPTO_SKCIPHER_H */
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 6e28c89..a315487 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -63,6 +63,7 @@
 #define CRYPTO_ALG_DEAD			0x00000020
 #define CRYPTO_ALG_DYING		0x00000040
 #define CRYPTO_ALG_ASYNC		0x00000080
+#define CRYPTO_ALG_BULK			0x00000100
 
 /*
  * Set this bit if and only if the algorithm requires another algorithm of
@@ -623,6 +624,11 @@ static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
 }
 
+static inline unsigned int crypto_tfm_alg_bulk(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_BULK;
+}
+
 static inline unsigned int crypto_tfm_alg_blocksize(struct crypto_tfm *tfm)
 {
 	return tfm->__crt_alg->cra_blocksize;
-- 
1.7.9.5
