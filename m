Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794014898;
	b=hiYwAPfu3bJa1HQMYXqMKthp/aGxi6TqU/7tEr3eh5SW0Z6lglfAoaGLuToX8E1inbyE
	 i4PN9BGLx1YqB2eeqioRM8GjSH+ki2LRvjjs5ZxoKUdCU+VFWfhELUO//erwl6rNy68HY
	 SLlYnzk79nTczslAKeAQNCwnkm0euSeghJpwm/1ETFXsNNlcNGSy0TAcr8APrOXxV6bk9
	 K53vo0CKmjns4mCRpEJHG4zJQAA+ydZytMw8oKxynkQB1KTwhClHGyg/zHyVztrxfIGBU
	 CSRVCgPh+NpmadEIvY2hVoRkBTFo+ww51qMrOtWgkoQLOj0cLpH9bOdIp7t06dbdBJQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794014898;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=A2K0C4Y601dKboRibgXNYOXQyJ93jJc/YQsibXbCB9k=;
	b=pPC45R49KlJ3+SOzy4YZVs0485oV5HsHmpxMgVJ188t2JIZVW1oQQ3NDGkX4KfILHzvp
	 zDmmVDwrwxT0ZC+s9aYNpYhnEqtdV5B2jgZRPFKb/jzh1wklweK1UMh0OPv5rTaMShtex
	 p4nIC09WfGJ8zku8fh3VGWrLRNkX/NRsTKCwSYk4xasal4MYx8O7H9tvOOks3zlDI6UWE
	 a0bHtMx8Ca0oGWgV93BihIaeJLyPkDlBZV2nMbcWYxn7EYPPRbY1elKo6SeXf+TC8ZXgj
	 rLy9n2EFN0xem+HteFFjsEdkM9TvryVldk+gubSeC1Gwc1cmrOlsAE1iEEzJrz3OmYw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SLS3Ja53;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.179
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7327606A32D
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 01:28:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7327606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SLS3Ja53
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3ab3b29a298so8915531fa.3
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 17:28:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794014896; cv=none;
        d=google.com; s=arc-20260327;
        b=HZYZWnkfDyzq0/ubpNOU7tHlRT9GPku1LvJ4BCCz7I882tk2cpSt7QSG5oB5sRDSYc
         JPzJ1b9efS3LPXDTLpuOiVGFOfqOgWTvs/p3das6KwbQZTpNgqCfCaXzlxQzjiflRieu
         ZONNxv2SryK985RNwB6P1Nyxh6BXHGiFiZHxb/jRW4udtfuHLsgN4/dwXu17G5m3V51u
         zICnBxPnXLweaz51c4+8fszMFsMR7N9v0BnyJGDIuFj067xBdtiijyvqVOjKPyN9ZCPQ
         AxrApTZu7mfFXSsxoWvKVuinC/8f2HDePUpMVpabvWXTksXATmeOLNaQ0mW4DCKVEGfQ
         bu9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A2K0C4Y601dKboRibgXNYOXQyJ93jJc/YQsibXbCB9k=;
        fh=AK2Cc7+eM4G+RKffQZBntmlZkOn+gQWkU6JIjrMfdTE=;
        b=VSIlPfCSBFLHf2IAl4JuiA9JXXDtr3wl3OZVEJ92c9mIpKsSMWNbPruxU1rarM+s+3
         3r8kCIcbvW0gmZhr0qzNRcaTmHty0HRmoKrZwgBGmbtuszlHNnneU+JupEgIoZ47FdxA
         F1smQXEDafqLsb7K171Qo0ztlud+3KSSYPGOCJcZ7M0Gu5skGKvmO9mFJjwtWW7LL/ni
         d9C9g0GRuhM+hG7DtvRaJdwa+nvbvumlVuPpmH7Pp0cka6g9fivHrb7i+4omx67WmFPb
         qB02j2v34TJ2qdRVQrcegclaYfmxxzTvFITAs+pZD62cwvdhK7lAOJ3qNqeYy/WKke5y
         Ry6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794014896; x=1794619696; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A2K0C4Y601dKboRibgXNYOXQyJ93jJc/YQsibXbCB9k=;
        b=SLS3Ja53nrJnn/H4p4EZ2yxPSP/BdpYPXGhiGkFELpsdJHlBXM8rPJzemCk2HosQ/7
         zaFBZMmhfIeLmJnVPfWyU8atIwE4aIogKYtdBXpGgGqgs6mTg0RJVGqfAFbEIQ3tpSAU
         Vag06XNZ4/SOvLg+1u1wou0BjMxVQ9Z95L2CoUOGfdq9mbrIn1bVaG3C8Bc84JN6VxFe
         waRuWRBEfQlY02JTi3Kr5m/+oK9g3lzZ7+071GPiKLtjyvhr4HylCk6Tpe3yLTkpzQ8X
         HGhGb6AiCBnFFeYTr5RAq/HSwL+JzhImfx6M7X0MNLr480WdpSKaj3KF4O7Teg4078pU
         7Vdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794014896; x=1794619696;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A2K0C4Y601dKboRibgXNYOXQyJ93jJc/YQsibXbCB9k=;
        b=b86hq4j0i/C0fh8teIEVzaN7zkf+DPq9AJtG5nFByAUStxebY1Q/NsHI5H3HvSoiKq
         UOijzgrVEM8qXDHZaAuJYFpZQmo9f4mH8ElXG6QO56GOKs7XeEY1pugMbwBXEiCMAmz7
         qDq/Qr7txcUtXPZhU30Y79c8LajFeuVBbQSqXYt7JHzg5A+xg0PlEyjovgIhUzYB5MjO
         q4MURF66Ct45t3CqVS+glK/yQun5TpYhtsvr/XHd/ZJun9FCjtLhH0JebtOJ2OrTzPI6
         RPUobvYXdMrmVPY6vKpwq8uyUGAwmcpqa3fuFgcihOYKDkL/OkgniCSUzAnb9FR830on
         JbuQ==
