Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793313073;
	b=bQKyEewqE4nRBzhD9OjWOwlIpFfttskVFiI7qCJj/CkKvdhikNtmfqmpp1c2woYNoAzw
	 FCjxTHF99bqYQvUMuZ5YPSOZeiYidFEqxvbsy/z36oLVE01QEt523J+ncgva2qxuUD3hU
	 a7vw+pvAZPRnLF8PIcK+uu0EAvSMkaJarZj3BwezNNW8snHKZN2+255ADzir5b0O0es4d
	 ozJlWxQN4XiOHMXcOEGAv+MIOjEQ/S4rYQU9EclB3Dghls4ZUlxzpbEFZ7WahzA6j3lj/
	 Bjbgd60ZmwIJFWejPCVZfCIXHq1rz/64VxXMAkQT/xJE95eFgza+EtSc9vQB2qRkBvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793313073;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=kf6LpxrUPl6mdfAmH/zCqlYs6hvSsVYZyBZpkHm4pBA=;
	b=Mp9aU7k3EcitosCnBps0o4L+i/OFYX6ZH5GmOwE4hlyi/ZzpH0Ew553qKceqX9LnsPlf
	 b3iVETlEH7pQb1hATmRkpjAorA8GFKWx+2UnC3h6EEcxiXbEU0sU+A8OYeBD87GFxEQ5x
	 LaaF/gC9X2pfph/rqnIaOZJrFbwtXkcBkv0f25ARQErnRLseSGDFSJangsuwrdj9CgMM5
	 Pdr8fRctrQtAqJ7ck3CM9Cnmit38s9hBB+eztg9PwHSwwcAo+A0xIst5aay5Wy/7sAG7Y
	 uTcwvBxhyuscJRpGTZhHaAvzHHs/xopFTaJp59D2zhQ+AXqzoeV2jpZrsKWakvVR+RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="NWF/Ngxn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEE5606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 22:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NWF/Ngxn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5531F01828
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 22:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793313073;
	bh=kf6LpxrUPl6mdfAmH/zCqlYs6hvSsVYZyBZpkHm4pBA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NWF/NgxndhhWgfgsP0U/oEp9QD10ogeqKJmKCCc5bEnRQ4BuA2ciqvET5cGeGUKTM
	 8x1JnNppcLWVGRN9Wzn3Ydq+gjBNIBUfb3jx+nxejwPLLhxKgr2X1UlF3X+Nq0JN6M
	 3Hphuq4TmioFwEW3UcZktZnL2+txazpoFpv8S55ZP/UXBt0Ima93n2lVIkIqI3ORxU
	 exL3w/hyYkxMcu50mgIGi64UyExj+I/ztIt1nuz34TpDyaJltHiUNprZlGGFJ3rDSa
	 Qd5vDxMxnF5RpjkfLFXNvi7MVz6rN+GVTKGict+aUy6R2DzdBHUWhmDExvhSx7djgO
	 H4J9cvjGgSiIA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c45551fa84eso4841466b.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 15:31:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwSwK1nP624lS7mUNMDD2z22Ih4RGGyqOs760G+26+utkFbtkzWwcy9VXvpkbR+fb47HKPisNL5KEQ1Vig=@vger.kernel.org
X-Gm-Message-State: AFq9FYKoewTBtHfCS/C29IxhqZ9PL6yF30cKrk+dP326WFlmMuaEkYWM
	/odJiM25FHvAbYCMj2EwcvwQaF0K43RwPe9TbxaOeGccjZcv2omExiebc0wawisdnyzRY6Jsdg+
	qP8t/MF3PI1bNYbqXfqX5jo8eiCdgo08=
X-Received: by 2002:a17:907:3f95:b0:c26:1648:a06b with SMTP id
 a640c23a62f3a-c4ca7a96a37mr36969166b.38.1793313071904; Thu, 29 Oct 2026
 15:31:11 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <auOZBtRqQGzFcbAT@google.com> <CACpmpocqHHa4z9hkZ6YEm-wmzMqSX5WpPLfku7Om=NenRq_05Q@mail.gmail.com>
In-Reply-To: <CACpmpocqHHa4z9hkZ6YEm-wmzMqSX5WpPLfku7Om=NenRq_05Q@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 29 Oct 2026 15:31:00 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMukKcs8u81O6ibOXd_BzdYKM124=rVyuyp2x9+00EDvA@mail.gmail.com>
X-Gm-Features: AclHuK9Kyop58VqX76nVFd46J_fFsMna3NEZi8sYQdg_eXsf3y1c_wvVLUO30DM
Message-ID: <CAO9r8zMukKcs8u81O6ibOXd_BzdYKM124=rVyuyp2x9+00EDvA@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Batched zswap_store() framework with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"

> > As mentioned in the previous version, I cannot reproduce these results,
> > mainly because the noise is too high. Digging a bit deeper, it's because
> > the throttling from memory.high varies. Hacking in a change to make
> > calculate_high_delay() always return 0 (no memory.high stalls) paints a
> > clearer picture about throughput improvements from the series up to
> > patch 6 and patch 8. With that, I see 1-2% improvement in throughput
> > with patch 6, and almost no improvement with patch 8 on top. Similarly,
> > for zswap store latency for high-order folios, I see a slight (~1-2%)
> > improvement with patch 6, but almost none with patch 8 on top.
>
> Thanks Yosry, for sharing this. Let me also see if I can replicate
> this hack on my end, and its impact on latency.
>
> >
> > In order to make meaningful progress, can you send patches 5-6
> > separately? I assume that 1-4 are prep for 7-8, so 5-6 are standalone. I
> > also think patch 6 will be simplified if we drop the prep work for
> > patches 7-8?
>
> It shouldn't be a problem to send patches 5-6 separately, but I would
> like to measure the latency impact with the hack and confirm the
> latency results in my environment, so we can figure out a plan on how
> to proceed. Patches 5-6 alone only achieve bulk allocation of
> zswap_entries. It could be possible to bundle in patch 8, which
> generalizes the store batching framework, but let's revisit on how
> best to make meaningful progress.

I am questioning the benefit of the compression batching based on the
results I am seeing.

>
> Patches 5-6 have a dependency on the batch_size for allocating
> acomp_ctx resources, which is for the compress batching improvements
> in patch 7-8.

I assume that this code can be dropped from patch 6 if it will be sent
with patch 5 as a standalone series.
