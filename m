From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/8] staging: ccree: fix leak of import() after init()
Date: Tue,  7 Nov 2017 09:39:57 +0000
Message-ID: <1510047606-5589-2-git-send-email-gilad@benyossef.com>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable <stable@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
Sender: stable-owner@vger.kernel.org
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
