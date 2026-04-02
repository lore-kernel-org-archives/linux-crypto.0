Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DE43EF0C7;
	Thu,  2 Apr 2026 23:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775171364; cv=none; b=hZYFLirGV1Wh9JEriHHad/pQWnRBHiGNLbWIBe1LE06QuwkVpkTwFMZb1Nf5pRqVGZAVKdq4rZ2hLsovSJFVOzRmdiQ9jskLyQGzMayiG0ue93nra6EpGkv4p/URG+L46DnbPrkUpht3ucmy23MlLkJ65yJRs38DvK5qBeB2qv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775171364; c=relaxed/simple;
	bh=Womd0qxtzg5R9EjMP/QfWE1oo9FxdE1IAOU+wvR8da0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FnAuydLdmiCy95jmA8EEZNK2z5mHNvue4EKswllgIw+h6oV2KuRrmV3J+ZO6e4UaUHnCkxbReMkM54knP2JPhg2enTSbquMNXpzEUwwHhW6+gS4RKBj76jwiS50k0370xiv0xGLq9EXcL8X78hKFpLB4gotUE62y0nNIlsiK+SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IyG0HqoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IyG0HqoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B37C116C6;
	Thu,  2 Apr 2026 23:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775171364;
	bh=Womd0qxtzg5R9EjMP/QfWE1oo9FxdE1IAOU+wvR8da0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IyG0HqoDhRaLLYBeSlEyQ4HDvvh4PatK7V/AgU3KYNIPxidvOd8w+iGkzEy8wb004
	 66XfmH6+mPmH80rYhiNHq5EnffFWWVrjCi+zXHiNQmqUtaFwA1J+9xpKrub4EeN3bK
	 lynBQE1upZRfioV3u2MnYje+A4EKEhwq0Ee22m+RLC4CfCH+JcEInZf3p5SMQW1rMW
	 +Z6ictNnsc5usGAxJgzgauTO/5ldvzGKxe9cs9+Ml8/M+88QpsFKZTB3FN1CK/xyip
	 n5DB6GZek0grLgOVcg7ANMPyFK8cjEBA0jCkOHqnNRezw2aB3eI7u4VbqnUH5LPKNy
	 EnRgi2RSJHX3g==
Date: Thu, 2 Apr 2026 16:09:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: aescfb: Don't disable IRQs during AES block
 encryption
Message-ID: <20260402230907.GA2910@quark>
References: <20260331024414.51545-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331024414.51545-1-ebiggers@kernel.org>

On Mon, Mar 30, 2026 at 07:44:14PM -0700, Eric Biggers wrote:
> aes_encrypt() now uses AES instructions when available instead of always
> using table-based code.  AES instructions are constant-time and don't
> benefit from disabling IRQs as a constant-time hardening measure.
> 
> In fact, on two architectures (arm and riscv) disabling IRQs is
> counterproductive because it prevents the AES instructions from being
> used.  (See the may_use_simd() implementation on those architectures.)
> 
> Therefore, let's remove the IRQ disabling/enabling and leave the choice
> of constant-time hardening measures to the AES library code.
> 
> Note that currently the arm table-based AES code (which runs on arm
> kernels that don't have ARMv8 CE) disables IRQs, while the generic
> table-based AES code does not.  So this does technically regress in
> constant-time hardening when that generic code is used.  But as
> discussed in commit a22fd0e3c495 ("lib/crypto: aes: Introduce improved
> AES library") I think just leaving IRQs enabled is the right choice.
> Disabling them is slow and can cause problems, and AES instructions
> (which modern CPUs have) solve the problem in a much better way anyway.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/aescfb.c | 25 +++----------------------
>  1 file changed, 3 insertions(+), 22 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
