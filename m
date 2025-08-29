Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBBC17E0;
	Fri, 29 Aug 2025 03:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756438295; cv=none; b=A+CdaO7yvtq9JcQXFbdgA+StZkhZc2ZEW91r6Kr2zeY4guq5G8q58vAq0YpTqUXjW7xkWBPZISWqX0VtMXW2rebihiYl8V5vONS7WIV1x/ULqHsm1PCLuHhHuRUJmPy/MCOmge6ZGlUxQlDm0a2izJqresLooWd1IODXmjjl51I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756438295; c=relaxed/simple;
	bh=hQU0ntEX9jUSg0B8Cu/aqBZcnH09deL1YiOoqFCmst4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QWhJGqWa/SIubk1tHmhaUuA/GR90BKka6zMxB04Z0K0sRoBRgiu1vFTgbMpJq8v+U/Qgb1j2kHMBq55WJaZVUj/LFIRIiwCXlMANUYp9UZec2aA2OCvfEca5J02jvlGKxG38QbxxbAdW7Mp25TVmxJWFFZZOs745v3WARnAA+Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bzHELN2L; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bzHELN2L"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7f861f89313so163485185a.1;
        Thu, 28 Aug 2025 20:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756438293; x=1757043093; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ADYcr57ubdWKZAedQhB4LgeKWRv5y3WMX0XjvFo6Wo=;
        b=bzHELN2LCXKl6DHtY0Z/D3MFEkfq7CAIkrNbZw+ljXZL8TGfV5tq8HDdmmCP95O+nB
         iifrlZE5fiegO6/hsvaSsBqH4stN6Y1vfivPQHKLK8Xm1lPc4Tx9wdkqywmqCAa7AYit
         HekyB8SsAmCZvqbT8u85abLXQtJ0N9w9D3yO5AOYWSpqp7k5xIDft0v4y1M6YPqEGziQ
         AbpG4NQRQO1VopMzpfH5rzhPxXNE74d2UcWV7Ut3xrWrt4U9OKZesgxLr+AsC0srUsrd
         yRtgJM8YkKcFUmlBeY8KnJceHUWmHJ3+GRXmmMZx+P11eFwOpRvW4py2FTmZqSBU1Lz7
         MD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756438293; x=1757043093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ADYcr57ubdWKZAedQhB4LgeKWRv5y3WMX0XjvFo6Wo=;
        b=FR1szSVPVsZUbVkEtK3t9GnUR8InsGvZ6lIaKJcm2mbWkj9Em4w61OEpjfnEh2l+jr
         urhYXFJDK6EabbTa5KmYPt1M9qukdUUQsllkZZ/qNVWassLYEPl14o0zWA3URv9ijOId
         +RHD5SaeztWH39nWOoanVmY6L+ra41T4hAC0jbFuZZT2ATO1ttP/I+16TGt65/B/QzWP
         N9aK23ME5sqUgY5j5gG3H2ltQeavDVv0LKQJ9TiVeIaw0hSXbU62sg3oPriarwiWHa8q
         w+1mots51FjovTMmfd7zPJUby8h1kZ4BDjSxHQ6NBeiKhruqV2GO4KL6xLEN+VAYh1Tn
         x4uQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcNSFWCRenTgpXk3wq2rALCvqyFrMk4TB0CD9l3dE6qiJA5+P5coq5WUSuht+/4BDdGlP2yxwmhgTivqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKbVlhKbtE8mJNuoI0PtKgc2FXVMUjaeOxNue61YRP+T2hSTnN
	Oa6k7mHnvZB8eKi4A9RMBpHeVm/hDvRBeUCo7ZTIYRUmcFl826l0N9TIsOn8hXAp2YbaXod0Tj0
	4DBulgqkLWirQR6G16YuU4xKdQ7RPkHI=
