Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07111CBE9A
	for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2024 18:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729707175; cv=none; b=pFbgbCyM+Y+jdG7C6b0MW51aEh3NcymvSgDKVRQG8wUz2+HIxGdkW6jFw0yvJZHwWwdVUxWfQ0gH/5jVPfaQ4vIBHvbAW4k61fOND5L7wEfMh2aqsq4tlhZLhT2dQjuiEwvipfeYlzgGYbG8IhTs4iolTZVgfm6xdjybtOI2ahc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729707175; c=relaxed/simple;
	bh=/hv8XK/2iUP+UjoDOE9T9lmfSy8KmqJlKWJehfeO/Fw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GqWm/ayBKTQAkU/sYbfZEQDIg2SIMk6ntnRO/YDg3hPm5oDZ9t+fOIJ8VhhlccGSngIZZwiinXRTUw/Wq0RTRKT4b0sE884LigioeuOUktzTn1in5L+cufX5tiLUqxuGTD5M+Yl8m/TPcWJqIFSORokCyfU2skVQH6FeSKM07Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xl9pueeC; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xl9pueeC"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5cb6ca2a776so90941a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2024 11:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729707170; x=1730311970; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LDi5VPzX6c61t1Xhrb5vlpguCbYE1+CPmZ5jAWd7OIw=;
        b=xl9pueeCn1DwRJHAgmj+kw9QGlJhwpY8TUVhnmUPgAMAANrkn136+ZqG8WciwIiGbE
         5DPKJdsDX1SA2d/p73ObOUsm7eskYQUo6PhrpFksiPHQtlio8uQy7pJV49lK1OE75h4u
         9Z5QkjcOwYXFKBkRclta/VGroEfdPjSRXjMWplYEHlgEomeBQT9q3nEeeKo0beI6iWkE
         PZMY+G0+xTdiJsh3T2orFoyfL3hGr3zmiTW1x+1O6Lvwf5SPT36Id7rtfdaUfY7RB6Az
         kn767BKXKau9hOs5Yv9tI52ExTlA/5Vcw8yhZSu0GbglLs6WcFgtc/xWGzsoCqIN3Ag3
         SRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729707170; x=1730311970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LDi5VPzX6c61t1Xhrb5vlpguCbYE1+CPmZ5jAWd7OIw=;
        b=Q26fVYFsAhoJqUnVgsepcKnx/KxQ7Q03MGVMrQgvR/IhdvqsecfmrxmmgpSeKol36e
         FBHbFQCF0APHuJJHgGa3f11FwOiuKWmiPOyZx1a/e8gwaBbUsiu7XEgQfztZyfAnmeYG
         PahrqzOMEn7MrL75WqXG0y59lexjvgyaptr72QAZYRkmvNeGunU1h6X5NKiD9VZj0mvf
         0rwlAkHFEi+l4pwIYhgb+Ka7/swxEsFgzTGYv7Z+B5KSWn3WaNNmcpW8NDbXK4JRBayh
         i6r+BMmqynX3+u7kSVSvWdnkdJNEyI9lSGYgVwdMs+1B5dT68cT7LNoF8WvrBIWnEVLE
         pCRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgFcGrVwyFBKsc74VNohXVBBRB52YaSnENg/PzALvSqT0/Qp3Nj4KcNBIGaJXrDYcJIFhKdEmDpIgYxo8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrRrTdv9kFLdVNxNjhr9vdnswL+Py8TBQloTZ43IO1ADDKA8gr
	6t1Kc7/6zGnMNa2OPDGhliQh01IXhZG0Mo5PECdUUkgdESnrJ6N9iP+babTYTLiJdQ+Dg6dGMZK
	QGfXmuTEc32UrDAbp8IHpVppFXsYFmJRRb2CL
X-Google-Smtp-Source: AGHT+IEWtGBqmChvvFUDCvgxebL4MPsU63ShJMOn68yqj4BjRtIC6qhUzt6L4WKNcUU9vsQpXuTBTyq/d29UkOioP7A=
X-Received: by 2002:a17:907:3e9e:b0:a9a:dac:2ab9 with SMTP id
 a640c23a62f3a-a9abf92dd94mr340448966b.42.1729707170109; Wed, 23 Oct 2024
 11:12:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241018064101.336232-1-kanchana.p.sridhar@intel.com>
 <20241018064101.336232-10-kanchana.p.sridhar@intel.com> <CAJD7tkbXTtG1UmQ7oPXoKUjT302a_LL4yhbQsMS6tDRG+vRNBg@mail.gmail.com>
 <SJ0PR11MB5678D24CDD8E5C8FF081D734C94D2@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5678D24CDD8E5C8FF081D734C94D2@SJ0PR11MB5678.namprd11.prod.outlook.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Wed, 23 Oct 2024 11:12:12 -0700
