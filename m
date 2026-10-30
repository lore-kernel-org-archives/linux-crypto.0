Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793319099;
	b=aa5xJxqSRmQw5wlIHfEN8GM5Xv+XoL+GAHlJuUonTjxZJwJsDxdHKiugcFkb5NA/Gv7Q
	 tTTM/9IrBxHXqbawYzn/w74lKINfwHsM4S1ohEHZInS6jQoZCMLkh3S19XBd+xl/fvRSB
	 DEvbwgUqh6cWWi+/QBuoVvj1S9+8D8cxupqLvqNGVa4FbemnFZftuF5TfZ5M57lPlHeKt
	 GtIKpW0Pd/wdwropqmmSyV+bItITJ7pOTebCcUiM6xQpVtT8HskgwgSVC+niXBAKio7Tq
	 Co3XZbjuS3PBWoU1GLPQqm6m/xsG7/NA+MwwiPam7htbP8yun97l1NPZZTCAe4zauYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793319099;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=eMFC2eyPXrFFKJU701P6neL6odKYpxUo97XpYgZl+Gs=;
	b=WtS4A0NKbm8eEAbIQUU4U8hyq9n3yZF1Ee8h74g9QKq9T1g5HTwA6k1e7WnRGFJK6wc8
	 KGsnqKHuCCVi1+GPrIa6o4nJ5GM5+srU8UJYwgrx/XoWa038PcbAYVvabCmc0yRjFgsw0
	 U51oIbDjKtIxvMRvQjqKywJMCOdUUpBUV/W4pfh4djBUuAzC/34fKYI00RgG0LOt/E3jE
	 WJy1qv8PxF3EjaoPzviFUd2lI7ly0Af+5mClUYxG3G3Gxw8uxRc6XVfeCpLe8OGWaHCmC
	 FkGLbGoZnK5SdWohcaBwSQ8z2X9qphv4/jFiPaDdp/eFJfzZ3lkI5TK1k5BzepDEwxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mr8D7JDl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.43
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C97606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 00:11:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27C97606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mr8D7JDl
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5be47aa555cso211459e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 17:11:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793319097; cv=none;
        d=google.com; s=arc-20260327;
        b=jHHrwWAX7qo3EBU79LU+/Oxz3dPHi96DiI99+Lj3Mi1A85BAPUQHkdEyHh5XQDRFvQ
         35NDS49LwVHGVFt0f1ZFcptcpSFmMBr5odhf8bIp802jjSTfD0/HBEDg9Cc74Acs5cvZ
         gZcjBMPKOEtDU6scyX/v8LG2XZ1OaMf0iINZCDzRmdQ61fNhEvQLO9AGF0PohurvO3MW
         7Hkiesllq1i/38E7Dud6CsO/ZlESEU2CS0CSgs0nh1mew+A2YLhnl0s4kZT9awtz7BHB
         qkqH0UbP5cFA0WRyRmHBjwjrxckZt17nQVyijiFI19i+O41SoNicgaVGObzlqWLzhD13
         ha7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eMFC2eyPXrFFKJU701P6neL6odKYpxUo97XpYgZl+Gs=;
        fh=3oFNhNI/1Pa7JkaUUe+KlZ1xZJjSK8a5M0G8hvBpxQ0=;
        b=l8++YvNj7IaaV5sODamr9qDLiX0uqfZmIEXYA3KlD6xjVgeIVcg1X613ZNQ6td7LKp
         9FpDfktN4jJVlC2y2ULxbDXOLNnXJazdb5ZhIjpOEDyyxdeBtCoOSqXGeHfZhf0jAaY3
         plHgV4UxBPLkSLVbBNxBhFf07CoYB1LHV3SU51FNf/hvowku5KqnkGQP05L3hn8YGmCk
         URclZAoQ7BMscOUFzBOZXkzOId4ifpft7N9m4otv7dmQQlRelqLxcGGX9NWkb2SlbxYK
         cC6rD1PuIfdLf8L09PkhX263S/oxD0Qq9fjdx3NIRBa6agsi7/MGNS/cAqqnG30BqcG+
         Kpzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793319097; x=1793923897; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eMFC2eyPXrFFKJU701P6neL6odKYpxUo97XpYgZl+Gs=;
        b=Mr8D7JDlom3goz4A8UlX1hopdWxCTnelB7U9i61cYDeZSOC3ccvVuSLjoMRXJ6pBpH
         CfUoTIIcl/bF76SK90dqVzmoyxa86xo5pp3We3ejC4Rhg5o1hM9+cqbP/SzcVzyZ6HY0
         0xx3nq+d912IVviWEmkC5LDd9/yEmnkj0bqLMEkPwdl185cnjUaCsTR7Hnpn1Sfz5pYw
         IHEwNyO85bkAi66NijuyjoXaq6/O/XNQ3BHrGeYBZYJqxHfI6o8ezTGDrx0f7K8y65fV
         lJO8nJAnnsHrHf0VHCuDeIGCz8IWdvtCW6hksjE79YHvBDoIkrHBQCrAgSRV8AkV2ay5
         pnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793319097; x=1793923897;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eMFC2eyPXrFFKJU701P6neL6odKYpxUo97XpYgZl+Gs=;
        b=xRvG2K60KRmrrcrlKj4wmqquToy1MWeDbgawD38U5bzw6VdQQ3fOZDXMhEZZsSJS29
         BLKKVNGNKvDSHonZLs2WpNtiqrCDL/6IP92c8mKSn4Mzg/z5OBdFbgzimGP4PEjbfLJb
         /7ApZmG+8WXdZBfJ0dfOS3FuiAL70WjY63jPasYixuGUgj7ddPGj8RjcT6OwJ0XuJr9b
         tUeoeoDUi6GY3TCXOj2DI52w8p1aAEs2quX2Jm/hhTcsmKELmIJ6afwMLUFiUKJgT+U4
         EwC47E8YlQ3ENm8XJcYf99M2kLgkPdUJhUIimo+/aDRHxenMRWPZZopT67A8veLJFxuH
         8cvw==
