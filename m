Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D0128DC4
	for <linux-crypto@vger.kernel.org>; Sun,  1 Feb 2026 00:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769906938; cv=pass; b=edph+AzQ7NMNFi1mOeT219wxP3M50/XMoepmLJm/6VrOP9DRip7WzW3/gPHIghXkyLYUHj6qr8PFm1KTlpBVLy9W0bZxCugA3aOvqfh2GJuWTN+5lBcKbg4KFoCBYSbO49UnMEa0kLd40+DS9zAvHJexNL93Rvq/p/eqSFGPY4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769906938; c=relaxed/simple;
	bh=hs8T3NNkLpM4EikOE8ZjmUECH+sxbIOwLR64aM/7twU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N/Z+WJzgX8eFDFkNpNedW4WO/QQB3xyNflnJ0MLf/MoRejhnL/CuV28oWufcc9yRd5tFYUyL+snPff3E+RQTch+Nb3zleCBbVblEDeqeVGOWF+DFmuWXHHhzZ+vzR7RpmMZSXO2OfG3UH99wsOCLmOmtwZdEMRFRbNJaQia/aPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ii+FP8Le; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ii+FP8Le"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42fbbc3df8fso2506915f8f.2
        for <linux-crypto@vger.kernel.org>; Sat, 31 Jan 2026 16:48:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769906935; cv=none;
        d=google.com; s=arc-20240605;
        b=AHmx6kSNKmWMffZkyGQ0oXabtPN2etfKwr3Mm2fioDvPWXUwMqAJR/aBnj8YKzTZYK
         PTWXQYSE//jQ8peZBoSGYCaHhmvshW/UxFBIe06lKyjjvXPc2STIHNxSnC0y1eM2BSwR
         y3eWrzdLJp2KpfHO2gv9/DVml9xkWg57woHJAggokmxxSwTqZTARyn2KrYDpheilNLpK
         0yKIJzrhdbIeSxuDSHEp4HUTh+2cJDmzzPjiwyK2Zszba2OlKkJzjrWOKwpIfUS4Hmax
         8fOiMo4JE6O/qVGHCc5c8YICRagVw6uSzLnKDGrRU7NHHotZI0aYtPGOVtxl9UkAaCyW
         bqRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IxzRN1GvYKcSA1myNnRhFl1/mDOmpAJaN3X4Z/70v0Y=;
        fh=RIkKpaXjuFr5HBGf+4f0ilXm/frA7ggMae8rj9g2VxI=;
        b=AAmFg1dweEsxKzwEHva0Y2A/9NX0IWva8WZYPn53OF6y38+LjgHfIsaFp2g32zkKU+
         R1aC2kWFlm5lHjjT4birdMnjqu8kCW4+D6upwRZSscuaej0g5v5Z0NfPBNXyRObP7xHt
         UIMp9aGH3r7s6veEf9JdTAVfPr/Sny403daKQeA3zJwWjedAgqpQDmjzqN8iK/CMvrNr
         0tx7PIT7QdyoNRWRZ9clDX0JsNw1czOstCwW8F9JtZ0cxG7pECeOJnQwqmwzMyEil+Vj
         uMJoU0vDSZYU6V5BHQkTSSChZ78ciIaszcqzJ5bJjZTulhA8g5zweHAMiTdF6YGMB04E
         IAag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769906935; x=1770511735; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxzRN1GvYKcSA1myNnRhFl1/mDOmpAJaN3X4Z/70v0Y=;
        b=Ii+FP8Le9IJFSuYbiOKHxlDMkg0XzxHMJOcac3z+6qXGXrqvDcnfDY4gHVzjOcOJ6o
         /f+es0k0iEP6vhMm/p5GSl1U7ZW5P5r7Lr3QnYJUrPXqtdOA3t6SSldPzFFT6B3TxoTS
         yfrykJCynRfuAols4UkDejyNbNN4WAOaZcGdqPJMY/eipFrYRfmSpBbQZCLHa3q6RF8x
         a6B2oGlFI2S34sFcwH90RY6G4xIqQ3oyd1KXo7JQV9qJYx/JL9UyIKUyGAYTk1G+NHd2
         eKe7tc03xRbE8Uw9o7KpLmT4J3XjnHCoZ7NtDWT5GavHuM829vsI9JlpcTdfpMdx3EET
         DIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769906935; x=1770511735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IxzRN1GvYKcSA1myNnRhFl1/mDOmpAJaN3X4Z/70v0Y=;
        b=bMxdKJPryF/3wI18cpyJ6vXQc1tPbU1x7sx95UFgejxgKymnn06TrLNS6qfQB/RPnf
         B7wyTZqwI/Cd52+rruqXxJ6EFt8vquj42b7B6W7i/TrQ7/HTIbi85fwiVNOavr3kgikM
         T/hXkwVUl/rNMiP4OfUsFcRBc+tmiGQMz2+tP/fBKeG0Me6+fTY4GCRqNrNlmxfKSGwF
         Bl8VCnwCKLdEyrr9B1/fmMkH7Ars+a8zcAs0g2FNdv5dbU/4coXMCGiL1S+ueOemEu+f
         NAwiSafk1owX9EAq7cRM0U7LctRQORGbjKHpodeiIHJP+XBc8sRv9v3Qx4/9UxA2LhxU
         2EBw==
