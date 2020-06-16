Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4712C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 15:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B22A20786
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 15:03:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qw8l/lAL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgFPPDA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 11:03:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31572 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729296AbgFPPDA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 11:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592319777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p7C9c1VwggJYHdShsnncXpmmJ8HXgLM0SoSM+1mUSHY=;
        b=Qw8l/lALvYMZLzOm5OUC6Uhq68CsB83NNLHKTltGknp7XTMbCi0A394pazwXcI4qg49THH
        ES0hrZO2puttIebfwOkIvfzDEIQ6VhPreCGTm72Y36YRw41chLQpewf6B9ItKyHe4zvvUG
        Yc1SfvhrDUTFcSoXVosW3U1k1ULE+8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-WLXxvyOdOA2biyo2-469RA-1; Tue, 16 Jun 2020 11:02:55 -0400
X-MC-Unique: WLXxvyOdOA2biyo2-469RA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47E3D134C2;
        Tue, 16 Jun 2020 15:02:54 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7424219C71;
        Tue, 16 Jun 2020 15:02:51 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05GF2oB6028957;
        Tue, 16 Jun 2020 11:02:50 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05GF2oph028953;
        Tue, 16 Jun 2020 11:02:50 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 16 Jun 2020 11:02:50 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] crypto: fix the drivers that don't respect
 CRYPTO_TFM_REQ_MAY_SLEEP
In-Reply-To: <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2006161102250.28052@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au> <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix the crypto drivers that don't respect CRYPTO_TFM_REQ_MAY_SLEEP. If
CRYPTO_TFM_REQ_MAY_SLEEP is not set, the driver must not do allocation
that sleeps.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c  |    5 ++-
 drivers/crypto/cavium/cpt/cptvf_algs.c       |    1 
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c |   12 ++++-----
 drivers/crypto/cavium/cpt/request_manager.h  |    2 +
 drivers/crypto/hisilicon/sec/sec_algs.c      |   34 ++++++++++++++-------------
 drivers/crypto/virtio/virtio_crypto_algs.c   |    4 +--
 drivers/crypto/xilinx/zynqmp-aes-gcm.c       |    4 +--
 7 files changed, 34 insertions(+), 28 deletions(-)

