Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722111;
	b=UdAN1aqyv0jphY92UCtmhOpSP1gubjOz9f/dbeM625VQMyOa04lsMqORLpVzLrcY8D9z
	 y2nwpYY22e9bXM21aTsd3tNmaTrasPaEnN450yJe5m1Vk4q/z5L5Gq/Y3BpIU+xxE47dZ
	 d0Y0ZEXEIthp0MvwrHISa7Ap/ubFERp/PrZQOaYjYB/8JcayYarX5gqvoN9UICfBFF4KR
	 GPNlR2nPtfIZYruhSwmi6MhXZBx3I2YIr6atnplvirsNOOOc+rjvKPeh56mIP769X57dY
	 Q1QnE3wcCchVLHRh7CmEr/6dYz4s/J8h5UQeGvS7ASMGUZc7C/hAvyHHqIr/mxoh4UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722111;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SvBxcU0JLNXA5MaTI7MCEmWVgzZuquV24Fb0g4m3Vl4=;
	b=Cpqxr06FJdfvQ3GDSGpo/z4m8MD31m3MJ5yqwtDe8u0vhoxCb+pB+5HNROETxVw4dP6K
	 8pQx3aqMiwIU2x9MHjw2CaXa3G1khgSYTqNz+8HhAebuYCKK05g5FiJeCBQ5r1cxsFlCw
	 TTkG1mlHFrY6dVHBdjajmUZ7NKtrbFYTrPtCBxIGrlKmof2lKZNiVDdILtFM+c21mZ7RE
	 D5axAET+8s7Ls51tl5RcZi/EXzE6GfnHk644sAMOClym1IPRHTtr/SNZZ/QYWuq08FMDt
	 aKzvjrEWkrj504UeujruEf0BankdRUVdOwqMZOP5rX3r5ethCh9ejwUyJiv2lhQcDhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tpqnxk4v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27853606A328
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tpqnxk4v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2AC1F00919
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 16:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722110;
	bh=SvBxcU0JLNXA5MaTI7MCEmWVgzZuquV24Fb0g4m3Vl4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Tpqnxk4v7O7cDlHQSOIdarQW8h114qvCR4rA83k23tIgNGlLvZN5zU0JyBchOVxRJ
	 7jUSpgD6p/qx//0BZh6qtlfmgxwzggxLfQXlqiTBOcmRYFWltQDNULbMDwZFjndek5
	 SuFp7ypbGPHSG/qC3QGzdu4fiidAiWBqcozHMpX57iEytcwP7G0JFRMlExqeb7+9lj
	 cqJdiIA4z+ClLUb4UFLxkIiuAAs4QCr8PvK2u0xUKfzzs3feE9HFJoycPKYbg4Sg/P
	 tu1xaF73JnnS2WraaOze2v39F2kuFmRaaUHrRc1iwi/n2kkq0MgmGleJScNbOLNb9T
	 L/ut3Ljl5Pl+w==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c46bd7a7345so183219266b.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 08:08:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxElxPxnihe4thxlRaxHDP08Hgl/gu3ZC/7CTf9sKUdlNsmSBB7SjQXezHPzHMOlGRezdcPt4Y7gpwLIIQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z88124eT3C+73EZPy4nAKc/4eOnszHUJtwed3FQoumu9QNloF/x
	leQ92WEZmCSqdN/OLoq8NXhtnm5zhL6eQaMrTBN/Dr+WdBFlxLDzoynjGg0MyWIrQGBTnHl6kwR
	oiS7J2h94bFO6KKy15n0sqAn3SVgbrE0=
X-Received: by 2002:a17:907:869f:b0:c41:825d:ed8c with SMTP id
 a640c23a62f3a-c49d147e127mr1481901066b.26.1793722109538; Tue, 03 Nov 2026
 08:08:29 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103000313.13677-1-kanchanapsridhar2026@gmail.com> <sashiko-outbox-194595@kernel.org>
In-Reply-To: <sashiko-outbox-194595@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 3 Nov 2026 08:08:18 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOdbbn0XGKoU_9ktNJJtn19oP8JxOX1uVs+-BLe0GdCTw@mail.gmail.com>
X-Gm-Features: AclHuK9wS_mhc5Y-JGS88yPApAQKys0rl04uUxuRn3Xg8ICSN0ztaY2JRlrhkNo
Message-ID: <CAO9r8zOdbbn0XGKoU_9ktNJJtn19oP8JxOX1uVs+-BLe0GdCTw@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] mm: zswap: Move the crypto_acomp to be per pool,
 instead of per-CPU.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, Barry Song <baohua@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	sashiko-reviews@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 9:42=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] mm: zswap: per-pool crypto_alloc_acomp() breaks NUMA and HW qu=
