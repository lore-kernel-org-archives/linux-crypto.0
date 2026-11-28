Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795824634;
	b=lt1ZjsvpupH83mYBUVXmrSmYjD3gC8/fhIAK909DMGtQGgKpOXhX4ltC1Ltj6bSzjX+z
	 hmdqb3JN6bEH4u5R23k/PjLICu+AuOb3QxlI6wsXcr/fc79t/q+GOIQT0PZGkyhPn5yOu
	 IZwyQPl6dxJvZjq5jtpxXYTkgHELrn1QfOgmJHj+Z+emTaUxBvfV7LPkav1X6mrweRTvb
	 a/XKYGoQhdthJW7i1KtmY8rCILIpM7O7G73kn2JDmREzkfWhsJSL2CsXlWaiTbwt/eyvH
	 6NWpf4OG9dzjwtP1uPeMKHmXJbB3KTljNCCRzEG28EzIwkeg4J46u1Dw95Ya/b9k3rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795824634;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XOT2rvVH+ioKilHHf+bv68GzpR5Tw7iV4zTXyPABCMU=;
	b=nj1gDFJRSXUp+ugdlh5n/MYjoZpPfnzaubTIaDKS45JyavACqGSSPaplagEMk5Rqtj1D
	 WMDFA59XFMHoOSOKwiRzzVXqNQB0H9kc9/+huQaqPw3NoRRQB3hqlcOqeF8eIuPGwzaQu
	 mNMHNxG+8Km+jNDLSE/L0JrUqneeeSDx5E+JLTDaA6UQW2nSvr8HtFSc0y0OTnZPcLBHb
	 bLmdgS81hCW7R2HgrxH6z1dOMqrpzZ4w86kRJzAVQgHDfAAdIR40XntRMezDo7CzRw02s
	 oLTF57qh8zRtU4Q8/2UVArUWZuQ6alL51N3ptmdHd3f2LlTHsM3h1B/XEmG9C0pX2NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfxAlh0f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82300606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 00:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfxAlh0f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5451F00893;
	Sat, 28 Nov 2026 00:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795824634;
	bh=XOT2rvVH+ioKilHHf+bv68GzpR5Tw7iV4zTXyPABCMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MfxAlh0ffyMGcEW/MzjqEtgps0nbgVuVrlCxpmpTKrPoGGcIQXaIPkcjloDy3oZhc
	 BozmkGlvR0hk86M7aZkjthX03XIWEHMbuuJJbQAbyobQil+fMFHzL7v1ZzgIIElmOd
	 taMtNvwcP2PjvYg9nD3d/BZWjBRkK782/fPNmKDmyeeTivVp/qsxPkINSMuD57yDer
	 gxbAf5c0GgwF+77yrxy1202PjC2tzUj+fLuDEohju03kVBz+FC6KgwQShwbRrhSxcy
	 wdvKPVvE1HoDH0cMsYPvuJGgWIV6M2GJV3O6/Uop6P+hVY7dNWNagKJOqVNiC2MnYk
	 D17JnBViY+jgw==
Date: Fri, 27 Nov 2026 16:10:32 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Laveesh Bansal <laveeshb@laveeshbansal.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Subject: Re: [RFC] crypto: adiantum - Switch to the ChaCha library
Message-ID: <20261128001032.GA179262@quark>
References: <20261127233636.7172-1-laveeshb@laveeshbansal.com>
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
In-Reply-To: <20261127233636.7172-1-laveeshb@laveeshbansal.com>

On Fri, Nov 27, 2026 at 03:36:36PM -0800, Laveesh Bansal wrote:
> Hi Eric
> 
> In the thread for your setkey patch
> (https://lore.kernel.org/all/20261127184407.GB1974@quark/) you wrote:
> 
> > Later we should shrink the required stack space by switching
> > from crypto_skcipher to the ChaCha library.
> 
> If you have not started on this, I would like to do it as a follow-up
> once your setkey and AES library patches are applied. I have a
> prototype and would like to check the approach with you first.
> 
> It is two patches on top of yours. The first makes adiantum_setkey()
> derive the subkeys with chacha_init(), hchacha_block() and
> chacha_crypt(), so the skcipher request on the stack goes away. The
> second makes adiantum_crypt() call the library directly. It walks src
> and dst with two scatter_walks, rounds each step down to a multiple of
> 64 bytes unless it is the last, and uses a 64-byte bounce buffer for
> shorter pieces. It removes the child tfm and the spawn. The
> algorithm names stay the same.
> 
> I tested on arm64 with gcc 13.3.0 and KASAN, lockdep and
> CRYPTO_SELFTESTS enabled (and _FULL with both patches applied). Random
> cases through AF_ALG give the same ciphertext as the code with and
> without your patches. A test module with odd scatterlist splits, in
> and out of place, also passes. I saw no KASAN or lockdep reports
> and no selftest failures. The adiantum_setkey() stack frame is much
> smaller than with your patch. The adiantum_crypt() frame is larger than
> before, and the data path as a whole stays about the same depth. I have
> not tried x86_64 or s390x yet.
> 
> There is no second adiantum driver for testmgr to compare against, so
> its vectors are the only in-tree check. None of them has full ChaCha
> blocks followed by a partial one. Before the cleanup I can add a few
> that do.
> 
> Do the overall design and direction look fine to you? If so, I can
> start with the vectors and then send the cleanup patch series.

Probably.  I'd like to provide Adiantum support in lib/crypto/, but this
might be another worthwhile intermediate step.  If you want to do what
you proposed, go ahead and send the patches, making sure to include the
base-commit and prerequisite-patch-id lines so that it's clear how to
apply them.  Besides that, the pace of everything has picked up due to
AI coding tools, so I don't think I can be expected to give detailed
feedback on an AI-assisted email like this where there are no patches.
Once there are patches it will be more concrete what you mean.

- Eric