Index: linux-2.6/drivers/crypto/virtio/virtio_crypto_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/virtio/virtio_crypto_algs.c
+++ linux-2.6/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -364,12 +364,12 @@ __virtio_crypto_skcipher_do_req(struct v
 
 	/* Why 3?  outhdr + iv + inhdr */
 	sg_total = src_nents + dst_nents + 3;
-	sgs = kcalloc_node(sg_total, sizeof(*sgs), GFP_KERNEL,
+	sgs = kcalloc_node(sg_total, sizeof(*sgs), req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC,
 				dev_to_node(&vcrypto->vdev->dev));
 	if (!sgs)
 		return -ENOMEM;
 
-	req_data = kzalloc_node(sizeof(*req_data), GFP_KERNEL,
+	req_data = kzalloc_node(sizeof(*req_data), req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC,
 				dev_to_node(&vcrypto->vdev->dev));
 	if (!req_data) {
 		kfree(sgs);
Index: linux-2.6/drivers/crypto/cavium/cpt/cptvf_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ linux-2.6/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -200,6 +200,7 @@ static inline int cvm_enc_dec(struct skc
 	int status;
 
 	memset(req_info, 0, sizeof(struct cpt_request_info));
+	req_info->may_sleep = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) != 0;
 	memset(fctx, 0, sizeof(struct fc_context));
 	create_input_list(req, enc, enc_iv_len);
 	create_output_list(req, enc_iv_len);
Index: linux-2.6/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
===================================================================
--- linux-2.6.orig/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ linux-2.6/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -133,7 +133,7 @@ static inline int setup_sgio_list(struct
 
 	/* Setup gather (input) components */
 	g_sz_bytes = ((req->incnt + 3) / 4) * sizeof(struct sglist_component);
-	info->gather_components = kzalloc(g_sz_bytes, GFP_KERNEL);
+	info->gather_components = kzalloc(g_sz_bytes, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->gather_components) {
 		ret = -ENOMEM;
 		goto  scatter_gather_clean;
@@ -150,7 +150,7 @@ static inline int setup_sgio_list(struct
 
 	/* Setup scatter (output) components */
 	s_sz_bytes = ((req->outcnt + 3) / 4) * sizeof(struct sglist_component);
-	info->scatter_components = kzalloc(s_sz_bytes, GFP_KERNEL);
+	info->scatter_components = kzalloc(s_sz_bytes, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->scatter_components) {
 		ret = -ENOMEM;
 		goto  scatter_gather_clean;
@@ -167,7 +167,7 @@ static inline int setup_sgio_list(struct
 
 	/* Create and initialize DPTR */
 	info->dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
-	info->in_buffer = kzalloc(info->dlen, GFP_KERNEL);
+	info->in_buffer = kzalloc(info->dlen, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->in_buffer) {
 		ret = -ENOMEM;
 		goto  scatter_gather_clean;
@@ -195,7 +195,7 @@ static inline int setup_sgio_list(struct
 	}
 
 	/* Create and initialize RPTR */
-	info->out_buffer = kzalloc(COMPLETION_CODE_SIZE, GFP_KERNEL);
+	info->out_buffer = kzalloc(COMPLETION_CODE_SIZE, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->out_buffer) {
 		ret = -ENOMEM;
 		goto scatter_gather_clean;
@@ -421,7 +421,7 @@ int process_request(struct cpt_vf *cptvf
 	struct cpt_vq_command vq_cmd;
 	union cpt_inst_s cptinst;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc(sizeof(*info), req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (unlikely(!info)) {
 		dev_err(&pdev->dev, "Unable to allocate memory for info_buffer\n");
 		return -ENOMEM;
@@ -443,7 +443,7 @@ int process_request(struct cpt_vf *cptvf
 	 * Get buffer for union cpt_res_s response
 	 * structure and its physical address
 	 */
-	info->completion_addr = kzalloc(sizeof(union cpt_res_s), GFP_KERNEL);
+	info->completion_addr = kzalloc(sizeof(union cpt_res_s), req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (unlikely(!info->completion_addr)) {
 		dev_err(&pdev->dev, "Unable to allocate memory for completion_addr\n");
 		ret = -ENOMEM;
Index: linux-2.6/drivers/crypto/cavium/cpt/request_manager.h
===================================================================
--- linux-2.6.orig/drivers/crypto/cavium/cpt/request_manager.h
+++ linux-2.6/drivers/crypto/cavium/cpt/request_manager.h
@@ -62,6 +62,8 @@ struct cpt_request_info {
 	union ctrl_info ctrl; /* User control information */
 	struct cptvf_request req; /* Request Information (Core specific) */
 
+	bool may_sleep;
+
 	struct buf_ptr in[MAX_BUF_CNT];
 	struct buf_ptr out[MAX_BUF_CNT];
 
Index: linux-2.6/drivers/crypto/hisilicon/sec/sec_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/hisilicon/sec/sec_algs.c
+++ linux-2.6/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -175,7 +175,8 @@ static int sec_alloc_and_fill_hw_sgl(str
 				     dma_addr_t *psec_sgl,
 				     struct scatterlist *sgl,
 				     int count,
-				     struct sec_dev_info *info)
+				     struct sec_dev_info *info,
+				     gfp_t gfp)
 {
 	struct sec_hw_sgl *sgl_current = NULL;
 	struct sec_hw_sgl *sgl_next;
@@ -190,7 +191,7 @@ static int sec_alloc_and_fill_hw_sgl(str
 		sge_index = i % SEC_MAX_SGE_NUM;
 		if (sge_index == 0) {
 			sgl_next = dma_pool_zalloc(info->hw_sgl_pool,
-						   GFP_KERNEL, &sgl_next_dma);
+						   gfp, &sgl_next_dma);
 			if (!sgl_next) {
 				ret = -ENOMEM;
 				goto err_free_hw_sgls;
@@ -545,14 +546,14 @@ void sec_alg_callback(struct sec_bd_info
 }
 
 static int sec_alg_alloc_and_calc_split_sizes(int length, size_t **split_sizes,
-					      int *steps)
+					      int *steps, gfp_t gfp)
 {
 	size_t *sizes;
 	int i;
 
 	/* Split into suitable sized blocks */
 	*steps = roundup(length, SEC_REQ_LIMIT) / SEC_REQ_LIMIT;
-	sizes = kcalloc(*steps, sizeof(*sizes), GFP_KERNEL);
+	sizes = kcalloc(*steps, sizeof(*sizes), gfp);
 	if (!sizes)
 		return -ENOMEM;
 
@@ -568,7 +569,7 @@ static int sec_map_and_split_sg(struct s
 				int steps, struct scatterlist ***splits,
 				int **splits_nents,
 				int sgl_len_in,
-				struct device *dev)
+				struct device *dev, gfp_t gfp)
 {
 	int ret, count;
 
@@ -576,12 +577,12 @@ static int sec_map_and_split_sg(struct s
 	if (!count)
 		return -EINVAL;
 
-	*splits = kcalloc(steps, sizeof(struct scatterlist *), GFP_KERNEL);
+	*splits = kcalloc(steps, sizeof(struct scatterlist *), gfp);
 	if (!*splits) {
 		ret = -ENOMEM;
 		goto err_unmap_sg;
 	}
-	*splits_nents = kcalloc(steps, sizeof(int), GFP_KERNEL);
+	*splits_nents = kcalloc(steps, sizeof(int), gfp);
 	if (!*splits_nents) {
 		ret = -ENOMEM;
 		goto err_free_splits;
@@ -589,7 +590,7 @@ static int sec_map_and_split_sg(struct s
 
 	/* output the scatter list before and after this */
 	ret = sg_split(sgl, count, 0, steps, split_sizes,
-		       *splits, *splits_nents, GFP_KERNEL);
+		       *splits, *splits_nents, gfp);
 	if (ret) {
 		ret = -ENOMEM;
 		goto err_free_splits_nents;
@@ -630,13 +631,13 @@ static struct sec_request_el
 			   int el_size, bool different_dest,
 			   struct scatterlist *sgl_in, int n_ents_in,
 			   struct scatterlist *sgl_out, int n_ents_out,
-			   struct sec_dev_info *info)
+			   struct sec_dev_info *info, gfp_t gfp)
 {
 	struct sec_request_el *el;
 	struct sec_bd_info *req;
 	int ret;
 
-	el = kzalloc(sizeof(*el), GFP_KERNEL);
+	el = kzalloc(sizeof(*el), gfp);
 	if (!el)
 		return ERR_PTR(-ENOMEM);
 	el->el_length = el_size;
@@ -668,7 +669,7 @@ static struct sec_request_el
 	el->sgl_in = sgl_in;
 
 	ret = sec_alloc_and_fill_hw_sgl(&el->in, &el->dma_in, el->sgl_in,
-					n_ents_in, info);
+					n_ents_in, info, gfp);
 	if (ret)
 		goto err_free_el;
 
@@ -679,7 +680,7 @@ static struct sec_request_el
 		el->sgl_out = sgl_out;
 		ret = sec_alloc_and_fill_hw_sgl(&el->out, &el->dma_out,
 						el->sgl_out,
-						n_ents_out, info);
+						n_ents_out, info, gfp);
 		if (ret)
 			goto err_free_hw_sgl_in;
 
@@ -720,6 +721,7 @@ static int sec_alg_skcipher_crypto(struc
 	int *splits_out_nents = NULL;
 	struct sec_request_el *el, *temp;
 	bool split = skreq->src != skreq->dst;
+	gfp_t gfp = skreq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 
 	mutex_init(&sec_req->lock);
 	sec_req->req_base = &skreq->base;
@@ -728,13 +730,13 @@ static int sec_alg_skcipher_crypto(struc
 	sec_req->len_in = sg_nents(skreq->src);
 
 	ret = sec_alg_alloc_and_calc_split_sizes(skreq->cryptlen, &split_sizes,
-						 &steps);
+						 &steps, gfp);
 	if (ret)
 		return ret;
 	sec_req->num_elements = steps;
 	ret = sec_map_and_split_sg(skreq->src, split_sizes, steps, &splits_in,
 				   &splits_in_nents, sec_req->len_in,
-				   info->dev);
+				   info->dev, gfp);
 	if (ret)
 		goto err_free_split_sizes;
 
@@ -742,7 +744,7 @@ static int sec_alg_skcipher_crypto(struc
 		sec_req->len_out = sg_nents(skreq->dst);
 		ret = sec_map_and_split_sg(skreq->dst, split_sizes, steps,
 					   &splits_out, &splits_out_nents,
-					   sec_req->len_out, info->dev);
+					   sec_req->len_out, info->dev, gfp);
 		if (ret)
 			goto err_unmap_in_sg;
 	}
@@ -775,7 +777,7 @@ static int sec_alg_skcipher_crypto(struc
 					       splits_in[i], splits_in_nents[i],
 					       split ? splits_out[i] : NULL,
 					       split ? splits_out_nents[i] : 0,
-					       info);
+					       info, gfp);
 		if (IS_ERR(el)) {
 			ret = PTR_ERR(el);
 			goto err_free_elements;
Index: linux-2.6/drivers/crypto/xilinx/zynqmp-aes-gcm.c
===================================================================
--- linux-2.6.orig/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ linux-2.6/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -101,12 +101,12 @@ static int zynqmp_aes_aead_cipher(struct
 	else
 		dma_size = req->cryptlen + GCM_AES_IV_SIZE;
 
-	kbuf = dma_alloc_coherent(dev, dma_size, &dma_addr_data, GFP_KERNEL);
+	kbuf = dma_alloc_coherent(dev, dma_size, &dma_addr_data, req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC);
 	if (!kbuf)
 		return -ENOMEM;
 
 	hwreq = dma_alloc_coherent(dev, sizeof(struct zynqmp_aead_hw_req),
-				   &dma_addr_hw_req, GFP_KERNEL);
+				   &dma_addr_hw_req, req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC);
 	if (!hwreq) {
 		dma_free_coherent(dev, dma_size, kbuf, dma_addr_data);
 		return -ENOMEM;
Index: linux-2.6/drivers/crypto/amlogic/amlogic-gxl-cipher.c
===================================================================
--- linux-2.6.orig/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ linux-2.6/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -102,6 +102,7 @@ static int meson_cipher(struct skcipher_
 	dma_addr_t phykeyiv;
 	void *backup_iv = NULL, *bkeyiv;
 	__le32 v;
+	gfp_t gfp = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 
 	algt = container_of(alg, struct meson_alg_template, alg.skcipher);
 
@@ -121,7 +122,7 @@ static int meson_cipher(struct skcipher_
 	 * The 2 first structures store key
 	 * The third stores IV
 	 */
-	bkeyiv = kzalloc(48, GFP_KERNEL | GFP_DMA);
+	bkeyiv = kzalloc(48, gfp | GFP_DMA);
 	if (!bkeyiv)
 		return -ENOMEM;
 
@@ -138,7 +139,7 @@ static int meson_cipher(struct skcipher_
 		memcpy(bkeyiv + 32, areq->iv, ivsize);
 		keyivlen = 48;
 		if (rctx->op_dir == MESON_DECRYPT) {
-			backup_iv = kzalloc(ivsize, GFP_KERNEL);
+			backup_iv = kzalloc(ivsize, gfp);
 			if (!backup_iv) {
 				err = -ENOMEM;
 				goto theend;

