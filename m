Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA506EC4
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jan 2025 00:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736211552; cv=none; b=lw5M0jhZuglAz2dlXYnYSwyfwvDUgKhCd2/IA/wHoyZ85xA7ECSP382Ei1ayYARtotAX4ChlJh2mxyO4C2AlA2SAaCECOWc3deFLqXtOgh1gVRvp2kjPl66kCVLe75KbVMlM39iGYMArylij5qJtBnV8ntle6M3ybfl+QR0lxas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736211552; c=relaxed/simple;
	bh=eDqJszZ+KlLE0sfcYdNHk6hH7Gkb3piwRBKzyX/o2z4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IicFGy5/mWHME9LimmsNlLL8W+vCA79UZCjPZAsXC4Wp43jJZoEohS4V7SnswJ9jis3LsShIA/zOllS5tY35mGSULI8kPSx7TCZtRO0PXXX40HddjjqARgH0I8EK97+JBAsePIccZtdj/Oqs2w44IRe4+cae9dePFwKjmojS/aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QS6CpFq4; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QS6CpFq4"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7b6e8fe401eso1248610485a.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jan 2025 16:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736211549; x=1736816349; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WeFORnNQK78XySFBYgxUmsgy0kgCAO436UvHH8FsbIc=;
        b=QS6CpFq4BpWQXv4I7SADnO+4ymodpuDZ0ww0MBASQSmnOUk/uRjrygOMeLcWVY0Pjm
         WjsUoCjnSmjt+XnEpFto/iRWk8ptq3nyJPeMOVSyRvJ3GuBsG5OKHoBwd7iR6/2CDEB4
         qC4/Pwuee5OXDH7Z6JX/jIR2Kv0S3cWfHhCrIXLCBe+qZX1xQzvH0CUafamskb96Kfyn
         I0NHMU1d8FR7y+F/k5y2rTy8ljmjejjWMco3EcG9c+YGoRpPaK6Xl67tWjjgUotr2qBx
         oTb4KBWqlUoQO9GNK+4OYRYLkUVOVuemlbzudkQCt4S7XxUl2ny7yXQC/8NF0aMg3Y9L
         G5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736211549; x=1736816349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WeFORnNQK78XySFBYgxUmsgy0kgCAO436UvHH8FsbIc=;
        b=YGymATXhluHGVCrqPrO+Pqe85r8cxL5qmTmTeUY86KaJblmpQ/QRaH6drYLZ6oJU5s
         3Y/ulYrKdtWuST/VfhUO9FmtC/WjxiuZUlC/y5ckxhXZqCH4bGA91BmARINtInwmr735
         VUrMO5hTpW+sbKciHA5W+nWndfAWBmoDIQGQ4HWEeyJ0uGuCySC32MSaJw7KiVtm6GMR
         A0qrlgmcyV8mfFGtCVW9KRMyU3llRP1PDp9PrbskmXVT8ebiMeSW9AyEtACF/fOW35RT
         WfbB2Dm3kSCcpVcnf27pAtRdu73ZFmzFbua6SSktjYqLTgaeNeJAwE9Vq0Md+5eLDNeA
         om/A==
X-Forwarded-Encrypted: i=1; AJvYcCU3h/vvbMMoVGCFLGemXNXgheHkk93QFdCGg18LhIzG5zYBcqqIJUYp3FrbEhjIgRSdSLI9AOyqxGjAREg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRrdyPC3x9/5mJRteWeiN+a2L9moov3wiZttTIc7LT9MmSapjo
	mCEvvq9+UC4CNRE5ibgUJyBbKZWMvTlL7PuEWpsn36Kfbs/DqDvTQUnW+Ybs7nLtr4/cSzuErvE
	VTqrx7KmXDEGTvOXQGf0owAqE+NzCvIzV8vHg
X-Gm-Gg: ASbGncuXNAcU3Yx2exiregmVMfbrsgX3gLzhKcKCOHLBtI+qBdqUURlv7d0kbh/zKZ5
	J4MJx4F2LtalhOV5H4gsxrrV44QTYJOr407Y=
X-Google-Smtp-Source: AGHT+IGvZxtw3OFyFU+SD1BuJrVvXiIJUbhG4lO80015a/itG0/Sg/bB3rarU7Ww7JCfQLGAtxS2OVJ11jnG3ubrwkQ=
X-Received: by 2002:a05:6214:b6e:b0:6d4:36ff:4356 with SMTP id
 6a1803df08f44-6dd2334645fmr1038040206d6.19.1736211549386; Mon, 06 Jan 2025
 16:59:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com> <20241221063119.29140-11-kanchana.p.sridhar@intel.com>
