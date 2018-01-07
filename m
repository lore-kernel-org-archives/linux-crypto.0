From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 11/27] stating: ccree: revert "staging: ccree: fix leak of
 import() after init()"
Date: Sun,  7 Jan 2018 12:14:22 +0000
Message-ID: <1515327285-8948-12-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

This reverts commit c5f39d07860c ("staging: ccree: fix leak of import()
after init()") and commit aece09024414 ("staging: ccree: Uninitialized
return in ssi_ahash_import()").

This is the wrong solution and ends up relying on uninitialized memory,
although it was not obvious to me at the time.

Cc: stable@vger.kernel.org
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index ff05ac8..ee7370c 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1673,7 +1673,7 @@ static int cc_hash_import(struct ahash_request *req, const void *in)
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	u32 tmp;
-	int rc = 0;
+	int rc;
 
 	memcpy(&tmp, in, sizeof(u32));
 	if (tmp != CC_EXPORT_MAGIC) {
@@ -1682,12 +1682,9 @@ static int cc_hash_import(struct ahash_request *req, const void *in)
 	}
 	in += sizeof(u32);
 
-	/* call init() to allocate bufs if the user hasn't */
-	if (!state->digest_buff) {
-		rc = cc_hash_init(req);
-		if (rc)
-			goto out;
-	}
+	rc = cc_hash_init(req);
+	if (rc)
+		goto out;
 
 	dma_sync_single_for_cpu(dev, state->digest_buff_dma_addr,
 				ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-- 
2.7.4
