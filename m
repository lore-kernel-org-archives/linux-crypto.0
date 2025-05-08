Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C1D21E0AF;
	Thu,  8 May 2025 21:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746739218; cv=none; b=CmA8yoY6s7a79JsHWRUYxPIU1TsE4KRcGukphwvau5rFswHDeEgxJOV8DRLi270pzU4Xi/4v/O/z+j6vUZNybXDI6sBeDCvIrJLwM+5s/gezO1Tz4CJfCZo38r+IhR6DxTpc5q67xDcHsgnxDBjoSB1MxF40pxF9XXpgSl1Q+aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746739218; c=relaxed/simple;
	bh=Xmd2I+VaZ/9eKyBcbs93FlK1nFrYWuqlvdTAUxHw4fg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PlGtHikGfQTAtxiV0MKBk4Fy5ma/8uTIbPHk0+6TeZp0/w0PA+l72D9PK5h6emEyHcGZi0RsctsnizXp0uLS3RV+5+A3apAtfurDghXG2IgGkT5lJMKFAQm/3aVgNPbxeLUurSjJ3pNKkEz6IHVIGMgZYCYRVUfn+k7GlLwA8FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d+/jQkHE; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+/jQkHE"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6f0c30a1cb6so12911356d6.2;
        Thu, 08 May 2025 14:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746739216; x=1747344016; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6ecuBg6SUtFmSzElOZogZBJCPGazdjaNlguYrKtp8U=;
        b=d+/jQkHEYARaIPJYZuVN+h+pPuzwdYOTsU5YKeKfRHzmaXVvzfhfHh7RlPpbwO9Yx7
         j2MX9HYTXxdg6Xdj+pDnxinebCHjZZCY8inWvq0dfayTrFLokWYRm0QDXBt/RzlAZva5
         HUg/DDpCz/WqfZZ0Zstu/dKg5j9GgX7EvdoCjJZwpTy/bz+xTvGGyz1agQQqADo55sRJ
         Q328SEn9x8kMF2/HtB5luqQ+X63xjYWVcmWxf2Lr0d89GCCcd2BBGFiR1UDy3rgiS4id
         Q1/F2eI76kCeiscxXK3xCWrZlg8J2WsIlX2Y6yvQB9juvb1PU6fH8wIqGZWUWGDoPhX1
         ct+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746739216; x=1747344016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c6ecuBg6SUtFmSzElOZogZBJCPGazdjaNlguYrKtp8U=;
        b=nTYzSs66qXBu4B9xs8frUtkIxkucv913TqLxwa25Pr1HsvMT3LusBNJpMTjgEfq7b2
         Jxesqj0qkAATkQ0tJ0hghGxnoKHkXpZHdW58f3rP4pLkJeU7D7fYOYUkI3O8P3n/TXku
         F219wPRqjYmmp4SEJ2/nAln8gXfhOkNGxp8GR1b0IoZKx5xnMs0Megr/0l3cIbih72DE
         7GzMaqDdThyoUkM0ry1hCLJxansLtXsPDodIwFXjXzRxw66qR0TL1F0mQ7j6WA6uBElM
         JdTnrnHuPiWAKocs2Ol86ipPXB2PJqwVGqsoYv1vtlbeejS7grBNZxDFNbC16YGnrdjL
         TSmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQwwWYoMWUNdpjldiqEa4fmn9Qkb3wKfqXDp0W5DB5a9FXHlROvL/uKLxSMUPOIehRiSNeswDp4+1k2Jw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbCjuKgc4s/9xNbFoXWoqQXi3uQWeX3shamNTsfAv6l/D9/pSe
	L2iKfE0eL6NxaxDLrjnjLkjLwEPtKF6EYA4yeNdknmKGpyLDVgHe3l6D8nzfipONOp0gX6XiNie
	CSi0dIPcx03Kn333jbBvm2aNIlXA=
X-Gm-Gg: ASbGncs2OFJuZvLVvvSy/NAKlU+K/CdqPkNnw6KBGuEUA6VRifp9TQSfs0mdvTz9pY/
	cq2xhyGMvV13CzyN80UUGH6PLvO5NojOZP+mXi20u/ONvl1yILWWY2ioqDC3G/2XmChIeDPnQWa
	hSkrVGL0h9SByaF/buf2tCx6kKlEKp8YS1UEe12prkE/VQQFAb
X-Google-Smtp-Source: AGHT+IEUVc1Z1Ki89dIWFxYP3C8XvwQ3BlPZZbY0JKU58WTVGFqSIOXjZrvoyLsmQ4rXvkdeBmH3S5xi9ejTADbdZ3A=
X-Received: by 2002:a05:6214:240d:b0:6eb:1e80:19fa with SMTP id
 6a1803df08f44-6f6e47a7723mr13889426d6.1.1746739215627; Thu, 08 May 2025
 14:20:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com> <CAKEwX=NJm-9zodgb_UC2z+vshw98MmcqZDw_xvbQWaaU29eGMw@mail.gmail.com>
In-Reply-To: <CAKEwX=NJm-9zodgb_UC2z+vshw98MmcqZDw_xvbQWaaU29eGMw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 8 May 2025 14:20:04 -0700
X-Gm-Features: AX0GCFt5TchwkrKRR1_yOZ-6N9xtr5dZhaLGBwRa--37b4LOM6CzsjWh6Mv0h8k
Message-ID: <CAKEwX=MybjpmXVxM3QbfdQyXOv2xq87CZKzh1w2pdxucwSMttA@mail.gmail.com>
Subject: Re: [RESEND PATCH v9 00/19] zswap compression batching
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 1:55=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Thu, May 8, 2025 at 12:41=E2=80=AFPM Kanchana P Sridhar
> <kanchana.p.sridhar@intel.com> wrote:
> >
> >
> > Compression Batching:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > This patch-series introduces batch compression of pages in large folios=
 to
