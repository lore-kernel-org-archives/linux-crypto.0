Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B457211704;
	Mon,  7 Apr 2025 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744044524; cv=none; b=ionsBwo64AuUJctps8AsHGm4MS0Gazhk4TdnaZ8mEl5hyj0EXqJkr5bqOy64dw3y9bbuygwbH36reOosQ2c/HBx+O2FajGKIyBZDbBovNw8e3kFuexvmAxfco9tpy2Rewj1TgIyniz17fSAffz8kEoSypQMKDzWhZpDJaKz17As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744044524; c=relaxed/simple;
	bh=bmjI2mo1WVbWDZeX2Qfbgg6QuEIqWPvfMO/E2wzuVoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5GuFmVo/dW3JJmYGTPkPQ82QU9VeTbPppZt13/iJ+mV2SGBLY66En+DOqQKK9Hu1mEmaUKNYSisPOKuwYINdK9ZEsFeq4qw5rBJhr5POmD8vdADUpqHeKDWUneH97yQMFcW+zNZ/tfV/xwk3ymjLxRvaillw2lmPoBrKD+18Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0XOd+2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0XOd+2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090B7C4CEDD;
	Mon,  7 Apr 2025 16:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744044524;
	bh=bmjI2mo1WVbWDZeX2Qfbgg6QuEIqWPvfMO/E2wzuVoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X0XOd+2yo1YmafQv5UKRqkKILylyFSgn3Iz4xMRW+j1EKQW9ycTJEh32M2mW7hgem
	 zlcNS1fNF2EbOMESsE8UXs+DnHYN87ZwI3oo2q76ugoXNSuzIgw4UyAB67LhQfpPb6
	 uU91fR/fLX7P25na3pCXCaG5l6fpHgH9PkiujMlHb6ywGAxcyGIPV+kqNbMM87ZOTC
	 X/fu8nxWevwkXZnKeMrsQENqEoSrapThGfd6o8Ke/uQeTGpu3gO5nvnx5Uxn60NNY3
	 11d2pBYMao5tJ1RQTeTiKbkbfqyDNfhUoa2WJuXxHf7w01xKypRW3qwb9MccO3Xi60
	 0fBpFZrKfGooA==
Date: Mon, 7 Apr 2025 09:48:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] crypto: x86/chacha - Remove SIMD fallback path
Message-ID: <20250407164842.GC2536@sol.localdomain>
References: <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
 <20250402171930.GD1235@sol.localdomain>
 <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>
 <20250403021453.GA2872965@google.com>
 <Z-344xAsx1uTE9OK@gondor.apana.org.au>
 <20250403032008.GA129577@sol.localdomain>
 <Z-4DqsRApwQi6Xju@gondor.apana.org.au>
 <20250403035934.GB129577@sol.localdomain>
 <Z-4LOoynbEz3ZLuQ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-4LOoynbEz3ZLuQ@gondor.apana.org.au>

On Thu, Apr 03, 2025 at 12:14:50PM +0800, Herbert Xu wrote:
> On Wed, Apr 02, 2025 at 08:59:34PM -0700, Eric Biggers wrote:
> >
> > But in a lot of cases there is also no reason to even add that restriction.  I'm
> > not sure why you're so eager to make the library functions harder to use.
> 
> I have no intention of making any changes to siphash.  It doesn't
> even use SIMD.
> 
> All I want to do is get rid of the crypto_simd_usable() fallback
> paths that we currently have in arch/x86/crypto.  This code is
> never used in hardirq context (and should never be).
> 
> For example:
> 
> ---8<---
> Get rid of the fallback path as SIMD is now always usable in softirq
> context.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

It looks like this broken patch already got applied for some reason.

First, there doesn't seem to be agreement yet that the library functions should
have requirements on the calling context.

Second, your patch made unrelated changes that deleted the checks for SSSE3
support.  Thus dropping support for CPUs that don't support SSSE3.

- Eric
