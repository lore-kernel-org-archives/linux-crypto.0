From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 10/27] Drivers: ccree: ssi_hash.c - align block comments
Date: Wed, 24 May 2017 16:43:26 +1200
Message-ID: <20170524044326.30330-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Derek Robson <robsonde@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: gilad@benyossef.com,
	gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_hash.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 162d17dee2cd..11b5eae1c55e 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -97,7 +97,8 @@ struct hash_key_req_ctx {
 struct ssi_hash_ctx {
 	struct ssi_drvdata *drvdata;
 	/* holds the origin digest; the digest after "setkey" if HMAC,*
-	   the initial digest if HASH. */
+	 * the initial digest if HASH.
+	 */
 	u8 digest_buff[SSI_MAX_HASH_DIGEST_SIZE]  ____cacheline_aligned;
 	u8 opad_tmp_keys_buff[SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE]  ____cacheline_aligned;
 	dma_addr_t opad_tmp_keys_dma_addr  ____cacheline_aligned;
@@ -250,7 +251,8 @@ static int ssi_hash_map_request(struct device *dev,
 		}
 	} else { /*hash*/
 		/* Copy the initial digests if hash flow. The SRAM contains the
-		initial digests in the expected order for all SHA* */
+		 * initial digests in the expected order for all SHA*
+		 */
 		HW_DESC_INIT(&desc);
 		HW_DESC_SET_DIN_SRAM(&desc, larval_digest_addr, ctx->inter_digestsize);
 		HW_DESC_SET_DOUT_DLLI(&desc, state->digest_buff_dma_addr, ctx->inter_digestsize, NS_BIT, 0);
@@ -1027,7 +1029,8 @@ static int ssi_hash_setkey(void *hash,
 					ctx->drvdata, ctx->hash_mode);
 
 	/* The keylen value distinguishes HASH in case keylen is ZERO bytes,
-	   any NON-ZERO value utilizes HMAC flow */
+	 * any NON-ZERO value utilizes HMAC flow
+	 */
 	ctx->key_params.keylen = keylen;
 	ctx->key_params.key_dma_addr = 0;
 	ctx->is_hmac = true;
-- 
2.12.2
