Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BE5208A5
	for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2024 00:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729644831; cv=none; b=NsNTfDlVWjV3S6rQtDW3IsjFw2hNUWQsbSsv5AcNBF10FWIhFL0DsFT0R/u2sb9yPRsvpCBhzmxZbKFEiUBj3K0m5fRCXHDWO7NVJt+Vb5U/1/wZRI/llrdXAOplDlmgi8+qOYwDSSTyhWw88gwqW52R/vYs5KwvF0Pe0gxocMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729644831; c=relaxed/simple;
	bh=58G2ffkSWBtuGCrPtZed+KWSwSI10CYKhO2VL0MVVxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=la+xcVCzCw9EDL+b3KsdOrAfYdE85f64LatrE7Vi6B4qcH6krUDD7n7EEMqqC/v++ujc8L5nKNOUwjgDFy2Fd/NXYp+wj7uOthWAzOgKe6/YXoRMmMVy0AU7IEX07k7nqT9z36lMhdXKyZht/BygNtiGKUYy8btdqEnb0qz5/k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U1z/jJ5q; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U1z/jJ5q"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c9454f3bfaso7361048a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Oct 2024 17:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729644827; x=1730249627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=elKEUgYOBb9hlnUkKA6N1hOgZ0Y3H2ei9uKOJEOK+EY=;
        b=U1z/jJ5q2zmUM6X9uFO23lJiy78lUCia61l9JRZitEbRvCtZX8nxyd1/d1qW48JuW7
         AYZNtcRVPe8veUFIFkw42pH8bngQhXuHfrPb9yaVKTJ7+DBno68dtB6cOSoG6POAXwbV
         Nd7qpc3E/J/3j6b2WPYNekLbHNvfzeAb7Nya58zyml3aDsejPIDx7DmkgsnQ+Q5HI6or
         6Mhs5R961dLhHkvG18uSYKElMrNbCAwqEZQOxV8F9UHPvcF4hL8tNWQttLsnM8A3RT/6
         8x1+DuKX4hgcrgXpHuNKvTHWVDUDc0pLihsZwEKgLM+lTOcHZj3ykmyMsRd8NeIyXi1Y
         ka+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729644827; x=1730249627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=elKEUgYOBb9hlnUkKA6N1hOgZ0Y3H2ei9uKOJEOK+EY=;
        b=mTRlt7v7zHbI/Ll78R7U14WDyl2BAq0z63anwq0jMqU1kPQz6BAGt8T+kPxtg/YvJn
         v/kXMxv7aLqu+NQLtZHPTmUyT+iwDwuK2R4VNtF0ZtRegbepOTGmc5Lu9qgGPb9lRPHn
         ++R0XpzBJv9daqIuXQGfKgJD/GNQTh/rCIrqkBIqzSkoE9MzdQQUfW+m9zn8vNHjCEfk
         F4nmO07N9oBojRa4DBgJhXIDSpunaXPWWW0Jm1D2P1/wg0ir8vMF0FZ2cex8YzlDFFYM
         KEwMs4qjmVkJSKRiuXkLH71zEaDBfAaRax6xmN2NLiXrY/BJrAw6tqaOsQsS00oI2zuj
         dEqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDbccyj7Zpkfrl/BJYKDylKhsYLn94XJjWnzqrHdHNqLOmZ8jcLvdWxZEWPreRIYjfZ1dDTBqNRoMbDYY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbqCM0pdWLbIAO8KZCwlmdhwowSZ0rZ0ntYiCujNnMASOF1XDn
	zlGGHytYM7DMCqohWrxcvra18A5c0hBFb5rIUj20T8i7trVHZkMm/bSRzwwtnj7ZEmb5x6j4rXn
	MZlnfYjIIe+N3Z3FmO4w13a2CvJ2B0jZfh1X9
X-Google-Smtp-Source: AGHT+IFvb4nuTDqZSgOQT/PkUifYMSJP87uSJMegevloYuQ+XMxD6rU7IQjfW1EjkbdiLAZ2EDHqJEJt3TT9St/pBug=
X-Received: by 2002:a17:907:86a1:b0:a9a:5b8d:68ad with SMTP id
 a640c23a62f3a-a9abf94da9emr60511966b.48.1729644826990; Tue, 22 Oct 2024
 17:53:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241018064101.336232-1-kanchana.p.sridhar@intel.com> <20241018064101.336232-12-kanchana.p.sridhar@intel.com>
