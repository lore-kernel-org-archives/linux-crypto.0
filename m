From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v3 01/12] crypto: atmel-sha: create function to get an Atmel
 SHA device
Date: Thu, 26 Jan 2017 17:07:46 +0100
Message-ID: <952192a522f455e6b066b8e542a446764064869f.1485443478.git.cyrille.pitchen@atmel.com>
References: <cover.1485443478.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, Cyrille Pitchen <cyrille.pitchen@atmel.com>,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
 <nicolas.ferre@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1485443478.git.cyrille.pitchen@atmel.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
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
