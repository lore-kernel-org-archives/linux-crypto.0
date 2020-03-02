Return-Path: <SRS0=CDDf=4T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CB9C3F2D2
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 12:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E910C2173E
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 12:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCBMtM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 07:49:12 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2494 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727720AbgCBMtM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 07:49:12 -0500
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 92C41DE0A9D3B1C3B0BB;
        Mon,  2 Mar 2020 12:49:10 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml709-cah.china.huawei.com (10.201.108.32) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 2 Mar 2020 12:49:09 +0000
Received: from localhost (10.202.226.57) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 2 Mar 2020
 12:49:10 +0000
Date:   Mon, 2 Mar 2020 12:49:08 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Zaibo Xu <xuzaibo@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <qianweili@huawei.com>, <tanghui20@huawei.com>,
        <forest.zhouchang@huawei.com>, <linuxarm@huawei.com>,
        <zhangwei375@huawei.com>, <yekai13@huawei.com>,
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] crypto: hisilicon/sec2 - Add pbuffer mode for
 SEC driver
Message-ID: <20200302124908.00006345@Huawei.com>
In-Reply-To: <1583129716-28382-6-git-send-email-xuzaibo@huawei.com>
References: <1583129716-28382-1-git-send-email-xuzaibo@huawei.com>
        <1583129716-28382-6-git-send-email-xuzaibo@huawei.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.57]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2 Mar 2020 14:15:16 +0800
Zaibo Xu <xuzaibo@huawei.com> wrote:

> From: liulongfang <liulongfang@huawei.com>
> 
> In the scenario of SMMU translation, the SEC performance of short messages
> (<512Bytes) cannot meet our expectations. To avoid this, we reserve the
> plat buffer (PBUF) memory for small packets when creating TFM.
> 
> Signed-off-by: liulongfang <liulongfang@huawei.com>
> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>

Hmm. I guess we pay the price for this performance trick in memory usage.
Oh well, if it becomes a problem we can always look at more clever solutions.

