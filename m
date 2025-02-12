Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CE6271837;
	Wed, 12 Feb 2025 05:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739339070; cv=none; b=PaZLollD4/IQ8NZXLeJKMWX8bfnrlivYVYH+ulYdlk3fzQu12BYU2o9Ofluc/iZs2LnvyZLpLTqTA3NFBRSsFc7WmutmaQdJ7EH2YC/YkRRDOimEgHi9sHxdiA0BjKtwT1OsneLlTCLj3HpZoLmXrrTbNYOXPyHhsqj8LdKL2LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739339070; c=relaxed/simple;
	bh=eqBw8wnJvr1qe7mS2XMAnJCiuly1iAV8vkca9jfee6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sceDWuYKD73/vhE0n/2uEQMRY9TVvmLkrmdoXNaOBV70173W1HKgUPxhNAeeZgrhC3D8f7LX+LJi7R1hkTSugCWJVgzlMrXyZIOgXf7VE9STeNAcBeBPThdEHI2w0Mq+uKnrFyev+vULHRol5qcAQcN0PmqbV2XnNBoj8wp29Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxteaO9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxteaO9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF12C4CEDF;
	Wed, 12 Feb 2025 05:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739339070;
	bh=eqBw8wnJvr1qe7mS2XMAnJCiuly1iAV8vkca9jfee6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nxteaO9QvWWmCguu8A1LMbWouNS7PmhzOFCfdvDIM1b0ZVqaIMFLaYunwLky1n30o
	 i9NKxtAZ8pb0gyVeLLHyW35KbRUF8HVq6I5KaExS+yqmajzBhxWAOZ7HMJAlm8+yBA
	 Vh78Xx5O6ihc5oEr1YV7DFILgwX7JMJcCi4nqOTAZYO5uhU9UX7r6ene8lz6LdnZ8U
	 6xMLVnlq8xHgulCZ9USR1FeAbe24Ff9UMpr9s8D51xiH7EUtV56vMy9K/MxO2J7+3V
	 3qfXUKgmgqSgG2fji4LBGYmkyLsaa2ED2To5r7P+xidQw/Ml++1LNwslC1J763l8g9
	 K5dVsf5xFtn2g==
Date: Wed, 12 Feb 2025 05:44:28 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kernel test robot <lkp@intel.com>, Danny Tsen <dtsen@linux.ibm.com>,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/Kconfig - Fix lib built-in failure when arch
 is modular
Message-ID: <20250212054428.GC2010357@google.com>
References: <202501230223.ikroNDr1-lkp@intel.com>
 <Z6woN4vgdaywOZxm@gondor.apana.org.au>
 <20250212050936.GB2010357@google.com>
 <Z6wxp7UE9MAht4pc@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6wxp7UE9MAht4pc@gondor.apana.org.au>

On Wed, Feb 12, 2025 at 01:29:11PM +0800, Herbert Xu wrote:
> On Wed, Feb 12, 2025 at 05:09:36AM +0000, Eric Biggers wrote:
> >
> > Please name these like ARCH_HAS_CURVE25519 and CRYPTO_LIB_CURVE25519_ARCH to be
> > consistent with the CRC library, the many other ARCH_HAS_* options, and
> > CRYPTO_LIB_CURVE25519_GENERIC.  Nothing uses names that contain "MAY_HAVE",
> > which is ambiguous.
> > 
> > FWIW, at some point the arch optimized crypto algorithms also need to just be
> > enabled by default.  The fact that they're not is a longstanding bug that is
> > really harmful to users and needs to be fixed.
> 
> I'm simply responding to an lkp report.  While your suggestions
> may have merit, I don't have the time to pursue them.

The way that the arch options are selected is very much related to this issue,
but even disregarding that the first paragraph of my response is a review
comment directly on this patch about the naming it uses.

- Eric
