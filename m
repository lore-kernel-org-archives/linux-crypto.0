Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD36520125D
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 21:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733262279; cv=none; b=YG7TTsKySx/kN5KoOCxLBZnrTt9WDAEhOqgvQi32k98ETLCjMVJmkL3N2Rtn/tKpxCpU4u5it9q3ngn4m/7ePxvSpvwktS4/LbFmRVqFduuh5RGn0v0aYVLN9Y/CTBJUmaUc0D2yUEPaNOCnN25tRonlUQQ8NcmGLsO1tfgOpL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733262279; c=relaxed/simple;
	bh=P3yEmkWYGA79algR4tDOhbLBkOs5sl45A0XdKdNUM3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n96cy+B9SKuebtyaIE5o+5WsUy+gN34cEILQbA0tnQXnR+cBtJmHRo829e8p+jur4N3NkS4V3eZmdrcpbh/tYeKKqfZsUmom/1wse6Fty1qIPDRrbFFu2kyL8B7qopWKYOiq1poPJCF8SA9N73N/anvx8XZaZQd6kNSwcb/K88Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w0hLgnPM; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w0hLgnPM"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6d882619044so38080276d6.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2024 13:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733262276; x=1733867076; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vm0D9iLih6NVgJOSSK56eoyE8s/0Ie0xteOxyeVsYIs=;
        b=w0hLgnPMsycx391yugiXm+7C04OWI/TKubbjT1ialJhIZnc0aQlsFmkwGWA9ipOsDd
         9zeXX+7i9ku3f9yhxajfRQEzkBqoQMiYafmkV9831SkT1X7H5CsTCQSpPBYY16lfqktg
         aQbvOct1GuITGfELAM3VEApnFAcCZVLV/76xXl/NvY+jyc/j3ISncnW0VF0eFREVpbaC
         7GdGMOHHhlMJWFGInZo1+HO0xNWmK6pdaezrnZfD/VyJN/asXxHb0xbgVDPpiVW9LmcD
         9AOE++5CwB9dZrRK0UKwYOTiFGFPlhRK4KFqAruolC2UY/H3RY9lxN6lodeSlko3qdoE
         ZQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733262276; x=1733867076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vm0D9iLih6NVgJOSSK56eoyE8s/0Ie0xteOxyeVsYIs=;
        b=qIlm0j3hd4UFtfRGOUmoz6q/IqUWlMpXSyvkH3JQIN8LIiutbbZo3gq/npU8NjBXjI
         NqHTaqAMbKvngEX8CXJr7Vt8O7GiR12KHd35Y13LrrQVTu7+6KL1f6dCwc2hDX3oKmUQ
         QWLoMrcg4sRfORfJ1SNh5HIPJbJGGsolJO3rfqg9HrTfTCEK3ZNzZxs4pmqkyhj3AOoI
         xSe9xzokCdHucxDf3g4ZTz/0L+SwS8oIMQ/BfLsmG62eVKeWJpOxHKTajNhGFHV+L0Tk
         hFxvKdBHiwWi68Bvhp6SuTO6UPxvNq86QTGqfkykrvGxeZI3ww9ldCaI9InIhbVk4y7V
         zibg==
X-Forwarded-Encrypted: i=1; AJvYcCXg6dJsp6K1IWZ+H5QzNrJFmkpUa9FOsXX4v66fSSJ2AzocNgjZjo1VSIp4/XHtHUaMZDDheJ58NLvzRDY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMjtKjr1ksfvf27uoHoOEAYMD4rwWccOqGt39KHOypBsXPglg0
	T1oV9s1538p/11Ci6et2C/Bn+Li5i1drNcvjY4V69pys5o+YJpIiDadPIVEipIdb8T/ZGIGc79k
	3hExXcu5vzAr9GnRSy90lROd+L+0fiYtbw5Gp
X-Gm-Gg: ASbGncsej8avpVgkzzVoZJA87PAE4rc0cZLYCkSZBAsRVQBwVWgQ0KORXQPf5qTpNCn
	4FTUU3uRHqqOnU5VFEkbRKCGxE6Qp
