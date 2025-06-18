Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A006535963
	for <linux-crypto@vger.kernel.org>; Wed, 18 Jun 2025 21:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750282839; cv=none; b=XVmHJ8t3oRQu5KqWdVE8K3bDmtnfK374v63jE6Pl9NP7/shUJdgEk0pdEH6P1c1dFciVTxqbYxnz/UEJYwRLlOsOd16s7J3wLFNaCNTInfPBVjwnbUSn+rb/HQs7jz7mjMyqk/2A0QQ2inSfK9KDvMAB+MbmtAesT5loNts4H3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750282839; c=relaxed/simple;
	bh=zZnSwWVfa3L4LcIlb9IwqQwW+8ErHGoypiCdYyko/M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+LTKM2G0C0ZSULFAnO2OITxs+rusL12ldB/O0/8/+aU51tUujxGHwYiE7DM1RQeOscVGGUXkTesMkDNw+6VsnVNsoFssaTIvSD2O+Y+kry4lm/THQEDJcM9AlLG6xq4lpf8eclMObDerrMPe6vS9hdEG+oYh7ohYX+Agj5mdbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kmMkbujt; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kmMkbujt"
Date: Wed, 18 Jun 2025 17:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750282834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5P7pmHdw5PVQBLtLoWp7mz+v2mTrLD1cSOToVE3C7JA=;
	b=kmMkbujtLNOiT7kEte94MfmNU4CJYwl30ArBiRClHUOtAFceAEhT4mIfeSMIATlb8y/m0j
	Sn0Lln/61J9Y1UTIHtrDtynL0RwKH53lKv4wkn9h+G8NMShu4L2k2xX/JB4Qpb2+pONdN5
	FRk1OgDIAoE6n4Z9CZKZFbTYNDxknSw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Kees Cook <kees@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [GIT PULL] Crypto library fixes for v6.16-rc3
Message-ID: <w3t36hsxocm3uotbhnonsioomnvkqpmazctyogmx36ehlxezyz@h4vytlcacc7k>
References: <20250618194958.GA1312@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618194958.GA1312@sol>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 18, 2025 at 12:49:58PM -0700, Eric Biggers wrote:
> The following changes since commit 19272b37aa4f83ca52bdf9c16d5d81bdd1354494:
> 
>   Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
> 
> for you to fetch changes up to 9d4204a8106fe7dc80e3f2e440c8f2ba1ba47319:
> 
>   lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch() (2025-06-16 12:51:34 -0700)
> 
> ----------------------------------------------------------------
> 
> - Fix a regression in the arm64 Poly1305 code

Some more tests too, perhaps? :)

This was a bit of a scary one, since poly1305 was returning an
inconsistent result, not total garbage. Meaning most of the tests
passed, but fortunately the migrate tests read data written by userspace
with a different library.

> - Fix a couple compiler warnings
> 
> ----------------------------------------------------------------
> Eric Biggers (1):
>       lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch()
> 
> Kees Cook (1):
>       lib/crypto: Annotate crypto strings with nonstring
> 
> Nathan Chancellor (1):
>       lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older
> 
>  arch/arm64/lib/crypto/poly1305-glue.c |  4 +--
>  lib/crypto/Makefile                   |  4 +++
>  lib/crypto/aescfb.c                   |  8 +++---
>  lib/crypto/aesgcm.c                   | 46 +++++++++++++++++------------------
>  4 files changed, 33 insertions(+), 29 deletions(-)
