Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5D314B950;
	Fri, 29 Aug 2025 03:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756438947; cv=none; b=IRmgSvMgeoUhlLbURxWr2yluJoRr5qdD5MY93AxnzCzMPQY6Q71r7q/6HDsHEAIMXNCnoYTIAN5EZmtgC5kD1oDVAb3AEuOwT48F5dVKJfVtFrIwkPHsE4tqvoCs6ujNxfEzHcKBoIq3VZtQs5Eal9Tkj9VAcZARD6dmnY2vhK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756438947; c=relaxed/simple;
	bh=6fNrWrma2TvfnDCrV5tcoa30XomGjB08+JDxmWxOdKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Aky2ikb5msO8FT4hIsWWD36OPeQt1mU3c65IFzvaqAFEcHIQ+sE1RbvTXjd45o5vU1UwAi2HW2zOi6YscTyOiSmEwvGf9xNwEgYIqIHFIX3zqbgO119hSsGjpDr37VPtIggfKvjRzSLOtjpMa1k5802rWhTtr2eBTKPqKJSxfLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YZ/tRxC4; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YZ/tRxC4"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7f84c17078fso156780085a.1;
        Thu, 28 Aug 2025 20:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756438945; x=1757043745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9nsLcz9oLPq6b5kinEZVYxfA3jpb2WrADy8yf5QiW8=;
        b=YZ/tRxC4TTwH7xCCwumRME5mh/mDipsdDdHDEukNNjRNzVfpJQOWNWU3qXOC4kEalv
         bgEB0vB1Gn9EZ/0w3yJFmR8HWiTIH2eS7OYSBtQYAuNhZBmso1lX57qvvkvsjph1wBDj
         zoRebcOupOzFBRuRVUk0QUYiC9wlXixy6SGEknOiK7g9pJlIaHMnKzjPp9s9QWS49L6x
         FZFG6oaW2Sp5OkyVvXjoeVY0cFbdRIEmY1m3Z9JoY/Zgr45Co7Q2tuwOQuEPLw8ACnmY
         7/BcPZ+B6sqcQUIdczeix995yg3hKsBRmQq75jZ3VSrUTzOB5nN+wcXr9ko9KKz/CvwT
         CvUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756438945; x=1757043745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9nsLcz9oLPq6b5kinEZVYxfA3jpb2WrADy8yf5QiW8=;
        b=i3d3eU0VnsLcGQq2Pqy4bnQQXs5niuXakVKBFpejoKyHd6ScFFD0TeJ/qh3wnqB0dO
         mmlgL3KvXnlpzA13LT4rXYeSt17fGvrpMRLVFyNJA+avUpcxb+iBBrCWIR3j21HxQxBB
         I9xCywmz07Yhfu4VBjxU9FV/oS3SJ1reNMEsgNV3Mt8v5kZErRitgwVol0ipnpf2bYpd
         obFEZAuObJ+uuRuqZd0uEeuPIz/sjNXt3TAkY3fTramO1cUxNXlt+ffViDSJA9z6qaIx
         XdhP1ZUkJpXBT/knYJszHpnW3czoBuaj4w0Znci3TnfT4/ktmDWrETOXXrEa9EUf4ZFX
         nUMw==
X-Forwarded-Encrypted: i=1; AJvYcCVzie6/12DlNNCXY2TTQ2rQxrTepH6mLL572vXVfROJwKl9TRDPmxU21dzcleIyCdDvzbsgDudIXHHoNRk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcd0tsl5f0D/eY96yrEQcjJHEmTZ+7o07A2DgmM7N+P/HyHECo
	H1E77hGmNAgWRWPsDkQsHJu/nSOP0QU9V83O/Tx11O8oPjLl+3UC3KTOp8qEbu+kPTXdsi5xUeW
	1LfFaQQFBTrJ3l6iKa1yx2hfGsZ8/eE4=
X-Gm-Gg: ASbGncsoEWwE72G7lYJNQDyYyJdNufk505CNf2FZ/e2W3sEWgjWG+vi8OMYh4X+oA7g
	pgSJBTJxvj8PtuF/+fb95YaP5wLbDQFBg5qLu3AYxDGFzEjQMqDwoRgFCqxGOfPUFOc30PMLPF7
	dtgKhOxQ6kZfz4webfkMc7ToZywHfHaOsn2hBHM9kpF60Srpe5rm14F6aTaTtflwVDlJXsX6Udx
	07uufA=
X-Google-Smtp-Source: AGHT+IHSLkm5K+k2w+6sBnrX/gOo2iWdZK+eBp5voDRHxu9SAC/ISPssrMgLw4Sv4FNHTUzekbupzxvNT+r7HLHqU3g=
X-Received: by 2002:a05:620a:394b:b0:7e8:2c22:8e0e with SMTP id
 af79cd13be357-7ea1107cbabmr3284967285a.49.1756438944142; Thu, 28 Aug 2025
 20:42:24 -0700 (PDT)
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
 <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com>
 <PH7PR11MB81211DD54822167C6BA238D5C93BA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xy3mksbwj61qnNrSpcFgkanEK0tCzJcjQgVF-oAyXe8A@mail.gmail.com> <PH7PR11MB81216DFB4CA6F22E0ED76026C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81216DFB4CA6F22E0ED76026C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 11:42:12 +0800
