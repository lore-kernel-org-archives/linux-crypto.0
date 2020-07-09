Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CABC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 07:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39D2320674
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 07:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ivX/wcA8";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Xr1H0has"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgGIHRU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 03:17:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33240 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgGIHRU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 03:17:20 -0400
Date:   Thu, 9 Jul 2020 09:17:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594279037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6uvYIItZIOK0R4wH3joTqVI6bbknAt5GZqDgVVXvw94=;
        b=ivX/wcA8yl6+WDr/PSAfeuS1zFMv0eLbo59MePRqPlK2V7NvwFhv0Ro419IEM1gKsPV3XI
        m9WBXD5kfNaivslg2UKv/BPaPI3g5H+cI8fRYI0YsAeLg+qk1FmdHkPUq8DuwnsLI45Sjo
        LDpntlgZigKa7o6aSdaGa5ZCnrYg2znt+rPszYEk9HU7XtTEqbGrGc/w1pK2f6O1WCsGGe
        sc1oJMLUsAHzB718sQgYlMabkOYD7pdaTG7KTrJkBRRWy1KYpEpJPvSiXiFew1l+NZHkVn
        kDT8e/kbTu6jIvukJ35/Fcd6SGQILl3Okd4MG8OK1ZiRRkmEJJAOgxoQrxDgIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594279037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6uvYIItZIOK0R4wH3joTqVI6bbknAt5GZqDgVVXvw94=;
        b=Xr1H0hash7LO3/io7vz4F1I6IM9WHpheIVNzUMTTxFv2OgsEZceeeIr4kkfcxWgBrGP2xW
        6g3qguXMUqJekdCA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
Cc:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v4] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Message-ID: <20200709071714.32m7hatmkr4pk2f4@linutronix.de>
References: <20200707125210.33256-1-song.bao.hua@hisilicon.com>
 <20200708145934.4w3qk53mgavyyln7@linutronix.de>
 <B926444035E5E2439431908E3842AFD2560DE6@DGGEMI525-MBS.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <B926444035E5E2439431908E3842AFD2560DE6@DGGEMI525-MBS.china.huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-07-08 21:45:47 [+0000], Song Bao Hua (Barry Song) wrote:
> > On 2020-07-08 00:52:10 [+1200], Barry Song wrote:
> > > @@ -127,9 +129,17 @@
> > > +struct crypto_acomp_ctx {
> > > +	struct crypto_acomp *acomp;
> > > +	struct acomp_req *req;
> > > +	struct crypto_wait wait;
> > > +	u8 *dstmem;
> > > +	struct mutex mutex;
> > > +};
> > =E2=80=A6
> > > @@ -1074,12 +1138,32 @@ static int zswap_frontswap_store(unsigned
> > type, pgoff_t offset,
> > >  	}
> > >
> > >  	/* compress */
> > > -	dst =3D get_cpu_var(zswap_dstmem);
> > > -	tfm =3D *get_cpu_ptr(entry->pool->tfm);
> > > -	src =3D kmap_atomic(page);
> > > -	ret =3D crypto_comp_compress(tfm, src, PAGE_SIZE, dst, &dlen);
> > > -	kunmap_atomic(src);
> > > -	put_cpu_ptr(entry->pool->tfm);
> > > +	acomp_ctx =3D *this_cpu_ptr(entry->pool->acomp_ctx);
> > > +
> > > +	mutex_lock(&acomp_ctx->mutex);
> > > +
> > > +	src =3D kmap(page);
> > > +	dst =3D acomp_ctx->dstmem;
> >=20
> > that mutex is per-CPU, per-context. The dstmem pointer is per-CPU. So if
> > I read this right, you can get preempted after crypto_wait_req() and
> > another context in this CPU writes its data to the same dstmem and then=
=E2=80=A6
> >=20
>=20
> This isn't true. Another thread in this cpu will be blocked by the mutex.
> It is impossible for two threads to write the same dstmem.
> If thread1 ran on cpu1, it held cpu1's mutex; if another thread wants to =
run on cpu1, it is blocked.
> If thread1 ran on cpu1 first, it held cpu1's mutex, then it migrated to c=
pu2 (with very rare chance)
> 	a. if another thread wants to run on cpu1, it is blocked;

How it is blocked? That "struct crypto_acomp_ctx" is
"this_cpu_ptr(entry->pool->acomp_ctx)" - which is per-CPU of a pool
which you can have multiple of. But `dstmem' you have only one per-CPU
no matter have many pools you have.
So pool1 on CPU1 uses the same `dstmem' as pool2 on CPU1. But pool1 and
pool2 on CPU1 use a different mutex for protection of this `dstmem'.

> Thanks
> Barry

Sebastian