eue scaling
> --
>
> commit 0abfb2c1c527ffcd5ca8df2224cd1c4533f5face
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Move the crypto_acomp to be per pool, instead of per-CPU.
>
> This commit moves the struct crypto_acomp instance from the per-CPU struc=
t
> crypto_acomp_ctx into the global struct zswap_pool, allocating a single
> transform per pool in zswap_pool_create() instead of allocating one per C=
PU
> in zswap_cpu_comp_prepare().
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 37d217860a6b2..a958b74d4425d 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
>
> [ ... ]
>
> > @@ -323,6 +313,17 @@ static struct zswap_pool *zswap_pool_create(char *=
compressor)
> >
> >       strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> >
> > +     /*
> > +      * In case of an error, crypto_alloc_acomp() returns an
> > +      * error pointer, never NULL.
> > +      */
> > +     pool->acomp =3D crypto_alloc_acomp(pool->tfm_name, 0, 0);
> > +     if (IS_ERR(pool->acomp)) {
> > +             pr_err("could not alloc crypto acomp %s : %pe\n",
> > +                     pool->tfm_name, pool->acomp);
> > +             goto error;
> > +     }
>
> [ ... ]
>
> > @@ -841,34 +857,20 @@ static int zswap_cpu_comp_prepare(unsigned int cp=
u, struct hlist_node *node)
> >        * To handle cases where the CPU goes through online-offline-onli=
ne
> >        * transitions, we return if the acomp_ctx has already been initi=
alized.
> >        */
> > -     if (acomp_ctx->acomp) {
> > -             WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp));
> > +     if (acomp_ctx->comp.areq.req)
> >               return 0;
> > -     }
> >
> >       acomp_ctx->comp.buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cp=
u_to_node(cpu));
> >       if (!acomp_ctx->comp.buffer)
> >               return ret;
> >
> > -     /*
> > -      * In case of an error, crypto_alloc_acomp_node() returns an
> > -      * error pointer, never NULL.
> > -      */
> > -     acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0=
, cpu_to_node(cpu));
> > -     if (IS_ERR(acomp_ctx->acomp)) {
> > -             pr_err("could not alloc crypto acomp %s : %pe\n",
> > -                             pool->tfm_name, acomp_ctx->acomp);
> > -             ret =3D PTR_ERR(acomp_ctx->acomp);
> > -             goto fail;
> > -     }
> > -
> > -     ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->ac=
omp);
> > +     ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, pool->acomp);
>
> [Severity: Medium]
> Does replacing the per-CPU crypto_alloc_acomp_node() call in
> zswap_cpu_comp_prepare() with a single non-NUMA-aware crypto_alloc_acomp(=
)
> call in zswap_pool_create() cause a NUMA locality and hardware queue scal=
ing
> regression for hardware compression accelerators?
>
> Previously, commits 7bc13b5b60e9 and 1ec3b5fe6eec allocated a dedicated
> struct crypto_acomp per CPU on cpu_to_node(cpu) so that hardware compress=
ion
> drivers would allocate per-CPU, NUMA-local hardware queues.
>
> While software scomp backends and Intel IAA select per-CPU streams or
> workqueues at request submission time, other hardware acomp drivers bind
> hardware queues, rings, and NUMA-local accelerator devices to the struct
> crypto_acomp transform during initialization based on the transform's nod=
e.

Adding Barry here, I think this undos the optimization he previously added.

>
> For example, in drivers/crypto/hisilicon/zip/zip_crypto.c,
> hisi_zip_acomp_init() allocates one compression queue pair, one
> decompression queue pair, and a per-transform request queue and spinlock =
on
> tfm->base.node:
>
> drivers/crypto/hisilicon/zip/zip_crypto.c:hisi_zip_acomp_init() {
>         ...
>         ret =3D hisi_zip_ctx_init(ctx, COMP_NAME_TO_TYPE(alg_name), tfm->=
base.node);
>         ...
>         ret =3D hisi_zip_create_req_q(ctx);
>         ...
> }
>
> Similarly, in drivers/crypto/intel/qat/qat_common/qat_comp_algs.c,
> qat_comp_alg_init_tfm() binds the transform to a single hardware compress=
ion
> ring pair on tfm->node:
>
> drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:qat_comp_alg_init_tfm=
() {
>         ...
>         inst =3D qat_compression_get_instance_node(node, alg);
>         if (!inst)
>                 return -EINVAL;
>         ctx->inst =3D inst;
>         ...
> }
>
> With a single pool->acomp allocated via crypto_alloc_acomp() (passing
> NUMA_NO_NODE), won't all CPUs across all NUMA nodes share and contend on =
a
> single hardware queue or ring pair on one accelerator device while leavin=
g
> all other hardware queues and NUMA-local devices unused?
>
> Also, if pool->acomp is shared across all CPUs, should the comment in
> zswap_compress() be updated as well? It currently still states:
>
> mm/zswap.c:zswap_compress() {
>         ...
>          * but in different threads running on different cpu, we have dif=
ferent
>          * acomp instance, and compression and decompression use separate
>          * requests, so multiple threads can do (de)compression in parall=
el.
>          */
> }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103000313.13=
677-1-kanchanapsridhar2026@gmail.com?part=3D1
