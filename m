Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795629966;
	b=XpOni08AAEx8yeqp0TI2xto1gkRW1pgGD7v+GUkzJKbBCMCGt7AeSpXKoNJa8EwmS9kz
	 Eos/vOAnzgdBygt5fuX1COrI+Yc7Jck90bzEvI8wFaWfqr/SQmw7R0/SM3/kkmB2lLFO3
	 /krCKhi/RN76L37QNhRFgkeOMPT5q0hnH3wTfVSvOwDSTd90NVpFkgb8V7pf3ZjDf22J9
	 GFFj5SQFUvIBo05VkJbnrwq82XgNI7P/BdxT58/sddy2ftTSrgmz6V1Oo1txky/9q/9QD
	 /o9pTkhO0kfDbJ1ZwpUUl+U+mZFe6APocul6jf9+SU1s3sQlslAdIfDq/6UdDQ3bE6A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629966;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=s0yGO0nle6dWsSssSP9hU9J70E3ycwEl+Dc20fwXM0A=;
	b=O/8h0u+yebCajs2sWdXFqFYwTRHvBAbq4dYIMDJackLiMhgDCdl+WXudu+7dnKKeCMzY
	 GR3RvOUCFXe9UOiiPHjOr5nMwu6DqclcGsW3mKTPq6arZZEx58FPcxpy9n/AGFpZdizeS
	 Sx9XU11aOuao46nT9XHUex18Z/gz+HDYXz3hbl2ahXcRmr+wmg4Zof1v8Y85hXphjoQUP
	 psmalZqfNcTl7J4KIRArGndVV7lvMX58PL1TJ4EXC8BO3p7TvHOSKzkJedc3qkG0P0oso
	 00M09iNWBYJ70ZfxTIiBcvYDwJUkAEgZD9lot4vZX9Q58Dl1PIv2qFWlaULHMaDsUzA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0rDEbnNB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.48
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37960606A321
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 18:06:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37960606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0rDEbnNB
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5c158c4c15fso7501203e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 10:06:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795629964; cv=none;
        d=google.com; s=arc-20260327;
        b=qRGlXAIJQK/XjG48HLqxALwpGmgmF5fmqp3PhMMVy2TbNK0mPj+1LXDlM05uHWNJTF
         +Bzyv1foohW0V7cx9JYzcBYiSmD/MhqKRBTYXnokO7lFfBYapLcfGodZmnyewp3Lfo/X
         gG2jBtvOxja2YJq8l9Jg8da5rklMTZ0cEqNpFt/tZVy1nQ8yYwdLc7K5yfctfx2f5feI
         gm9zDhn1IxGOLaQ7yjPhXpPUxG7E11Z76BbsJdBl1ZrQyVOF8ydUhi4121yGLxAwpwcj
         B+2ENITAhTHUjvEFQH+m2S4F7IpsSRHpkyvcwcssnvmFQ4wvy9qaLkKI5k9WO5g/FwUR
         YrLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s0yGO0nle6dWsSssSP9hU9J70E3ycwEl+Dc20fwXM0A=;
        fh=TVGj9MJ/XUlciusID+cRqPd3cikmwiDD61oDOrUJjl4=;
        b=LMF/WT5YmODcisHOKt2dayh5clqUsZv+vJWoXwOW9myB6lJtIpaKY3rsZqu2vmx8+k
         flJ4m/vf1nFDkoZ6NjHMTskebScSFkyjiowjWY7w47siMODS64dgNajBwqhf4/+xk3Iw
         Hdk2Bqtgahh0tKsrqm8MEeT74jgFV1SceA1nStr0VOAdaYYjFvWWyRlVUJFXyP5NYXVn
         CD+DSbq/cLYh93GrXI3Sw0OMCVKFeiBatgndvTASVE0LB0DsYUunUiSd0n2+cjT3WZ8e
         5lmPv+G1WOHgg2RwSOX97l8D58CwBeZrz8+1B2ZC31WwnhZ0JkZIGeslb8kHuNogi/bT
         Fp8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795629964; x=1796234764; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s0yGO0nle6dWsSssSP9hU9J70E3ycwEl+Dc20fwXM0A=;
        b=0rDEbnNB2GJRsgUy6lUv/ntf0plwID5UbAeFHTUjOREZCwLw7zEg/DoGYO7NP2BX5w
         RfD1UG6MXcNgcwM8335YZFlxSusZNj6H1NIersHvTvZ8zgQJP5VdPbVMO4SiogkR9ISb
         AvlhBK3iDSMbek0uLdgeXC/8u5OY8v+Oui5AfSeEVNdo6Vs+OnDhu/MSr2Nrmj7qmui2
         3ehNL9HUU8Ki1r+cz1V8u3iEcf1kLbi5CZMuCLBts9vn5UCbiTO9Ntu2M9HxXSzrrqJw
         2xE+sFwHgONnSwG8B9NeQYziQ5j2f+mN+Spc9IsGbjSz5VRlLwfo2aGSe4kIyRKspCm7
         +ZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795629964; x=1796234764;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s0yGO0nle6dWsSssSP9hU9J70E3ycwEl+Dc20fwXM0A=;
        b=TcExw9f4ClOHrl8lO0pxEHCfy3TX2t9zA+JhB+I04Fj4h+QsoDiCiCTQ8bWtENL0n9
         mtcZrFYn7hF9NJGSt1dR+RRj+LEezR3TPpy49HeBkEHFB1N/dyPrOrRoTUbEdm2M+vdU
         qpOME/W31ZRSdCY63oXvFYtcGOpzXtEoLyi0sC4qdRbsbl75qRgCnYSOnYa+2ggcoe3n
         XJ2Ym3mQJnyV0ELCO+UWOAyEmc82/DcUrC0cj6cImWkEDnC7ggoLwoMl+0H7RSrlazRo
         hqqp3Zm3YIhKMzQ40TZSHRJrKUbUr7JGGBjEOw0fOVtL4oO21fcJSRP4l+V4aYOY6Tmc
         n4FQ==
