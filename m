From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 2/4] scatterlist: add sg_alloc_table_from_buf() helper
Date: Thu, 31 Mar 2016 14:29:42 +0200
Message-ID: <1459427384-21374-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1459427384-21374-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>,
	Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>,
	linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vignesh R <vigneshr-l0cyMroinI0@public.gmane.org>,
	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>,
	iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Dave Gordon <david.s.gordon-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459427384-21374-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

sg_alloc_table_from_buf() provides an easy solution to create an sg_table
from a virtual address pointer. This function takes care of dealing with
vmallocated buffers, buffer alignment, or DMA engine limitations (maximum
DMA transfer size).

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 include/linux/scatterlist.h |  24 ++++++
 lib/scatterlist.c           | 183 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 207 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 556ec1e..18d1091 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -41,6 +41,27 @@ struct sg_table {
 	unsigned int orig_nents;	/* original size of list */
 };
 
+/**
+ * struct sg_constraints - SG constraints structure
+ *
+ * @max_segment_size: maximum segment length. Each SG entry has to be smaller
+ *		      than this value. Zero means no constraint.
+ * @required_alignment: minimum alignment. Is used for both size and pointer
+ *			alignment. If this constraint is not met, the function
+ *			should return -EINVAL.
+ * @preferred_alignment: preferred alignment. Mainly used to optimize
+ *			 throughput when the DMA engine performs better when
+ *			 doing aligned accesses.
+ *
+ * This structure is here to help sg_alloc_table_from_buf() create the optimal
+ * SG list based on DMA engine constraints.
+ */
+struct sg_constraints {
+	size_t max_segment_size;
+	size_t required_alignment;
+	size_t preferred_alignment;
+};
+
 /*
  * Notes on SG table design.
  *
@@ -265,6 +286,9 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 	struct page **pages, unsigned int n_pages,
 	unsigned long offset, unsigned long size,
 	gfp_t gfp_mask);
+int sg_alloc_table_from_buf(struct sg_table *sgt, const void *buf, size_t len,
+			    const struct sg_constraints *constraints,
+			    gfp_t gfp_mask);
 
 size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
 		      size_t buflen, off_t skip, bool to_buffer);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 004fc70..9c9746e 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -433,6 +433,189 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 }
 EXPORT_SYMBOL(sg_alloc_table_from_pages);
 
+static size_t sg_buf_chunk_len(const void *buf, size_t len,
+			       const struct sg_constraints *cons)
+{
+	size_t chunk_len = len;
+
+	if (cons->max_segment_size)
+		chunk_len = min_t(size_t, chunk_len, cons->max_segment_size);
+
+	if (is_vmalloc_addr(buf)) {
+		unsigned long offset_in_page = offset_in_page(buf);
+		size_t contig_len = PAGE_SIZE - offset_in_page;
+		unsigned long phys = vmalloc_to_pfn(buf) - offset_in_page;
+		const void *contig_ptr = buf + contig_len;
+
+		/*
+		 * Vmalloced buffer might be composed of several physically
+		 * contiguous pages. Avoid extra scattergather entries in
+		 * this case.
+		 */
+		while (contig_len < chunk_len) {
+			if (phys + PAGE_SIZE != vmalloc_to_pfn(contig_ptr))
+				break;
+
+			contig_len += PAGE_SIZE;
+			contig_ptr += PAGE_SIZE;
+			phys += PAGE_SIZE;
+		}
+
+		chunk_len = min_t(size_t, chunk_len, contig_len);
+	}
+
+	if (!IS_ALIGNED((unsigned long)buf, cons->preferred_alignment)) {
+		const void *aligned_buf = PTR_ALIGN(buf,
+						    cons->preferred_alignment);
+		size_t unaligned_len = (unsigned long)(aligned_buf - buf);
+
+		chunk_len = min_t(size_t, chunk_len, unaligned_len);
+	} else if (chunk_len > cons->preferred_alignment) {
+		chunk_len &= ~(cons->preferred_alignment - 1);
+	}
+
+	return chunk_len;
+}
+
+#define sg_for_each_chunk_in_buf(buf, len, chunk_len, constraints)	\
+	for (chunk_len = sg_buf_chunk_len(buf, len, constraints);	\
+	     len;							\
+	     len -= chunk_len, buf += chunk_len,			\
+	     chunk_len = sg_buf_chunk_len(buf, len, constraints))
+
+static int sg_check_constraints(struct sg_constraints *cons,
+				const void *buf, size_t len)
+{
+	/*
+	 * We only accept buffers coming from the lowmem, vmalloc and
+	 * highmem regions.
+	 */
+	if (!virt_addr_valid(buf) && !is_vmalloc_addr(buf) &&
+	    !is_highmem_addr(buf))
+		return -EINVAL;
+
+	if (!cons->required_alignment)
+		cons->required_alignment = 1;
+
+	if (!cons->preferred_alignment)
+		cons->preferred_alignment = cons->required_alignment;
+
+	/* Test if buf and len are properly aligned. */
+	if (!IS_ALIGNED((unsigned long)buf, cons->required_alignment) ||
+	    !IS_ALIGNED(len, cons->required_alignment))
+		return -EINVAL;
+
+	/*
+	 * if the buffer has been vmallocated or kmapped and required_alignment
+	 * is more than PAGE_SIZE we cannot guarantee it.
+	 */
+	if (!virt_addr_valid(buf) && cons->required_alignment > PAGE_SIZE)
+		return -EINVAL;
+
+	/*
+	 * max_segment_size has to be aligned to required_alignment to
+	 * guarantee that all buffer chunks are aligned correctly.
+	 */
+	if (!IS_ALIGNED(cons->max_segment_size, cons->required_alignment))
+		return -EINVAL;
+
+	/*
+	 * preferred_alignment has to be aligned to required_alignment
+	 * to avoid misalignment of buffer chunks.
+	 */
+	if (!IS_ALIGNED(cons->preferred_alignment, cons->required_alignment))
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * sg_alloc_table_from_buf - create an SG table from a buffer
+ *
+ * @sgt: SG table
+ * @buf: buffer you want to create this SG table from
+ * @len: length of buf
+ * @constraints: optional constraints to take into account when creating
+ *		 the SG table. Can be NULL if no specific constraints are
+ *		 required.
+ * @gfp_mask: type of allocation to use when creating the table
+ *
+ * This function creates an SG table from a buffer, its length and some
+ * SG constraints.
+ *
+ * Note: This function supports buffers coming from the lowmem, vmalloc or
+ * highmem region.
+ */
+int sg_alloc_table_from_buf(struct sg_table *sgt, const void *buf, size_t len,
+			    const struct sg_constraints *constraints,
+			    gfp_t gfp_mask)
+{
+	struct sg_constraints cons = { };
+	size_t remaining, chunk_len;
+	const void *sg_buf;
+	int i, ret;
+
+	if (constraints)
+		cons = *constraints;
+
+	ret = sg_check_constraints(&cons, buf, len);
+	if (ret)
+		return ret;
+
+	sg_buf = buf;
+	remaining = len;
+	i = 0;
+	sg_for_each_chunk_in_buf(sg_buf, remaining, chunk_len, &cons)
+		i++;
+
+	ret = sg_alloc_table(sgt, i, gfp_mask);
+	if (ret)
+		return ret;
+
+	sg_buf = buf;
+	remaining = len;
+	i = 0;
+	sg_for_each_chunk_in_buf(sg_buf, remaining, chunk_len, &cons) {
+		if (virt_addr_valid(buf)) {
+			/*
+			 * Buffer is in lowmem, we can safely call
+			 * sg_set_buf().
+			 */
+			sg_set_buf(&sgt->sgl[i], sg_buf, chunk_len);
+		} else {
+			struct page *vm_page;
+
+			/*
+			 * Buffer has been obtained with vmalloc() or kmap().
+			 * In this case we have to extract the page information
+			 * and use sg_set_page().
+			 */
+			if (is_vmalloc_addr(sg_buf))
+				vm_page = vmalloc_to_page(sg_buf);
+			else
+				vm_page = kmap_to_page((void *)sg_buf);
+
+			if (!vm_page) {
+				ret = -ENOMEM;
+				goto err_free_table;
+			}
+
+			sg_set_page(&sgt->sgl[i], vm_page, chunk_len,
+				    offset_in_page(sg_buf));
+		}
+
+		i++;
+	}
+
+	return 0;
+
+err_free_table:
+	sg_free_table(sgt);
+
+	return ret;
+}
+EXPORT_SYMBOL(sg_alloc_table_from_buf);
+
 void __sg_page_iter_start(struct sg_page_iter *piter,
 			  struct scatterlist *sglist, unsigned int nents,
 			  unsigned long pgoffset)
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
