Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794211256;
	b=NOBhkKtTnNjdUv0PuYL4tV8jKyr4hbY4QNI3bdqFuXQvDT5+BQMUJ21IobYHQ2XfNj8K
	 8OBi9SQ3odhdq5PFcdxmOm1Y21n4aBxUesnk4oKS00VUpkcpe2rdX8AlCHsSVXjmI0ygR
	 QKV9yHJsKFLcSjOJlA2F1193vl96UaxoJ06Ljgh1kx2isxSPOgJwqC80Hcx2wS1C6+Etd
	 8CAzNgvL2C/eaIg04e5d6HaKbp34xl9V9ZLSKolrALa5dGQ2CxIa+B9WSYPxzih3BgpL0
	 8KnlxQURTVxoBlnwtfwI+VuSWBkL0fz5HnNSyi9cjCkNKHxKv9HkQH6ZSx0Q8y1qaKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794211256;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gjmtswv9VcZKkxlAxk/CoVqUw3+8B5/47myQS0vj5vw=;
	b=KPdxWDB0TIVDnqErDKu9khsE9gXqipu5WpJ0GavOtV0XIFH5hTwsFrULoe2uSJgzMgKb
	 TGBGkKq9fzqYwc9h80kLO8MDZ+J4tytuMuFdX8g4B3xBtJLt2rfoqRGo+uAbj0rbuPfh4
	 gacWlUpGU7+H70W8s7guwfigakbSiMXbXQqRUwKvBfaksAP2Y5DOtMVxCPjhLwXKYVGho
	 cln6TAvoQ5DZGeY+HMcbYZUPeefoFEiLSvepJXYMpdABPutGFsaLP69cyLYzLh+Dpduwc
	 /eAFQrg/S/99EC6LE/aqS4jDW2As87vfmYQHcA2dqK148S2NLUP4xxp5ZddWhWBd2DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="l/vJVyiL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A83606A31C
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 08:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l/vJVyiL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED081F0089F;
	Mon,  9 Nov 2026 08:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794211255;
	bh=gjmtswv9VcZKkxlAxk/CoVqUw3+8B5/47myQS0vj5vw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l/vJVyiLA+IKIW8CqRKrFXpMgiLN/39uYjSiMnmVvBQQoQuQ8oTP2WUFK4QpXiWpH
	 2hOg2KWpVMtlpIWfz1XFFzb+/mH7UlBT0q867eWDQUqaYWN4kX9u5XjvVBUaBp7Zw5
	 5GY0GAOPNCbEHmUqIYvTv/tAz+hzJr7VDWQVqOo7JPmGBmkVKD4fVvTBqI0QlW1/T/
	 UfndYq2FZSIu6xop24TtbhjKR/VS3ifzTpXj+hrLodsfu0IgHUJbwrjauXLCovNvKq
	 VuZ7PpTd/C+Gp5JFat0Y0cjjNTjsKen/bwkDxvgG531WwtteBLvJOkMWszUF5mtv83
	 MtNQ8RJbe4IRw==
Message-ID: <sashiko-outbox-204559@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] crypto: hisilicon/hpre - use crypto engine
 framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chenghai Huang" <huangchenghai2@huawei.com>, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, liulongfang@huawei.com, qianweili@huawei.com, wangzhou1@hisilicon.com, linwenkai6@hisilicon.com
In-Reply-To: <20261109073556.2517351-4-huangchenghai2@huawei.com>
References: <20261109073556.2517351-1-huangchenghai2@huawei.com>
 <20261109073556.2517351-4-huangchenghai2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 08:00:54 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] crypto: hisilicon/hpre: race in hpre_ctx_init() with engine
  init and exit
It also noticed 2 related pre-existing issues this patch does not
introduce:
- [Critical] crypto: hisilicon/hpre - null pointer dereference in
  hpre_ecdh_cb() [1]
- [Critical] crypto: hisilicon/hpre: destination scatterlist overwrite
  in hpre_hw_data_clr_all() [2]
--

commit fd11798f0428979de89ed11bd547ffce95a2a817
Author: Weili Qian <qianweili@huawei.com>

crypto: hisilicon/hpre - use crypto engine framework

This commit migrates the HiSilicon HPRE DH, RSA, and ECDH algorithms to
the crypto engine framework so that CRYPTO_TFM_REQ_MAY_BACKLOG requests
are queued and retried when the hardware queue is full.

> diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto=
/hisilicon/hpre/hpre_crypto.c
> index 66a276786a7d0..c02c33ba04d4a 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
[ ... ]
> @@ -386,10 +398,20 @@ static int hpre_ctx_init(struct hpre_ctx *ctx, u8 t=
ype)
>  		return -ENODEV;
>  	}
> =20
> +	hpre =3D container_of(qp->qm, struct hpre, qm);
> +	if (!hpre->engine_num) {
> +		hisi_qm_free_qps(&qp, 1);
> +		return -ENODEV;
> +	}
> +	ctx->engine =3D hpre->engine[qp->qp_id % hpre->engine_num];
> +	if (!ctx->engine) {
> +		hisi_qm_free_qps(&qp, 1);
> +		return -ENODEV;
> +	}

