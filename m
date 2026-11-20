Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795202690;
	b=EEi8EqxxAFNUkdpqpAk7THNwrmwxZYS0E6oQdStbbCJdqh6/EOf7ehUhcMEs+DQwsWue
	 klVHGoy/G6YMb2UlEmq9QERkRYIFDJxxtk00P1mBG8yBJJB/Yt75FWIBzL1wU2LWI/z2u
	 OQA1i6hXhMzuZ5dipj/p4LbPhd1NoEQ2OZjDP1FHASx3pJEinxMlTRJHoTjLOy95nl+ak
	 ahlaxipZbFTvSTRmCfsgh5YvuhqwlCrWkOb88Zd5uxWywlozHm5zpGBjkv8eP2Q3d2T+2
	 gLMReXmeZCZu68sZIPi2orPea4nfWXr47gG/ediYvdBI4SzTdvm6/pTQiRc/ogHC/NA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795202690;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3zWIxONUZeQvHjISuRSptZ8FC7xw6mAb5ZCwaWbc76g=;
	b=RrQtm2lmNpmP07nuQOHJiZlL7rYOA0WAfUG018UWlHSsIE5iZ5QorMqXjuEmtx9/05Xm
	 wWo2+27frMBSbCmZa7Tp0qHSTnSv5FWXpysLE+kPG6I/TuNv2QpXiscSBHQezq2QoTgvO
	 UrXmbXHyuvAm9q3TW6VM19OrtLDXkpqHi8nQbPt1KJ97/cUDh/K4o/z4MLblTwC23cu3x
	 cqphHZk+wEFs8o1cMAzYdc1HvoufqG6cnNxkK8tk2Yu/HuRQvN6WV8p8Kx25bwIcSbB9Q
	 IJPqm29FNR9lNU68xSlZH1a+e61qh8Q/JfhwbiaGqRdB2CaU/E/BD3K2Hg0+24MNCtg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pr5T2inO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.177
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ED1606A6D8
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:24:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5ED1606A6D8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pr5T2inO
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3ab30b3212aso9645241fa.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:24:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795202687; cv=none;
        d=google.com; s=arc-20260327;
        b=E552ia8swQJNc1lSkl2LodANdfTFof8mRfHqFREQi4GLrOzwmPaHNk9JuGqZjN0NgN
         YXRmGLgoAHN/pEWANFfBtINhyXnT+w/ViE4hpImcl88JCM/xoIoQkOqK4kDboKIT++bc
         qyIILaZn/ppvJXLlIu3yGBal5plZBlv3BCK4jnbjKlwlMcfgS0kZTqjL0iTpjPffusoW
         +FN8kT/SQX0YxZtBzzAL+0ALvZAeIYuqjynb86Znfmm8zG9rY1Hi40lVqe0l/HhfrdeP
         ke23Kjm1f9nUsqORCEn2v+da2ojNvqOjw6gaQgfWRP639owbEstaFgjBwn232PsCUNBl
         A3LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3zWIxONUZeQvHjISuRSptZ8FC7xw6mAb5ZCwaWbc76g=;
        fh=K8Kask7EuOyrNplpZCVu7SvpdkoyRnh6ZfMrRlEGBKw=;
        b=RdPY9sgIQyf8ZJL4AQYUyO1Frrk+Hbc5Fd1DjlB3RX80td1VWvlCluiDXszdiirJpP
         mpQUYD+H6BCe4qSwMXGVUX29UAU1PxxYdgmndC+i5YDfTlGzo7bFZ0I64SwaMT/1sM8i
         q2GU4t1FGc8UdJpThtdUGVRFqW5MJBt1N2eX/RB92SDNGCb2eZtTCltHomap+ww/jzyC
         IHUIdmS16ZZqqefAyEi30zgz6kfrIa4BSR0vcsY0jkFXFv6H6a4umWRVGtSl/D3eyHa1
         CDxXIJyvOaWigbRm5IsZsJcVWS3GbW/3ED39s67tUx71EBTiHYVik69jQ19PNSQgr1DO
         RnnQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795202687; x=1795807487; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3zWIxONUZeQvHjISuRSptZ8FC7xw6mAb5ZCwaWbc76g=;
        b=Pr5T2inOFzYcIOYOXqOV7p2eQnrCPpnkWWB+z+oTO+RoL/y/yehhVGKSUExCGLi+zH
         UbQoP/nHY7aJohEtGF0029VaxTS6AyH1t8CMjoZAUZ08H0Hqq5CLOre9vJKRUq5SbnhV
         GEE8rCxyssfQhb9kS336y64OdB8XavJkNcubSkWgcaownW0w9ezX4pVweZfqI1++kALm
         buZ4CwQtPRExxF2Z1onNOW5gh1599B46Fqj+oQSv6gUmaOW3QeNHwaMRYqlen+xIhcrP
         10aDiZz6nvy0OqtympkFXrj/LoS8JsQpobXqWfb8yhYyn3Tsz4xzT103uEGNhyRzXQem
         fDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202687; x=1795807487;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3zWIxONUZeQvHjISuRSptZ8FC7xw6mAb5ZCwaWbc76g=;
        b=lnN27VMYn02ArgEW6cAmxI9ZPoIaORoEOo331gtGWRr2U/Hez7Vi9UeYmq4MiklKfB
         7W90ddoYbmNS59CqK0YQLDTAA6ShzhqhkDGBSSQSjRxtgqz+36H68FPv2KT1Mby5Yzre
         xMSm+d61GsHrX0EyTr4cdxPPmUw5/DwJqL8WozK2M3LC7POp+BFWnqmbi24XGl54d0Fd
         EzvL0/5ZsZF9ideKXlVsX8rcxpaN8pfLpMVJuvzRQfwe9EvtzfAvXOUVo6sZNIiR42eQ
         7dtTzTZEdbVtmO7ZCYqbjWvbXPDvf0TAgBGUIzwcdhFXZgwKCvG5jyjQRMAwNtZH2ZBT
         gigg==