X-Forwarded-Encrypted: i=1; AJvYcCVGhFxwuK55smjVVb9PwX1KRDZRJN7XJMiPWJRaWzLlBxH/48Xd733aEdkgyUJvzJAR5uiX40xH5b8qOng=@vger.kernel.org
X-Gm-Message-State: AOJu0YyprL3edSTL8bgc0+cx+nDXWz9/x7tngc2zT3Vh+sWcGY7R0zwq
	rUp41mosurMUjDDAkGND6EZ5bf7sYkr0NmocSg1FIA4ZcpVPclC64dtYBGQ0sEPgNEqEAbR5P/t
	LsMLrNShvZhGCsBViy60hrasLVNX8HAk=
X-Gm-Gg: AZuq6aI7/wGBKDvmBhC4ObOBpmaIwBkBjuuSw1GNiGPzlCkx7bUrTUtxPiyIcfhtwbr
	DLKPFDlPackx69pakEkZGkqWp7vR/x7IwZC2J+coTNgINh2Iap6bMBPxAMOi49kHBkmoxaqsZDs
	D+aWy1uSyOe3QICewL4Dm/kG3Dve5a4KxrXLeULpOg4qLTeBV7rgs3wyrdpaY91tEHyZZ2O/69H
	msSEQB2jWRt2jxrD/SLSN4nzt+oNU/fKJg6CWw6O3mmmSOq7kPIUdu+y7lnCgRjyfho7g==
X-Received: by 2002:a05:6000:2c01:b0:435:8ec5:d27b with SMTP id
 ffacd0b85a97d-435f3a7bfecmr11333484f8f.26.1769906934865; Sat, 31 Jan 2026
 16:48:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-27-kanchana.p.sridhar@intel.com> <CAKEwX=PS7mjuhaazydkE2TOVa5DWQu9521FqH4aXi0yptZQaeA@mail.gmail.com>
 <SJ2PR11MB8472E5DC16759FFE6E23EED0C99CA@SJ2PR11MB8472.namprd11.prod.outlook.com>
In-Reply-To: <SJ2PR11MB8472E5DC16759FFE6E23EED0C99CA@SJ2PR11MB8472.namprd11.prod.outlook.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 31 Jan 2026 16:48:43 -0800
X-Gm-Features: AZwV_Qi4WDbYOooIOPZu2Ppua8Lejwpek0DNwYJiKSz_rJv0IVeNCuN7p921l5s
Message-ID: <CAKEwX=PqWQ_39BuApc_bT1WKQMJyNPDs+Gv0JAU5cTa1KNDj9g@mail.gmail.com>
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 31, 2026 at 12:32=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Nhat Pham <nphamcs@gmail.com>
> > Sent: Friday, January 30, 2026 5:13 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosry.ahmed@linux.dev; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.co=
m>;
> > Cabiddu, Giovanni <giovanni.cabiddu@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>
> > Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
> > compress batching of large folios.
> >
> > On Sat, Jan 24, 2026 at 7:36=E2=80=AFPM Kanchana P Sridhar
> > <kanchana.p.sridhar@intel.com> wrote:
> > >
> > > We introduce a new batching implementation of zswap_compress() for
> > > compressors that do and do not support batching. This eliminates code
> > > duplication and facilitates code maintainability with the introductio=
n
> > > of compress batching.
> > >
> > > The vectorized implementation of calling the earlier zswap_compress()
> > > sequentially, one page at a time in zswap_store_pages(), is replaced
> > > with this new version of zswap_compress() that accepts multiple pages=
 to
