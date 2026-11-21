Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795296157;
	b=LXqtLKPn+DO1t5WTKwqCN/SAzRucbGZNRalHuykDWizFSFtrkiEwLsG5rP8K6szLNw8n
	 5Q6kfRFkNTIO5SymSXrkOng4idJTMR+e7w0ap2nrNxECvk2Ps34DersBFk+05W04qzsvG
	 kNFqgQ5TL8+gmzGECSqFi+GEqSbnJbqvZwbFyp7DOL5Rgn8q43d0eGXbrc7re2rZc8/3i
	 q95Y+Q0kSBrnk0HV1F5Mdw5X9c73U4QrH2tda1sAQGEvEH4ysozSjzz7AzIA/GsEJ/9k/
	 /wKczTNYn12iQZsvkAOO67zzRS66MB3s1DdYk9H9jXjcsAkueGBHrZ30kuZDcU/dE5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795296157;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=QhxZH8BTZF9uyHOWYNwDlYQX01HSpJGN5QAEadM7D00=;
	b=ksF9K2moIdkwd1UBLHFzrCrojkjS6Buua4tDuhH5C226uF5J/yiNyKAmmO+6gS1Q/5Nb
	 29KN2faNUZdOguWwdLhth6m71pwOjfCXDTSTpTnUbOy1MqAE+6zWADs0ObrS3pTCF1t/m
	 i4LKGNliln9is9YHRmxRdjoisEIYfghbtx1/bgydD35DrP/iHSqCw2gp8adxhzv31fwGu
	 IMbYSCm4KizHgdqgZ6vsGkPz7TLg72elf6bbsxLppKCC6fPJ7phFoARg1cOArMm7NW8mP
	 TIvCyusAlVEAAiyP2VFt+LZhGXgczvzN/r4cC4Koyj1TgY84KOKt1dUHLoxZ3IrwEIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DCe6V0h0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.169
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20372606A32A
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 21:22:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20372606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DCe6V0h0
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3ae0d0b9db2so18898241fa.1
        for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 13:22:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795296155; cv=none;
        d=google.com; s=arc-20260327;
        b=NTF4YvrT8sNSxWKskOpYwIJv/NJLwFX6O2eY8E9X5MbLi+Zei8PavFw3CPgh/2jvmA
         wEtsJYII355odHn/vaTUWi1cnAMjWtjuWQ3dwF9PBu5mzvJR9/Myxz4BRDLLxOoC8+hL
         Y/ivnjPveH79ze7BbvYKbLKLTH11jH7O8WKTALi1q3mdNLXkCPLUstOszb1FOTexP/85
         +cDq47vnqC02Kxvak2iz+3PLdTUIb65PjkGZNW0siOnwCekAmPFo0aG8M68PuNrOPRH0
         R3pIugyJFhmlmtGL2Vz764TfUegWyYwbRodrM29/S7oNMcPTGI8rwFTtUCm+yBWP0Gg6
         HjLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QhxZH8BTZF9uyHOWYNwDlYQX01HSpJGN5QAEadM7D00=;
        fh=t9IelL8lh0ueFcKmeuDCRKXteNRN/FR6wQphVj5/UgA=;
        b=c8TU9222ie4emaAXxFnz+eBR3Uzb7y4rsgaahp7JY8BfVQup2n6UjYrDjfOHOPIU4W
         fI8JHpywO1yW3VAEzzYjWWfPIysbnimhSEhxbwsXo9sMlhMQw4csACMR0YNB6iqopU2G
         0+Nl8wjUZ/I+FzqYfcW7t+0G9JFLWCyQR/BtAzRL+Tx2XH5DTwxu78bngbQWxZJ4NX3R
         GEH82fZ6jZZ0a2su8soqX0F/Fef9oZ1OFS7R8hXQ32cekxWnpUTZ9l+ozzySqQcxmpTP
         jOT8yytc6/DbHlJZ3vBr649/nBiWyO7v/K1D/W0tg+5+b9oyGxlrpx6VDijlARtP7EBw
         v1KQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795296155; x=1795900955; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QhxZH8BTZF9uyHOWYNwDlYQX01HSpJGN5QAEadM7D00=;
        b=DCe6V0h0tUqfJPm1CdO9WrOk8yAuBk8Nc+17DErh3riOa+YU6oTYoCyBi1ksuaFZ6o
         fjnWpZI2o4tRjOIpWfAFoer5A5j92CIbPWC2TVK/ETffjgFvxScoyqn7O1xcWkI6L/+z
         NQ6Gc0YClOHXCPjDju2pZp97gmctHpCv/11ywDeCyw4X741qsp+kvLbLFY5f3EtqCPp1
         /5sdlHp+NgNNHE/K8bokEZvVkJXWfURJpzli7xwxqE6D4xy3r2PheSirq/+pAlemKe8v
         gRK2mdUDNz5M/3lykrdeDeus9h99dz6KcrOpmyre6/WhvPzqItEGwRL75oASkgjv1W1e
         Uo9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795296155; x=1795900955;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QhxZH8BTZF9uyHOWYNwDlYQX01HSpJGN5QAEadM7D00=;
        b=QgS61RZb1wY6rwW9qf8LZ1okwbmn/kHs/weX0lyllg/b/ghlwoUbPW9zuQPE+G4WrF
         RVZi1bH58mdCF/u+8d4qSC9hC8LrIzmf2CuGVd0M1hsXUYgdZmbjuC3qn3O0jf71eSnq
         5H8EYo06AKiY2J17OILBTQEbfvX32ioRGg0HMpmaJGRT1I9ii3wgURfjbodEn3Ehapt8
         PXEBkdAJtA1+Rupz0unolbLD0i8mNuYUhFZ0fJdygCIne4MMybcHzAjCpTPKgexxFYu5
         Gy7mxLYX0bDLUhx3lVu7JdSqI8x/v1jgRV4O8uY1/XqI/VdoOzKZPbrF3u+yHcYWpZju
         5DCA==