Looks good to me.  Fix up liulongfang's sign off..

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/crypto/hisilicon/sec2/sec.h        |   4 +
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 173 ++++++++++++++++++++++++++++-
>  2 files changed, 172 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
> index e67b416..a73d82c 100644
> --- a/drivers/crypto/hisilicon/sec2/sec.h
> +++ b/drivers/crypto/hisilicon/sec2/sec.h
> @@ -11,6 +11,8 @@
>  
>  /* Algorithm resource per hardware SEC queue */
>  struct sec_alg_res {
> +	u8 *pbuf;
> +	dma_addr_t pbuf_dma;
>  	u8 *c_ivin;
>  	dma_addr_t c_ivin_dma;
>  	u8 *out_mac;
> @@ -50,6 +52,7 @@ struct sec_req {
>  
>  	/* Status of the SEC request */
>  	bool fake_busy;
> +	bool use_pbuf;
>  };
>  
>  /**
> @@ -130,6 +133,7 @@ struct sec_ctx {
>  	atomic_t dec_qcyclic;
>  
>  	enum sec_alg_type alg_type;
> +	bool pbuf_supported;
>  	struct sec_cipher_ctx c_ctx;
>  	struct sec_auth_ctx a_ctx;
>  };
> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> index 1eeaa74..3136ada 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> @@ -48,6 +48,19 @@
>  #define SEC_MAX_MAC_LEN		64
>  #define SEC_MAX_AAD_LEN		65535
>  #define SEC_TOTAL_MAC_SZ	(SEC_MAX_MAC_LEN * QM_Q_DEPTH)
> +
> +#define SEC_PBUF_SZ			512
> +#define SEC_PBUF_IV_OFFSET		SEC_PBUF_SZ
> +#define SEC_PBUF_MAC_OFFSET		(SEC_PBUF_SZ + SEC_IV_SIZE)
> +#define SEC_PBUF_PKG		(SEC_PBUF_SZ + SEC_IV_SIZE +	\
> +			SEC_MAX_MAC_LEN * 2)
> +#define SEC_PBUF_NUM		(PAGE_SIZE / SEC_PBUF_PKG)
> +#define SEC_PBUF_PAGE_NUM	(QM_Q_DEPTH / SEC_PBUF_NUM)
> +#define SEC_PBUF_LEFT_SZ	(SEC_PBUF_PKG * (QM_Q_DEPTH -	\
> +			SEC_PBUF_PAGE_NUM * SEC_PBUF_NUM))
> +#define SEC_TOTAL_PBUF_SZ	(PAGE_SIZE * SEC_PBUF_PAGE_NUM +	\
> +			SEC_PBUF_LEFT_SZ)
> +
>  #define SEC_SQE_LEN_RATE	4
>  #define SEC_SQE_CFLAG		2
>  #define SEC_SQE_AEAD_FLAG	3
> @@ -246,6 +259,50 @@ static void sec_free_mac_resource(struct device *dev, struct sec_alg_res *res)
>  				  res->out_mac, res->out_mac_dma);
>  }
>  
> +static void sec_free_pbuf_resource(struct device *dev, struct sec_alg_res *res)
> +{
> +	if (res->pbuf)
> +		dma_free_coherent(dev, SEC_TOTAL_PBUF_SZ,
> +				  res->pbuf, res->pbuf_dma);
> +}
> +
> +/*
> + * To improve performance, pbuffer is used for
> + * small packets (< 512Bytes) as IOMMU translation using.
> + */
> +static int sec_alloc_pbuf_resource(struct device *dev, struct sec_alg_res *res)
> +{
> +	int pbuf_page_offset;
> +	int i, j, k;
> +
> +	res->pbuf = dma_alloc_coherent(dev, SEC_TOTAL_PBUF_SZ,
> +				&res->pbuf_dma, GFP_KERNEL);
> +	if (!res->pbuf)
> +		return -ENOMEM;
> +
> +	/*
> +	 * SEC_PBUF_PKG contains data pbuf, iv and
> +	 * out_mac : <SEC_PBUF|SEC_IV|SEC_MAC>
> +	 * Every PAGE contains six SEC_PBUF_PKG
> +	 * The sec_qp_ctx contains QM_Q_DEPTH numbers of SEC_PBUF_PKG
> +	 * So we need SEC_PBUF_PAGE_NUM numbers of PAGE
> +	 * for the SEC_TOTAL_PBUF_SZ
> +	 */
> +	for (i = 0; i <= SEC_PBUF_PAGE_NUM; i++) {
> +		pbuf_page_offset = PAGE_SIZE * i;
> +		for (j = 0; j < SEC_PBUF_NUM; j++) {
> +			k = i * SEC_PBUF_NUM + j;
> +			if (k == QM_Q_DEPTH)
> +				break;
> +			res[k].pbuf = res->pbuf +
> +				j * SEC_PBUF_PKG + pbuf_page_offset;
> +			res[k].pbuf_dma = res->pbuf_dma +
> +				j * SEC_PBUF_PKG + pbuf_page_offset;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int sec_alg_resource_alloc(struct sec_ctx *ctx,
>  				  struct sec_qp_ctx *qp_ctx)
>  {
> @@ -262,6 +319,13 @@ static int sec_alg_resource_alloc(struct sec_ctx *ctx,
>  		if (ret)
>  			goto alloc_fail;
>  	}
> +	if (ctx->pbuf_supported) {
> +		ret = sec_alloc_pbuf_resource(dev, res);
> +		if (ret) {
> +			dev_err(dev, "fail to alloc pbuf dma resource!\n");
> +			goto alloc_fail;
> +		}
> +	}
>  
>  	return 0;
>  alloc_fail:
> @@ -279,6 +343,8 @@ static void sec_alg_resource_free(struct sec_ctx *ctx,
>  
>  	if (ctx->alg_type == SEC_AEAD)
>  		sec_free_mac_resource(dev, qp_ctx->res);
> +	if (ctx->pbuf_supported)
> +		sec_free_pbuf_resource(dev, qp_ctx->res);
Is the ordering right here?  Seems like this is allocated after the mac_resource
so should be freed before it.

I would prefer specific gotos for resource_alloc failure cases to make it clear
that different cleanup is needed if we fail allocating this from doing the
mac_resource allocation.


>  }
>  
>  static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
> @@ -369,6 +435,8 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
>  	ctx->sec = sec;
>  	ctx->hlf_q_num = sec->ctx_q_num >> 1;
>  
> +	ctx->pbuf_supported = ctx->sec->iommu_used;
> +
>  	/* Half of queue depth is taken as fake requests limit in the queue. */
>  	ctx->fake_req_limit = QM_Q_DEPTH >> 1;
>  	ctx->qp_ctx = kcalloc(sec->ctx_q_num, sizeof(struct sec_qp_ctx),
> @@ -591,6 +659,66 @@ GEN_SEC_SETKEY_FUNC(3des_cbc, SEC_CALG_3DES, SEC_CMODE_CBC)
>  GEN_SEC_SETKEY_FUNC(sm4_xts, SEC_CALG_SM4, SEC_CMODE_XTS)
>  GEN_SEC_SETKEY_FUNC(sm4_cbc, SEC_CALG_SM4, SEC_CMODE_CBC)
>  
> +static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
> +			struct scatterlist *src)
> +{
> +	struct aead_request *aead_req = req->aead_req.aead_req;
> +	struct sec_cipher_req *c_req = &req->c_req;
> +	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
> +	struct device *dev = SEC_CTX_DEV(ctx);
> +	int copy_size, pbuf_length;
> +	int req_id = req->req_id;
> +
> +	if (ctx->alg_type == SEC_AEAD)
> +		copy_size = aead_req->cryptlen + aead_req->assoclen;
> +	else
> +		copy_size = c_req->c_len;
> +
> +	pbuf_length = sg_copy_to_buffer(src, sg_nents(src),
> +				qp_ctx->res[req_id].pbuf,
> +				copy_size);
> +
> +	if (unlikely(pbuf_length != copy_size)) {
> +		dev_err(dev, "copy src data to pbuf error!\n");
> +		return -EINVAL;
> +	}
> +
> +	c_req->c_in_dma = qp_ctx->res[req_id].pbuf_dma;
> +
> +	if (!c_req->c_in_dma) {
> +		dev_err(dev, "fail to set pbuffer address!\n");
> +		return -ENOMEM;
> +	}
> +
> +	c_req->c_out_dma = c_req->c_in_dma;
> +
> +	return 0;
> +}
> +
> +static void sec_cipher_pbuf_unmap(struct sec_ctx *ctx, struct sec_req *req,
> +			struct scatterlist *dst)
> +{
> +	struct aead_request *aead_req = req->aead_req.aead_req;
> +	struct sec_cipher_req *c_req = &req->c_req;
> +	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
> +	struct device *dev = SEC_CTX_DEV(ctx);
> +	int copy_size, pbuf_length;
> +	int req_id = req->req_id;
> +
> +	if (ctx->alg_type == SEC_AEAD)
> +		copy_size = c_req->c_len + aead_req->assoclen;
> +	else
> +		copy_size = c_req->c_len;
> +
> +	pbuf_length = sg_copy_from_buffer(dst, sg_nents(dst),
> +				qp_ctx->res[req_id].pbuf,
> +				copy_size);
> +
> +	if (unlikely(pbuf_length != copy_size))
> +		dev_err(dev, "copy pbuf data to dst error!\n");
> +
> +}
> +
>  static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
>  			  struct scatterlist *src, struct scatterlist *dst)
>  {
> @@ -599,7 +727,20 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
>  	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
>  	struct sec_alg_res *res = &qp_ctx->res[req->req_id];
>  	struct device *dev = SEC_CTX_DEV(ctx);
> +	int ret;
> +
> +	if (req->use_pbuf) {
> +		ret = sec_cipher_pbuf_map(ctx, req, src);
> +		c_req->c_ivin = res->pbuf + SEC_PBUF_IV_OFFSET;
> +		c_req->c_ivin_dma = res->pbuf_dma + SEC_PBUF_IV_OFFSET;
> +		if (ctx->alg_type == SEC_AEAD) {
> +			a_req->out_mac = res->pbuf + SEC_PBUF_MAC_OFFSET;
> +			a_req->out_mac_dma = res->pbuf_dma +
> +					SEC_PBUF_MAC_OFFSET;
> +		}
>  
> +		return ret;
> +	}
>  	c_req->c_ivin = res->c_ivin;
>  	c_req->c_ivin_dma = res->c_ivin_dma;
>  	if (ctx->alg_type == SEC_AEAD) {
> @@ -642,10 +783,14 @@ static void sec_cipher_unmap(struct sec_ctx *ctx, struct sec_req *req,
>  	struct sec_cipher_req *c_req = &req->c_req;
>  	struct device *dev = SEC_CTX_DEV(ctx);
>  
> -	if (dst != src)
> -		hisi_acc_sg_buf_unmap(dev, src, c_req->c_in);
> +	if (req->use_pbuf) {
> +		sec_cipher_pbuf_unmap(ctx, req, dst);
> +	} else {
> +		if (dst != src)
> +			hisi_acc_sg_buf_unmap(dev, src, c_req->c_in);
>  
> -	hisi_acc_sg_buf_unmap(dev, dst, c_req->c_out);
> +		hisi_acc_sg_buf_unmap(dev, dst, c_req->c_out);
> +	}
>  }
>  
>  static int sec_skcipher_sgl_map(struct sec_ctx *ctx, struct sec_req *req)
> @@ -844,7 +989,10 @@ static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
>  		cipher = SEC_CIPHER_DEC << SEC_CIPHER_OFFSET;
>  	sec_sqe->type_cipher_auth = bd_type | cipher;
>  
> -	sa_type = SEC_SGL << SEC_SRC_SGL_OFFSET;
> +	if (req->use_pbuf)
> +		sa_type = SEC_PBUF << SEC_SRC_SGL_OFFSET;
> +	else
> +		sa_type = SEC_SGL << SEC_SRC_SGL_OFFSET;
>  	scene = SEC_COMM_SCENE << SEC_SCENE_OFFSET;
>  	if (c_req->c_in_dma != c_req->c_out_dma)
>  		de = 0x1 << SEC_DE_OFFSET;
> @@ -852,7 +1000,10 @@ static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
>  	sec_sqe->sds_sa_type = (de | scene | sa_type);
>  
>  	/* Just set DST address type */
> -	da_type = SEC_SGL << SEC_DST_SGL_OFFSET;
> +	if (req->use_pbuf)
> +		da_type = SEC_PBUF << SEC_DST_SGL_OFFSET;
> +	else
> +		da_type = SEC_SGL << SEC_DST_SGL_OFFSET;
>  	sec_sqe->sdm_addr_type |= da_type;
>  
>  	sec_sqe->type2.clen_ivhlen |= cpu_to_le32(c_req->c_len);
> @@ -1215,6 +1366,12 @@ static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
>  		return -EINVAL;
>  	}
>  	sreq->c_req.c_len = sk_req->cryptlen;
> +
> +	if (ctx->pbuf_supported && sk_req->cryptlen <= SEC_PBUF_SZ)
> +		sreq->use_pbuf = true;
> +	else
> +		sreq->use_pbuf = false;
> +
>  	if (c_alg == SEC_CALG_3DES) {
>  		if (unlikely(sk_req->cryptlen & (DES3_EDE_BLOCK_SIZE - 1))) {
>  			dev_err(dev, "skcipher 3des input length error!\n");
> @@ -1334,6 +1491,12 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
>  		return -EINVAL;
>  	}
>  
> +	if (ctx->pbuf_supported && (req->cryptlen + req->assoclen) <=
> +		SEC_PBUF_SZ)
> +		sreq->use_pbuf = true;
> +	else
> +		sreq->use_pbuf = false;
> +
>  	/* Support AES only */
>  	if (unlikely(c_alg != SEC_CALG_AES)) {
>  		dev_err(SEC_CTX_DEV(ctx), "aead crypto alg error!\n");


