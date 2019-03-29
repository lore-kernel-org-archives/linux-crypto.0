Return-Path: <SRS0=TS5y=SA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D46C10F05
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Mar 2019 13:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FFE12075E
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Mar 2019 13:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfC2NKM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Mar 2019 09:10:12 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:55430 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729555AbfC2NKM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Mar 2019 09:10:12 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1h9rGq-0001sc-0Q; Fri, 29 Mar 2019 14:10:08 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/2] crypto: scompress: Use per-CPU struct instead multiple variables
Date:   Fri, 29 Mar 2019 14:09:56 +0100
Message-Id: <20190329130956.15935-2-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190329130956.15935-1-bigeasy@linutronix.de>
References: <20190329130956.15935-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Two per-CPU variables are allocated as pointer to per-CPU memory which
then are used as scratch buffers.
We could be smart about this and use instead a per-CPU struct which
contains the pointers already and then we need to allocate just the
scratch buffers.
Add a lock to the struct. By doing so we can avoid the get_cpu()
statement and gain lockdep coverage (if enabled) to ensure that the lock
is always acquired in the right context. On non-preemptible kernels the
lock vanishes.
It is okay to use raw_cpu_ptr() in order to get a pointer to the struct
since it is protected by the spinlock.

The diffstat of this is negative and according to size scompress.o:
   text    data     bss     dec     hex filename
   1847     160      24    2031     7ef dbg_before.o
   1754     232       4    1990     7c6 dbg_after.o
   1799      64      24    1887     75f no_dbg-before.o
   1703      88       4    1795     703 no_dbg-after.o

The overall size increase difference is also negative. The increase in
the data section is only four bytes without lockdep.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 crypto/scompress.c | 137 ++++++++++++++++++++-------------------------
 1 file changed, 60 insertions(+), 77 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index aea1a8e5d1954..da31f6fe1f833 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -29,9 +29,17 @@
 #include <crypto/internal/scompress.h>
 #include "internal.h"
 
+struct scomp_scratch {
+	spinlock_t	lock;
+	void		*src;
+	void		*dst;
+};
+
+static DEFINE_PER_CPU(struct scomp_scratch, scomp_scratch) = {
+	.lock = __SPIN_LOCK_UNLOCKED(scomp_scratch.lock),
+};
+
 static const struct crypto_type crypto_scomp_type;
-static void * __percpu *scomp_src_scratches;
-static void * __percpu *scomp_dst_scratches;
 static int scomp_scratch_users;
 static DEFINE_MUTEX(scomp_lock);
 
@@ -62,76 +70,53 @@ static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_puts(m, "type         : scomp\n");
 }
 
-static void crypto_scomp_free_scratches(void * __percpu *scratches)
+static void crypto_scomp_free_scratches(void)
 {
+	struct scomp_scratch *scratch;
 	int i;
 
-	if (!scratches)
-		return;
-
-	for_each_possible_cpu(i)
-		vfree(*per_cpu_ptr(scratches, i));
-
-	free_percpu(scratches);
-}
-
-static void * __percpu *crypto_scomp_alloc_scratches(void)
-{
-	void * __percpu *scratches;
-	int i;
-
-	scratches = alloc_percpu(void *);
-	if (!scratches)
-		return NULL;
-
 	for_each_possible_cpu(i) {
-		void *scratch;
+		scratch = raw_cpu_ptr(&scomp_scratch);
 
-		scratch = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
-		if (!scratch)
+		vfree(scratch->src);
+		vfree(scratch->dst);
+		scratch->src = NULL;
+		scratch->dst = NULL;
+	}
+}
+
+static int crypto_scomp_alloc_scratches(void)
+{
+	struct scomp_scratch *scratch;
+	int i;
+
+	for_each_possible_cpu(i) {
+		void *mem;
+
+		scratch = raw_cpu_ptr(&scomp_scratch);
+
+		mem = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
+		if (!mem)
 			goto error;
-		*per_cpu_ptr(scratches, i) = scratch;
-	}
-
-	return scratches;
-
-error:
-	crypto_scomp_free_scratches(scratches);
-	return NULL;
-}
-
-static void crypto_scomp_free_all_scratches(void)
-{
-	if (!--scomp_scratch_users) {
-		crypto_scomp_free_scratches(scomp_src_scratches);
-		crypto_scomp_free_scratches(scomp_dst_scratches);
-		scomp_src_scratches = NULL;
-		scomp_dst_scratches = NULL;
-	}
-}
-
-static int crypto_scomp_alloc_all_scratches(void)
-{
-	if (!scomp_scratch_users++) {
-		scomp_src_scratches = crypto_scomp_alloc_scratches();
-		if (!scomp_src_scratches)
-			return -ENOMEM;
-		scomp_dst_scratches = crypto_scomp_alloc_scratches();
-		if (!scomp_dst_scratches) {
-			crypto_scomp_free_scratches(scomp_src_scratches);
-			scomp_src_scratches = NULL;
-			return -ENOMEM;
-		}
+		scratch->src = mem;
+		mem = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
+		if (!mem)
+			goto error;
+		scratch->dst = mem;
 	}
 	return 0;
+error:
+	crypto_scomp_free_scratches();
+	return -ENOMEM;
 }
 
 static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 {
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&scomp_lock);
-	ret = crypto_scomp_alloc_all_scratches();
+	if (!scomp_scratch_users++)
+		ret = crypto_scomp_alloc_scratches();
 	mutex_unlock(&scomp_lock);
 
 	return ret;
