Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFF319F137
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252954; cv=none; b=rjwCUZAqdZAcv6f6Yo0LIBWV3y7S5FcQCwV90d4LJVlOgvmaN6L4SLc752xUK8dVgaj049lv2Rd0yAkVq1PF9sYC27ie2J0+dk2P0atSoER760GWfXrbUQnfcSPTzs0AY1aMvClH6s3s1nhPvk+auiH6Bn29/u3Xw263aqASP7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252954; c=relaxed/simple;
	bh=3TIUnaMNJegHr2uMi3ty/Rxvko3+soqxUBxLdSsFFmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AXFANwJSNgro14aVtGUsr1oY+bWlLMhTnf+vhJUJcez6qOYIQlnRWqsLFZkqaOtHD99iWV8O79TAz66TuekyDZIcPolpCvLbIKWU9tMS87HkynBCYUlwiOJxOGOWJ8KVy+BFOYjB7C3sU0McitlIUk8SDiAdwv6F6mO/lwPhrR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H+X25fg3; arc=none smtp.client-ip=95.215.58.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H+X25fg3"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3TIUnaMNJegHr2uMi3ty/Rxvko3+soqxUBxLdSsFFmc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792252949; v=1; x=1792857749;
 b=H+X25fg3kSVgbkwl44DuSSGBpdLoTDbZAfgfCHea7mC39cPQbcdlR8FOiWFo92vVmuqGCKCB
 k0sluPFs3zb+PPqtemu9aaRgFKeHHvlKfnVfmHGulfFjy+f0B/EwA6vOxTEfXSpmQdp8gqsNwtW
 omwLM6dWFVNfGyawXzenfRxU=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 0e5aa83133d443f6;
	Sat, 17 Oct 2026 16:02:29 +0000