X-Google-Smtp-Source: AGHT+IElgjsMKzyb8pB6S2q5z1oqGiduDeQK5SqLnhC4d+BQTcWkNixPgmGxlQy2kLoTb/AFWhq1uk9LZWaoSMS148s=
X-Received: by 2002:a05:6214:5183:b0:6d8:a84b:b50d with SMTP id
 6a1803df08f44-6d8c46bd285mr28938446d6.33.1733262276441; Tue, 03 Dec 2024
 13:44:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-10-kanchana.p.sridhar@intel.com> <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
 <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <Z066p53LoISwqkmX@gondor.apana.org.au> <SJ0PR11MB5678AAEF4F62773847E6307FC9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5678AAEF4F62773847E6307FC9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 3 Dec 2024 13:44:00 -0800
Message-ID: <CAJD7tkbui2MTkkGA6_+RDA0oZW2m3rMnUTKp1Fp6tPqp2QLgKw@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Nhat Pham <nphamcs@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"ying.huang@intel.com" <ying.huang@intel.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 1:37=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Tuesday, December 3, 2024 12:01 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: Nhat Pham <nphamcs@gmail.com>; linux-kernel@vger.kernel.org; linux-
> > mm@kvack.org; hannes@cmpxchg.org; yosryahmed@google.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; ying.huang@intel.com; 21cnbao@gmail.com;
> > akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.=
com>;
> > Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v4 09/10] mm: zswap: Allocate pool batching resourc=
es if
> > the crypto_alg supports batching.
> >
> > On Tue, Dec 03, 2024 at 12:30:30AM +0000, Sridhar, Kanchana P wrote:
> > >
> > > > Why do we need this "can_batch" field? IIUC, this can be determined
> > > > from the compressor internal fields itself, no?
> > > >
> > > > acomp_has_async_batching(acomp);
> > > >
> > > > Is this just for convenience, or is this actually an expensive thin=
g to
> > compute?
> > >
> > > Thanks for your comments. This is a good question. I tried not to imp=
ly that
> > > batching resources have been allocated for the cpu based only on what
> > > acomp_has_async_batching() returns. It is possible that the cpu onlin=
ing
> > > code ran into an -ENOMEM error on any particular cpu. In this case, I=
 set
> > > the pool->can_batch to "false", mainly for convenience, so that zswap
> > > can be somewhat insulated from migration. I agree that this may not b=
e
> > > the best solution; and whether or not batching is enabled can be dire=
ctly
> > > determined just before the call to crypto_acomp_batch_compress()
> > > based on:
> > >
> > > acomp_ctx->nr_reqs =3D=3D SWAP_CRYPTO_BATCH_SIZE;
> >
> > With ahash request chaining, the idea is to accumulate as much
> > data as you can before you provide it to the Crypto API.  The
> > API is responsible for dividing it up if the underlying driver
> > is only able to handle one request at a time.
> >
> > So that would be the ideal model to use for compression as well.
> > Provide as much data as you can and let the API handle the case
> > where the data needs to be divided up.
>
> Thanks for this suggestion! This sounds like a clean way to handle the
> batching/sequential compress/decompress within the crypto API as long
> as it can be contained in the crypto acompress layer.
> If the zswap maintainers don't have any objections, I can look into the
> feasibility of doing this.

Does this mean that instead of zswap breaking down the folio into
SWAP_CRYPTO_BATCH_SIZE -sized batches, we pass all the pages to the
crypto layer and let it do the batching as it pleases?

It sounds nice on the surface, but this implies that we have to
allocate folio_nr_pages() buffers in zswap, essentially as the
allocation is the same size as the folio itself. While the allocation
does not need to be contiguous, making a large number of allocations
in the reclaim path is definitely not something we want. For a 2M THP,
we'd need to allocate 2M in zswap_store().

If we choose to keep preallocating, assuming the maximum THP size is
2M, we need to allocate 2M * nr_cpus worth of buffers. That's a lot of
memory.

I feel like I am missing something.

>
> Thanks,
> Kanchana
>
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
