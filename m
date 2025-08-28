Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEAA7082D;
	Thu, 28 Aug 2025 23:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756423727; cv=none; b=uPu7EdFndz8OLhChS7zh4g+TBAcnWuC6nnZeZvGSHX35VJIMkIrxvXrsz9XgpORXCe51PZgXHh7HZYv3CwKoUrYnAu8aStOxJL9L6IIRIZeNGhNVcvN28pX462gdwEL/fIqmxa491YLAYS8xDjXu92iqM4n6d+Kj/Uun/BQBQ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756423727; c=relaxed/simple;
	bh=ddB5ltz052A0NgyWpdONDu99T4ypYNf+rbcFEGWBC6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=af6YKkqKpPmMHZMlUnvEcI/DcBail3CkXyxTjO2R+CJo/mAMGxfvpVqI9TmNTP2paZeCmBtmq2wWuJyqDCYj4Pt9lXzZU2yAOmkNa0EaERlYJlZxv1SHnHMl1LNMmqQiOwcEpuZpwjbmtkzOBx+oFBeTSs/d8xHOyEpsd3DwEiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JbkJ0SQF; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JbkJ0SQF"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7f8ea864d68so146265185a.0;
        Thu, 28 Aug 2025 16:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756423725; x=1757028525; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5xAEZzGkKzOekVqIS4rKLRu5l7Wsy0HGBRxwvDh6Sc=;
        b=JbkJ0SQF58bxxeS7rfzfQlOSKp3WlVr+iBzUPWi9pCnIjdA0PQTNkCnP9L8KGmNheV
         6V5oEJTJR+OlghzmcFkN98QVX3BdA9FmY59DDjTC5YQ+7Siv6x6erwrgqyJOwk/w6UwH
         KM0EVRvZ78aKt7T1Tl/wA9TC4BPvD0iDS0mJYV39dQpft4LWzDrfP49Uv5XwY0kM0y/h
         C3kJffQ8x/efceAgXNBRWeWOERwlmHbp5eR0IkhFVLT94H+R5TQm5cNHEWUaJoFKE38N
         uh+IZls1dNhMKg0tEVvr07BIgEK8GkjJhAs5Af2P5HD9VeaGAhkqKd0fwN7r+XtlzySp
         yJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756423725; x=1757028525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5xAEZzGkKzOekVqIS4rKLRu5l7Wsy0HGBRxwvDh6Sc=;
        b=KyaeJ9zHju0mDLS97qH3a4ayvjM6J0EIuXuUZvZ7cO/cr8ZjiaFWPaly/A/sbo0Cq1
         ohejGs/Yf1+Tf6QywZux8oo8MzT5VJ6lFr36zv4OC6Xwt0vh3liBWju+TVNgfpNvrKk+
         YJyPJu60le2isknP9q+WtbvM4sEn3oSnJuw2iO0NOf9nHpQiRkec2dk2GgOA/tzJivvU
         Q5YxBTZd2UTKCXgD3sI6mtaDlzHKo2yfK2XiGy4oeSGHEOSIsd7Y3EVXAmszS5IF2HAC
         2Is6HF07YLzWeiOpkQpE8eAspNmmHPZs2jiEoaiVbK2YaG1i29gL9O70v7nL0phYIudY
         jSXg==
X-Forwarded-Encrypted: i=1; AJvYcCVjTmVOzIZ+l5+N58YY1jNw4RFRiRo/Gn2jg/KApHp7G7aO4osLc9Ag9MNE9iqQ+e53POl9y4qRk+qoRUk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwneOC6JhMQ3J+BLahr6OZvNhkXSh4/UY4HiEXdp/zp4G69Onr5
	jkOOCSsloaeFhI1ErMBiIKtC6v39OaSFPTavWVHxNrL2XUXyActGEHxqlVxjEAx5GDK0GX6lu4S
	pB8UqK10vhlzq8Z37aQuLUytw1m6/6rT8AMrw
X-Gm-Gg: ASbGncuJENieg+hCSwhl4b5CuQ4bWHelCP1nvt/KxEseoYVUEfsiwDlQltM2AVyeITz
	iiCdt6eEji+jVhbVB1AptDx3o+oAaBSijktYQndu+blju0Qi7ZTXDeW8N8WS29GNz1cPpwZccUx
	x4UJd/wtXTIwkOIq+C2DJ8yI8w9WfvyuVw28Bvu3dZm7hnio7kVRIEMYw8QPr5XIbSMO+uL/F14
	Gmx1QjJ+hPm/nEvCg==
