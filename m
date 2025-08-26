Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3770A2D3A74;
	Tue, 26 Aug 2025 04:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756183345; cv=none; b=swaFfOQ7N8sebdFoCCpnZAlHsik0jcaMHMMh3QCTBceTegWyrTN2fzE6oaxvzZFNX1zns8UEOeYsjP7cT4F+ERuB6TR69CN9T4yGNHe7q70rf7jPKZoBNRYn/Uwab/v0MWOMF1cUv1sZady/lUpLSUb6TgH8vOd6XyqawNS9ESU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756183345; c=relaxed/simple;
	bh=k1bk6VFjDk5I1Z88ppayqh4AH6QAAdHsKpLOUa1Pwtw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ALKbq2Jq/Oo0UDeFAZ1LLGVYXuko/Fc+qCUtLzflE9O11v1fOnI82YIQQgTIo5pjd4EvUCeUQZU5NCe2fX+B9UkLiO7rpq/3ruGUyS23x9VuurPfIwC013jPlcjP1mwKK+6CYnyuXHa0+Jq0rJKTh2nXIjtRKAduPt/S9jiNbFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M1MWC0hN; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M1MWC0hN"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-53b17558b2fso3778007e0c.3;
        Mon, 25 Aug 2025 21:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756183342; x=1756788142; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QeuOW/tAwdKvRds8hPNWFHvxC5GbUoV3RdzaFP3jJI=;
        b=M1MWC0hNfbbZcEdvK9Ab6LQnasRLhRFcya2RwxPNcBx1Ex/lAlZM3Nkb0GYi30LUq0
         J94uGZfJK/Yd4ekL1YVXVbE+EYajDEQ/n95wl1DSNbPLsOdxPHAKVCnK8dnDOT8LT755
         gk/tCa5IzgHALWhmEclU1kAVzRPUXTiHDm/lT3YMo07RDT2VJiha8n/9qRO6Mngla1Jk
         RkqnIiLOY25f0FHSKrYTCD4CiZdimGueM1g22Z5WsMhs2g+sxlmcp53mvqGWxVnrm+b5
         upk2s/mBPJ0C9vXcwxmS2Vxj3dq5H6APuStLp8QV1v0dagc/yIoyevOyr0KzxDaF2/+i
         yKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756183342; x=1756788142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+QeuOW/tAwdKvRds8hPNWFHvxC5GbUoV3RdzaFP3jJI=;
        b=EO9acTjyCYCOKImDo0No1i6JMsLmZwdsDeQShpvar7vdEVC8zuJH0cGqX4aYgNVdFB
         MuA5r+pWf0K85MtX+7/ya5s19UANpGg6IULhsS9600YjwH6dZevVavd/LytXMuF4NOdO
         81OFs8mAiesR2+3lNOiToEYTcKqqEeBx47hEmXM5r3xy8ztsNYuK04eVGS4TGTCSl/mQ
         oMdV4yN3Dk5jPa2ZqX5kRNPiphdH//U6Ol5ykmb6TbL2rgxVjZI4VQ5dVaSlURz6hngs
         73VM6y5J1JPZnu6uTEnWx0Vk/eDpuZxPrOn1YnlV6+nmW3MhKyw+LgsWUTGvFGOohvsY
         fJeg==
X-Forwarded-Encrypted: i=1; AJvYcCWG/C2MHeOkp8FNT3/6Wxep/QIu+GiVpRF4+szxz7//JzXTmAvXSC0KhDLjzw+hhpodClkv9rdi2QwgzPU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5bAGLN5j3nAoUxMsU0DR/fVe5evDnKpN4MqdtsBxJ2kaUrUDy
	EqpxG9y0aPRj2b4GZ+p77bm2f66DP8II2woNjAvYGQGWU7sZatPKlcfn6GQvsSYbbbjvB7+QoOL
	HefjhooSLHBrRyVok9xNrCJ6HG5fP+XQ=