X-Forwarded-Encrypted: i=1; AKwUvBwGW3WNLkd47dHU9zkob/c5U3d+JibBKOPhlQtefFv1yR9it6JpQB6rp/eJ17uf+OfWIb/BwyL+dE7j1c8=@vger.kernel.org
X-Gm-Message-State: AFq9FYKrByH4J7IUAdpzLKdk23KqNO84dMsDhjuNsvZUdG/Dzh2O7ibL
	rtoya0cUKyPBTHH0X7fOyMnwWbMPrTy++CCh0A5cYCBRiWoL8DmPqLGMLyMuXQKRjdxghgF//Z+
	UK1LkkmcIF5gkYEj+YyI5HwOLYZvx5wc=
X-Gm-Gg: AYBFou0SZ3sK/njjX0jzrxPUbEK+nhevPsvFjqh9D8RqpCvY4xQZZREgbvLsYZpvXA+
	3BttwkJS31RHKkNzjK+I7ZqN9Oii0NKZxjdbk6Pn72bsGfu9y9fYMn3NPixRR3DdbpFsoB4Rzq2
	V+7KdphlbuteRajbVNocc/GZeZwRMo7Dpq33ZrpLqzwwcFgJ1Fyi2s/HUzoIwCDBUnIPHoqT6w2
	nLOFPuo7kJgkPNncEembTeRDzNkCmBHegnLTotQW9ZJUoE1SS/jlh8hnXw8t8vL1EL4PF/a+fj5
	60Nai33fbFwQIA8UhBn6eeqIgW0H7h6bTrzDQ1gCud8UIdHciiT2Rbn7XB6NkJzSFivh4cT6U2v
	z4eaxE545rJ5rxR8fc9uRkh/cPhdXUU2bnwyV
X-Received: by 2002:a05:6512:2250:b0:5bf:a467:32a6 with SMTP id
 2adb3069b0e04-5bfd957cd4cmr126035e87.39.1793319097124; Thu, 29 Oct 2026
 17:11:37 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188658@kernel.org>