X-Mizu-Trace-ID: 0e5aa83133d443f6
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 1/3] mm: zswap: use separate compression and decompression requests
Date: Sat, 17 Oct 2026 09:02:25 -0700
Message-ID: <20261017160226.2510957-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAO9r8zM-utRFYGBfaEb=89LWM0DOKc8dywcDLSb6L7f4c80yuQ@mail.gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 13:57:14 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Tue, Oct 13, 2026 at 8:10 AM Usama Arif <usama.arif@linux.dev> wrote:
> >
> > Stores and loads serialize on the same per-CPU acomp request and mutex.
> > A low-priority store can be preempted as soon as the compressor drops
> > its stream lock, while it still holds the mutex. A higher-priority load
> > on that CPU then waits until the store runs again, which can take a
> > long time when other tasks are runnable.
> >
> > Give compression and decompression their own request, completion wait
> > and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> > decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> > compression, so group it with the compression request. Independent
> > requests can share the per-CPU transform; the codecs and drivers
> > synchronize their shared state internally. Loads can still wait for
> > each other on the decompression mutex, and stores still serialize on
> > the compression mutex.
> >
> > acomp_request_free() ignores NULL requests, so drop the check in
> > acomp_ctx_free().
> >
> > This follows the proposal from Sergey Senozhatsky for the same split
> > for zram [1].
> >
> > [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
> >
> > Acked-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> Why didn't you take Herbert's Ack?

Ah completely forgot, will add it in the next revision and fix the nit below.

> 
> LGTM with one nit below:
> 
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> 

Thanks!


> > ---
> >  mm/zswap.c | 108 +++++++++++++++++++++++++++++++----------------------
> >  1 file changed, 64 insertions(+), 44 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index ae19e301fced7..23c4298765795 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -137,14 +137,25 @@ bool zswap_never_enabled(void)
> >  * data structures
> >  **********************************/
> >
> > -struct crypto_acomp_ctx {
> > -       struct crypto_acomp *acomp;
> > +struct zswap_acomp_req {
> >         struct acomp_req *req;
> >         struct crypto_wait wait;
> > -       u8 *buffer;
> >         struct mutex mutex;
> >  };
> >
> > +/* The compression mutex also protects the output buffer. */
> > +struct zswap_comp_ctx {
> > +       struct zswap_acomp_req areq;
> > +       u8 *buffer;
> > +};
> > +
> > +/* Separate requests, so that decompression does not wait for compression. */
> > +struct crypto_acomp_ctx {
> > +       struct crypto_acomp *acomp;
> > +       struct zswap_comp_ctx comp;
> > +       struct zswap_acomp_req decomp;
> > +};
> > +
> >  /*
> >   * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
> >   * The only case where lru_lock is not acquired while holding tree.lock is
> > @@ -270,14 +281,10 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
> >         if (!acomp_ctx)
> >                 return;
> >
> > -       /*
> > -        * If there was an error in allocating @acomp_ctx->req, it
> > -        * would be set to NULL.
> > -        */
> > -       if (acomp_ctx->req)
> > -               acomp_request_free(acomp_ctx->req);
> > -
> > -       acomp_ctx->req = NULL;
> > +       acomp_request_free(acomp_ctx->comp.areq.req);
> > +       acomp_ctx->comp.areq.req = NULL;
> > +       acomp_request_free(acomp_ctx->decomp.req);
> > +       acomp_ctx->decomp.req = NULL;
> >
> >         /*
> >          * We have to handle both cases here: an error pointer return from
> > @@ -289,8 +296,8 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
> >
> >         acomp_ctx->acomp = NULL;
> >
> > -       kfree(acomp_ctx->buffer);
> > -       acomp_ctx->buffer = NULL;
> > +       kfree(acomp_ctx->comp.buffer);
> > +       acomp_ctx->comp.buffer = NULL;
> >  }
> >
> >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > @@ -796,6 +803,28 @@ static void zswap_entry_free(struct zswap_entry *entry)
> >  /*********************************
> >  * compressed storage functions
> >  **********************************/
> > +static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
> > +                               struct crypto_acomp *acomp)
> > +{
> > +       /* acomp_request_alloc() returns NULL in case of an error. */
> > +       areq->req = acomp_request_alloc(acomp);
> > +       if (!areq->req)
> > +               return -ENOMEM;
> > +
> > +       crypto_init_wait(&areq->wait);
> > +
> > +       /*
> > +        * if the backend of acomp is async zip, crypto_req_done() will wakeup
> > +        * crypto_wait_req(); if the backend of acomp is scomp, the callback
> > +        * won't be called, crypto_wait_req() will return without blocking.
> > +        */
> > +       acomp_request_set_callback(areq->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +                                  crypto_req_done, &areq->wait);
> > +
> > +       mutex_init(&areq->mutex);
> > +       return 0;
> > +}
> > +
> >  static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> >  {
> >         struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> > @@ -811,8 +840,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> >                 return 0;
> >         }
> >
> > -       acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > -       if (!acomp_ctx->buffer)
> > +       acomp_ctx->comp.buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > +       if (!acomp_ctx->comp.buffer)
> >                 return ret;
> >
> >         /*
> > @@ -827,25 +856,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> >                 goto fail;
> >         }
> >
> > -       /* acomp_request_alloc() returns NULL in case of an error. */
> > -       acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> > -       if (!acomp_ctx->req) {
> > +       if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp) ||
> > +           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
> 
> We stop propagating the output of these functions to the caller here.
> It still works because ret is initialized as -ENOMEM, and that's the
> only possible failure of zswap_acomp_req_init(), but that's really
> subtle.
> 
> I'd rather either propagate the return value as-is on failure, or make
> zswap_acomp_req_init() a boolean so that it's obvious there's one
> failure mode and future changes can't just return a new error code
> that would be silently thrown away.
> 
> >                 pr_err("could not alloc crypto acomp_request %s\n",
> >                        pool->tfm_name);
> >                 goto fail;
> >         }
> >
> > -       crypto_init_wait(&acomp_ctx->wait);
> > -
> > -       /*
> > -        * if the backend of acomp is async zip, crypto_req_done() will wakeup
> > -        * crypto_wait_req(); if the backend of acomp is scomp, the callback
> > -        * won't be called, crypto_wait_req() will return without blocking.
> > -        */
> > -       acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > -                                  crypto_req_done, &acomp_ctx->wait);
> > -
> > -       mutex_init(&acomp_ctx->mutex);
> >         return 0;
> >
> >  fail:
> 
