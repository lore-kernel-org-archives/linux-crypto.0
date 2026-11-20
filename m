Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795202894;
	b=DfvXuYnmMj8YAfjfnnq1aTayHVAhQGhibC+agDMEcMqTvKPj5/GUSht0UUvrM2aWbsef
	 scssJLvQzH+WJq91bT0nuZA96cTz/IOnuLTCtWN0sHuixJWVYMxi4cz5yDNYu1misF3PE
	 BjSHnW1iLnXjJSzBtxtJJ09dAsmlp250YKR1v4i5dbTGogayS8I9Xh7NGquiQ0SSGnlAq
	 K4SxFjVw2f09ewJonfTiWbeCnx+n2G7BNeMOFm2orF9sCBzng+lkk21/D/fTQuBZ9LgEW
	 wXcFG6Sn3ZSVTO1t3MRLbbf3Mgo+w4cpq04pu6KLow8I9+C4gsQ2UJ1flELpVIvA8Cw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795202894;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=gTSQmZl/zKK0zXMmK+A31LEN+NDNPEQL27tBFK3Clmw=;
	b=C/CyLksr+E8l34qUmfgfolbykT0Y8EuAc+wZZ0zcxPPNUgPgaxhyl81K7qq9XcZnaG8k
	 SlPs+OU4CSTx6RxD55CulFMa6bHRLNZhJUsXWoGKNmRHNktMk7nkcP81bsBRtw3hFQ8y0
	 powyXfrQNi5Eg8y1fxjTzN3xq0HYYZva4qUJKZs3iueuid088/bAYJdmWxkCmVEsBF2zb
	 4vvd/Sdn0TMde3XooWm62aJ4I+5BEElKt7ZLHJFkaJzCdjjR3azCgIjJsZBqKcTsmRdXP
	 OH/aRHD6kDoV3KcfDsP+U1vGczCju95DeSM0s6ymjU0Z61lZ5cgtJC7M4dr3MTPzaqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XAboyiHZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B557606A6D5
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:28:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B557606A6D5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XAboyiHZ
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5be4fea434bso2364195e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:28:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795202892; cv=none;
        d=google.com; s=arc-20260327;
        b=KDurEtASIPGlW8CuHjCJeSjc/QtBIr2PVu5SnKypaGCv+2nZ0C/FqQ1FIjF1Y/FEVG
         U+Y8Tg6V6XtNWu7Mz6E1LyJ3SMqTkzrKMcDM0p3vrMeslLhwLblhir0qX+sNDraBQ6ua
         1DEj0DZ3bol3o4SsyWelocLXHOpuUJ+QLLX1bSxtAuRolmeolj3drw0BnQpO9QVH+jSO
         ZEHrTG2ES0AZ1JfFD9LC4uF/k4ez1Gl0O7bq5DvvxcoPyB/FB99Qzf0TjX/G56tMKh4Z
         G3QLGFGBung0671GPr0ToHUNFK2lYYXxCdgcLV+rdwGRL7LVqa8mUaoN9YppaUfMWbdd
         susA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gTSQmZl/zKK0zXMmK+A31LEN+NDNPEQL27tBFK3Clmw=;
        fh=WIUONizbC3iJb0Wgr5Cj3P9KO9+7DQ8qEeB8kDluq5Y=;
        b=aOIqaAuySUfAFFImNwEuRAz/28TQ1RhT3Uvv7g8ueBI4WJ12F27tG7CF1+eQ6EkYEx
         RoF2hMfZ8javLoglIGfELmABJR1pIPDyzuNl05iOZKPXEyTfmGmYSmjIig6OfnKnISRU
         95Vc7iJlhrgBPA64MaZpXkb9s6SUrLbWmIjsaRqip0ifgr3iCpX8B0copB2K0EdQfd2U
         d4lxb0yL4txpZWYXoySBuJOTN/CRO58+q6SA/lU8EvO/MKlGAk19+rfx2LTVWufDWgH/
         vQZLoedX6vF/Evqos87+eu26jpN+iosSDUPNuYRNhVmaR5hirlsQ0iBHyLWQ20t86k/S
         t+3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795202892; x=1795807692; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gTSQmZl/zKK0zXMmK+A31LEN+NDNPEQL27tBFK3Clmw=;
        b=XAboyiHZfjvEsrDSTRPcNSLRfv0fNubP6mdVnn8Gs7PuFhhOIapnkmusBUKkqceZjc
         y2CnNtyYIdKsuSyO9oUGH9bFrL5UxF3TWq8FrpZpZTED2bRo+VYnHN8IWd9B/0FZ42uX
         M4ULfypP7jOtL60+0svYQV1lF/vFGLoDNNU/I5GKiJhHkqhwGE/mxv2Ct4kBzYqV3wdy
         hQlTBxBQinwfMCVZJGFG9J4Oa2gW5/ITexQjtMfgd/Hj/u31+jUfQ2ZpKq31xF/h9w+S
         LCNYpLxk9BWSzlYBEGxNZtyajYhDKK+r/91tMbZQwb/VL13oN7h43NBPX65k0kePsuua
         2eOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202892; x=1795807692;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gTSQmZl/zKK0zXMmK+A31LEN+NDNPEQL27tBFK3Clmw=;
        b=GVIyIzmEuXBd5Y/rZMfZTIbo8PS/sUozGX8h7fIUUwAN3EFMEz83lqr1YKDGwMOnDN
         HFIwkfrj1rJ54uJn7vRCF3kzhvg7mDz2mmjDTzi9dnJmxrQWuYNJHD0Mm2MfBp6Zj6yd
         p8SdxbB2+YdAD/oqAkeMAs5s2VoeIONgS0KFE8I6+TjeFmbIGJ51bSCbOH42BmuCB7z5
         p6kRPlxk5jKRaHsbSFEm9wfNIGnLxAHiGsSIrTVM87vOlt9XhQ6fakzUSp2zrwRN8sZn
         LkH6si9OVS8xaR+5lM083N9Gl1Wlip7JLEBJNTHJ7VJkB4Nz+OGPGSyAnljoGXHNNHwz
         DOzA==
