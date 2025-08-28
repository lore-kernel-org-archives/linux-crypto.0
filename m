Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD28634;
	Thu, 28 Aug 2025 23:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425273; cv=none; b=omO6E8aUrkrH4y85W4zMlarKqEjK9pm7M0Hz5gNCehT3Y/02JauXRYFBYmoGUVBUZBrYOC0OXRoaiyP+LDV8qXSTw+M7VLDgvr/iV0X5vJKBxyZKTlWAhVF66h3Zf7/i5Fg+xr5U6oALYXzffHhGXoCBWP9kVo/PHDZJ0Os+Q/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425273; c=relaxed/simple;
	bh=lCuDXGa8ikg2WC8GEmfWNaHgmgrl9ey+9nIbr+f+2bk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uOaGSar2NsHCW+CU1IsKOaYfN6CTB/tj9n3wPTcxElGbUCMg47UTwVOp8vXCv7wiszHW1tXgDr+BJ8MRxuttiPBk35CTNj4jRU8Ims3xtGlQfkDssa83scTI2/pJT1k/w5kseYPZu7T6ltO/nI51c+vPZLiTvoLw4bQQxuSliZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d2wZc1Nh; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2wZc1Nh"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7f0481658ceso159815385a.2;
        Thu, 28 Aug 2025 16:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756425271; x=1757030071; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywp5khp3KpGpdpq9ocHmTVlcpn3e5Ai0bpi4D2HSbEA=;
        b=d2wZc1NhnTlSXVrDpKdeBMn+Kj8Zc+TtFdUxKGaqZfztBPb4wh/5zpIz+n5V5UrrNk
         zeBNYmYsMFVKneo6FX0MaS/tCVzl3mjXXtMKNfjiMxwnb2nc/KBBXY142serBjQ9+UJQ
         GelQcokvrhtHE5hZpL68z6oonQVEn3v1KHzmXt+vSAJAg6Q73VBtKPBA9JhiEaUkaaR3
         qhz/wWP+YKE2vM8WB4ooepmYEOAac1/IXg32fWNKxs6yc3DZJeIl/oIK6lkSdtbfC2Vn
         mIeRUwKxqVYiPD2G2Up4ObWrnjdE2Fmn8j9QlOWEASa1pQpqes7i7FRyDil6f+wxbJI8
         MLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425271; x=1757030071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ywp5khp3KpGpdpq9ocHmTVlcpn3e5Ai0bpi4D2HSbEA=;
        b=k8JZQ95XPpJj9yprjsEVrkVzost6xDiNqt4gTDsWfGZMjEsDklledVDIMWIbPzd+67
         vtp+Es+bCo+hOmH2MisoCZkb2/1UljAvkUqj8hmhTIeWwh32351xWSCqWIBe0wW7cWo2
         mIW048Qb3Yjq7TqECU23WLM29i+g2gGd4Aouora3Li/NbwKRUyw+XkIrTvq9jVZg0iOk
         mm3pZTB1b3M/dK/eSsETWW498cQB597iSKNnNfo35bYPoNp7uAKpDAmE9xhXBjoAmCuZ
         QaVRWDHaGcMqqnBc4GxjXrVaeKx1PBJ6xLX4vTKxywIvIeKXcRl9Fzex4HoI0cxncyM+
         CS2g==
X-Forwarded-Encrypted: i=1; AJvYcCU7n7naPWOZ7t7gVQlxb2JOynScglGWuJmm9ez7nLfrmmnxyz+8XQ4SNFlDLLW86nnZ9xeRR040596G73g=@vger.kernel.org
X-Gm-Message-State: AOJu0YynpYiiTUzxLaORyZrSbVP/60W+NtpZEND4Fv4xzoJXGvFXUWy/
	MeKXHqa8PEEVQ1hAGrAbWSEzVGccxroygR0FErv7Ia7T7hPCVfd2gSYMvSrK5B5DrnySnjoY5BT
	Zkj/q3Ff12CMDdQLXqnVr+wKG1dh7hSM=
X-Gm-Gg: ASbGnctvRcXJk87gbCdhG++iaqgXWY1jIaIxt4n+3iS+lkcS2mJXH8enLYCDV6RWGjJ
	+luNQB9fJcipx43bDeaHxMbKDdBKayqsBAdwEm0SZTk6CyV04qKX/Ro9ZOaeJpetvECldL0Heu2
	5EmBpVXxBGMWDOlqanNo5KhKHbpeUO4ixMHnsXFl/v+TVNnPrQZGmv0gIcciB8gYFk/WHxGmiLY
	5DVDznZBqeQSDb5Tg==
X-Google-Smtp-Source: AGHT+IFx1bCdet3TXgM/yuGL1gCygeo78sYjNJ6iHciVjPmaRNEDp0QbZjfxfvz+2gGiwjHgQPA9Qv79Bjp1hQIzq1I=
X-Received: by 2002:a05:620a:a201:b0:7e9:fb98:f27e with SMTP id
 af79cd13be357-7ea1107f044mr3049024585a.58.1756425270808; Thu, 28 Aug 2025
 16:54:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-25-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-25-kanchana.p.sridhar@intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 11:54:19 +1200
