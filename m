Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFF21DB37B
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jan 2025 23:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736205894; cv=none; b=kKmw5I4F/cLkXg0o9VCQ9JlWNFke0+ai15PauDhITF74NTYdquyXbR/1MUHqHqfbTuVZHFLv7AeSoXjoAPyk6n6qX/9qJmG/mXK4VIUW5rXcblEtAmrvKKX/x/FnnGAWcDdfvQHzcT19/1zcN7RgalSBUtLJnL9k8I1Zmn4tsiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736205894; c=relaxed/simple;
	bh=oVl/+D3Bk+0sLTBYRTAp8Sxp098WE+23RntlNThvoGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mesKNF5B3jWvdu7PFAgUrdg2RYkDAqSEakK0KmMtJeYgfROj7WFpXMa0NpfNLDJKfjU3AN3cACXlrM3Xyqq9rhCNaWeRNmeGMMOozeSyifcIZttEvrfCx/55j9GyODyFtbVZ82p37kTHHERx9px+CcBhUPrHUHFCpWCjbxtoU8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HREUaA1z; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HREUaA1z"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6df83fd01cbso7258196d6.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jan 2025 15:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736205892; x=1736810692; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKhRgig6RvBQByFIYLu/f2LHcv9xOxj/hUQxk99BI4o=;
        b=HREUaA1zh9ZQjHqTIpfi1b6NrZhGK76WHJbSq/k6Y7mkn2VWdpDGYxbSzJLe8MRuHQ
         WMcLwHYPfJ9SBYOxhHPI66a1wf1HFJ5A0/WnVQnwJzL1Hp6acRz1Phxpllg7wYVhoHVy
         RPaJK4Zf22webyNVFTBoVXY8veaixP7O5vEXbTVFcahFUZGZVKg4xpGB+ERiFd9XXTWF
         s17NuGGj8VhxaWVkKBRcp3cgQAOIl1KQ5QXUsFa/gBCFoqb5dSa4ntIqaQ467/gpDcqL
         7vlgKI6r6xiPs2te1PNaazmjNWKzIhg3/pvaNPvVLmaKsRnH4s07sMKufRThk3yn6l/p
         g7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736205892; x=1736810692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKhRgig6RvBQByFIYLu/f2LHcv9xOxj/hUQxk99BI4o=;
        b=hzrM5zDxLtRQHh8c8Xjcm+kFIid3hg+v4pjUfZ/qQVPl8IESgfleHcns5LVJO7WpKM
         tqFAuCH9q4UODF8Y5rM1dURG9ljd9I7VKnH67T32BRwvGkF8qOFw90D/jMwGA3g8Uucu
         VNoTzx1IWLmsEqfcK3naoDEk0QHj5rdMjQRmSEjphugHJ+51vot2SuY5UZXBvIMhA9hO
         X9RMinqZD1Wed1UZ/ogFM9BNbMefPhQH5vpGHSkZhJIkfTcYIH+y5PuiuuW2EbPys7J0
         vo6LwcHDCiG5/3k8EBCj6TAIku3VHRZsUr3bMXYRJinXUef20AoJC1//icquL9L75Q/l
         mQyw==
X-Forwarded-Encrypted: i=1; AJvYcCUsCcCksmmDppS+5u/9iFrHHTPdd6vfFvcuQ5EhtyVEZbA4nQOfNl6G6yxjZsg0qNTjyobnzY/Gdgh0d6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOvzjya6i79Pyex/pqTG+Jc8JO12lY3+gUf0PKe8O+Zs/iwk0P
	65tqPVMxu04wkbKZ/0bFIELhwO5hQAvU87teZ6Q25So5s307ZybmUh5s7NZ4GWWpckOTi2W50jL
	mj5IXEc3zo3Htl9awFGmynWJ+Hms0S/TLI7Dx
