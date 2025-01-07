Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3933FB1B
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jan 2025 01:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736214403; cv=none; b=hdB8W2WqsdERaDnCM2ucPDAEyCOLbU62ue5Tbe1L518P7fzCvGJXh6yi9w720FYYp4oZbIPVJTTop9955igs2b7EPTWyLEuPKk8O+LCKcAoU97h7C/S+GGwkW4qCxEGIQFfFibKKGVD6aKsjm1iNRwqoQ20Z2HxOvFrw5ml3/HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736214403; c=relaxed/simple;
	bh=vkE6xYkQ90T2bE7ce31y7258jnu53txD5JDC+K0WTo4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UkX8cO0two5qlcH7lHNO1bfQp9V234F/7FJ1F2dL0Vbf4NQtrrGMJ2e5naK1lzm/rUpfYo0cdYQIRaU9a+o7m4QAEg6E6gyPCuPtxoU/yHv74vZOfY644lcO+E2uItiSsPIbmTJRMIx9SFzdyhxOL22FrVQaDizlHQDfqt9qlg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yppjLr7c; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yppjLr7c"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6dd1b895541so123206856d6.0
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jan 2025 17:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736214398; x=1736819198; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SSvF6aUL1JCiB9c4ONJk1avFv1g15BMehNQIcAJ9VWI=;
        b=yppjLr7cZe1P/HTdFSHrJSWLC6VrHAYDSQ1w7XsqorU78h9oe6q8rGHH87QViYpEdJ
         GdunWlKlxiPiiz9f37oVzlobrEC3A9KWWgIjOtB1yo+oKSgdAPNQ745mmXvrn+RKEGTQ
         Tf8Im9Bm4CtBSYeMSaQ75AY0WL60yF8MlItHL/Po7aLZW9B3H3xhWiUy5xVQq9KNghP7
         N273Cw5P1QrI1SCxYHMvl2Q5yDeqVVrtkVtGMtdxMgf0Lk40gobg6T+lNQGx4PWQA/xI
         OVT6iZrfNb1zqUbuEf2DBP11G4WFJrMIZkOk15Ood3G3x/66VEFjl37/IX7zGmGGptdv
         qpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736214398; x=1736819198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SSvF6aUL1JCiB9c4ONJk1avFv1g15BMehNQIcAJ9VWI=;
        b=w3aDnmftf7jkrMz3TfSO/XwydtC9cAlTlr4ufv+y2mV8s45WZZKHxweQhucwK26ivC
         RpUyn9Mred9ee3W6+ALg3B4129ib4QpJk1hNet2qHorIMgSzn2lXHjfAIxiLEizJFJv5
         DJvyWaKIlKwBD9KdoPRUowLnfwXlPGyQcHEsICOOl4Pk0GJGu7MJZMEAZc/ZaQPZi1Wy
         m9ndhElCzHPT14X1HVu4HhUVMk8gKKqf64oZV9e3f6yqdLwZbZ5N5wPXI26HT9sbxw5p
         p4NljIn0aEmU/cXR+s1ft08rz0bljE2g3OLBDAnuI3/serEkYLXXV1o9PyL3ETZYyYjA
         /1gQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSvIKiU0II2QK1bZD9igDL0uoiOqyexRee+Ar1FRuw0hkGEFyy7BXfwxb4GOEUqu+MEx/w+TcPilkvDss=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWooavt+IIlleEuw79e4nga94KvH8+5tsc/EzYUib6PUZpKjkz
	Or99k2gIuIvfxXl8jH/AvnpxpwjFy043XbIgvVoldJ3pTV1nGOiQW0M1ffTOBXUoUbmWETaf2FL
	YtOQJH163Bx7IMiPWsBa30kUg1xo3r8g5Ty5t
X-Gm-Gg: ASbGncuu0xHFd0Hjj0zHDlz3E/lrJTSEe8gCQRf72b6zlLX3GvU97An7PivbPZ02DEP
	oJF/jouFQW0r0UXLcZ5Q7TaHGEF4knUWH4c0=
X-Google-Smtp-Source: AGHT+IEwpsyifEEIEbyhRdZDI+y3x50tfrUBIzAywjmI0EsmGB8yKBkYHmbO7tJ7+yTmILhlwwvUaICr742dC2q070o=
X-Received: by 2002:ad4:5c6c:0:b0:6d8:a856:133 with SMTP id
 6a1803df08f44-6dd233360b9mr950996906d6.12.1736214398209; Mon, 06 Jan 2025
 17:46:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com> <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com> <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 6 Jan 2025 17:46:01 -0800
X-Gm-Features: AbW1kvb2Q3lSJydrqEOf5nKTy60L3z1n1kh8dAM1JigeuXwhiTh0sh6huNfEx1k
Message-ID: <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
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

On Mon, Jan 6, 2025 at 5:38=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
> Hi Yosry,
>
> > -----Original Message-----
> > From: Yosry Ahmed <yosryahmed@google.com>
> > Sent: Monday, January 6, 2025 3:24 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>; linux-
> > kernel@vger.kernel.org; linux-mm@kvack.org; hannes@cmpxchg.org;
> > nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.=
com>;
> > Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
> > compress/decompress batching.
> >
> > On Mon, Jan 6, 2025 at 9:37=E2=80=AFAM Sridhar, Kanchana P
> > <kanchana.p.sridhar@intel.com> wrote:
> > >
> > > Hi Herbert,
> > >
> > > > -----Original Message-----
> > > > From: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Sent: Saturday, December 28, 2024 3:46 AM
> > > > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > > > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > > hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> > > > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > > > ryan.roberts@arm.com; 21cnbao@gmail.com; akpm@linux-
> > foundation.org;
> > > > linux-crypto@vger.kernel.org; davem@davemloft.net;
> > clabbe@baylibre.com;
> > > > ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> > > > Kristen C <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> > > > <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> > > > Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces=
 for
