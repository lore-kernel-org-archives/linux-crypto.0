Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795377353;
	b=zheo1c3N18WZbeGhTWVNCdZtsTLpGnVxT0xn/BAm5EPJoeaELZi465TKTIm9JcsVV5SB
	 IyEIlYwJwyByje6jlBi0Jze+G/egJAnHuElqs88nkIK2CaDzkRzzbB+LwD3MKE1b7W3D8
	 36aw/Gq1P+Y12zoVB99A8AvGyFFfsIufqPyxVDxdOzeI2iGeU3B5eiCEKLet74jx5KQ4F
	 ilrYmPRKwoIIe8E+tc0EnsSQMc1w+qbqYsOJj/mOc+8y0yv7pfrUor6hRSJpTu2Wahwcw
	 UZR9YUODyabXg2R0lbrUZNJADgRPksrWvq2h6N9zFdMCOd3xuugAEmWMen5ylqorIQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795377353;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=MPMQu4BCoUDykkFbNt6vtulnjN5wBroFJlnucc4H1vw=;
	b=Xlbo16rUo9mKc4bUTSWkZ3UOR7EElqEe6aRaDVBBZ3DbDXLqgOBxSaESMrDRN9rZmWse
	 tGj+J1oRgsu/bAM9AJR1Oqo+dCyPqMOVGVld91l0tpMCcGJYZvxuHWZrdOOQ6gOQRDHlJ
	 aIVev1ktPW6neAn0U49MXNXty8oYJ1tSzvZDcKnfc5A2A7Jl4q0en9tr3Vbnn0HRuoC1Z
	 7JQZZf+1iW4S/dXoY3zAk/ZbgSB+GEobrHp8I4yx1PLseLmU3mGxDVPUTo2mOcll6wAK8
	 FW2+rGbYANrcA3+kcXC/FqmrLUZ9MNlKRHOqXp10jBMum07Bsici651DCRtiqo9JAdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jQvoOk4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A847606A31A;
	Sun, 22 Nov 2026 19:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jQvoOk4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276B61F000CA;
	Sun, 22 Nov 2026 19:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795377353;
	bh=MPMQu4BCoUDykkFbNt6vtulnjN5wBroFJlnucc4H1vw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jQvoOk4BkS2tZqIzY5OR7rn4UiQNdm7FCXsXIy5M+Kc9W4ZwRSLUjUd0OQZ0UqZ61
	 42IR6++t0oU4GrCEJlGp8q/5t9ApQkWFID01J36i4A7cMg41d0PayVAgE0aT2c5Rt6
	 2nMc0u1MoP+v9GmoAUPl0Agjq4iltxGjWmun9WIEvJ+YuIr3WjzCZZcF/6DEJD+I6z
	 VGL4/BB3lEMWnhf+oYZsIlMGy6CcmrCKq9gQSNXuWo3GQVvTSSBAfRLthcJWW66Yik
	 coYrGFamHWteT9o0H8D6OAb8nTWqPtoDDBcmt3dJBnOfbHXg07Dzjacs8U/5b4k/aQ
	 kAptKtb5eshjA==
Date: Sun, 22 Nov 2026 11:55:51 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: x86/sha2: Drop one-off implementations for
 Sandy/Ivy Bridge
Message-ID: <20261122195551.GB2122@sol>
References: <20261115080900.216434-1-ebiggers@kernel.org>
 <20261122113934.48a9ac42@pumpkin>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261122113934.48a9ac42@pumpkin>

On Sun, Nov 22, 2026 at 11:39:34AM +0000, David Laight wrote:
> On Sun, 15 Nov 2026 00:09:00 -0800
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > [ This is proposed to supersede my patch
> >   "lib/crypto: x86/sha512: Partially roll up sha512_transform_avx()"
> >   which was starting to clean up one of the files being dropped. ]
> > 
> > Currently, the kernel has SSSE3, AVX, and AVX2 implementations of each
> > of SHA-256 and SHA-512.
> > 
> > The AVX implementations of SHA-256 and SHA-512 run only on CPUs that
> > have AVX but do *not* have AVX2.  These are all the ones I could find:
> > 
> >     - Intel Sandy Bridge and Ivy Bridge
> >     - AMD Bulldozer, Piledriver, Steamroller, Jaguar, and Puma
> >     - Zhaoxin KX-5000 and KX-6000 (possibly SHA-512 only, as these CPUs
> >       might be able to run the PHE optimized SHA-256 code)
> >     - Maybe some oddly configured VMs
> > 
> > Oddly enough, this "AVX" code doesn't actually have much to do with AVX.
> > The only AVX capability it uses is support for 3-operand VEX-coded
> > instructions, which is unlikely to make a huge difference.
> 
> Especially if they are the only VEX encoded instructions.
> Switching back and forth is horribly expensive and the change isn't
> 'sticky' on some later Intel cpu and you get the 'hit' for every
> instruction.
> (kernel_fpu_begin() might need a vzeroupper to migitage this.)
> 
> > 
> > Its actual purpose is mostly unrelated to AVX: it replaces the 'ror'
> > instruction with 'shld'.  This is entirely to work around a quirk
> > specific to Sandy Bridge and Ivy Bridge where the 'ror' instruction was
> > very slow for microarchitectural reasons, and 'shld' worked better.
> > 
> > This is documented in the contemporaneous paper "Speeding up SHA-1,
> > SHA-256 and SHA-512 on the 2nd Generation Intel Core Processors"
> > (https://ieeexplore.ieee.org/document/6209073).  There, the 'shld'
> > workaround was claimed to speed up SHA-256 and SHA-512 by about 20% on
> > Sandy Bridge.
> > 
> > However, that was a one-off quirk.  And even the paper itself warns
> > about using the 'shld' approach on other microarchitectures.
> > 
> > On AMD CPUs, and on Intel CPUs after Sandy and Ivy Bridge, the exact
> > opposite applies: ror is a fast single-cycle and single µop instruction,
> > while shld is either a slow microcoded or multi-µop instruction.
> > 
> > From what I can find, this is true even on the older AMD CPUs mentioned
> > above that run this code.  Thus this code has likely always been harmful
> > on AMD.  (I don't have such a CPU available to test, but for what it's
> > worth, on Zen 5 the AVX SHA-512 code is 58% as fast as the SSSE3 code.
> > Clearly, the 'shld' hack can be quite slow on CPUs it wasn't meant for.)
> 
> I've got a bulldozer (or similar) I can run a test on.
> I might just to a quick one for shld v ror.
> I've rewritten my 'rep movs/stos' benchmark and plan to run it on the
> older cpu I have.
> (I need to get something newer than an i7-7 and older than a zen5.)

Thanks.  If you do want to benchmark it, you can use sha512_kunit with
CONFIG_CRYPTO_LIB_BENCHMARK=y enabled.

After that, you could also check the performance with the
sha512-ssse3-asm.S optimization patchset applied on top of it
(https://lore.kernel.org/linux-crypto/20261122022030.296468-1-ebiggers@kernel.org/)

My prediction is that performance on Bulldozer goes up slightly when
sha512-avx-asm.S is removed (due to sha512-ssse3-asm.S being faster),
then up slightly more due to the sha512-ssse3-asm.S optimizations.

(Of course, even if the results are more mixed, both patches seem like
the clear way to go anyway for other reasons: reducing the code size,
deleting an entire asm file that we'll no longer have to maintain,
eliminating the huge on-stack buffer that was never cleared, etc...)

- Eric
