Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C72210F4D;
	Wed, 28 May 2025 06:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748412884; cv=none; b=nw4ac8Egl6iFxgR5l/qUE0gFaXTQSHX9tEi2rUK3NlkwKsVmL6lJCo+zTWwGyfbT3Ab7RDd2PDkLu0sguYRs6V7hAVzfiTBnXMVYhzK8BU415aP6Coh8EnKSVGXtNVt+4Z8Xdb1w4yjfGRFhzx1AtgurYcs80CUhPI8g6vKzi50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748412884; c=relaxed/simple;
	bh=gSS4CjRAoDJno8ZPj89/BweAbZmckAAF42wPMM0GsLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g6l3qk21atcrmGnDsv/IVWYw1M74ZliTdRsbt5BEAr3qRJsd7cilGGeizMofARWGSZU7OCTqtpQeALI5ZFXsNK6El6d+ngkt6ztVFcXtH3pIZrnZpfuwpmGCzPXLwF4T7ndCnv2qK+r5ivNWafuco3ZF+n/TjEAwHnf9go36pCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aocLOYon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aocLOYon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98EFC4CEE7;
	Wed, 28 May 2025 06:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748412884;
	bh=gSS4CjRAoDJno8ZPj89/BweAbZmckAAF42wPMM0GsLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aocLOYonwxONTi12LfiZ5xjosNb3Y5gKkNrj56+v0oqn+5bxipcc7fqfKMCLUiPqJ
	 86koB/f3yH3JfJeFCzRulM0tj0iUYixZECMqlrrgJScAarzNXjZRjx0mo5Zc/ertnT
	 8tvOuu4HUmgHrE5ANkuyKODt1Qj4IM4GjN2pJu4G+2hJp898Du/mknk+BrCDACyYrY
	 cdhD6bs1tV3M5NFukEJcRQhBfTCDV7yjlZxxm8fSCmI3bDhNjtnt9hUHWF+Ioq30eW
	 2vId+gOUX4vWP7jCqmsT4NHqRao2rZzclOgIRz3z+jiai+mHbfe19EkqU5HbAMTMQm
	 xv3/SBt7Q0Rbg==
Date: Tue, 27 May 2025 23:14:27 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [linus:master] [crypto]  40b9969796:
 UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c
Message-ID: <20250528061427.GA42911@sol>
References: <202505281024.f42beaa7-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202505281024.f42beaa7-lkp@intel.com>

[+Kees and linux-hardening]

On Wed, May 28, 2025 at 01:15:05PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> by this commit, the config has below diff:
> 
> --- /pkg/linux/x86_64-randconfig-101-20250522/clang-20/d469eaed223fa485eabebd3bcd05ddd3c891f54e/.config 2025-05-23 23:44:56.781716572 +0800
> +++ /pkg/linux/x86_64-randconfig-101-20250522/clang-20/40b9969796bfa49ed1b0f7ddc254f48cb2ac6d2c/.config 2025-05-24 02:08:29.858605300 +0800
> @@ -4837,7 +4837,8 @@ CONFIG_CRYPTO_ACOMP2=y
>  CONFIG_CRYPTO_MANAGER=y
>  CONFIG_CRYPTO_MANAGER2=y
>  # CONFIG_CRYPTO_USER is not set
> -CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> +CONFIG_CRYPTO_SELFTESTS=y
> +# CONFIG_CRYPTO_MANAGER_EXTRA_TESTS is not set
>  # CONFIG_CRYPTO_NULL is not set
>  CONFIG_CRYPTO_PCRYPT=m
>  CONFIG_CRYPTO_CRYPTD=y
> 
> it seems tests are enabled then we observe the UBSAN issues
> 
> d469eaed223fa485 40b9969796bfa49ed1b0f7ddc25
> ---------------- ---------------------------
>        fail:runs  %reproduction    fail:runs
>            |             |             |
>            :6          100%           6:6     dmesg.UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c
>            :6          100%           6:6     dmesg.UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305.c
> 
> it's hard for bot to apply this commit to previous commits in bisect, so we just
> make out below report FYI that we observe UBSAN issues in boot tests.
> 
> 
> kernel test robot noticed "UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c" on:
> 
> commit: 40b9969796bfa49ed1b0f7ddc254f48cb2ac6d2c ("crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> [test failed on linux-next/master 176e917e010cb7dcc605f11d2bc33f304292482b]
> 
> in testcase: boot
> 
> config: x86_64-randconfig-101-20250522
> compiler: clang-20
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202505281024.f42beaa7-lkp@intel.com
> 
> 
> [   12.442846][    T1] ------------[ cut here ]------------
> [   12.443261][    T1] UBSAN: unsigned-integer-overflow in lib/crypto/chacha20poly1305-selftest.c:8854:47
> [   12.444084][    T1] 16 - 114 cannot be represented in type 'size_t' (aka 'unsigned long')
> [   12.444682][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Tainted: G                T   6.15.0-rc5-00342-g40b9969796bf #1 VOLUNTARY

This issue predates the blamed commit, and it's specific to
CONFIG_UBSAN_INTEGER_WRAP which was recently introduced.

CONFIG_UBSAN_INTEGER_WRAP apparently requires clang 20.

To try to reproduce this, I built clang from the release/20.x branch, then built
a kernel with CONFIG_UBSAN_INTEGER_WRAP=y.  When booting that kernel, there are
many UBSAN reports:

    [    0.000000] UBSAN: negation-overflow in lib/sort.c:199:36

    [    0.000000] UBSAN: negation-overflow in lib/sort.c:185:14

    [    0.276708] UBSAN: unsigned-integer-overflow in ./include/linux/min_heap.h:329:24

    [    0.277376] UBSAN: negation-overflow in ./include/linux/min_heap.h:260:42

    [    0.871191] UBSAN: unsigned-integer-overflow in lib/crypto/chacha20poly1305-selftest.c:8854:47

    [    0.890856] UBSAN: unsigned-integer-overflow in lib/crypto/chacha20poly1305-selftest.c:8851:47

    [    0.910455] UBSAN: unsigned-integer-overflow in lib/crypto/chacha20poly1305.c:260:57

    [    1.105542] UBSAN: unsigned-integer-overflow in lib/zstd/compress/zstd_compress_sequences.c:334:21

    [    1.113539] UBSAN: unsigned-integer-overflow in lib/zstd/compress/huf_compress.c:889:23

    [    1.114597] UBSAN: unsigned-integer-overflow in lib/lz4/lz4_compress.c:294:9

So I did get the chacha20poly1305 ones, but they're hardly unique.

If this new sanitizer is going to move forward, is there any sort of plan or
guide for how to update code to be compatible with it?  Specifically considering
common situations where unsigned wraparound (which is defined behavior in C) can
be intentionally relied on, like calculating the distance from the next N-byte
boundary.  What are the best practices now?

Documentation/dev-tools/ubsan.rst says nothing about this and only mentions
"undefined behavior", which this is not.

- Eric
