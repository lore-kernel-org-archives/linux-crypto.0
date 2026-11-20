Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795218680;
	b=4VYcwUuBW4pWc7FYjPQDI9cJRukKUP8+tk0+qG4uzIETZrVgIc/le14zzDA6xUBwu0xM
	 RrTV7LRg6S0ZqhWDmorAscPd+yJGUFyWg3+JfPjue3IcWfSlp/mCm3tnznjR9KimSdl0L
	 Tcmhcjl0YPD5uclAnEhbxAUxV5czFnzJoTtbT2XpnL8M0Kgfu6zx65sEtmHK9nQ4ZD0h9
	 CQfOc2UzBTQKvYR0SSYG3kNk2C8TOo/P+3AEPMQa8+7r2WQfqH0lxP8z2by/1P/AId0eU
	 tpNqpymODsRWavqym+6a262QZpSSzDTsR5SL+4DmaY6bqdcfPVHYf5fsDZvH3S14tOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795218680;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=KHxTN0uS+Qg1aDUZNJtoDzFicoj8vWJ+yr5kM/h7aeY=;
	b=hAW0aAms1fynL6Tw6vJR2TnKEZsmzB1lKl0MBP2b2uSQ7uqr97hIflVGb/NopKhi6NO1
	 IlHlh5B4WdMd/cb/A0iz3D4OBzg/Ls5j2HvMu5rPcim3Dp9wMpm61o1f23owOKSADnITp
	 4EBcTLesDonYHjs7MZh34qNromN6mwgkQnxkKZaEIiPItgX8wayw0vxlBKDBlnj4ta5df
	 CZY7Og3hfHGiPKOfPgoedYKfdf8TmgG0GFsMPuVjlR9oos8F7bYH9yvHEcJiJUKgEzqAi
	 MTsEEF8GADNMc3BFcLTanhsj0KE/Ot/rRHKAdYaAE1eNvf3/aou+LtP2nSWJIfaTUvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=StStSgBw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CF7606A68B
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 23:51:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5CF7606A68B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=StStSgBw
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c14470729eso1214912e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 15:51:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795218677; cv=none;
        d=google.com; s=arc-20260327;
        b=XSCt3sBHvE1VJzmq1ucmKeEAKDzbQ4RmkYltR5QGwTSrSGfvHWaJ1/iDGIDeEuvbzT
         gyBgNLNZ29ERBS/BO8eQbOjYtwCOlO/GgHUCNpBBD8OB1imaW0MEElP9ZLzE35oKvXEi
         WNNr8G8js2hy2zz/J3nzjUWi1+qQfyZ8LWt9W9csTuD2Ql+SpDaruJHmweSBhOtAv2Qz
         BqBXKn6eqTEiucPYhSHITNv3S5TjgENnZKaJEemuoU32Q/rpqw+1BDFsZmO/xjwnhxCQ
         BT2slWbBnbAPXNtWl4krmeKUQFagInVZaAHwHkSO7aBlFBhUG3XQthMFy9Tpo6S/EJ2n
         5lFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KHxTN0uS+Qg1aDUZNJtoDzFicoj8vWJ+yr5kM/h7aeY=;
        fh=IBxx/Lb84CXTCq48m8+3iP/+gM3Ak2QWDTcvl1Rfxa4=;
        b=ZGc7UEG033ROBNWPAs1D9gFBKjZOnRGXCnsOgu7duellEbTRAGvT/6b0HhulbDxj1z
         zXMK3hxchTGSdkhuSV3pGGyxqDiWFy6l5IP58pp6bPdHR9Kyugy/lX4OlinsgrDFKJib
         3C6UDUVUWRM9U+gyGcOmV4KnD2+A6TYZA1no1yAYSO+ksrQdDcRChD8jRB6b1/GxZAn9
         m088sL0cF0pcb7o/lCRIwm65+ihCaFmrhhXT/ff4cR4syz7avHpqBC3T3A7H95IxcGsS
         w6/8uHUVr8DpBdSCrMjQrYuo/5X5zO2W9dJFsZoR5MmVtRvyTD3y4cdapW4E5g+Gqxbv
         GTQQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795218677; x=1795823477; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KHxTN0uS+Qg1aDUZNJtoDzFicoj8vWJ+yr5kM/h7aeY=;
        b=StStSgBwqT9sMp6/7BXRRH5W7+XhxeyfsKRSJhwdqGRFKiu1P/ExdW4+gCD77bVp0C
         keMt0+TKoHMJF+kKjTPx3WVS/Ox+cGVSTQ/qLfHjONK11hc+11km+HgLgpB0x/y3BFyS
         zrUhlVM0nQcqJloTQzWGnA/pZY2sgCdzmgzKWXrnZZ/MBWhXZG/tBiU3O5XqVRBl25ya
         76BeqBCYZ8fHFTPDD+CTmTYvpELpEJ5gBm2xlTI2ZhAE3Wvj6PdvNBRsGhjfyhLEZ6UE
         +2jxyPJFSj2VZ7JylIclS24YCBMDHyeLpoXXnzfiSw6D1hhrNoAzMJnvJvXjhQnv4owX
         Gkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795218677; x=1795823477;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KHxTN0uS+Qg1aDUZNJtoDzFicoj8vWJ+yr5kM/h7aeY=;
        b=SjhUQm4Y9aDJtUDo72ARZK8+gP+Tadsjf82tDeLLoyJZNwXXqmB8vHDRZjnQFWY65z
         PKlq1r0XUdDqnvZmp1XFnLBcGPRTWouVzSXh2mAvEphtuk4hVc5SD5zWfoXudOiuzMHV
         kL0liwq601hS41gUcAQ1KvZkiiWpKpLGnFT+O0EYIdf0yID4uHPLXeAhn7PcbFNc2DuY
         BqlIx66bsXR4l9Zsaxmp1mhV6UAl8zGQoOQcKf6fnxlrxaY9OHOks+Eu4AWUsDoBjL/+
         /wCguTz8/2g2Eht9DYt2DyuI91u8PCeYbOdRHwn5pnatMrIGkJTrNpj+MNvtqafsgUaa
         eTHA==