In-Reply-To: <sashiko-outbox-188658@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 17:11:24 -0700
X-Gm-Features: AclHuK-yXK_SCfxPeXOlV3-w-vp4HmLVTPHL5E8x5sdAfQnRtJ3WTsp8ODMhep4
Message-ID: <CACpmpodSK7txDECSiwqbZjuqs74YgL9TSAbfDNkg0cLrOwT6=w@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 8:06=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] mm: zswap: fix error return on buffer alloc failure in zswap_cpu=
_comp_prepare()
> - [Medium] mm: zswap: unsynchronized write to pool->compr_batch_size on C=
PU hotplug
> --
>
> commit 13a7e2ffeb93e24e6a8f400496ff51f01ce0c408
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Store large folios in batches.
>
> This commit introduces batching when storing large folios in zswap, alloc=
ating
> multiple per-CPU compression destination buffers when supported by the
> compressor and batch-allocating zswap entries from the slab cache. It als=
o
> caches the memcg writeback setting and folio NUMA node ID in a store cont=
ext
> and reorganizes struct zswap_pool for cacheline locality.
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 19b7d60bc7d2a..c8890e8a9b836 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
>
> [ ... ]
>
> > @@ -866,10 +922,28 @@ static int zswap_cpu_comp_prepare(unsigned int cp=
u, struct hlist_node *node)
> >               goto fail;
> >       }
> >
> > +     /*
> > +      * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> > +      * compressor supports batching.
> > +      */
> > +     pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> > +                                  crypto_acomp_batch_size(acomp_ctx->a=
comp));
>
> [Severity: Medium]
> Can updating pool->compr_batch_size inside the per-CPU hotplug callback r=
ace
> with concurrent readers or cause a buffer count mismatch across CPUs?
>
> In zswap_pool_create(), cpuhp_state_add_instance() runs zswap_cpu_comp_pr=
epare()
> only on currently online CPUs. If an offline CPU is brought online later =
while
> the pool is active, zswap_cpu_comp_prepare() writes to pool->compr_batch_=
size
> without synchronization while zswap_store() concurrently reads it:
>
>     store_batch_size =3D (pool->compr_batch_size > 1) ?
>                         pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
>
> Additionally, because each CPU independently calls crypto_alloc_acomp_nod=
e()
> when brought online, if a higher-priority acomp implementation for
> pool->tfm_name with a different batch_size is registered before a CPU com=
es
> online, pool->compr_batch_size will be overwritten with the new value. Wh=
en
> zswap_pool_destroy() later frees each CPU's buffers using the single
> pool->compr_batch_size:
>
>     for_each_possible_cpu(cpu)
>         acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu),
>                        pool->compr_batch_size);
>
> acomp_ctx_free() would iterate past the end of acomp_ctx->comp.buffers (o=
r
> leak buffers) for CPUs that were initialized with the earlier batch size.

Thanks Sashiko, for the excellent observations. Based on this, I am
moving the "u8 compr_batch_size" to struct zswap_comp_ctx, which is
per-CPU. In addition to addressing the issues you've highlighted, this
will also simplify the store batching architecture quite a bit.

>
> > +
> >       ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->ac=
omp);
> >       if (ret)
> >               goto req_fail;
> >
> > +     acomp_ctx->comp.buffers =3D kcalloc_node(pool->compr_batch_size, =
sizeof(u8 *),
> > +                                            GFP_KERNEL, nid);
> > +     if (!acomp_ctx->comp.buffers)
> > +             goto req_fail;
> > +
> > +     for (i =3D 0; i < pool->compr_batch_size; ++i) {
> > +             acomp_ctx->comp.buffers[i] =3D kmalloc_node(PAGE_SIZE, GF=
P_KERNEL, nid);
> > +             if (!acomp_ctx->comp.buffers[i])
> > +                     goto req_fail;
> > +     }
> > +
> >       /* Skip the per-CPU request when decompression can use the stack.=
 */
> >       if (acomp_is_async(acomp_ctx->acomp)) {
> >               ret =3D zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ct=
x->acomp);
> > @@ -882,12 +956,13 @@ static int zswap_cpu_comp_prepare(unsigned int cp=
u, struct hlist_node *node)
> >  req_fail:
> >       pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_nam=
e);
> >  fail:
> > -     acomp_ctx_free(acomp_ctx);
> > +     acomp_ctx_free(acomp_ctx, pool->compr_batch_size);
> >       return ret;
> >  }
>
> [Severity: High]
> Does zswap_cpu_comp_prepare() return 0 (success) if kcalloc_node() or
> kmalloc_node() fails when allocating acomp_ctx->comp.buffers?

Thanks, I have fixed this.

[ .. ]

> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D6
