Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022BD3446CC;
	Mon, 20 Apr 2026 17:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776707309; cv=none; b=XSWNi7ZY6rn0sJkRFS8hmqmf1S00zvErEtuzzoC8UHAIm5v/WFvKUn9B7pGdqOaGLFPBC1ko1EgGMSgmZzAg4CmgBJ+U/won7QmfU6cpSG1wyAiL+RexiP/50mZRiT5AnZaFhERhjcbI8TRhBecNou4gd16N1tWY/iYFqw7p250=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776707309; c=relaxed/simple;
	bh=FDeI1DTJ7gMmhAhnOgD4lEOmUlxLaOnfTDsK+A+8yAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEPCO12oogB4OroKLb4WQTolunRPN2W5JLZC2UsCpivI5HnBwS6TMxFGFL61j1dqPNDueYUwrVvOHW3WeiLL+mU44p8VvELplzPI7Dw/3A1g7r9sPA4urkTdI9hG0vm8Izf7w6OHVdvrtJOukraJF+NgViiRbbAYWbD02X1xMc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrv3mpr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrv3mpr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86901C19425;
	Mon, 20 Apr 2026 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776707308;
	bh=FDeI1DTJ7gMmhAhnOgD4lEOmUlxLaOnfTDsK+A+8yAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qrv3mpr82fyEfpUsZ1z7bwW3M5XvtuRkTMTZ6GyLUHNwpMqiNY6OGDUPb60NHdVZ6
	 T+Hrmg4eRj6mZ3MdgtQ0PpENpsEVM3x3Lac2e5XDuUnHNUfL4OepY/Er0wHDYI6+Bw
	 5dOtMIMt9Pbw2s52RPoWJNL0aoiji9lrp5R8LPhZkt2K5XPJeztJI699QAFIPWpHEi
	 Qo93DxEzw7i2uCd1FJ7S+hl6+lI3V0Io8qfUzHJsRk2k08CJzR+9QMgpYioHyED7mX
	 5d32Gepnw/k+VG4OkNeW6LgDn0llsU1Jk60DP9TQv3ESTIfD34l0onSiLPWxtgMk6o
	 7rJwLsLVq3cbg==
Date: Mon, 20 Apr 2026 10:47:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 12/38] crypto: drbg - Remove support for CTR_DRBG
Message-ID: <20260420174713.GC2221@sol>
References: <20260420063422.324906-1-ebiggers@kernel.org>
 <20260420063422.324906-13-ebiggers@kernel.org>
 <2300345.NgBsaNRSFp@tauon>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2300345.NgBsaNRSFp@tauon>

On Mon, Apr 20, 2026 at 04:40:18PM +0200, Stephan Mueller wrote:
> Am Montag, 20. April 2026, 08:33:56 Mitteleuropäische Sommerzeit schrieb Eric 
> Biggers:
> 
> Hi Eric,
> 
> > Remove the support for CTR_DRBG.  It's likely unused code, seeing as
> > HMAC_DRBG is always enabled and prioritized over it unless
> > NETLINK_CRYPTO is used to change the algorithm priorities.
> 
> Just as an FYI: the CTR DRBG implementation is used, because it provides 
> massive superior performance. The CTR DRBG implementation is lined up to use 
> the AES-CTR mode directly. If you have an accelerated implementation like AES-
> NI or ARM-CE, your performance increase is significant.
> 
> For example, on my M4 development system, the generation of 1GB of data from 
> the CTR DRBG takes 90ms whereas the HMAC DRBG takes more than 4 seconds.
> 
> The default of HMAC DRBG, however, was used since it has a simple logic and 
> smaller code.

I guess I have to ask: by "it is used", do you mean that it's used by a
significant number of users, or is it more of a personal thing where you
happen to be personally using it?  Note that the only way to select it
is directly by driver name (which has no in-kernel users), by running a
custom userspace program that uses NETLINK_CRYPTO to modify the
algorithm priorities.  I'm sure you know how to do the NETLINK_CRYPTO
thing, but this very much seems like an idiosyncratic expert-level
configuration that isn't really used in practice, similar to some other
things that you've added like CONFIG_CRYPTO_JITTERENTROPY_MEMSIZE_*.

And even if it's being used, does it really need to be?  Do you really
need more than 250 MB/s of "FIPS-approved" random numbers, and from the
kernel (not a userspace library)?

I also don't think we actually have much choice, given that we don't
currently have a reliably correct implementation of CTR_DRBG anyway, and
that takes priority over everything else.  As I explained in detail in
this patch, this just hasn't been something that's ever been done.  It
sometimes returns success on failure, it sometimes isn't constant-time,
and it used to repeat output on some platforms (and maybe even still
does).  Not particularly great properties for a RNG.

While a reliable implementation of CTR_DRBG is possible (BoringSSL does
it, for example), the reality is it would take quite a bit more work.

- Eric
