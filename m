From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH v2 1/4] scatterlist: Introduce some helper functions
Date: Tue, 15 Mar 2016 15:47:59 +0800
Message-ID: <9442060edaca12f520bcbb76545ad33a52346e58.1458023698.git.baolin.wang@linaro.org>
References: <cover.1458023695.git.baolin.wang@linaro.org>
Cc: akpm@linux-foundation.org, david.s.gordon@intel.com,
	thomas.lendacky@amd.com, robert.jarzmik@free.fr,
	yamada.masahiro@socionext.com, smueller@chronox.de,
	tadeusz.struk@intel.com, standby24x7@gmail.com, shli@kernel.org,
	broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	baolin.wang@linaro.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, agk@redhat.com,
	snitzer@redhat.com, axboe@fb.com, dm-devel@redhat.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1458023695.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1458023695.git.baolin.wang@linaro.org>
References: <cover.1458023695.git.baolin.wang@linaro.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In crypto engine framework, one request can combine (copy) other requests'
scatterlists into its dynamic sg table to manage them together as a bulk
block , which can improve engine efficency with handling bulk block. Thus
we need some helper functions to manage dynamic scattertables.

This patch introduces 'sg_is_contiguous()' function to check if two
scatterlists are contiguous, 'sg_alloc_empty_table()' function to
allocate one empty dynamic sg table, 'sg_add_sg_to_table()' function
to copy one mapped scatterlist into sg table and 'sg_table_is_empty'
function to check if the sg table is empty.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 include/linux/scatterlist.h |   33 +++++++++++++++++++++
 lib/scatterlist.c           |   69 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 556ec1e..c1ed9f4 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -212,6 +212,20 @@ static inline void sg_unmark_end(struct scatterlist *sg)
 }
 
 /**
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
@@ -241,6 +255,23 @@ static inline void *sg_virt(struct scatterlist *sg)
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
+/**
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
+	return *(unsigned long *)sg_virt(sga) + sga->length ==
+		*(unsigned long *)sg_virt(sgb);
+}
+
 int sg_nents(struct scatterlist *sg);
 int sg_nents_for_len(struct scatterlist *sg, u64 len);
 struct scatterlist *sg_next(struct scatterlist *);
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
index 004fc70..6d3f3b0 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -370,6 +370,75 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 EXPORT_SYMBOL(sg_alloc_table);
 
 /**
+ * sg_add_sg_to_table - Add one scatterlist into sg table
+ * @sgt:	The sg table header to use
+ * @src:	The sg need to be added into sg table
+ *
+ * Description:
+ *   The 'nents' member indicates how many mapped scatterlists has been added
+ *   in the dynamic sg table. The 'orig_nents' member indicates the size of the
+ *   dynamic sg table.
+ *
+ *   Copy one mapped @src@ scatterlist into the dynamic sg table and increase
+ *   'nents' member.
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
+ * sg_alloc_empty_table - Allocate one empty dynamic sg table
+ * @sgt:	The sg table header to use
+ * @nents:	Number of entries in sg list
+ * @gfp_mask:	GFP allocation mask
+ *
+ *  Description:
+ *    Allocate and initialize one dynamic sg table. One dynamic sg table means
+ *    it need allocate @nents@ empty scatterlists entries and is used to copy
+ *    other mapped scatterlists into the dynamic sg table.
+ *
+ *    The 'nents' member indicates how many scatterlists has been copied into
+ *    the dynamic sg table. It should set 0 which means there are no mapped
+ *    scatterlists added in this sg table now.
+ *
+ *    The 'orig_nents' member indicates the size of the dynamic sg table.
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

