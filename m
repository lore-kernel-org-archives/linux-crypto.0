Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794983881;
	b=z82kkFPdbcEA52ENLUU5/2a4vU6Jgi/Eyv/KLsIYupk0H5eJ+bE6qCx+hhqFlxKc8vtb
	 MLJpB5+VDB+0IdOr/gWxst/XtGUp6zI/2EYV9CxArFt/wP5fsvWVeck3R1HlAeTu8ZclZ
	 O/Kq12yBCaGP8D4U9rz8w7M2C1Fsz4uO3kPK+07aKbcyLBmDHABRf6rcXAfMFr2G/Nh35
	 zldtD2Q0C/8ge/h/jnt2IUYJrhLzf8xsVVuCdOlRWSTfBwzoA5umcoKiDcNd63wrl5HfP
	 gkNDbUuYBPpYTzrDASr1auh1GbbeGwdKtA0goeZi59qkyPBj/SMgq9P+mfiDP7MtgYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794983881;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gnt5cqpLvsV11Y2M81ywDej7TE7+sI+AcbZZU7jtj4Q=;
	b=R9qcwJEEVsH40oVYDnaDPB2XH3OP92JPpbr48kW0Bo6p3HQM8odLopuWgr/CHB1jY5Ht
	 PukvH2xd9Kv6IYcl5yZxDNtBSqHUUa8ev6BNWuON+SrQryNw/L6mHb9CK9YhMgiARXQmi
	 GJuo01a/BnzijlB4YAmlkqCfj4uih9iEVyea6/eTXG0FHdSM3AoEQvMmrspdNjHQY+rZs
	 uc636KC4KFxmrAZRFUf30x+qc75xEsNlwiiBBtwxCTv36dYrXnSNp+X2AfKBA8Om3O9xv
	 3nGmiWRziTt+xZklX2FNvbPLndNC4TgDG0sBzS9emeV4qM32wEc8GUJ996NHtpQoBww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OgYZwShO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B320606A31C
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 06:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OgYZwShO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3036B1F000C4;
	Wed, 18 Nov 2026 06:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794983881;
	bh=gnt5cqpLvsV11Y2M81ywDej7TE7+sI+AcbZZU7jtj4Q=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=OgYZwShOwGoyYw9e/tYhtFtyPbex7xlhGqRsPVq8zfGlSLoHT9yNaU2wLDiYNb93f
	 fAd3mjrxYfT/JZFodpBLykJQ49evwFQUa/X2AZ+KJzXOqVpB1Xz8p/dC1NgHbuXF5Q
	 8xMbcX6GwUWAQqZOd1h/GmgqO3A6EiCNmlT96ciN689g1Ag/3Bd/Y9ztyych2XHBkc
	 QmtanQ+MRXsD63M61QPyZ5I/1Allobj9sBKqgLU35ko4IN5njLUuRQTYa98htM6p9T
	 GNd8IvBPDOfboPSV3uYr5Rn8si3p31F20mMElvS3O9vo6XfSr+b2Zg/MV4cQtv7mlX
	 pGw2TT3iZBdAQ==
Message-ID: <sashiko-outbox-220265@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: hifn_795x - Free walk pages on session setup
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haoxiang Li" <haoxiang_li2024@163.com>, herbert@gondor.apana.org.au, davem@davemloft.net, johnpol@2ka.mipt.ru, linux-crypto@vger.kernel.org
In-Reply-To: <20261118061917.2093148-1-haoxiang_li2024@163.com>
References: <20261118061917.2093148-1-haoxiang_li2024@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 06:38:00 +0000
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
- [Medium] crypto: hifn_795x: out-of-bounds access in
  hifn_process_ready() after -EAGAIN
--

commit 36e24dad40a71397ed983775cdb1b3eac820b6a2
Author: Haoxiang Li <haoxiang_li2024@163.com>

crypto: hifn_795x - Free walk pages on session setup failure

This commit calls hifn_cipher_walk_exit() in the hifn_setup_session()
error paths to free temporary walk pages allocated for misaligned
destination scatterlists.

> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> index 46bcef0446067..73a661085d974 100644
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -1539,7 +1539,7 @@ static int hifn_setup_session(struct skcipher_reque=
st *req)
>  	sg_num =3D hifn_cipher_walk(req, &rctx->walk);
>  	if (sg_num < 0) {
>  		err =3D sg_num;
> -		goto err_out_exit;
> +		goto err_out_free;
>  	}
> =20
>  	spin_lock_irqsave(&dev->lock, flags);
> @@ -1561,6 +1561,9 @@ static int hifn_setup_session(struct skcipher_reque=
st *req)
> =20
>  err_out:
>  	spin_unlock_irqrestore(&dev->lock, flags);
> +err_out_free:
> +	if (rctx->walk.flags & ASYNC_FLAGS_MISALIGNED)
> +		hifn_cipher_walk_exit(&rctx->walk);
>  err_out_exit:
>  	if (err) {
>  		dev_info(&dev->pdev->dev, "iv: %p [%d], key: %p [%d], mode: %u, op: %u=
, "

[Severity: Medium]
Can this cause an out-of-bounds access on rctx->walk.cache[] in
hifn_process_ready() when hifn_setup_session() fails with -EAGAIN?

When a misaligned request has more than ASYNC_SCATTERLIST_CACHE (16)
destination segments that coalesce into fewer cache pages during
hifn_cipher_walk(), hitting the -EAGAIN path calls
hifn_cipher_walk_exit(), which zeroes w->cache[i].length and w->num while
leaving ASYNC_FLAGS_MISALIGNED set in rctx->walk.flags.  hifn_handle_req()
then enqueues the request into dev->queue.  If hifn_remove() ->
hifn_flush() later drains dev->queue via hifn_process_ready(), it sees
ASYNC_FLAGS_MISALIGNED still set and enters the walk loop:

drivers/crypto/hifn_795x.c:hifn_process_ready() {
	if (rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
		...
		while (nbytes) {
			t =3D &rctx->walk.cache[idx];
			dst =3D &req->dst[idx];
			...
			if (!t->length) {
				nbytes -=3D min(dst->length, nbytes);
				idx++;
				continue;
			}

Because every cache entry now has t->length =3D=3D 0 instead of advancing
across coalesced segments via skcipher_get(), idx increments once per
req->dst segment and indexes past rctx->walk.cache[16] and the end of
struct hifn_request_context.  Clearing ASYNC_FLAGS_MISALIGNED in
hifn_cipher_walk_exit() (or under err_out_free) would avoid walking an
already-freed cipher walk.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118061917.2093=
148-1-haoxiang_li2024@163.com?part=3D1
