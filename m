Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795290710;
	b=IvjTGZyTqsGTG+GQkbFqIaHHVPMmRV3gPie3NFCl9+FFjj3VbuUrrufKaRa4zJFvkZMq
	 Iatmp6a1TkZ/Uo0AJvhtmHXu9EykbQugz13J9DTW7mJBOx9l8KFEgPGjl8+5mwos/Nbf5
	 hutzLc8uJgEoct0wqNS/Ev+pNcUPnDp0i4ZvFQtQc000zgHws3tpzF2NiJ3dwkEMeG3Ih
	 AIx0rh1LCape4fNCOK2QAkyu+Wz3mnCGkozLXp/57a5pd39NAikE/FHMp6V1X1NPl+CPj
	 xsvLJ6zbxTAsShGScB1YY+4EG2Z/Il6naDrd8pymGxRkop+YUJ1NLtb7KbA5zIpDueg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795290710;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=GkqXyfKbYKFXj8J+3KPieMCEQRRKt19JWVxhhibgDIM=;
	b=SbL7aKxNWOAVUO+Y0bmbtZZFSW3WYfnNKUVoAOpbmIdpEpvgUvh39SXDb/06MEwzW2y8
	 eFx2VJyRd9Yo7W8pJViz62PBIAje//4e5KsF3uzPBf4c3PieliAgaV0Du44tacUiRXPeV
	 hoZ/Tt9uPvhgNH1B9Z+OmSkJWGg7qlYQM6Tywa5AIQV+Q4+AZimp8auILptiorV3gx9D6
	 rWRqfuCaKkMSCH7GqiqPIysfcKKAzAD3nfobJtiPWxr5PNORbigjECAI0zu92DuKQQFf8
	 NYM47zI86/jyt0lfGrouUu259AbJddbw0hRqJiUjM8a8Ao2yMHQATpuLhoIHyC73SVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AvyzFRea;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C87606A320;
	Sat, 21 Nov 2026 19:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AvyzFRea
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F411F000C0;
	Sat, 21 Nov 2026 19:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290710;
	bh=GkqXyfKbYKFXj8J+3KPieMCEQRRKt19JWVxhhibgDIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AvyzFReaeN9EfkHxN8epdHdZ5zSDOQIZjHmt0/xbb7llGgSixYgiyXcrD6tPiA1l9
	 tNo9D7MaoEewNe0emO4Dl3Fp8rGBQ4iWhts2A5FD+t7A18MxbmSmAgjudb4hjVHEmm
	 2s9xg9ERrdcPYjb5ZKDKx/zpYw2Qu7c77qsYI3QFKV0qRlaMiJBBw0CqOW3K3h5Bdn
	 CvXEA66aGZhYvEm6qr040cu0plgra6Hr+pFiK7DgD+MghlGkFuusQsjyvYAPd1IBf6
	 cvJW88B/eT9xlhYdIZLOH4wuxsBO/xPox19OUxjaOxy4WIBpPac24CECXCxmf/Gzsj
	 MUBaCbrUpHF+Q==
Date: Sat, 21 Nov 2026 11:51:48 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: x86/sha2: Drop one-off implementations for
 Sandy/Ivy Bridge
Message-ID: <20261121195148.GC1975@quark>
References: <20261115080900.216434-1-ebiggers@kernel.org>
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
In-Reply-To: <20261115080900.216434-1-ebiggers@kernel.org>

On Sun, Nov 15, 2026 at 12:09:00AM -0800, Eric Biggers wrote:
> [ This is proposed to supersede my patch
>   "lib/crypto: x86/sha512: Partially roll up sha512_transform_avx()"
>   which was starting to clean up one of the files being dropped. ]
> 
> Currently, the kernel has SSSE3, AVX, and AVX2 implementations of each
> of SHA-256 and SHA-512.
> 
> The AVX implementations of SHA-256 and SHA-512 run only on CPUs that
> have AVX but do *not* have AVX2.  These are all the ones I could find:
> 
>     - Intel Sandy Bridge and Ivy Bridge
>     - AMD Bulldozer, Piledriver, Steamroller, Jaguar, and Puma
>     - Zhaoxin KX-5000 and KX-6000 (possibly SHA-512 only, as these CPUs
>       might be able to run the PHE optimized SHA-256 code)
>     - Maybe some oddly configured VMs
> 
> Oddly enough, this "AVX" code doesn't actually have much to do with AVX.
> The only AVX capability it uses is support for 3-operand VEX-coded
> instructions, which is unlikely to make a huge difference.
> 
> Its actual purpose is mostly unrelated to AVX: it replaces the 'ror'
> instruction with 'shld'.  This is entirely to work around a quirk
> specific to Sandy Bridge and Ivy Bridge where the 'ror' instruction was
> very slow for microarchitectural reasons, and 'shld' worked better.
> 
> This is documented in the contemporaneous paper "Speeding up SHA-1,
> SHA-256 and SHA-512 on the 2nd Generation Intel Core Processors"
> (https://ieeexplore.ieee.org/document/6209073).  There, the 'shld'
> workaround was claimed to speed up SHA-256 and SHA-512 by about 20% on
> Sandy Bridge.
> 
> However, that was a one-off quirk.  And even the paper itself warns
> about using the 'shld' approach on other microarchitectures.
> 
> On AMD CPUs, and on Intel CPUs after Sandy and Ivy Bridge, the exact
> opposite applies: ror is a fast single-cycle and single µop instruction,
> while shld is either a slow microcoded or multi-µop instruction.
> 
> From what I can find, this is true even on the older AMD CPUs mentioned
> above that run this code.  Thus this code has likely always been harmful
> on AMD.  (I don't have such a CPU available to test, but for what it's
> worth, on Zen 5 the AVX SHA-512 code is 58% as fast as the SSSE3 code.
> Clearly, the 'shld' hack can be quite slow on CPUs it wasn't meant for.)
> 
> We generally shouldn't be carrying asm files that are one-offs for
> single microarchitectures, as it's just not worth it.  This is
> especially true when the code has been mistakenly targeted to other CPUs
> on which it is likely harmful, and when it has other issues that would
> require maintenance, such as excessive loop unrolling and spilling the
> entire 640-byte SHA-512 message schedule to the stack.  (The SSSE3 code
> has the same issues, but it's easier to fix it in one place.)
> 
> Therefore, let's drop sha256-avx-asm.S and sha512-avx-asm.S.
> 
> The CPUs that could have run this code will instead run
> sha256-ssse3-asm.S and sha512-ssse3-asm.S.  SHA-256 and SHA-512 may get
> around 20% slower on Sandy and Ivy Bridge, but they likely get
> significantly faster on AMD CPUs from around the same time (2011-2014).
> 
> Everything with AVX2 continues to run the newer code and is entirely
> unaffected by this cleanup.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/Makefile             |   2 -
>  lib/crypto/x86/sha256-avx-asm.S | 493 --------------------------------
>  lib/crypto/x86/sha256.h         |  12 +-
>  lib/crypto/x86/sha512-avx-asm.S | 421 ---------------------------
>  lib/crypto/x86/sha512.h         |  14 +-
>  5 files changed, 6 insertions(+), 936 deletions(-)
>  delete mode 100644 lib/crypto/x86/sha256-avx-asm.S
>  delete mode 100644 lib/crypto/x86/sha512-avx-asm.S

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

Acks appreciated, but I think this is very well justified.

- Eric
