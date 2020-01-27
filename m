Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CD7C2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63237214D8
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fViU+4Yp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgA0Q5O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 11:57:14 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37205 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgA0Q5N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 11:57:13 -0500
Received: by mail-pg1-f195.google.com with SMTP id q127so5450254pga.4;
        Mon, 27 Jan 2020 08:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BuwBYKNpueVIncHb9ydcafEJkLI7WjIcrz9xX3DsWoQ=;
        b=fViU+4YpPZEfoJ5+N1iYy72s5seMgdrdlWUbW7zVgoP7D1QcF7U/sjFKKWBOBbvI7T
         NQMJl4i7nO91lMxhkMs9ovmbr74+K9QdMSk6XWq4vh3m921T3TYN6SnDh7Dye3/YPi/c
         XYmB/ElG2oqFNhLl/cnUlSY8fR94g/iUwb3YaSg86qzThKpJ9zWa5oVqJe1ajs49aMFf
         czkQAlczWZ0zrnX2seyRBpHN8In9IuKcI3wTk14bhLySXAjgXgg4RGa72/tUn4A54S/z
         L1GT9p/paRuCnE7suPq6r5vMZJcyRm9scKSN9wiOx/L2a8ADg9wCIZPCUS4bSlkQ080b
         9BBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BuwBYKNpueVIncHb9ydcafEJkLI7WjIcrz9xX3DsWoQ=;
        b=XESmbBaxs/l4fqvntDJUtk5iakcnEwM9W0gs6oJ8v9/YQkkJpdnXy9ODcYRqBjavSg
         jSb9PSL4E8a3c0drDs5SYbk/nHRxvv3Xh2P2rSRBxBsAEBW/MfLb0vG02q9t7RqYDsyt
         FM0HV/k0Bihv2oGLFgE/NMEJ1QpuYtSZyB3aivRL4mVnmILRh555NBoeMQ/1w3tHJnFm
         huCnFkTuesgV42PhBALpejlvhWEp5QcFRcWdXVIua69le4KHEB2CKepbzRoHEXwZ32Yu
         BPTTs7RpV/Li94lRCfGGFTI8/cjw2GwoM10eLrd/YLbT49uKLIZXmjunpHxRrTlBQK5u
         0irA==
X-Gm-Message-State: APjAAAVclwg8esnJ9aIgulCFABaqxmcSAmXCHJSLkw/sXu5oAN44D/1Z
        zdkOcOC9mJZ6TSm5ICSU9Kx5Ejrf
X-Google-Smtp-Source: APXvYqwy7/W/bEEWRw0XGTxj0mGmOLuV5tXPS6puO0GFw1mmqQh0/Vl/WxzDBGGcFcVA5hLJ55HFdA==
X-Received: by 2002:a63:7949:: with SMTP id u70mr18192668pgc.233.1580144232228;
        Mon, 27 Jan 2020 08:57:12 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id u23sm16368642pfm.29.2020.01.27.08.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 08:57:11 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v7 5/9] crypto: caam - simplify RNG implementation
Date:   Mon, 27 Jan 2020 08:56:42 -0800
Message-Id: <20200127165646.19806-6-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200127165646.19806-1-andrew.smirnov@gmail.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rework CAAM RNG implementation as follows:

- Make use of the fact that HWRNG supports partial reads and will
handle such cases gracefully by removing recursion in caam_read()

- Convert blocking caam_read() codepath to do a single blocking job
read directly into requested buffer, bypassing any intermediary
buffers

- Convert async caam_read() codepath into a simple single
reader/single writer FIFO use-case, thus simplifying concurrency
handling and delegating buffer read/write position management to KFIFO
subsystem.

- Leverage the same low level RNG data extraction code for both async
and blocking caam_read() scenarios, get rid of the shared job
descriptor and make non-shared one as a simple as possible (just
HEADER + ALGORITHM OPERATION + FIFO STORE)

- Split private context from DMA related memory, so that the former
could be allocated without GFP_DMA.

NOTE: On its face value this commit decreased throughput numbers
reported by

  dd if=/dev/hwrng of=/dev/null bs=1 count=100K [iflag=nonblock]

