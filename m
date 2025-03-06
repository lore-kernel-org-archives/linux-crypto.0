Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DA518DB3F
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741233580; cv=none; b=RISda8BxzlmPAx4rMBIcbPu5qv6tk8/ZRFXYmwHW4GRqEC8ECfMvNUU2ExAnHIXYmjgAEMlLu/E/FwUITHJPE1Mos/sqiyW5XGP8KHpP/R2aIKnG9DYW7V72AkYD83n2RiyTsYSdGbZ/jwhbwJy8Nl8rD6imIonjp7G98Y3HYLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741233580; c=relaxed/simple;
	bh=aun8Ty0siKgubChCRwDFz2rX5y/tjPwrE43VNC1GuDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyhK3R7MG8XR6eh+5lRPFCXOthc0Wtc17FiXRPrY7+G9LHKyxEKX8hadoWZNoO3nB2DXr6Lh12LA5/CCyuUZEpkXNnKK9kDfUNNZTKapQKUB5cFHtHS9tDMXcopRbKEi1HT/JUW3KYbrj2kA3QGXSBTA5IE1aZjfDAfsT04oQ4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/R6Hu2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/R6Hu2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A3EC4CEE4;
	Thu,  6 Mar 2025 03:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741233579;
	bh=aun8Ty0siKgubChCRwDFz2rX5y/tjPwrE43VNC1GuDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f/R6Hu2p1AwNUmSbXHKqIOb2C3eapZjim5IUwp3hEtK3x7eA/WYeTJCJ16nS+ooLt
	 FcCdPNz0GVdh1I3RKvj+lO9VNiM/Aek3PhEFd3zJg8jb98+d9n9Mu4MNani6DcFgae
	 yPqJA7lVI3OjHFGy61LMXAPAlid1N3TXXJXjr4GodJec6/pvPDHpyQq8QY2fpuOtyj
	 EKCMZbMuewjDTFrZXH4XN0wrgnDwFqGfPwxsKqcRDfhY3Doc7Y2sT9mk/RBVz2SNPB
	 bQxkAoEsHtrb6qPrO6gUdVCT5qrg9ajmjdnI4MziZ5ARnFpY7/nEdRNQTkb4l/24EF
	 UJJWRdSjzTa7w==
Date: Wed, 5 Mar 2025 19:59:37 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: scatterwalk - Change scatterwalk_next calling
 convention
Message-ID: <20250306035937.GA1153@sol.localdomain>
References: <Z8kOABHrceBW7EiK@gondor.apana.org.au>
 <20250306031005.GB1592@sol.localdomain>
 <Z8kT90qXaTo15271@gondor.apana.org.au>
 <20250306033658.GD1592@sol.localdomain>
 <Z8kZL2WlWX-KhkqR@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8kZL2WlWX-KhkqR@gondor.apana.org.au>

On Thu, Mar 06, 2025 at 11:40:31AM +0800, Herbert Xu wrote:
> On Wed, Mar 05, 2025 at 07:36:58PM -0800, Eric Biggers wrote:
> > 
> > That's exactly what happens to struct skcipher_walk.  This patch adds two
> > redundant pointers to it.  Yes it's allocated on the stack, but it's still not a
> > great result.
> 
> I forgot to mention that :)
> 
> I marked a few places in the patch with XXXs to indicate where
> the API is being abused.  skcipher_walk happens to be one of them
> where it's mixing the new done calls with the old map call.  So
> I will come back to this and fix it to use the new next call instead.
> 
> At that point I intend to have exactly one virtual pointer each
> for src/dst in skcipher_walk, probably the new one that I've just
> added to scatterwalk.
> 
> Thanks,

I don't think it will be quite that simple, since the skcipher_walk code relies
on the different parts being split up so that it can do things like calculate
the length before it starts mapping anything.  If you can make it work, we can
do that.  But until that additional patch is ready I don't think it makes sense
to merge this one, as it leaves things half-baked with the redundant pointers.

- Eric
