Return-Path: <SRS0=ER22=4N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0107FC35DEE
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 03:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAFA824650
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 03:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgBYDRC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 22:17:02 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10684 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728011AbgBYDRC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 22:17:02 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AC60EB6CA20C21515787;
        Tue, 25 Feb 2020 11:16:59 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Feb 2020
 11:16:52 +0800
Subject: Re: [PATCH 4/4] crypto: hisilicon/sec2 - Add pbuffer mode for SEC
 driver
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
References: <1582189495-38051-1-git-send-email-xuzaibo@huawei.com>
 <1582189495-38051-5-git-send-email-xuzaibo@huawei.com>
 <20200224140154.00005967@Huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <qianweili@huawei.com>, <tanghui20@huawei.com>,
        <forest.zhouchang@huawei.com>, <linuxarm@huawei.com>,
        <zhangwei375@huawei.com>, <shenyang39@huawei.com>,
        <yekai13@huawei.com>, <linux-crypto@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <80ab5da7-eceb-920e-dc36-1d411ad57a09@huawei.com>
Date:   Tue, 25 Feb 2020 11:16:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200224140154.00005967@Huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,


On 2020/2/24 22:01, Jonathan Cameron wrote:
> On Thu, 20 Feb 2020 17:04:55 +0800
> Zaibo Xu <xuzaibo@huawei.com> wrote:
>
>> From: liulongfang <liulongfang@huawei.com>
>>
>> In the scenario of SMMU translation, the SEC performance of short messages
>> (<512Bytes) cannot meet our expectations. To avoid this, we reserve the
>> plat buffer (PBUF) memory for small packets when creating TFM.
>>
>> Signed-off-by: liulongfang <liulongfang@huawei.com>
>> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
> Hi liulongfang,
>
> This patch might have been easier to review done in two parts.
> First part would do the refactor to place c_ivin etc in the sec_alg_res.
> That should be really simple to review.  Second part then adds the
> pbuf alternative to existing code.
Okay, we will split it.
> I'm not sure putting the boolean saying if we are using pbuf or not in
> the context makes sense.  Seems liable to introduce race conditions.
> Should that not be tied to the request?
I think it makes no sense, we will update here.
>
> Thanks,
>
> Jonathan
>
>> ---
>>   drivers/crypto/hisilicon/sec2/sec.h        |   6 +
>>   drivers/crypto/hisilicon/sec2/sec_crypto.c | 244 ++++++++++++++++++++++++-----
>>   2 files changed, 213 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
>> index eab0d22..8e2e34b 100644
>> --- a/drivers/crypto/hisilicon/sec2/sec.h
>> +++ b/drivers/crypto/hisilicon/sec2/sec.h
>> @@ -11,6 +11,8 @@
>>   
>>   /* Algorithm resource per hardware SEC queue */
>>   struct sec_alg_res {
>> +	u8 *pbuf;
>> +	dma_addr_t pbuf_dma;
>>   	u8 *c_ivin;
>>   	dma_addr_t c_ivin_dma;
>>   	u8 *out_mac;
>> @@ -23,6 +25,8 @@ struct sec_cipher_req {
>>   	dma_addr_t c_in_dma;
>>   	struct hisi_acc_hw_sgl *c_out;
>>   	dma_addr_t c_out_dma;
>> +	u8 *c_ivin;
>> +	dma_addr_t c_ivin_dma;
>>   	struct skcipher_request *sk_req;
>>   	u32 c_len;
>>   	bool encrypt;
>> @@ -128,6 +132,8 @@ struct sec_ctx {
>>   	atomic_t dec_qcyclic;
>>   
>>   	enum sec_alg_type alg_type;
>> +	bool pbuf_supported;
>> +	bool use_pbuf;
>>   	struct sec_cipher_ctx c_ctx;
>>   	struct sec_auth_ctx a_ctx;
>>   };
>> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> index a2cfcc9..022d4bf6 100644
>> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> @@ -46,7 +46,21 @@
>>   #define SEC_CIPHER_AUTH		0xfe
>>   #define SEC_AUTH_CIPHER		0x1
>>   #define SEC_MAX_MAC_LEN		64
>> +#define SEC_MAX_AAD_LEN		65535
>>   #define SEC_TOTAL_MAC_SZ	(SEC_MAX_MAC_LEN * QM_Q_DEPTH)
>> +
>> +#define SEC_PBUF_SZ			512
>> +#define SEC_PBUF_IV_OFFSET		SEC_PBUF_SZ
>> +#define SEC_PBUF_MAC_OFFSET		(SEC_PBUF_SZ + SEC_IV_SIZE)
>> +#define SEC_PBUF_PKG		(SEC_PBUF_SZ + SEC_IV_SIZE +	\
>> +			SEC_MAX_MAC_LEN * 2)
> 512 + 24 + 128
>
> So we get 6 per 4kiB page?
Yes, we tried to hold 6 per 4 KB page.
>
>> +#define SEC_PBUF_NUM		(PAGE_SIZE / SEC_PBUF_PKG)
>> +#define SEC_PBUF_PAGE_NUM	(QM_Q_DEPTH / SEC_PBUF_NUM)
>> +#define SEC_PBUF_LEFT_SZ	(SEC_PBUF_PKG * (QM_Q_DEPTH -	\
>> +			SEC_PBUF_PAGE_NUM * SEC_PBUF_NUM))
>> +#define SEC_TOTAL_PBUF_SZ	(PAGE_SIZE * SEC_PBUF_PAGE_NUM +	\
>> +			SEC_PBUF_LEFT_SZ)
>> +
>>   #define SEC_SQE_LEN_RATE	4
>>   #define SEC_SQE_CFLAG		2
>>   #define SEC_SQE_AEAD_FLAG	3
>> @@ -110,12 +124,12 @@ static void sec_free_req_id(struct sec_req *req)
>>   	mutex_unlock(&qp_ctx->req_lock);
>>   }
>>   
>> -static int sec_aead_verify(struct sec_req *req, struct sec_qp_ctx *qp_ctx)
>> +static int sec_aead_verify(struct sec_req *req)
>>   {
>>   	struct aead_request *aead_req = req->aead_req.aead_req;
>>   	struct crypto_aead *tfm = crypto_aead_reqtfm(aead_req);
>> -	u8 *mac_out = qp_ctx->res[req->req_id].out_mac;
>>   	size_t authsize = crypto_aead_authsize(tfm);
>> +	u8 *mac_out = req->aead_req.out_mac;
> This change looks unrelated to the rest of the patch.
> Good cleanup but not part of adding pbuffer as far as I can tell.
With Pbuf, 'aead_req' will hold the operational 'out_mac' address from 
'res'.
With only SGL buffer, the 'out_mac' of 'aead_req' is only from 'out_mac' 
of 'res'.
So, should update here.
>
>>   	u8 *mac = mac_out + SEC_MAX_MAC_LEN;
>>   	struct scatterlist *sgl = aead_req->src;
>>   	size_t sz;
>> @@ -163,7 +177,7 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
>>   	}
>>   
>>   	if (ctx->alg_type == SEC_AEAD && !req->c_req.encrypt)
>> -		err = sec_aead_verify(req, qp_ctx);
>> +		err = sec_aead_verify(req);
>>   
>>   	atomic64_inc(&ctx->sec->debug.dfx.recv_cnt);
>>   
>> @@ -245,6 +259,50 @@ static void sec_free_mac_resource(struct device *dev, struct sec_alg_res *res)
>>   				  res->out_mac, res->out_mac_dma);
>>   }
>>   
>> +static void sec_free_pbuf_resource(struct device *dev, struct sec_alg_res *res)
>> +{
>> +	if (res->pbuf)
>> +		dma_free_coherent(dev, SEC_TOTAL_PBUF_SZ,
>> +				  res->pbuf, res->pbuf_dma);
>> +}
>> +
>> +/*
>> + * To improve performance, pbuffer is used for
>> + * small packets (< 576Bytes) as IOMMU translation using.
>> + */
>> +static int sec_alloc_pbuf_resource(struct device *dev, struct sec_alg_res *res)
>> +{
>> +	int pbuf_page_offset;
>> +	int i, j, k;
>> +
>> +	res->pbuf = dma_alloc_coherent(dev, SEC_TOTAL_PBUF_SZ,
>> +				&res->pbuf_dma, GFP_KERNEL);
> Would it make more sense perhaps to do this as a DMA pool and have
> it expand on demand?
Since there exist all kinds of buffer length, I think dma_alloc_coherent 
may be better?
>
>> +	if (!res->pbuf)
>> +		return -ENOMEM;
>> +
>> +	/*
>> +	 * SEC_PBUF_PKG contains data pbuf, iv and
>> +	 * out_mac : <SEC_PBUF|SEC_IV|SEC_MAC>
>> +	 * Every PAGE contains six SEC_PBUF_PKG
>> +	 * The sec_qp_ctx contains QM_Q_DEPTH numbers of SEC_PBUF_PKG
>> +	 * So we need SEC_PBUF_PAGE_NUM numbers of PAGE
>> +	 * for the SEC_TOTAL_PBUF_SZ
>> +	 */
>> +	for (i = 0; i <= SEC_PBUF_PAGE_NUM; i++) {
>> +		pbuf_page_offset = PAGE_SIZE * i;
>> +		for (j = 0; j < SEC_PBUF_NUM; j++) {
>> +			k = i * SEC_PBUF_NUM + j;
>> +			if (k == QM_Q_DEPTH)
>> +				break;
>> +			res[k].pbuf = res->pbuf +
>> +				j * SEC_PBUF_PKG + pbuf_page_offset;
>> +			res[k].pbuf_dma = res->pbuf_dma +
>> +				j * SEC_PBUF_PKG + pbuf_page_offset;
>> +		}
>> +	}
>> +	return 0;
>> +}
>> +
>>   static int sec_alg_resource_alloc(struct sec_ctx *ctx,
>>   				  struct sec_qp_ctx *qp_ctx)
>>   {
>> @@ -259,11 +317,17 @@ static int sec_alg_resource_alloc(struct sec_ctx *ctx,
>>   	if (ctx->alg_type == SEC_AEAD) {
>>   		ret = sec_alloc_mac_resource(dev, res);
>>   		if (ret)
>> -			goto get_fail;
>> +			goto alloc_fail;
>> +	}
>> +	if (ctx->pbuf_supported) {
>> +		ret = sec_alloc_pbuf_resource(dev, res);
>> +		if (ret) {
>> +			dev_err(dev, "fail to alloc pbuf dma resource!\n");
>> +			goto alloc_fail;
>> +		}
>>   	}
>> -
>>   	return 0;
>> -get_fail:
>> +alloc_fail:
>>   	sec_free_civ_resource(dev, res);
>>   
>>   	return ret;
>> @@ -278,6 +342,8 @@ static void sec_alg_resource_free(struct sec_ctx *ctx,
>>   
>>   	if (ctx->alg_type == SEC_AEAD)
>>   		sec_free_mac_resource(dev, qp_ctx->res);
>> +	if (ctx->pbuf_supported)
>> +		sec_free_pbuf_resource(dev, qp_ctx->res);
>>   }
>>   
>>   static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
>> @@ -368,6 +434,12 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
>>   	ctx->sec = sec;
>>   	ctx->hlf_q_num = sec->ctx_q_num >> 1;
>>   
>> +	if (ctx->sec->iommu_used)
>> +		ctx->pbuf_supported = true;
>> +	else
>> +		ctx->pbuf_supported = false;
> ctx->pbuf_supported = ctx->sec->iommu_used;
yes, nice idea.
>
>> +	ctx->use_pbuf = false;
>> +
>>   	/* Half of queue depth is taken as fake requests limit in the queue. */
>>   	ctx->fake_req_limit = QM_Q_DEPTH >> 1;
>>   	ctx->qp_ctx = kcalloc(sec->ctx_q_num, sizeof(struct sec_qp_ctx),
>> @@ -447,7 +519,6 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
>>   	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
>>   	int ret;
>>   
>> -	ctx = crypto_skcipher_ctx(tfm);
>>   	ctx->alg_type = SEC_SKCIPHER;
>>   	crypto_skcipher_set_reqsize(tfm, sizeof(struct sec_req));
>>   	ctx->c_ctx.ivsize = crypto_skcipher_ivsize(tfm);
>> @@ -591,11 +662,94 @@ GEN_SEC_SETKEY_FUNC(3des_cbc, SEC_CALG_3DES, SEC_CMODE_CBC)
>>   GEN_SEC_SETKEY_FUNC(sm4_xts, SEC_CALG_SM4, SEC_CMODE_XTS)
>>   GEN_SEC_SETKEY_FUNC(sm4_cbc, SEC_CALG_SM4, SEC_CMODE_CBC)
>>   
>> -static int sec_cipher_map(struct device *dev, struct sec_req *req,
>> +static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
>> +			struct scatterlist *src)
>> +{
>> +	struct aead_request *aead_req = req->aead_req.aead_req;
>> +	struct sec_cipher_req *c_req = &req->c_req;
>> +	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
>> +	struct device *dev = SEC_CTX_DEV(ctx);
>> +	int copy_size, pbuf_length;
>> +	int req_id = req->req_id;
>> +
>> +	if (ctx->alg_type == SEC_AEAD)
>> +		copy_size = aead_req->cryptlen + aead_req->assoclen;
>> +	else
>> +		copy_size = c_req->c_len;
>> +
>> +	pbuf_length = sg_copy_to_buffer(src, sg_nents(src),
>> +				qp_ctx->res[req_id].pbuf,
>> +				copy_size);
>> +
>> +	if (unlikely(pbuf_length != copy_size)) {
>> +		dev_err(dev, "copy src data to pbuf error!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	c_req->c_in_dma = qp_ctx->res[req_id].pbuf_dma;
>> +
>> +	if (!c_req->c_in_dma) {
>> +		dev_err(dev, "fail to set pbuffer address!\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	c_req->c_out_dma = c_req->c_in_dma;
>> +
>> +	return 0;
>> +}
>> +
>> +static void sec_cipher_pbuf_unmap(struct sec_ctx *ctx, struct sec_req *req,
>> +			struct scatterlist *dst)
>> +{
>> +	struct aead_request *aead_req = req->aead_req.aead_req;
>> +	struct sec_cipher_req *c_req = &req->c_req;
>> +	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
>> +	struct device *dev = SEC_CTX_DEV(ctx);
>> +	int copy_size, pbuf_length;
>> +	int req_id = req->req_id;
>> +
>> +	if (ctx->alg_type == SEC_AEAD)
>> +		copy_size = c_req->c_len + aead_req->assoclen;
>> +	else
>> +		copy_size = c_req->c_len;
>> +
>> +	pbuf_length = sg_copy_from_buffer(dst, sg_nents(dst),
>> +				qp_ctx->res[req_id].pbuf,
>> +				copy_size);
>> +
>> +	if (unlikely(pbuf_length != copy_size))
>> +		dev_err(dev, "copy pbuf data to dst error!\n");
>> +
>> +}
>> +
>> +static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
>>   			  struct scatterlist *src, struct scatterlist *dst)
>>   {
>>   	struct sec_cipher_req *c_req = &req->c_req;
>> +	struct sec_aead_req *a_req = &req->aead_req;
>>   	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
>> +	struct sec_alg_res *res = &qp_ctx->res[req->req_id];
>> +	struct device *dev = SEC_CTX_DEV(ctx);
>> +	int ret;
>> +
>> +	if (ctx->use_pbuf) {
>> +		ret = sec_cipher_pbuf_map(ctx, req, src);
>> +		c_req->c_ivin = res->pbuf + SEC_PBUF_IV_OFFSET;
>> +		c_req->c_ivin_dma = res->pbuf_dma + SEC_PBUF_IV_OFFSET;
>> +		if (ctx->alg_type == SEC_AEAD) {
>> +			a_req->out_mac = res->pbuf + SEC_PBUF_MAC_OFFSET;
>> +			a_req->out_mac_dma = res->pbuf_dma +
>> +					SEC_PBUF_MAC_OFFSET;
>> +		}
>> +
>> +		return ret;
>> +	}
>> +	c_req->c_ivin = res->c_ivin;
>> +	c_req->c_ivin_dma = res->c_ivin_dma;
>> +	if (ctx->alg_type == SEC_AEAD) {
>> +		a_req->out_mac = res->out_mac;
>> +		a_req->out_mac_dma = res->out_mac_dma;
>> +	}
>>   
>>   	c_req->c_in = hisi_acc_sg_buf_map_to_hw_sgl(dev, src,
>>   						    qp_ctx->c_in_pool,
>> @@ -626,29 +780,34 @@ static int sec_cipher_map(struct device *dev, struct sec_req *req,
>>   	return 0;
>>   }
>>   
>> -static void sec_cipher_unmap(struct device *dev, struct sec_cipher_req *req,
>> +static void sec_cipher_unmap(struct sec_ctx *ctx, struct sec_req *req,
>>   			     struct scatterlist *src, struct scatterlist *dst)
>>   {
>> -	if (dst != src)
>> -		hisi_acc_sg_buf_unmap(dev, src, req->c_in);
>> +	struct sec_cipher_req *c_req = &req->c_req;
>> +	struct device *dev = SEC_CTX_DEV(ctx);
>>   
>> -	hisi_acc_sg_buf_unmap(dev, dst, req->c_out);
>> +	if (ctx->use_pbuf) {
> Are we sure this flag can't have changed?
I thinks this is a bug, we will update it.
>> +		sec_cipher_pbuf_unmap(ctx, req, dst);
>> +	} else {
>> +		if (dst != src)
>> +			hisi_acc_sg_buf_unmap(dev, src, c_req->c_in);
>> +
>> +		hisi_acc_sg_buf_unmap(dev, dst, c_req->c_out);
>> +	}
>>   }
>>   
>>   static int sec_skcipher_sgl_map(struct sec_ctx *ctx, struct sec_req *req)
>>   {
>>   	struct skcipher_request *sq = req->c_req.sk_req;
>>   
>> -	return sec_cipher_map(SEC_CTX_DEV(ctx), req, sq->src, sq->dst);
>> +	return sec_cipher_map(ctx, req, sq->src, sq->dst);
>>   }
>>   
>>   static void sec_skcipher_sgl_unmap(struct sec_ctx *ctx, struct sec_req *req)
>>   {
>> -	struct device *dev = SEC_CTX_DEV(ctx);
>> -	struct sec_cipher_req *c_req = &req->c_req;
>> -	struct skcipher_request *sk_req = c_req->sk_req;
>> +	struct skcipher_request *sq = req->c_req.sk_req;
>>   
>> -	sec_cipher_unmap(dev, c_req, sk_req->src, sk_req->dst);
>> +	sec_cipher_unmap(ctx, req, sq->src, sq->dst);
>>   }
>>   
>>   static int sec_aead_aes_set_key(struct sec_cipher_ctx *c_ctx,
>> @@ -759,16 +918,14 @@ static int sec_aead_sgl_map(struct sec_ctx *ctx, struct sec_req *req)
>>   {
>>   	struct aead_request *aq = req->aead_req.aead_req;
>>   
>> -	return sec_cipher_map(SEC_CTX_DEV(ctx), req, aq->src, aq->dst);
>> +	return sec_cipher_map(ctx, req, aq->src, aq->dst);
>>   }
>>   
>>   static void sec_aead_sgl_unmap(struct sec_ctx *ctx, struct sec_req *req)
>>   {
>> -	struct device *dev = SEC_CTX_DEV(ctx);
>> -	struct sec_cipher_req *cq = &req->c_req;
>>   	struct aead_request *aq = req->aead_req.aead_req;
>>   
>> -	sec_cipher_unmap(dev, cq, aq->src, aq->dst);
>> +	sec_cipher_unmap(ctx, req, aq->src, aq->dst);
>>   }
>>   
>>   static int sec_request_transfer(struct sec_ctx *ctx, struct sec_req *req)
>> @@ -801,9 +958,9 @@ static void sec_request_untransfer(struct sec_ctx *ctx, struct sec_req *req)
>>   static void sec_skcipher_copy_iv(struct sec_ctx *ctx, struct sec_req *req)
>>   {
>>   	struct skcipher_request *sk_req = req->c_req.sk_req;
>> -	u8 *c_ivin = req->qp_ctx->res[req->req_id].c_ivin;
>> +	struct sec_cipher_req *c_req = &req->c_req;
>>   
>> -	memcpy(c_ivin, sk_req->iv, ctx->c_ctx.ivsize);
>> +	memcpy(c_req->c_ivin, sk_req->iv, ctx->c_ctx.ivsize);
>>   }
>>   
>>   static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
>> @@ -818,8 +975,7 @@ static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
>>   	memset(sec_sqe, 0, sizeof(struct sec_sqe));
>>   
>>   	sec_sqe->type2.c_key_addr = cpu_to_le64(c_ctx->c_key_dma);
>> -	sec_sqe->type2.c_ivin_addr =
>> -		cpu_to_le64(req->qp_ctx->res[req->req_id].c_ivin_dma);
>> +	sec_sqe->type2.c_ivin_addr = cpu_to_le64(c_req->c_ivin_dma);
>>   	sec_sqe->type2.data_src_addr = cpu_to_le64(c_req->c_in_dma);
>>   	sec_sqe->type2.data_dst_addr = cpu_to_le64(c_req->c_out_dma);
>>   
>> @@ -836,7 +992,10 @@ static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
>>   		cipher = SEC_CIPHER_DEC << SEC_CIPHER_OFFSET;
>>   	sec_sqe->type_cipher_auth = bd_type | cipher;
>>   
>> -	sa_type = SEC_SGL << SEC_SRC_SGL_OFFSET;
>> +	if (ctx->use_pbuf)
>> +		sa_type = SEC_PBUF << SEC_SRC_SGL_OFFSET;
>> +	else
>> +		sa_type = SEC_SGL << SEC_SRC_SGL_OFFSET;
>>   	scene = SEC_COMM_SCENE << SEC_SCENE_OFFSET;
>>   	if (c_req->c_in_dma != c_req->c_out_dma)
>>   		de = 0x1 << SEC_DE_OFFSET;
>> @@ -844,7 +1003,10 @@ static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
>>   	sec_sqe->sds_sa_type = (de | scene | sa_type);
>>   
>>   	/* Just set DST address type */
>> -	da_type = SEC_SGL << SEC_DST_SGL_OFFSET;
>> +	if (ctx->use_pbuf)
>> +		da_type = SEC_PBUF << SEC_DST_SGL_OFFSET;
>> +	else
>> +		da_type = SEC_SGL << SEC_DST_SGL_OFFSET;
>>   	sec_sqe->sdm_addr_type |= da_type;
>>   
>>   	sec_sqe->type2.clen_ivhlen |= cpu_to_le32(c_req->c_len);
>> @@ -904,9 +1066,9 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
>>   static void sec_aead_copy_iv(struct sec_ctx *ctx, struct sec_req *req)
>>   {
>>   	struct aead_request *aead_req = req->aead_req.aead_req;
>> -	u8 *c_ivin = req->qp_ctx->res[req->req_id].c_ivin;
>> +	struct sec_cipher_req *c_req = &req->c_req;
>>   
>> -	memcpy(c_ivin, aead_req->iv, ctx->c_ctx.ivsize);
>> +	memcpy(c_req->c_ivin, aead_req->iv, ctx->c_ctx.ivsize);
>>   }
>>   
>>   static void sec_auth_bd_fill_ex(struct sec_auth_ctx *ctx, int dir,
>> @@ -939,8 +1101,7 @@ static void sec_auth_bd_fill_ex(struct sec_auth_ctx *ctx, int dir,
>>   
>>   	sec_sqe->type2.cipher_src_offset = cpu_to_le16((u16)aq->assoclen);
>>   
>> -	sec_sqe->type2.mac_addr =
>> -		cpu_to_le64(req->qp_ctx->res[req->req_id].out_mac_dma);
>> +	sec_sqe->type2.mac_addr = cpu_to_le64(a_req->out_mac_dma);
>>   }
>>   
>>   static int sec_aead_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
>> @@ -964,6 +1125,7 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
>>   {
>>   	struct aead_request *a_req = req->aead_req.aead_req;
>>   	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
>> +	struct sec_aead_req *aead_req = &req->aead_req;
>>   	struct sec_cipher_req *c_req = &req->c_req;
>>   	size_t authsize = crypto_aead_authsize(tfm);
>>   	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
>> @@ -979,7 +1141,7 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
>>   		struct scatterlist *sgl = a_req->dst;
>>   
>>   		sz = sg_pcopy_from_buffer(sgl, sg_nents(sgl),
>> -					  qp_ctx->res[req->req_id].out_mac,
>> +					  aead_req->out_mac,
>>   					  authsize, a_req->cryptlen +
>>   					  a_req->assoclen);
>>   
>> @@ -1031,6 +1193,7 @@ static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
>>   
>>   static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
>>   {
>> +	struct sec_cipher_req *c_req = &req->c_req;
>>   	int ret;
>>   
>>   	ret = sec_request_init(ctx, req);
>> @@ -1057,12 +1220,10 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
>>   	/* As failing, restore the IV from user */
>>   	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && !req->c_req.encrypt) {
>>   		if (ctx->alg_type == SEC_SKCIPHER)
>> -			memcpy(req->c_req.sk_req->iv,
>> -			       req->qp_ctx->res[req->req_id].c_ivin,
>> +			memcpy(req->c_req.sk_req->iv, c_req->c_ivin,
>>   			       ctx->c_ctx.ivsize);
>>   		else
>> -			memcpy(req->aead_req.aead_req->iv,
>> -			       req->qp_ctx->res[req->req_id].c_ivin,
>> +			memcpy(req->aead_req.aead_req->iv, c_req->c_ivin,
>>   			       ctx->c_ctx.ivsize);
>>   	}
>>   
>> @@ -1208,6 +1369,10 @@ static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
>>   		return -EINVAL;
>>   	}
>>   	sreq->c_req.c_len = sk_req->cryptlen;
>> +
>> +	if (ctx->pbuf_supported && sk_req->cryptlen <= SEC_PBUF_SZ)
>> +		ctx->use_pbuf = true;
> This is request specific so a bit nasty to put it in the context. If nothing
> else it means reviewing this properly requires careful checking that there
> isn't a race on that variable.  Can we put the flag in the request somewhere?
Will fix here in V2.

Cheers,
Zaibo

.
>
>> +
>>   	if (c_alg == SEC_CALG_3DES) {
>>   		if (unlikely(sk_req->cryptlen & (DES3_EDE_BLOCK_SIZE - 1))) {
>>   			dev_err(dev, "skcipher 3des input length error!\n");
>> @@ -1321,11 +1486,16 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
>>   	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>>   	size_t authsize = crypto_aead_authsize(tfm);
>>   
>> -	if (unlikely(!req->src || !req->dst || !req->cryptlen)) {
>> +	if (unlikely(!req->src || !req->dst || !req->cryptlen ||
>> +		req->assoclen > SEC_MAX_AAD_LEN)) {
>>   		dev_err(SEC_CTX_DEV(ctx), "aead input param error!\n");
>>   		return -EINVAL;
>>   	}
>>   
>> +	if (ctx->pbuf_supported && (req->cryptlen + req->assoclen) <=
>> +		SEC_PBUF_SZ)
>> +		ctx->use_pbuf = true;
>> +
>>   	/* Support AES only */
>>   	if (unlikely(c_alg != SEC_CALG_AES)) {
>>   		dev_err(SEC_CTX_DEV(ctx), "aead crypto alg error!\n");
>
> .
>


