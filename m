Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE9F1442F4
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jan 2025 01:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736300656; cv=none; b=FHXNZNY6dIbn+LyC7/HfC5iKD8wrw+xe811X0IDEHTcFsM+tbpwG9u7M9RvAK5eYq7Kwvt0/8DSjRCEqICPyIu8HyMBr5X+ruMFGmuR+eulqUGEeqAmcpX5x2KDCnfYEqzC2H1a+NqMqEC6lUilad3OU3Jld7BeDgmIb1KFIsxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736300656; c=relaxed/simple;
	bh=uQhyMZwrt4mB2NQv+KrtmlFei6zfQ9+WRPjnZLQenPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q3xzawb8/9eHsHaI9r5dGcDjfgOrp9+vaAACPz/PPyxWoLnIGqZIwUfAijRTPhOCwDfWrA87p1y89QMz2YbnZqYDiwV8ovpKodkE2c4JQjODDGbwshY1/CieaGKuvA7xKiX5OFBVAG6ManP7RMnNk/J99CSKja+GPY6FzHsB2Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QjVkTxrl; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QjVkTxrl"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6dcd4f1aaccso104667806d6.2
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jan 2025 17:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736300651; x=1736905451; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHo9hEuef3ERGHHO2rwMA2Af58CDjKtCvUYF4uesulc=;
        b=QjVkTxrlHXL5PImwcQ6Sd1JwWo70HbptEqr6jCk1a2GqlVKoolQJegoZ09ofgaQqSs
         ZcjV8eo6LjDixUVxkvzA8IG6l1P0CcTG7L8m3mCThZNsf3CRLdkAWEb8dj8ptTZ5r5Vz
         ke8SPX25cuCAboAQ2bD0wnRAJwlAhq5+xgeft2MXmURiTHITHdwV9XCJ3a1DMTIgQLab
         YHzR9LOFCekLXS7ucqSWswdWyPR6lvJ1Hui/Fv2rTo9ubQrZYVEz3Bhpz6+pGc8qO8fY
         N0A/RMKztelXbPg6JETaQKUoYOL5PHd0JLQ6/O9CF9GYK5TGoC8KfJoCiCZftKgJKKs3
         hMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736300651; x=1736905451;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gHo9hEuef3ERGHHO2rwMA2Af58CDjKtCvUYF4uesulc=;
        b=twXjR5vrw3EbJkUSiKzqo5mDVg7uKDGBcldTZ4iSs0qGqFXrlphrsrV7LIb54kkBJu
         rON//xJMBVXKN2BzdBh37eJEUghwWgQ1LeVaPMvwN2ypUYUkTVudL//uBZC4rxh5Sqgg
         TmcEkRH1o3dln2xRMZBu2s65rhZ5F0hEzdB7DqeU/jJtWYJHNk+Nd47A8G576HiIdELq
         cfyl4rKxQCis6NgOYzzeUj/1Z8FiE3iHNc9cmhMD+rR0HOK0xL5z2ZLNXMI3gvvO3Hxz
         gdynZP2ev8VRfZEPctkXKMJrfPqpyjEnbm3gEcc1COWInILTCAG2wMvD7cLzcDLG63AO
         pRkA==
X-Forwarded-Encrypted: i=1; AJvYcCUBoa3b0p4vNFuWpaY+40KAfka4maxnc+SlijioMWgUpRazY+GbTTmosMQBh0dcqKbzRYur9HxAiwIbIH8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp5uFITLBq9SImBVo5vKQZvaj/CyloL3loMZr/bFYi3eU5yNFP
	ueUcU81syEegqCQHY9MH8eA36C+6sH35bzoAstfIFDbWPXV0ox59DOfOzNdlrg5n/GKgznd0q0f
	neb5KGQfW/eoNOFbcYvu91c3BPqkNjuTBeK9/
X-Gm-Gg: ASbGncuPZYrIqXPVtuC8dHgqVUvbrptBEdelzLxj9n12xczhKvs6tbj42vdkpqqpB2+
	ZS49fmy1lffxPEQkcfxgpiMezj27PJyRZ2QrTbG+pJKChzMazxLm2XbXCGK0OcFsFO8Fr
X-Google-Smtp-Source: AGHT+IEX5O9W2dy6wtPD3nEP1ySmPfoJdxTB0Bjv81VL5rGDRrVFLLDjZ4XMD9DXqk259cr80NiLawuESt8uEnzFk1c=
X-Received: by 2002:ad4:5d61:0:b0:6d4:dae:6250 with SMTP id
 6a1803df08f44-6df9b28c6aemr22247996d6.34.1736300651023; Tue, 07 Jan 2025
 17:44:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com> <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au> <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z33XKZozGeNM0uxr@gondor.apana.org.au>
In-Reply-To: <Z33XKZozGeNM0uxr@gondor.apana.org.au>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 7 Jan 2025 17:43:34 -0800
X-Gm-Features: AbW1kvbgBXpKidxdPUyw9ZPKdRgCny0iuoA8E6tbrDl9_ptZM6BG2eAm8w4f3c4
Message-ID: <CAJD7tkbSXWp+yU8z-djTSounTh1Pq2MMRqo69=1d_aDAO3wrow@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, 
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
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

On Tue, Jan 7, 2025 at 5:39=E2=80=AFPM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> On Mon, Jan 06, 2025 at 07:10:53PM -0800, Yosry Ahmed wrote:
> >
> > The main problem is memory usage. Zswap needs a PAGE_SIZE*2-sized
> > buffer for each request on each CPU. We preallocate these buffers to
> > avoid trying to allocate this much memory in the reclaim path (i.e.
> > potentially allocating two pages to reclaim one).
>
> What if we allowed each acomp request to take a whole folio?
> That would mean you'd only need to allocate one request per
> folio, regardless of how big it is.

Hmm this means we need to allocate a single request instead of N
requests, but the source of overhead is the output buffers not the
requests. We need PAGE_SIZE*2 for each page in the folio in the output
buffer on each CPU. Preallocating this unnecessarily adds up to a lot
of memory.

Did I miss something?

>
> Eric, we could do something similar with ahash.  Allow the
> user to supply a folio (or scatterlist entry) instead of a
> single page, and then cut it up based on a unit-size supplied
> by the user (e.g., 512 bytes for sector-based users).  That
> would mean just a single request object as long as your input
> is a folio or something similar.
>
> Is this something that you could use in fs/verity? You'd still
> need to allocate enough memory to store the output hashes.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