X-Forwarded-Encrypted: i=1; AL+hErFSHi7eApkdEa7drrAHn/rUX5XwLGyPl9ofr/mc4fi0rUWyaWpt3dCFqHxV8I5fkz4GOvOS3UafcTvYR6U=@vger.kernel.org
X-Gm-Message-State: APuU4Z/3vlJcfj59xa38WTDTmr9AvIGZ0ZVRKxsfab4JwHLtIz1nmy9o
	e2zP01qkMffAnqKnyZMeFGOwVf0fx9NNBQIgABDXNaCu5mc9En3Hm9gWYFzXRgoFsuVfFLtXF03
	K/QtSVAFtVRMspaFc0L3C/K9xNxDYii3Lnu5iNZ0=
X-Gm-Gg: AZFdTZfWeZDEeK77o7ncFs31j/SJkCgmcoababmQaPBihfO/YUXXPRYVogBrr8tZOJ+
	QSBO3GLJBpF8bDeIDNxm4cifq/3OJo0a1nvz1nI813jLhm7i33YehhFB5vIO2GEDgRp/fzgGLsO
	W/2uhmNnk3kWuIH0fK2e5BnrNcSHZ2dxmWzckJuMLIFdpQw9Jy14n1HnSWWU2oRpvh00EQhwNaC
	8xzz5NKJy6QLJii/HDc2Bzo1tbIf4hcVStVjOcSwK1CQ8lebGf6uH7WNvtIJGYzP92J1Shau2cl
	T5FS+/kFPR/Ng5MylEYam4z+95S2bspnJXApXsEAE6jPIYzp65mSJmaZAg/8r6u5FrSpHY3l+bq
	jhZtWoQCVhGiqFox2ImYma1NtaOisTCFHwbo8
X-Received: by 2002:a05:6512:33d1:b0:5c1:4aa3:cf96 with SMTP id
 2adb3069b0e04-5c1bc86cfdcmr4235686e87.14.1795629963996; Wed, 25 Nov 2026
 10:06:03 -0800 (PST)
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
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com> <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
 <awYsDfYqrS2ldOTw@google.com> <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
 <awZt7P_p-GNZ3A2i@google.com> <CACpmpod_87WY_PcOsNmPZvFzmJyBtCpyvvq1a_BqmZgGmO1e5A@mail.gmail.com>
 <awcK9oNDbc1QFJr6@google.com>
