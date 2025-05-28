Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE51419D07A;
	Wed, 28 May 2025 16:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748450760; cv=none; b=cqXpEly05r+pREimyrp69ErLAWV+sSZ44oTlC0N21W/TFmhP6/piRgukFjEbCWlyhggXE/unUWOcC9AwysyIfzC2Djel9+Wx4PhH/+2LXtINz/M12eG1y92uZTX0q7+6N+NbiT5GHRSIeXEwutMBD2Dfj9ThYsIQnvWG5UCxEmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748450760; c=relaxed/simple;
	bh=ZzP3dZbIvqBIvFOURta05rer0syVpr9AYK8L5vT3Cwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4M64C11vrr8lkF/epF81v2cF2jjJlNkGBZICi4bbhK5LqqAjiwRSJ1z5iRX2C1FzhJtEwJR5gIFahsIx7mj8W5o1ppzcW47hBChlvrOdpKl+GZ5r9Wbt5PcRcb58O9zq8Z8FHWsnVu9EvAl2fRskkWYE/fwSQVQxtqDDYyv7io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVXzyTZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVXzyTZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4561BC4CEE3;
	Wed, 28 May 2025 16:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748450759;
	bh=ZzP3dZbIvqBIvFOURta05rer0syVpr9AYK8L5vT3Cwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LVXzyTZMwmjueFCXAoq3KZlHkwl9jf4A8JjFcq88dAM8hfAUvmtIJwb4Bxl1ws/Tr
	 ApiRG/VITi515B6Pd224PL11E1tw2OcX/bfPd9uyszUuCLjVdgABdingNaaqyC7mzp
	 zIF8RYFthHLqWDi0F8kgcOQGCEuFDmi74VyHJq4TwH3+1LZ9YFgH+QGTaJqYd6q0el
	 qWnBQpBmvMyzupU04McJocy6KvMvfgj9+u3CCT9Io12x+Eg2mBF88vXa+v2YwWoPti
	 bnkKh0jPV2DP3SpwsBor/BcnjC4nejO+DYEbJIIIS9yKBw543336xSXo+fmxCKwpFg
	 lpXE8h/tMxsPg==
Date: Wed, 28 May 2025 09:45:55 -0700
From: Kees Cook <kees@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>,
	Justin Stitt <justinstitt@google.com>
Cc: linux-hardening@vger.kernel.org, oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, llvm@lists.linux.dev
Subject: Re: [linus:master] [crypto]  40b9969796:
 UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c
Message-ID: <202505280937.6802F0F210@keescook>
References: <202505281024.f42beaa7-lkp@intel.com>
 <20250528061427.GA42911@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250528061427.GA42911@sol>

