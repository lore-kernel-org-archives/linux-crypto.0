Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA972219EB
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jan 2025 03:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736219493; cv=none; b=FE/BQ0ILslWpPFgjT798Gjq8g7APy43AdRsofumB08OMHUezVP0HAQrSaeY7JeX0CyyxWxUw2qipEQ8kqerf0s1zG5aWwEaA/eJ9WfKPjcr683Sd8rnFIfC+/gshPo223N9LlVpcgx0EC1JJ5P65dhghD6Ulx10pby6iT813Xac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736219493; c=relaxed/simple;
	bh=HP1mgpelsYvb9vpvczphOCFhOvy4RKgTM4GFnR3ClHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ccOiOIFPXpnbSIXOpa5rnZ25kGAdnaqEYdS2hrRQupdMQm9Stp7ck7TTETNIbPbm1yfE8IDp5jkHsHmzrak9E8CDNsXbD45sbKN/ul/eu87H8nvN0zPhGkIHEyMLja2yctuaEDcKk2ouiMsSL6Lt/B6KgadI4Z71Bow2oFvz4LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yx35ne3X; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yx35ne3X"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6d8fa32d3d6so91456646d6.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jan 2025 19:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736219490; x=1736824290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gE5ypbffUfoAThIHdIK+6dHWsg9uuohAx51QktBl09Y=;
        b=Yx35ne3XYwNi1wydZ6r6cPtzsAL4wiSKX5lp7CY+H5EckQFF+Ms+eXmKrK+Yu/SW2q
         d103L3B0K9cBzgnMRy/ZQRsG49ToVtjtn7tnug1yvIH2lJ/zpnnHaqYE3WicG7I/Hp8a
         G+tSGDEc+fa6Eg12CYUfif0DLINaocM4YoNlYQaECDrCq0YBW4LQ+Llb2b35UElHTBn5
         vQHhsDPKm33e+9aGjxLV6b3WxukHBXFPeuCV5LdoHK/xx70HHQxgT2rwOLdTCjUwy8Pd
         1wE3VqsSlgT93B8gLYtBFkVGXP/TGH/7/pneJNJhrN+XX1wWuE4LGman36YpBVl0kDmu
         yO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736219490; x=1736824290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gE5ypbffUfoAThIHdIK+6dHWsg9uuohAx51QktBl09Y=;
        b=YUNiAGbPd45zE1oF136gSoCYna9Wy/+VmL5s16ZgMmgKql/84Pq2ElBaT/HhiJ2hw2
         rlBA/1Rc5zCjsCY2yvCbsh4pTUdFDB4iF3XdqhX/fTZHv8gO8ZThsTnLibo2wkWAZKP4
         AXKBXzRhZCkEHIeTkim47YsCExQGcrScMUKEVYRDZjEiJf8P8WyJEGLlk/ZRxf/d7V0A
         ihzSbDYoK7EBzVF/LH2Pq6uiFgYvUbCN4eCmQsGm7lZKkTR42dE6l67QjFsHqKwahi0+
         3/y3IHPYRVHW4pTyuNWF4un+2Tp59h4D91X0Q89v0nSUq46N9+iwM+tZswvoGW3wvUf1
         vSVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZxT4/GoscKNREfRTVJetmqdxV+TpNj2Sa9Ky8l2rVYab4QKZb0ubjDoqzSF0n90qTsy81n71l4fBLja8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwS7kS28A55OUXoWsd3rP4q7biyhPI92Dmf89fXR7k0yEVz9jEH
	aa09u6QwLntoRmZjTSbpzx8zmoL+LtVZIaf0I84cU5WVqmQHSyng/i9qYwRaocIBBSEYCGY8ymY
	zVjWlMU7nvzos+mhk9YTJeGIsoolQJDNpRBfc
X-Gm-Gg: ASbGncudkT6Ps9LpRlLoQlwJXoy2D2Y1qQFCYjoJZ+/kfTKZ5s8z9Basc81eQMoc9Q5
	wDt1qDPSfQABP15eTZfhO+fhr+bFiyzjkdEA=
X-Google-Smtp-Source: AGHT+IFVXknZEvt8igRM3wvLzBIPpfNMtnOcFqLRi59emyfyupDg6t6qV4JZSXpUNXCDaqYAjML3enasHgO66pxFHxI=
X-Received: by 2002:a05:6214:250e:b0:6d8:d5f6:8c75 with SMTP id
 6a1803df08f44-6dd2334bcd5mr968244066d6.12.1736219490413; Mon, 06 Jan 2025
 19:11:30 -0800 (PST)
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
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com> <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
In-Reply-To: <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 6 Jan 2025 19:10:53 -0800
X-Gm-Features: AbW1kvYntz8quKXkVFcoTtGmO5nXA5-Ug3kgb4M7u5Msx8CwqjwBgpahBqKjzSU
Message-ID: <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
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

On Mon, Jan 6, 2025 at 6:06=E2=80=AFPM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> On Mon, Jan 06, 2025 at 05:46:01PM -0800, Yosry Ahmed wrote:
> >
> > For software compressors, the batch size should be 1. In that
> > scenario, from a zswap perspective (without going into the acomp
> > implementation details please), is there a functional difference? If
> > not, we can just use the request chaining API regardless of batching
> > if that is what Herbert means.
>
> If you can supply a batch size of 8 for iaa, there is no reason
> why you can't do it for software algorithms.  It's the same
> reason that we have GSO in the TCP stack, regardless of whether
> the hardware can handle TSO.

The main problem is memory usage. Zswap needs a PAGE_SIZE*2-sized
buffer for each request on each CPU. We preallocate these buffers to
avoid trying to allocate this much memory in the reclaim path (i.e.
potentially allocating two pages to reclaim one).

With batching, we need to preallocate N PAGE_SIZE*2-sized buffers on
each CPU instead. For N=3D8, we are allocating PAGE_SIZE*14 extra memory
on each CPU (56 KB on x86). That cost may be acceptable with IAA
hardware accelerated batching, but not for software compressors that
will end up processing the batch serially anyway.

Does this make sense to you or did I miss something?

>
> The amortisation of the segmentation cost means that it will be
> a win over-all.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
