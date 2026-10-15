Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0759F3B1008
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792104687; cv=pass; b=mJxwxLUCzrS+zmi+ELlYUfjRvyZoUla3ge1NbfMNljFYmrkn4iah1ofJiG4HxYwExldDOQ8BIMUAMN4BRLI8PAO1kRfCsul0TFR6mpRc3ryXbcpnY4xRm/LcDipOLAooJJWuEopGvOiBOTmb0rQHdbPtR5LDNcRiQ1hWg5tBZ0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792104687; c=relaxed/simple;
	bh=1sT8NdIr+AU2SPJki3v9lJtmhGP0p+Dta5BBYpiM838=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AgTcPDmd/5f1FaLn/FfcSWPUSey5yV4a402QJcoVZMjXZCM1SIYHEaVEpOYjyN0iUTnb+Sn8xaLouI220M6Zbio9Zzt5Q9k4ss1RwWTr8rDVe4PXjn1T/rBYKjdxF72t3lV6WVKx4CI6vWkU3rIgVU1mvKe8boLZXJcyJdM2ElI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fqZuYkqv; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fqZuYkqv"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5be4b61fd3dso29727e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 15:51:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792104684; cv=none;
        d=google.com; s=arc-20260327;
        b=de+y2pn4BGZF8Fsb8/IpxwcOVR3Uo0ebZzkkPSODquWOVp46NPd4xK/+vEHbCrzyQR
         Yzup63r7kPMi3JFu4+UqstPankh/30KInMSV6lgoYsWOO8lhH9CqY6qeJoI0GEcAB5LO
         20IYlCRQjmK59/Suw5JPEWtYEY5j/96np0J1WULuyr7+1Yu8uf6HB+bXuDldazRyHxad
         q3iqQX2lo1VVJ/fgJZIpKNMpfTSn6xf+nX8pOIf1AzsgCV3WgnR8/qGl6CFC8Tmm00G2
         Mz0m42zKX90fIOCM473RPT1kX+nYVJ5DgEvkiVhMbcvtujfq6tPWXfMv4F2DWIs4TFqs
         4tOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n63KkNNJ2ZOvS2IAs8k+KZxz8QryTA7xZPJO3TDdt5A=;
        fh=vczCO/dywxvG8O87QjQEEKxTlWbq3u3ZnusY9Od8hdc=;
        b=l9JzKoVxMSECqIbd6Fb4OhlxVbZCo8pj+NVxlxganJ5hjcx4M5zWS6pUEpPxpanU7w
         QgZwteIiIW1AEkt6hNsWJiiV7bW/iRetG5rmh46KHG8PaDoiHxV0S126XMQMoBu74Mvw
         sWdyGPtUZ32cFzFxQLY2nDYSshzMJ2PTzMP1FRzEdO+iAm692RqU6NU/RUlWuOfs3cMq
         idDNGljh6YZVxBHgAg1qEW8S4mrSAdpLeyGnS7sAdcwk3NWo6LQXQJjutZmFwH6HJKnj
         FCo+WxP9Aio23JPynZh4RATBUpAuMJGnwAyWtTP6giv3UhbTYMO+qqdYU8TDDVXmlFeD
         Ou7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792104684; x=1792709484; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n63KkNNJ2ZOvS2IAs8k+KZxz8QryTA7xZPJO3TDdt5A=;
        b=fqZuYkqvGWTSuoGfR9kkjcfgt6yx0xIZNE0Q4POhZHahcbLhRjePS5ODBAHj1hm9O2
         EGZ9csHAX4srpNsrPkeRqQ2PF8yla98LcY26tlBti15bVaRVb65f3hD/mwNo8PZCUjYc
         R6wWZJz4eX/vxvTmpnbbnWJgnj3EkJkxNbk549EYNfgF0DXtSQor4OeCalx8oecW4SAK
         xZjw1/BRsuNd8/p3LQQSN84M33KVE2yrLpaiYEkMN7ede9B4Oq8Ow8uaze5icyrTkdBP
         TC4Rz6pLZuVILhn0uzfNyRT2W/UM1mCorPUs1JeBOfig46UCeglkXPw/QJNJaZ+4PlOt
         NnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792104684; x=1792709484;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n63KkNNJ2ZOvS2IAs8k+KZxz8QryTA7xZPJO3TDdt5A=;
        b=0WAfqoNPDbwKyEXDhUICeBcL34rYEBgpLMns6UYIuQp1PlkwD9UsayiTI9C7/sN/Bj
         H1UKNeoqta6egXWCMAiUR55Moun72POIRH7qvHtYYwpUSkw+3ENiw6eomAd+Dph4QlYf
         H3zQZUAX8aH627KH+7MXslrAlAA50QISyGNh2S49M2h5LnuDMqk9r36+Wf5O7SJ5ORtI
         PJ9H0o/owBbj1/4XARSmmLXA3B+zdnfLwmv/SrvQ8iOfHc6YwJMLaRXLoOLgX7COhi3B
         U5XAg3L/f3EF46hgbe1HpjSJdN79yBP0yCkNmOI1QiP4MqEN9vm3Rh9BZzwjnFPOugvl
         8Q7Q==
