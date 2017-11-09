From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 01/10] staging: ccree: fix leak of import() after init()
Date: Thu,  9 Nov 2017 09:16:09 +0000
Message-ID: <1510218980-3549-2-git-send-email-gilad@benyossef.com>
References: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
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

crypto_ahash_import() may be called either after
crypto_ahash_init() or without such call. Right now
we always internally call init() as part of
import(), thus leaking memory and mappings if the
user has already called init() herself.

Fix this by only calling init() internally if the
state is not already initialized.

Fixes: commit 454527d0d94f ("staging: ccree: fix hash import/export")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index d79090e..1799d3f 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1778,9 +1778,12 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 	}
 	in += sizeof(u32);
 
-	rc = ssi_hash_init(state, ctx);
-	if (rc)
-		goto out;
+	/* call init() to allocate bufs if the user hasn't */
+	if (!state->digest_buff) {
+		rc = ssi_hash_init(state, ctx);
+		if (rc)
+			goto out;
+	}
 
 	dma_sync_single_for_cpu(dev, state->digest_buff_dma_addr,
 				ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-- 
2.7.4
