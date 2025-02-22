Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183EA35949;
	Sat, 22 Feb 2025 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740241455; cv=none; b=XQ9vVXI1zsdlmz9b1tDWozi//gbeaWHsUW8RWtnn87hGlc8+67W5HhoYFB9ibBHRS8tfWnIXnZ+mp+X6o28GXdUu2j+KxMIRtUZHXkFPpg/6MrVhvJkTDZy2jKEf9s0jz7QsAqsxEP5ffdI1oaGxuqgPr4GwXsZET6qngIGovN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740241455; c=relaxed/simple;
	bh=JGqfqv3BNgeG5pmAT6hUdbLTNBF7gGfSK73mC0aEAIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G9VN4t0eBx9zLGW8wOfOLVibVzTV3o+33LAupgCjxYD6iS2tPu6l9EZ4lkp5t5RahiJ34y6Wgp+Dl67HJ09fKWKaBWGRZs1jK0qPQJxyjznkjoP2qqzNg4Fd+oWRPvVbGAUmvptMrhvrXkufJrpc2sDcAYBXlUrgTFQfnmQF9Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iNOReIa0; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iNOReIa0"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-868e986092cso897929241.0;
        Sat, 22 Feb 2025 08:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740241453; x=1740846253; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sav4wPG9DWPA9l3hgLj0gOmAeBsfhnABFgdC6wlWJKc=;
        b=iNOReIa0BQomCqKRdFJsxxI3Gl7VQccPj67XGqFy7NcLDtl/CjOITcXlMZQ3d9zd60
         rZnMWvEyWidGemRNfcdo68tZhnQEftuRdtHSLrUetWR/SLZvsZJ3akThVGRX8xGDK0cH
         s5xgaAjxcP9WkM6ih5z5CBJdxowuF7neVunAEXgV9jaM9swGtIYwauhOEBiDRDHntSkQ
         1DeyGuU1vtvTOS72stKQTdG2qYsVY76fwKZ29jtZZZ85IGdYGnd+3GffteBQZFZeQ6Ld
         pNdAfcBTf9YOMfsMxxMddlLeQm56/LLNIGIiaUgLSnNy0jPz1iDthavicONk/WWH8c4S
         4bfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740241453; x=1740846253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sav4wPG9DWPA9l3hgLj0gOmAeBsfhnABFgdC6wlWJKc=;
        b=bQu/QhM2kWh2zACZJzR0ZVrghh0ym2vJJyvNxMvshtuyTZ9dRuzEmvjVw+mCkdcJz4
         Y7QYOSXWzQGxDH8McLup4nFst22ExVCXZOqWmtM3JuVWvyeE6Q1J53rpxGcaJL+OnGzb
         AvvcDd+epEGoZLSjzjkvFyquPrD9fIV7Q3DonzuSVw7KM0v3Ec76rxMqakatQafQfy+W
         iNQk62UibaDeAdgB/P9IvUPsEspxr/3SGLD0jWt7w7Y1ZE71YhYi8DygsvuvNJRjlM0i
         Rx/u0rTZ3+DaEw6MnLo0Gz/0AGh5qLMdzMR8VPD9itSXbOOIgiYeZdFjGs/WmoJNye3U
         pwHw==
X-Forwarded-Encrypted: i=1; AJvYcCUGUZoN6W6YI9QyKhdAhLL9R5h3t3I+Hv+wfyyIEDYSwEzuMoR5+DaDQPkzbd0fYxb/sj3B+oUpTYc562n9@vger.kernel.org, AJvYcCUYhAcBpLI4Yq8oWj9vmM5k2iQqkQsOccbb9kRG4kdJw660fZr8AT+betRykVe1qWID544XWkmnO3+N56k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdyWBtNdVKZIHpGqGmI3W3odBIbXShG9r5PZ13yL6WLaXXgVXf
	j1a7cErhsarCoxiCrTzzJ8t/sexuHb1C+yS4x4bTH1NcT2/s+wUad1TA/P98bvPSzJS1MkV5hXe
	Oyqa65mrgqYLshe1WroAMCf1UIkU=
X-Gm-Gg: ASbGncs0e2CR92kWZcUL4Rz4FjES17Uq51+08vEn/BssLfstng5awK+HC36Nw5kMmqJ
	x170x/AIrWZBmfEHrPOBvNntI02isNQFwhS4ECx8bMzdi+HQfq9GACDBVwqZRY65to+ROmV/h70
	H5ufx7tI4=
