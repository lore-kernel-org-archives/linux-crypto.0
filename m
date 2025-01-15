Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A3E4206B
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jan 2025 02:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736908822; cv=none; b=pk5DR9jK8sOQeEC8O4M88htuO5nUtW084NR6eeLgt2myqPzyBrkuQOBY9nAwf4MT0X1k4UjfZOhqa5IxWEMiUz2H6QYlq5DmerMLHr7iKlRgUyfb33UskhMmUDTPVbkUJQTSJvTuMbX0lNH7dHDuSLcMEExww5JVkLKbn3TYlVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736908822; c=relaxed/simple;
	bh=ETQvDhvHX0vLLdDC/Ke6Aw/EXZwrzC1/mBgIaQF1BUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p8UFnvXhpNZdfIJQ4MA7ppU1BAXanVJTCJLzcwj69Y5HCfsHLBi++kUW0jRygz0d2ACSR1niJHwTBn+4k3Yqx1x33ZcS1E/2e+hLorE0h1s/G20o/V/XAAVOjBTa3oWdqlv0k51Vhd3k+bd8TZTzh5cxTAD/1g26WXWmT+yYbMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UkAbef8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UkAbef8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C309EC4CEDD;
	Wed, 15 Jan 2025 02:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736908821;
	bh=ETQvDhvHX0vLLdDC/Ke6Aw/EXZwrzC1/mBgIaQF1BUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UkAbef8dhPsw0Z43gZJzcu0SZlCh7SCq/X/MxIFmcn/GPSS5UebLosoF2X6uCB1NI
	 T4VuXW0om8kypCC2nJHhNiLLQilPDhXcWgCWNU2i8jHZnjeFG7idYvsIL2fBJZA18x
	 tmgB68P1Bugr3k9QJtrxZmW7hRBN+FzxUyey3zy/4rwt2cCefjovg6jMnf6H7JA7Kq
	 IWV8iqyNUKMZAcEgVsFkU9aG1t1YP8RCbreo2hybq0s++fXMAceJfWme6Uj65Zz5H/
	 Tweyra7KVsXv+LSKnH0uSa1syJnMWLkQW/7Tl9GP+Z8ztwWm9nt6/xLqfaWZGTqXMH
	 BE2PIDkf1nAUQ==
Date: Tue, 14 Jan 2025 18:40:20 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 0/8] crypto: skcipher_walk cleanups
Message-ID: <20250115024020.GA60803@sol.localdomain>
References: <20250105193416.36537-1-ebiggers@kernel.org>
 <Z4XeEiZtN7rLXCZV@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4XeEiZtN7rLXCZV@gondor.apana.org.au>

Hi Herbert,

On Tue, Jan 14, 2025 at 11:46:26AM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> > This series cleans up and optimizes some of the skcipher_walk code.
> > 
> > I've split this out from my original series
> > "crypto: scatterlist handling improvements"
> > (https://lore.kernel.org/linux-crypto/20241230001418.74739-1-ebiggers@kernel.org/).
> > Please consider applying this smaller set for 6.14, and we can do
> > patches 11-29 of the original series later.
> > 
> > Other changes in v3:
> >   - Added comments in the patch
> >     "crypto: skcipher - optimize initializing skcipher_walk fields"
> > 
> > Eric Biggers (8):
> >  crypto: skcipher - document skcipher_walk_done() and rename some vars
> >  crypto: skcipher - remove unnecessary page alignment of bounce buffer
> >  crypto: skcipher - remove redundant clamping to page size
> >  crypto: skcipher - remove redundant check for SKCIPHER_WALK_SLOW
> >  crypto: skcipher - fold skcipher_walk_skcipher() into
> >    skcipher_walk_virt()
> >  crypto: skcipher - clean up initialization of skcipher_walk::flags
> >  crypto: skcipher - optimize initializing skcipher_walk fields
> >  crypto: skcipher - call cond_resched() directly
> > 
> > crypto/skcipher.c                  | 206 +++++++++++++----------------
> > include/crypto/internal/skcipher.h |   2 +-
> > 2 files changed, 90 insertions(+), 118 deletions(-)
> > 
> > 
> > base-commit: 7fa4817340161a34d5b4ca39e96d6318d37c1d3a
> 
> All applied.  Thanks.
> -- 

Did you forget to push this out?

- Eric