X-Forwarded-Encrypted: i=1; AL+hErF/cpX9SoKbpBmXWdUAXlgjWaigwCmsIRaV3Q4LbsfqrPlGPaTvGUjVv1eWWtX6mKPZf9CFSkDeNd9gbQQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8/kT/LTQTLRuP4uDaWiC+zpOFDdSmJD4uDGpbhEbr6TG5sU6Wh
	lY6P+65c93Rm/NgfRlaKS8TMmWDmCbLthg2NRvZlWEVH3ZPmvpsob5MuCh2fwlDKoMpvcrHcbGI
	V4dW5HZPrvfmCGPgnmi5GfPG/Dk3VmEM=
X-Gm-Gg: AZFdTZdu0p6eYzjm6aS+/DGTBzi3e054w3D0WZj0BOllWq24Dh/saKXuuHTzNNmv4kK
	nurLbPYkMboq4uY7fEbpN7eF207Av7e4JcETMtVAlvysTZzkVV48ytX0/+4glAtZ/22uiv900DQ
	V2Gko4SMOTOYdYAtGDh4ql0JiW0eNEaNeGeCIxrrXkZAnk2zN3BbYFedN48nEX9ZD+/eLwtgYs/
	StOUBNYsHPwyulXmJcOxA+guRYA6ohxoBZgjxgeklOCtSEy7M9hvEGdLy5vkeLOs3tUsViSmM6O
	DkbsEDMr9PE4BITIGis5TZjVAqoMB+PN4ftvXyI97jtG9MVenRVQGdM58V/bqBZ2JnC4d5rfpfz
	tMZcPBtP+K6LEhfKHuk5kUvFdaaaXTIZ4a0WAfb25IMdOZZyEIczo0L+u8g==
X-Received: by 2002:a05:651c:a149:b0:3ac:e4fe:49c with SMTP id
 38308e7fff4ca-3ae7fa65ademr21112491fa.21.1795296154982; Sat, 21 Nov 2026
 13:22:34 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-9-kanchanapsridhar2026@gmail.com> <sashiko-outbox-226638@kernel.org>