X-Gm-Gg: ASbGncuQ17zgQeyem85iL+qlvtjs657tjDFZONEkZjc+HpC0TgF++idEFM7Q/BjvbBy
	0fE7WHjY/4m/KTaNN9pi+TLePH1LgvolN7JfTNDmhLifRDj+F0p2dEOH+/IeOAe/NvjFgGH/2AR
	05fbLa4042c/KiMQIFs8XUaaiF1pQfTSdAwBTerlHsvlTH7GyL2syuGipWIprZmQdp0MWC29fmo
	l7DmP6lo5KhAiVgBw==
X-Google-Smtp-Source: AGHT+IH5b0xCIWtqEG+h9ra5vWc4g5n84Q9ziHeF9o3vOHY8vzNL1C4z2v2bOjHCTTM16yDC4g/RAi16yBCVpf9ru9A=
X-Received: by 2002:a05:6122:896:b0:53c:6d68:1cd7 with SMTP id
 71dfb90a1353d-53c8a3f18f2mr4610648e0c.13.1756183341907; Mon, 25 Aug 2025
 21:42:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com> <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 26 Aug 2025 12:42:09 +0800
X-Gm-Features: Ac12FXwIVh1CBUbWctN1hUqXXVlFsJoqPjkIW5ijU8kZiggqZfat8Ckeul-2aTI
Message-ID: <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
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

On Tue, Aug 26, 2025 at 12:27=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Barry Song <21cnbao@gmail.com>
> > Sent: Monday, August 25, 2025 8:48 PM
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
> > Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resour=
ces
> > if the compressor supports batching.
> >
> > Hi Kanchana,
> >
> >
> > [...]
> > >
> > > +       /*
> > > +        * Set the unit of compress batching for large folios, for qu=
ick
> > > +        * retrieval in the zswap_compress() fast path:
> > > +        * If the compressor is sequential (@pool->compr_batch_size i=
s 1),
> > > +        * large folios will be compressed in batches of
> > ZSWAP_MAX_BATCH_SIZE
> > > +        * pages, where each page in the batch is compressed sequenti=
ally.
> > > +        * We see better performance by processing the folio in batch=
es of
> > > +        * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working set
> > > +        * structures.
> > > +        */
> > > +       pool->batch_size =3D (pool->compr_batch_size > 1) ?
> > > +                               pool->compr_batch_size : ZSWAP_MAX_BA=
TCH_SIZE;
> > > +
> > >         zswap_pool_debug("created", pool);
> > >
> > >         return pool;
> > >
> >
> > It=E2=80=99s hard to follow =E2=80=94 you add batch_size and compr_batc=
h_size in this
> > patch, but only use them in another. Could we merge the related changes
> > into one patch instead of splitting them into several that don=E2=80=99=
t work
> > independently?
>
> Hi Barry,
>
> Thanks for reviewing the code and for your comments! Sure, I can merge
> this patch with the next one. I was trying to keep the changes modularize=
d
> to a) zswap_cpu_comp_prepare(), b) zswap_store() and c) zswap_compress()
> so the changes are broken into smaller parts, but I can see how this can
> make the changes appear disjointed.
>
> One thing though: the commit logs for each of the patches will
> also probably need to be merged, since I have tried to explain the
> changes in detail.

It=E2=80=99s fine to merge the changelog and present the story as a whole. =
Do we
really need both pool->batch_size and pool->compr_batch_size? I assume
pool->batch_size =3D pool->compr_batch_size if HW supports batch; otherwise
pool->compr_batch_size =3D 1. It seems pool->compr_batch_size should either
be a bool or be dropped. If we drop it, you can still check whether HW
supports batch via crypto_acomp_batch_size() when doing compression:

if (crypto_acomp_batch_size() > 1)
    compress in steps of PAGE_SIZE;
else
    compress in steps of batch_size;

no ?

Thanks
Barry
