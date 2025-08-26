Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33541F4191;
	Tue, 26 Aug 2025 03:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756180103; cv=none; b=Pp5OQC/ujwvRNMPkLoCr1RQbjBYAjvEDUJ9aqp/SxovVP623cyuic1NUg0Sr8ROOYqDgIGJzNLmL2L6+AFQIi3W59+dfXhcOIV/cGWlmeklzwuPOy0LUvgAZvJCMQOUOjAlkyb4VLzoM6MmelKtLsr4G9abLPfPqgG6M5sd95ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756180103; c=relaxed/simple;
	bh=etyVX44EcxWPwN6CBglOgoTRZZlYZ4odKE6PWrlMzQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z/2p7CKZlV6DtqOyakooBhq3bzkE0lddTtIzmLp8T0E1I5aGel+sj1jK82GFpNr7x8WuJFqOEILXsNWN4hcAn5YJt2376Bv1fIFtxK6EjVmu8PUm6+xvSEAFeCrev1+P3vwHyea5CSTJG6COoRX3StDY5s9pC+37anVyt7FVZeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BK4AGdMW; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BK4AGdMW"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e87031323aso593675585a.0;
        Mon, 25 Aug 2025 20:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756180101; x=1756784901; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSD8VMG9zZQ8ShbiUSnWktqc4t1GwqQcLAuPm99uK2A=;
        b=BK4AGdMWR0VO3xcXf/cwqzVYMf+kEYgM8iQ+H6eXvbucmVV9vIhjti4nmIJP5fA33Y
         i65M2gMZAKIVMkkbnDgBtywR/lLG5r5Sx1eyFEcPEVBD0AxLycHVuQ/GuNFJ4d2wDx7I
         5tjs3tKwEjtyoj9PDaodrpcRqNfZUcfPZu0R2yQSxYYXBk77IdhGlS8YmIbpkig3pyFc
         f2HkDcaVCurpq4eXdAfZlKfCruimOD/G+KjQbkfdoRXPOM6fJWgRooQxJh32RTtcsYny
         IQgP3HVgIIv7mwlISFbp/9kCDQzKpv+/YQbfh2pFTuWbqsQlg2S5sk2ebjdnbjGkOJ/t
         LsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756180101; x=1756784901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jSD8VMG9zZQ8ShbiUSnWktqc4t1GwqQcLAuPm99uK2A=;
        b=haB7uNwQwgAmmt2B6z2J4eYSLmcvcDPm2WefbpdN7ZteZV474XwNRWLAassp9VNURL
         CHitfHDjA0HArWzlgqHialbxZBa4PwAblr/VYrOGIHXE8bzCFcAv8dkyUoVJJJc0jJeD
         amFwLK2pUYArHq61u5x9If+y3HzYXC4toGTS6zc3w4CY2TYpzB/DYBpv7m04l0v3QAA7
         CYIH0ksOn8EaOHlJgSScku8QGKTB0s46YnJ6Vmu/cGgIyrLyGUleRkHeItFMnBPcq0nJ
         6PQ3AXAIOzolUKtKEnxMtGEajjRBJDBxMo6tswJBJFJ3w71mS57CO2OGIIgjT5fIijvq
         Whvw==
X-Forwarded-Encrypted: i=1; AJvYcCXd6Npl3If54b0kmzaD5X2u5Wds5NfUO5BNRQmGIt0fuAAzWEfAvSKGBI89PQVh6CNHsOG+1lOVRDSALCo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMNEBX9SxYfqphKpmpg45sL+8KDvG4Ir9BAVjkhMqsZ/hzUPbo
	4b6kAybw+lFlBSJ40MVFOcL9OzqoJvpuSCzT0VoD8sfyR3kkATpSLNNpaEMK9Nvyw0kvfUKOwzI
	5DcX4fS356NB9tHBukL3sdRlUcNOP3zc=
X-Gm-Gg: ASbGncvRWQT8I/6IRyzeJ5EctB7/kGlEJFvjAiKKOlFOe2vhpqt4cOmZtel+DtmFpJ/
	oAvmyQYgzBTX1Qf+myoFqMmWs/ckvmdjZDEmPNIrS779P+beFtlPdacc10PNnUG7+3f7ROCioA1
	nOylHMhYJZ3i3KTPv3M3/yChTigg/DG4VF77WMrGFVBO4Z02oqJOZmpbhhv+qiMqcwGt8053PkF
	LFHCI0=
X-Google-Smtp-Source: AGHT+IHogeU0tcf8N9/98D2LKMRmBjSxLonp2Qk4eM+QiDMFLzmDfhCSs2TqzN4cavgW351hLtr/C3wuwPteFCroeM4=
X-Received: by 2002:a05:620a:28c4:b0:7e9:f81f:ce7a with SMTP id
 af79cd13be357-7ea110daa7cmr1436407685a.80.1756180100659; Mon, 25 Aug 2025
 20:48:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 26 Aug 2025 11:48:08 +0800
