Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794560188;
	b=xqpBGe125QA2QYHjaBB1cliqR73mYbZHVPEFvEaQAqnMTYFyUOD5lnXG/W9KvngxhU5i
	 Ray0QWPI+UueOfXUnQzSMafN0mIjogkQ/YzIZRqTdWbdjsuHF7snA7qsoV8N4wPhLhXRd
	 xC3JOTzrNyeT+L/SwzOpXuSL8zRgsUjoi2rqtkdzVQWxIxy7a75/JZBU8MMhf3iVNzuJa
	 F3hrtTgTNUmHoDR60dZj1T3gkCPauh5ljKlFWAP22epXLHFg3PTLnQojjIRAfnCjpvJEB
	 LyfQm6ARyF11IgqbIZvjvCZ4PxFpcs3OuxnaSTy4RcyN7kU38aUsoJ5DoXiWSALHuyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794560188;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=635Ci6VAnXs6c1GfhFk9h3QP3roIWWt+PYlTyK8KYmc=;
	b=3KrgGvkNQysubldqUesnHOiwreZCP4lW5mL9/YqP9MXE8mKUe9vEDLmNJ9nfNx8JAhcK
	 +TLZuPiBWievGR1XzLCzLirL8+wq0kpCuVSpSwSgWrHl+xaTnFbeC6PmDu2T2y1lNRJdY
	 jRwe4FJtSkYH6aIGwgTTVowHlEPJbKitSsTdC9ohopM+8A5yI8kUlhI5Yhf1iO7SLwlmh
	 W6AoI4Lub8Ft7S5iDlRzH7/8Bnyde7baKQug4+LV7AB1DwWd+HzouvRC1yu8fqd1Lb+Ip
	 sPcYw1nBRAjHmvK/MF4O/kOcKyv+c8+e1/i48RjaqA+nBkBgksZ3lgzQM1Mdx/xKUcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cxzb7MG/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC8B606A32D
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 08:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cxzb7MG/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D706B1F000C4;
	Fri, 13 Nov 2026 08:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794560188;
	bh=635Ci6VAnXs6c1GfhFk9h3QP3roIWWt+PYlTyK8KYmc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cxzb7MG/wqtkn/bNXKeaIO4O/JTdgz68mWL4V9TYN5+Hy7JT2KhgcJH7p0kv4Xguu
	 q+VVrXvK41R/U50IxMmmGvboV7dA788rAcvwZf0sAphr5avHVA9VnEU5jQfN2iWBZe
	 wtFpAzE12xVuKb1BnAErbjiELsRTtr5PgfkDqcRi9JV7UK/ZbpQcbwnCIVK5qFQ1MO
	 tXIqHA9qQdKMpQvZUtGyM4WhTt8E2fVL+P3cALImI8JiBdcmTLqyVC/6Kb3ckSne8S
	 yv8dJkAj6Spjopz+cbnPxJsOsyGLqnxQCEp7aJIOf21VGmECn8i+GegMd1ZwiM1uFV
	 hSqPWSfoObh8A==
Message-ID: <sashiko-outbox-212481@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: qce - use the mapped scatterlist count for
 ahash requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinming Zhao" <zhaojinming@uniontech.com>, "Bartosz Golaszewski" <brgl@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "LABBE
 Corentin" <clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <20261113-qce-ahash-dma-count-v1-1-0423b54d75c8@uniontech.com>
References: <20261113-qce-ahash-dma-count-v1-1-0423b54d75c8@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 08:56:27 +0000
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
- [High] crypto: qce - wrong nents passed to dma_unmap_sg() in ahash
  paths
--

commit a88269ea6101fd18834fc68bd1c31da34ddad7a9
Author: Jinming Zhao <zhaojinming@uniontech.com>

crypto: qce - use the mapped scatterlist count for ahash requests

This commit stores the entry count returned by dma_map_sg() in
rctx->src_nents so that qce_dma_prep_sgs() and the subsequent dma_unmap_sg()
calls use the mapped scatterlist count.

Link: https://sashiko.dev/#/patchset/20261016-fix-qce-ccm-adata-leak-v1-0-f=
54a82af2de0@uniontech.com

> diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
> index b67d749db05f2..c53d0e53784e0 100644
> --- a/drivers/crypto/qce/sha.c
> +++ b/drivers/crypto/qce/sha.c
> @@ -97,6 +97,12 @@ static int qce_ahash_async_req_handle(struct crypto_as=
ync_request *async_req)
>  	if (!ret)
>  		return -EIO;
> =20
> +	/*
> +	 * dma_map_sg() can coalesce entries, so use the number of mapped
> +	 * entries for the descriptor and for the later unmap.
> +	 */
> +	rctx->src_nents =3D ret;

[Severity: High]
Does overwriting rctx->src_nents pass the wrong entry count to
dma_unmap_sg()?

Both qce_ahash_done() and the error_unmap_src path pass rctx->src_nents to
dma_unmap_sg(), which the DMA API requires to be the original nents passed
to dma_map_sg() rather than the coalesced count it returned.  When
dma_map_sg() merges entries, unmapping with the smaller count triggers a
DMA-API debug warning and leaves trailing scatterlist segments unsynchroniz=
ed
or unmapped.

Like qce_skcipher_async_req_handle(), keeping the return value of
dma_map_sg() in a local variable for qce_dma_prep_sgs() would preserve
rctx->src_nents for dma_unmap_sg().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-qce-ahash-=
dma-count-v1-1-0423b54d75c8@uniontech.com?part=3D1
