Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792450245;
	b=trjFPDxusu85m9IAtkayPOaZoHKnuEK4qWws+bQVMACf3ssbiHCpjqnIjfoq8VwwmBRL
	 UwljBiw4yG/QcyTHVlZHbR56/dhMaJz/eBG58YaTIko6cySoZZ0bAG5SlMlgotDwmdsJU
	 sfx8ZPDSzsUbKsXVs/IAaRT3pIB9BF5wvFV4hGLvUBbhgfLThHf24ypbgftNLEI0mBHTk
	 OIbMN/B6xLOYPb2Ni2tzGxe6Zc+s9rBLDJLOp4OMuAsSC/SI3gM7lco2sTlA766ABMeLd
	 c8nwWxdtGpK6aom6BwfK3CJGeuMYJsVyk0NmV5/Tmj0YktMtcS68W9NAXxxg899tpTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792450245;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=3jYVSE8MO06CVSpnqlpUP2cyOZO8mgxxOpK+L9HkhQk=;
	b=3Vcx8PVviL+sFXbvh0qqj4MMT74L/4cg20EyvcYI1v391QWyqIRGIWjTyJM8mzJjlE+d
	 p+wbuJGh5lfWr7GebyknbQ6EhCTzKU+4P8DqN+HC+UkdhjJcZmKAqsOtQI6qu7VMd9DIR
	 xIa/2t///zizWtUYqPxFCU9vlBPOXb6ecqGvgBQO1MA2YarvoOhph2bPa5kDuydq6dL+Q
	 I2+5BpGH1B+DIezD5e+GIH85dGJ6VS8RqfcdqA5NEfclGuCqwNSq4zpB1+p0hRW0fcJX8
	 lndzVirzJLKPhf3TCtWuvhZDd36gJuobi+gzr0n5BJ1di0qh/bV3iidzeLs4mWjTTIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0tJ+dUt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA30606A319;
	Mon, 19 Oct 2026 22:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0tJ+dUt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815001F000C4;
	Mon, 19 Oct 2026 22:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792450245;
	bh=3jYVSE8MO06CVSpnqlpUP2cyOZO8mgxxOpK+L9HkhQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m0tJ+dUtmJdEOPoct6ILnIhgcQXfh7pFaKvWN9ULzvJ/tTI3TG+B8SU0FCO86X/8g
	 AZGPNxaTlYewm8jdNOm2nMvbwzN43NLujX2XZk9K5WvfDg+3M0WFGffrA4HyK2D2Nq
	 NQ9aDUs/evNbojIkRgOSp60JxeBZAwMi8Ud7UwgQM8hvBfdfxyyqSYRu+BSBmMdk7o
	 Ml0mNsXrZt2/DCVcrNlrx+e8RFNK6iq8sqC9YD4j15U7Kx09XHgbGakxjlTqP06TMs
	 TeyBnKb5b0ayoW9gIMA8VgMAPmDxckm5I1ffXozTIHHxWP8/TPt3MWEgjTsokYZip2
	 67R4cMPD6VVnA==
Date: Mon, 19 Oct 2026 22:50:43 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atadE_kZz45KAeuE@google.com>
References: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au>
 <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au>
 <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au>
 <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>

On Sun, Oct 18, 2026 at 06:35:01PM -0700, Kanchana P. Sridhar wrote:
> On Fri, Oct 16, 2026 at 10:07 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Fri, Oct 16, 2026 at 10:02:13PM -0700, Kanchana P. Sridhar wrote:
> > [ .. ]
> >
> > That isn't quite right though.  We need to ensure that it really
> > is a singleton before taking the short-cut.  So you need at
> > least one conditional:
> >
> >         if (likely(req->unit_size == req->slen))
> >                 take short-cut
> 
> I added the check for the singleton req [2]. I hope this looks Ok.
> 
> With the latest crypto_acomp_compress(), the batch compress latency
> improves considerably:
> 
> usemem 10 iterations average throughput:
> 
>    patch 6 (store batching only): 19,119 KB/s
> patch 8 (+ compress batching): 24,076 KB/s (+25.93%)

This is exactly what I mean by the numbers varying too much to draw
any conclusions. I am not sure if it's the VM setup or the usemem test
itself, but previously it was argued that the short-circuit in
crypto_acomp_compress() was ~10% faster than the one in
acomp_do_req_chain() (20,946 vs 19,058 KB/s) due to avoiding a function
call and two conditionals, and now *adding* a conditional improves
performance by 15% (20,946 -> 24,076 KB/s)?

Moreover, for zswap with ZSTD the added check is always true: the batch
size is 1, so slen == unit_size == PAGE_SIZE for every request. The
previous version and this one execute the same code, so the 15%
difference can only be noise. With the stddev you reported (~5.4k KB/s
over 10 iterations), both differences are well within the noise.

I think something is wrong with the performance testing methodology
here. The results are self-contradicting and do not make much sense to
me. Did I miss something?

> 
> bpftrace measurement of zswap compress latency per-page:
> 
> Sequential_zswap_compress  nr_samples     p25     p50      p75
> p95       p99
> =================================================================================
> zswap_compress_ns_per_page  1,722,489  43,947  57,791   88,489
> 130,165   323,961
> 
> Batched_zswap_compress     nr_samples     p25     p50      p75
> p95       p99
> =================================================================================
> zswap_compress_ns_per_page    665,267  41,511  54,915   77,707
> 124,648   213,962
> =================================================================================
>  Latency saving (ns)                   -2,435  -2,876  -10,782
> -5,517  -109,999
> =================================================================================

I measured zswap_store() (not zswap_compress()), to get the per-folio
latency, and it didn't seem to change much beyond noise in my testing. I
also notice that the number of samples is very different between cases.