by about 15%, however commits that enable prediction resistance and
limit JR total size impact the performance so much and move the
bottleneck such as to make this regression irrelevant.

NOTE: On the bright side, this commit reduces RNG in kernel DMA buffer
memory usage from 2 x RN_BUF_SIZE (~256K) to 32K.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/caamrng.c | 321 ++++++++++++----------------------
 1 file changed, 107 insertions(+), 214 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 47b15c25b66f..cb498186b9b9 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -7,35 +7,12 @@
  *
  * Based on caamalg.c crypto API driver.
  *
- * relationship between job descriptors to shared descriptors:
- *
- * ---------------                     --------------
- * | JobDesc #0  |-------------------->| ShareDesc  |
- * | *(buffer 0) |      |------------->| (generate) |
- * ---------------      |              | (move)     |
- *                      |              | (store)    |
- * ---------------      |              --------------
- * | JobDesc #1  |------|
- * | *(buffer 1) |
- * ---------------
- *
- * A job desc looks like this:
- *
- * ---------------------
- * | Header            |
- * | ShareDesc Pointer |
- * | SEQ_OUT_PTR       |
- * | (output buffer)   |
- * ---------------------
- *
- * The SharedDesc never changes, and each job descriptor points to one of two
- * buffers for each device, from which the data will be copied into the
- * requested destination
  */
 
 #include <linux/hw_random.h>
 #include <linux/completion.h>
 #include <linux/atomic.h>
+#include <linux/kfifo.h>
 
 #include "compat.h"
 
@@ -45,38 +22,34 @@
 #include "jr.h"
 #include "error.h"
 
+/* length of descriptors */
+#define CAAM_RNG_MAX_FIFO_STORE_SIZE	U16_MAX
+
+#define CAAM_RNG_FIFO_LEN		SZ_32K /* Must be a multiple of 2 */
+
 /*
- * Maximum buffer size: maximum number of random, cache-aligned bytes that
- * will be generated and moved to seq out ptr (extlen not allowed)
+ * See caam_init_desc()
  */
-#define RN_BUF_SIZE			(0xffff / L1_CACHE_BYTES * \
-					 L1_CACHE_BYTES)
+#define CAAM_RNG_DESC_LEN (CAAM_CMD_SZ +				\
+			   CAAM_CMD_SZ +				\
+			   CAAM_CMD_SZ + CAAM_PTR_SZ_MAX)
 
-/* length of descriptors */
-#define DESC_JOB_O_LEN			(CAAM_CMD_SZ * 2 + CAAM_PTR_SZ_MAX * 2)
-#define DESC_RNG_LEN			(3 * CAAM_CMD_SZ)
-
-/* Buffer, its dma address and lock */
-struct buf_data {
-	u8 buf[RN_BUF_SIZE] ____cacheline_aligned;
-	dma_addr_t addr;
-	struct completion filled;
-	u32 hw_desc[DESC_JOB_O_LEN];
-#define BUF_NOT_EMPTY 0
-#define BUF_EMPTY 1
-#define BUF_PENDING 2  /* Empty, but with job pending --don't submit another */
-	atomic_t empty;
+typedef u8 caam_rng_desc[CAAM_RNG_DESC_LEN];
+
+enum {
+	DESC_ASYNC,
+	DESC_SYNC,
+	DESC_NUM,
 };
 
 /* rng per-device context */
 struct caam_rng_ctx {
 	struct hwrng rng;
 	struct device *jrdev;
-	dma_addr_t sh_desc_dma;
-	u32 sh_desc[DESC_RNG_LEN];
-	unsigned int cur_buf_idx;
-	int current_buf;
-	struct buf_data bufs[2];
+	struct device *ctrldev;
+	caam_rng_desc *desc;
+	struct work_struct worker;
+	struct kfifo fifo;
 };
 
 static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
@@ -84,228 +57,146 @@ static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
 	return container_of(r, struct caam_rng_ctx, rng);
 }
 
