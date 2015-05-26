From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 3/3] crypto: ccp - Protect against poorly marked end of
 sg list
Date: Tue, 26 May 2015 13:06:35 -0500
Message-ID: <20150526180635.6527.5580.stgit@tlendack-t1.amdoffice.net>
References: <20150526180612.6527.53332.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0111.outbound.protection.outlook.com ([207.46.100.111]:44640
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750835AbbEZSk2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 14:40:28 -0400
In-Reply-To: <20150526180612.6527.53332.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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

Protect against this in the future by counting the number of sg entries
needed to meet the length requirement and supplying that value to
dma_map_sg().

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 542453c..8377ed6 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -477,6 +477,22 @@ static u32 ccp_gen_jobid(struct ccp_device *ccp)
 	return atomic_inc_return(&ccp->current_id) & CCP_JOBID_MASK;
 }
 
+static int ccp_sg_nents(struct scatterlist *sg, u64 len)
+{
+	int nents = 0;
+
+	while (sg && len) {
+		nents++;
+		if (sg->length > len)
+			break;
+
+		len -= sg->length;
+		sg = sg_next(sg);
+	}
+
+	return nents;
+}
+
 static void ccp_sg_free(struct ccp_sg_workarea *wa)
 {
 	if (wa->dma_count)
@@ -495,7 +511,7 @@ static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
 	if (!sg)
 		return 0;
 
-	wa->nents = sg_nents(sg);
+	wa->nents = ccp_sg_nents(sg, len);
 	wa->bytes_left = len;
 	wa->sg_used = 0;
 
