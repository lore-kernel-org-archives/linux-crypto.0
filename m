Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2C3C282C5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF3942184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548284017;
	bh=bNXKQZrjQDdVE6uVnXReLUroOzBvjqFAqo/MuiQNV44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wA9MlY1sREH7ows3KBnd7yl+853v9M8qiRrxuUX/24d54Qe2ELnaP4KEel6357iLD
	 MbHSshMUh51qMQMC/916yqHv9bteOWshxkckTStgvsZFAhQdbj3ouQJTu3bqhEx+6u
	 HG7KZV19vnp86x4T/WEMHl2S8K6BGghpkZqWysCY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfAWWxb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:53:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbfAWWwe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:34 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F0A0218AE;
        Wed, 23 Jan 2019 22:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283953;
        bh=bNXKQZrjQDdVE6uVnXReLUroOzBvjqFAqo/MuiQNV44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIW6Mh0XkHE1QidJCPPahWXmzzHX5ObnXq9AjvK04uOYo2WMdwF5WaSdUo7+rdtgY
         +5xjs8TTBe4c9643vFA7pWfBsYmz1opkL6/aeh/3c+sPo4N5VkmrygFmogRq+DyvWu
         ADukYlE3iZD1+J2VNcNxUi5VCWOHBKvR2up6M8kY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC/RFT PATCH 08/15] crypto: testmgr - add testvec_config struct and helper functions
Date:   Wed, 23 Jan 2019 14:49:19 -0800
Message-Id: <20190123224926.250525-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190123224926.250525-1-ebiggers@kernel.org>
References: <20190123224926.250525-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Crypto algorithms must produce the same output for the same input
regardless of data layout, i.e. how the src and dst scatterlists are
divided into chunks and how each chunk is aligned.  Request flags such
as CRYPTO_TFM_REQ_MAY_SLEEP must not affect the result either.

However, testing of this currently has many gaps.  For example,
individual algorithms are responsible for providing their own chunked
test vectors.  But many don't bother to do this or test only one or two
cases, providing poor test coverage.  Also, other things such as
misaligned IVs and CRYPTO_TFM_REQ_MAY_SLEEP are never tested at all.

Test code is also duplicated between the chunked and non-chunked cases,
making it difficult to make other improvements.

To improve the situation, this patch series basically moves the chunk
descriptions into the testmgr itself so that they are shared by all
algorithms.  However, it's done in an extensible way via a new struct
'testvec_config', which describes not just the scaled chunk lengths but
also all other aspects of the crypto operation besides the data itself
such as the buffer alignments, the request flags, whether the operation
is in-place or not, the IV alignment, and for hash algorithms when to
do each update() and when to use finup() vs. final() vs. digest().

Then, this patch series makes skcipher, aead, and hash algorithms be
tested against a list of default testvec_configs, replacing the current
test code.  This improves overall test coverage, without reducing test
performance too much.  Note that the test vectors themselves are not
changed, except for removing the chunk lists.

This series also adds randomized fuzz tests, enabled by a new kconfig
option intended for developer use only, where skcipher, aead, and hash
algorithms are tested against many randomly generated testvec_configs.
This provides much more comprehensive test coverage.

These improved tests have already exposed many bugs.

To start it off, this initial patch adds the testvec_config and various
helper functions that will be used by the skcipher, aead, and hash test
code that will be converted to use the new testvec_config framework.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 452 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 437 insertions(+), 15 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4ac3d22256c3..a29b42a17841 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
  * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
+ * Copyright (c) 2019 Google LLC
  *
  * Updated RFC4106 AES-GCM testing.
  *    Authors: Aidan O'Mahony (aidan.o.mahony@intel.com)
@@ -26,6 +27,7 @@
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <linux/module.h>
+#include <linux/once.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -146,12 +148,12 @@ static void hexdump(unsigned char *buf, unsigned int len)
 			buf, len, false);
 }
 
-static int testmgr_alloc_buf(char *buf[XBUFSIZE])
+static int __testmgr_alloc_buf(char *buf[XBUFSIZE], int order)
 {
 	int i;
 
 	for (i = 0; i < XBUFSIZE; i++) {
-		buf[i] = (void *)__get_free_page(GFP_KERNEL);
+		buf[i] = (char *)__get_free_pages(GFP_KERNEL, order);
 		if (!buf[i])
 			goto err_free_buf;
 	}
@@ -160,17 +162,435 @@ static int testmgr_alloc_buf(char *buf[XBUFSIZE])
 
 err_free_buf:
 	while (i-- > 0)
-		free_page((unsigned long)buf[i]);
+		free_pages((unsigned long)buf[i], order);
 
 	return -ENOMEM;
 }
 