@@ -143,31 +128,28 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	void **tfm_ctx = acomp_tfm_ctx(tfm);
 	struct crypto_scomp *scomp = *tfm_ctx;
 	void **ctx = acomp_request_ctx(req);
-	const int cpu = get_cpu();
-	u8 *scratch_src = *per_cpu_ptr(scomp_src_scratches, cpu);
-	u8 *scratch_dst = *per_cpu_ptr(scomp_dst_scratches, cpu);
+	struct scomp_scratch *scratch;
 	int ret;
 
-	if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE)
+		return -EINVAL;
 
-	if (req->dst && !req->dlen) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (req->dst && !req->dlen)
+		return -EINVAL;
 
 	if (!req->dlen || req->dlen > SCOMP_SCRATCH_SIZE)
 		req->dlen = SCOMP_SCRATCH_SIZE;
 
-	scatterwalk_map_and_copy(scratch_src, req->src, 0, req->slen, 0);
+	scratch = raw_cpu_ptr(&scomp_scratch);
+	spin_lock(&scratch->lock);
+
+	scatterwalk_map_and_copy(scratch->src, req->src, 0, req->slen, 0);
 	if (dir)
-		ret = crypto_scomp_compress(scomp, scratch_src, req->slen,
-					    scratch_dst, &req->dlen, *ctx);
+		ret = crypto_scomp_compress(scomp, scratch->src, req->slen,
+					    scratch->dst, &req->dlen, *ctx);
 	else
-		ret = crypto_scomp_decompress(scomp, scratch_src, req->slen,
-					      scratch_dst, &req->dlen, *ctx);
+		ret = crypto_scomp_decompress(scomp, scratch->src, req->slen,
+					      scratch->dst, &req->dlen, *ctx);
 	if (!ret) {
 		if (!req->dst) {
 			req->dst = sgl_alloc(req->dlen, GFP_ATOMIC, NULL);
@@ -176,11 +158,11 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 				goto out;
 			}
 		}
-		scatterwalk_map_and_copy(scratch_dst, req->dst, 0, req->dlen,
+		scatterwalk_map_and_copy(scratch->dst, req->dst, 0, req->dlen,
 					 1);
 	}
 out:
-	put_cpu();
+	spin_unlock(&scratch->lock);
 	return ret;
 }
 
@@ -201,7 +183,8 @@ static void crypto_exit_scomp_ops_async(struct crypto_tfm *tfm)
 	crypto_free_scomp(*ctx);
 
 	mutex_lock(&scomp_lock);
-	crypto_scomp_free_all_scratches();
+	if (!--scomp_scratch_users)
+		crypto_scomp_free_scratches();
 	mutex_unlock(&scomp_lock);
 }
 
-- 
2.20.1