X-Gm-Gg: ASbGncuH5t7DpzcYPehP/Tsw/gIYQnbjUO5dpYLvs5FBqjCdyFpVpF01FHwB19fLjRF
	G/Khw0Rs0vAuAAQDRCN8wSp6dD8kaqg6YzsD5JeXxgscIQXeOo6+vzj2M7lfbQCPW92TdEb+wqx
	axhNyjF/gWnMojZXnW+3vlTLWNjDCLPbFwM7viLN0Z48yj0udY1ESrnubGybO2AzMrLCoiq+Td5
	rnpzTQ=
X-Google-Smtp-Source: AGHT+IGEZ/VVLdhbW4pwfoESF2nMHOvYZKZwWWhXDB21nwadZKTlaRoN2bwKZej7UBthdgBvEuoaeEf77PMv3GxcBqk=
X-Received: by 2002:a05:620a:178d:b0:7f2:32f6:6059 with SMTP id
 af79cd13be357-7f232f66372mr2304183185a.73.1756438292389; Thu, 28 Aug 2025
 20:31:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-25-kanchana.p.sridhar@intel.com> <CAGsJ_4xMYUHo_SRc=1jgP6jMNosA_NP3HCitSMKwx=5ScJ0Cng@mail.gmail.com>
 <PH7PR11MB81213032EE672C69B3FC3370C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81213032EE672C69B3FC3370C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 11:31:21 +0800