X-Forwarded-Encrypted: i=1; AL+hErHb9nXhKpCRHKPvpykoSobkWfntahPCBrnXEiaYnApR6dkLzKx0S3huu5OmeShrFhBTb/qu0ZTrUc3+kfU=@vger.kernel.org
X-Gm-Message-State: APuU4Z94ZYunJzb1LV0vIeIS6cqLQCjvH6JhfrDb93EcJoFwVsh9HZx7
	SVsm3L2IGkb7AXQaYVnQ+299ZKjr4tvd4EX4nSsTis4pJReeT0QEwR2RGsk78Y4wQGkaAtuk7UV
	2sJ9c3Ot359BS9Wi9ouDX6m9MrqZRQFY=
X-Gm-Gg: AZFdTZd7MDg1HuiX8dKZpiXS1nANHbLm9ccdURAfKw/UtvHcwaaFNvKoqxKxQNR4fQE
	3xMWeBjXKqYQ1OJeptOV3cFGPDJ14YCBzKcnWL4fYkeBjhaDy+7oHOqfhqWMDB8MuE1hPBp1vOZ
	zukSTs7zp9SD46G+FVCDdf3EEltYWrpWpytjwDrJ5D0UpfpdTmFoh5kitRCQrI5dmgAcCSr1Jxd
	aRT//aCjHwMNJ/Pba6B4px4ETl1noeQSwzjs8w8RLjePMreNl1rTnIxA6SWbf9YT4Eo4Fpq+lXH
	rpazQS/zqH0h0ewtBUZWl/NLOhQdOj2Wv+k2kjyQS6aO9+RDTyhIiLFH6w8pfCZ43H1zxR+l4bV
	UFHqIpJ0vi2o7vUmrZEmtYxtdSkh8F0do45+/Ukq7E5Xm6Rhjh83XNokRSw==
X-Received: by 2002:a05:6512:3da4:b0:5c1:57ba:f848 with SMTP id
 2adb3069b0e04-5c1bc576a77mr1562754e87.0.1795218676722; Fri, 20 Nov 2026
 15:51:16 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-7-kanchanapsridhar2026@gmail.com> <CAKEwX=Pr6t8w676ztfrONaKrRKoy6NS1priTb2c2XUikNhYU7A@mail.gmail.com>
In-Reply-To: <CAKEwX=Pr6t8w676ztfrONaKrRKoy6NS1priTb2c2XUikNhYU7A@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 15:51:04 -0800
X-Gm-Features: Aa3M54pGq-g0FQY51hIMaRGadQCw3Jar2bC1oRgHGQK3b2ePQ8Bn-IWKzW3So3o
Message-ID: <CACpmpocuNQE=6m=WJ7oX_1ZP0WvwQm4T=6KFv3ya2k7oNvM=yw@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] mm: zswap: Store large folios in batches.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:25=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > Use batching when storing large folios in zswap. A new constant,
> > ZSWAP_MAX_BATCH_SIZE is defined as 4U to support processing batches of
> > up to 4 pages at a time while storing large folios. This commit
> > modifies the "store single page" approach to "store a batch of pages".
> >
> > As part of CPU onlining per-CPU acomp_ctx setup, ZSWAP_MAX_BATCH_SIZE
> > compression buffers are allocated to eventually be able to compress and
> > store ZSWAP_MAX_BATCH_SIZE pages. This happens in subsequent commits.
> >
> > For existing software compressors, the extra overhead is the
> > the extra 'buffers' pointer, 3 additional elements in 'buffers' and 3
> > additional 4K space per 'buffers[i]': in all ~12 KB per-CPU on
> > x86_64. Only the first buffer is currently used.
> >
> > zswap_store_page() is replaced with zswap_store_pages(), which processe=
s
> > a batch of pages and allows for batching optimizations. For now, only
> > optimize allocating entries by using batch allocations from the slab
> > cache.
> >
> > Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
> > page and only call it once for the folio, since the entire folio is
> > charged to a single memcg. Similarly, obtain the nid once to use during
> > each batch store of a folio. To facilitate this, a "struct
> > zswap_store_context" is introduced to keep function parameter lists
> > concise.
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > ---
> >  mm/zswap.c | 307 +++++++++++++++++++++++++++++++++++++----------------
> >  1 file changed, 217 insertions(+), 90 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 78d9694f75b5..df59ab0c1029 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -85,6 +85,9 @@ static bool zswap_pool_reached_full;
> >
> >  #define ZSWAP_PARAM_UNSET ""
> >
> > +/* Limit the batch size to limit per-CPU memory usage for dst buffers.=
 */
