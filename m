Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553686;
	b=z2QJfoRzdrzdW28Hhn4qzg2u4urML2T3QYkrmI+DHxaiPmLjKAf099mduA7ek9cnjSmb
	 +zzSSpBtl6ifkDbZKGUEKEh77qRGjCV7jVyPnIqJchY41RQ0FUMxHdx/TAMq6ToFK7/78
	 HfThTJDzdkmYAmr0h5q+QZ4eYzbSdB15w7Mimsy5xJEbfoNOEZH2qxLACwzKa4RQZZYuS
	 jg7Q7vpV2QntC7Np4HW0TSVNeuDfw1li5Eq2+BAuGUbPbkk25bbWEFrFFn7nRx/k7tYLj
	 UgfbVLkn6jVEYqrlWvYWS9ETy2GJZOLKciDYMGGtxJ5kIQFwpsliWGF9dqsUx8MtJNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553686;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OL4dzJNOuLqLseJzL0ilTzIpSLYP/dNRhVD1xaqa39Q=;
	b=BfO8I8fZUF30Vyee4N84NmhObP9h0T3KdTwKkdCt6tA4xwgJ7NGiOIXlJ696TBzuk+Vo
	 BelZyaa1AeqwRvNzTel/83mj5qWRJ09nnjA4HJbuSxhqpUDpHtfm3ZHH3+gTi8fk13PtF
	 x/ULPfUUGEBGw7YAvx5LCyDdg1LCgaX8gLUZr98r9s/L0QcSLmvEljM8VtwCu1fYzChlA
	 iKYfhT6vuujjrfMbLsSLdzEJdpOd/HZ7NgWFcyF9qKbauCRtsMrl7WS9d0KSdpIrEFJyG
	 7dAx9KDFTo+J4q6AOKObByhrShJ0Z6RAvhYcid65Kdz+rWdD8Yxm8MCykn3JvwXWnYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kV8nOu3s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124EC606A321
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 07:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kV8nOu3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826251F000C9;
	Fri, 13 Nov 2026 07:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794553685;
	bh=OL4dzJNOuLqLseJzL0ilTzIpSLYP/dNRhVD1xaqa39Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kV8nOu3s+9M0go6YIHcNQq9YJx5afPQszMPUcCtw36CI1rvzyURNvf8VyqB3IAfvy
	 0ptt7H+x/kCwQmJQsCcyY+9EuH2icPEjVh3BB6/nPh4bXBh7VWCLBAI22z8jR05B4z
	 l4SLXbGdmzPCbyopHL/AUiiDlxE5fnpmMGQz3Y9Uo79GDFs7Z/Pvc/skrd/RwdP43W
	 UhERnuLnSiB+fsm+TL4N8hrxQ3O+UXFMU+UFa1ql6clmcubwW58qu5QQmwpuHoBJXF
	 N2nrov9P++INI4UsyYtgfmobfL7knK4pD89W3GYPVOc1OaaY+HNkNKUEFEZNyZx/MQ
	 /Woj/3pS0Hjng==
Message-ID: <sashiko-outbox-212320@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/7] crypto: qce - reject a negative scatterlist
 count in CCM AAD preparation
Reply-To: sashiko-reviews@lists.linux.dev
To: ZhaoJinming <zhaojinming@uniontech.com>, "Bartosz Golaszewski" <brgl@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Thara
 Gopinath" <thara.gopinath@linaro.org>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <20261113-fix-qce-ccm-adata-leak-v2-6-914501377a62@uniontech.com>
References: <20261113-fix-qce-ccm-adata-leak-v2-0-914501377a62@uniontech.com>
 <20261113-fix-qce-ccm-adata-leak-v2-6-914501377a62@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:08:05 +0000
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
- [High] crypto: qce: late sg_nents_for_len() check after
  scatterwalk_ffwd()
--

commit 68e95033f32d45aeb2e2a9a17114843648589d9a
Author: ZhaoJinming <zhaojinming@uniontech.com>

crypto: qce - reject a negative scatterlist count in CCM AAD preparation

This commit checks the return value of sg_nents_for_len(req->src, totallen)
in qce_aead_ccm_prepare_buf_assoclen() before passing the entry count to
sg_alloc_table().

> diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
> index 00c5924c057e3..f75e3827d8bcb 100644
> --- a/drivers/crypto/qce/aead.c
> +++ b/drivers/crypto/qce/aead.c
> @@ -186,6 +186,7 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request=
 *req)
>  	unsigned int adata_header_len, cryptlen, totallen;
>  	gfp_t gfp;
>  	bool diff_dst;
> +	int nents;
>  	int ret;
> =20
>  	if (IS_DECRYPT(rctx->flags))
> @@ -231,10 +232,16 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_reque=
st *req)
> =20
>  	diff_dst =3D (req->src !=3D req->dst) ? true : false;
> =20
> +	nents =3D sg_nents_for_len(req->src, totallen);
> +	if (nents < 0) {
> +		ret =3D nents;
> +		goto err_free_adata;
> +	}
> +
>  	if (diff_dst)
> -		rctx->src_nents =3D sg_nents_for_len(req->src, totallen) + 1;
> +		rctx->src_nents =3D nents + 1;
>  	else
> -		rctx->src_nents =3D sg_nents_for_len(req->src, totallen) + 2;
> +		rctx->src_nents =3D nents + 2;
> =20
>  	gfp =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL : GFP=
_ATOMIC;
>  	ret =3D sg_alloc_table(&rctx->src_tbl, rctx->src_nents, gfp);

[Severity: High]
Is this sg_nents_for_len(req->src, totallen) check placed too late in
qce_aead_ccm_prepare_buf_assoclen()?

Earlier in the function, req->src is already walked and copied before
reaching this check:

drivers/crypto/qce/aead.c:qce_aead_ccm_prepare_buf_assoclen() {
	...
	totallen =3D cryptlen + req->assoclen;

	/* Get the msg */
	msg_sg =3D scatterwalk_ffwd(__sg, req->src, req->assoclen);
	...
	/* Copy the associated data */
	if (sg_copy_to_buffer(req->src, sg_nents_for_len(req->src, assoclen),
			      rctx->adata + adata_header_len,
			      assoclen) !=3D assoclen) {
	...
}

If req->src is shorter than req->assoclen, scatterwalk_ffwd() walks past the
end of the scatterlist and triggers a NULL pointer dereference before the n=
ew
check is reached, and sg_copy_to_buffer() also receives an unchecked negati=
ve
return value from sg_nents_for_len(req->src, assoclen) as its unsigned int
nents argument.  Checking sg_nents_for_len(req->src, totallen) immediately
after computing totallen would validate req->src before scatterwalk_ffwd(),
the rctx->adata allocation, and sg_copy_to_buffer() run.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-fix-qce-cc=
m-adata-leak-v2-0-914501377a62@uniontech.com?part=3D6