In-Reply-To: <sashiko-outbox-226638@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sat, 21 Nov 2026 13:22:21 -0800
X-Gm-Features: Aa3M54pt8cwuxT6_by5lL_6hdW5GlQGTKVDXQNTvmifS0EhM5bwkQ1ptuPBtKJw
Message-ID: <CACpmpocYxp38npkHWhbhOyoRAq2KKyvpo6HQRih1VPPDwMvFUw@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] mm: zswap: Batched zswap_compress() for storing
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

On Fri, Nov 20, 2026 at 8:20=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] mm: zswap: invalid and unreset dst scatterlist lengths in
>   zswap_compress()
> - [High] mm: zswap: unterminated dst scatterlist slice passed in
>   zswap_compress()
> - [Medium] mm: zswap: unsigned sg->length check and error accounting in
>   zswap_compress()
> --
>
> commit a77cc3e636d5134b6371aa977bb1025c031583c2
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Batched zswap_compress() for storing large folios in batches.
>
> This commit replaces the per-page zswap_compress() call in
> zswap_store_pages() with a batched zswap_compress() and
> zswap_update_entries() that compress up to ZSWAP_MAX_BATCH_SIZE pages per
> batch using a per-CPU scatterlist table mapped to destination buffers.
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 5e1fb5624ffb8..56354a568bad0 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> [ ... ]
> > @@ -949,6 +971,26 @@ static int zswap_cpu_comp_prepare(unsigned int cpu=
, struct hlist_node *node)
> >               }
> >       }
> >
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
> > +
> [ ... ]
> > @@ -965,88 +1007,179 @@ static int zswap_cpu_comp_prepare(unsigned int =
cpu, struct hlist_node *node)
> [ ... ]
> > +static bool zswap_compress(struct zswap_store_context *zc)
> > +{
> > +     u8 nr_batch_pages, batch_start, comp_batch_iter;
> > +     struct scatterlist *sg, *dst_sg;
> > +     unsigned int slen;
> > +     int err;
> >
> >       /*
> > +      * @nr_batch_pages is constrained by the per-CPU comp_ctx's compr=
essor
> > +      * batch size and the @zc->nr_pages in this store batch. @slen in=
dicates
> > +      * the total source length bytes for @nr_batch_pages.
> >        */
> > +     nr_batch_pages =3D min(zc->comp_ctx->compr_batch_size, zc->nr_pag=
es);
> >
> >       /*
> > +      * Compress the @nr_pages in @folio starting at index @folio_star=
t
> > +      * in batches of @nr_batch_pages.
> >        */
> > +     for (batch_start =3D 0; batch_start < zc->nr_pages;
> > +          batch_start +=3D nr_batch_pages) {
> > +             /*
> > +              * Clamp the last iteration's batch size if the compresso=
r's
> > +              * batch_size does not evenly divide @zc->nr_pages.
> > +              */
> > +             nr_batch_pages =3D min(nr_batch_pages, zc->nr_pages - bat=
ch_start);
> > +             slen =3D nr_batch_pages * PAGE_SIZE;
> > +
> > +             /*
> > +              * Send @nr_batch_pages to crypto_acomp for compression:
> > +              *
> > +              * These pages are in @zc->folio's range of indices in th=
e
> > +              * interval:
> > +              *     [@zc->folio_start + @batch_start,
> > +              *      @zc->folio_start + @batch_start + @nr_batch_pages=
).
> > +              *
> > +              * The source folio pages in the batch are directly submi=
tted to
> > +              * crypto_acomp via acomp_request_set_src_folio().
> > +              */
> > +             acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->f=
olio,
> > +                             (zc->folio_start + batch_start) * PAGE_SI=
ZE,
> > +                             slen);
> > +
> > +             dst_sg =3D zc->comp_ctx->sg_table->sgl + batch_start;
> > +             dst_sg->length =3D slen;
>
> [Severity: High]
> Does setting only dst_sg->length =3D slen overrun acomp_ctx->comp.buffers=
[]
> and leave dst_sg[1 .. nr_batch_pages - 1].length uninitialized when
> nr_batch_pages > 1?
>
> Each entry in acomp_ctx->comp.sg_table->sgl is mapped to a single
> PAGE_SIZE buffer in acomp_ctx->comp.buffers[i], and earlier runs overwrit=
e
> each entry's sg->length with compressed lengths or negative error codes.
> When a batching compressor runs with nr_batch_pages > 1, dst_sg[0].length
> is set to nr_batch_pages * PAGE_SIZE (exceeding its PAGE_SIZE buffer),
> while dst_sg[1 .. nr_batch_pages - 1].length are not reset to PAGE_SIZE.
> If the compressor fails when zc->wb_enabled is true without updating
> dst_sg[1 .. nr_batch_pages - 1].length, any entry still holding a stale
> compressed length (0 < sg->length < PAGE_SIZE) from a previous call will
> skip the PAGE_SIZE fallback and cause zswap_update_entries() to store
> stale data from the previous folio.
>
> Each of the nr_batch_pages scatterlist entries in dst_sg needs its length
> reset to PAGE_SIZE before crypto_acomp_compress().

Summary:
=3D=3D=3D=3D=3D=3D=3D=3D
Batching compressors that result in this code seeing
zc->nr_batch_pages > 1, need to set the individual SG->lengths in the
list starting at dst_sg, to contain the result of the respective
page's compression status in the batch. crypto_acomp_compress() for
the batch will return a negative error in "err", however, each *page
in the batch* could have compressed successfully or compressed with an
error.

The code in patch 8 is handling this contract correctly, for both
non-batching compressors like ZSTD and for batching compressors.

For a reference implementation of how a batching compressor should
handle this contract, please see patch 16/26 in [3]:

[3]: https://patchwork.kernel.org/project/linux-mm/cover/20260125033537.334=
628-1-kanchana.p.sridhar@intel.com/

This is the reference implementation for iaa that correctly handles
this for batch compression, for instance:

+static __always_inline int iaa_comp_submit_acompress_batch(
+ struct iaa_compression_ctx *ctx,
+ struct iaa_req *parent_req,
+ struct iaa_req **reqs,
+ int nr_reqs,
+ unsigned int unit_size)
+{
+ struct sg_page_iter sgiter;
+ struct scatterlist *sg;
+ int i, err, ret =3D 0;
+
+ __sg_page_iter_start(&sgiter, parent_req->src, nr_reqs,
+     parent_req->src->offset/unit_size);
+
+ for (i =3D 0; i < nr_reqs; ++i, ++sgiter.sg_pgoffset) {
+ sg_set_page(reqs[i]->src, sg_page_iter_page(&sgiter), PAGE_SIZE, 0);
+ reqs[i]->slen =3D PAGE_SIZE;
+ }
+
+ /*
+ * Prepare and submit the batch of iaa_reqs to IAA. IAA will process
+ * these compress jobs in parallel.
+ */
+ for_each_sg(parent_req->dst, sg, nr_reqs, i) {
+ sg->length =3D PAGE_SIZE;
+ reqs[i]->dst =3D sg;
+ reqs[i]->dlen =3D PAGE_SIZE;
+
+ err =3D iaa_comp_acompress(ctx, reqs[i]);
+
+ if (likely(err =3D=3D -EINPROGRESS)) {
+ reqs[i]->dst->length =3D -EAGAIN;
+ } else if (unlikely(err)) {
+ reqs[i]->dst->length =3D err;
+ ret =3D -EINVAL;
+ } else {
+ reqs[i]->dst->length =3D reqs[i]->dlen;
+ }
+ }
+
+ return ret;
+}
+

Details:
=3D=3D=3D=3D=3D=3D=3D=3D
For additional context, reiterating some of my earlier responses to
Sashiko's comments.

v2 7/8 response:

Excellent questions. For compressors for which compr_batch_size > 1,
i.e., zc->nr_batch_pages > 1, that batching algorithm's driver is
expected to test for req->slen > req->unit_size and use
req->slen/req->unit_size to ascertain the # of SG lists to process (in
the case of compression). Please refer to a reference implementation
in [1] and [2].

