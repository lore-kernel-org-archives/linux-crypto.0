Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF15E1E47B1
	for <linux-crypto@vger.kernel.org>; Fri,  8 Nov 2024 20:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731097380; cv=none; b=cLe9djDeZo+Yt0oJ8eZqwKiWa7/AMziTMoybt63CZog+K9L7azmDxhSFXYlCkCiBa89YzobU2HgJcdo76LMPp38ttlZIMUaT8UdPgvsIij0vwVi3JJFraDA66iovBkWNHHHduJtoCr5W6MhJvEjT8JGUmY15A2mfdvbFbIqw01U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731097380; c=relaxed/simple;
	bh=3TaFMvCIfdL7mNUddxjurzlwZsffRo/yJgzOOsh8UkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uoAvAX4F7yNXe41JeaSxke+i+FTe89eQ14CXjBjJPzIoxNah6RAzoqyGJH1+gFFdAewfFakO/kvcRTmsZYxQyEA7cfKYHgoY7YPYhnjJDX5GQJtmCR2JyZ3TplBGKIj/BQh+plehntSo5JHVNpAJNSblIDi9l6BcRPATUTtYViM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pP7ptgzz; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pP7ptgzz"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5ebc27fdc30so1426839eaf.2
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2024 12:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731097378; x=1731702178; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j2hzwMt1vCXwnRJDBw66UYNW1buQGS3Aq1RmBj4RhN4=;
        b=pP7ptgzz8FrBtFhwwg1QOafw2OZx5i6x5MDqmYEmbyq6uGC6d8KKJHLpU3fVVVNkYY
         EtDiBg0sm1qJZgS6fh1FSrHfeb4SgpeACHq7wLKSw2hAdu1xa1+5U9D7OQ6gjiU6LQCG
         6cbim6iWGkHKqibcURTCRwNjZiT3fgXDogUQmVlT4MNkhiMPYdNE0tddUfYiYd4tuIJI
         JzTLPhMFT4T7U86QMilGvX+JreNG9LDSnzq5Cgtszflk7rzsRSjKtsTa/KXy6RHlRcLa
         oofvbIAS4Wl8SIqrGn9Mzi+HewmTuH6ubfkqj/r1r4hCQnYMCpPp3kW4GUEBIo8j1sTG
         yvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731097378; x=1731702178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j2hzwMt1vCXwnRJDBw66UYNW1buQGS3Aq1RmBj4RhN4=;
        b=T/3am8M2lRIz3Es27WB+pk6boQh1/i7eN8oBp31l1LUTlvj5II6xZyxU+UbgQLJPi1
         ouY5SOuEmDgp62cpWBNmapCIEHn4om0LJvhfqCF1vtbQ9IYd/0jkG5xKH54pBoolHjdL
         ryl8RgMj7lPhSJQ1M5rySK0AVKOF2xW4Z7XW2Wa/hKQlYX4kzgGQNmgDfhaFNvDmLBaM
         xAn/YnCu2iaNlwAtN3QCAKnLMhuVYsqT5QyMzVNVFXBc1Lr0LmFtxTZcmuGI+YkHSwdr
         4BJ6jF50HikF+BiqAHrrkIeMN0ZPuIrR9TVKOctsRHmcJCqB6XmAm64a6RJRCkk4qbRF
         JxOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDuKj3UlUSg1TLsMnoRZgFF/2uc/qhpKCVdD54he94tCf4Ytt764UoVjRPMJ7e8nzemUIAVuuAnmlpEq8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx10+xLNCeraJ949XdtqxDIELr74V3v5Ip0kBsgppemJVWSLnPU
	SyUK9R/aZ7+1OJLrQiCOVF8r9WvtM3h7C8sjG7yJPuOgcpWYFU/OcFl2rOKzZy+pxE8VXcIUt6O
	geGbHIhZXf/7srd4JYHZhoa5CgHSpaIbjKgJK
