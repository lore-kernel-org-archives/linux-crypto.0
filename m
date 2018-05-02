From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 01/10] crypto: aead - allow to allocate AEAD requests on the stack
Date: Wed,  2 May 2018 11:57:16 +0200
Message-ID: <20180502095725.31935-2-antoine.tenart@bootlin.com>
References: <20180502095725.31935-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502095725.31935-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Adds the AEAD_REQUEST_ON_STACK primitive to allow allocating AEAD
requests on the stack, as it can already be done with various other
crypto algorithms within the kernel.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/crypto/aead.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 1e26f790b03f..b67064786546 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -151,6 +151,11 @@ struct aead_alg {
 	struct crypto_alg base;
 };
 
+#define AEAD_REQUEST_ON_STACK(name, tfm) \
+	char __##name##_desc[sizeof(struct aead_request) + \
+		crypto_aead_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
+	struct aead_request *name = (void *)__##name##_desc
+
 struct crypto_aead {
 	unsigned int authsize;
 	unsigned int reqsize;
-- 
2.17.0