-static void testmgr_free_buf(char *buf[XBUFSIZE])
+static int testmgr_alloc_buf(char *buf[XBUFSIZE])
+{
+	return __testmgr_alloc_buf(buf, 0);
+}
+
+static void __testmgr_free_buf(char *buf[XBUFSIZE], int order)
 {
 	int i;
 
 	for (i = 0; i < XBUFSIZE; i++)
-		free_page((unsigned long)buf[i]);
+		free_pages((unsigned long)buf[i], order);
+}
+
+static void testmgr_free_buf(char *buf[XBUFSIZE])
+{
+	__testmgr_free_buf(buf, 0);
+}
+
+#define TESTMGR_POISON_BYTE	0xfe
+#define TESTMGR_POISON_LEN	16
+
+static inline void testmgr_poison(void *addr, size_t len)
+{
+	memset(addr, TESTMGR_POISON_BYTE, len);
+}
+
+/* Is the memory region still fully poisoned? */
+static inline bool testmgr_is_poison(const void *addr, size_t len)
+{
+	return memchr_inv(addr, TESTMGR_POISON_BYTE, len) == NULL;
+}
+
+/* flush type for hash algorithms */
+enum flush_type {
+	/* merge with update of previous buffer(s) */
+	FLUSH_TYPE_NONE = 0,
+
+	/* update with previous buffer(s) before doing this one */
+	FLUSH_TYPE_FLUSH,
+
+	/* likewise, but also export and re-import the intermediate state */
+	FLUSH_TYPE_REIMPORT,
+};
+
+/* finalization function for hash algorithms */
+enum finalization_type {
+	FINALIZATION_TYPE_FINAL,	/* use final() */
+	FINALIZATION_TYPE_FINUP,	/* use finup() */
+	FINALIZATION_TYPE_DIGEST,	/* use digest() */
+};
+
+#define TEST_SG_TOTAL	10000
+
+/**
+ * struct test_sg_division - description of a scatterlist entry
+ *
+ * This struct describes one entry of a scatterlist being constructed to check a
+ * crypto test vector.
+ *
+ * @proportion_of_total: length of this chunk relative to the total length,
+ *			 given as a proportion out of TEST_SG_TOTAL so that it
+ *			 scales to fit any test vector
+ * @offset: byte offset into a 2-page buffer at which this chunk will start
+ * @offset_relative_to_alignmask: if true, add the algorithm's alignmask to the
+ *				  @offset
+ * @flush_type: for hashes, whether an update() should be done now vs.
+ *		continuing to accumulate data
+ */
+struct test_sg_division {
+	unsigned int proportion_of_total;
+	unsigned int offset;
+	bool offset_relative_to_alignmask;
+	enum flush_type flush_type;
+};
+
+/**
+ * struct testvec_config - configuration for testing a crypto test vector
+ *
+ * This struct describes the data layout and other parameters with which each
+ * crypto test vector can be tested.
+ *
+ * @name: name of this config, logged for debugging purposes if a test fails
+ * @inplace: operate on the data in-place, if applicable for the algorithm type?
+ * @req_flags: extra request_flags, e.g. CRYPTO_TFM_REQ_MAY_SLEEP
+ * @src_divs: description of how to arrange the source scatterlist
+ * @dst_divs: description of how to arrange the dst scatterlist, if applicable
+ *	      for the algorithm type.  Defaults to @src_divs if unset.
+ * @iv_offset: misalignment of the IV in the range [0..MAX_ALGAPI_ALIGNMASK+1],
+ *	       where 0 is aligned to a 2*(MAX_ALGAPI_ALIGNMASK+1) byte boundary
+ * @iv_offset_relative_to_alignmask: if true, add the algorithm's alignmask to
+ *				     the @iv_offset
+ * @finalization_type: what finalization function to use for hashes
+ */
+struct testvec_config {
+	const char *name;
+	bool inplace;
+	u32 req_flags;
+	struct test_sg_division src_divs[XBUFSIZE];
+	struct test_sg_division dst_divs[XBUFSIZE];
+	unsigned int iv_offset;
+	bool iv_offset_relative_to_alignmask;
+	enum finalization_type finalization_type;
+};
+
+#define TESTVEC_CONFIG_NAMELEN	192
+
+static unsigned int count_test_sg_divisions(const struct test_sg_division *divs)
+{
+	unsigned int remaining = TEST_SG_TOTAL;
+	unsigned int ndivs = 0;
+
+	do {
+		remaining -= divs[ndivs++].proportion_of_total;
+	} while (remaining);
+
+	return ndivs;
+}
+
+static bool valid_sg_divisions(const struct test_sg_division *divs,
+			       unsigned int count, bool *any_flushes_ret)
+{
+	unsigned int total = 0;
+	unsigned int i;
+
+	for (i = 0; i < count && total != TEST_SG_TOTAL; i++) {
+		if (divs[i].proportion_of_total <= 0 ||
+		    divs[i].proportion_of_total > TEST_SG_TOTAL - total)
+			return false;
+		total += divs[i].proportion_of_total;
+		if (divs[i].flush_type != FLUSH_TYPE_NONE)
+			*any_flushes_ret = true;
+	}
+	return total == TEST_SG_TOTAL &&
+		memchr_inv(&divs[i], 0, (count - i) * sizeof(divs[0])) == NULL;
+}
+
+/*
+ * Check whether the given testvec_config is valid.  This isn't strictly needed
+ * since every testvec_config should be valid, but check anyway so that people
+ * don't unknowingly add broken configs that don't do what they wanted.
+ */
+static bool valid_testvec_config(const struct testvec_config *cfg)
+{
+	bool any_flushes = false;
+
+	if (cfg->name == NULL)
+		return false;
+
+	if (!valid_sg_divisions(cfg->src_divs, ARRAY_SIZE(cfg->src_divs),
+				&any_flushes))
+		return false;
+
+	if (cfg->dst_divs[0].proportion_of_total) {
+		if (!valid_sg_divisions(cfg->dst_divs,
+					ARRAY_SIZE(cfg->dst_divs),
+					&any_flushes))
+			return false;
+	} else {
+		if (memchr_inv(cfg->dst_divs, 0, sizeof(cfg->dst_divs)))
+			return false;
+		/* defaults to dst_divs=src_divs */
+	}
+
+	if (cfg->iv_offset +
+	    (cfg->iv_offset_relative_to_alignmask ? MAX_ALGAPI_ALIGNMASK : 0) >
+	    MAX_ALGAPI_ALIGNMASK + 1)
+		return false;
+
+	if (any_flushes && cfg->finalization_type == FINALIZATION_TYPE_DIGEST)
+		return false;
+
+	return true;
+}
+
+struct test_sglist {
+	char *bufs[XBUFSIZE];
+	struct scatterlist sgl[XBUFSIZE];
+	struct scatterlist sgl_saved[XBUFSIZE];
+	struct scatterlist *sgl_ptr;
+	unsigned int nents;
+};
+
+static int init_test_sglist(struct test_sglist *tsgl)
+{
+	return __testmgr_alloc_buf(tsgl->bufs, 1 /* two pages per buffer */);
+}
+
+static void destroy_test_sglist(struct test_sglist *tsgl)
+{
+	return __testmgr_free_buf(tsgl->bufs, 1 /* two pages per buffer */);
+}
+
+/**
+ * build_test_sglist() - build a scatterlist for a crypto test
+ *
+ * @tsgl: the scatterlist to build.  @tsgl->bufs[] contains an array of 2-page
+ *	  buffers which the scatterlist @tsgl->sgl[] will be made to point into.
+ * @divs: the layout specification on which the scatterlist will be based
+ * @alignmask: the algorithm's alignmask
+ * @total_len: the total length of the scatterlist to build in bytes
+ * @data: if non-NULL, the buffers will be filled with this data until it ends.
+ *	  Otherwise the buffers will be poisoned.  In both cases, some bytes
+ *	  past the end of each buffer will be poisoned to help detect overruns.
+ * @out_divs: if non-NULL, the test_sg_division to which each scatterlist entry
+ *	      corresponds will be returned here.  This will match @divs except
+ *	      that divisions resolving to a length of 0 are omitted as they are
+ *	      not included in the scatterlist.
+ *
+ * Return: 0 or a -errno value
+ */
+static int build_test_sglist(struct test_sglist *tsgl,
+			     const struct test_sg_division *divs,
+			     const unsigned int alignmask,
+			     const unsigned int total_len,
+			     struct iov_iter *data,
+			     const struct test_sg_division *out_divs[XBUFSIZE])
+{
+	struct {
+		const struct test_sg_division *div;
+		size_t length;
+	} partitions[XBUFSIZE];
+	const unsigned int ndivs = count_test_sg_divisions(divs);
+	unsigned int len_remaining = total_len;
+	unsigned int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(partitions) != ARRAY_SIZE(tsgl->sgl));
+	if (WARN_ON(ndivs > ARRAY_SIZE(partitions)))
+		return -EINVAL;
+
+	/* Calculate the (div, length) pairs */
+	tsgl->nents = 0;
+	for (i = 0; i < ndivs; i++) {
+		unsigned int len_this_sg =
+			min(len_remaining,
+			    (total_len * divs[i].proportion_of_total +
+			     TEST_SG_TOTAL / 2) / TEST_SG_TOTAL);
+
+		if (len_this_sg != 0) {
+			partitions[tsgl->nents].div = &divs[i];
+			partitions[tsgl->nents].length = len_this_sg;
+			tsgl->nents++;
+			len_remaining -= len_this_sg;
+		}
+	}
+	if (tsgl->nents == 0) {
+		partitions[tsgl->nents].div = &divs[0];
+		partitions[tsgl->nents].length = 0;
+		tsgl->nents++;
+	}
+	partitions[tsgl->nents - 1].length += len_remaining;
+
+	/* Set up the sgl entries and fill the data or poison */
+	sg_init_table(tsgl->sgl, tsgl->nents);
+	for (i = 0; i < tsgl->nents; i++) {
+		unsigned int offset = partitions[i].div->offset;
+		void *addr;
+
+		if (partitions[i].div->offset_relative_to_alignmask)
+			offset += alignmask;
+
+		while (offset + partitions[i].length + TESTMGR_POISON_LEN >
+		       2 * PAGE_SIZE) {
+			if (WARN_ON(offset <= 0))
+				return -EINVAL;
+			offset /= 2;
+		}
+
+		addr = &tsgl->bufs[i][offset];
+		sg_set_buf(&tsgl->sgl[i], addr, partitions[i].length);
+
+		if (out_divs)
+			out_divs[i] = partitions[i].div;
+
+		if (data) {
+			size_t copy_len, copied;
+
+			copy_len = min(partitions[i].length, data->count);
+			copied = copy_from_iter(addr, copy_len, data);
+			if (WARN_ON(copied != copy_len))
+				return -EINVAL;
+			testmgr_poison(addr + copy_len, partitions[i].length +
+				       TESTMGR_POISON_LEN - copy_len);
+		} else {
+			testmgr_poison(addr, partitions[i].length +
+				       TESTMGR_POISON_LEN);
+		}
+	}
+
+	sg_mark_end(&tsgl->sgl[tsgl->nents - 1]);
+	tsgl->sgl_ptr = tsgl->sgl;
+	memcpy(tsgl->sgl_saved, tsgl->sgl, tsgl->nents * sizeof(tsgl->sgl[0]));
+	return 0;
+}
+
+/*
+ * Verify that a scatterlist crypto operation produced the correct output.
+ *
+ * @tsgl: scatterlist containing the actual output
+ * @expected_output: buffer containing the expected output
+ * @len_to_check: length of @expected_output in bytes
+ * @unchecked_prefix_len: number of ignored bytes in @tsgl prior to real result
+ * @check_poison: verify that the poison bytes after each chunk are intact?
+ *
+ * Return: 0 if correct, -EINVAL if incorrect, -EOVERFLOW if buffer overrun.
+ */
+static int verify_correct_output(const struct test_sglist *tsgl,
+				 const char *expected_output,
+				 unsigned int len_to_check,
+				 unsigned int unchecked_prefix_len,
+				 bool check_poison)
+{
+	unsigned int i;
+
+	for (i = 0; i < tsgl->nents; i++) {
+		struct scatterlist *sg = &tsgl->sgl_ptr[i];
+		unsigned int len = sg->length;
+		unsigned int offset = sg->offset;
+		const char *actual_output;
+
+		if (unchecked_prefix_len) {
+			if (unchecked_prefix_len >= len) {
+				unchecked_prefix_len -= len;
+				continue;
+			}
+			offset += unchecked_prefix_len;
+			len -= unchecked_prefix_len;
+			unchecked_prefix_len = 0;
+		}
+		len = min(len, len_to_check);
+		actual_output = page_address(sg_page(sg)) + offset;
+		if (memcmp(expected_output, actual_output, len) != 0)
+			return -EINVAL;
+		if (check_poison &&
+		    !testmgr_is_poison(actual_output + len, TESTMGR_POISON_LEN))
+			return -EOVERFLOW;
+		len_to_check -= len;
+		expected_output += len;
+	}
+	if (WARN_ON(len_to_check != 0))
+		return -EINVAL;
+	return 0;
+}
+
+static bool is_test_sglist_corrupted(const struct test_sglist *tsgl)
+{
+	unsigned int i;
+
+	for (i = 0; i < tsgl->nents; i++) {
+		if (tsgl->sgl[i].page_link != tsgl->sgl_saved[i].page_link)
+			return true;
+		if (tsgl->sgl[i].offset != tsgl->sgl_saved[i].offset)
+			return true;
+		if (tsgl->sgl[i].length != tsgl->sgl_saved[i].length)
+			return true;
+	}
+	return false;
+}
+
+struct cipher_test_sglists {
+	struct test_sglist src;
+	struct test_sglist dst;
+};
+
+static struct cipher_test_sglists *alloc_cipher_test_sglists(void)
+{
+	struct cipher_test_sglists *tsgls;
+
+	tsgls = kmalloc(sizeof(*tsgls), GFP_KERNEL);
+	if (!tsgls)
+		return NULL;
+
+	if (init_test_sglist(&tsgls->src) != 0)
+		goto fail_kfree;
+	if (init_test_sglist(&tsgls->dst) != 0)
+		goto fail_destroy_src;
+
+	return tsgls;
+
+fail_destroy_src:
+	destroy_test_sglist(&tsgls->src);
+fail_kfree:
+	kfree(tsgls);
+	return NULL;
+}
+
+static void free_cipher_test_sglists(struct cipher_test_sglists *tsgls)
+{
+	if (tsgls) {
+		destroy_test_sglist(&tsgls->src);
+		destroy_test_sglist(&tsgls->dst);
+		kfree(tsgls);
+	}
+}
+
+/* Build the src and dst scatterlists for an skcipher or AEAD test */
+static int build_cipher_test_sglists(struct cipher_test_sglists *tsgls,
+				     const struct testvec_config *cfg,
+				     unsigned int alignmask,
+				     unsigned int src_total_len,
+				     unsigned int dst_total_len,
+				     const struct kvec *inputs,
+				     unsigned int nr_inputs)
+{
+	struct iov_iter input;
+	int err;
+
+	iov_iter_kvec(&input, WRITE, inputs, nr_inputs, src_total_len);
+	err = build_test_sglist(&tsgls->src, cfg->src_divs, alignmask,
+				cfg->inplace ?
+					max(dst_total_len, src_total_len) :
+					src_total_len,
+				&input, NULL);
+	if (err)
+		return err;
+
+	if (cfg->inplace) {
+		tsgls->dst.sgl_ptr = tsgls->src.sgl;
+		tsgls->dst.nents = tsgls->src.nents;
+		return 0;
+	}
+	return build_test_sglist(&tsgls->dst,
+				 cfg->dst_divs[0].proportion_of_total ?
+					cfg->dst_divs : cfg->src_divs,
+				 alignmask, dst_total_len, NULL, NULL);
 }
 
 static int ahash_guard_result(char *result, char c, int size)
@@ -3650,18 +4070,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}
 };
 
-static bool alg_test_descs_checked;
-
-static void alg_test_descs_check_order(void)
+static void alg_check_test_descs_order(void)
 {
 	int i;
 
-	/* only check once */
-	if (alg_test_descs_checked)
-		return;
-
-	alg_test_descs_checked = true;
-
 	for (i = 1; i < ARRAY_SIZE(alg_test_descs); i++) {
 		int diff = strcmp(alg_test_descs[i - 1].alg,
 				  alg_test_descs[i].alg);
@@ -3679,6 +4091,16 @@ static void alg_test_descs_check_order(void)
 	}
 }
 
+static void alg_check_testvec_configs(void)
+{
+}
+
+static void testmgr_onetime_init(void)
+{
+	alg_check_test_descs_order();
+	alg_check_testvec_configs();
+}
+
 static int alg_find_test(const char *alg)
 {
 	int start = 0;
@@ -3715,7 +4137,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		return 0;
 	}
 
-	alg_test_descs_check_order();
+	DO_ONCE(testmgr_onetime_init);
 
 	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
 		char nalg[CRYPTO_MAX_ALG_NAME];
-- 
2.20.1.321.g9e740568ce-goog