In-Reply-To: <20241221063119.29140-11-kanchana.p.sridhar@intel.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 6 Jan 2025 16:58:33 -0800
X-Gm-Features: AbW1kvZLS-11r0tfoNOsY5eT7vQ1teqMTDYZHluwmF70ZBUWLNCCxISHrLhjfgA
Message-ID: <CAJD7tkatD8Qw582C4gOsHRNgN3G7Qx=CxzV=FExhvroCaCAW6Q@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, akpm@linux-foundation.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2024 at 10:31=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch does the following:
>
> 1) Defines ZSWAP_MAX_BATCH_SIZE to denote the maximum number of acomp_ctx
>    batching resources (acomp_reqs and buffers) to allocate if the zswap
>    compressor supports batching. Currently, ZSWAP_MAX_BATCH_SIZE is set t=
o
>    8U.
>
> 2) Modifies the definition of "struct crypto_acomp_ctx" to represent a
>    configurable number of acomp_reqs and buffers. Adds a "nr_reqs" to
>    "struct crypto_acomp_ctx" to contain the number of resources that will
>    be allocated in the cpu hotplug onlining code.
>
> 3) The zswap_cpu_comp_prepare() cpu onlining code will detect if the
>    crypto_acomp created for the zswap pool (in other words, the zswap
>    compression algorithm) has registered implementations for
>    batch_compress() and batch_decompress().

This is an implementation detail that is not visible to the zswap
code. Please do not refer to batch_compress() and batch_decompress()
here, just mention that we check if the compressor supports batching.

> If so, it will query the
>    crypto_acomp for the maximum batch size supported by the compressor, a=
nd
>    set "nr_reqs" to the minimum of this compressor-specific max batch siz=
e
>    and ZSWAP_MAX_BATCH_SIZE. Finally, it will allocate "nr_reqs"
>    reqs/buffers, and set the acomp_ctx->nr_reqs accordingly.
>
> 4) If the crypto_acomp does not support batching, "nr_reqs" defaults to 1=
.

General note, some implementation details are obvious from the code
and do not need to be explained in the commit log. It's mostly useful
to explain what you are doing from a high level, and why you are doing
it.

In this case, we should mainly describe that we are adding support for
the per-CPU acomp_ctx to track multiple compression/decompression
requests but are not actually using more than one request yet. Mention
that followup changes will actually utilize this to batch
compression/decompression of multiple pages, and highlight important
implementation details (such as ZSWAP_MAX_BATCH_SIZE limiting the
amount of extra memory we are using for this, and that there is no
extra memory usage for compressors that do not use batching).

>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 122 +++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 90 insertions(+), 32 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 9718c33f8192..99cd78891fd0 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -78,6 +78,13 @@ static bool zswap_pool_reached_full;
>
>  #define ZSWAP_PARAM_UNSET ""
>
> +/*
> + * For compression batching of large folios:
> + * Maximum number of acomp compress requests that will be processed
> + * in a batch, iff the zswap compressor supports batching.
> + */

Please mention that this limit exists because we preallocate enough
requests and buffers accordingly, so a higher limit means higher
memory usage.