X-Forwarded-Encrypted: i=1; AL+hErF/BO9ciPmVAJd6OHZna6z8ABy5LxTVUHoiw1qrkZRzhUfo3wHGolyo4xfV/9UG8wIFeCI9agPnI62YIUE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+dw+LXXZ/DjP07fGzX+X4A73ChHtqs86VcpjuMJUT++uUV3xav
	a094X5EtORnFImg4aZfcxQ3LeHcMTqIaIXD/DBqUcAzTTHgW5s8xgauAN6W2orvOqW4pgF0HZSC
	0WZxdgxyPtKcvLpFWivBVwYHLGPUYrn4=
X-Gm-Gg: AYBFou379ALfgijIuthPULkNdgMsHPATJ1T6EwlbtGt3xZq8Jaw5oP9PD2Vfcd3Rr/j
	Qz9tZcUpVOTDuZk/7HsYavG+L6in6UweXsWKNPoAkC7c/1t7f7M4cFj0DD38emPrx3IJMUaYsRA
	j2YM/75K7pxYu8KOXMD8/hlGTSjMF5CRPtMlL/iqsqqVqwb/LgUf1+pNWZEtJTUxpPpU950/sin
	cK0FhhGvCo0FTfV+u1LeEJCeHvkvEnRwtRO/WauWYS42fsHrJDu/m9DufBZUA/78UN8kE7OxyMH
	QSJQhD3UWq8+0E+wrCQWtr5OXgP6uKEDR9NdSXTF3CPvtg7H8/nzUUThczYtXs06FeKBjPupGzC
	2if7UwzK1HhmNnHMXy9UcsYK7JMaUzY96PUk6
X-Received: by 2002:a05:651c:50b:b0:3ac:7ad6:2007 with SMTP id
 38308e7fff4ca-3acf3d2e1b2mr8306571fa.25.1794014895558; Fri, 06 Nov 2026
 17:28:15 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com> <au5l3KEjG_mri-br@google.com>
In-Reply-To: <au5l3KEjG_mri-br@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 6 Nov 2026 17:28:01 -0800
X-Gm-Features: AclHuK8dDkK5HTfWUegZtffyaMCinmRWFj4cc_dRxksYCqbkD4npiRB4j2h1mUA
Message-ID: <CACpmpoc3R8gwkMouwyFLw9PEqyDN1i6OcmPxsvZ1d0QOPSS_fQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] Batched zswap_store() framework with compression batching.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 3:59=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Thu, Nov 05, 2026 at 11:24:04PM -0800, Kanchana P. Sridhar wrote:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >    usemem PMD THP BPFTRACE
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >            Baseline           zswap           zswap          Change    =
Change
> >         mm-unstable           store        compress            with    =
  with
> >          10-25-2026        batching        batching        compress  co=
mpress
> >                         (patch 6-7)       (patch 8)        batching  ba=
tching
> >                                                                (ns)    =
   %
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   zswap_store_order0_folio (ns):
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   p50        39,631          37,538          37,765          -1,866    =
-4.71%
> >   p95        53,088          49,690          49,349          -3,739    =
-7.04%
> >   p99        65,065          63,529          57,404          -7,661   -=
11.77%
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   zswap_store_higher_order_folio (ns):
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   p50    21,460,366      21,201,411      20,383,233      -1,077,133    =
-5.02%
> >   p95    25,975,341      27,558,253      25,045,350        -929,991    =
-3.58%
> >   p99    29,538,493      61,926,648      27,184,835      -2,353,658    =
-7.97%
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   zswap_single_compress_per_page (ns):
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   p50        37,545          39,320          37,218            -327    =
-0.87%
> >   p95        51,549          66,503          51,481             -68    =
-0.13%
> >   p99        89,866         134,854          87,091          -2,775    =
-3.09%
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   zswap_batch_compress_per_page (ns):
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   p50                                        40,493           2,948    =
 7.85%