In-Reply-To: <awcK9oNDbc1QFJr6@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Wed, 25 Nov 2026 10:05:51 -0800
X-Gm-Features: Aa3M54rQYU3bIxvHpI5Dlfnhm6qCWUiCqJ7E9nlnUc215LhQmCibH9zYugGNAEE
Message-ID: <CACpmpoenPZ_SqhxL70r8q09WBfrnqvPu3H+F8Tz3nVwO=rvUTw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 8:31=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> [..]
> > > write_s would be calculated averaging the time in the ".. bytes / ..
> > > usecs" lines, and free_s by averaging the time from the ".. usecs to =
free
> > > memory" lines.
> > >
> > > In this run:
> > > write_s =3D 37.31 s
> > > free_s =3D 23.39 s
> > >
> > > With your patches, I got:
> > > write_s =3D 37.03 s
> > > free_s =3D 18.86 s
> >
> > I am not sure how useful it is to apply user-space gettimeofday()
> > results that time many higher level C code API, as an indicator of
> > zswap_store() performance.
>
> It is useful to see where the time is being spent, and it is consistent
> with the perf profiles.
>
> [..]
> > > You can see that the cycles spent on zswap_store() are almost the sam=
e,
> > > and the cycle reduction happens in zswap_invalidate().
> >
> > The cycles spent in zswap_store() should be normalized to the # of
> > zswpout events that these CPU cycles represent, for this to be a
> > reliable measure of latency improvement. There could be an increase in
> > reclaimed folios for any number of reasons, all of which are not
> > necessarily due to performance-improvement/degradation of
> > zswap_store() itself. IOW, more work for less latency per unit of work
> > is not always indicative of a performance degradation in this case.
> >
> > A realistic scenario would be that with zswap_store() becoming more
> > efficient, the 30 allocating threads cause more memory.high breaches,
> > that causes more zswpout..
> > This would cause more CPU cycles in zswap_store(), but the fact
> > remains that zswap_store() efficiency has improved due to batching.
>
> The zswpout number is almost identical: 45,796,107 vs 45,796,089.

Can you also share these vmstat/zswap stats for this run (baseline and
with patches):

 pswpin
 pswpout
 thp_swpout
 thp_swpout_fallback
 zswpin
 zswpout
 zswpwb
 pgmajfault
 2048kB-alloc
 2048kB-zswpout
 2048kB-swpout
 2048kB-swpout-fallback
 zswap_pool_total_size
 zswap_pool_limit_hit
 zswap_written_back_pages

Thanks.

>
> [..]
> > > > > If we want to address lock contention in zsmalloc freeing we shou=
ld address it as
> > > > > such, not by batching compression.
> > > >
> > > > Lock contention in zsmalloc seems like an independent optimization
> > > > that is good to solve. What I don't see is a way of explaining the
> > > > gains in this series based on zs_free() lock contention, and hence
> > > > drawing a questionable conclusion that this series does not optimiz=
e
> > > > zswap_store(), and further that batch compression is not attributin=
g
> > > > to the gains. I have provided ~10 reasons as to why the combined
> > > > zswap_store_pages() batching and zswap_compress() batching improves
> > > > zswap_store() performance in [2].
> > >
> > > See above. I think the performance improvement is a side effect of
> > > calling zs_store() in rapid succession for pages in the same folio, a=
nd
> > > more pages in the same folio ending up in the same zspage. As I
> > > previously mentioned, this happens because all pages in usemem end up=
 in
> > > the same size class.
> > >
> > > The right thing to do would be optimize the zs_free() path. I am look=
ing
> > > into batching zswap entries freeing, which I believe is the right pat=
h
> > > to optimize given those results.
> >
> > If I can restate what you are suggesting, and please correct me if I am=
 wrong:
> >
> > 1) [Data needed]: Normalized zswap_store() CPU cycles to # of zswpout
> > vmstat events in baseline and patched.
> >
> > 2) [Data needed]:  Normalized zs_free() CPU cycles to # of calls to zs_=
free().
> >
> > 3) If (2) confirms that zs_free() has become faster, then that is a
> > beneficial side effect of batching, per your analysis above.
>
> The number of zswap_store() and zs_free() calls is almost the same. So
> storing doesn't get faster, freeing does.
>
> > 4) Why are you suggesting that *instead* of acknowledging the
> > beneficial side-effects of zswap store/compress batching, you would
> > want to find another way to improve zs_free() latency by batching of
> > zswap entries freeing? I would imagine both need to happen. The zspage
> > locality side-effect isn't a contra-indicator to zswap compress
> > batching.
>
> 1. It is unlikely for realistic workloads to have folio where all pages
> compress to the same class.
>
> 2. Even if it happens in practice, we'd optimizing the wrong thing.
> Consecutive calls to zs_store() landing in the same zspage is an
> implementation detail of zsmalloc, and if it is something we want to
> enforce, we can do so in the correct layer (e.g. by adding per-CPU
> partial zspages like SLUB). The gains also depend on how different
> threads race, and the effect of cache locality on the specific CPU.
>
> You are basically proposing optimizing zs_free() for this scenario by
> batching zs_store() calls in hopes of landing compressed pages from a
> folio in the same zspage so that freeing gets faster. That's definitely
> not the way to do it.
>
> If the zsmalloc class lock is a bottleneck on the freeing side, we
> should address that problem directly.
>
> > I will run some experiments to quantify zswap_store() improvements
> > better, with compress batching.
>
> Feel free to, but we have been going back-and-forth on this a lot, and I
> am trying to make it clear that your time is better spent elsewhere.