-static inline void rng_unmap_buf(struct device *jrdev, struct buf_data *bd)
+static void caam_rng_done(struct device *jrdev, u32 *desc, u32 err,
+			  void *context)
 {
-	if (bd->addr)
-		dma_unmap_single(jrdev, bd->addr, RN_BUF_SIZE,
-				 DMA_FROM_DEVICE);
-}
-
-static inline void rng_unmap_ctx(struct caam_rng_ctx *ctx)
-{
-	struct device *jrdev = ctx->jrdev;
-
-	if (ctx->sh_desc_dma)
-		dma_unmap_single(jrdev, ctx->sh_desc_dma,
-				 desc_bytes(ctx->sh_desc), DMA_TO_DEVICE);
-	rng_unmap_buf(jrdev, &ctx->bufs[0]);
-	rng_unmap_buf(jrdev, &ctx->bufs[1]);
-}
-
-static void rng_done(struct device *jrdev, u32 *desc, u32 err, void *context)
-{
-	struct buf_data *bd;
-
-	bd = container_of(desc, struct buf_data, hw_desc[0]);
+	struct completion *done = context;
 
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
-	atomic_set(&bd->empty, BUF_NOT_EMPTY);
-	complete(&bd->filled);
-
-	/* Buffer refilled, invalidate cache */
-	dma_sync_single_for_cpu(jrdev, bd->addr, RN_BUF_SIZE, DMA_FROM_DEVICE);
-
-	print_hex_dump_debug("rng refreshed buf@: ", DUMP_PREFIX_ADDRESS, 16, 4,
-			     bd->buf, RN_BUF_SIZE, 1);
+	complete(done);
 }
 
-static inline int submit_job(struct caam_rng_ctx *ctx, int to_current)
+static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma, int len)
 {
-	struct buf_data *bd = &ctx->bufs[!(to_current ^ ctx->current_buf)];
-	struct device *jrdev = ctx->jrdev;
-	u32 *desc = bd->hw_desc;
-	int err;
+	init_job_desc(desc, 0);	/* + 1 cmd_sz */
+	/* Generate random bytes: + 1 cmd_sz */
+	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
+	/* Store bytes */
+	append_fifo_store(desc, dst_dma, len, FIFOST_TYPE_RNGSTORE);
 
-	dev_dbg(jrdev, "submitting job %d\n", !(to_current ^ ctx->current_buf));
-	init_completion(&bd->filled);
-	err = caam_jr_enqueue(jrdev, desc, rng_done, ctx);
-	if (err)
-		complete(&bd->filled); /* don't wait on failed job*/
-	else
-		atomic_inc(&bd->empty); /* note if pending */
+	print_hex_dump_debug("rng job desc@: ", DUMP_PREFIX_ADDRESS,
+			     16, 4, desc, desc_bytes(desc), 1);
 
-	return err;
+	return desc;
 }
 
-static int caam_read(struct hwrng *rng, void *data, size_t max, bool wait)
+static int caam_rng_read_one(struct device *jrdev,
+			     void *dst, int len,
+			     void *desc,
+			     struct completion *done)
 {
-	struct caam_rng_ctx *ctx = to_caam_rng_ctx(rng);
-	struct buf_data *bd = &ctx->bufs[ctx->current_buf];
-	int next_buf_idx, copied_idx;
+	dma_addr_t dst_dma;
 	int err;
 
-	if (atomic_read(&bd->empty)) {
-		/* try to submit job if there wasn't one */
-		if (atomic_read(&bd->empty) == BUF_EMPTY) {
-			err = submit_job(ctx, 1);
-			/* if can't submit job, can't even wait */
-			if (err)
-				return 0;
-		}
-		/* no immediate data, so exit if not waiting */
-		if (!wait)
-			return 0;
-
-		/* waiting for pending job */
-		if (atomic_read(&bd->empty))
-			wait_for_completion(&bd->filled);
-	}
-
-	next_buf_idx = ctx->cur_buf_idx + max;
-	dev_dbg(ctx->jrdev, "%s: start reading at buffer %d, idx %d\n",
-		 __func__, ctx->current_buf, ctx->cur_buf_idx);
+	len = min_t(int, len, CAAM_RNG_MAX_FIFO_STORE_SIZE);
 
-	/* if enough data in current buffer */
-	if (next_buf_idx < RN_BUF_SIZE) {
-		memcpy(data, bd->buf + ctx->cur_buf_idx, max);
-		ctx->cur_buf_idx = next_buf_idx;
-		return max;
+	dst_dma = dma_map_single(jrdev, dst, len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, dst_dma)) {
+		dev_err(jrdev, "unable to map destination memory\n");
+		return -ENOMEM;
 	}
 
-	/* else, copy what's left... */
-	copied_idx = RN_BUF_SIZE - ctx->cur_buf_idx;
-	memcpy(data, bd->buf + ctx->cur_buf_idx, copied_idx);
-	ctx->cur_buf_idx = 0;
-	atomic_set(&bd->empty, BUF_EMPTY);
-
-	/* ...refill... */
-	submit_job(ctx, 1);
+	init_completion(done);
+	err = caam_jr_enqueue(jrdev,
+			      caam_init_desc(desc, dst_dma, len),
+			      caam_rng_done, done);
+	if (!err)
+		wait_for_completion(done);
 
-	/* and use next buffer */
-	ctx->current_buf = !ctx->current_buf;
-	dev_dbg(ctx->jrdev, "switched to buffer %d\n", ctx->current_buf);
+	dma_unmap_single(jrdev, dst_dma, len, DMA_FROM_DEVICE);
 
-	/* since there already is some data read, don't wait */
-	return copied_idx + caam_read(rng, data + copied_idx,
-				      max - copied_idx, false);
+	return err ?: len;
 }
 
