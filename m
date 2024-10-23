Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C911DFE1
	for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2024 00:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729644633; cv=none; b=QJjxlAJGk1J7TJKOsfjodiQR2Veud9lW5czwuU4WJv8khjXjsZ0Rk1icETrRN1dXjDyA92RA8RFWL2qqR7RN3FIEPGMshgk2hOimtAmFJvsil/MOQhl+JCYWr8QWthi9hTYxLxIe6Efy8qT6XbJ4q6iDvD5sKErpgbRO5n8f5c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729644633; c=relaxed/simple;
	bh=85C14LnzHSmDnVC9fmIWJXsHAZ/RskLVIvFJVK0C8MY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aq54aDM73e0FK+WIJlpnJYwFFA7gstNpjy8DZ9pbZhGJneGvE4Y/M2jdlpk0dUzKMjZc5kFg1t+l/ltS2Sq0UlXVScK3THiFSzPA1Epo1dA2AMpkinZbZrHA5afz4r460hPVqiT8seCEWRdA0/aWMy2Holf+f52dZKD6XHYpZ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r3wFZA/R; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r3wFZA/R"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a99ebb390a5so59483366b.1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Oct 2024 17:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729644629; x=1730249429; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2RVe7tez2PJu7xFZaopsIUK4FQaSBewWT4oCCH7cRo=;
        b=r3wFZA/R70P/zPEPQ4q4jwebcXVe7G8IvmVkyfg840/H8oFE/SdOIJfcENXb6Ph6Tg
         ot6No2eCDh1eA3QUHGmH9hgtW9fh0JsXnGQh2etzjMAj12VXom+RVk42xlLaXFpwWO3C
         Jc6GiU93MyIhUhbKYOQIKa+Z52bsuapfqHdSHEeHMKESvJbOLav3FAbsRzJT4C/OnjMO
         5yuUKAHEIPf3u76mA/xoywCSBQgbvRI6I/nXn47i2/vwCvAqcVJSgEBN2EjksUuIx3Gh
         Oy+QWtn61zDfAMis9pK8v6C/csvtHf8OrUGFJ4R0A19o4JAeiFE84Ookw7uv8SUXcbDR
         EFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729644629; x=1730249429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T2RVe7tez2PJu7xFZaopsIUK4FQaSBewWT4oCCH7cRo=;
        b=CeGwLLnmMo96/PysS/2rFWzKXZqJssM7T/vnFZIu3LjZXLSa+nI5phqCSA/T8UrDIa
         WApRGxH9OcVh/p8KCSldX5SD/ZivpT0aJbydFg50DP1rGblhbghN+HFZFze+4o1C1iCd
         p8H1/2FXkk2MFqNCEkjJAS4X4EoOqeMufSto9C67v+HzS+zLtqgDE5nUxV4O384rbCCh
         JN4EtfkwCE2QSiC9+NZtMVfM8P4pyjrPkXSxStg5ZT3XuT4guxhx4BhUBIInzfCfZdBY
         o9L/WNJ/9oABwRjof/k3oGvOUIGAYFL4atvmw6+GJ63bWNYY+I8MOpyPXQwwlMD+3BxR
         Xp5g==
X-Forwarded-Encrypted: i=1; AJvYcCVXLbVwtECcqoiDqBgD3ljyNWlju2EpUpjUYN55KvCfmSJ+SCq4ogtsccMthfNMFWhx1JjHFJnpOj25kzw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy6UNCrIRFGnaYkWfp1MxiyHNNvYo1gm8CZ6qV564WCxpBoJV/
	8xb0eOy2VMpg3LGP26oWIDzsLx1yeiXAkqOagF09b2jzVO+aB2fcLgumtN5dtnLrHaZBAHrcHD6
	36lJp1p42H2+s6pYh2SkCfzVy5sHuZXR9CQHO
X-Google-Smtp-Source: AGHT+IGEjIYQpmIs+gAoloBjz17prVfsvhxrsDIKUjyX4jbTSir6xX9/MpmDlwfyBofviyxuYwSskWvLQsI1isWTUW4=
X-Received: by 2002:a17:907:6d0c:b0:a8d:2281:94d9 with SMTP id
 a640c23a62f3a-a9aaa620d72mr577158666b.23.1729644629301; Tue, 22 Oct 2024
 17:50:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241018064101.336232-1-kanchana.p.sridhar@intel.com> <20241018064101.336232-10-kanchana.p.sridhar@intel.com>
