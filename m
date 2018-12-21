Return-Path: <SRS0=edWn=O6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from inva021.nxp.com ([92.121.34.21]:49164 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387764AbeLUP7s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Dec 2018 10:59:48 -0500
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx@nxp.com,
        Iuliana Prodan <Iuliana.Prodan@nxp.com>
Subject: [PATCH 2/3] crypto: caam - create ahash shared descriptors only once
Date: Fri, 21 Dec 2018 17:59:09 +0200
Message-Id: <20181221155910.6235-3-horia.geanta@nxp.com>
In-Reply-To: <20181221155910.6235-1-horia.geanta@nxp.com>
References: <20181221155910.6235-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Iuliana Prodan <Iuliana.Prodan@nxp.com>

For keyed hash algorithms, shared descriptors are currently generated
twice:
-at tfm initialization time, in cra_init() callback
-in setkey() callback

Since it's mandatory to call setkey() for keyed algorithms, drop the
generation in cra_init().

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 33f7c19efb62..179981f44807 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1722,7 +1722,12 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct caam_hash_state));
-	return ahash_set_sh_desc(ahash);
+
+	/*
+	 * For keyed hash algorithms shared descriptors
+	 * will be created later in setkey() callback
+	 */
+	return alg->setkey ? 0 : ahash_set_sh_desc(ahash);
 }
 
 static void caam_hash_cra_exit(struct crypto_tfm *tfm)
-- 
2.16.2