> +#define ZSWAP_MAX_BATCH_SIZE 8U
> +
>  static int zswap_setup(void);
>
>  /* Enable/disable zswap */
> @@ -143,9 +150,10 @@ bool zswap_never_enabled(void)
>
>  struct crypto_acomp_ctx {
>         struct crypto_acomp *acomp;
> -       struct acomp_req *req;
> +       struct acomp_req **reqs;
> +       u8 **buffers;
> +       unsigned int nr_reqs;
>         struct crypto_wait wait;
> -       u8 *buffer;
>         struct mutex mutex;
>         bool is_sleepable;
>  };
> @@ -818,49 +826,88 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>         struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
>         struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
>         struct crypto_acomp *acomp;
> -       struct acomp_req *req;
> -       int ret;
> +       unsigned int nr_reqs =3D 1;
> +       int ret =3D -ENOMEM;
> +       int i, j;
>
>         mutex_init(&acomp_ctx->mutex);
> -
> -       acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu=
_to_node(cpu));
> -       if (!acomp_ctx->buffer)
> -               return -ENOMEM;
> +       acomp_ctx->nr_reqs =3D 0;
>
>         acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_no=
de(cpu));
>         if (IS_ERR(acomp)) {
>                 pr_err("could not alloc crypto acomp %s : %ld\n",
>                                 pool->tfm_name, PTR_ERR(acomp));
> -               ret =3D PTR_ERR(acomp);
> -               goto acomp_fail;
> +               return PTR_ERR(acomp);
>         }
>         acomp_ctx->acomp =3D acomp;
>         acomp_ctx->is_sleepable =3D acomp_is_async(acomp);
>
> -       req =3D acomp_request_alloc(acomp_ctx->acomp);
> -       if (!req) {
> -               pr_err("could not alloc crypto acomp_request %s\n",
> -                      pool->tfm_name);
> -               ret =3D -ENOMEM;
> +       /*
> +        * Create the necessary batching resources if the crypto acomp al=
g
> +        * implements the batch_compress and batch_decompress API.

No mention of the internal implementation of acomp_has_async_batching() ple=
ase.

> +        */
> +       if (acomp_has_async_batching(acomp)) {
> +               nr_reqs =3D min(ZSWAP_MAX_BATCH_SIZE, crypto_acomp_batch_=
size(acomp));
> +               pr_info_once("Creating acomp_ctx with %d reqs/buffers for=
 batching since crypto acomp\n%s has registered batch_compress() and batch_=
decompress().\n",
> +                       nr_reqs, pool->tfm_name);

This will only be printed once, so if the compressor changes the
information will no longer be up-to-date on all CPUs. I think we
should just drop it.

> +       }
> +
> +       acomp_ctx->buffers =3D kmalloc_node(nr_reqs * sizeof(u8 *), GFP_K=
ERNEL, cpu_to_node(cpu));

Can we use kcalloc_node() here?

> +       if (!acomp_ctx->buffers)
> +               goto buf_fail;
> +
> +       for (i =3D 0; i < nr_reqs; ++i) {
> +               acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE * 2, GFP=
_KERNEL, cpu_to_node(cpu));
> +               if (!acomp_ctx->buffers[i]) {
> +                       for (j =3D 0; j < i; ++j)
> +                               kfree(acomp_ctx->buffers[j]);
> +                       kfree(acomp_ctx->buffers);
> +                       ret =3D -ENOMEM;
> +                       goto buf_fail;
> +               }
> +       }
> +
> +       acomp_ctx->reqs =3D kmalloc_node(nr_reqs * sizeof(struct acomp_re=
q *), GFP_KERNEL, cpu_to_node(cpu));

Ditto.

> +       if (!acomp_ctx->reqs)
>                 goto req_fail;
> +
> +       for (i =3D 0; i < nr_reqs; ++i) {
> +               acomp_ctx->reqs[i] =3D acomp_request_alloc(acomp_ctx->aco=
mp);
> +               if (!acomp_ctx->reqs[i]) {
> +                       pr_err("could not alloc crypto acomp_request reqs=
[%d] %s\n",
> +                              i, pool->tfm_name);
> +                       for (j =3D 0; j < i; ++j)
> +                               acomp_request_free(acomp_ctx->reqs[j]);
> +                       kfree(acomp_ctx->reqs);
> +                       ret =3D -ENOMEM;
> +                       goto req_fail;
> +               }
>         }
> -       acomp_ctx->req =3D req;
>
> +       /*
> +        * The crypto_wait is used only in fully synchronous, i.e., with =
scomp
> +        * or non-poll mode of acomp, hence there is only one "wait" per
> +        * acomp_ctx, with callback set to reqs[0], under the assumption =
that
> +        * there is at least 1 request per acomp_ctx.
> +        */
>         crypto_init_wait(&acomp_ctx->wait);
>         /*
>          * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
>          * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
>          * won't be called, crypto_wait_req() will return without blockin=
g.
>          */
> -       acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +       acomp_request_set_callback(acomp_ctx->reqs[0], CRYPTO_TFM_REQ_MAY=
_BACKLOG,
>                                    crypto_req_done, &acomp_ctx->wait);
>
> +       acomp_ctx->nr_reqs =3D nr_reqs;
>         return 0;
>
>  req_fail:
> +       for (i =3D 0; i < nr_reqs; ++i)
> +               kfree(acomp_ctx->buffers[i]);
> +       kfree(acomp_ctx->buffers);

