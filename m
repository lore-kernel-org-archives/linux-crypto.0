Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748689;
	b=dbNVlbp13xBwLC8ncwEisvqG5V/K+P69e55hhIP8isA5zuWBisR3wKc0P8qz643q9/xW
	 DSQi5a5Rp18nUrkeG2Jr2q0keTxEb4NmvQG6CtGBLg9T3/Q3zrDqNAsv5KgiTfEP3pHcv
	 VMAkDuVMB05ljNXVbUzYzx2ffniIoGfQ3u7059kToq4ltq2RYBAbsw6kpBwz0q2Uh9sKf
	 JEa0ViwiKS88yeT5GrTpjuOpul4hsfZNG4YIJFyyCoTk4k0kDdhxtftHJq0Jx/+LsBlKC
	 IapHoS0F2rdJo4a2OMt1t3fwUFWkrcmAvIDcVfxZj/ZpkhlwMuMW7xlh2KyKxIji1aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748689;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=n3jLanO4OgqFy1sW5u0s8yYdAZ3TQuUt7PYKH+zFpGE=;
	b=4X3Qjk4D9cCQyxsHCoXLkxhjVx+qb1eZqPy3VSsZotFv5rakgbHzSlS8bZGK9BGGdPyk
	 dqcmQ6uxiKUghicf/HhfTBJ6cCe0Ql38T9mXehyf8YV/UTddRRAf4vrnTrq4Ay1efk5Zq
	 e+qRZMOxLDRok6X/Xj7VuqSNjvksdJsVyJ57b0SQGcyGXAtRyKBmPFdunRitfPtPrxb43
	 QmaaEildUO6p0cYhxZOoXHU/uxgJK2uycoh/IX/7Lvz+BE7QQRdb6K/Qdmrsadz+3L7Mu
	 BDs8yCFGXu6sz5k2iGCVr3jugKtUQHgOdG2V2xP6j+RjCEEMFBKf/dK3YxrRVXFQLAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wp5WfryO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B480606A328
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 23:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wp5WfryO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D095C1F00A02;
	Tue,  3 Nov 2026 23:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793748689;
	bh=n3jLanO4OgqFy1sW5u0s8yYdAZ3TQuUt7PYKH+zFpGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wp5WfryO8ig3k7S1U3Vw7fRqA20QiL/qiwOlqdHZucegu4ngBj1hQiUAiyVlpxCr8
	 xey4Oxv4D1loeHy2btVTlnXux3E27y38VuqFAIbLQg+OeXHAhCOTNBjDybbX9EPRF4
	 i952q2TbbzeIz0YGSGaJHZ8P9T1x5o9Gwe3Hox/a2lxAS3kg9cchvJQor3ylOkoA/X
	 +HizxwvPP5QzD4XT3cMys/863qclrWmJGr5CFiRKEavVnTAvZxlkm1/p/MrqOrxGuS
	 y9g9QL8w35ztoexeT8Q3sN8MvMz/y/C5AlwkTtKdVGYzOcWHTz1UbIbosYQ7FSeBGR
	 Y0XY19PTjf71A==
Date: Tue, 3 Nov 2026 15:31:27 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Martin Willi <martin@strongswan.org>
Cc: linux-crypto@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: Re: [PATCH v2 0/3] lib/crypto: x86/chacha: Add a 16-block AVX-512
 function
Message-ID: <20261103233127.GL2281@quark>
References: <20261102113926.2765176-1-martin@strongswan.org>
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
In-Reply-To: <20261102113926.2765176-1-martin@strongswan.org>

On Mon, Nov 02, 2026 at 12:39:23PM +0100, Martin Willi wrote:
> Here is v2 of the 16-block ChaCha function for 512-bit zmm registers.
> Patch 1 renames the assembly file, patch 2 wraps the 8-block code in
> a macro, and patch 3 adds the 16-block function on top.
> 
> I previously mentioned a larger series with more AVX refactorings to
> shared macros along with a 4-block zmm variant. That needs some
> more work, so here is just the 16-block variant.
> 
> v1 used embedded broadcasts for the final ChaCha state add. This comes
> with a minor regression on older Intel chips when used in the 8-block
> variant. Therefore I kept the state words in registers in the macro
> version used by both 8/16-block variants, see patch 3.
> 
> I don't have a Zen 4, which splits zmm instructions into two 256-bit
> halves, so I can't tell how the 16-block function performs there.
> If anybody has access to one, numbers from there would be great.
> 
> Changes in v2:
>  - Rename chacha-avx512vl-x86_64.S to chacha-avx512-x86_64.S
>  - Generate the 8- and 16-block functions from a shared macro
>  - Drop the cpu_has_xfeatures() and X86_FEATURE_AVX512F checks
>  - Keep the state words in registers for the final add
>  - Benchmark with the ChaCha KUnit suite instead of tcrypt
> 
> v1: https://lore.kernel.org/linux-crypto/20260722153247.630519-1-martin@strongswan.org/
> 
> Martin Willi (3):
>   lib/crypto: x86/chacha: Rename the AVX-512VL assembly file
>   lib/crypto: x86/chacha: Wrap the 8-block AVX-512 code in a macro
>   lib/crypto: x86/chacha: Add a 16-block AVX-512 function

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

I updated the last commit message to add my results for Zen 4:

    Results on Zen 4 (specifically Genoa), which has a 256-bit datapath:
    
        Length      Before       After  Change
        ======  ==========  ==========  ======
           768   2674 MB/s   3417 MB/s  +27.8%
          1024   3241 MB/s   4514 MB/s  +39.3%
          1420   3242 MB/s   3845 MB/s  +18.6%
          2048   3587 MB/s   4829 MB/s  +34.6%
          4096   3743 MB/s   5040 MB/s  +34.7%
          8920   3606 MB/s   4846 MB/s  +34.4%
         16384   3739 MB/s   5105 MB/s  +36.5%

- Eric
