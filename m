From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 01/12] crypto: atmel-sha: create function to get an Atmel SHA device
Date: Thu, 22 Dec 2016 17:15:06 +0100
Message-ID: <2557968ceb904a9a73dc83a3639e9f11f54a643b.1482422983.git.cyrille.pitchen@atmel.com>
References: <cover.1482422983.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1482422983.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a transitional patch: it creates the atmel_sha_find_dev() function,
which will be used in further patches to share the source code responsible
for finding a Atmel SHA device.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 97e34799e077..33a36e667547 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -260,11 +260,8 @@ static void atmel_sha_fill_padding(struct atmel_sha_reqctx *ctx, int length)
 	}
 }
 
-static int atmel_sha_init(struct ahash_request *req)
+static struct atmel_sha_dev *atmel_sha_find_dev(struct atmel_sha_ctx *tctx)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct atmel_sha_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
 	struct atmel_sha_dev *dd = NULL;
 	struct atmel_sha_dev *tmp;
 
@@ -281,6 +278,16 @@ static int atmel_sha_init(struct ahash_request *req)
 
 	spin_unlock_bh(&atmel_sha.lock);
 
+	return dd;
+}
+
+static int atmel_sha_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	struct atmel_sha_dev *dd = atmel_sha_find_dev(tctx);
+
 	ctx->dd = dd;
 
 	ctx->flags = 0;
-- 
2.7.4
