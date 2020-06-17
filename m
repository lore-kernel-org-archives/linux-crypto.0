Return-Path: <SRS0=o6su=76=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7498C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jun 2020 13:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A40CF208B8
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jun 2020 13:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MfYk6qLV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgFQNtK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jun 2020 09:49:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29795 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726329AbgFQNtH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jun 2020 09:49:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592401745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mb8DWjjIdCGqMZgKNw82x+Xb6kvEAuWr9+vg57D2LC8=;
        b=MfYk6qLVVNuCaSPTdiRmujGPh77Tm3PxXt9+dNTvq1EToHVdOtWCbw+Hs+FP8PyBGNKTX9
        tJ9YMEgALwjlQ1wyaVwiftubU0dNzaikbGjfjstngWxKfD9Q2FhQxbVkwDCTehKIdyaDVP
        EIRavsqCzjxMql38bsVWU6ADcq/Gz6I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-rQNXFxxfOReJVhZBL1sT2A-1; Wed, 17 Jun 2020 09:49:01 -0400
X-MC-Unique: rQNXFxxfOReJVhZBL1sT2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36D277A3A1;
        Wed, 17 Jun 2020 13:49:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AE3F5D9D3;
        Wed, 17 Jun 2020 13:48:57 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05HDmuxK022478;
        Wed, 17 Jun 2020 09:48:56 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05HDmu3g022474;
        Wed, 17 Jun 2020 09:48:56 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 17 Jun 2020 09:48:56 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Eric Biggers <ebiggers@kernel.org>,
        George Cherian <gcherian@marvell.com>,
        Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@huawei.com>
cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>
Subject: [PATCH 1/2] cpt-crypto: don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was
 not specified
In-Reply-To: <alpine.LRH.2.02.2006170940510.18714@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2006170946590.18714@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au> <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006161102250.28052@file01.intranet.prod.int.rdu2.redhat.com> <20200616175022.GD207319@gmail.com> <alpine.LRH.2.02.2006161416510.12390@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616182327.GE207319@gmail.com> <alpine.LRH.2.02.2006170940510.18714@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is this call chain:
cvm_encrypt -> cvm_enc_dec -> cptvf_do_request -> process_request -> kzalloc
where we call sleeping allocator function even if CRYPTO_TFM_REQ_MAY_SLEEP 
was not specified.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.11+
Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")

---
 drivers/crypto/cavium/cpt/cptvf_algs.c       |    1 +
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c |   12 ++++++------
 drivers/crypto/cavium/cpt/request_manager.h  |    2 ++
 3 files changed, 9 insertions(+), 6 deletions(-)

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
 