X-Forwarded-Encrypted: i=1; AL+hErG8MDLsHfhyv+jQpjyKOGGqU8oAr/LtBm51TArq6iuQLUWLI9vCaF4iVriaTCOL5Vt9KSfVR13we2jmyTE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Xfleu0U/GK5tdlGCrRQt20C3nadpJlMr9Y4s7nTMaIqPFHydE
	6rnB1LRq4r9B/RNDUX2KUIEWWZFkmcEaiDHY0onkWPf3+zxxdIn8qJvUGGMmD1F0yMvTkBl0DSw
	hNVDq7lzZARPNUYrheYOFmdeGM2Rjgqk=
X-Gm-Gg: AZFdTZdfi5qFfmaxZwP3mtBUv0WVe6JvvTBT40O68AXB51vDLs7xwa1HAV+ZRTeJkmn
	P/BVouLmv58N3r4NzKMcRjvL8YxNfEcw6YzXyCab1u3gRZsvRqTJa3RFeMN9r65mUflCmgJ7B7M
	lMnhFSlPLMUGw4wncObClYekTWIHGX7VS43AW8kRLBlRCjpe3QRUiHXGXLW4airPbg7+3Jk9wAN
	ngvxcKzOhHQeg12WSUtO054PsPi/UiWEWbl0TYMIp+5T0XUvRjBburlI4/pFl4SPScMwq0yupRz
	DSKpypgmn6L0eMfcUIzQi5CGvDv0jVUoDWr1cZNI+uR7t7VMqS970GMTKm2rq+83toY2gX8ZDzV
	X6bwXSmSa+deC4fNUdxuw9//oEfgOyW+o5Sy5YtXVV863u82Lbm+loZN1QA==
X-Received: by 2002:a05:6512:3087:b0:5c1:4a42:fb17 with SMTP id
 2adb3069b0e04-5c1bc89ed7amr1304224e87.59.1795202686629; Fri, 20 Nov 2026
 11:24:46 -0800 (PST)
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
In-Reply-To: <sashiko-outbox-202714@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 11:24:32 -0800
X-Gm-Features: Aa3M54ouMN2ITwFj5M9g2-yqpSHQYsFb1T7wXbDyaNC29TFae9jRHTQF_lWNW-Q
Message-ID: <CACpmpofRbbRuRQfx0wd_xnitwz-TfWZ4_XfgR-y0HYPsN3ZFpA@mail.gmail.com>
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