[1]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-17-kanchana.p.sridhar@intel.com/
[2]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-19-kanchana.p.sridhar@intel.com/

The crypto_acomp algorithms don't use
zc->comp_ctx->sg_table->sgl->length as inputs, these values are always
over-written as the output of compression (patch 3 in this series).

>
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
> > +             acomp_request_set_dst_sg(zc->comp_ctx->areq.req, dst_sg, =
slen);
>
> [Severity: High]
> Isn't dst_sg an unterminated scatterlist slice whenever
> batch_start + nr_batch_pages < ZSWAP_MAX_BATCH_SIZE?
>
> sg_alloc_table() only sets SG_END on sgl[ZSWAP_MAX_BATCH_SIZE - 1], so
> passing dst_sg as req->dst leaves sg_nents(req->dst) equal to
> ZSWAP_MAX_BATCH_SIZE - batch_start (4, 3, or 2 instead of nr_batch_pages)=
.
> In-tree hardware acomp drivers rely on sg_nents(req->dst):
> iaa_comp_acompress() falls back to software deflate whenever
> sg_nents(req->dst) > 1 (affecting all order-0 folios and 3 of every 4
> pages in a batch), while __qat_bl_sgl_to_bufl() and
> hisi_acc_sg_buf_map_to_hw_sgl() walk and DMA-map all sg_nents(req->dst)
> entries up to sgl[3] using their sg->length fields, which can still hold =
a
> negative errno such as (unsigned int)-ENOSPC (~4 GiB) left behind by a
> prior failed batch.