In-Reply-To: <20241018064101.336232-12-kanchana.p.sridhar@intel.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 22 Oct 2024 17:53:11 -0700
Message-ID: <CAJD7tkZnEp98A+bP4N8GvFn=vT5Ck4NgrqsFQn+V8gpSbyAzkg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 11/13] mm: swap: Add IAA batch compression API swap_crypto_acomp_compress_batch().
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
> Added a new API swap_crypto_acomp_compress_batch() that does batch
> compression. A system that has Intel IAA can avail of this API to submit =
a
> batch of compress jobs for parallel compression in the hardware, to impro=
ve
> performance. On a system without IAA, this API will process each compress
> job sequentially.
>
> The purpose of this API is to be invocable from any swap module that need=
s
> to compress large folios, or a batch of pages in the general case. For
> instance, zswap would batch compress up to SWAP_CRYPTO_SUB_BATCH_SIZE
> (i.e. 8 if the system has IAA) pages in the large folio in parallel to
> improve zswap_store() performance.
>
> Towards this eventual goal:
>
> 1) The definition of "struct crypto_acomp_ctx" is moved to mm/swap.h
>    so that mm modules like swap_state.c and zswap.c can reference it.
> 2) The swap_crypto_acomp_compress_batch() interface is implemented in
>    swap_state.c.
>
> It would be preferable for "struct crypto_acomp_ctx" to be defined in,
> and for swap_crypto_acomp_compress_batch() to be exported via
> include/linux/swap.h so that modules outside mm (for e.g. zram) can
> potentially use the API for batch compressions with IAA. I would
> appreciate RFC comments on this.

Same question as the last patch, why does this need to be in the swap
code? Why can't zswap just submit a single request to compress a large
folio or a range of contiguous subpages at once?

