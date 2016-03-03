From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 1/4] scatterlist: Introduce some helper functions
Date: Thu,  3 Mar 2016 13:19:36 +0800
Message-ID: <3bff3e286d3ee01ebb7e26d7233075054c42a7a9.1456981314.git.baolin.wang@linaro.org>
References: <cover.1456981314.git.baolin.wang@linaro.org>
Cc: akpm@linux-foundation.org, david.s.gordon@intel.com,
	thomas.lendacky@amd.com, robert.jarzmik@free.fr,
	yamada.masahiro@socionext.com, smueller@chronox.de,
	tadeusz.struk@intel.com, standby24x7@gmail.com, shli@kernel.org,
	broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	baolin.wang@linaro.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, agk@redhat.com,
	snitzer@redhat.com, axboe@fb.com, dm-devel@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35168 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbcCCFU3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Mar 2016 00:20:29 -0500
Received: by mail-pa0-f54.google.com with SMTP id bj10so7970952pad.2
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2016 21:20:29 -0800 (PST)
In-Reply-To: <cover.1456981314.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1456981314.git.baolin.wang@linaro.org>
References: <cover.1456981314.git.baolin.wang@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In crypto engine framework, one request can combine other requests'
scatterlists into its sg table to improve engine efficency with
handling bulk block. Thus we need some helper functions to manage
dynamic scattertables.

This patch introduces 'sg_is_contiguous()' function to check if two
scatterlists are contiguous, 'sg_alloc_empty_table()' function to
allocate one empty sg table, 'sg_add_sg_to_table()' function to add
one scatterlist into sg table and 'sg_table_is_empty' function to
check if the sg table is empty.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 include/linux/scatterlist.h |   33 ++++++++++++++++++++++++
 lib/scatterlist.c           |   59 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 556ec1e..ae9aee6 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -212,6 +212,37 @@ static inline void sg_unmark_end(struct scatterlist *sg)
 }
 
 /**
+ * sg_is_contiguous - Check if the scatterlists are contiguous
+ * @sga: SG entry
+ * @sgb: SG entry
+ *
+ * Description:
+ *   If the sga scatterlist is contiguous with the sgb scatterlist,
+ *   that means they can be merged together.
+ *
+ **/
+static inline bool sg_is_contiguous(struct scatterlist *sga,
+				    struct scatterlist *sgb)
+{
+	return ((sga->page_link & ~0x3UL) + sga->offset + sga->length ==
+		(sgb->page_link & ~0x3UL));
+}
+
+/**
+ * sg_table_is_empty - Check if the sg table is empty
+ * @sgt: sg table
+ *
+ * Description:
+ *   The 'orig_nents' member of one sg table is used to indicate how many
+ *   scatterlists in the sg table.
+ *
+ **/
+static inline bool sg_table_is_empty(struct sg_table *sgt)
+{
+	return !sgt->orig_nents;
+}
+
+/**
  * sg_phys - Return physical address of an sg entry
  * @sg:	     SG entry
  *
@@ -261,6 +292,8 @@ void sg_free_table(struct sg_table *);
 int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int,
 		     struct scatterlist *, gfp_t, sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
+int sg_alloc_empty_table(struct sg_table *, unsigned int, gfp_t);
+int sg_add_sg_to_table(struct sg_table *, struct scatterlist *);
 int sg_alloc_table_from_pages(struct sg_table *sgt,
 	struct page **pages, unsigned int n_pages,
 	unsigned long offset, unsigned long size,
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 004fc70..e9e5d5a 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -370,6 +370,65 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 EXPORT_SYMBOL(sg_alloc_table);
 
 /**
+ * sg_add_sg_to_table - Add one scatterlist into sg table
+ * @sgt:	The sg table header to use
+ * @src:	The sg need to be added into sg table
+ *
+ * Description:
+ *   The 'nents' member indicates how many scatterlists added in the sg table.
+ *   Copy the @src@ scatterlist into sg table and increase 'nents' member.
+ *
+ **/
+int sg_add_sg_to_table(struct sg_table *sgt, struct scatterlist *src)
+{
+	unsigned int i = 0, orig_nents = sgt->orig_nents;
+	struct scatterlist *sgl = sgt->sgl;
+	struct scatterlist *sg;
+
+	/* Check if there are enough space for the new sg to be added */
+	if (sgt->nents >= sgt->orig_nents)
+		return -EINVAL;
+
+	for_each_sg(sgl, sg, orig_nents, i) {
+		if (sgt->nents > 0 && i == (sgt->nents - 1)) {
+			sg_unmark_end(sg);
+		} else if (i == sgt->nents) {
+			memcpy(sg, src, sizeof(struct scatterlist));
+			sg_mark_end(sg);
+			sgt->nents++;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * sg_alloc_empty_table - Allocate one empty sg table
+ * @sgt:	The sg table header to use
+ * @nents:	Number of entries in sg list
+ * @gfp_mask:	GFP allocation mask
+ *
+ *  Description:
+ *    Allocate and initialize an sg table. The 'nents' member of sg_table
+ *    indicates how many scatterlists added in the sg table. It should set
+ *    0 which means there are no scatterlists added in this sg table now.
+ *
+ **/
+int sg_alloc_empty_table(struct sg_table *sgt, unsigned int nents,
+			 gfp_t gfp_mask)
+{
+	int ret;
+
+	ret = sg_alloc_table(sgt, nents, gfp_mask);
+	if (ret)
+		return ret;
+
+	sgt->nents = 0;
+	return 0;
+}
+
+/**
  * sg_alloc_table_from_pages - Allocate and initialize an sg table from
  *			       an array of pages
  * @sgt:	The sg table header to use
-- 
1.7.9.5