X-Forwarded-Encrypted: i=1; AL+hErGmcaKK/hsbqsbeq01ty9DcrG/ShFIs+cGCKRjtpzx71HLthws+EM3Sy3p1GIcYox8eSkYVBicXsYlM6Lk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+Ru5Akio4ZnhOVnG5UnI8xnNmIJGIR/XlV3M3vQGTimRKZludn
	4rtkSJwBO9tVx3CCC+1Lq0BjmYPDa7FmBTzVdfBT+QVruwe3Mr57BbVbLguIAB2ST7cB4zzz6xa
	zCdZhxbRGjvFyAhUaWlIZ6O9NtPf9Lhbst7Ur
X-Gm-Gg: AZFdTZex4gKHYLCe7JS91QOltxA0BZ/9yUxzym8uB2dnLSycjZMS55aNLg+/JbyhQqU
	/GWbEzqAf6kQCV6crfTIIZizugQuUzwg5aM3W7sOzt8DIaWtHPce308nEKorTv+ESdShKPRh/uq
	Dqxcr8M9lu8THYRxr9Zwdxzq1ieboIluEHAdnUPjhFclEYKxzcEqUVhi87omdtebAcIloArXjjc
	zzLMilUQq4SR+9uODH+A5AEdNEUnCvlTAmhWReFNPNEIbqYciOzqtWjbey/DrPEqv4iDydAay+W
	HJY4CwRwNSvYz0BGYACxfP7t8VHhSyFdOFY3UZTHufdwr7En9bRMY+PGedCmOLQz3C8Z7cXVnwo
	k5v1FfKqD5Nzsbk9YUtSlUu2q7jKQRjoRMULD
X-Received: by 2002:a05:6512:32c8:b0:5c1:46f8:913c with SMTP id
 2adb3069b0e04-5c1b7c00f96mr1590361e87.20.1795202892209; Fri, 20 Nov 2026
 11:28:12 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-9-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202714@kernel.org>
 <CACpmpofRbbRuRQfx0wd_xnitwz-TfWZ4_XfgR-y0HYPsN3ZFpA@mail.gmail.com>