Message-ID: <CAJD7tkYAvEVK9o4Nt9qdn_2sN+rNwD9yuqNJ5jKsTs8257naFA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 09/13] mm: zswap: Config variable to enable
 compress batching in zswap_store().
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"Huang, Ying" <ying.huang@intel.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>, 
	"jack@suse.cz" <jack@suse.cz>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"joel.granados@kernel.org" <joel.granados@kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, 
	"willy@infradead.org" <willy@infradead.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 22, 2024 at 7:17=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Yosry Ahmed <yosryahmed@google.com>
> > Sent: Tuesday, October 22, 2024 5:50 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; Huang, Ying
> > <ying.huang@intel.com>; 21cnbao@gmail.com; akpm@linux-foundation.org;
> > linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; zanussi@kernel.org; viro@zeniv.linux.org=
.uk;
> > brauner@kernel.org; jack@suse.cz; mcgrof@kernel.org; kees@kernel.org;
> > joel.granados@kernel.org; bfoster@redhat.com; willy@infradead.org; linu=
x-
> > fsdevel@vger.kernel.org; Feghali, Wajdi K <wajdi.k.feghali@intel.com>; =
Gopal,
> > Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [RFC PATCH v1 09/13] mm: zswap: Config variable to enable
> > compress batching in zswap_store().
> >
> > On Thu, Oct 17, 2024 at 11:41=E2=80=AFPM Kanchana P Sridhar
> > <kanchana.p.sridhar@intel.com> wrote:
> > >
> > > Add a new zswap config variable that controls whether zswap_store() w=
ill
> > > compress a batch of pages, for instance, the pages in a large folio:
> > >
> > >   CONFIG_ZSWAP_STORE_BATCHING_ENABLED
> > >
> > > The existing CONFIG_CRYPTO_DEV_IAA_CRYPTO variable added in commit
> > > ea7a5cbb4369 ("crypto: iaa - Add Intel IAA Compression Accelerator cr=
ypto
> > > driver core") is used to detect if the system has the Intel Analytics
> > > Accelerator (IAA), and the iaa_crypto module is available. If so, the
> > > kernel build will prompt for CONFIG_ZSWAP_STORE_BATCHING_ENABLED.
> > Hence,
> > > users have the ability to set
> > CONFIG_ZSWAP_STORE_BATCHING_ENABLED=3D"y" only
> > > on systems that have Intel IAA.
> > >
> > > If CONFIG_ZSWAP_STORE_BATCHING_ENABLED is enabled, and IAA is
> > configured
> > > as the zswap compressor, zswap_store() will process the pages in a la=
rge
> > > folio in batches, i.e., multiple pages at a time. Pages in a batch wi=
ll be
> > > compressed in parallel in hardware, then stored. On systems without I=
ntel
> > > IAA and/or if zswap uses software compressors, pages in the batch wil=
l be
> > > compressed sequentially and stored.
> > >
> > > The patch also implements a zswap API that returns the status of this
> > > config variable.
> >
> > If we are compressing a large folio and batching is an option, is not
> > batching ever the correct thing to do? Why is the config option
> > needed?
>
> Thanks Yosry, for the code review comments! This is a good point. The mai=
n
> consideration here was not to impact software compressors run on non-Inte=
l
> platforms, and only incur the memory footprint cost of multiple
> acomp_req/buffers in "struct crypto_acomp_ctx" if there is IAA to reduce
> latency with parallel compressions.
>
> If the memory footprint cost if acceptable, there is no reason not to do
> batching, even if compressions are sequential. We could amortize cost
> of the cgroup charging/objcg/stats updates.

Hmm yeah based on the next patch it seems like we allocate 7 extra
buffers, each sized 2 * PAGE_SIZE, percpu. That's 56KB percpu (with 4K
page size), which is non-trivial.

Making it a config option seems to be inconvenient though. Users have
to sign up for the memory overhead if some of them won't use IAA
batching, or disable batching all together. I would assume this would
be especially annoying for distros, but also for anyone who wants to
experiment with IAA batching.

