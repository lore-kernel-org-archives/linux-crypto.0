From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 03/17] crypto: talitos - Use zero entry to init descriptors ptrs to zero
Date: Fri,  6 Mar 2015 17:38:25 +0100 (CET)
Message-ID: <20150306163825.92F711A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Do use zero_entry value to init the descriptors ptrs to zero instead of
writing 0 in each field

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 103bfcf..de4d93b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1385,9 +1385,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	int sg_count, ret;
 
 	/* first DWORD empty */
-	desc->ptr[0].len = 0;
-	to_talitos_ptr(&desc->ptr[0], 0);
-	desc->ptr[0].j_extent = 0;
+	desc->ptr[0] = zero_entry;
 
 	/* cipher iv */
 	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
@@ -1457,9 +1455,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 			       DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
-	desc->ptr[6].len = 0;
-	to_talitos_ptr(&desc->ptr[6], 0);
-	desc->ptr[6].j_extent = 0;
+	desc->ptr[6] = zero_entry;
 
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
-- 
2.1.0
