From: sleepingzucchini@gmail.com
Subject: [PATCH 3/5] staging: ccree: remove assignement in conditional
Date: Sun,  9 Jul 2017 17:10:45 -0400
Message-ID: <b45c6eaded65c1abb45b7a4d88824f289913d7ce.1499608047.git.sleepingzucchini@gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: gregkh@linuxfoundation.orgc, driverdev-devel@linuxdriverproject.org,
 linux-crypto@vger.kernel.org, Tyler Olivieri <sleepingzucchini@gmail.com>
To: gilad@benyossef.com
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
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

From: Tyler Olivieri <sleepingzucchini@gmail.com>

Patch to fix following checkpatch error:
ERROR: do not use assignment in if condition

Signed-off-by: Tyler Olivieri <sleepingzucchini@gmail.com>
---
 drivers/staging/ccree/ssi_hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 7e9f273..c66314f 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -602,7 +602,8 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 		return 0;
 	}
 
-	if (unlikely(rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, src, nbytes, block_size))) {
+	rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, src, nbytes, block_size);
+	if (unlikely(rc)) {
 		if (rc == 1) {
 			SSI_LOG_DEBUG(" data size not require HW update %x\n",
 				     nbytes);
@@ -1404,7 +1405,8 @@ static int ssi_mac_update(struct ahash_request *req)
 
 	state->xcbc_count++;
 
-	if (unlikely(rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, req->src, req->nbytes, block_size))) {
+	rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, req->src, req->nbytes, block_size);
+	if (unlikely(rc)) {
 		if (rc == 1) {
 			SSI_LOG_DEBUG(" data size not require HW update %x\n",
 				     req->nbytes);
-- 
2.9.4
