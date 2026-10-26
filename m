Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792974912;
	b=LeCJ94OMZO6UBpxEtDvQO9VLBfFuOOOqL+TV4gvDq5RFZyLVboqPeAojrF6KRDX9BLXu
	 MtZq5VEBKgqrRRiZCL4BaD9PdbUgPp/FyrgVE+93LDMl2IZCSpNPPLjuu+XxDrdlqwZ/s
	 A3ShImvEtVob8rLXZsHQsEmUqjbn0BZjRs4Ik86OfcjJX0pSy6GA/F9IXtPWXK47O3nPK
	 9M0k2DqItY2WjWWH2OMW7bG79U5Uw0f0ZijakwwL7cYRXyqcl8O5KbTDyAddm7qyAd+eM
	 yfhNNTr8pBeFa2kEbtR5KKT/GdJ2O8p8j6oc7DzOxWztS3CjTPVzewvyWLcfYXtoKYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792974912;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xsz+D0rxREBPPKrNprIr1l+jlvD9CjCwuJ5XVICmXro=;
	b=3b/w8y6sPLwVX4BrxoINubuVnPhXmM0zwqoYLCMRve+ffbQtkC5P3CQB5dleZegMoLrT
	 XqhlWf04xzYt0uarL+miTXr0tl1ISFO/FjbZu4U46mTUixGLgvvNkMvcFj50MZOjdn38l
	 NvropaQm1FhhLqbcu0dKXouMWzzXCHSlpnbLTYI/xdCM3p5+M6b9qdYnEffZ8utehBaqh
	 A71ANFVIAA0besTP/w0svs+Zl6dtn1RlehSoWG3iQBMc1m/H3O3jOvkLIuWseFSWrq5l9
	 FXaZVm+QX2PlczB5gkP8cGdM+1HxI2njeoxJfiHY2uBiz8dCbx391ETojEt7DAE0Zkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MJbEdvfg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99278606A31A;
	Mon, 26 Oct 2026 00:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MJbEdvfg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F8D1F01825;
	Mon, 26 Oct 2026 00:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792974912;
	bh=xsz+D0rxREBPPKrNprIr1l+jlvD9CjCwuJ5XVICmXro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MJbEdvfgfr+wIBLEh1fINhAWov1u12ZlkOFomcdI6t0RZOPUEqtj4wipbZbtRCPj3
	 2TM5ba4XkYgpi5ng/L/E7hdm398leODdkJ1yuQd6NNfCZ5RsuyxxJl2+BInxu8dCr7
	 ZSdvj3gtWdFSRsLSehNM2GLxqT+vjgKg/oWAXVGxOB2m8ktDR9Ry1iMoYfs5ivypZ0
	 aXY6f+uqnGaz8kFJEvssf+Kgc+K/XPMV1aXoRvtL4voQz+XAyzZkHHQ/7K3a1REhzO
	 PY3eo9SJEcatpSpLP1e2RK4W66OPUmgJvL90kLTTKMMX0lebcXQdad5UsHmsk9HfGE
	 u4zjHwln4OXuA==
Date: Sun, 25 Oct 2026 17:35:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH 0/2] lib/crypto: x86/chacha: Add 16-block AVX-512
 implementation
Message-ID: <20261026003510.GA1843@sol>
References: <20261025234758.3219829-1-antonio@mandelbit.com>
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
In-Reply-To: <20261025234758.3219829-1-antonio@mandelbit.com>

[+Cc Martin Willi <martin@strongswan.org>]

On Mon, Oct 26, 2026 at 12:47:53AM +0100, Antonio Quartulli wrote:
> Hi all,
> 
> this series adds a 16-block ChaCha implementation for x86 using 512-bit
> registers. It is preceded by a KUnit suite and benchmark for
> chacha_crypt(), as lib/crypto has none for plain ChaCha yet.
> 
> Patch 1 stands on its own and passes with and without patch 2.
> 
> On AMD Zen 5, the new code doubles chacha_crypt() throughput for inputs
> of 1 KiB and more, from about 5.2 GB/s to about 10.2 GB/s. It came out
> of work on the OpenVPN data channel offload driver (ovpn), whose
> ChaCha20-Poly1305 throughput is CPU-bound: in a VM benchmark it gained
> about 10% at a 1500-byte MTU and 35% at 9000.
> 
> iPlease note that I could only measure Zen 5.
> The new code is not used on the CPUs setting X86_FEATURE_PREFER_YMM
> (Skylake-X, Ice Lake and Tiger Lake), but it is on
> Rocket Lake, Sapphire Rapids and later, and on Zen 4, where 512-bit
> operations are split into two halves. Numbers from any of those would be
> very welcome.

Can you clarify how your AVX-512 implementation differs from
https://lore.kernel.org/linux-crypto/20260722153247.630519-1-martin@strongswan.org/
?  See also the feedback I left on it here:
https://lore.kernel.org/linux-crypto/20260722232424.GA50619@quark/
That applies to this one too, it looks like.

Side note: "Zen 5" needs clarification.  The vector execution units
aren't as wide on the Zen 5 mobile processors as on Zen 5 desktop and
server.  Probably your numbers apply to desktop and server only.  (I've
made that mistake in the past before, but they are indeed different.)

- Eric