X-Gm-Features: Ac12FXxu-APcLv8VU8AYKc0OPlj6u_0o-Gu5UmAhfYadfpGbK1JQlq4O_4nF6-Y
Message-ID: <CAGsJ_4xMYUHo_SRc=1jgP6jMNosA_NP3HCitSMKwx=5ScJ0Cng@mail.gmail.com>
Subject: Re: [PATCH v11 24/24] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> +static bool zswap_compress(struct folio *folio, long start, unsigned int=
 nr_pages,
> +                          struct zswap_entry *entries[], struct zswap_po=
ol *pool,
> +                          int node_id)
>  {
>         struct crypto_acomp_ctx *acomp_ctx;
>         struct scatterlist input, output;
> -       int comp_ret =3D 0, alloc_ret =3D 0;
> -       unsigned int dlen =3D PAGE_SIZE;
> -       unsigned long handle;
> -       struct zpool *zpool;
> +       struct zpool *zpool =3D pool->zpool;
> +
> +       unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
> +       int errors[ZSWAP_MAX_BATCH_SIZE];
> +
> +       unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);
> +       unsigned int i, j;
> +       int err;
>         gfp_t gfp;
> -       u8 *dst;
> +
> +       gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
>
>         acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
>
>         mutex_lock(&acomp_ctx->mutex);
>
> -       dst =3D acomp_ctx->buffers[0];
> -       sg_init_table(&input, 1);
> -       sg_set_page(&input, page, PAGE_SIZE, 0);
> -
>         /*
> -        * We need PAGE_SIZE * 2 here since there maybe over-compression =
case,
> -        * and hardware-accelerators may won't check the dst buffer size,=
 so
> -        * giving the dst buffer with enough length to avoid buffer overf=
low.
> +        * Note:
> +        * [i] refers to the incoming batch space and is used to
> +        *     index into the folio pages, @entries and @errors.
>          */
> -       sg_init_one(&output, dst, PAGE_SIZE * 2);
> -       acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SI=
ZE, dlen);
> +       for (i =3D 0; i < nr_pages; i +=3D nr_comps) {
> +               if (nr_comps =3D=3D 1) {
> +                       sg_init_table(&input, 1);
> +                       sg_set_page(&input, folio_page(folio, start + i),=
 PAGE_SIZE, 0);
>
> -       /*
> -        * it maybe looks a little bit silly that we send an asynchronous=
 request,
> -        * then wait for its completion synchronously. This makes the pro=
cess look
> -        * synchronous in fact.
> -        * Theoretically, acomp supports users send multiple acomp reques=
ts in one
> -        * acomp instance, then get those requests done simultaneously. b=
ut in this
> -        * case, zswap actually does store and load page by page, there i=
s no
> -        * existing method to send the second page before the first page =
is done
> -        * in one thread doing zwap.
> -        * but in different threads running on different cpu, we have dif=
ferent
> -        * acomp instance, so multiple threads can do (de)compression in =
parallel.
> -        */
> -       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
> -       dlen =3D acomp_ctx->req->dlen;
> -       if (comp_ret)
> -               goto unlock;
> +                       /*
> +                        * We need PAGE_SIZE * 2 here since there maybe o=
ver-compression case,
> +                        * and hardware-accelerators may won't check the =
dst buffer size, so
> +                        * giving the dst buffer with enough length to av=
oid buffer overflow.
> +                        */
> +                       sg_init_one(&output, acomp_ctx->buffers[0], PAGE_=
SIZE * 2);
> +                       acomp_request_set_params(acomp_ctx->req, &input,
> +                                                &output, PAGE_SIZE, PAGE=
_SIZE);
> +
> +                       errors[i] =3D crypto_wait_req(crypto_acomp_compre=
ss(acomp_ctx->req),
> +                                                   &acomp_ctx->wait);
> +                       if (unlikely(errors[i]))
> +                               goto compress_error;
> +
> +                       dlens[i] =3D acomp_ctx->req->dlen;
> +               } else {
> +                       struct page *pages[ZSWAP_MAX_BATCH_SIZE];
> +                       unsigned int k;
> +
> +                       for (k =3D 0; k < nr_pages; ++k)
> +                               pages[k] =3D folio_page(folio, start + k)=
;
> +
> +                       struct swap_batch_comp_data batch_comp_data =3D {
> +                               .pages =3D pages,
> +                               .dsts =3D acomp_ctx->buffers,
> +                               .dlens =3D dlens,
> +                               .errors =3D errors,
> +                               .nr_comps =3D nr_pages,
> +                       };

Why would this work given that nr_pages might be larger than
pool->compr_batch_size?

unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);

So this actually doesn=E2=80=99t happen unless pool->compr_batch_size =3D=
=3D 1,
but the code is confusing, right?

> +
> +                       acomp_ctx->req->kernel_data =3D &batch_comp_data;

Can you actually pass a request larger than pool->compr_batch_size
to the crypto driver?

By the way, swap_batch_comp_data seems like a poor name. Why should
crypto drivers know anything about swap_? kernel_data isn=E2=80=99t ideal e=
ither;
maybe batch_data would be better ?

> +
> +                       if (unlikely(crypto_acomp_compress(acomp_ctx->req=
)))
> +                               goto compress_error;
> +               }

Thanks
Barry