On Tue, May 27, 2025 at 11:14:27PM -0700, Eric Biggers wrote:
> [+Kees and linux-hardening]
> 
> On Wed, May 28, 2025 at 01:15:05PM +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > by this commit, the config has below diff:
> > 
> > --- /pkg/linux/x86_64-randconfig-101-20250522/clang-20/d469eaed223fa485eabebd3bcd05ddd3c891f54e/.config 2025-05-23 23:44:56.781716572 +0800
> > +++ /pkg/linux/x86_64-randconfig-101-20250522/clang-20/40b9969796bfa49ed1b0f7ddc254f48cb2ac6d2c/.config 2025-05-24 02:08:29.858605300 +0800
> > @@ -4837,7 +4837,8 @@ CONFIG_CRYPTO_ACOMP2=y
> >  CONFIG_CRYPTO_MANAGER=y
> >  CONFIG_CRYPTO_MANAGER2=y
> >  # CONFIG_CRYPTO_USER is not set
> > -CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> > +CONFIG_CRYPTO_SELFTESTS=y
> > +# CONFIG_CRYPTO_MANAGER_EXTRA_TESTS is not set
> >  # CONFIG_CRYPTO_NULL is not set
> >  CONFIG_CRYPTO_PCRYPT=m
> >  CONFIG_CRYPTO_CRYPTD=y
> > 
> > it seems tests are enabled then we observe the UBSAN issues
> > 
> > d469eaed223fa485 40b9969796bfa49ed1b0f7ddc25
> > ---------------- ---------------------------
> >        fail:runs  %reproduction    fail:runs
> >            |             |             |
> >            :6          100%           6:6     dmesg.UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c
> >            :6          100%           6:6     dmesg.UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305.c
> > 
> > it's hard for bot to apply this commit to previous commits in bisect, so we just
> > make out below report FYI that we observe UBSAN issues in boot tests.
> > 
> > 
> > kernel test robot noticed "UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c" on:
> > 
> > commit: 40b9969796bfa49ed1b0f7ddc254f48cb2ac6d2c ("crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > [test failed on linux-next/master 176e917e010cb7dcc605f11d2bc33f304292482b]
> > 
> > in testcase: boot
> > 
> > config: x86_64-randconfig-101-20250522
> > compiler: clang-20
> > test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> > 
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202505281024.f42beaa7-lkp@intel.com
> > 
> > 
> > [   12.442846][    T1] ------------[ cut here ]------------
> > [   12.443261][    T1] UBSAN: unsigned-integer-overflow in lib/crypto/chacha20poly1305-selftest.c:8854:47
> > [   12.444084][    T1] 16 - 114 cannot be represented in type 'size_t' (aka 'unsigned long')
> > [   12.444682][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Tainted: G                T   6.15.0-rc5-00342-g40b9969796bf #1 VOLUNTARY
> 
> This issue predates the blamed commit, and it's specific to
> CONFIG_UBSAN_INTEGER_WRAP which was recently introduced.
> 
> CONFIG_UBSAN_INTEGER_WRAP apparently requires clang 20.
> 
> To try to reproduce this, I built clang from the release/20.x branch, then built
> a kernel with CONFIG_UBSAN_INTEGER_WRAP=y.  When booting that kernel, there are
> many UBSAN reports:
> 
>     [    0.000000] UBSAN: negation-overflow in lib/sort.c:199:36
> 
>     [    0.000000] UBSAN: negation-overflow in lib/sort.c:185:14
> 
>     [    0.276708] UBSAN: unsigned-integer-overflow in ./include/linux/min_heap.h:329:24
> 
>     [    0.277376] UBSAN: negation-overflow in ./include/linux/min_heap.h:260:42
> 
>     [    0.871191] UBSAN: unsigned-integer-overflow in lib/crypto/chacha20poly1305-selftest.c:8854:47
> 
>     [    0.890856] UBSAN: unsigned-integer-overflow in lib/crypto/chacha20poly1305-selftest.c:8851:47
> 
>     [    0.910455] UBSAN: unsigned-integer-overflow in lib/crypto/chacha20poly1305.c:260:57
> 
>     [    1.105542] UBSAN: unsigned-integer-overflow in lib/zstd/compress/zstd_compress_sequences.c:334:21
> 
>     [    1.113539] UBSAN: unsigned-integer-overflow in lib/zstd/compress/huf_compress.c:889:23
> 
>     [    1.114597] UBSAN: unsigned-integer-overflow in lib/lz4/lz4_compress.c:294:9
> 
> So I did get the chacha20poly1305 ones, but they're hardly unique.
> 
> If this new sanitizer is going to move forward, is there any sort of plan or
> guide for how to update code to be compatible with it?  Specifically considering
> common situations where unsigned wraparound (which is defined behavior in C) can
> be intentionally relied on, like calculating the distance from the next N-byte
> boundary.  What are the best practices now?

Hi, yes, this is still under development. I tried to make it hard to
enable accidentally (not via COMPILE_TEST, not UBSAN-default, etc), but
we (still) don't have a way to disable configs for randconfigs. :(

We're hoping to see Clang 21 with the more versatile Overflow Behavior Types:
https://discourse.llvm.org/t/rfc-v2-clang-introduce-overflowbehaviortypes-for-wrapping-and-non-wrapping-arithmetic/86507

and our current testing is showing many fewer false positives. (Having
run syzkaller for weeks now.)

> Documentation/dev-tools/ubsan.rst says nothing about this and only mentions
> "undefined behavior", which this is not.

Right -- this will get extensive documentation before we move it out of
its development phase.

I'm not sure how to enforce "don't enable this unless you're developing
the Overflow Behavior Types" with current Kconfig, given the randconfig
gap... I have some memory of Arnd doing something special with his
randconfigs to avoid these kinds of things, but I can't find it now.

-Kees

-- 
Kees Cook