[Severity: Medium]
Can hpre_ctx_init() race with hpre_alloc_crypto_engine() and
hpre_free_crypto_engine() when multiple HPRE devices are present?

In hpre_probe(), hisi_qm_add_list() adds the QM to hpre_devices before
hisi_qm_alg_register() calls hpre_algs_register(), and error rollback or
hpre_remove() calls hpre_algs_unregister() before hisi_qm_del_list().
When a first device has already registered the algorithms, a transform
allocated on another CPU can grab a QP from a second device while its
engines are being set up or torn down:

CPU0                                  CPU1
hpre_remove()
  hisi_qm_alg_unregister()
    hpre_algs_unregister()
      hpre_free_crypto_engine()
        crypto_engine_exit(engine[0])
                                      hpre_ctx_init()
                                        hpre_create_qp()
                                        ctx->engine =3D hpre->engine[0];
        hpre->engine_num =3D 0;
                                      hpre_rsa_enc()
                                        crypto_transfer_..._to_engine()
                                          <-- use-after-free on kworker

Similarly, during hpre_probe() of a second device, hpre_create_qp() can
select the new QM before hpre_alloc_crypto_engine() sets hpre->engine_num,
causing hpre_ctx_init() to fail with -ENODEV and forcing the transform to
software fallback even though other HPRE devices are ready.

[ ... ]

> @@ -1433,8 +1475,12 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, voi=
d *resp)
>  	p =3D sg_virt(areq->dst);
>  	memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
>  	memmove(p + curve_sz, p + areq->dst_len - curve_sz, curve_sz);
> -
> -	kpp_request_complete(areq, ret);
> +	local_bh_disable();
> +	if (areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
> +		crypto_finalize_kpp_request(ctx->engine, areq, ret);
> +	else
> +		kpp_request_complete(areq, ret);
> +	local_bh_enable();
> =20
>  	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
>  }

[Severity: Critical]
This problem wasn't introduced by this patch, but can sg_virt(areq->dst)
cause a NULL pointer dereference [1] when a request scatterlist is
backed by highmem pages?

Because the algorithms are registered without CRYPTO_ALG_KERN_DRIVER_ONLY,
requests submitted via AF_ALG can carry highmem pages where sg_virt()
returns NULL.  Passing that result to dma_map_single() in
hpre_get_data_dma_addr() performs an invalid DMA mapping, and passing p to
memmove() here in hpre_ecdh_cb() dereferences NULL.

[ ... ]

> @@ -1679,86 +1732,176 @@ static void hpre_ecdh_exit_tfm(struct crypto_kpp=
 *tfm)
[ ... ]
> +static int hpre_rsa_do_one_request(struct crypto_engine *engine, void *a=
req)
> +{
> +	struct akcipher_request *akreq =3D
> +	    container_of(areq, struct akcipher_request, base);
> +	void *tmp =3D akcipher_request_ctx(akreq);
> +	struct hpre_asym_request *hpre_req =3D PTR_ALIGN(tmp, hpre_align_sz());
> +	int ret;
> +
> +	ret =3D hpre_alg_send_message(hpre_req);
> +	if (ret && ret !=3D -ENOSPC)
> +		hpre_hw_data_clr_all(hpre_req->ctx, hpre_req, akreq->dst, akreq->src);
> +
> +	return ret;
> +}

[Severity: Critical]
This problem wasn't introduced by this patch, but does calling
hpre_hw_data_clr_all() with a non-NULL dst scatterlist on send failure
overwrite the caller's destination buffer [2] with zeroes?

drivers/crypto/hisilicon/hpre/hpre_crypto.c:hpre_hw_data_clr_all() {
	...
	if (req->dst) {
		if (dst)
			scatterwalk_map_and_copy(req->dst, dst, 0,
						 ctx->key_sz, 1);
		dma_free_coherent(dev, ctx->key_sz, req->dst, tmp);
	}
}

When hpre_hw_data_init() allocates a zeroed coherent bounce buffer in
req->dst and sending the request later fails in hpre_dh_compute_value(),
hpre_rsa_enc(), hpre_rsa_dec(), hpre_dh_do_one_request(), or
hpre_rsa_do_one_request(), the hardware never runs, so passing dst to
hpre_hw_data_clr_all() copies those unpopulated zeroes into the caller's
scatterlist.  Passing NULL for dst on error cleanup paths would free the
bounce buffer without modifying the caller's destination memory.

[1] https://sashiko.dev/#/bug/linux-2e7b66d8-14a8-417d-adb9-4989357e46d7
[2] https://sashiko.dev/#/bug/linux-547b9bb7-6119-42c4-b3f0-fda7348ea883

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109073556.2517=
351-1-huangchenghai2@huawei.com?part=3D3
