Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676452C0296;
	Sun,  5 Jul 2026 05:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783229580; cv=none; b=lhm5G2E2ygnYCmbDlEvcTw1v5JfWGN9fKYOkFWV6UGFlqjvC+8HILhJhV6tPX15ckfz9p0oD2DkwgEQKI1hw0o+ZZK+iVwHd5/RjuPlYRtvcC8HhVvG19yxSzkXdKdLB93TCfomr8t4SoW3v+Jy0m0w/OJ9A/v1WCVgcos4Tca4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783229580; c=relaxed/simple;
	bh=oJxxBrOOz20JnxSl/i2qzeEbn+wESCr6l0i68SMVjhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5bJcaRAaKPDtQfZdcWXQL/ckFYPnbOsiLj6fo09jaVwUEKTXMlX1q9BLuVPmNfbgmssM4cVo2I81zdT32u8NqfsogL36y96drB7LyDPHrsPMDUwBoH6NlEDPSUA2XqADEXq8dHi9cdL1emu5hLnTVdvuC1H9JSurfTYg51pfo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FL6rZAZ6; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FL6rZAZ6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=TlJbmYWZgXG8qApCvGeXLUE0weI82tXOrKLjBUIdkM8=; 
	b=FL6rZAZ67F8C0H7rMLO0T1t3Q3hlVjchOLPYsgpTHkWAqoABX4Do6zGv4WM3djfio/sQhcEmN98
	HcejAt9Mk21+8aAG5Tzpcp28ni/HyIvbTQ0uEKy7RbJ3iROYW8jEfI/N/rYtk4xwaisnyr6t927uW
	A/yG0pGcFjTlotqf+rQIooOpCH4dl2FEPZZrThkOEBcmFMmQ/i0gpjqkf7yqIq9Wfuq/hi/vZDJVy
	Byzs8nN6ZoyWxjsY6AwqU/dQ2LBLShnZgjUT6BroklnpSVuvi4R9xRrUwVfhROmgnJN0PknYKtJAj
	J/Vhkx7oijsqWVSK8nrGvcowqCz8qYL0/NVA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgFTG-0000000Ajfe-3NsC;
	Sun, 05 Jul 2026 13:32:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 13:32:50 +0800
Date: Sun, 5 Jul 2026 13:32:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Fabian Blatter <fabianblatter09@gmail.com>
Cc: lukas@wunner.de, ignat@linux.win, davem@davemloft.net,
	stefanb@linux.ibm.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecc - Optimize vli additive operations using
 compiler builtins
Message-ID: <aknsgpnZsjmLtcT_@gondor.apana.org.au>
References: <20260607112435.42804-1-fabianblatter09@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260607112435.42804-1-fabianblatter09@gmail.com>