> >   p95                                        56,944           5,395    =
10.47%
> >   p99                                        76,242         -13,624   -=
15.16%
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
> As with previous versions, I cannot reproduce these results. I tried
> with a QEMU VM on a Cascade Lake host. I saw marginal improvements with
> patch 6 and no significant gain with patches 7-8.
>
> I noticed that you omitted high-level metrics (e.g. throughput), I
> didn't see significant changes in throughput, and I also ran a kernel
> build and saw a small regression in some cases (probably with order-0
> folios) and no significant improvement otherwise. Even if latency for
> some functions does improve slightly, it doesn't matter if it doesn't
> show up on higher-level metrics.
>
> It could be the difference in setups, or the overhead of bpftrace hooks
> for zswap_compress() might affect measured zswap_store() latencies, as
> you will have fewer zswap_compress() calls with patch 8.
>
> As advised previously, I would trim down patch 6 to the bare minimum
> (without all the scaffolding and prep work for patches 7-8), and send it
> separately (with patch 5), and we can check if it's worth adding, I am
> still concerned it might be adding overhead for order-0 to be honest.
>
> I am questioning the benefit of batching here without HW batching, so
> far the results are more concerning than encouraging. I already spent
> too much time trying to reproduce the performance gains. Also, sending
> new versions without resolving discussions on previous ones is not
> really productive.

Thanks for taking the time to test and provide feedback, Yosry.

I omitted high-level metrics like throughput since you raised a
concern about variation. Hence, I decided to go with the "ultimate
truth" which is bpftrace latency measurements.

For performance validation, I only have access to a 16G Chromebook
with a Crostini VM to which 13G is allocated. I am setting aside 3G
for swap and 7G for QEMU. Within the QEMU VM, I am selecting 2 E-cores
to run the 2 usemem processes to minimize variation due to frequency
fluctuations. This setup has its own limitations such as being unable
to fix the frequency.

Despite all this, I have been able to consistently replicate the
bpftrace latency improvements with patch 8. My results show regression
with patch 6-7, and improvement only with patch 8. As noted in the
cover-letter, patch 8 adds significant latency improvement for order-0
folios. This is with ZSTD. FWIW, these are bpftrace latency
improvements in a significantly memory constrained environment and
this ought to be a useful data point. I have been posting general
vmstat "system health" metrics to prove that nothing unexpected is
going on.

My data shows that order-0 zswap_store() tail latency improves by 11%
over mm-unstable with patch 8, although p50 is roughly similar between
patches 6-7 and 8. PMD store latency is significantly better at p50
and p99 with patch 8.

Likewise, p99 latency of zswap_compress() alone improves by 3% with
patch 8, while it degrades with patch 6-7. p50 is almost the same with
patch 8, although patch 6-7 regresses. The page-normalized
batch_compress() p99 latency is better by 15%. All comparisons are wrt
mm-unstable.

Hence, I believe even in a memory-constrained setup such as mine,
batching significantly (7-15%) improves p99 in all cases, with 4-5%
gains in p50: for order-0 and PMD folios.

In addition to the latency benefits shown through my validation, I
would like to also emphasize the strategic benefit of moving zswap to
use batching, as noted under "Conclusions" in my cover letter. IOW,
batching within large folios to improve workload metrics can only do
so much (in proportion to the # of large folios reclaimed and
contribution of zswap_store() to the overall allocation-reclaim path).
What this patch series attempts to provide is a zswap batching
framework upon which additional improvements can be built, such as
reclaiming multiple folios as a batch. I believe that compress
batching is essential to support these next steps, which improve
workload throughput/latency metrics even more than simply batching
within folios. This is with ZSTD.

Due to the environmental constraints, I haven't been able to reliably
use kernel compilation for validation.

I have been doing my best to resolve previous discussions by
incorporating the calculate_high_delay() hack that you suggested to
reduce variation. The data posted in v3 comprehends this suggestion.

I would like to suggest/request the following, as next steps:

1) Can we reconcile our methodologies for usemem bpftrace
measurements: # of vCPU, usemem command line, reading Silesia, etc.
Also swap space and QEMU memory allocation, using linear lhists() in
bpftrace, etc. If you can share these details, it would be very
helpful. Thanks again for your time!

2) Does the kernel community offer servers for contributors to test
their optimizations at scale?

3) Can I please request the help of other zswap maintainers/reviewers
to validate this series with ZSTD on a server setup with usemem
running on 30+ cores, under high over-commit ratios; through bpftrace
and/or throughput metrics.

Thanks,
Kanchana