X-Gm-Features: Ac12FXzFSiQppO9L-3PlARCfK6bU14dUhFnHEYsWxbGYtLIBoR6DEP5l_M3xqew
Message-ID: <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kanchana,


[...]
>
> +       /*
> +        * Set the unit of compress batching for large folios, for quick
> +        * retrieval in the zswap_compress() fast path:
> +        * If the compressor is sequential (@pool->compr_batch_size is 1)=
,
> +        * large folios will be compressed in batches of ZSWAP_MAX_BATCH_=
SIZE
> +        * pages, where each page in the batch is compressed sequentially=
.
> +        * We see better performance by processing the folio in batches o=
f
> +        * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working set
> +        * structures.
> +        */
> +       pool->batch_size =3D (pool->compr_batch_size > 1) ?
> +                               pool->compr_batch_size : ZSWAP_MAX_BATCH_=
SIZE;
> +
>         zswap_pool_debug("created", pool);
>
>         return pool;
>

It=E2=80=99s hard to follow =E2=80=94 you add batch_size and compr_batch_si=
ze in this
patch, but only use them in another. Could we merge the related changes
into one patch instead of splitting them into several that don=E2=80=99t wo=
rk
independently?

> -
>         acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0=
, cpu_to_node(cpu));
>         if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
>                 pr_err("could not alloc crypto acomp %s : %ld\n",
> @@ -904,17 +929,36 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>         acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
>         if (IS_ERR_OR_NULL(acomp_ctx->req)) {
>                 pr_err("could not alloc crypto acomp_request %s\n",
> -                      pool->tfm_name);
> +                       pool->tfm_name);
>                 goto fail;
>         }
>
> -       crypto_init_wait(&acomp_ctx->wait);
> +       /*
> +        * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> +        * compressor supports batching.
> +        */
> +       pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> +                                    crypto_acomp_batch_size(acomp_ctx->a=
comp));
> +
> +       acomp_ctx->buffers =3D kcalloc_node(pool->compr_batch_size, sizeo=
f(u8 *),
> +                                         GFP_KERNEL, cpu_to_node(cpu));
> +       if (!acomp_ctx->buffers)
> +               goto fail;
> +
> +       for (i =3D 0; i < pool->compr_batch_size; ++i) {
> +               acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE * 2, GFP=
_KERNEL,
> +                                                    cpu_to_node(cpu));
> +               if (!acomp_ctx->buffers[i])
> +                       goto fail;
> +       }

It=E2=80=99s hard to follow =E2=80=94 memory is allocated here but only use=
d in another
patch. Could we merge the related changes into a single patch instead of
splitting them into several that don=E2=80=99t work independently?

>
>         /*
>          * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
>          * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
>          * won't be called, crypto_wait_req() will return without blockin=
g.
>          */
> +       crypto_init_wait(&acomp_ctx->wait);
> +
>         acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BAC=
KLOG,
>                                    crypto_req_done, &acomp_ctx->wait);
>
> @@ -922,7 +966,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
>         return 0;
>
>  fail:
> -       acomp_ctx_dealloc(acomp_ctx);
> +       acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
>         return ret;
>  }
>
> @@ -942,7 +986,7 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>
>         mutex_lock(&acomp_ctx->mutex);
>
> -       dst =3D acomp_ctx->buffer;
> +       dst =3D acomp_ctx->buffers[0];
>         sg_init_table(&input, 1);
>         sg_set_page(&input, page, PAGE_SIZE, 0);
>
> @@ -1003,19 +1047,19 @@ static bool zswap_decompress(struct zswap_entry *=
entry, struct folio *folio)
>
>         acomp_ctx =3D raw_cpu_ptr(entry->pool->acomp_ctx);
>         mutex_lock(&acomp_ctx->mutex);
> -       obj =3D zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buf=
fer);
> +       obj =3D zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buf=
fers[0]);
>
>         /*
>          * zpool_obj_read_begin() might return a kmap address of highmem =
when
> -        * acomp_ctx->buffer is not used.  However, sg_init_one() does no=
t
> -        * handle highmem addresses, so copy the object to acomp_ctx->buf=
fer.
> +        * acomp_ctx->buffers[0] is not used.  However, sg_init_one() doe=
s not
> +        * handle highmem addresses, so copy the object to acomp_ctx->buf=
fers[0].
>          */
>         if (virt_addr_valid(obj)) {
>                 src =3D obj;
>         } else {
> -               WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffer);
> -               memcpy(acomp_ctx->buffer, obj, entry->length);
> -               src =3D acomp_ctx->buffer;
> +               WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffers[0]);
> +               memcpy(acomp_ctx->buffers[0], obj, entry->length);
> +               src =3D acomp_ctx->buffers[0];

Hard to understand what is going on if related changes are not kept in
one self-contained patch.

Thanks
Barry