> > > compress as a batch.
> > >
> > > If the compressor does not support batching, each page in the batch i=
s
> > > compressed and stored sequentially. If the compressor supports batchi=
ng,
> > > for e.g., 'deflate-iaa', the Intel IAA hardware accelerator, the batc=
h
> > > is compressed in parallel in hardware.
> > >
> > > If the batch is compressed without errors, the compressed buffers for
> > > the batch are stored in zsmalloc. In case of compression errors, the
> > > current behavior based on whether the folio is enabled for zswap
> > > writeback, is preserved.
> > >
> > > The batched zswap_compress() incorporates Herbert's suggestion for
> > > SG lists to represent the batch's inputs/outputs to interface with th=
e
> > > crypto API [1].
> > >
> > > Performance data:
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > As suggested by Barry, this is the performance data gathered on Intel
> > > Sapphire Rapids with two workloads:
> > >
> > > 1) 30 usemem processes in a 150 GB memory limited cgroup, each
> > >    allocates 10G, i.e, effectively running at 50% memory pressure.
> > > 2) kernel_compilation "defconfig", 32 threads, cgroup memory limit se=
t
> > >    to 1.7 GiB (50% memory pressure, since baseline memory usage is 3.=
4
> > >    GiB): data averaged across 10 runs.
> > >
> > > To keep comparisons simple, all testing was done without the
> > > zswap shrinker.
> > >
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >   IAA                 mm-unstable-1-23-2026             v14
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >     zswap compressor            deflate-iaa     deflate-iaa   IAA Bat=
ching
> > >                                                                   vs.
> > >                                                             IAA Seque=
ntial
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >  usemem30, 64K folios:
> > >
> > >     Total throughput (KB/s)       6,226,967      10,551,714       69%
> > >     Average throughput (KB/s)       207,565         351,723       69%
> > >     elapsed time (sec)                99.19           67.45      -32%
> > >     sys time (sec)                 2,356.19        1,580.47      -33%
> > >
> > >  usemem30, PMD folios:
> > >
> > >     Total throughput (KB/s)       6,347,201      11,315,500       78%
> > >     Average throughput (KB/s)       211,573         377,183       78%
> > >     elapsed time (sec)                88.14           63.37      -28%
> > >     sys time (sec)                 2,025.53        1,455.23      -28%
> > >
> > >  kernel_compilation, 64K folios:
> > >
> > >     elapsed time (sec)               100.10           98.74     -1.4%
> > >     sys time (sec)                   308.72          301.23       -2%
> > >
> > >  kernel_compilation, PMD folios:
> > >
> > >     elapsed time (sec)                95.29           93.44     -1.9%
> > >     sys time (sec)                   346.21          344.48     -0.5%
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >   ZSTD                mm-unstable-1-23-2026             v14
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >     zswap compressor                   zstd            zstd     v14 Z=
STD
> > >                                                              Improvem=
ent
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >  usemem30, 64K folios:
> > >
> > >     Total throughput (KB/s)       6,032,326       6,047,448      0.3%
> > >     Average throughput (KB/s)       201,077         201,581      0.3%
> > >     elapsed time (sec)                97.52           95.33     -2.2%
> > >     sys time (sec)                 2,415.40        2,328.38       -4%
> > >
> > >  usemem30, PMD folios:
> > >
> > >     Total throughput (KB/s)       6,570,404       6,623,962      0.8%
> > >     Average throughput (KB/s)       219,013         220,798      0.8%
> > >     elapsed time (sec)                89.17           88.25       -1%
> > >     sys time (sec)                 2,126.69        2,043.08       -4%
> > >
> > >  kernel_compilation, 64K folios:
> > >
> > >     elapsed time (sec)               100.89           99.98     -0.9%
> > >     sys time (sec)                   417.49          414.62     -0.7%
> > >
> > >  kernel_compilation, PMD folios:
> > >
> > >     elapsed time (sec)                98.26           97.38     -0.9%
> > >     sys time (sec)                   487.14          473.16     -2.9%
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The rest of the patch changelog (architectural and future
> > considerations)  can stay in the cover letter. Let's not duplicate
> > information :)
> >
> > Keep the patch changelog limited to only the changes in the patch
> > itself (unless we need some clarifications imminently relevant).
>
> Hi Nhat,
>
> Thanks for this comment. Yosry had also pointed this out in [1]. I have
> been including the architectural and future considerations in this change=
 log
> since Andrew had asked me to do so. I hope this is Ok?

Ah hmmmmm. For some reasons I was under the assumption that usually
Andrew would concatenate the patch cover letter and the patch
changelog before merging. Oh well.

If Andrew prefers including that here then I'm fine with it.

>
> [1]: https://patchwork.kernel.org/comment/26706240/
>
> >
> > I'll review the remainder of the patch later :)
>
> Sure.
>
> Thanks,
> Kanchana