In-Reply-To: <CACpmpofRbbRuRQfx0wd_xnitwz-TfWZ4_XfgR-y0HYPsN3ZFpA@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 11:27:59 -0800
X-Gm-Features: Aa3M54qHyMHAs4REx3hc_QYhZyScUZM2KH4BsGOU3VT9vIU15C1WE7ikT83enGg
Message-ID: <CACpmpof-tnHWn=mqGEm=xAGi039Ewh8Zv5=n+5QOrvLjefv3TA@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] mm: zswap: Batched zswap_compress() for storing
 large folios in batches.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 11:24=E2=80=AFAM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Fri, Nov 6, 2026 at 11:25=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 3 potential
> > issues to consider:
> > - [High] mm: zswap: corrupted and unterminated dst scatterlist in
> >   zswap_compress()
> > - [Medium] mm: zswap: unclamped nr_batch_pages on remainder batch in
> >   zswap_compress()
> > - [Medium] mm: zswap: unsigned sg->length check mishandles negative
> >   errors in zswap_compress()
> > --
> >
> > commit 212f5740068394b4c82b7b1e5452b1ac6625322f
> > Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> >
> > mm: zswap: Batched zswap_compress() for storing large folios in batches=
.
> >
> > This commit replaces per-page zswap_compress() calls with a batched
> > implementation that compresses up to ZSWAP_MAX_BATCH_SIZE pages using a
> > per-CPU scatterlist table and updates the batch entries in
> > zswap_update_entries().
> >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 5ef1ae67e67a9..45fd8dfaf916d 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> >
> > [ ... ]
> >
> > > @@ -898,6 +914,7 @@ static int zswap_cpu_comp_prepare(unsigned int cp=
u, struct hlist_node *node)
> >
> > [ ... ]
> >
> > > +     acomp_ctx->comp.sg_table =3D kmalloc(sizeof(*acomp_ctx->comp.sg=
_table),
> > > +                                        GFP_KERNEL);
> > > +     if (!acomp_ctx->comp.sg_table) {
> > > +             ret =3D -ENOMEM;
> > > +             goto req_fail;
> > > +     }
> > > +
> > > +     if (sg_alloc_table(acomp_ctx->comp.sg_table, ZSWAP_MAX_BATCH_SI=
ZE,
> > > +                        GFP_KERNEL)) {
> > > +             ret =3D -ENOMEM;
> > > +             goto req_fail;
> > > +     }
> > > +
> > > +     /*
> > > +      * Statically map the per-CPU destination buffers to the per-CP=
U
> > > +      * SG lists; crucial for performance.
> > > +      */
> > > +     for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, ZSWAP_MAX_BATCH_=
SIZE, i)
> > > +             sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
> >
> > [ ... ]
> >
> > > +static bool zswap_compress(struct zswap_store_context *zc)
> > > +{
> > > +     u8 batch_start, comp_batch_iter;
> > > +     struct scatterlist *sg, *dst_sg;
> > > +     int err;
> > >
> > >       /*
> > > -      * it maybe looks a little bit silly that we send an asynchrono=
us request,
> > > -      * then wait for its completion synchronously. This makes the p=
rocess look
> > > -      * synchronous in fact.
> > > -      * Theoretically, acomp supports users send multiple acomp requ=
ests in one
> > > -      * acomp instance, then get those requests done simultaneously.=
 but in this
> > > -      * case, zswap actually does store and load page by page, there=
 is no
> > > -      * existing method to send the second page before the first pag=
e is done
> > > -      * in one thread doing zswap.
> > > -      * but in different threads running on different cpu, we have d=
ifferent
> > > -      * acomp instance, and compression and decompression use separa=
te
> > > -      * requests, so multiple threads can do (de)compression in para=
llel.
> > > +      * @nr_batch_pages is constrained by the per-CPU comp_ctx's com=
pressor
> > > +      * batch size and the @zc->nr_pages in this store batch. @slen =
indicates
> > > +      * the total source length bytes for @nr_batch_pages.
> > >        */
> > > +     zc->nr_batch_pages =3D min(zc->comp_ctx->compr_batch_size, zc->=
nr_pages);
> > > +     zc->slen =3D zc->nr_batch_pages * PAGE_SIZE;
> > >
> > >       /*
> > > +      * Compress the @nr_pages in @folio starting at index @folio_st=
art
> > > +      * in batches of @nr_batch_pages.
> > >        */
> > > +     for (batch_start =3D 0; batch_start < zc->nr_pages;
> > > +          batch_start +=3D zc->nr_batch_pages) {
> >
> > [Severity: Medium]
> > Can zc->nr_batch_pages exceed the remaining pages in the store batch on=
 the
> > final loop iteration?
> >
> > zc->nr_batch_pages and zc->slen are computed once before the loop inste=
ad
> > of being clamped to zc->nr_pages - batch_start on each iteration.  If a
> > compressor has a compr_batch_size that does not evenly divide zc->nr_pa=
ges
> > (for example, compr_batch_size =3D=3D 3 with zc->nr_pages =3D=3D 4), th=
e final
> > iteration reads past the end of the folio batch and walks past the SG_E=
ND
> > terminator of zc->comp_ctx->sg_table->sgl in for_each_sg(), causing a N=
ULL
> > pointer dereference when sg_next() returns NULL.
>
> Thanks for catching this. I have resolved this and will include it
> when I submit the next revision.

This has been resolved in v4 submitted yesterday.

>
> >
> > > +             /*
> > > +              * Send @nr_batch_pages to crypto_acomp for compression=
:
> > > +              *
> > > +              * These pages are in @folio's range of indices in the =
interval
> > > +              *     [@folio_start + @batch_start,
> > > +              *      @folio_start + @batch_start + @nr_batch_pages).
> > > +              *
> > > +              * The source folio pages in the batch are directly sub=
mitted to
> > > +              * crypto_acomp via acomp_request_set_src_folio().
> > > +              */
> > > +             acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc-=
>folio,
> > > +                             (zc->folio_start + batch_start) * PAGE_=
SIZE,
> > > +                             zc->slen);
> > > +
> > > +             dst_sg =3D zc->comp_ctx->sg_table->sgl + batch_start;
> > > +             dst_sg->length =3D zc->slen;
> > > +
> > > +             /*
> > > +              * The per-CPU @zc->comp_ctx->sg_table scatterlists are=
 statically
> > > +              * mapped to the per-CPU dst @buffers at pool creation =
time.
> > > +              * There are ZSWAP_MAX_BATCH_SIZE per-CPU SG lists and =
dst
> > > +              * buffers allocated for all compressors.
> > > +              */
> > > +             acomp_request_set_dst_sg(zc->comp_ctx->areq.req,
> > > +                                      dst_sg, zc->slen);
> >
> > [Severity: High]
> > Does setting dst_sg->length =3D zc->slen corrupt the per-CPU scatterlis=
t table
> > in zc->comp_ctx->sg_table?
> >
> > In zswap_cpu_comp_prepare(), each entry in sg_table->sgl is mapped to a
> > separate PAGE_SIZE buffer and only sgl[ZSWAP_MAX_BATCH_SIZE - 1] has SG=
_END
> > set.  During compression, each entry's sg->length is overwritten with t=
he
> > compressed size or a negative error code.
> >
> > When zc->nr_batch_pages > 1, setting dst_sg->length =3D zc->slen tells =
the
> > compressor that dst_sg[0]'s single PAGE_SIZE buffer is nr_batch_pages *
> > PAGE_SIZE bytes long, while dst_sg[1 .. nr_batch_pages - 1].length are =
never
> > reset to PAGE_SIZE and retain stale lengths or negative error codes fro=
m the
> > previous batch.  If crypto_acomp_compress() fails while zc->wb_enabled =
is
> > true without updating every entry's sg->length, any entry still holding=
 a
> > stale length in (0, PAGE_SIZE) bypasses the sg->length >=3D PAGE_SIZE c=
heck
> > and causes zswap_update_entries() to store stale data from the previous
> > folio.
> >
> > In addition, because SG_END is only set on sgl[3], passing dst_sg =3D s=
gl +
> > batch_start leaves 4 - batch_start entries linked in req->dst.  Hardwar=
e
> > acomp drivers that check sg_nents(req->dst) or DMA-map every entry in t=
he
> > scatterlist walk past the current batch into trailing entries whose
> > sg->length may still hold PAGE_SIZE or (unsigned int)-ENOSPC (0xffffffe=
4)
> > from an earlier failed compression.
>
> Sashiko raised this in v2 code review. Please see my follow up comments i=
n:
>
> https://lore.kernel.org/all/CACpmpofOE797D7f4YGZEJ2jtHn08d9Jo8Ya3cdV8h9UL=
5hUd9A@mail.gmail.com/
>
> and let me know if this explains things better. Thanks.
>
> >
> > > +
> > > +             err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_=
ctx->areq.req),
> > > +                                   &zc->comp_ctx->areq.wait);
> > > +
> > > +             /*
> > > +              * If a page cannot be compressed into a size smaller t=
han
> > > +              * PAGE_SIZE, save the content as is without a compress=
ion, to
> > > +              * keep the LRU order of writebacks.  If writeback is d=
isabled,
> > > +              * reject the page since it only adds metadata overhead=
.
> > > +              * swap_writeout() will put the page back to the active=
 LRU list
> > > +              * in the case.
> > > +              */
> > > +             if (err && !zc->wb_enabled)
> > > +                     goto compress_error;
> > >
> > > +             /*
> > > +              * For each output SG list in @acomp_ctx->req->sg_table=
->sgl,
> > > +              * the @sg->length should be set to either the page's c=
ompressed
> > > +              * length (success), or it's negative value compression=
 error.
> > > +              */
> > > +             for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_=
iter) {
> > > +
> > > +                     if (sg->length <=3D 0 || sg->length >=3D PAGE_S=
IZE) {
> > > +                             if (!zc->wb_enabled) {
> > > +                                     if (sg->length =3D=3D PAGE_SIZE=
)
> > > +                                             sg->length =3D -ENOSPC;
> > > +                                     else if (WARN_ON_ONCE(!sg->leng=
th || sg->length > PAGE_SIZE))
> > > +                                             sg->length =3D -EINVAL;
> > > +                                     goto compress_error;
> > > +                             }
> > > +
> > > +                             sg->length =3D PAGE_SIZE;
> > > +                     }
> > > +             }
> > >       }
> > >
> > > +     return zswap_update_entries(zc);
> > >
> > > +compress_error:
> > > +     for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_iter) {
> > > +             if ((int)sg->length < 0) {
> > > +                     if ((int)sg->length =3D=3D -ENOSPC)
> > > +                             zswap_reject_compress_poor++;
> > > +                     else
> > > +                             zswap_reject_compress_fail++;
> > > +             }
> > > +     }
> > > +
> > > +     return false;
> > >  }
> >
> > [Severity: Medium]
> > Does checking sg->length without casting to int mishandle negative
> > compression error codes when !zc->wb_enabled?
> >
> > scatterlist.length is an unsigned int, so a negative error code stored =
in
> > sg->length (such as -ENOSPC) is never <=3D 0 and instead triggers
> > WARN_ON_ONCE(!sg->length || sg->length > PAGE_SIZE) and overwrites
> > sg->length with -EINVAL before compress_error: checks for -ENOSPC.
> > Conversely, if crypto_acomp_compress() returns an error before setting
> > negative values in sg->length, jumping directly to compress_error: find=
s no
> > entries with (int)sg->length < 0 and increments neither rejection count=
er.
>
> Thanks. I have resolved this.
>
>
> >
> > --
> > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.=
7909-1-kanchanapsridhar2026@gmail.com?part=3D8
