Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A79E2F747A;
	Wed, 29 Oct 2025 20:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761770027; cv=none; b=JL+yrssm9MzfX0+UIaZ5N4Y550oiYqTU9wdfPmhO0vT96P8hkyEIcw84HN36leLuQ+Dl2VclmHNoVnnYElwOYsurtHHT4dsoEdQaTXRU+yFsWIyZYZKgfBouboEmIhPVgqGGeFf8fsbiJkgIPERb935OrHpovEVx4AFNFbL7QT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761770027; c=relaxed/simple;
	bh=1YYHbGxitQpCKegAMWgROh9APSqbc/XP3P6OnMF3lYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+EsiCPTGsyHB7BUtryMx2ieocI4xfTUIFxp9lH2b+GOOhNFx/iGfoT+P/CSvLcMIx/gKvv/2xUp/i5vD7K5WzeL0ft2dFSwEDfuJeU0pID0XrL0/tZlO/qXo45tdESMA+ThNStTrJKe/xQS9oBxSGHpBYp2cKETakRQcQ23Mkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u/YomqmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u/YomqmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5CDC4CEF7;
	Wed, 29 Oct 2025 20:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761770027;
	bh=1YYHbGxitQpCKegAMWgROh9APSqbc/XP3P6OnMF3lYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u/YomqmNZv9U436QyDn2L0CLJ3MWyFtp+BYSvTPSEMD1bESCtQVOc0Zcnb4jShy5I
	 5HxoAUg0W1hjky75dCBJJ739FiGnBtDbdPDiMLHGgWN0XU/inuOmxTCakOCFzm0ttE
	 6l+47dXhAPQzitQB+l7L7Yi3qTNB0yuxuiqDBpH2aFq/DrDoMBcGhhM90GCQDmU1b+
	 v7j7OpB/XgySFRM8gwVVP66ml8qCNDSrfPzR4n62Kzh8BOEvRYgUzpZinskpiiMLgf
	 o9zx+G7K+UFyHmvRZP4T3+BBwspVrCIaeB4GEOzfchkJpBLsfxL/QAfGcUSP7L/DrN
	 1IjUVcQwSkPIw==
Date: Wed, 29 Oct 2025 20:33:45 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/15] SHA-3 library
Message-ID: <20251029203345.GA3750798@google.com>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <ba3ff3d5183ab78b3d02d8db30223def@linux.ibm.com>
 <20251029163216.GA1603@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029163216.GA1603@sol>

On Wed, Oct 29, 2025 at 09:32:16AM -0700, Eric Biggers wrote:
> On Wed, Oct 29, 2025 at 10:30:40AM +0100, Harald Freudenberger wrote:
> > > If the s390 folks could re-test the s390 optimized SHA-3 code (by
> > > enabling CRYPTO_LIB_SHA3_KUNIT_TEST and CRYPTO_LIB_BENCHMARK), that
> > > would be helpful.  QEMU doesn't support the instructions it uses.  Also,
> > > it would be helpful to provide the benchmark output from just before
> > > "lib/crypto: s390/sha3: Add optimized Keccak function", just after it,
> > > and after "lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest
> > > functions".  Then we can verify that each change is useful.
> [...]
> > 
> > Picked this series from your ebiggers repo branch sha3-lib-v2.
> > Build on s390 runs without any complains, no warnings.
> > As recommended I enabled the KUNIT option and also CRYPTO_SELFTESTS_FULL.
> > With an "modprobe tcrypt" I enforced to run the selftests
> > and in parallel I checked that the s390 specific CPACF instructions
> > are really used (can be done with the pai command and check for
> > the KIMD_SHA3_* counters). Also ran some AF-alg tests to verify
> > all the the sha3 hashes and check for thread safety.
> > All this ran without any findings. However there are NO performance
> > related tests involved.
> 
> Thanks!  Just to confirm, did you actually run the sha3 KUnit test and
> verify that all its test cases passed?  That's the most important one.
> It also includes a benchmark, if CONFIG_CRYPTO_LIB_BENCHMARK=y is
> enabled, and I was hoping to see your results from that after each
> change.  The results get printed to the kernel log when the test runs.
> 

Also, can you confirm that you ran the test on a CPU that has
"facility 86", so that the one-shot digest functions get exercised?

(By the way, I recommend defining named constants somewhere in
arch/s390/ for the different facilities.  I borrowed the
"test_facility(86)" from the existing code, which does not say what 86
means.  After doing some research, it looks like it means MSA12.)

- Eric