> > +#define ZSWAP_MAX_BATCH_SIZE 4U
> > +
> >  static int zswap_setup(void);
> >
> >  /* Enable/disable zswap */
> > @@ -144,10 +147,12 @@ struct zswap_acomp_req {
> >         struct mutex mutex;
> >  };
> >
> > -/* The compression mutex also protects the output buffer. */
> > +/*
> > + * The compression mutex also protects the output buffer(s).
> > + */
> >  struct zswap_comp_ctx {
> >         struct zswap_acomp_req areq;
> > -       u8 *buffer;
> > +       u8 **buffers;
> >  };
> >
> >  /* Separate requests, so that decompression does not wait for compress=
ion. */
> > @@ -162,6 +167,7 @@ struct crypto_acomp_ctx {
> >   * The only case where lru_lock is not acquired while holding tree.loc=
k is
> >   * when a zswap_entry is taken off the lru for writeback, in that case=
 it
> >   * needs to be verified that it's still valid in the tree.
> > + *
> >   */
> >  struct zswap_pool {
> >         struct zs_pool *zs_pool;
> > @@ -226,6 +232,15 @@ struct zswap_entry {
> >         struct list_head lru;
> >  };
> >
> > +struct zswap_store_context {
> > +       struct folio *folio;
> > +       long folio_start;
> > +       bool wb_enabled;
> > +       int nid;
> > +       u8 nr_pages;
> > +       struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> > +};
> > +
> >  /*
> >   * No RCU section is needed around the returned pointer: a stored entr=
y pins
> >   * its pool via percpu_ref (taken in zswap_store_page()), so the id ca=
nnot be
> > @@ -284,6 +299,8 @@ static void __zswap_pool_empty(struct percpu_ref *r=
ef);
> >
> >  static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
> >  {
> > +       u8 i;
> > +
> >         if (!acomp_ctx)
> >                 return;
> >
> > @@ -302,8 +319,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx=
 *acomp_ctx)
> >
> >         acomp_ctx->acomp =3D NULL;
> >
> > -       kfree(acomp_ctx->comp.buffer);
> > -       acomp_ctx->comp.buffer =3D NULL;
> > +       if (acomp_ctx->comp.buffers) {
> > +               for (i =3D 0; i < ZSWAP_MAX_BATCH_SIZE; ++i)
> > +                       kfree(acomp_ctx->comp.buffers[i]);
> > +               kfree(acomp_ctx->comp.buffers);
> > +       }
> > +       acomp_ctx->comp.buffers =3D NULL;
> >  }
> >
> >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > @@ -388,6 +409,7 @@ static struct zswap_pool *zswap_pool_create(char *c=
ompressor)
> >  cpuhp_add_fail:
> >         for_each_possible_cpu(cpu)
> >                 acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
> > +
> >  error:
> >         if (pool->acomp_ctx)
> >                 free_percpu(pool->acomp_ctx);
> > @@ -778,6 +800,44 @@ static void zswap_entry_cache_free(struct zswap_en=
try *entry)
> >         kmem_cache_free(zswap_entry_cache, entry);
> >  }
> >
> > +static inline void zswap_entries_cache_free_batch(
> > +       struct zswap_entry **entries,
> > +       u8 nr_entries)
> > +{
> > +       /*
> > +        * It is okay to use this to free entries allocated separately
> > +        * by zswap_entry_cache_alloc().
> > +        */
> > +       kmem_cache_free_bulk(zswap_entry_cache, nr_entries, (void **)en=
tries);
> > +}
> > +
> > +static bool zswap_entries_cache_alloc_batch(
> > +       struct zswap_store_context *zc,
> > +       gfp_t gfp)
> > +{
> > +       u8 i;
> > +
> > +       bool ret =3D kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> > +                                        zc->nr_pages, (void **)zc->ent=
ries);
> > +
> > +       if (likely(ret)) {
> > +               for (i =3D 0; i < zc->nr_pages; ++i)
> > +                       zs_handle_init(&zc->entries[i]->handle);
> > +       } else {
> > +               for (i =3D 0; i < zc->nr_pages; ++i) {
> > +                       zc->entries[i] =3D zswap_entry_cache_alloc(GFP_=
KERNEL);
>
> Oh and why are we using GFP_KERNEL in the fallback path, but passing a
> gfp to kmem_cache_alloc_bulk above?
>
> (and it seems like the only caller of
> zswap_entries_cache_alloc_batch() passed GFP_KERNEL for gfp anyway?).
>
> Let's just drop gfp and use GFP_KERNEL if that's the intention?

Good catch! Makes sense, I will drop the gfp and use GFP_KERNEL in the next=
 rev.

Thanks,
Kanchana
