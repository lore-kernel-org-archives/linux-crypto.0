Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070991DBB13;
	Sat, 30 Aug 2025 08:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756543271; cv=none; b=I2wkcc2NQtXj1Cze4b9SlgfxT9bDgQZbJt7PqoeFxOsu1zmYu38IMtDod7r4bqePkixVB5m2m06qLrKs6b2Cq58udaz4iPzjp71a1YRNH1XwCoAznOtEKpfbzSv7a1aRgQb7qCWD6srfEEWcvCU7Xnhq/syLlgVLGyb9WgSMppQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756543271; c=relaxed/simple;
	bh=jkUVdbpOU+SkveJ4KHnqt1C/hB2g9VfaofOPCWLWzE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sSnDg/uGMz+qFmV2Y32cgJCi3m5tqFb3DOglaadQHinNzPhwMs0KKE5yeqkPLZ0Wp8u6LZRc/JEN6YSm2gBSgTpO9RXhijhm3OynIqAhvEiapqW5uhKPzRZqrB+JwJ2K4UPsGCvZL/XYglJNtn7K7V+wp/f051M8vQN/0u1MX9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AsuclDkn; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AsuclDkn"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7e870689dedso175802085a.3;
        Sat, 30 Aug 2025 01:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756543269; x=1757148069; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jkUVdbpOU+SkveJ4KHnqt1C/hB2g9VfaofOPCWLWzE0=;
        b=AsuclDknLinQbBhIoHA+boRWizjaEkd4XaX+ZZA7pQqvWIG0FCw1UciG1p9f2t86RP
         W3EgPVOvCwheq0BHSyJExWdgm7k2DHxlSnAC4BNAWhhmTOCZQSdkDCa8IGkzhAd9H3Ro
         PBP6acK8kUZkt3KG6xuFx/P+2CAkteUVd7KION/cuDRivQmjBumV+thpMcAUFdzta12a
         0qKiw9VOIBI/YK01JNThHVbYtRU39PFJMGxLt4P/Zunb2qEz2V2toVICKGeitGZbP2RB
         ZASbI24KTKkPiGLqtV4T0TgIGz17m7BGZZdFmZjzymG07N5oGpEiDA567ljjB3XcRSCe
         UyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756543269; x=1757148069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jkUVdbpOU+SkveJ4KHnqt1C/hB2g9VfaofOPCWLWzE0=;
        b=rR3Hnp1fbNhgvlhcW5vihJ9CQiFawvBfTSs3ePo90K7RNwm5r4gHzhlaq13uQ67V/1
         74y89YFhMnratUK4HAfA1W19FqImtjWqCk6MYutKWAEEAv9YAW0xGl7XNAEjKdUtZQCp
         5qKltmSXIilhuHW21el2AnUjw3TPELp7dAmxO3BsKzPLA6nPaGOQ7JtbJ1Fg7tL4WNIX
         q2hKq1t7Qh/fP+h0BTgeqeVk2r3ehGFlp9mhpL57F/cIMEWJhUeTP+tIz2Yh4/Jio299
         u1uuhC/PsRepiEC5GY1ErDY+XVl7lt97q4l7JXwc3O/WpQwOnI2j3mme6oJw3jQN8MSl
         O8ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUql9DaTo0LXccyTKKPeY/mZpt3zi4pKKHAQVRjRtYYBLVXXNPDp1epsCZmkzZjtGIMaiwVRyRDSphR3CU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJaK9+lH75XcjCfHgeWanICD7R3JLHLarauV/7e6QjCz48AiYc
	JCJl3ckijKUTYdib7zDbW4rJ+7rabk9hSl7xTfcqbji+AeSlQeu+2aqP7Il8j4Ak/kA20ktLG/H
	6ICwoW1i/m+M12OZFILFxEjlP7/wwjE6hzzkW
X-Gm-Gg: ASbGncuKCSdMnMoadT+yk/willCtQA7AgwBkrPmXumoRrdu9Gz9k8yrY5Q7GlKNjYZR
	W2Xu0sxlRQr2YwhLcZj8XY9xFIJuyLZhWTjovc/KiD0WP8ltokdlP+EL85dYR92QkwMbvl/QhiU
	pK032E81GsizT3kAjb+1SaIwPFdXnxAOKS3qXdbLzNsIZQQJn5QPsIs+MKH+bCD7VDjb1obsZvM
	gVOVMdLqI7En3soHtrl41uo3zHR
