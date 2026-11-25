Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624315;
	b=rA2r/hlSQmYonephd7AlY2UfeML/wpN+D/M6u+f2kVgl6NhU1HNaVP3RNSA9//O9PKhA
	 83r+oO0eNCK93WcxzIHY6lce75h61DaihieKiaWEpDvl4/bpNZN9M8furUgAz6ZyuIGdY
	 3dkIEP+mFkzs1toZjW5IG7tLcCHx/cAmwEbYLksFS2UbFWbXbpgCpNVZASnlp7+xtc6dE
	 FsYd6XB5ka1yPwg1B42YdukHVW1G1pmH3YDV/y5FawrXujivG55W9n5GnncMC9sbDj5S4
	 JjqnQLmTbkldd32oCRCnPhUl4BA+Yd/UNyzPGgVTw7/nObkwcxNyq25hTT2Jlk/TfzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624315;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kYj2Xxi2t6rEOEW9AEQRhf9Q5ZB4wLf+bcqG0Uy1bcY=;
	b=YT6dXzzX4SG5XhOb7FHIlh7QOh8068ERDlInaAdVGBBJCXV6HHfwbsuK1jJy3yXrE19D
	 mCbwoEJHmobWzz+i1hwq52JSJMRHtm0Aunym2xBk3t2hbyK3KdqlUsrwvlLaYdRaSSSLE
	 wZcoSys8iPr1zQ4qKwKx9lBuF4C+XPc8VcOdH29krs2xlNjvwtoIGPkWqJJ4gp6WaqMb5
	 pI6LO1Fi7eRvd0rf8kgIdpVKPO9SwAlkL5u9kBeiGZlbLM4RA/D8YQc482pqYQlqZ8ND4
	 yEX1aljmMhinK+X8E0uXGmzSb5MeJ4HHV0+5ky4aZ+HmHAB1DtG2CqfFDRd6TFPtmaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UwsoFC6G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC1E606A33A;
	Wed, 25 Nov 2026 16:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UwsoFC6G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D4F1F000C4;
	Wed, 25 Nov 2026 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795624315;
	bh=kYj2Xxi2t6rEOEW9AEQRhf9Q5ZB4wLf+bcqG0Uy1bcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UwsoFC6GUk6xmqNyiFsiWG5CS43wb19dTAzEGOVwsIQXV9Es1/Eqjx2EfP4fkWo0k
	 EyZiRiW0SLvsTXdEKJYFp30+UseXNsFGz1uTSQk9+dO8C2Nbo5nxBW7HsjkCWmdRsD
	 0poUolRdSnNBhWyW7VdQ9MVonkxfKP4vy4uFUO/iuF3VDT7N+FiV5fpcxjs+Ujdo1n
	 LnGdPqzX4+TvYEQY9nHXD2op9pxnLxOzuH5s4re+tLWEGo+0guYV9N4tYvsZZfXXod
	 usHl3/EQiP76XMzlO4zhqvkbgb+oHgbI3AXftbxnE6BJ0+u0lVhtMOr/SWw4ybZYDh
	 7yCIV6iE2oFHQ==
Date: Wed, 25 Nov 2026 16:31:53 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression
 batching
Message-ID: <awcK9oNDbc1QFJr6@google.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com>
 <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
 <awYsDfYqrS2ldOTw@google.com>
 <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
 <awZt7P_p-GNZ3A2i@google.com>
 <CACpmpod_87WY_PcOsNmPZvFzmJyBtCpyvvq1a_BqmZgGmO1e5A@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpod_87WY_PcOsNmPZvFzmJyBtCpyvvq1a_BqmZgGmO1e5A@mail.gmail.com>

[..]
> > write_s would be calculated averaging the time in the ".. bytes / ..
> > usecs" lines, and free_s by averaging the time from the ".. usecs to free
> > memory" lines.
> >
> > In this run:
> > write_s = 37.31 s
> > free_s = 23.39 s
> >
> > With your patches, I got:
> > write_s = 37.03 s
> > free_s = 18.86 s
> 
> I am not sure how useful it is to apply user-space gettimeofday()
> results that time many higher level C code API, as an indicator of
> zswap_store() performance.