> > improve zswap swapout latency. It preserves the existing zswap protocol=
s
> > for non-batching software compressors by calling crypto_acomp sequentia=
lly
> > per page in the batch. Additionally, in support of hardware accelerator=
s
> > that can process a batch as an integral unit, the patch-series creates
> > generic batching interfaces in crypto_acomp, and calls the
> > crypto_acomp_batch_compress() interface in zswap_compress() for compres=
sors
> > that intrinsically support batching.
> >
> > The patch series provides a proof point by using the Intel Analytics
> > Accelerator (IAA) for implementing the compress/decompress batching API
> > using hardware parallelism in the iaa_crypto driver and another proof p=
oint
> > with a sequential software compressor, zstd.
>
> Any plan on doing hardware accelerated/offloaded/parallelized zstd? :)
>
> >
> > SUMMARY:
> > =3D=3D=3D=3D=3D=3D=3D=3D
> >
> >   The first proof point is to test with IAA using a sequential call (fu=
lly
> >   synchronous, compress one page at a time) vs. a batching call (fully
> >   asynchronous, submit a batch to IAA for parallel compression, then po=
ll for
> >   completion statuses).
> >
> >     The performance testing data with usemem 30 processes and kernel
> >     compilation test using 32 threads, show 67%-77% throughput gains an=
d
> >     28%-32% sys time reduction (usemem30) and 2-3% sys time reduction
> >     (kernel compilation) with zswap_store() large folios using IAA comp=
ress
> >     batching as compared to IAA sequential.
> >
> >   The second proof point is to make sure that software algorithms such =
as
> >   zstd do not regress. The data indicates that for sequential software
> >   algorithms a performance gain is achieved.
> >
> >     With the performance optimizations implemented in patches 18 and 19=
 of
> >     v9, zstd usemem30 throughput increases by 1%, along with a 6%-8% sy=
s time
> >     reduction. With kernel compilation using zstd, we get a 0.4%-3.2%
> >     reduction in sys time. These optimizations pertain to common code
> >     paths, removing redundant branches/computes, using prefetchw() of t=
he
> >     zswap entry before it is written, and selectively annotating branch=
es
> >     with likely()/unlikely() compiler directives to minimize branch
> >     mis-prediction penalty. Additionally, using the batching code for
> >     non-batching compressors to sequentially compress/store batches of =
up
> >     to ZSWAP_MAX_BATCH_SIZE (8) pages seems to help, most likely due to
> >     cache locality of working set structures such as the array of
> >     zswap_entry-s for the batch.
>
> Nice!
>
> >
> >     Our internal validation of zstd with the batching interface vs. IAA=
 with
> >     the batching interface on Emerald Rapids has shown that IAA
> >     compress/decompress batching gives 21.3% more memory savings as com=
pared
> >     to zstd, for 5% performance loss as compared to the baseline withou=
t any
> >     memory pressure. IAA batching demonstrates more than 2X the memory
> >     savings obtained by zstd at this 95% performance KPI.
> >     The compression ratio with IAA is 2.23, and with zstd 2.96. Even wi=
th
> >     this compression ratio deficit for IAA, batching is extremely
>
> I'm confused. How does IAA give more memory savings, while having a
> worse compression ratio? How do you define memory savings here?
>
> >     beneficial. As we improve the compression ratio of the IAA accelera=
tor,
> >     we expect to see even better memory savings with IAA as compared to
> >     software compressors.
> >
> >
> >   Batching Roadmap:
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >   1) Compression batching within large folios (this series).
> >
> >   2) Reclaim batching of hybrid folios:
> >
> >      We can expect to see even more significant performance and through=
put
> >      improvements if we use the parallelism offered by IAA to do reclai=
m
> >      batching of 4K/large folios (really any-order folios), and using t=
he
> >      zswap_store() high throughput compression pipeline to batch-compre=
ss
> >      pages comprising these folios, not just batching within large
> >      folios. This is the reclaim batching patch 13 in v1, which we expe=
ct
> >      to submit in a separate patch-series.
>
> Are you aware of the current kcompressd work:
>
> https://lore.kernel.org/all/20250430082651.3152444-1-qun-wei.lin@mediatek=
.com/
>
> It basically offloads compression work into a separate kernel thread
> (kcompressd), for kswapd reclaim.
>
> This might provide you with a more natural place to perform batch
> compression - instead of compressing one page at a time from the
> worker thread's queue, you can grab a batch worth of pages and feed it
> to IAA.
>
> Downside is it only applies to indirect reclaim. Proactive and direct
> reclaimers are not covered, unfortunately.
>
> >
> >   3) Decompression batching:
> >
> >      We have developed a zswap load batching interface for IAA to be us=
ed
> >      for parallel decompression batching, using swapin_readahead().
> >
> >   These capabilities are architected so as to be useful to zswap and
> >   zram. We are actively working on integrating these components with zr=
am.
>
> Yeah problem with readahead is you can potentially get different
> backends in the batch, and modifying readahead code is pretty ugly :)
> But we'll see...
>

Another place where you can do decompression batching is for zswap
writeback :) Right now, we are decompressing the pages and writing
them back one page at a time. You can, however, grab a batch worth of
them, feed to IAA for processing, before submitting them all for IO :)

I have a prototype that perform batch writeback (mostly for IO
efficiency purpose) - lmk if you want to play with it. Problem, as
usual, is benchmarking :)