X-Google-Smtp-Source: AGHT+IHiBcp+DLTL1DFIy/5DJtQgKHM1E9fLaKA4e6Epk8HBp8ZNiEmwjJXBcfdTsOI2gw7V8C886efkoeZ+tKvM1YY=
X-Received: by 2002:a05:620a:4256:b0:7f6:74fc:2a94 with SMTP id
 af79cd13be357-7ff27094456mr136276085a.2.1756543268719; Sat, 30 Aug 2025
 01:41:08 -0700 (PDT)
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
 <CAGsJ_4xy3mksbwj61qnNrSpcFgkanEK0tCzJcjQgVF-oAyXe8A@mail.gmail.com>
 <PH7PR11MB81216DFB4CA6F22E0ED76026C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zMHtYG3rS61PyGfJYd8KwGEw=Gy=g5s5wT_vrEL9fhbA@mail.gmail.com> <SA3PR11MB81201972CB6D308FB4659E7DC93AA@SA3PR11MB8120.namprd11.prod.outlook.com>
In-Reply-To: <SA3PR11MB81201972CB6D308FB4659E7DC93AA@SA3PR11MB8120.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 30 Aug 2025 16:40:57 +0800
X-Gm-Features: Ac12FXxQQzVz3ZwE12kpQKBS_WIg20ZLii0Hl9TF9Df55yGu3hbeQmQN-gJ_jbQ
Message-ID: <CAGsJ_4x38iz1XmRp_j3jX-8fY8o_3RNXLx78wc3s_4-o+N0URQ@mail.gmail.com>
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

> > >
> > > I am not sure I understand this rationale, but I do want to reiterate
> > > that the patch-set implements a simple set of rules/design choices
> > > to provide a batching framework for software and hardware compressors=
,
> > > that has shown good performance improvements with both, while
> > > unifying zswap_store()/zswap_compress() code paths for both.
> >
> > I=E2=80=99m really curious: if ZSWAP_MAX_BATCH_SIZE =3D 8 and
> > compr_batch_size =3D 4, why wouldn=E2=80=99t batch_size =3D 8 and
> > compr_batch_size =3D 4 perform better than batch_size =3D 4 and
> > compr_batch_size =3D 4?
> >
> > In short, I=E2=80=99d like the case of compr_batch_size =3D=3D 1 to be =
treated the same
> > as compr_batch_size =3D=3D 2, 4, etc., since you can still see performa=
nce
> > improvements when ZSWAP_MAX_BATCH_SIZE =3D 8 and compr_batch_size =3D=
=3D
> > 1,
> > as batching occurs even outside compression.
> >
> > Therefore, I would expect batch_size =3D=3D 8 and compr_batch_size =3D=
=3D 2 to
> > perform better than when both are 2.
> >
> > The only thing preventing this from happening is that compr_batch_size
> > might be 5, 6, or 7, which are not powers of two?
>
> It would be interesting to see if a generalization of pool->compr_batch_s=
ize
> being a factor "N" (where N > 1) of ZSWAP_MAX_BATCH_SIZE yields better
> performance than the current set of rules. However, we would still need t=
o
> handle the case where it is not, as you mention, which might still necess=
itate
> the use of a distinct pool->batch_size to avoid re-calculating this dynam=
ically,
> when this information doesn't change after pool creation.
>
> The current implementation gives preference to the algorithm to determine
> not just the batch compression step-size, but also the working-set size f=
or
> other zswap processing for the batch, i.e., bulk allocation of entries,
> zpool writes, etc. The algorithm's batch-size is what zswap uses for the =
latter
> (the zswap_store_pages() in my patch-set). This has been shown to work
> well.
>
> To change this design to be driven instead by ZSWAP_MAX_BATCH_SIZE
> always (while handling non-factor pool->compr_batch_size) requires more
> data gathering. I am inclined to keep the existing implementation and
> we can continue to improve upon this if its Ok with you.

Right, I have no objection at this stage. I=E2=80=99m just curious=E2=80=94=
since some hardware
now supports HW compression with only one queue, and in the future may
increase to two or four queues but not many overall=E2=80=94whether batch_s=
ize =3D=3D
compr_batch_size is always the best rule.

BTW, is HW compression always better than software? For example, when
kswapd, proactive reclamation, and direct reclamation all run simultaneousl=
y,
the CPU-based approach can leverage multiple CPUs to perform compression
in parallel. But if the hardware only provides a limited number of queues,
software might actually perform better. An extreme case is when multiple
threads are running MADV_PAGEOUT at the same time.

I=E2=80=99m not opposing your current patchset, just sharing some side thou=
ghts :-)

Thanks
Barry