X-Gm-Gg: ASbGncvqSuX+igbcwlfOegSx0kk+IQW6grEOh6xUm/gZroshR+/ucdIdPIETu04MKo6
	TPJf8QK1oSLsmmNsAAbHW4z7bWcqIQ5qmQEk=
X-Google-Smtp-Source: AGHT+IG9zmeZwtyOnsnBkMeqJ3xK/tqIzpoFJqb89Dat0pQ9PmlCCaYsopKI0if6B3TNWI/WoZHecfDyZLZEo6Y5G7s=
X-Received: by 2002:ad4:5aad:0:b0:6d8:d5f6:8c72 with SMTP id
 6a1803df08f44-6dd2332e380mr1041760026d6.19.1736205891701; Mon, 06 Jan 2025
 15:24:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com> <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 6 Jan 2025 15:24:15 -0800
X-Gm-Features: AbW1kvY1DpYZkUogZ-GyezP9HOYgzr8x3sGsVp-x_34VwwGW0DIzItdsD6GWGO0
Message-ID: <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 6, 2025 at 9:37=E2=80=AFAM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
> Hi Herbert,
>
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Saturday, December 28, 2024 3:46 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; 21cnbao@gmail.com; akpm@linux-foundation.org;
> > linux-crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> > ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> > Kristen C <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
> > compress/decompress batching.
> >
> > On Fri, Dec 20, 2024 at 10:31:09PM -0800, Kanchana P Sridhar wrote:
> > > This commit adds get_batch_size(), batch_compress() and
> > batch_decompress()
> > > interfaces to:
> >
> > First of all we don't need a batch compress/decompress interface
> > because the whole point of request chaining is to supply the data
> > in batches.
> >
> > I'm also against having a get_batch_size because the user should
> > be supplying as much data as they're comfortable with.  In other
> > words if the user is happy to give us 8 requests for iaa then it
> > should be happy to give us 8 requests for every implementation.
> >
> > The request chaining interface should be such that processing
> > 8 requests is always better than doing 1 request at a time as
> > the cost is amortised.
>
> Thanks for your comments. Can you please elaborate on how
> request chaining would enable cost amortization for software
> compressors? With the current implementation, a module like
> zswap would need to do the following to invoke request chaining
> for software compressors (in addition to pushing the chaining
> to the user layer for IAA, as per your suggestion on not needing a
> batch compress/decompress interface):
>
> zswap_batch_compress():
>    for (i =3D 0; i < nr_pages_in_batch; ++i) {
>       /* set up the acomp_req "reqs[i]". */
>       [ ... ]
>       if (i)
>         acomp_request_chain(reqs[i], reqs[0]);
>       else
>         acomp_reqchain_init(reqs[0], 0, crypto_req_done, crypto_wait);
>    }
>
>    /* Process the request chain in series. */
>    err =3D crypto_wait_req(acomp_do_req_chain(reqs[0], crypto_acomp_compr=
ess), crypto_wait);
>
> Internally, acomp_do_req_chain() would sequentially process the
> request chain by:
> 1) adding all requests to a list "state"
> 2) call "crypto_acomp_compress()" for the next list element
> 3) when this request completes, dequeue it from the list "state"
> 4) repeat for all requests in "state"
> 5) When the last request in "state" completes, call "reqs[0]->base.comple=
te()",
>     which notifies crypto_wait.
>
> From what I can understand, the latency cost should be the same for
> processing a request chain in series vs. processing each request as it is
> done today in zswap, by calling:
>
>   comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]),=
 &acomp_ctx->wait);
>
> It is not clear to me if there is a cost amortization benefit for softwar=
e
> compressors. One of the requirements from Yosry was that there should
> be no change for the software compressors, which is what I have
> attempted to do in v5.
>
> Can you please help us understand if there is a room for optimizing
> the implementation of the synchronous "acomp_do_req_chain()" API?
> I would also like to get inputs from the zswap maintainers on using
> request chaining for a batching implementation for software compressors.

Is there a functional change in doing so, or just using different
interfaces to accomplish the same thing we do today?