X-Gm-Features: Ac12FXyg8yM_nrW9tpGwrsqMNR1iGLArF5rK3V7hQyzvGqOBzOtw6u8bvrLvgxg
Message-ID: <CAGsJ_4zMHtYG3rS61PyGfJYd8KwGEw=Gy=g5s5wT_vrEL9fhbA@mail.gmail.com>
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

On Fri, Aug 29, 2025 at 10:57=E2=80=AFAM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Barry Song <21cnbao@gmail.com>
> > Sent: Thursday, August 28, 2025 4:29 PM
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
> > > >
> > > > If ZSWAP_MAX_BATCH_SIZE is set to 8 and there is no hardware batchi=
ng,
> > > > compression is done with a step size of 1. If the hardware step siz=
e is 4,
> > > > compression occurs in two steps. If the hardware step size is 6, th=
e first
> > > > compression uses a step size of 6, and the second uses a step size =
of 2.
> > > > Do you think this will work?
> > >
> > > Hi Barry,
> > >
> > > This would be non-optimal from code simplicity and latency perspectiv=
es.
> > > One of the benefits of using the hardware accelerator's "batch parall=
elism"
> > > is cost amortization across the batch. We might lose this benefit if =
we make
> > > multiple calls to zswap_compress() to ask the hardware accelerator to
> > > batch compress in smaller batches. Compression throughput would also
> > > be sub-optimal.
> >
> > I guess it wouldn=E2=80=99t be an issue if both ZSWAP_MAX_BATCH_SIZE an=
d
> > pool->compr_batch_size are powers of two. As you mentioned, we still
> > gain improvement with ZSWAP_MAX_BATCH_SIZE batching even when
> > pool->compr_batch_size =3D=3D 1, by compressing pages one by one but
> > batching other work such as zswap_entries_cache_alloc_batch() ?
> >
> > >
> > > In my patch-series, the rule is simple: if an algorithm has specified=
 a
> > > batch-size, carve out the folio by that "batch-size" # of pages to be
> > > compressed as a batch in zswap_compress(). This custom batch-size
> > > is capped at ZSWAP_MAX_BATCH_SIZE.
> > >
> > > If an algorithm has not specified a batch-size, the default batch-siz=
e
> > > is 1. In this case, carve out the folio by ZSWAP_MAX_BATCH_SIZE
> > > # of pages to be compressed as a batch in zswap_compress().
> >
> > Yes, I understand your rule. However, having two global variables is st=
ill
> > somewhat confusing. It might be clearer to use a single variable with a
> > comment, since one variable can clearly determine the value of the othe=
r.
> >
> > Can we get the batch_size at runtime based on pool->compr_batch_size?
> >
> > /*
> >  * If hardware compression supports batching, we use the hardware step =
size.
> >  * Otherwise, we use ZSWAP_MAX_BATCH_SIZE for batching, but still
> > compress
> >  * one page at a time.
> >  */
> > batch_size =3D pool->compr_batch_size > 1 ? pool->compr_batch_size :
> >              ZSWAP_MAX_BATCH_SIZE;
> >
> > We probably don=E2=80=99t need this if both pool->compr_batch_size and
> > ZSWAP_MAX_BATCH_SIZE are powers of two?
>
> I am not sure I understand this rationale, but I do want to reiterate
> that the patch-set implements a simple set of rules/design choices
> to provide a batching framework for software and hardware compressors,
> that has shown good performance improvements with both, while
> unifying zswap_store()/zswap_compress() code paths for both.

I=E2=80=99m really curious: if ZSWAP_MAX_BATCH_SIZE =3D 8 and
compr_batch_size =3D 4, why wouldn=E2=80=99t batch_size =3D 8 and
compr_batch_size =3D 4 perform better than batch_size =3D 4 and
compr_batch_size =3D 4?

In short, I=E2=80=99d like the case of compr_batch_size =3D=3D 1 to be trea=
ted the same
as compr_batch_size =3D=3D 2, 4, etc., since you can still see performance
improvements when ZSWAP_MAX_BATCH_SIZE =3D 8 and compr_batch_size =3D=3D 1,
as batching occurs even outside compression.

Therefore, I would expect batch_size =3D=3D 8 and compr_batch_size =3D=3D 2=
 to
perform better than when both are 2.

The only thing preventing this from happening is that compr_batch_size
might be 5, 6, or 7, which are not powers of two?

>
> As explained before, keeping the two variables as distinct u8 members
> of struct zswap_pool is a design choice with these benefits:
>
> 1) Saves computes by avoiding computing this in performance-critical
>     zswap_store() code. I have verified that dynamically computing the
>     batch_size based on pool->compr_batch_size impacts latency.

Ok, I=E2=80=99m a bit surprised, since this small computation wouldn=E2=80=
=99t
cause a branch misprediction at all.

In any case, if you want to keep both variables, that=E2=80=99s fine.
But can we at least rename one of them? For example, use
pool->store_batch_size and pool->compr_batch_size instead of
pool->batch_size and pool->compr_batch_size, since pool->batch_size
generally has a broader semantic scope than compr_batch_size.

Thanks
Barry
