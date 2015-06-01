From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 2/2] crypto: ccp - Protect against poorly marked end of
 sg list
Date: Mon, 1 Jun 2015 11:15:53 -0500
Message-ID: <20150601161553.729.88982.stgit@tlendack-t1.amdoffice.net>
References: <20150601161519.729.75909.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150601161519.729.75909.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Scatter gather lists can be created with more available entries than are
actually used (e.g. using sg_init_table() to reserve a specific number
of sg entries, but in actuality using something less than that based on
the data length).  The caller sometimes fails to mark the last entry
with sg_mark_end().  In these cases, sg_nents() will return the original
size of the sg list as opposed to the actual number of sg entries that
contain valid data.

On arm64, if the sg_nents() value is used in a call to dma_map_sg() in
this situation, then it causes a BUG_ON in lib/swiotlb.c because an
"empty" sg list entry results in dma_capable() returning false and
swiotlb trying to create a bounce buffer of size 0. This occurred in
the userspace crypto interface before being fixed by

0f477b655a52 ("crypto: algif - Mark sgl end at the end of data")

Protect against this by using the new sg_nents_for_len() function which
returns only the number of sg entries required to meet the desired
length and supplying that value to dma_map_sg().

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 542453c..d09c6c4 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -52,7 +52,7 @@ struct ccp_dm_workarea {
 
 struct ccp_sg_workarea {
 	struct scatterlist *sg;
-	unsigned int nents;
+	int nents;
 
 	struct scatterlist *dma_sg;
 	struct device *dma_dev;
@@ -495,7 +495,10 @@ static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
 	if (!sg)
 		return 0;
 
-	wa->nents = sg_nents(sg);
+	wa->nents = sg_nents_for_len(sg, len);
+	if (wa->nents < 0)
+		return wa->nents;
+
 	wa->bytes_left = len;
 	wa->sg_used = 0;
 