In-Reply-To: <20241018064101.336232-10-kanchana.p.sridhar@intel.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 22 Oct 2024 17:49:53 -0700
Message-ID: <CAJD7tkbXTtG1UmQ7oPXoKUjT302a_LL4yhbQsMS6tDRG+vRNBg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 09/13] mm: zswap: Config variable to enable
 compress batching in zswap_store().
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, ying.huang@intel.com, 21cnbao@gmail.com, 
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com, 
	ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, zanussi@kernel.org, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, mcgrof@kernel.org, kees@kernel.org, 
	joel.granados@kernel.org, bfoster@redhat.com, willy@infradead.org, 
	linux-fsdevel@vger.kernel.org, wajdi.k.feghali@intel.com, 
	vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024 at 11:41=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> Add a new zswap config variable that controls whether zswap_store() will
> compress a batch of pages, for instance, the pages in a large folio:
>
>   CONFIG_ZSWAP_STORE_BATCHING_ENABLED
>
> The existing CONFIG_CRYPTO_DEV_IAA_CRYPTO variable added in commit
> ea7a5cbb4369 ("crypto: iaa - Add Intel IAA Compression Accelerator crypto
> driver core") is used to detect if the system has the Intel Analytics
> Accelerator (IAA), and the iaa_crypto module is available. If so, the
> kernel build will prompt for CONFIG_ZSWAP_STORE_BATCHING_ENABLED. Hence,
> users have the ability to set CONFIG_ZSWAP_STORE_BATCHING_ENABLED=3D"y" o=
nly
> on systems that have Intel IAA.
>
> If CONFIG_ZSWAP_STORE_BATCHING_ENABLED is enabled, and IAA is configured
> as the zswap compressor, zswap_store() will process the pages in a large
> folio in batches, i.e., multiple pages at a time. Pages in a batch will b=
e
> compressed in parallel in hardware, then stored. On systems without Intel
> IAA and/or if zswap uses software compressors, pages in the batch will be
> compressed sequentially and stored.
>
> The patch also implements a zswap API that returns the status of this
> config variable.

If we are compressing a large folio and batching is an option, is not
batching ever the correct thing to do? Why is the config option
needed?

>
> Suggested-by: Ying Huang <ying.huang@intel.com>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  include/linux/zswap.h |  6 ++++++
>  mm/Kconfig            | 12 ++++++++++++
>  mm/zswap.c            | 14 ++++++++++++++
>  3 files changed, 32 insertions(+)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index d961ead91bf1..74ad2a24b309 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -24,6 +24,7 @@ struct zswap_lruvec_state {
>         atomic_long_t nr_disk_swapins;
>  };
>
> +bool zswap_store_batching_enabled(void);
>  unsigned long zswap_total_pages(void);
>  bool zswap_store(struct folio *folio);
>  bool zswap_load(struct folio *folio);
> @@ -39,6 +40,11 @@ bool zswap_never_enabled(void);
>
>  struct zswap_lruvec_state {};
>
> +static inline bool zswap_store_batching_enabled(void)
> +{
> +       return false;
> +}
> +
>  static inline bool zswap_store(struct folio *folio)
>  {
>         return false;
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 33fa51d608dc..26d1a5cee471 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -125,6 +125,18 @@ config ZSWAP_COMPRESSOR_DEFAULT
>         default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
>         default ""
>
> +config ZSWAP_STORE_BATCHING_ENABLED
> +       bool "Batching of zswap stores with Intel IAA"
> +       depends on ZSWAP && CRYPTO_DEV_IAA_CRYPTO
> +       default n
> +       help
> +       Enables zswap_store to swapout large folios in batches of 8 pages=
,
> +       rather than a page at a time, if the system has Intel IAA for har=
dware
> +       acceleration of compressions. If IAA is configured as the zswap
> +       compressor, this will parallelize batch compression of upto 8 pag=
es
> +       in the folio in hardware, thereby improving large folio compressi=
on
> +       throughput and reducing swapout latency.
> +
>  choice
>         prompt "Default allocator"
>         depends on ZSWAP
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 948c9745ee57..4893302d8c34 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -127,6 +127,15 @@ static bool zswap_shrinker_enabled =3D IS_ENABLED(
>                 CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
>  module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool, 0644)=
;
>
> +/*
> + * Enable/disable batching of compressions if zswap_store is called with=
 a
> + * large folio. If enabled, and if IAA is the zswap compressor, pages ar=
e
> + * compressed in parallel in batches of say, 8 pages.
> + * If not, every page is compressed sequentially.
> + */
> +static bool __zswap_store_batching_enabled =3D IS_ENABLED(
> +       CONFIG_ZSWAP_STORE_BATCHING_ENABLED);
> +
>  bool zswap_is_enabled(void)
>  {
>         return zswap_enabled;
> @@ -241,6 +250,11 @@ static inline struct xarray *swap_zswap_tree(swp_ent=
ry_t swp)
>         pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,         \
>                  zpool_get_type((p)->zpool))
>
> +__always_inline bool zswap_store_batching_enabled(void)
> +{
> +       return __zswap_store_batching_enabled;
> +}
> +
>  /*********************************
>  * pool functions
>  **********************************/
> --
> 2.27.0
>
