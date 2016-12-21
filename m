From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v3 2/3] drivers: crypto: Add the Virtual Function driver
 for CPT
Date: Wed, 21 Dec 2016 15:01:55 +0100
Message-ID: <20161221140155.GB21051@Red>
References: <1482321373-407-1-git-send-email-george.cherian@cavium.com>
 <1482321373-407-3-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        david.daney@cavium.com
To: george.cherian@cavium.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36568 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934632AbcLUOB7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2016 09:01:59 -0500
Content-Disposition: inline
In-Reply-To: <1482321373-407-3-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

I have some comment inline

On Wed, Dec 21, 2016 at 11:56:12AM +0000, george.cherian@cavium.com wrote:
> From: George Cherian <george.cherian@cavium.com>
> 
> Enable the CPT VF driver. CPT is the cryptographic Accelaration Unit

typo acceleration

[...]
> +static inline void update_input_data(struct cpt_request_info *req_info,
> +				     struct scatterlist *inp_sg,
> +				     u32 nbytes, u32 *argcnt)
> +{
> +	req_info->req.dlen += nbytes;
> +
> +	while (nbytes) {
> +		u32 len = min(nbytes, inp_sg->length);
> +		u8 *ptr = page_address(sg_page(inp_sg)) + inp_sg->offset;

You could use sg_virt instead.

But do you have tested your accelerator with user space data (via cryptodev/AF_ALG) ?
In my memory, you better use kmap() instead of this direct memory address.

[...]
> +static inline u32 cvm_enc_dec(struct ablkcipher_request *req, u32 enc,
> +			      u32 cipher_type)
> +{
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
> +	struct cvm_enc_ctx *ctx = crypto_ablkcipher_ctx(tfm);
> +	u32 key_type = AES_128_BIT;
> +	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
> +	u32 enc_iv_len = crypto_ablkcipher_ivsize(tfm);
> +	struct fc_context *fctx = &rctx->fctx;
> +	struct cpt_request_info *req_info = &rctx->cpt_req;
> +	void *cdev = NULL;
> +	u32 status = -1;

Doable but dangerous
Furthermore, cptvf_do_request return int so why use u32 ?

[...]
> +void cvm_enc_dec_exit(struct crypto_tfm *tfm)
> +{
> +	return;
> +}

So you could remove all reference to this function

[...]
> +static inline int cav_register_algs(void)
> +{
> +	int err = 0;
> +
> +	err = crypto_register_algs(algs, ARRAY_SIZE(algs));
> +	if (err) {
> +		pr_err("Error in aes module init %d\n", err);
> +		return -1;

This is not a standard error code

[...]
> diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.h b/drivers/crypto/cavium/cpt/cptvf_algs.h
> new file mode 100644
> index 0000000..fcb287b
> --- /dev/null
> +++ b/drivers/crypto/cavium/cpt/cptvf_algs.h
[...]
> +
> +u32 cptvf_do_request(void *cptvf, struct cpt_request_info *req);

latter this function is set "return int"

[...]
> +static int cptvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct cpt_vf *cptvf;
> +	int    err;
> +
> +	cptvf = devm_kzalloc(dev, sizeof(struct cpt_vf), GFP_KERNEL);

use sizeof(*cptvf) and checkpatch

[...]
> +static int setup_sgio_components(struct cpt_vf *cptvf, struct buf_ptr *list,
> +				 int buf_count, u8 *buffer)
> +{
> +	int ret = 0, i, j;
> +	int components;
> +	struct sglist_component *sg_ptr = NULL;
> +	struct pci_dev *pdev = cptvf->pdev;
> +
> +	if (unlikely(!list)) {
> +		pr_err("Input List pointer is NULL\n");
> +		ret = -EFAULT;
> +		return ret;

You could directly return -EFAULT and use dev_err()

> +	}
> +
> +	for (i = 0; i < buf_count; i++) {
> +		if (likely(list[i].vptr)) {
> +			list[i].dma_addr = dma_map_single(&pdev->dev,
> +							  list[i].vptr,
> +							  list[i].size,
> +							  DMA_BIDIRECTIONAL);
> +			if (unlikely(dma_mapping_error(&pdev->dev,
> +						       list[i].dma_addr))) {
> +				pr_err("DMA map kernel buffer failed for component: %d\n",
> +				       i);

Use dev_err

[...]
> +	u16 g_sz_bytes = 0, s_sz_bytes = 0;
> +	int ret = 0;
> +	struct pci_dev *pdev = cptvf->pdev;
> +
> +	if (req->incnt > MAX_SG_IN_CNT || req->outcnt > MAX_SG_OUT_CNT) {
> +		pr_err("Requestes SG components are higher than supported\n");

typo request and use dev_err

In all files you have some pr_x that could be better use as dev_x

> +		ret = -EINVAL;
> +		goto  scatter_gather_clean;
> +	}
> +
> +	/* Setup gather (input) components */
> +	g_sz_bytes = ((req->incnt + 3) / 4) * sizeof(struct sglist_component);
> +	info->gather_components = kzalloc((g_sz_bytes), GFP_KERNEL);

unnecessary parenthesis

> +	if (!info->gather_components) {
> +		ret = -ENOMEM;
> +		goto  scatter_gather_clean;
> +	}
> +
> +	ret = setup_sgio_components(cptvf, req->in,
> +				    req->incnt,
> +				    info->gather_components);
> +	if (ret) {
> +		pr_err("Failed to setup gather list\n");
> +		ret = -EFAULT;
> +		goto  scatter_gather_clean;
> +	}
> +
> +	/* Setup scatter (output) components */
> +	s_sz_bytes = ((req->outcnt + 3) / 4) * sizeof(struct sglist_component);
> +	info->scatter_components = kzalloc((s_sz_bytes), GFP_KERNEL);

again

> +	if (!info->scatter_components) {
> +		ret = -ENOMEM;
> +		goto  scatter_gather_clean;
> +	}
> +
> +	ret = setup_sgio_components(cptvf, req->out,
> +				    req->outcnt,
> +				    info->scatter_components);
> +	if (ret) {
> +		pr_err("Failed to setup gather list\n");
> +		ret = -EFAULT;
> +		goto  scatter_gather_clean;

double space

> +	}
> +
> +	/* Create and initialize DPTR */
> +	info->dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
> +	info->in_buffer = kzalloc((info->dlen), GFP_KERNEL);

double parenthesis
I will stop here, you have lots of that in all your alloc

[...]
> +
> +	ret = send_cpt_command(cptvf, &cptinst, queue);
> +	spin_unlock_bh(&pqueue->lock);
> +	if (unlikely(ret)) {
> +		spin_unlock_bh(&pqueue->lock);

Double unlock

[...]
> diff --git a/drivers/crypto/cavium/cpt/request_manager.h b/drivers/crypto/cavium/cpt/request_manager.h
> new file mode 100644
> index 0000000..df6c306
> --- /dev/null
> +++ b/drivers/crypto/cavium/cpt/request_manager.h
> @@ -0,0 +1,147 @@
> +/*
> + * Copyright (C) 2016 Cavium, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of version 2 of the GNU General Public License
> + * as published by the Free Software Foundation.
> + */
> +
> +#ifndef __REQUEST_MANGER_H
> +#define __REQUEST_MANGER_H

typo manager

Thanks
Regards
Corentin Labbe
