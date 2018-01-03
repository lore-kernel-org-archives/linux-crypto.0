From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 5/6] crypto: stm32-hash: convert to the new crypto engine API
Date: Wed,  3 Jan 2018 21:11:08 +0100
Message-ID: <20180103201109.16077-6-clabbe.montjoie@gmail.com>
References: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	fabien.dessenne@st.com, virtualization@lists.linux-foundation.org,
	Corentin Labbe <clabbe.montjoie@gmail.com>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: alexandre.torgue@st.com, arei.gonglei@huawei.com, corbet@lwn.net,
	davem@davemloft.net, herbert@gondor.apana.org.au, jasowang@redhat.com,
	mcoquelin.stm32@gmail.com, mst@redhat.com
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

This patch convert the stm32-hash driver to the new crypto engine API.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/stm32/stm32-hash.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 4ca4a264a833..9790c2c936c7 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -122,6 +122,7 @@ enum stm32_hash_data_format {
 #define HASH_DMA_THRESHOLD		50
 
 struct stm32_hash_ctx {
+	struct crypto_engine_reqctx enginectx;
 	struct stm32_hash_dev	*hdev;
 	unsigned long		flags;
 
@@ -828,6 +829,11 @@ static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 	return 0;
 }
 
+static int stm32_hash_one_request(struct crypto_engine *engine,
+				  void *areq);
+static int stm32_hash_prepare_req(struct crypto_engine *engine,
+				  void *areq);
+
 static int stm32_hash_handle_queue(struct stm32_hash_dev *hdev,
 				   struct ahash_request *req)
 {
@@ -835,8 +841,9 @@ static int stm32_hash_handle_queue(struct stm32_hash_dev *hdev,
 }
 
 static int stm32_hash_prepare_req(struct crypto_engine *engine,
-				  struct ahash_request *req)
+				  void *areq)
 {
+	struct ahash_request *req = container_of(areq, struct ahash_request, base);
 	struct stm32_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
 	struct stm32_hash_request_ctx *rctx;
@@ -855,8 +862,9 @@ static int stm32_hash_prepare_req(struct crypto_engine *engine,
 }
 
 static int stm32_hash_one_request(struct crypto_engine *engine,
-				  struct ahash_request *req)
+				  void *areq)
 {
+	struct ahash_request *req = container_of(areq, struct ahash_request, base);
 	struct stm32_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
 	struct stm32_hash_request_ctx *rctx;
@@ -1033,6 +1041,9 @@ static int stm32_hash_cra_init_algs(struct crypto_tfm *tfm,
 	if (algs_hmac_name)
 		ctx->flags |= HASH_FLAGS_HMAC;
 
+	ctx->enginectx.op.do_one_request = stm32_hash_one_request;
+	ctx->enginectx.op.prepare_request = stm32_hash_prepare_req;
+	ctx->enginectx.op.unprepare_request = NULL;
 	return 0;
 }
 
@@ -1493,9 +1504,6 @@ static int stm32_hash_probe(struct platform_device *pdev)
 		goto err_engine;
 	}
 
-	hdev->engine->prepare_hash_request = stm32_hash_prepare_req;
-	hdev->engine->hash_one_request = stm32_hash_one_request;
-
 	ret = crypto_engine_start(hdev->engine);
 	if (ret)
 		goto err_engine_start;
-- 
2.13.6