X-Google-Smtp-Source: AGHT+IExbeBvFGtjLuoasW3NeMshCokZaIOyTX2uf0zaf0oAM379rYmGJUT6WjsAQvdQ7FbzFCOa+pXex4aBHc2E+YA=
X-Received: by 2002:a05:6122:ec3:b0:518:6286:87a4 with SMTP id
 71dfb90a1353d-521ee253c9dmr4720213e0c.4.1740241452732; Sat, 22 Feb 2025
 08:24:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z2_lAGctG0DDSCIH@gondor.apana.org.au> <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au> <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au> <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com> <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
In-Reply-To: <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 23 Feb 2025 05:24:01 +1300
X-Gm-Features: AWEUYZkxRypvz8LrhfnOSKOPJoiE7CkvYVgqyhi-wM4RgZJZyCSAVqDgM3Nysw0
Message-ID: <CAGsJ_4xv_4H3zfL+06iMMx0xxJMpRVacGRPa-OOB6ORSe+JjSQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Minchan Kim <minchan@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, 
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 23, 2025 at 1:31=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (25/02/22 19:26), Barry Song wrote:
> > After reviewing the zRAM code, I don't see why zram_write_page() needs
> > to rely on
> > comp_len to call write_incompressible_page().
>
> [..]
>
> > zram_write_page()
> > {
> >         ret =3D zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
> >                              mem, &comp_len);
> >         kunmap_local(mem);
> >
> >         if (unlikely(ret && ret !=3D -ENOSP)) {
> >                 zcomp_stream_put(zstrm);
> >                 pr_err("Compression failed! err=3D%d\n", ret);
> >                 return ret;
> >         }
> >
> >         if (comp_len >=3D huge_class_size || ret) {
> >                 zcomp_stream_put(zstrm);
> >                 return write_incompressible_page(zram, page, index);
> >         }
> > }
>
> Sorry, I'm slower than usual now, but why should we?  Shouldn't compressi=
on
> algorithms just never fail, even on 3D videos, because otherwise they won=
't
> be able to validate their Weissman score or something :)
>
> On a serious note - what is the use-case here?  Is the failure here due t=
o
> some random "cosmic rays" that taint the  compression H/W?  If so then wh=
at
> makes us believe that it's uni-directional?  What if it's decompression
> that gets busted and then you can't decompress anything previously stored
> compressed and stored in zsmalloc.  Wouldn't it be better in this case
> to turn the computer off and on again?
>
> The idea behind zram's code is that incompressible pages are not unusual,
> they are quite usual, in fact,  It's not necessarily that the data grew
> in size after compression, the data is incompressible from zsmalloc PoV.
> That is the algorithm wasn't able to compress a PAGE_SIZE buffer to an
> object smaller than zsmalloc's huge-class-watermark (around 3600 bytes,
> depending on zspage chain size).  That's why we look at the comp-len.
> Anything else is an error, perhaps a pretty catastrophic error.
>
> > As long as crypto drivers consistently return -ENOSP or a specific erro=
r
> > code for dst_buf overflow, we should be able to eliminate the
> > 2*PAGE_SIZE buffer.
> >
> > My point is:
> > 1. All drivers must be capable of handling dst_buf overflow.
> > 2. All drivers must return a consistent and dedicated error code for
> > dst_buf overflow.
>
> Sorry, where do these rules come from?
>
> > +Minchan, Sergey,
> > Do you think we can implement this change in zRAM by using PAGE_SIZE in=
stead
> > of 2 * PAGE_SIZE?
>
> Sorry again, what problem are you solving?

The context is that both zswap and zRAM currently use a destination buffer =
of
2 * PAGE_SIZE instead of just PAGE_SIZE. Herbert, Chenming, and Yosry are
questioning why it hasn't been reduced to a single PAGE_SIZE, and some
attempts have been made to do so.[1][2].

The rules are based on my thoughts on feasibility if we aim to reduce it to=
 a
single PAGE_SIZE.

[1] https://lore.kernel.org/linux-mm/Z7F1B_blIbByYBzz@gondor.apana.org.au/
[2] https://lore.kernel.org/lkml/20231213-zswap-dstmem-v4-1-f228b059dd89@by=
tedance.com/

Thanks
Barry