X-Gm-Features: Ac12FXwkrbOj6-86gUqhlz-rQd1S-Zr7JQZDpGn6f_G18CtOphnH5OXwGLiRBic
Message-ID: <CAGsJ_4xH7aU37w03-4MSJs7Bik6pShLfad8RY8TSzj37AcGwDg@mail.gmail.com>
Subject: Re: [PATCH v11 24/24] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 11:05=E2=80=AFAM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Barry Song <21cnbao@gmail.com>
> > Sent: Thursday, August 28, 2025 4:54 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; ying.huang@linux.alibaba.com; akpm@linux-
> > foundation.org; senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> > herbert@gondor.apana.org.au; davem@davemloft.net;
> > clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> > surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> > Gomes, Vinicius <vinicius.gomes@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v11 24/24] mm: zswap: Batched zswap_compress() with
> > compress batching of large folios.
> >
> > > +static bool zswap_compress(struct folio *folio, long start, unsigned=
 int
> > nr_pages,
> > > +                          struct zswap_entry *entries[], struct zswa=
p_pool *pool,
> > > +                          int node_id)
> > >  {
> > >         struct crypto_acomp_ctx *acomp_ctx;
> > >         struct scatterlist input, output;
> > > -       int comp_ret =3D 0, alloc_ret =3D 0;
> > > -       unsigned int dlen =3D PAGE_SIZE;
> > > -       unsigned long handle;
> > > -       struct zpool *zpool;
> > > +       struct zpool *zpool =3D pool->zpool;
> > > +
> > > +       unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
> > > +       int errors[ZSWAP_MAX_BATCH_SIZE];
> > > +
> > > +       unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_siz=
e);
> > > +       unsigned int i, j;
> > > +       int err;
> > >         gfp_t gfp;
> > > -       u8 *dst;
> > > +
> > > +       gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM |
> > __GFP_MOVABLE;
> > >
> > >         acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> > >
> > >         mutex_lock(&acomp_ctx->mutex);
> > >
> > > -       dst =3D acomp_ctx->buffers[0];
> > > -       sg_init_table(&input, 1);
> > > -       sg_set_page(&input, page, PAGE_SIZE, 0);
> > > -
> > >         /*
> > > -        * We need PAGE_SIZE * 2 here since there maybe over-compress=
ion
> > case,
> > > -        * and hardware-accelerators may won't check the dst buffer s=
ize, so
> > > -        * giving the dst buffer with enough length to avoid buffer o=
verflow.
> > > +        * Note:
> > > +        * [i] refers to the incoming batch space and is used to
> > > +        *     index into the folio pages, @entries and @errors.
> > >          */
> > > -       sg_init_one(&output, dst, PAGE_SIZE * 2);
> > > -       acomp_request_set_params(acomp_ctx->req, &input, &output,
> > PAGE_SIZE, dlen);
> > > +       for (i =3D 0; i < nr_pages; i +=3D nr_comps) {
> > > +               if (nr_comps =3D=3D 1) {
> > > +                       sg_init_table(&input, 1);
> > > +                       sg_set_page(&input, folio_page(folio, start +=
 i), PAGE_SIZE, 0);
> > >
> > > -       /*
> > > -        * it maybe looks a little bit silly that we send an asynchro=
nous request,
> > > -        * then wait for its completion synchronously. This makes the=
 process
> > look
> > > -        * synchronous in fact.
> > > -        * Theoretically, acomp supports users send multiple acomp re=
quests in
> > one
> > > -        * acomp instance, then get those requests done simultaneousl=
y. but in
> > this
> > > -        * case, zswap actually does store and load page by page, the=
re is no
> > > -        * existing method to send the second page before the first p=
age is
> > done
> > > -        * in one thread doing zwap.
> > > -        * but in different threads running on different cpu, we have=
 different
> > > -        * acomp instance, so multiple threads can do (de)compression=
 in
> > parallel.
> > > -        */
> > > -       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx-
> > >req), &acomp_ctx->wait);
> > > -       dlen =3D acomp_ctx->req->dlen;
> > > -       if (comp_ret)
> > > -               goto unlock;
> > > +                       /*
> > > +                        * We need PAGE_SIZE * 2 here since there may=
be over-
> > compression case,
> > > +                        * and hardware-accelerators may won't check =
the dst buffer
> > size, so
> > > +                        * giving the dst buffer with enough length t=
o avoid buffer
> > overflow.
> > > +                        */
> > > +                       sg_init_one(&output, acomp_ctx->buffers[0], P=
AGE_SIZE * 2);
> > > +                       acomp_request_set_params(acomp_ctx->req, &inp=
ut,
> > > +                                                &output, PAGE_SIZE, =
PAGE_SIZE);
> > > +
> > > +                       errors[i] =3D
> > crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
> > > +                                                   &acomp_ctx->wait)=
;
> > > +                       if (unlikely(errors[i]))
> > > +                               goto compress_error;
> > > +
> > > +                       dlens[i] =3D acomp_ctx->req->dlen;
> > > +               } else {
> > > +                       struct page *pages[ZSWAP_MAX_BATCH_SIZE];
> > > +                       unsigned int k;
> > > +
> > > +                       for (k =3D 0; k < nr_pages; ++k)
> > > +                               pages[k] =3D folio_page(folio, start =
+ k);
> > > +
> > > +                       struct swap_batch_comp_data batch_comp_data =
=3D {
> > > +                               .pages =3D pages,
> > > +                               .dsts =3D acomp_ctx->buffers,
> > > +                               .dlens =3D dlens,
> > > +                               .errors =3D errors,
> > > +                               .nr_comps =3D nr_pages,
> > > +                       };
> >
> > Why would this work given that nr_pages might be larger than
> > pool->compr_batch_size?
>
> You mean the batching call? For batching compressors, nr_pages
> is always <=3D pool->batch_size. For batching compressors, pool->batch_si=
ze
> is the pool->compr_batch_size.

I=E2=80=99m actually confused that this feels inconsistent with the earlier

    unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);

So why not just use nr_comps instead?

>
> >
> > unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);
> >
> > So this actually doesn=E2=80=99t happen unless pool->compr_batch_size =
=3D=3D 1,
> > but the code is confusing, right?
> >
> > > +
> > > +                       acomp_ctx->req->kernel_data =3D &batch_comp_d=
ata;
> >
> > Can you actually pass a request larger than pool->compr_batch_size
> > to the crypto driver?
>
> Clarification above..
>
> >
> > By the way, swap_batch_comp_data seems like a poor name. Why should
> > crypto drivers know anything about swap_? kernel_data isn=E2=80=99t ide=
al either;
> > maybe batch_data would be better ?
>
> This will be changing in v12 to use an SG list based on Herbert's suggest=
ions.
>

Cool. Thanks!

Thanks
Barry
