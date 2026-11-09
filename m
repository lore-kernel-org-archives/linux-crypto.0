Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794211534;
	b=UAnzvgKi56g4uTwW39cCW7/L6SwaVvKGpCniFegt7mYwGbbP0xgVnqrtMIim6CUWz45E
	 av+qnYWf2CjNRWVPAhB+dab0pfo26gXuFEwxAO7n+n1WLYcwtOtQh+f5r9loM3xxV6f5f
	 4DGrB98eJmazHsbzQadT7YrSW+9yKuWiW8/12G1pFoS4ormojBEwoOTth4lqr90ItBvve
	 QUsLgBNVRZtsslvkvyndcezO0Cc0TZY31qxrfRtZccNeFqJhtjw/PREbcIB5BuTkEdaRN
	 M3gQNT+4BAR47zvGO+89pY7ePb/GTe56aIIHtPxwlGCjsWBOKQNADFK7/BZNWZOMv3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794211534;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=J65fHlMIodQdJrFvp6Eb4f0lyEr7o6Uh1vYDTmprIg8=;
	b=upfwcu8kWiC4spx+/N7SGI9XWhlyECNhijWSKg7nPlFhpevA4uE/nUkqp6RYfV2LJSCh
	 GvGvBYbTwDCkSoq7+S1jAk7HT7eDLsPqmHC5dgS1B/Jh22vj4vbFwwx+HY6y5oUXBScaI
	 ge5rgTMv+JYi6fQM3P/zlFbQJ+McLgpvwy1JUtt3pHcUGEO6hpIWS67ubOBoYfyMPZeiW
	 1Yo9SMdOU6Nl9kZ8aVJ0NA7oxzWrVKaEfjRiiSRkuxE66+a02VX79J53b+AJKUXBu13oi
	 nhjNjNuCkVG9ZvKyhabMRI3yZUSwobA3lkT/YK7+EgV6BrUCkAA6iw9BD9m0IStp19g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FhAlFBCj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD46606A321
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 08:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FhAlFBCj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052491F0089F;
	Mon,  9 Nov 2026 08:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794211533;
	bh=J65fHlMIodQdJrFvp6Eb4f0lyEr7o6Uh1vYDTmprIg8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FhAlFBCj+SJ6rnZT7ousddDGpx4leWAXnIn2QX7rDOwl0c1FqKG5aChNoPvT9J5BP
	 6eYCZxwfGHSSAM7KAUihui9wCP7gw+m6UxSFT+joBjkqkW2sJo68ul3aDA3npgkPP9
	 ExgQn/ON4RXbz/dR8E+TOQ3buQK1I4idV5hm9F/94AuzPCRZ/tMfBWEfKZRhbYDADM
	 Pvb0l9lk/P6ruMd+Ktr7jn/x/7HuORhNrdLFowyQNPTTYqpwVXEG62a2l4O9pWLCqm
	 ZX4CJk6+I+UM5syo7GpgAEljPJPFspH2V5J8E6Q3UGg1YBAgi0/KnxMsu6ibq3eBI9
	 vujPYPrholKvA==
Message-ID: <sashiko-outbox-204560@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] crypto: hisilicon/zip - adapt to use crypto engine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chenghai Huang" <huangchenghai2@huawei.com>, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, liulongfang@huawei.com, qianweili@huawei.com, wangzhou1@hisilicon.com, linwenkai6@hisilicon.com
In-Reply-To: <20261109073556.2517351-5-huangchenghai2@huawei.com>
References: <20261109073556.2517351-1-huangchenghai2@huawei.com>
 <20261109073556.2517351-5-huangchenghai2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 08:05:32 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] crypto: hisilicon/zip - req_id exhaustion deadlock in
  hisi_zip_do_comp()
- [Medium] crypto: hisilicon/zip: hisi_zip_do_acomp() clobbers -EBUSY on
  backlog
--

commit e6135edb946689a8be0edb23655def633c6b3f9a
Author: Chenghai Huang <huangchenghai2@huawei.com>

crypto: hisilicon/zip - adapt to use crypto engine

This commit migrates the HiSilicon ZIP acomp driver to the crypto_engine
framework so requests that hit a full hardware queue are queued and retried
instead of failing immediately.

> diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/h=
isilicon/zip/zip_crypto.c
> index 70adde049b535..84951bc74a96e 100644
> --- a/drivers/crypto/hisilicon/zip/zip_crypto.c
> +++ b/drivers/crypto/hisilicon/zip/zip_crypto.c

[ ... ]

> @@ -333,68 +345,111 @@ static void hisi_zip_acomp_cb(struct hisi_qp *qp, =
void *data)

[ ... ]