X-Google-Smtp-Source: AGHT+IG9dqf0v9B4cNprbTA7zUMYBwOa7Uq6IGQrFQsG5rT3a7SmZdhcZHPObNG9JdyxtkduL8KD+Nlyyk3kPIqkw2Q=
X-Received: by 2002:a05:620a:3913:b0:7fb:d5c5:a4df with SMTP id
 af79cd13be357-7fbd5c5a6b0mr253670785a.34.1756423724471; Thu, 28 Aug 2025
 16:28:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com> <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
 <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
 <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com> <PH7PR11MB81211DD54822167C6BA238D5C93BA@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81211DD54822167C6BA238D5C93BA@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 11:28:33 +1200
X-Gm-Features: Ac12FXymL-oJOFhtfchGYmwxY8_PFVTDmAseMPSDCZcsDDSfx-7l2g2_r4lHbbs
Message-ID: <CAGsJ_4xy3mksbwj61qnNrSpcFgkanEK0tCzJcjQgVF-oAyXe8A@mail.gmail.com>
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

> >
> > If ZSWAP_MAX_BATCH_SIZE is set to 8 and there is no hardware batching,
> > compression is done with a step size of 1. If the hardware step size is=
 4,
> > compression occurs in two steps. If the hardware step size is 6, the fi=
rst
> > compression uses a step size of 6, and the second uses a step size of 2=
.
> > Do you think this will work?
>
> Hi Barry,
>
> This would be non-optimal from code simplicity and latency perspectives.
> One of the benefits of using the hardware accelerator's "batch parallelis=
m"
> is cost amortization across the batch. We might lose this benefit if we m=
ake
> multiple calls to zswap_compress() to ask the hardware accelerator to
> batch compress in smaller batches. Compression throughput would also
> be sub-optimal.

I guess it wouldn=E2=80=99t be an issue if both ZSWAP_MAX_BATCH_SIZE and
pool->compr_batch_size are powers of two. As you mentioned, we still
gain improvement with ZSWAP_MAX_BATCH_SIZE batching even when
pool->compr_batch_size =3D=3D 1, by compressing pages one by one but
batching other work such as zswap_entries_cache_alloc_batch() ?

>
> In my patch-series, the rule is simple: if an algorithm has specified a
> batch-size, carve out the folio by that "batch-size" # of pages to be
> compressed as a batch in zswap_compress(). This custom batch-size
> is capped at ZSWAP_MAX_BATCH_SIZE.
>
> If an algorithm has not specified a batch-size, the default batch-size
> is 1. In this case, carve out the folio by ZSWAP_MAX_BATCH_SIZE
> # of pages to be compressed as a batch in zswap_compress().

Yes, I understand your rule. However, having two global variables is still
somewhat confusing. It might be clearer to use a single variable with a
comment, since one variable can clearly determine the value of the other.

Can we get the batch_size at runtime based on pool->compr_batch_size?

/*
 * If hardware compression supports batching, we use the hardware step size=
.
 * Otherwise, we use ZSWAP_MAX_BATCH_SIZE for batching, but still compress
 * one page at a time.
 */
batch_size =3D pool->compr_batch_size > 1 ? pool->compr_batch_size :
             ZSWAP_MAX_BATCH_SIZE;

We probably don=E2=80=99t need this if both pool->compr_batch_size and
ZSWAP_MAX_BATCH_SIZE are powers of two?

>
> >
> > I don=E2=80=99t quite understand why you want to save
> > ZSWAP_MAX_BATCH_SIZE - X resources, since even without hardware
> > batching
> > you are still allocating all ZSWAP_MAX_BATCH_SIZE resources. This is th=
e
> > case for all platforms except yours.
>
> Not sure I understand.. Just to clarify, this is not done to save on reso=
urces,
> rather for the reasons stated above.
>
> We are already saving on resources by only allocating only
> "pool->compr_batch_size" number of resources
> (*not* ZSWAP_MAX_BATCH_SIZE resources):
>
>         pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
>                                      crypto_acomp_batch_size(acomp_ctx->a=
comp));
>
> For non-Intel platforms, this means only 1 dst buffer is allocated, as
> explained in the commit log for this patch.

you are right. I misunderstood your code :-)

>
> " A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
> Yosry's suggestion. pool->compr_batch_size is set as the minimum of the
> compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE. Accordingly, it
> proceeds to allocate the necessary compression dst buffers in the
> per-CPU acomp_ctx."

This is fine, but it still doesn=E2=80=99t provide a strong reason for havi=
ng
two global variables when one can fully determine the value of the other.

Thanks
Barry