On Sun, Jun 07, 2026 at 01:24:35PM +0200, Fabian Blatter wrote:
> Replace the software carry flag emulation with compiler builtins.
> 
> Even the newest compilers struggle with taking advantage of the
> hardware carry flag. Compiler builtins allow the compiler to
> much more easily achieve this while still remaining constant-time.
> 
> This yields an approximately 6-7% performance improvement
> on the ecc_gen_privkey, ecc_make_pub_key and crypto_ecdh_shared_secret
> functions on x86_64 on all curve sizes.
> 
> Additionally, the code becomes much more readable.
> 
> Signed-off-by: Fabian Blatter <fabianblatter09@gmail.com>
> ---
> 
> Hi,
> 
> I'd like to expand on the benchmarks, compare the generated assembly,
> and clarify some things.
> 
> 
> Use of compiler builtins:
> 
> This patch uses __builtin_addcll, __builtin_subcll when available and
> otherwise __builtin_uaddll_overflow, __builtin_usubll_overflow. the
> latter have existed since ancient gcc versions, so no third fallback
> is needed.
> 
> I have put the add_carry and sub_borrow inline functions with the
> preprocessor logic for builtin selection directly in crypto/ecc.c.
> Please let me know if you would like them to be somewhere else.
> 
> They do not emit data-dependent branches, and so remain constant-time.
> 
> 
> Benchmarks:
> 
> All benchmarks were run single-threaded on my AMD 7700X CPU limited to
> 5.6Ghz. I have measured both nanoseconds and clock cycles, since their
> combination can hint at downclocking issues and allows calculation of
> the clock speed during the benchmark.
> 
> I have omitted the raw output from the benchmarking code, as they much
> exceed the 72 character limit.
> 
> I have calculated the percent differences, included clock speed
> calculations and relevant summaries.
> 
> 
> Macro benchmarks:
> 
> These were run in a virtualized environment using virtme-ng on the
> compiled linux kernel image compiled with default flags.
> 
> (the first value is the original time per operation, the second the
> patched one. cc is short for clock cycles)
> 
> Curve keypair generation (ecc_gen_privkey + ecc_make_pub_key):
> 
> P256:
>  - 646963ns/op -> 600632ns/op = -7.71%
>  - 2911300cc/op -> 2702854cc/op = -7.71%
>  - 4.4999Ghz -> 4.5000Ghz = no difference
> 
> P384:
>  - 1239160ns/op -> 1153940ns/op = -7.38%
>  - 5576250cc/op -> 5192749cc/op = -7.38%
>  - 4.5000Ghz -> 4.5000Ghz = no difference
> 
> Shared secret generation (crypto_ecdh_shared_secret):
> 
> P256:
>  - 320114ns/op -> 297548ns/op = -7.58%
>  - 1440521cc/op -> 1338972cc/op = -7.58%
>  - 4.5000Ghz -> 4.5000Ghz = no difference
> 
> P384:
>  - 620768ns/op -> 582560ns/op = -6.55%
>  - 2793467cc/op -> 2621529cc/op = -6.55%
>  - 4.5000Ghz -> 4.5000Ghz = no difference
> 
> The benchmarks clearly indicate a roughly 6-7% performance increase on
> the public API functions. It also appears that virtme-ng limited the
> clock speed to 4.5Ghz
> 
> 
> Micro benchmarks:
> 
> Since the vli additive functions only rely on u64 being defined, these
> were run without virtualization and with varying compilers and
> compiler flags.
> 
> The microbenchmarks show much more mixed results, depending
> heavily on the compiler and optimization level used.
> 
> For instance, on gcc and O2, the vli_add present in the
> patch is actually 25.3% slower than the original one. I have tracked
> this down to gcc using a weird way to restore the carry flag after
> each iteration, causing way more dependent instructions, preventing
> ILP from executing multiple at once.
> 
> This is quite interesting, since, as far as I know, the kernel compiles
> with gcc and O2 by default, yet the macro-level benchmarks still show a
> performance increase. The effect seems to be reversed when crypto/ecc.c
> gets compiled. Or maybe the linux kernel uses some additional
> optimization flags, I am unsure.
> 
> However, most of the time, the patched version outperforms the original
> one by a wide margin:
>  - On clang -O2 or -O3, vli_add and vli_uadd show a 4.074x and 5.384x
>    speedup.
>  - On gcc, vli_uadd shows a 74% performance increase at O2, 
>    and a 2.07x speedup at O3.
> 
> The performance profile of vli_sub and vli_usub is almost identical to
> that of vli_add and vli_uadd.
> 
> 
> Assembly comparison:
> 
> I have put together a piece of code on Compiler explorer, to make sure
> it compiles on old gcc versions, view instructions and play around with
> compiler settings.
> 
> If you would like, you can play around yourself here:
> https://godbolt.org/z/1jT5zesz8
> 
> When using clang 22.1 at -O3 -march=lunarlake, the difference between
> the patched and original version is particularly clear. The patched
> version produces this assembly in the unrolled vli_add loop:
> 
> mov     rax, qword ptr [rsi + 8*rcx + 16]
> adc     rax, qword ptr [rdx + 8*rcx + 16]
> mov     qword ptr [rdi + 8*rcx + 16], rax
> mov     rax, qword ptr [rsi + 8*rcx + 24]
> adc     rax, qword ptr [rdx + 8*rcx + 24]
> mov     qword ptr [rdi + 8*rcx + 24], rax
> mov     rax, qword ptr [rsi + 8*rcx + 32]
> adc     rax, qword ptr [rdx + 8*rcx + 32]
> mov     qword ptr [rdi + 8*rcx + 32], rax
> mov     rax, qword ptr [rsi + 8*rcx + 40]
> adc     rax, qword ptr [rdx + 8*rcx + 40]
> mov     qword ptr [rdi + 8*rcx + 40], rax
> mov     rax, qword ptr [rsi + 8*rcx + 48]
> adc     rax, qword ptr [rdx + 8*rcx + 48]
> 
> This is basically optimal for an inner loop. It's pure adc and mov
> instructions. The loop counting part is still nowhere near perfect,
> and still uses setc instructions. But it is still better than what
> the original version produces with the same compiler and flags:
> 
> mov     r10, qword ptr [rsi + 8*rcx]
> lea     r11, [r10 + rax]
> add     r11, qword ptr [rdx + 8*rcx]
> xor     ebx, ebx
> cmp     r11, r10
> setb    bl
> cmove   rbx, rax
> mov     qword ptr [rdi + 8*rcx], r11
> mov     rax, qword ptr [rsi + 8*rcx + 8]
> lea     r10, [rax + rbx]
> add     r10, qword ptr [rdx + 8*rcx + 8]
> xor     r11d, r11d
> cmp     r10, rax
> setb    r11b
> cmove   r11, rbx
> mov     qword ptr [rdi + 8*rcx + 8], r10
> mov     rax, qword ptr [rsi + 8*rcx + 16]
> lea     r10, [rax + r11]
> add     r10, qword ptr [rdx + 8*rcx + 16]
> xor     ebx, ebx
> cmp     r10, rax
> setb    bl
> cmove   rbx, r11
> mov     qword ptr [rdi + 8*rcx + 16], r10
> mov     rax, qword ptr [rsi + 8*rcx + 24]
> lea     r10, [rax + rbx]
> add     r10, qword ptr [rdx + 8*rcx + 24]
> xor     r11d, r11d
> cmp     r10, rax
> setb    r11b
> cmove   r11, rbx
> 
> This is downright horrendous. that entire block of processes only 4
> limbs, thats 8 instructions per limb! The add instructions
> are also not adc instructions, showing that the carry flag is
> being fully emulated. This demonstrates how even on the newest
> compilers and at the highest optimization level, still cannot
> generate hardware carry chains without explicit use of builtins.
> 
> I should note that not just clang 22.1.0 with -O3 -march=lunarlake
> does this. Gcc and clang show this behaviour on every version i have
> tested, regardless of target architecture.
> 
> I am not very familiar with ARM or RISC-V assembly, but looking at
> compiler explorer, the effect clearly persists, and in the case of
> RISC-V actually gets much worse.
> 
> This affects all architectures across all compilers and compiler
> flags.
> 
> 
> If you have gotten this far, thank you for reading this and I am looking
> forward to any feedback! If you would like any changes to this patch,
> I am very happy to send a v2.
> 
>  crypto/ecc.c | 98 ++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 60 insertions(+), 38 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
