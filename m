Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347CD352037
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792101880; cv=none; b=J16VzTZG7dFanvgw8flki05rxpUjcVaSd2bQH1UWlYjJmQk20y1JzZIRFpLZxhLxS7hfuwXTavp2NlF2gpK7dg7ey6DxnTeZPP+P7wsnbLirKwk9KqjasItJDYmWqA1TXQMqQGxdz1CgYgj5EmDn/0axAo6FPO+SAOcYgpIF9jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792101880; c=relaxed/simple;
	bh=TBX5A67YSsWuxAB/4TO7PVxB29M1xxONXuyWhIREFeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=msTGLH3cY74IRmAbhW+AIiyFLuIvk6Dc81nZCkJjopoU+CE7tHYG1lkF1Y2kMmtFKo/F59xmGZBXF6LbFptKkeXfQUOzUaGWTtIsRJMpzs/H/qUVMtyrHYMb7Hqjv+F1riBikE5CyDl3PJ0rkVp3ZWUkq7ZOfgUnU/Y12kwgz1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJT0+jrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJT0+jrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32571F000CC
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792101878;
	bh=RlYzd0USpwg3JvbStBZnQdUC/IjyPKMmb+JkSAhgO4c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DJT0+jrLOGQd88lrqJAj8DabydJnd2u7QOrmT2Txk0viriqWFku9s8wrt5PECKnOs
	 69hEyT85EXJ/EQiNhU1aPp6e0XCy+NQg9bdIIQabSSQRQqJ5ECf1WVPDG21nIIe+Ki
	 rPnh5lg+hS5i6/uhd1UrMHRRrCZVxgoaVM9VnLYUZ85lOaZ6ONWn5D1HMoUkvcHtLp
	 H6lPS6nxQIzY1ff3xdtZyF6VKoRRL/DTJdw8Te1P7VfQ2WGaXaDjASwxx+9nd0HuUO
	 20Zyxjs8ZGUymprw0fADj/AXo+540TeHGZH7gkZ9zK83hFvc9YTivBuHzKKVRfnTt2
	 HYXFjlBE91Zow==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2e6df2742cso884599866b.2
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 15:04:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxoYgkSbSTYOYJOmZ9wRO0zWIyMzTpIOM+u+dbSGnXFjrMl1FH0GrDKPcC7X5Jwou5TjtsU4CuwkZyD2Ok=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ6JjtQ/XsGoAB6MaWqeoEqzIHRceZk19ODvUmX3Glr+GrrI/Zj
	u762XTfyBbmQ42eWNaPAbOkoF5nZ2wSugpD36XsWMlZQyciFo8MnKH8mRPYmvzz/Nrw4Vcp396o
	4mlGqvA3v20wxAn2zg4zGi5XSl0urQW0=
X-Received: by 2002:a17:907:dab:b0:c2d:fade:e089 with SMTP id
 a640c23a62f3a-c31a96de49dmr1933015666b.0.1792101877742; Thu, 15 Oct 2026
 15:04:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
In-Reply-To: <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 15:04:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
X-Gm-Features: AclHuK9As4WppohD6ZJZNrzjy04-7wgYHo0FQv2W3Z0D8lo9pnmEnN3DgsfpTfg
Message-ID: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 3:00=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Wed, Oct 14, 2026 at 8:45=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wrote:
> > > v1: Batched zswap_store() with compression batching
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > >
> > > This series is a spin-off of "v14: zswap compression batching with op=
timized
> > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and z=
swap
> > > compression batching enablers. Resuming work on this series following=
 a gap
> > > since v14 (January 2026). Please note that my email address and affil=
iation have
> > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gma=
il.com. I
> > > have retained the original Intel sign-offs on prior patches for histo=
rical
> > > attribution while signing off v1 of this series with my current addre=
ss.
> > >
> > > To summarize the main contribution of this patch series: Batching is =
introduced
> > > in zswap_store() of large folios: we carve out a large folio into bat=
ches of
> > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store ea=
ch
> > > batch. Moving the fundamental operations that need to be happen to st=
ore a page
> > > to now work at the granularity of a batch offers opportunities to opt=
imize them
> > > from these perspectives:
> > >
> > > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> > >
> > > 2) We keep the working set for each of the core store functionalities=
 (alloc
> > >    entries, compress pages, store pages in zsmalloc) to be focused on=
 a
> > >    batch, thereby minimizing cache evictions and benefiting from cach=
e
> > >    locality.
> > >
> > > 3) Along the lines of (1), the main zswap_compress() batching routine=
 obtains
> > >    the acomp_ctx mutex lock once per batch, and releases it after it =
has
> > >    processed all pages in that batch.
> > >
> > > 4) Any zswap store functionality that works on a batch can potentiall=
y be
> > >    parallelized as a next step, to further improve performance.
> > >
> > > Performance data: usemem with 60% over-commit:
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > How much of the performance benefits come from patch 6 vs patch 8?
>
> This is how the performance changes: Average throughput is averaged
> from 10 iterations of usemem.
>
> patch 6: 19,119 KB/s
> patch 8: 17,593 KB/s
>
> So the acomp_do_req_chain() path that ZSTD goes through with patch 8
> causes a regression, even though it provides a generic batching
> framework in acomp.
>
> I was able to retrieve performance with the following change in acompress=
.c:

Why add it to begin with in this case?

>
> patch 3 with this change in acompress.c: 19,578 KB/s
>
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index 192ea996e779..dc609bd7d927 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
>                 return -EAGAIN;
>
>         if (likely(req->unit_size && acomp_request_issg(req))) {
> -               if (!crypto_acomp_req_seg(tfm))
> -                       return acomp_do_req_chain(req, true);
> +               if (!crypto_acomp_req_seg(tfm)) {
> +                       int err =3D tfm->compress(req);
> +
> +                       req->dst->length =3D unlikely(err) ? err : req->d=
len;
> +                       return err;
> +               }
>
>                 return tfm->compress(req);
>         }
>
> Herbert, would you be Ok with this change in patch 3?