It is useful to see where the time is being spent, and it is consistent
with the perf profiles.

[..]
> > You can see that the cycles spent on zswap_store() are almost the same,
> > and the cycle reduction happens in zswap_invalidate().
> 
> The cycles spent in zswap_store() should be normalized to the # of
> zswpout events that these CPU cycles represent, for this to be a
> reliable measure of latency improvement. There could be an increase in
> reclaimed folios for any number of reasons, all of which are not
> necessarily due to performance-improvement/degradation of
> zswap_store() itself. IOW, more work for less latency per unit of work
> is not always indicative of a performance degradation in this case.
> 
> A realistic scenario would be that with zswap_store() becoming more
> efficient, the 30 allocating threads cause more memory.high breaches,
> that causes more zswpout..
> This would cause more CPU cycles in zswap_store(), but the fact
> remains that zswap_store() efficiency has improved due to batching.

The zswpout number is almost identical: 45,796,107 vs 45,796,089.

[..]
> > > > If we want to address lock contention in zsmalloc freeing we should address it as
> > > > such, not by batching compression.
> > >
> > > Lock contention in zsmalloc seems like an independent optimization
> > > that is good to solve. What I don't see is a way of explaining the
> > > gains in this series based on zs_free() lock contention, and hence
> > > drawing a questionable conclusion that this series does not optimize
> > > zswap_store(), and further that batch compression is not attributing
> > > to the gains. I have provided ~10 reasons as to why the combined
> > > zswap_store_pages() batching and zswap_compress() batching improves
> > > zswap_store() performance in [2].
> >
> > See above. I think the performance improvement is a side effect of
> > calling zs_store() in rapid succession for pages in the same folio, and
> > more pages in the same folio ending up in the same zspage. As I
> > previously mentioned, this happens because all pages in usemem end up in
> > the same size class.
> >
> > The right thing to do would be optimize the zs_free() path. I am looking
> > into batching zswap entries freeing, which I believe is the right path
> > to optimize given those results.
> 
> If I can restate what you are suggesting, and please correct me if I am wrong:
> 
> 1) [Data needed]: Normalized zswap_store() CPU cycles to # of zswpout
> vmstat events in baseline and patched.
> 
> 2) [Data needed]:  Normalized zs_free() CPU cycles to # of calls to zs_free().
> 
> 3) If (2) confirms that zs_free() has become faster, then that is a
> beneficial side effect of batching, per your analysis above.

The number of zswap_store() and zs_free() calls is almost the same. So
storing doesn't get faster, freeing does.

> 4) Why are you suggesting that *instead* of acknowledging the
> beneficial side-effects of zswap store/compress batching, you would
> want to find another way to improve zs_free() latency by batching of
> zswap entries freeing? I would imagine both need to happen. The zspage
> locality side-effect isn't a contra-indicator to zswap compress
> batching.

1. It is unlikely for realistic workloads to have folio where all pages
compress to the same class.

2. Even if it happens in practice, we'd optimizing the wrong thing.
Consecutive calls to zs_store() landing in the same zspage is an
implementation detail of zsmalloc, and if it is something we want to
enforce, we can do so in the correct layer (e.g. by adding per-CPU
partial zspages like SLUB). The gains also depend on how different
threads race, and the effect of cache locality on the specific CPU.

You are basically proposing optimizing zs_free() for this scenario by
batching zs_store() calls in hopes of landing compressed pages from a
folio in the same zspage so that freeing gets faster. That's definitely
not the way to do it.

If the zsmalloc class lock is a bottleneck on the freeing side, we
should address that problem directly.

> I will run some experiments to quantify zswap_store() improvements
> better, with compress batching.

Feel free to, but we have been going back-and-forth on this a lot, and I
am trying to make it clear that your time is better spent elsewhere.
