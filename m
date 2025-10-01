Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B8817C77;
	Wed,  1 Oct 2025 15:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759332597; cv=none; b=Vv7t7Hph8ZYe5KfBo81kM/7+wJlT/nrPwte3bTXNv2X3Yq62aapPZU7H7BMMTESaELr3x0s7d0TvSP7BTBRhKZc9muz794P4JQlkAVdrxX/O3nFqYzdpB5RsMRDChxCTCMYnZ3+evOu2pYxN3q7oDSrPppTI9MvlTu3Xt3qtZJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759332597; c=relaxed/simple;
	bh=qEkigKbJtpRX1KVNlb2llRzoHaqUCe40ACmRcrTdjRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLPxe4XYtbD8zW67Hf2Dy+mVqNO8i4zVdr89AzWgW33o9pAHmQX0G5Tw8Jv9KahffLfWmaWwvzSGiugsjt1L1WuCPvUIAN9PMYk5WeNmmefLgZO3v8gKlbdTeOz9nRaHyk/HeYWD8eFvYcd7ZeJGwPV3/YTVJWS9GPUzAk1z3Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ABEANM7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ABEANM7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16CCC4CEF1;
	Wed,  1 Oct 2025 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759332597;
	bh=qEkigKbJtpRX1KVNlb2llRzoHaqUCe40ACmRcrTdjRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ABEANM7+xvhy/ZW8rA3AsXYtA/4hsJxT6NJG0sqdZR8mSjtIXGBSBMlUt9HNUHjwB
	 rmEngIJVtgxsODAS8Sn54hhR1ZR/XfWwZ/p79mtF9/msXIpzp+0EtQKgU9DWHG+KyQ
	 EUoG3vw++GTV5r4k34DkvdRUh4DFczCZNjZ0ft5YaTUvnQA4A8aeVpmtrLosCaTSOR
	 p0CTUdsP6NMdZE0vAbS1jiUufDbuxMrreMiUfN5+pRnrshIqvpTCjLNPepenNXKd0m
	 YDOZm//oBsJ4AYS1A41UkQyIbyLfrmQafsxnFM+MF7fAiDMGutEKI84iip36y+u3Re
	 9jsLM/osduvUA==
Date: Wed, 1 Oct 2025 08:28:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] crypto, lib/crypto: Add SHAKE128/256 support and
 move SHA3 to lib/crypto
Message-ID: <20251001152826.GB1592@sol>
References: <20250926141959.1272455-1-dhowells@redhat.com>
 <20250926195958.GA2163@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926195958.GA2163@sol>

Hi David,

On Fri, Sep 26, 2025 at 12:59:58PM -0700, Eric Biggers wrote:
> Hi David,
> 
> On Fri, Sep 26, 2025 at 03:19:43PM +0100, David Howells wrote:
> > I have done what Eric required and made a separate wrapper struct and set
> > of wrapper functions for each algorithm, though I think this is excessively
> > bureaucratic as this multiplies the API load by 7 (and maybe 9 in the
> > future[*]).
> 
> I don't think I "required" that it be implemented in exactly this way.
> Sorry if I wasn't clear.  Let me quote what I wrote:

Have you had a chance to read this reply?  In the v4 patchset I don't
see any evidence that you read this reply.  And you didn't respond to it
either.

- Eric