The first thing that comes to mind is making this a boot option. But I
think we can make it even more convenient and support enabling it at
runtime. We just need to allocate the additional buffers the first
time batching is enabled. This shouldn't be too complicated, we have
an array of buffers on each CPU but we only allocate the first one
initially (unless batching is enabled at boot). When batching is
enabled, we can allocate the remaining buffers.

The only shortcoming of this approach is that if we enable batching
then disable it, we can't free the buffers without significant
complexity, but I think that should be fine. I don't see this being a
common pattern.

WDYT?



>
> Thanks,
> Kanchana
>
> >
> > >
> > > Suggested-by: Ying Huang <ying.huang@intel.com>
> > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > > ---
> > >  include/linux/zswap.h |  6 ++++++
> > >  mm/Kconfig            | 12 ++++++++++++
> > >  mm/zswap.c            | 14 ++++++++++++++
> > >  3 files changed, 32 insertions(+)
> > >
> > > diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> > > index d961ead91bf1..74ad2a24b309 100644
> > > --- a/include/linux/zswap.h
> > > +++ b/include/linux/zswap.h
> > > @@ -24,6 +24,7 @@ struct zswap_lruvec_state {
> > >         atomic_long_t nr_disk_swapins;
> > >  };
> > >
> > > +bool zswap_store_batching_enabled(void);
> > >  unsigned long zswap_total_pages(void);
> > >  bool zswap_store(struct folio *folio);
> > >  bool zswap_load(struct folio *folio);
> > > @@ -39,6 +40,11 @@ bool zswap_never_enabled(void);
> > >
> > >  struct zswap_lruvec_state {};
> > >
> > > +static inline bool zswap_store_batching_enabled(void)
> > > +{
> > > +       return false;
> > > +}
> > > +
> > >  static inline bool zswap_store(struct folio *folio)
> > >  {
> > >         return false;
> > > diff --git a/mm/Kconfig b/mm/Kconfig
> > > index 33fa51d608dc..26d1a5cee471 100644
> > > --- a/mm/Kconfig
> > > +++ b/mm/Kconfig
> > > @@ -125,6 +125,18 @@ config ZSWAP_COMPRESSOR_DEFAULT
> > >         default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
> > >         default ""
> > >
> > > +config ZSWAP_STORE_BATCHING_ENABLED
> > > +       bool "Batching of zswap stores with Intel IAA"
> > > +       depends on ZSWAP && CRYPTO_DEV_IAA_CRYPTO
> > > +       default n
> > > +       help
> > > +       Enables zswap_store to swapout large folios in batches of 8 p=
ages,
> > > +       rather than a page at a time, if the system has Intel IAA for=
 hardware
> > > +       acceleration of compressions. If IAA is configured as the zsw=
ap
> > > +       compressor, this will parallelize batch compression of upto 8=
 pages
> > > +       in the folio in hardware, thereby improving large folio compr=
ession
> > > +       throughput and reducing swapout latency.
> > > +
> > >  choice
> > >         prompt "Default allocator"
> > >         depends on ZSWAP
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 948c9745ee57..4893302d8c34 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -127,6 +127,15 @@ static bool zswap_shrinker_enabled =3D
> > IS_ENABLED(
> > >                 CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
> > >  module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool,
> > 0644);
> > >
> > > +/*
> > > + * Enable/disable batching of compressions if zswap_store is called =
with a
> > > + * large folio. If enabled, and if IAA is the zswap compressor, page=
s are
> > > + * compressed in parallel in batches of say, 8 pages.
> > > + * If not, every page is compressed sequentially.
> > > + */
> > > +static bool __zswap_store_batching_enabled =3D IS_ENABLED(
> > > +       CONFIG_ZSWAP_STORE_BATCHING_ENABLED);
> > > +
> > >  bool zswap_is_enabled(void)
> > >  {
> > >         return zswap_enabled;
> > > @@ -241,6 +250,11 @@ static inline struct xarray
> > *swap_zswap_tree(swp_entry_t swp)
> > >         pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,         \
> > >                  zpool_get_type((p)->zpool))
> > >
> > > +__always_inline bool zswap_store_batching_enabled(void)
> > > +{
> > > +       return __zswap_store_batching_enabled;
> > > +}
> > > +
> > >  /*********************************
> > >  * pool functions
> > >  **********************************/
> > > --
> > > 2.27.0
> > >
