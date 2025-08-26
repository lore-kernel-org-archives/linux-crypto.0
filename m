Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6C511CA9;
	Tue, 26 Aug 2025 05:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756185462; cv=none; b=qiYAmJjFC0T6/3W/Iirf5eCqOKHeCe3EDlVICMwgnOi6j9XcgHy6ihhP4r8d0d7w7s7q0tv8LXA7K+8myKO/vGYS5FtA2WYrm9ngbp5EhIq2XuV2ieqKGNd6Yba0wFIClJLP01xDBdNYQdPUAxrr/JyucTr0AjptdHHRAoz5Yds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756185462; c=relaxed/simple;
	bh=HN4WVMsoJ6aT/HrCyH4VdROYVrIDQAJ31til/XsQxTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YPPf1s80Vy2FnSlohHedG84rQtGeJLHapOgGcMXEa9S6pPACiQAkYIOKDGNVtzK9t9+VbZz7/myM+TRzIKPoyKHD/pS1xj5IJqIprSv5KKMj5R2hfrKo8E/JKVxq8xN6RVt6RkOXZDJCl7+CIZu9+8CLfuUYgpCt4FZGjMB42YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RcOxXkVa; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RcOxXkVa"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-53b174f7cf0so3992226e0c.2;
        Mon, 25 Aug 2025 22:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756185459; x=1756790259; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6KCkaaGO+9Jn63lszeHqOHrKxFsF7u4XrLjmhxlKN4=;
        b=RcOxXkVagIG6ExyE1gVgeyWtz970qXVAhotkXKvANEy7M3sKkAUplN3464r0+HkrJG
         ZLZ7yu0fIMgZ3YNdJskRSl6E+S/SCcX2061aSFrF2ZhhDNLnE2fMoGhGGnr2t88SAn4c
         hxOPHPoj89PSB2mlhbegNqfyosWaJ7jkaoh7OvMR5onxWr0AmW+6tfpPLsOolJ/zYVOB
         LcbcjKYaRngHQstQ9NmrDLuAPDNSZQ3BJEP+5NXEFlhhsuo9RtWxJs30O6pKEefmKeHQ
         TRDcsH4AdkB2XzbyBKgcD58rk+/a3c+weZ3jWxuK+P4kYoIk6wWaPoRzjbz2sEcCCfSO
         MyxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756185459; x=1756790259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R6KCkaaGO+9Jn63lszeHqOHrKxFsF7u4XrLjmhxlKN4=;
        b=BUuVePDReYQ7GQ7gEU/i69HOpk1j+GazVOOsEPEgzABZB9lKKZf6TEIjqhXdHCwMuB
         rRzzYiBWUnC3xMZ3ofAkvIFze6CoRQ1dyJWvp5Fz+EKodeBRTwJTuO5N1u8W2GVb5RQA
         2SriK5Ra88xgek/X+8nAlc2Me5lptsLG+uKT3BVuh3VG/NU11Gq/kaPK84TUHNP7pZfV
         0qFu3ba60ZVcxUrEwosJ1tDem+xptijqBPIq5IUMctUk2xbAq52Z11gxOk1fFoFCG8WK
         8Ya8A1SPVYKgCR9EeqcjURrDuXAf5DIN9DpoTDPifvpVAHVYq3ue1OK+Mkm9+2HdjxEV
         ZRKw==
X-Forwarded-Encrypted: i=1; AJvYcCWvdH1TLC18TFyvXI0RxJCHG0+WUFTFYU1LVFuEQ8IpBVHmvlvabFQ5sdBunDGPx/jriyzHur9qJKQeXj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxweJ+HjCtsob+neb2o4i33NBuIp7Rm+nSHO//dEbND45jHU9EA
	tRIRTBZ8OUNDHrfoBv/mk+u1e6ERoftgEWeR4AXCFy2CYE/L6R9yahm8kYLTJVY6oeQ52GHdd3q
	df5NREc+W9v24r31A0ixYwCi8CXqlRlo=
X-Gm-Gg: ASbGncvb9YGQTxTZQKy+vTS9YUhR9I7noaWDWXzNtqzDwUi4RzHziHuusVIDymA/PBL
	3Tzhx6NwCR/uMUTnAl00jMNwxgHTlRnUI25ioSqpXw6bXZVcpeJTyxJb52KjWPFrZP1bAowEKNu
	Sx5zMF+SZSCjGEkfoLDQHm6NO3XwQBfkCjLpB+3PXGbWAAOdmIalPahuGhMcmlDwb/npiXoZsqv
	u49nk5AaAA4rl8kOg==