X-Google-Smtp-Source: AGHT+IFjyt9auLSTN4OrHmI8xBiTct7D6gWyd04J3d54pyx6QKB4P4jpozUdfP8sQsvTQ9DB0xUuNIhWiKVawHd0fqg=
X-Received: by 2002:a05:6358:5d84:b0:1bc:d0a4:3d3a with SMTP id
 e5c5f4694b2df-1c641ec23bcmr361609655d.12.1731097377665; Fri, 08 Nov 2024
 12:22:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-10-kanchana.p.sridhar@intel.com> <20241107172056.GC1172372@cmpxchg.org>
 <SJ0PR11MB5678FA2EA40FEFE20521AC6BC95C2@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5678FA2EA40FEFE20521AC6BC95C2@SJ0PR11MB5678.namprd11.prod.outlook.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Fri, 8 Nov 2024 12:22:21 -0800
Message-ID: <CAJD7tkZrdrez2mohU_SRb3SYho5JGgwGYK4-imvfCNvSHfe=Eg@mail.gmail.com>
Subject: Re: [PATCH v3 09/13] mm: zswap: Modify struct crypto_acomp_ctx to be
 configurable in nr of acomp_reqs.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"Huang, Ying" <ying.huang@intel.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 2:21=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
> Hi Johannes,
>
> > -----Original Message-----
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > Sent: Thursday, November 7, 2024 9:21 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > yosryahmed@google.com; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; Huang, Ying <ying.huang@intel.com>;
> > 21cnbao@gmail.com; akpm@linux-foundation.org; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; zanussi@kernel.org; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v3 09/13] mm: zswap: Modify struct crypto_acomp_ctx
> > to be configurable in nr of acomp_reqs.
> >
> > On Wed, Nov 06, 2024 at 11:21:01AM -0800, Kanchana P Sridhar wrote:
> > > Modified the definition of "struct crypto_acomp_ctx" to represent a
> > > configurable number of acomp_reqs and the required number of buffers.
> > >
> > > Accordingly, refactored the code that allocates/deallocates the acomp=
_ctx
> > > resources, so that it can be called to create a regular acomp_ctx wit=
h
> > > exactly one acomp_req/buffer, for use in the the existing non-batchin=
g
> > > zswap_store(), as well as to create a separate "batching acomp_ctx" w=
ith
> > > multiple acomp_reqs/buffers for IAA compress batching.
> > >
> > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > > ---
> > >  mm/zswap.c | 149 ++++++++++++++++++++++++++++++++++++++----------
> > -----
> > >  1 file changed, 107 insertions(+), 42 deletions(-)
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 3e899fa61445..02e031122fdf 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -143,9 +143,10 @@ bool zswap_never_enabled(void)
> > >
> > >  struct crypto_acomp_ctx {
> > >     struct crypto_acomp *acomp;
> > > -   struct acomp_req *req;
> > > +   struct acomp_req **reqs;
> > > +   u8 **buffers;
> > > +   unsigned int nr_reqs;
> > >     struct crypto_wait wait;
> > > -   u8 *buffer;
> > >     struct mutex mutex;
> > >     bool is_sleepable;
> > >  };
> > > @@ -241,6 +242,11 @@ static inline struct xarray
> > *swap_zswap_tree(swp_entry_t swp)
> > >     pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,         \
> > >              zpool_get_type((p)->zpool))
> > >
> > > +static int zswap_create_acomp_ctx(unsigned int cpu,
> > > +                             struct crypto_acomp_ctx *acomp_ctx,
> > > +                             char *tfm_name,
> > > +                             unsigned int nr_reqs);
> >
> > This looks unnecessary.
>
> Thanks for the code review comments. I will make sure to avoid the
> forward declarations.
>
> >
> > > +
> > >  /*********************************
> > >  * pool functions
> > >  **********************************/
> > > @@ -813,69 +819,128 @@ static void zswap_entry_free(struct
> > zswap_entry *entry)
> > >  /*********************************
> > >  * compressed storage functions
> > >  **********************************/
> > > -static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_nod=
e
> > *node)
> > > +static int zswap_create_acomp_ctx(unsigned int cpu,
> > > +                             struct crypto_acomp_ctx *acomp_ctx,
> > > +                             char *tfm_name,
> > > +                             unsigned int nr_reqs)
> > >  {
> > > -   struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> > node);
> > > -   struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> > >acomp_ctx, cpu);
> > >     struct crypto_acomp *acomp;
> > > -   struct acomp_req *req;
> > > -   int ret;
> > > +   int ret =3D -ENOMEM;
> > > +   int i, j;
> > >
> > > +   acomp_ctx->nr_reqs =3D 0;
> > >     mutex_init(&acomp_ctx->mutex);
> > >
> > > -   acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
> > cpu_to_node(cpu));
> > > -   if (!acomp_ctx->buffer)
> > > -           return -ENOMEM;
> > > -
> > > -   acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0,
> > cpu_to_node(cpu));
> > > +   acomp =3D crypto_alloc_acomp_node(tfm_name, 0, 0,
> > cpu_to_node(cpu));
> > >     if (IS_ERR(acomp)) {
> > >             pr_err("could not alloc crypto acomp %s : %ld\n",
> > > -                           pool->tfm_name, PTR_ERR(acomp));
> > > -           ret =3D PTR_ERR(acomp);
> > > -           goto acomp_fail;
> > > +                           tfm_name, PTR_ERR(acomp));
> > > +           return PTR_ERR(acomp);
> > >     }
> > > +
> > >     acomp_ctx->acomp =3D acomp;
> > >     acomp_ctx->is_sleepable =3D acomp_is_async(acomp);
> > >
> > > -   req =3D acomp_request_alloc(acomp_ctx->acomp);
> > > -   if (!req) {
> > > -           pr_err("could not alloc crypto acomp_request %s\n",
> > > -                  pool->tfm_name);
> > > -           ret =3D -ENOMEM;
> > > +   acomp_ctx->buffers =3D kmalloc_node(nr_reqs * sizeof(u8 *),
> > > +                                     GFP_KERNEL, cpu_to_node(cpu));
> > > +   if (!acomp_ctx->buffers)
> > > +           goto buf_fail;
> > > +
> > > +   for (i =3D 0; i < nr_reqs; ++i) {
> > > +           acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE * 2,
> > > +                                                GFP_KERNEL,
> > cpu_to_node(cpu));
> > > +           if (!acomp_ctx->buffers[i]) {
> > > +                   for (j =3D 0; j < i; ++j)
> > > +                           kfree(acomp_ctx->buffers[j]);
> > > +                   kfree(acomp_ctx->buffers);
> > > +                   ret =3D -ENOMEM;
> > > +                   goto buf_fail;
> > > +           }
> > > +   }
> > > +
> > > +   acomp_ctx->reqs =3D kmalloc_node(nr_reqs * sizeof(struct acomp_re=
q
> > *),
> > > +                                  GFP_KERNEL, cpu_to_node(cpu));
> > > +   if (!acomp_ctx->reqs)
> > >             goto req_fail;
> > > +
> > > +   for (i =3D 0; i < nr_reqs; ++i) {
> > > +           acomp_ctx->reqs[i] =3D acomp_request_alloc(acomp_ctx-
> > >acomp);
> > > +           if (!acomp_ctx->reqs[i]) {
> > > +                   pr_err("could not alloc crypto acomp_request
> > reqs[%d] %s\n",
> > > +                          i, tfm_name);
> > > +                   for (j =3D 0; j < i; ++j)
> > > +                           acomp_request_free(acomp_ctx->reqs[j]);
> > > +                   kfree(acomp_ctx->reqs);
> > > +                   ret =3D -ENOMEM;
> > > +                   goto req_fail;
> > > +           }
> > >     }
> > > -   acomp_ctx->req =3D req;
> > >
> > > +   /*
> > > +    * The crypto_wait is used only in fully synchronous, i.e., with =
scomp
> > > +    * or non-poll mode of acomp, hence there is only one "wait" per
> > > +    * acomp_ctx, with callback set to reqs[0], under the assumption =
that
> > > +    * there is at least 1 request per acomp_ctx.
> > > +    */
> > >     crypto_init_wait(&acomp_ctx->wait);
> > >     /*
> > >      * if the backend of acomp is async zip, crypto_req_done() will
> > wakeup
> > >      * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
> > >      * won't be called, crypto_wait_req() will return without blockin=
g.
> > >      */
> > > -   acomp_request_set_callback(req,
> > CRYPTO_TFM_REQ_MAY_BACKLOG,
> > > +   acomp_request_set_callback(acomp_ctx->reqs[0],
> > CRYPTO_TFM_REQ_MAY_BACKLOG,
> > >                                crypto_req_done, &acomp_ctx->wait);
> > >
> > > +   acomp_ctx->nr_reqs =3D nr_reqs;
> > >     return 0;
> > >
> > >  req_fail:
> > > +   for (i =3D 0; i < nr_reqs; ++i)
> > > +           kfree(acomp_ctx->buffers[i]);
> > > +   kfree(acomp_ctx->buffers);
> > > +buf_fail:
> > >     crypto_free_acomp(acomp_ctx->acomp);
> > > -acomp_fail:
> > > -   kfree(acomp_ctx->buffer);
> > >     return ret;
> > >  }
> > >
> > > -static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node
> > *node)
> > > +static void zswap_delete_acomp_ctx(struct crypto_acomp_ctx
> > *acomp_ctx)
> > >  {
> > > -   struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> > node);
> > > -   struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> > >acomp_ctx, cpu);
> > > -
> > >     if (!IS_ERR_OR_NULL(acomp_ctx)) {
> > > -           if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > > -                   acomp_request_free(acomp_ctx->req);
> > > +           int i;
> > > +
> > > +           for (i =3D 0; i < acomp_ctx->nr_reqs; ++i)
> > > +                   if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
> > > +                           acomp_request_free(acomp_ctx->reqs[i]);
> > > +           kfree(acomp_ctx->reqs);
> > > +
> > > +           for (i =3D 0; i < acomp_ctx->nr_reqs; ++i)
> > > +                   kfree(acomp_ctx->buffers[i]);
> > > +           kfree(acomp_ctx->buffers);
> > > +
> > >             if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > >                     crypto_free_acomp(acomp_ctx->acomp);
> > > -           kfree(acomp_ctx->buffer);
> > > +
> > > +           acomp_ctx->nr_reqs =3D 0;
> > > +           acomp_ctx =3D NULL;
> > >     }
> > > +}
> > > +
> > > +static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_nod=
e
> > *node)
> > > +{
> > > +   struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> > node);
> > > +   struct crypto_acomp_ctx *acomp_ctx;
> > > +
> > > +   acomp_ctx =3D per_cpu_ptr(pool->acomp_ctx, cpu);
> > > +   return zswap_create_acomp_ctx(cpu, acomp_ctx, pool->tfm_name,
> > 1);
> > > +}
> > > +
> > > +static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node
> > *node)
> > > +{
> > > +   struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> > node);
> > > +   struct crypto_acomp_ctx *acomp_ctx;
> > > +
> > > +   acomp_ctx =3D per_cpu_ptr(pool->acomp_ctx, cpu);
> > > +   zswap_delete_acomp_ctx(acomp_ctx);
> > >
> > >     return 0;
> > >  }
> >
> > There are no other callers to these functions. Just do the work
> > directly in the cpu callbacks here like it used to be.
>
> There will be other callers to zswap_create_acomp_ctx() and
> zswap_delete_acomp_ctx() in patches 10 and 11 of this series, when the
> per-cpu "acomp_batch_ctx" is introduced in struct zswap_pool. I was tryin=
g
> to modularize the code first, so as to split the changes into smaller com=
mits.
>
> The per-cpu "acomp_batch_ctx" resources are allocated in patch 11 in the
> "zswap_pool_can_batch()" function, that allocates batching resources
> for this cpu. This was to address Yosry's earlier comment about minimizin=
g
> the memory footprint cost of batching.
>
> The way I decided to do this is by reusing the code that allocates the de=
-facto
> pool->acomp_ctx for the selected compressor for all cpu's in zswap_pool_c=
reate().
> However, I did not want to add the acomp_batch_ctx multiple reqs/buffers
> allocation to the cpuhp_state_add_instance() code path which would incur =
the
> memory cost on all cpu's.
>
> Instead, the approach I chose to follow is to allocate the batching resou=
rces
> in patch 11 only as needed, on "a given cpu" that has to store a large fo=
lio. Hope
> this explains the purpose of the modularization better.
>
> Other ideas towards accomplishing this are very welcome.

If we remove the sysctl as suggested by Johannes, then we can just
allocate the number of buffers based on the compressor and whether it
supports batching during the pool initialization in the cpu callbacks
only.

Right?

>
> Thanks,
> Kanchana
>
> >
> > Otherwise it looks good to me.