-static inline int rng_create_sh_desc(struct caam_rng_ctx *ctx)
+static void caam_rng_fill_async(struct caam_rng_ctx *ctx)
 {
-	struct device *jrdev = ctx->jrdev;
-	u32 *desc = ctx->sh_desc;
-
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
-
-	/* Generate random bytes */
-	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
-
-	/* Store bytes */
-	append_seq_fifo_store(desc, RN_BUF_SIZE, FIFOST_TYPE_RNGSTORE);
-
-	ctx->sh_desc_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
-					  DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->sh_desc_dma)) {
-		dev_err(jrdev, "unable to map shared descriptor\n");
-		return -ENOMEM;
-	}
-
-	print_hex_dump_debug("rng shdesc@: ", DUMP_PREFIX_ADDRESS, 16, 4,
-			     desc, desc_bytes(desc), 1);
+	struct scatterlist sg[1];
+	struct completion done;
+	int len, nents;
+
+	sg_init_table(sg, ARRAY_SIZE(sg));
+	nents = kfifo_dma_in_prepare(&ctx->fifo, sg, ARRAY_SIZE(sg),
+				     CAAM_RNG_FIFO_LEN);
+	if (!nents)
+		return;
+
+	len = caam_rng_read_one(ctx->jrdev, sg_virt(&sg[0]),
+				sg[0].length,
+				&ctx->desc[DESC_ASYNC],
+				&done);
+	if (len < 0)
+		return;
+
+	kfifo_dma_in_finish(&ctx->fifo, len);
+}
 
-	return 0;
+static void caam_rng_worker(struct work_struct *work)
+{
+	struct caam_rng_ctx *ctx = container_of(work, struct caam_rng_ctx,
+						worker);
+	caam_rng_fill_async(ctx);
 }
 