Great analysis, Sashiko. Patch 11/26 in [3] sets up the iaa compressor
to handle exactly this scenario [4]. Then, you can understand how [4]
sets up the batching architecture in zswap to work with iaa's
batching, in [5]:

[4]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-12-kanchana.p.sridhar@intel.com/
[5]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-17-kanchana.p.sridhar@intel.com/

Any batching compressor must adapt to work with the new architecture.

zswap with ZSTD already works and demonstrates good performance
improvements with this architecture.

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
> > +
> > +             /*
> > +              * For each output SG list in @acomp_ctx->req->sg_table->=
sgl,
> > +              * the @sg->length should be set to either the page's com=
pressed
> > +              * length (success), or it's negative value compression e=
rror.
> > +              */
> > +             for_each_sg(dst_sg, sg, nr_batch_pages, comp_batch_iter) =
{
> > +                     if (((int)sg->length <=3D 0) || (sg->length >=3D =
PAGE_SIZE)) {
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
> > +     for_each_sg(dst_sg, sg, nr_batch_pages, comp_batch_iter) {
> > +             if ((int)sg->length < 0) {
> > +                     if ((int)sg->length =3D=3D -ENOSPC)
> > +                             zswap_reject_compress_poor++;
> > +                     else
> > +                             zswap_reject_compress_fail++;
> > +             }
> > +     }
> >
> > +     return false;
> >  }
>
> [Severity: Medium]
> Won't evaluating sg->length > PAGE_SIZE on an unsigned int trigger
> WARN_ON_ONCE() whenever sg->length holds a negative error code?
>
> Because sg->length is unsigned, a negative error code in sg->length (such
> as -ENOSPC from a failed page in a batch) satisfies sg->length > PAGE_SIZ=
E
> when !zc->wb_enabled, firing a spurious WARN_ON_ONCE() and overwriting th=
e
> error code with -EINVAL so compress_error increments
> zswap_reject_compress_fail instead of zswap_reject_compress_poor.

Yes, I will disambiguate the (sg->length > PAGE_SIZE) check for error
code vs. a real case of an invalid length in the next rev. Thanks for
the catch.

> Conversely, if crypto_acomp_compress() returns an early request-level
> error in err before writing negative error codes into dst_sg->length,
> jumping to compress_error leaves all sg->length values positive and
> returns false without incrementing either rejection counter.

This is not expected to happen today for non-batching compressors, as
explained above. Batching compressors need to follow the architecture
described in "Summary" above, to correctly handle this. A reference
implementation for how the iaa batching compressor could handle this
is also provided in "Summary".


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.57=
85-1-kanchanapsridhar2026@gmail.com?part=3D8
