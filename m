Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358AA1A254C;
	Sun,  2 Mar 2025 20:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740946898; cv=none; b=Pjc+q/ak4zDw7u0EuDKBULcCxhTnMkl5RyD7C9lNmiH9sucZ+/q7hnVcHwNTub9rBC7LlotYNzaUky/87nv7ZX9lFZyZFQw+IQ98MwghwMbJh/VAredVGIXP/1NkG8ZiuN2Q/DGIVxYuTgTo9g2/BUlL2U8KjB2JSID6DXOkJuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740946898; c=relaxed/simple;
	bh=U/oh/1qUjuVWLJQXba7EY6JVHOFjUPWecbqEwFKCr2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FfYrIsHFhOCQ3bSC75VRiDKneM8CoyzkjCeSxK2LpGN+lyoWzPI1S8g0GoJo8WpfImbqH3lkoTK5e6RHl12E10yqGWtzMu9WT1cUUa9stLKV4qLMR/Q5RwLj+rGXmBUGKlQysXPZUJkrN/reXDYuw7VP90P9s7U4yM/hSVZidOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvXYDw0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvXYDw0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8DEC4CED6;
	Sun,  2 Mar 2025 20:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740946897;
	bh=U/oh/1qUjuVWLJQXba7EY6JVHOFjUPWecbqEwFKCr2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XvXYDw0v5ornM3+5+sNYUWUPsvCe3iHJV3193ZnXV5x3oBCNZAx44NH9FL+42XVf7
	 4OPfPS/8jv32JNRMjfEwlW3m8bkP+629Eb9pme6DKNoaG83dxat8jjgCTWcdN6mxUQ
	 gyf563SE32MYCgi7mDXNrvV4NrfsKep7sP8rA4q1uvUD3+6ufxPAywaYDyrGa7o0Pz
	 1mzuEyr2EmukBy9+gjNO2gO8+DY2PJ/nRTdnzhIs82Oyj2i5l/RxFGDZlEYMG4RIMu
	 j6CQahvbp6phiBhkNOSzd+Vp9eAZTEY+9DxNp5FmRWtIOd5chkE9olU535JxnUDYqn
	 lwL7d0SS5EoQA==
Date: Sun, 2 Mar 2025 12:21:35 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v3 03/19] crypto: scatterwalk - add new functions for
 iterating through data
Message-ID: <20250302202135.GA2079@quark.localdomain>
References: <20250219182341.43961-4-ebiggers@kernel.org>
 <Z8P6qOt4DQ3_FkMo@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8P6qOt4DQ3_FkMo@gondor.apana.org.au>

On Sun, Mar 02, 2025 at 02:28:56PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > +static inline void scatterwalk_done_src(struct scatter_walk *walk,
> > +                                       const void *vaddr, unsigned int nbytes)
> > +{
> > +       scatterwalk_unmap((void *)vaddr);
> 
> Please send an incremental patch to eliminate this cast by making
> scatterwalk_unmap take a const void * just like kunmap_local.
> 
> Thanks,

Patch 19 of this series already did that.

- Eric