>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/swap.h       |  45 +++++++++++++++++++
>  mm/swap_state.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/zswap.c      |   9 ----
>  3 files changed, 160 insertions(+), 9 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 566616c971d4..4dcb67e2cc33 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -7,6 +7,7 @@ struct mempolicy;
>  #ifdef CONFIG_SWAP
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
> +#include <linux/crypto.h>
>
>  /*
>   * For IAA compression batching:
> @@ -19,6 +20,39 @@ struct mempolicy;
>  #define SWAP_CRYPTO_SUB_BATCH_SIZE 1UL
>  #endif
>
> +/* linux/mm/swap_state.c, zswap.c */
> +struct crypto_acomp_ctx {
> +       struct crypto_acomp *acomp;
> +       struct acomp_req *req[SWAP_CRYPTO_SUB_BATCH_SIZE];
> +       u8 *buffer[SWAP_CRYPTO_SUB_BATCH_SIZE];
> +       struct crypto_wait wait;
> +       struct mutex mutex;
> +       bool is_sleepable;
> +};
> +
> +/**
> + * This API provides IAA compress batching functionality for use by swap
> + * modules.
> + * The acomp_ctx mutex should be locked/unlocked before/after calling th=
is
> + * procedure.
> + *
> + * @pages: Pages to be compressed.
> + * @dsts: Pre-allocated destination buffers to store results of IAA comp=
ression.
> + * @dlens: Will contain the compressed lengths.
> + * @errors: Will contain a 0 if the page was successfully compressed, or=
 a
> + *          non-0 error value to be processed by the calling function.
> + * @nr_pages: The number of pages, up to SWAP_CRYPTO_SUB_BATCH_SIZE,
> + *            to be compressed.
> + * @acomp_ctx: The acomp context for iaa_crypto/other compressor.
> + */
> +void swap_crypto_acomp_compress_batch(
> +       struct page *pages[],
> +       u8 *dsts[],
> +       unsigned int dlens[],
> +       int errors[],
> +       int nr_pages,
> +       struct crypto_acomp_ctx *acomp_ctx);
> +
>  /* linux/mm/page_io.c */
>  int sio_pool_init(void);
>  struct swap_iocb;
> @@ -119,6 +153,17 @@ static inline int swap_zeromap_batch(swp_entry_t ent=
ry, int max_nr,
>
>  #else /* CONFIG_SWAP */
>  struct swap_iocb;
> +struct crypto_acomp_ctx {};
> +static inline void swap_crypto_acomp_compress_batch(
> +       struct page *pages[],
> +       u8 *dsts[],
> +       unsigned int dlens[],
> +       int errors[],
> +       int nr_pages,
> +       struct crypto_acomp_ctx *acomp_ctx)
> +{
> +}
> +
>  static inline void swap_read_folio(struct folio *folio, struct swap_iocb=
 **plug)
>  {
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 4669f29cf555..117c3caa5679 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -23,6 +23,8 @@
>  #include <linux/swap_slots.h>
>  #include <linux/huge_mm.h>
>  #include <linux/shmem_fs.h>
> +#include <linux/scatterlist.h>
> +#include <crypto/acompress.h>
>  #include "internal.h"
>  #include "swap.h"
>
> @@ -742,6 +744,119 @@ void exit_swap_address_space(unsigned int type)
>         swapper_spaces[type] =3D NULL;
>  }
>
> +#ifdef CONFIG_SWAP
> +
> +/**
> + * This API provides IAA compress batching functionality for use by swap
> + * modules.
> + * The acomp_ctx mutex should be locked/unlocked before/after calling th=
is
> + * procedure.
> + *
> + * @pages: Pages to be compressed.
> + * @dsts: Pre-allocated destination buffers to store results of IAA comp=
ression.
> + * @dlens: Will contain the compressed lengths.
> + * @errors: Will contain a 0 if the page was successfully compressed, or=
 a
> + *          non-0 error value to be processed by the calling function.
> + * @nr_pages: The number of pages, up to SWAP_CRYPTO_SUB_BATCH_SIZE,
> + *            to be compressed.
> + * @acomp_ctx: The acomp context for iaa_crypto/other compressor.
> + */
> +void swap_crypto_acomp_compress_batch(
> +       struct page *pages[],
> +       u8 *dsts[],
> +       unsigned int dlens[],
> +       int errors[],
> +       int nr_pages,
> +       struct crypto_acomp_ctx *acomp_ctx)
> +{
> +       struct scatterlist inputs[SWAP_CRYPTO_SUB_BATCH_SIZE];
> +       struct scatterlist outputs[SWAP_CRYPTO_SUB_BATCH_SIZE];
> +       bool compressions_done =3D false;
> +       int i, j;
> +
> +       BUG_ON(nr_pages > SWAP_CRYPTO_SUB_BATCH_SIZE);
> +
> +       /*
> +        * Prepare and submit acomp_reqs to IAA.
> +        * IAA will process these compress jobs in parallel in async mode=
.
> +        * If the compressor does not support a poll() method, or if IAA =
is
> +        * used in sync mode, the jobs will be processed sequentially usi=
ng
> +        * acomp_ctx->req[0] and acomp_ctx->wait.
> +        */
> +       for (i =3D 0; i < nr_pages; ++i) {
> +               j =3D acomp_ctx->acomp->poll ? i : 0;
> +               sg_init_table(&inputs[i], 1);
> +               sg_set_page(&inputs[i], pages[i], PAGE_SIZE, 0);
> +
> +               /*
> +                * Each acomp_ctx->buffer[] is of size (PAGE_SIZE * 2).
> +                * Reflect same in sg_list.
> +                */
> +               sg_init_one(&outputs[i], dsts[i], PAGE_SIZE * 2);
> +               acomp_request_set_params(acomp_ctx->req[j], &inputs[i],
> +                                        &outputs[i], PAGE_SIZE, dlens[i]=
);
> +
> +               /*
> +                * If the crypto_acomp provides an asynchronous poll()
> +                * interface, submit the request to the driver now, and p=
oll for
> +                * a completion status later, after all descriptors have =
been
> +                * submitted. If the crypto_acomp does not provide a poll=
()
> +                * interface, submit the request and wait for it to compl=
ete,
> +                * i.e., synchronously, before moving on to the next requ=
est.
> +                */
> +               if (acomp_ctx->acomp->poll) {
> +                       errors[i] =3D crypto_acomp_compress(acomp_ctx->re=
q[j]);
> +
> +                       if (errors[i] !=3D -EINPROGRESS)
> +                               errors[i] =3D -EINVAL;
> +                       else
> +                               errors[i] =3D -EAGAIN;
> +               } else {
> +                       errors[i] =3D crypto_wait_req(
> +                                             crypto_acomp_compress(acomp=
_ctx->req[j]),
> +                                             &acomp_ctx->wait);
> +                       if (!errors[i])
> +                               dlens[i] =3D acomp_ctx->req[j]->dlen;
> +               }
> +       }
> +
> +       /*
> +        * If not doing async compressions, the batch has been processed =
at
> +        * this point and we can return.
> +        */
> +       if (!acomp_ctx->acomp->poll)
> +               return;
> +
> +       /*
> +        * Poll for and process IAA compress job completions
> +        * in out-of-order manner.
> +        */
> +       while (!compressions_done) {
> +               compressions_done =3D true;
> +
> +               for (i =3D 0; i < nr_pages; ++i) {
> +                       /*
> +                        * Skip, if the compression has already completed
> +                        * successfully or with an error.
> +                        */
> +                       if (errors[i] !=3D -EAGAIN)
> +                               continue;
> +
> +                       errors[i] =3D crypto_acomp_poll(acomp_ctx->req[i]=
);
> +
> +                       if (errors[i]) {
> +                               if (errors[i] =3D=3D -EAGAIN)
> +                                       compressions_done =3D false;
> +                       } else {
> +                               dlens[i] =3D acomp_ctx->req[i]->dlen;
> +                       }
> +               }
> +       }
> +}
> +EXPORT_SYMBOL_GPL(swap_crypto_acomp_compress_batch);
> +
> +#endif /* CONFIG_SWAP */
> +
>  static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
>                            unsigned long *end)
>  {
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 579869d1bdf6..cab3114321f9 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -150,15 +150,6 @@ bool zswap_never_enabled(void)
>  * data structures
>  **********************************/
>
> -struct crypto_acomp_ctx {
> -       struct crypto_acomp *acomp;
> -       struct acomp_req *req[SWAP_CRYPTO_SUB_BATCH_SIZE];
> -       u8 *buffer[SWAP_CRYPTO_SUB_BATCH_SIZE];
> -       struct crypto_wait wait;
> -       struct mutex mutex;
> -       bool is_sleepable;
> -};
> -
>  /*
>   * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
>   * The only case where lru_lock is not acquired while holding tree.lock =
is
> --
> 2.27.0
>
