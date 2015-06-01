From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 1/2] scatterlist: introduce sg_nents_for_len
Date: Mon, 1 Jun 2015 11:15:25 -0500
Message-ID: <20150601161525.729.58208.stgit@tlendack-t1.amdoffice.net>
References: <20150601161519.729.75909.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0101.outbound.protection.outlook.com ([65.55.169.101]:9488
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751771AbbFAQam (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 12:30:42 -0400
In-Reply-To: <20150601161519.729.75909.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When performing a dma_map_sg() call, the number of sg entries to map is
required. Using sg_nents to retrieve the number of sg entries will
return the total number of entries in the sg list up to the entry marked
as the end. If there happen to be unused entries in the list, these will
still be counted. Some dma_map_sg() implementations will not handle the
unused entries correctly (lib/swiotlb.c) and execute a BUG_ON.

The sg_nents_for_len() function will traverse the sg list and return the
number of entries required to satisfy the supplied length argument. This
can then be supplied to the dma_map_sg() call to successfully map the
sg.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 include/linux/scatterlist.h |    1 +
 lib/scatterlist.c           |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index ed8f9e7..a0edb99 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -221,6 +221,7 @@ static inline void *sg_virt(struct scatterlist *sg)
 }
 
 int sg_nents(struct scatterlist *sg);
+int sg_nents_for_len(struct scatterlist *sg, u64 len);
 struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c9f2e8c..99fbc2f 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -56,6 +56,38 @@ int sg_nents(struct scatterlist *sg)
 }
 EXPORT_SYMBOL(sg_nents);
 
+/**
+ * sg_nents_for_len - return total count of entries in scatterlist
+ *                    needed to satisfy the supplied length
+ * @sg:		The scatterlist
+ * @len:	The total required length
+ *
+ * Description:
+ * Determines the number of entries in sg that are required to meet
+ * the supplied length, taking into acount chaining as well
+ *
+ * Returns:
+ *   the number of sg entries needed, negative error on failure
+ *
+ **/
+int sg_nents_for_len(struct scatterlist *sg, u64 len)
+{
+	int nents;
+	u64 total;
+
+	if (!len)
+		return 0;
+
+	for (nents = 0, total = 0; sg; sg = sg_next(sg)) {
+		nents++;
+		total += sg->length;
+		if (total >= len)
+			return nents;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(sg_nents_for_len);
 
 /**
  * sg_last - return the last scatterlist entry in a list
