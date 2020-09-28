Return-Path: <SRS0=0P/0=DF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C56C2D0A8
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Sep 2020 15:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D2F621548
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Sep 2020 15:24:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="4DY4Itmk";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ofMbZh7H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgI1PYg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Sep 2020 11:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgI1PYg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Sep 2020 11:24:36 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FAEC061755;
        Mon, 28 Sep 2020 08:24:35 -0700 (PDT)
Date:   Mon, 28 Sep 2020 17:24:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601306674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wbp8RnKXpkPruMdK0XgZ83gTD+4W5fzBYxcGwVrJPmc=;
        b=4DY4ItmkyLGXIsFWrYLAc3qO3pICg5yne/nxMmBgsvcQgeqmM1M4p11cMyzPeUr5tmNhrN
        Hh4kAsfNPSchb9Jq5Y0FNlXmK5VJg2cOVZHf+XoGE0AlM9az5tXq1475iCF5+ApH+qWrwS
        4kW4BJVlDKtpecN8ppKxDOWgOv9M+wjRs25XVw5oY33CP/hR8s/wQy1fEZC8owEVptsGRZ
        NWbbe2Stc1R+Cf6xjTD7hl7mt3hHlps8sjQNFtX2pm7XuGFt0+OFpBrIiGUthAVilEdfKz
        ry4quSO4bbmRYaMZBPVwrFtrBH8EJceqTktP5qWW3BttsR4Zjp62i9HXz8nYKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601306674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wbp8RnKXpkPruMdK0XgZ83gTD+4W5fzBYxcGwVrJPmc=;
        b=ofMbZh7HEyJ90NUIYGOHl5m946yjPc/+byRarwJ2Ujh8/grgWpvkHl/gt+3HQzeGvIEZ1s
        3sWSAV+ZDbDqsxAA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Barry Song <song.bao.hua@hisilicon.com>
Cc:     akpm@linux-foundation.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v6] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Message-ID: <20200928152432.l3auscdx2suyli4u@linutronix.de>
References: <20200818123100.4140-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200818123100.4140-1-song.bao.hua@hisilicon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-08-19 00:31:00 [+1200], Barry Song wrote:
> diff --git a/mm/zswap.c b/mm/zswap.c
> index fbb782924ccc..00b5f14a7332 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -127,9 +129,17 @@ module_param_named(same_filled_pages_enabled, zswap_=
same_filled_pages_enabled,
>  * data structures
>  **********************************/
> =20
> +struct crypto_acomp_ctx {
> +	struct crypto_acomp *acomp;
> +	struct acomp_req *req;
> +	struct crypto_wait wait;
> +	u8 *dstmem;
> +	struct mutex *mutex;
> +};
> +
>  struct zswap_pool {
>  	struct zpool *zpool;
> -	struct crypto_comp * __percpu *tfm;
> +	struct crypto_acomp_ctx __percpu *acomp_ctx;
>  	struct kref kref;
>  	struct list_head list;
>  	struct work_struct release_work;
> @@ -388,23 +398,43 @@ static struct zswap_entry *zswap_entry_find_get(str=
uct rb_root *root,
>  * per-cpu code
>  **********************************/
>  static DEFINE_PER_CPU(u8 *, zswap_dstmem);
> +/*
> + * If users dynamically change the zpool type and compressor at runtime,=
 i.e.
> + * zswap is running, zswap can have more than one zpool on one cpu, but =
they
> + * are sharing dtsmem. So we need this mutex to be per-cpu.
> + */
> +static DEFINE_PER_CPU(struct mutex *, zswap_mutex);

There is no need to make it sturct mutex*. You could make it struct
mutex. The following make it more obvious how the relation here is (even
without a comment):

|struct zswap_mem_pool {
|	void		*dst_mem;
|	struct mutex	lock;
|};
|
|static DEFINE_PER_CPU(struct zswap_mem_pool , zswap_mem_pool);

Please access only this, don't add use a pointer in a another struct to
dest_mem or lock which may confuse people.

This resource is per-CPU.  Do you really utilize them all? On 2, 8, 16,
64, 128 core system? More later=E2=80=A6

> @@ -916,14 +974,21 @@ static int zswap_writeback_entry(struct zpool *pool=
, unsigned long handle)
> =20
>  	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
>  		/* decompress */
> +		acomp_ctx =3D this_cpu_ptr(entry->pool->acomp_ctx);

My feeling is that this triggers a warning with CONFIG_DEBUG_PREEMPT. I
don't see how it could be avoid it. If you are not preemptible here then
you must not sleep later.

> +
>  		dlen =3D PAGE_SIZE;
>  		src =3D (u8 *)zhdr + sizeof(struct zswap_header);
> -		dst =3D kmap_atomic(page);
> -		tfm =3D *get_cpu_ptr(entry->pool->tfm);
> -		ret =3D crypto_comp_decompress(tfm, src, entry->length,
> -					     dst, &dlen);
> -		put_cpu_ptr(entry->pool->tfm);
> -		kunmap_atomic(dst);
> +		dst =3D kmap(page);
> +
> +		mutex_lock(acomp_ctx->mutex);
> +		sg_init_one(&input, src, entry->length);
> +		sg_init_one(&output, dst, dlen);
> +		acomp_request_set_params(acomp_ctx->req, &input, &output, entry->lengt=
h, dlen);
> +		ret =3D crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acom=
p_ctx->wait);
> +		dlen =3D acomp_ctx->req->dlen;
> +		mutex_unlock(acomp_ctx->mutex);

Say a request comes in on CPU1. After the mutex_lock() you get migrated to
CPU2. You do crypto_wait_req() on CPU2. In that time another request
gets in on CPU1. It blocks on the very same mutex. No data corruption but
it could have used another buffer instead of blocking and waiting for
the previous one to finish its work.
So it might make sense to have a pool of pages which are shared in the
system globally system instead of having strict per-CPU allocations
while being fully migrate-able while the are in use.

While at it: For dst you could use sg_set_page(). This would avoid the
kmap().=20

> +		kunmap(page);
>  		BUG_ON(ret);
>  		BUG_ON(dlen !=3D PAGE_SIZE);
> =20

Sebastian
