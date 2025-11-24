Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1981E572F;
	Mon, 24 Nov 2025 22:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024030; cv=none; b=WLWjp8Ul4vIW8c6nFANT1mpA6jZTN4vYwbSnyiEyY6V36BQ9KJUFbfWNTuUknPMBnk6SzntWv6oedmGqZAxM6/j0WNvJJD1G0k1JhgL/sGFlkr25akBWNL7LYyOdgSExB0vFyrR3Aeo9F8CB1ZbqzPxVqR1I1jZ7hoVp6VN0RUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024030; c=relaxed/simple;
	bh=s7mMInTg8Tm2Dxg7yZatVSfzSg7ucJg4akwdLSmm0os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iuiXiaPw6OmgyepnIGwv+KTE4RxkoTExEsmwkr1RA2aPap4WlpP18fkSS2HH80nMh3abhDBy6gFnDsL5Z+Wg63pJr1xOTh7st0xj2ruK57+lZW3mTdWYTzbima1/8M+LO1BIHM1/RufxPtzO3AhoMKnrGULzmEThr04W/wBdwtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FP6tJGvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FP6tJGvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C2FC4CEF1;
	Mon, 24 Nov 2025 22:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764024030;
	bh=s7mMInTg8Tm2Dxg7yZatVSfzSg7ucJg4akwdLSmm0os=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FP6tJGvzGgEOLpaNJuS3qblTpuNYXegKOJtay5k4vnAteslQut3LHzl7hvk0AAuaj
	 groQxdYKEj5Y7jMYHq7LDjgRA565DpV8U9n2ZLGRrDiCotaNHarxV+H3fi+cVCrryB
	 3JhUm6fRgqz4w08HZ1nFxGBOzZ6WJJ/yw4w3Xrq/GyhXmamRHjwAiCVaiMBI2NNmTj
	 ROG8yowRQ1dW+4uNfFBF68zuEw0dU77EPL+jXk/XqcqSGb+6XVZ4DcpbhtcwHhAXrG
	 +WHvTREPR1qASblzRZ3f9D1EIt66glI4hZB30F0fiXrrPYvcABGnt/k5yyWT2E2MFW
	 v4W3bmqrg8lZg==
Date: Mon, 24 Nov 2025 14:40:28 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: david laight <david.laight@runbox.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC
 < 12.2 on i386
Message-ID: <20251124224028.GA1827@quark>
References: <20251122105530.441350-2-thorsten.blum@linux.dev>
 <20251123092840.44c92841@pumpkin>
 <0EA9C088-D1B1-4E6E-B42F-EFE9C69D1005@linux.dev>
 <20251123185818.23ad5d3f@pumpkin>
 <20251123202629.GA49083@sol>
 <20251124090846.18d02a78@pumpkin>
 <CAHmME9o7rw=Hi9ykfU4GD6Jxzo6Q404FVGVkUDh+RCjr_-DadQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHmME9o7rw=Hi9ykfU4GD6Jxzo6Q404FVGVkUDh+RCjr_-DadQ@mail.gmail.com>

On Mon, Nov 24, 2025 at 06:14:31PM +0100, Jason A. Donenfeld wrote:
> On Mon, Nov 24, 2025 at 10:08 AM david laight <david.laight@runbox.com> wrote:
> > > How about we roll up the BLAKE2b rounds loop if !CONFIG_64BIT?
> >
> > I do wonder about the real benefit of some of the massive loop unrolling
> > that happens in a lot of these algorithms (not just blake2b).
> 
> I remember looking at this in the context of blake2s, with two paths,
> depending on CONFIG_CC_OPTIMIZE_FOR_SIZE, but the savings didn't seem
> enough for the performance hit. It might be platform specific though.
> I guess try it and post numbers, and that'll either be a compelling
> reason to adjust it or still "meh"?

Earlier I did some quick microbenchmarks with blake2b_kunit.  The
existing unrolling does increase throughput by as much as 50%.  It's
probably mostly due to inlining the blake2b_sigma constants.

However, the increased code size is a real issue that doesn't show up in
that microbenchmark.  Naturally, it will be especially bad on 32-bit
CPUs, given that BLAKE2b works with 64-bit words.  The 32-bit code gets
the code size blow-up from emulating the 64-bit arithmetic using 32-bit
instructions, in addition to the unrolling.  Rolling up the rounds loop
when !CONFIG_64BIT seems like a reasonable first step.

We could consider rolling up the rounds loop even when CONFIG_64BIT.  If
optimal BLAKE2b throughput was actually important on x86_64, we should
have an AVX optimized implementation anyway.  But no one has ever cared
to add one.  I think btrfs is the only user currently, but btrfs's use
case is non-cryptographic and it already supports much faster
non-cryptographic checksums (crc32c and xxhash64).

- Eric