The cleanup code is all over the place. Sometimes it's done in the
loops allocating the memory and sometimes here. It's a bit hard to
follow. Please have all the cleanups here. You can just initialize the
arrays to 0s, and then if the array is not-NULL you can free any
non-NULL elements (kfree() will handle NULLs gracefully).

There may be even potential for code reuse with zswap_cpu_comp_dead().

> +buf_fail:
>         crypto_free_acomp(acomp_ctx->acomp);
> -acomp_fail:
> -       kfree(acomp_ctx->buffer);
>         return ret;
>  }
>
> @@ -870,11 +917,22 @@ static int zswap_cpu_comp_dead(unsigned int cpu, st=
ruct hlist_node *node)
>         struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
>
>         if (!IS_ERR_OR_NULL(acomp_ctx)) {
> -               if (!IS_ERR_OR_NULL(acomp_ctx->req))
> -                       acomp_request_free(acomp_ctx->req);
> +               int i;
> +
> +               for (i =3D 0; i < acomp_ctx->nr_reqs; ++i)
> +                       if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
> +                               acomp_request_free(acomp_ctx->reqs[i]);
> +               kfree(acomp_ctx->reqs);
> +
> +               for (i =3D 0; i < acomp_ctx->nr_reqs; ++i)
> +                       kfree(acomp_ctx->buffers[i]);
> +               kfree(acomp_ctx->buffers);
> +
>                 if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
>                         crypto_free_acomp(acomp_ctx->acomp);
> -               kfree(acomp_ctx->buffer);
> +
> +               acomp_ctx->nr_reqs =3D 0;
> +               acomp_ctx =3D NULL;
>         }
>
>         return 0;
> @@ -897,7 +955,7 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>
>         mutex_lock(&acomp_ctx->mutex);
>
> -       dst =3D acomp_ctx->buffer;
> +       dst =3D acomp_ctx->buffers[0];
>         sg_init_table(&input, 1);
>         sg_set_page(&input, page, PAGE_SIZE, 0);
>
> @@ -907,7 +965,7 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>          * giving the dst buffer with enough length to avoid buffer overf=
low.
>          */
>         sg_init_one(&output, dst, PAGE_SIZE * 2);
> -       acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SI=
ZE, dlen);
> +       acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, PAG=
E_SIZE, dlen);
>
>         /*
>          * it maybe looks a little bit silly that we send an asynchronous=
 request,
> @@ -921,8 +979,8 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>          * but in different threads running on different cpu, we have dif=
ferent
>          * acomp instance, so multiple threads can do (de)compression in =
parallel.
>          */
> -       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
> -       dlen =3D acomp_ctx->req->dlen;
> +       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
s[0]), &acomp_ctx->wait);
> +       dlen =3D acomp_ctx->reqs[0]->dlen;
>         if (comp_ret)
>                 goto unlock;
>
> @@ -975,20 +1033,20 @@ static void zswap_decompress(struct zswap_entry *e=
ntry, struct folio *folio)
>          */
>         if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) |=
|
>             !virt_addr_valid(src)) {
> -               memcpy(acomp_ctx->buffer, src, entry->length);
> -               src =3D acomp_ctx->buffer;
> +               memcpy(acomp_ctx->buffers[0], src, entry->length);
> +               src =3D acomp_ctx->buffers[0];
>                 zpool_unmap_handle(zpool, entry->handle);
>         }
>
>         sg_init_one(&input, src, entry->length);
>         sg_init_table(&output, 1);
>         sg_set_folio(&output, folio, PAGE_SIZE, 0);
> -       acomp_request_set_params(acomp_ctx->req, &input, &output, entry->=
length, PAGE_SIZE);
> -       BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &=
acomp_ctx->wait));
> -       BUG_ON(acomp_ctx->req->dlen !=3D PAGE_SIZE);
> +       acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, ent=
ry->length, PAGE_SIZE);
> +       BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->reqs[0]=
), &acomp_ctx->wait));
> +       BUG_ON(acomp_ctx->reqs[0]->dlen !=3D PAGE_SIZE);
>         mutex_unlock(&acomp_ctx->mutex);
>
> -       if (src !=3D acomp_ctx->buffer)
> +       if (src !=3D acomp_ctx->buffers[0])
>                 zpool_unmap_handle(zpool, entry->handle);
>  }
>
> --
> 2.27.0
>