X-Forwarded-Encrypted: i=1; AKwUvBwcXSOwbXd7Qd181JMmRaO0OQ37DdrYszy2r+0WDE916oL3HP/61+r2vTrRXfe14U4Eo3bx793SPbTU1bg=@vger.kernel.org
X-Gm-Message-State: AFq9FYKvPPdFM4n6a5pAtNvmyYIaVAeqnYuYvPt0e/HF0Hme2B1PoxRu
	mm7jxderNXkhBPzZIXZdlpZaYDCM0th3EyxvhUSF/Mvy0PVUT4TkFkxOZN5d+pLh9Kv0/EcRCQX
	dM+CvFWnrdxWD/EUVEU7Wrk1OJWDvk7I=
X-Gm-Gg: AYBFou1v2g95PnF4PRzh/TVuyLZq5cvR39OKHPV83TqTSXlBSs6I0jjS1FTuvkokQea
	1rycJCr+PhhaZsnjBkFwJ+PtGw4Uf1kdud/Sis/hHYzAyvJK/GmnQ1ba39Ixk3QUVUt3iDDy89d
	B14GI2p1aOcJ6kk7w1e+7fd+BbCcHNn1AvNVoO4vnxRy8hsQaETl+uN/EeUJB52cxDW9U4BePhZ
	S3C03m+fUnHUhYQbGLiWNMEtrkSSgjEJuHmsDcDGGIBXb17Zp2Aksj8tLvIh6f6ns0Ld+F82ruy
	82wiAXf9Ei22YpyOiRnZmdZd5ORMAMpqqFlMPE0XoWZ0Ho0wiz58kQc=
X-Received: by 2002:a05:6512:238c:b0:5bc:b728:31b with SMTP id
 2adb3069b0e04-5bcde39f1c0mr6258902e87.21.1792104683741; Thu, 15 Oct 2026
 15:51:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
In-Reply-To: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 15:51:11 -0700
X-Gm-Features: AclHuK-C_rlfvY9gc7Ysw5I3rgT-17tzvCB8MZKJeUsSlTmiFpKdeYuI1BXf3wA
Message-ID: <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 3:04=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 15, 2026 at 3:00=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Wed, Oct 14, 2026 at 8:45=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wrote:
> > > > v1: Batched zswap_store() with compression batching
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > > >
> > > > This series is a spin-off of "v14: zswap compression batching with =
optimized
> > > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and=
 zswap
> > > > compression batching enablers. Resuming work on this series followi=
ng a gap
> > > > since v14 (January 2026). Please note that my email address and aff=
iliation have
> > > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@g=
mail.com. I
> > > > have retained the original Intel sign-offs on prior patches for his=
torical
> > > > attribution while signing off v1 of this series with my current add=
ress.
> > > >
> > > > To summarize the main contribution of this patch series: Batching i=
s introduced
> > > > in zswap_store() of large folios: we carve out a large folio into b=
atches of
> > > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store =
each
> > > > batch. Moving the fundamental operations that need to be happen to =
store a page
> > > > to now work at the granularity of a batch offers opportunities to o=
ptimize them
> > > > from these perspectives:
> > > >
> > > > 1) Utilize existing kernel API that minimize obtaining locks for bu=
lk
> > > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> > > >
> > > > 2) We keep the working set for each of the core store functionaliti=
es (alloc
> > > >    entries, compress pages, store pages in zsmalloc) to be focused =
on a
> > > >    batch, thereby minimizing cache evictions and benefiting from ca=
che
> > > >    locality.
> > > >
> > > > 3) Along the lines of (1), the main zswap_compress() batching routi=
ne obtains
> > > >    the acomp_ctx mutex lock once per batch, and releases it after i=
t has
> > > >    processed all pages in that batch.
> > > >
> > > > 4) Any zswap store functionality that works on a batch can potentia=
lly be
> > > >    parallelized as a next step, to further improve performance.
> > > >
> > > > Performance data: usemem with 60% over-commit:
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > How much of the performance benefits come from patch 6 vs patch 8?
> >
> > This is how the performance changes: Average throughput is averaged
> > from 10 iterations of usemem.
> >
> > patch 6: 19,119 KB/s
> > patch 8: 17,593 KB/s
> >
> > So the acomp_do_req_chain() path that ZSTD goes through with patch 8
> > causes a regression, even though it provides a generic batching
> > framework in acomp.
> >
> > I was able to retrieve performance with the following change in acompre=
ss.c:
>
> Why add it to begin with in this case?

Patch 3 ("crypto: acomp - Add trivial segmentation wrapper.") was
co-developed with Herbert. The request chaining for non-segmentation
algorithms was as in Herbert's original implementation. Since this
causes a regression, I would like to get Herbert's Ok on replacing the
request chaining in this part of crypto_acomp_compress().

>
> >
> > patch 3 with this change in acompress.c: 19,578 KB/s
> >
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index 192ea996e779..dc609bd7d927 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
> >                 return -EAGAIN;
> >
> >         if (likely(req->unit_size && acomp_request_issg(req))) {
> > -               if (!crypto_acomp_req_seg(tfm))
> > -                       return acomp_do_req_chain(req, true);
> > +               if (!crypto_acomp_req_seg(tfm)) {
> > +                       int err =3D tfm->compress(req);
> > +
> > +                       req->dst->length =3D unlikely(err) ? err : req-=
>dlen;
> > +                       return err;
> > +               }
> >
> >                 return tfm->compress(req);
> >         }
> >
> > Herbert, would you be Ok with this change in patch 3?