> > > > compress/decompress batching.
> > > >
> > > > On Fri, Dec 20, 2024 at 10:31:09PM -0800, Kanchana P Sridhar wrote:
> > > > > This commit adds get_batch_size(), batch_compress() and
> > > > batch_decompress()
> > > > > interfaces to:
> > > >
> > > > First of all we don't need a batch compress/decompress interface
> > > > because the whole point of request chaining is to supply the data
> > > > in batches.
> > > >
> > > > I'm also against having a get_batch_size because the user should
> > > > be supplying as much data as they're comfortable with.  In other
> > > > words if the user is happy to give us 8 requests for iaa then it
> > > > should be happy to give us 8 requests for every implementation.
> > > >
> > > > The request chaining interface should be such that processing
> > > > 8 requests is always better than doing 1 request at a time as
> > > > the cost is amortised.
> > >
> > > Thanks for your comments. Can you please elaborate on how
> > > request chaining would enable cost amortization for software
> > > compressors? With the current implementation, a module like
> > > zswap would need to do the following to invoke request chaining
> > > for software compressors (in addition to pushing the chaining
> > > to the user layer for IAA, as per your suggestion on not needing a
> > > batch compress/decompress interface):
> > >
> > > zswap_batch_compress():
> > >    for (i =3D 0; i < nr_pages_in_batch; ++i) {
> > >       /* set up the acomp_req "reqs[i]". */
> > >       [ ... ]
> > >       if (i)
> > >         acomp_request_chain(reqs[i], reqs[0]);
> > >       else
> > >         acomp_reqchain_init(reqs[0], 0, crypto_req_done, crypto_wait)=
;
> > >    }
> > >
> > >    /* Process the request chain in series. */
> > >    err =3D crypto_wait_req(acomp_do_req_chain(reqs[0],
> > crypto_acomp_compress), crypto_wait);
> > >
> > > Internally, acomp_do_req_chain() would sequentially process the
> > > request chain by:
> > > 1) adding all requests to a list "state"
> > > 2) call "crypto_acomp_compress()" for the next list element
> > > 3) when this request completes, dequeue it from the list "state"
> > > 4) repeat for all requests in "state"
> > > 5) When the last request in "state" completes, call "reqs[0]-
> > >base.complete()",
> > >     which notifies crypto_wait.
> > >
> > > From what I can understand, the latency cost should be the same for
> > > processing a request chain in series vs. processing each request as i=
t is
> > > done today in zswap, by calling:
> > >
> > >   comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx-
> > >reqs[0]), &acomp_ctx->wait);
> > >
> > > It is not clear to me if there is a cost amortization benefit for sof=
tware
> > > compressors. One of the requirements from Yosry was that there should
> > > be no change for the software compressors, which is what I have
> > > attempted to do in v5.
> > >
> > > Can you please help us understand if there is a room for optimizing
> > > the implementation of the synchronous "acomp_do_req_chain()" API?
> > > I would also like to get inputs from the zswap maintainers on using
> > > request chaining for a batching implementation for software compresso=
rs.
> >
> > Is there a functional change in doing so, or just using different
> > interfaces to accomplish the same thing we do today?
>
> The code paths for software compressors are considerably different betwee=
n
> these two scenarios:
>
> 1) Given a batch of 8 pages: for each page, call zswap_compress() that do=
es this:
>
>         comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
s[0]), &acomp_ctx->wait);
>
> 2) Given a batch of 8 pages:
>      a) Create a request chain of 8 acomp_reqs, starting with reqs[0], as
>          described earlier.
>      b) Process the request chain by calling:
>
>               err =3D crypto_wait_req(acomp_do_req_chain(reqs[0], crypto_=
acomp_compress), &acomp_ctx->wait);
>         /* Get each req's error status. */
>         for (i =3D 0; i < nr_pages; ++i) {
>                 errors[i] =3D acomp_request_err(reqs[i]);
>                 if (errors[i]) {
>                         pr_debug("Request chaining req %d compress error =
%d\n", i, errors[i]);
>                 } else {
>                         dlens[i] =3D reqs[i]->dlen;
>                 }
>         }
>
> What I mean by considerably different code paths is that request chaining
> internally overwrites the req's base.complete and base.data (after saving=
 the
> original values) to implement the algorithm described earlier. Basically,=
 the
> chain is processed in series by getting the next req in the chain, settin=
g it's
> completion function to "acomp_reqchain_done()", which gets called when
> the "op" (crypto_acomp_compress()) is completed for that req.
> acomp_reqchain_done() will cause the next req to be processed in the
> same manner. If this next req happens to be the last req to be processed,
> it will notify the original completion function of reqs[0], with the cryp=
to_wait
> that zswap sets up in zswap_cpu_comp_prepare():
>
>         acomp_request_set_callback(acomp_ctx->reqs[0], CRYPTO_TFM_REQ_MAY=
_BACKLOG,
>                                    crypto_req_done, &acomp_ctx->wait);
>
> Patch [1] in v5 of this series has the full implementation of acomp_do_re=
q_chain()
> in case you want to understand this in more detail.
>
> The "functional change" wrt request chaining is limited to the above.

For software compressors, the batch size should be 1. In that
scenario, from a zswap perspective (without going into the acomp
implementation details please), is there a functional difference? If
not, we can just use the request chaining API regardless of batching
if that is what Herbert means.

>
> [1]: https://patchwork.kernel.org/project/linux-mm/patch/20241221063119.2=
9140-2-kanchana.p.sridhar@intel.com/
>
> Thanks,
> Kanchana
>