X-Google-Smtp-Source: AGHT+IHW8PFR8+zVJx+H1F//I5Djns1GfxpRAjFWm2T8ulatbw+PZth3H+Z/Iuy2+xO6mHlBSstorcd9X74Q7lUd+ls=
X-Received: by 2002:a05:6122:3c51:b0:53b:174d:98f2 with SMTP id
 71dfb90a1353d-53c8a2afd87mr4059919e0c.3.1756185459220; Mon, 25 Aug 2025
 22:17:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com> <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com> <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 26 Aug 2025 13:17:26 +0800
X-Gm-Features: Ac12FXwFLemTCGqls7xpPBf9Ugl5TECSEyLNR8RUZl5ccfrj7g2jmoWvOleOPpM
Message-ID: <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
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

> > > > [...]
> > > > >
> > > > > +       /*
> > > > > +        * Set the unit of compress batching for large folios, fo=
r quick
> > > > > +        * retrieval in the zswap_compress() fast path:
> > > > > +        * If the compressor is sequential (@pool->compr_batch_si=
ze is 1),
> > > > > +        * large folios will be compressed in batches of
> > > > ZSWAP_MAX_BATCH_SIZE
> > > > > +        * pages, where each page in the batch is compressed sequ=
entially.
> > > > > +        * We see better performance by processing the folio in b=
atches of
> > > > > +        * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working=
 set
> > > > > +        * structures.
> > > > > +        */
> > > > > +       pool->batch_size =3D (pool->compr_batch_size > 1) ?
> > > > > +                               pool->compr_batch_size : ZSWAP_MA=
X_BATCH_SIZE;
> > > > > +
> > > > >         zswap_pool_debug("created", pool);
> > > > >
> > > > >         return pool;
> > > > >
> > > >
> > > > It=E2=80=99s hard to follow =E2=80=94 you add batch_size and compr_=
batch_size in this
> > > > patch, but only use them in another. Could we merge the related cha=
nges
> > > > into one patch instead of splitting them into several that don=E2=
=80=99t work
> > > > independently?
> > >
> > > Hi Barry,
> > >
> > > Thanks for reviewing the code and for your comments! Sure, I can merg=
e
> > > this patch with the next one. I was trying to keep the changes modula=
rized
> > > to a) zswap_cpu_comp_prepare(), b) zswap_store() and c)
> > zswap_compress()
> > > so the changes are broken into smaller parts, but I can see how this =
can
> > > make the changes appear disjointed.
> > >
> > > One thing though: the commit logs for each of the patches will
> > > also probably need to be merged, since I have tried to explain the
> > > changes in detail.
> >
> > It=E2=80=99s fine to merge the changelog and present the story as a who=
le. Do we
>
> Sure.
>
> > really need both pool->batch_size and pool->compr_batch_size? I assume
> > pool->batch_size =3D pool->compr_batch_size if HW supports batch; other=
wise
> > pool->compr_batch_size =3D 1.
>
> Actually not exactly. We have found value in compressing in batches of
> ZSWAP_MAX_BATCH_SIZE even for software compressors. Latency benefits
> from cache locality of working-set data. Hence the approach that we have
> settled on is pool->batch_size =3D ZSWAP_MAX_BATCH_SIZE if
> the compressor does not support batching (i.e., if pool->compr_batch_size=
 is 1).
> If it does, then pool->batch_size =3D pool->compr_batch_size.

I understand that even without a hardware batch, you can still
have some software batching that excludes compression.

However, based on the code below, it looks like
pool->compr_batch_size is almost always either equal to
pool->batch_size or 1:

+       pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
+                                    crypto_acomp_batch_size(acomp_ctx->aco=
mp));

+       pool->batch_size =3D (pool->compr_batch_size > 1) ?
+                               pool->compr_batch_size : ZSWAP_MAX_BATCH_SI=
ZE;


It seems one of these two variables may be redundant.
For instance, no matter if pool->compr_batch_size > 1, could we always trea=
t
batch_size as ZSWAP_MAX_BATCH_SIZE?  if we remove
pool->batch_size, could we just use pool->compr_batch_size as the
step size for compression no matter if pool->compr_batch_size > 1.

for example:
       pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
                                    crypto_acomp_batch_size(acomp_ctx->acom=
p));

Then batch the zswap store using ZSWAP_MAX_BATCH_SIZE, but set the
compression step to pool->compr_batch_size.

Thanks
Barry