> +static int hisi_zip_do_comp(struct hisi_zip_req *req)
> +{
> +	struct hisi_qp *qp =3D req->qp_ctx->qp;
> +	struct device *dev =3D &qp->qm->pdev->dev;
> +	int ret;
> +
> +	if (!req->buf_ready) {
> +		ret =3D hisi_zip_create_req(req);
> +		if (unlikely(ret))
> +			return -ENOSPC;
> +
> +		ret =3D hisi_zip_map_req_buffers(req);
> +		if (unlikely(ret))
> +			goto remove_req;
> +	}
> +
> +	ret =3D hisi_zip_do_work(req);
> +	if (ret =3D=3D -EINPROGRESS)
> +		return -EINPROGRESS;
> +
> +	if (ret =3D=3D -EBUSY)
> +		return -ENOSPC;

[Severity: High]
Can hisi_zip_do_comp() deadlock qp_ctx->engine when a request with
req->buf_ready =3D=3D false sits at the head of engine->queue while all
req_q->size bits in req_q->req_bitmap are held by req->buf_ready =3D=3D true
requests queued behind it?

req_q->req_bitmap has sq_depth bits, while qm_get_avail_sqe() caps the
hardware SQ at sq_depth - 1 in-flight requests.  When hisi_qp_send() returns
-EBUSY, hisi_zip_do_comp() returns -ENOSPC with req->buf_ready =3D=3D true =
and
keeps req->req_id allocated while the request is parked in engine->queue.
Because hisi_zip_do_acomp() runs hisi_zip_do_comp() before
crypto_transfer_acomp_request_to_engine(), and qm_poll_req_cb() runs
hisi_zip_acomp_cb() (freeing req_id) before atomic_dec(&qp->qp_status.used),
new submissions can claim freed req_bitmap bits and queue behind an unmapped
request:

CPU0                              CPU1 (QM completion / new submitters)
hisi_zip_do_acomp(req_b)
  /* sq_depth - 1 in flight,
   * 1 parked with req_id held:
   * req_bitmap is full
   */
  hisi_zip_do_comp(req_b)
    hisi_zip_create_req(req_b)
      -> -EBUSY (-ENOSPC,
         buf_ready =3D=3D false)
  crypto_transfer_acomp_request_to_engine(req_b)
    /* req_b at head of engine->queue */
                                  qm_poll_req_cb()
                                    hisi_zip_acomp_cb()
                                      hisi_zip_remove_req()
                                    /* before atomic_dec(&qp_status.used),
                                     * new hisi_zip_do_acomp() calls
                                     * allocate the freed req_ids, get
                                     * -EBUSY from hisi_qp_send(), and
                                     * queue behind req_b with
                                     * buf_ready =3D=3D true
                                     */
kworker:
crypto_pump_requests()
  hisi_zip_do_one_request(req_b)
    hisi_zip_create_req(req_b)
      -> -ENOSPC
  crypto_enqueue_request_head(req_b)
  kthread_queue_work(pump_requests)  <-- spins forever

Once all sq_depth bits in req_bitmap are held by requests queued behind
req_b and the hardware SQ drains, req_b can never allocate a req_id and the
requests behind it can never be dequeued to release theirs, wedging the
queue and spinning engine->kworker at 100% CPU.

[ ... ]

> +static int hisi_zip_do_acomp(struct acomp_req *acomp_req, u8 alg_type)
> +{
> +	struct hisi_zip_ctx *ctx =3D crypto_tfm_ctx(acomp_req->base.tfm);
> +	struct hisi_zip_qp_ctx *qp_ctx =3D &ctx->qp_ctx[alg_type];
> +	struct hisi_zip_req *req =3D acomp_request_ctx(acomp_req);
> +	int ret;
> +
> +	if (unlikely(!acomp_req->src || !acomp_req->slen ||
> +		     !acomp_req->dst || !acomp_req->dlen))
> +		return -EINVAL;
> +
> +	req->req =3D acomp_req;
> +	req->alg_type =3D alg_type;
> +	req->qp_ctx =3D qp_ctx;
> +	req->buf_ready =3D false;
> +
> +	if (ctx->fallback)
> +		return hisi_zip_fallback_do_work(acomp_req,
> +						 req->alg_type =3D=3D HZIP_ALG_TYPE_DECOMP);
> +
> +	ret =3D hisi_zip_do_comp(req);
> +	if (ret !=3D -ENOSPC)
> +		return ret;
> +
> +	ret =3D crypto_transfer_acomp_request_to_engine(qp_ctx->engine, acomp_r=
eq);
> +	if (ret !=3D -EINPROGRESS && ret !=3D -EBUSY) {
> +		hisi_zip_release_req_resource(req);
> +		return ret;
> +	}
> +
> +	return -EINPROGRESS;
> +}

[Severity: Medium]
Should hisi_zip_do_acomp() return ret instead of -EINPROGRESS at the end of
the function?

When engine->queue is full and CRYPTO_TFM_REQ_MAY_BACKLOG is set,
crypto_transfer_acomp_request_to_engine() records the request on
engine->queue.backlog and returns -EBUSY.  Returning -EINPROGRESS hides the
backlog signal from callers and still triggers the extra
crypto_request_complete(backlog, -EINPROGRESS) notification from
crypto_pump_requests() that callers only expect after receiving -EBUSY.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109073556.2517=
351-1-huangchenghai2@huawei.com?part=3D4
