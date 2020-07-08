Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6843C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 14:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9496420720
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 14:59:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xQvWEvqu";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="S7NW9mWM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgGHO7j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 10:59:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51060 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729948AbgGHO7i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 10:59:38 -0400
Date:   Wed, 8 Jul 2020 16:59:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594220376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+7JziWx8xGafb1lK96IKc6xbdLpVMYN0yIUWKgqSpO8=;
        b=xQvWEvquy19QIrrgc5ILsPisEeMdQ6EJHAhuKxdkY6e8LDs561EpZsKyKvYoyGESPser42
        eO/oROdh/m3nfBsDqLliSEM8ZVzLy7hyyIBdB/sXzxMpsX0Uk3nwf9W2bjFG9/qGC7hEY1
        +M0VOTXL+zXups7BrW58O31GOQLmM+L0zDsFT2Qf7H2uzQsLPCa2CuIxvC860Ohd344eDt
        dN2qTPB0rhQwOtExcDU0P53eQ9dfYH9Ou31kSwqjFFZjcDLyJV2KzliwQ4QAf0TpOOg4rN
        Ef9C9r/OKy/XurDKqpi3Ac7cCgBj89uIJ4OXsM+ggMv5D0NyKqXM54N+QX4BYw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594220376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+7JziWx8xGafb1lK96IKc6xbdLpVMYN0yIUWKgqSpO8=;
        b=S7NW9mWMMthgTMCxBRmNHemfR0mHU1rThQ/ENWILjzTIe/eWgPqfmCGuNboGaDicwL1F8i
        jmmYr4ah0HkZVTBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Barry Song <song.bao.hua@hisilicon.com>
Cc:     akpm@linux-foundation.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v4] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Message-ID: <20200708145934.4w3qk53mgavyyln7@linutronix.de>
References: <20200707125210.33256-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200707125210.33256-1-song.bao.hua@hisilicon.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-07-08 00:52:10 [+1200], Barry Song wrote:
=E2=80=A6
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
> +	struct mutex mutex;
> +};
=E2=80=A6
> @@ -561,8 +614,9 @@ static struct zswap_pool *zswap_pool_create(char *typ=
e, char *compressor)
>  	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
> =20
>  	strlcpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> -	pool->tfm =3D alloc_percpu(struct crypto_comp *);
> -	if (!pool->tfm) {
> +
> +	pool->acomp_ctx =3D alloc_percpu(struct crypto_acomp_ctx *);

Can't you allocate the whole structure instead just a pointer to it? The
structure looks just like bunch of pointers anyway. Less time for
pointer chasing means more time for fun.

> @@ -1074,12 +1138,32 @@ static int zswap_frontswap_store(unsigned type, p=
goff_t offset,
>  	}
> =20
>  	/* compress */
> -	dst =3D get_cpu_var(zswap_dstmem);
> -	tfm =3D *get_cpu_ptr(entry->pool->tfm);
> -	src =3D kmap_atomic(page);
> -	ret =3D crypto_comp_compress(tfm, src, PAGE_SIZE, dst, &dlen);
> -	kunmap_atomic(src);
> -	put_cpu_ptr(entry->pool->tfm);
> +	acomp_ctx =3D *this_cpu_ptr(entry->pool->acomp_ctx);
> +
> +	mutex_lock(&acomp_ctx->mutex);
> +
> +	src =3D kmap(page);
> +	dst =3D acomp_ctx->dstmem;

that mutex is per-CPU, per-context. The dstmem pointer is per-CPU. So if
I read this right, you can get preempted after crypto_wait_req() and
another context in this CPU writes its data to the same dstmem and then=E2=
=80=A6

> +	sg_init_one(&input, src, PAGE_SIZE);
> +	/* zswap_dstmem is of size (PAGE_SIZE * 2). Reflect same in sg_list */
> +	sg_init_one(&output, dst, PAGE_SIZE * 2);
> +	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dl=
en);
> +	/*
> +	 * it maybe looks a little bit silly that we send an asynchronous reque=
st,
> +	 * then wait for its completion synchronously. This makes the process l=
ook
> +	 * synchronous in fact.
> +	 * Theoretically, acomp supports users send multiple acomp requests in =
one
> +	 * acomp instance, then get those requests done simultaneously. but in =
this
> +	 * case, frontswap actually does store and load page by page, there is =
no
> +	 * existing method to send the second page before the first page is done
> +	 * in one thread doing frontswap.
> +	 * but in different threads running on different cpu, we have different
> +	 * acomp instance, so multiple threads can do (de)compression in parall=
el.
> +	 */
> +	ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_c=
tx->wait);
> +	dlen =3D acomp_ctx->req->dlen;
> +	kunmap(page);
> +
>  	if (ret) {
>  		ret =3D -EINVAL;
>  		goto put_dstmem;

This looks using the same synchronous mechanism around an asynchronous
interface. It works as a PoC.

As far as I remember the crypto async interface, the incoming skbs were
fed to the async interface and returned to the caller so the NIC could
continue allocate new RX skbs and move on. Only if the queue of requests
was getting to long the code started to throttle. Eventually the async
crypto code completed the decryption operation in a different context
and fed the decrypted packet(s) into the stack.

=46rom a quick view, you would have to return -EINPROGRESS here and have
at the caller side something like that:

iff --git a/mm/page_io.c b/mm/page_io.c
index e8726f3e3820b..9d1baa46ec3ed 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -252,12 +252,15 @@ int swap_writepage(struct page *page, struct writebac=
k_control *wbc)
                unlock_page(page);
                goto out;
        }
-       if (frontswap_store(page) =3D=3D 0) {
+       ret =3D frontswap_store(page);
+       if (ret =3D=3D 0) {
                set_page_writeback(page);
                unlock_page(page);
                end_page_writeback(page);
                goto out;
        }
+       if (ret =3D -EINPROGRESS)
+               goto out;
        ret =3D __swap_writepage(page, wbc, end_swap_bio_write);
 out:
        return ret;

so that eventually callers like write_cache_pages() could feed all pages
into *writepage and then wait for that bulk to finish.

Having it this way would also reshape the memory allocation you have.
You have now per-context a per-CPU crypto request and everything. With
a 64 or 128 core I'm not sure you will use all that resources.
With a truly async interface you would be force to have a resource pool
or so which you would use and then only allow a certain amount of
parallel requests.

Sebastian