-static inline int rng_create_job_desc(struct caam_rng_ctx *ctx, int buf_id)
+static int caam_read(struct hwrng *rng, void *dst, size_t max, bool wait)
 {
-	struct device *jrdev = ctx->jrdev;
-	struct buf_data *bd = &ctx->bufs[buf_id];
-	u32 *desc = bd->hw_desc;
-	int sh_len = desc_len(ctx->sh_desc);
+	struct caam_rng_ctx *ctx = to_caam_rng_ctx(rng);
+	int out;
 
-	init_job_desc_shared(desc, ctx->sh_desc_dma, sh_len, HDR_SHARE_DEFER |
-			     HDR_REVERSE);
+	if (wait) {
+		struct completion done;
 
-	bd->addr = dma_map_single(jrdev, bd->buf, RN_BUF_SIZE, DMA_FROM_DEVICE);
-	if (dma_mapping_error(jrdev, bd->addr)) {
-		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
+		return caam_rng_read_one(ctx->jrdev, dst, max,
+					 ctx->desc[DESC_SYNC], &done);
 	}
 
-	append_seq_out_ptr_intlen(desc, bd->addr, RN_BUF_SIZE, 0);
-
-	print_hex_dump_debug("rng job desc@: ", DUMP_PREFIX_ADDRESS, 16, 4,
-			     desc, desc_bytes(desc), 1);
+	out = kfifo_out(&ctx->fifo, dst, max);
+	if (kfifo_len(&ctx->fifo) <= CAAM_RNG_FIFO_LEN / 2)
+		schedule_work(&ctx->worker);
 
-	return 0;
+	return out;
 }
 
 static void caam_cleanup(struct hwrng *rng)
 {
 	struct caam_rng_ctx *ctx = to_caam_rng_ctx(rng);
-	int i;
-	struct buf_data *bd;
-
-	for (i = 0; i < 2; i++) {
-		bd = &ctx->bufs[i];
-		if (atomic_read(&bd->empty) == BUF_PENDING)
-			wait_for_completion(&bd->filled);
-	}
 
-	rng_unmap_ctx(ctx);
+	flush_work(&ctx->worker);
 	caam_jr_free(ctx->jrdev);
+	kfifo_free(&ctx->fifo);
 }
 
-static int caam_init_buf(struct caam_rng_ctx *ctx, int buf_id)
+static int caam_init(struct hwrng *rng)
 {
-	struct buf_data *bd = &ctx->bufs[buf_id];
+	struct caam_rng_ctx *ctx = to_caam_rng_ctx(rng);
 	int err;
 
-	err = rng_create_job_desc(ctx, buf_id);
-	if (err)
-		return err;
-
-	atomic_set(&bd->empty, BUF_EMPTY);
-	submit_job(ctx, buf_id == ctx->current_buf);
-	wait_for_completion(&bd->filled);
+	ctx->desc = devm_kcalloc(ctx->ctrldev, DESC_NUM, sizeof(*ctx->desc),
+				 GFP_DMA | GFP_KERNEL);
+	if (!ctx->desc)
+		return -ENOMEM;
 
-	return 0;
-}
+	if (kfifo_alloc(&ctx->fifo, CAAM_RNG_FIFO_LEN, GFP_DMA | GFP_KERNEL))
+		return -ENOMEM;
 
-static int caam_init(struct hwrng *rng)
-{
-	struct caam_rng_ctx *ctx = to_caam_rng_ctx(rng);
-	int err;
+	INIT_WORK(&ctx->worker, caam_rng_worker);
 
 	ctx->jrdev = caam_jr_alloc();
 	err = PTR_ERR_OR_ZERO(ctx->jrdev);
 	if (err) {
+		kfifo_free(&ctx->fifo);
 		pr_err("Job Ring Device allocation for transform failed\n");
 		return err;
 	}
 
-	err = rng_create_sh_desc(ctx);
-	if (err)
-		goto free_jrdev;
-
-	ctx->current_buf = 0;
-	ctx->cur_buf_idx = 0;
-
-	err = caam_init_buf(ctx, 0);
-	if (err)
-		goto free_jrdev;
-
-	err = caam_init_buf(ctx, 1);
-	if (err)
-		goto free_jrdev;
+	/*
+	 * Fill async buffer to have early randomness data for
+	 * hw_random
+	 */
+	caam_rng_fill_async(ctx);
 
 	return 0;
-
-free_jrdev:
-	caam_jr_free(ctx->jrdev);
-	return err;
 }
 
 int caam_rng_init(struct device *ctrldev);
@@ -335,10 +226,12 @@ int caam_rng_init(struct device *ctrldev)
 	if (!devres_open_group(ctrldev, caam_rng_init, GFP_KERNEL))
 		return -ENOMEM;
 
-	ctx = devm_kzalloc(ctrldev, sizeof(*ctx), GFP_DMA | GFP_KERNEL);
+	ctx = devm_kzalloc(ctrldev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
+	ctx->ctrldev = ctrldev;
+
 	ctx->rng.name    = "rng-caam";
 	ctx->rng.init    = caam_init;
 	ctx->rng.cleanup = caam_cleanup;
-- 
2.21.0