On Fri, Nov 6, 2026 at 11:25=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] mm: zswap: corrupted and unterminated dst scatterlist in
>   zswap_compress()
> - [Medium] mm: zswap: unclamped nr_batch_pages on remainder batch in
>   zswap_compress()
> - [Medium] mm: zswap: unsigned sg->length check mishandles negative
>   errors in zswap_compress()
> --
>
> commit 212f5740068394b4c82b7b1e5452b1ac6625322f
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Batched zswap_compress() for storing large folios in batches.
>
> This commit replaces per-page zswap_compress() calls with a batched
> implementation that compresses up to ZSWAP_MAX_BATCH_SIZE pages using a
> per-CPU scatterlist table and updates the batch entries in
> zswap_update_entries().
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 5ef1ae67e67a9..45fd8dfaf916d 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
>
> [ ... ]
>
> > @@ -898,6 +914,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>
> [ ... ]
>
> > +     acomp_ctx->comp.sg_table =3D kmalloc(sizeof(*acomp_ctx->comp.sg_t=
able),
> > +                                        GFP_KERNEL);
> > +     if (!acomp_ctx->comp.sg_table) {
> > +             ret =3D -ENOMEM;
> > +             goto req_fail;
> > +     }
> > +
> > +     if (sg_alloc_table(acomp_ctx->comp.sg_table, ZSWAP_MAX_BATCH_SIZE=
,
> > +                        GFP_KERNEL)) {
> > +             ret =3D -ENOMEM;
> > +             goto req_fail;
> > +     }
> > +
> > +     /*
> > +      * Statically map the per-CPU destination buffers to the per-CPU
> > +      * SG lists; crucial for performance.
> > +      */
> > +     for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, ZSWAP_MAX_BATCH_SI=
ZE, i)
> > +             sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
>
> [ ... ]
>
> > +static bool zswap_compress(struct zswap_store_context *zc)
> > +{
> > +     u8 batch_start, comp_batch_iter;
> > +     struct scatterlist *sg, *dst_sg;
> > +     int err;
> >
> >       /*
> > -      * it maybe looks a little bit silly that we send an asynchronous=
 request,
> > -      * then wait for its completion synchronously. This makes the pro=
cess look
> > -      * synchronous in fact.
> > -      * Theoretically, acomp supports users send multiple acomp reques=
ts in one
> > -      * acomp instance, then get those requests done simultaneously. b=
ut in this
> > -      * case, zswap actually does store and load page by page, there i=
s no
> > -      * existing method to send the second page before the first page =
is done
> > -      * in one thread doing zswap.
> > -      * but in different threads running on different cpu, we have dif=
ferent
> > -      * acomp instance, and compression and decompression use separate
> > -      * requests, so multiple threads can do (de)compression in parall=
el.
> > +      * @nr_batch_pages is constrained by the per-CPU comp_ctx's compr=
essor
> > +      * batch size and the @zc->nr_pages in this store batch. @slen in=
dicates
> > +      * the total source length bytes for @nr_batch_pages.
> >        */
> > +     zc->nr_batch_pages =3D min(zc->comp_ctx->compr_batch_size, zc->nr=
_pages);
> > +     zc->slen =3D zc->nr_batch_pages * PAGE_SIZE;
> >
> >       /*
> > +      * Compress the @nr_pages in @folio starting at index @folio_star=
t
> > +      * in batches of @nr_batch_pages.
> >        */
> > +     for (batch_start =3D 0; batch_start < zc->nr_pages;
> > +          batch_start +=3D zc->nr_batch_pages) {
>
> [Severity: Medium]
> Can zc->nr_batch_pages exceed the remaining pages in the store batch on t=
he
> final loop iteration?
>
> zc->nr_batch_pages and zc->slen are computed once before the loop instead
> of being clamped to zc->nr_pages - batch_start on each iteration.  If a
> compressor has a compr_batch_size that does not evenly divide zc->nr_page=
s
> (for example, compr_batch_size =3D=3D 3 with zc->nr_pages =3D=3D 4), the =
final
> iteration reads past the end of the folio batch and walks past the SG_END
> terminator of zc->comp_ctx->sg_table->sgl in for_each_sg(), causing a NUL=
L
> pointer dereference when sg_next() returns NULL.

Thanks for catching this. I have resolved this and will include it
when I submit the next revision.

>
> > +             /*
> > +              * Send @nr_batch_pages to crypto_acomp for compression:
> > +              *
> > +              * These pages are in @folio's range of indices in the in=
terval
> > +              *     [@folio_start + @batch_start,
> > +              *      @folio_start + @batch_start + @nr_batch_pages).
> > +              *
> > +              * The source folio pages in the batch are directly submi=
tted to
> > +              * crypto_acomp via acomp_request_set_src_folio().
> > +              */
> > +             acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->f=
olio,
> > +                             (zc->folio_start + batch_start) * PAGE_SI=
ZE,
> > +                             zc->slen);
> > +
> > +             dst_sg =3D zc->comp_ctx->sg_table->sgl + batch_start;
> > +             dst_sg->length =3D zc->slen;
> > +
> > +             /*
> > +              * The per-CPU @zc->comp_ctx->sg_table scatterlists are s=
tatically
> > +              * mapped to the per-CPU dst @buffers at pool creation ti=
me.
> > +              * There are ZSWAP_MAX_BATCH_SIZE per-CPU SG lists and ds=
t
> > +              * buffers allocated for all compressors.
> > +              */
> > +             acomp_request_set_dst_sg(zc->comp_ctx->areq.req,
> > +                                      dst_sg, zc->slen);
>
> [Severity: High]
> Does setting dst_sg->length =3D zc->slen corrupt the per-CPU scatterlist =
table
> in zc->comp_ctx->sg_table?
>
> In zswap_cpu_comp_prepare(), each entry in sg_table->sgl is mapped to a
> separate PAGE_SIZE buffer and only sgl[ZSWAP_MAX_BATCH_SIZE - 1] has SG_E=
ND
> set.  During compression, each entry's sg->length is overwritten with the
> compressed size or a negative error code.
>
> When zc->nr_batch_pages > 1, setting dst_sg->length =3D zc->slen tells th=
e
> compressor that dst_sg[0]'s single PAGE_SIZE buffer is nr_batch_pages *
> PAGE_SIZE bytes long, while dst_sg[1 .. nr_batch_pages - 1].length are ne=
ver
> reset to PAGE_SIZE and retain stale lengths or negative error codes from =
the
> previous batch.  If crypto_acomp_compress() fails while zc->wb_enabled is
> true without updating every entry's sg->length, any entry still holding a
> stale length in (0, PAGE_SIZE) bypasses the sg->length >=3D PAGE_SIZE che=
ck
> and causes zswap_update_entries() to store stale data from the previous
> folio.
>
> In addition, because SG_END is only set on sgl[3], passing dst_sg =3D sgl=
 +
> batch_start leaves 4 - batch_start entries linked in req->dst.  Hardware
> acomp drivers that check sg_nents(req->dst) or DMA-map every entry in the
> scatterlist walk past the current batch into trailing entries whose
> sg->length may still hold PAGE_SIZE or (unsigned int)-ENOSPC (0xffffffe4)
> from an earlier failed compression.

Sashiko raised this in v2 code review. Please see my follow up comments in:

https://lore.kernel.org/all/CACpmpofOE797D7f4YGZEJ2jtHn08d9Jo8Ya3cdV8h9UL5h=
Ud9A@mail.gmail.com/

and let me know if this explains things better. Thanks.

>
> > +
> > +             err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_ct=
x->areq.req),
> > +                                   &zc->comp_ctx->areq.wait);
> > +
> > +             /*
> > +              * If a page cannot be compressed into a size smaller tha=
n
> > +              * PAGE_SIZE, save the content as is without a compressio=
n, to
> > +              * keep the LRU order of writebacks.  If writeback is dis=
abled,
> > +              * reject the page since it only adds metadata overhead.
> > +              * swap_writeout() will put the page back to the active L=
RU list
> > +              * in the case.
> > +              */
> > +             if (err && !zc->wb_enabled)
> > +                     goto compress_error;
> >
> > +             /*
> > +              * For each output SG list in @acomp_ctx->req->sg_table->=
sgl,
> > +              * the @sg->length should be set to either the page's com=
pressed
> > +              * length (success), or it's negative value compression e=
rror.
> > +              */
> > +             for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_it=
er) {
> > +
> > +                     if (sg->length <=3D 0 || sg->length >=3D PAGE_SIZ=
E) {
> > +                             if (!zc->wb_enabled) {
> > +                                     if (sg->length =3D=3D PAGE_SIZE)
> > +                                             sg->length =3D -ENOSPC;
> > +                                     else if (WARN_ON_ONCE(!sg->length=
 || sg->length > PAGE_SIZE))
> > +                                             sg->length =3D -EINVAL;
> > +                                     goto compress_error;
> > +                             }
> > +
> > +                             sg->length =3D PAGE_SIZE;
> > +                     }
> > +             }
> >       }
> >
> > +     return zswap_update_entries(zc);
> >
> > +compress_error:
> > +     for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_iter) {
> > +             if ((int)sg->length < 0) {
> > +                     if ((int)sg->length =3D=3D -ENOSPC)
> > +                             zswap_reject_compress_poor++;
> > +                     else
> > +                             zswap_reject_compress_fail++;
> > +             }
> > +     }
> > +
> > +     return false;
> >  }
>
> [Severity: Medium]
> Does checking sg->length without casting to int mishandle negative
> compression error codes when !zc->wb_enabled?
>
> scatterlist.length is an unsigned int, so a negative error code stored in
> sg->length (such as -ENOSPC) is never <=3D 0 and instead triggers
> WARN_ON_ONCE(!sg->length || sg->length > PAGE_SIZE) and overwrites
> sg->length with -EINVAL before compress_error: checks for -ENOSPC.
> Conversely, if crypto_acomp_compress() returns an error before setting
> negative values in sg->length, jumping directly to compress_error: finds =
no
> entries with (int)sg->length < 0 and increments neither rejection counter=
.

Thanks. I have resolved this.


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.79=
09-1-kanchanapsridhar2026@gmail.com?part=3D8
