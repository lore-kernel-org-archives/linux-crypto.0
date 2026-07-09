Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5345D37F755
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783610847; cv=none; b=bdwf+vxA8mMHuKwoRfvuNiOZo68RoQqKy88K5hFWbEov9DCENe+vgk1du8v5DAwzqJRjysCXUvzEZEz8DWT1bYoMp/3AB3y9HfeJVtGFV0Dr+97bJgvMANXOot29Gl8zQ2qL8Fs6sgXFII58Ham31kEnPEUjG1smw8OxwCqhE8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783610847; c=relaxed/simple;
	bh=ABwhp410kKyCXET/wnxdJ5t5QT1XbP5Bx0W21iMax/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljh3Rti0DON9DJ1GLrpGddZREhCnnDIiE1wPNDvBOvnw1ak+crF0UQbJILSkoVSNxfkKN4jkhVIg/HRJCq1CV5T93e9pr1Kfmjisr0bJfVcSQNjqBnhFDLmrOd3UIumyJT1HSphyz1nrCmxhKXnW9yIvqTE4CfTFT/Ghdd+YD74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8XPsNvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8XPsNvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4951F000E9;
	Thu,  9 Jul 2026 15:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783610842;
	bh=0sP/MjSLcB/7GCXYU7a/ogplGBFTPfKJpRq3p8Kmc3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e8XPsNvyhQ+BiCOFCFeddNHpswfnN4NGdl/FVqjTX68phTlv2/LWjVWwbMmM6MxM+
	 XuNPX5zWjQKfrmaslTM4TEf9TWz4+gEpM3lh3mFJ2LZnyKqECc2V0zfaR+fvxUrUkR
	 PM51WnV3GZk1U2iRmceyp2nQHeF3Fn88t+l3pabWl/o89EpJB+mhW0B6jx8xLw1Hht
	 JlLPdXdDpKBuDk4bMFpyM1w6YWWkrtN5PEdr/gQBAqMD7J1I10+EDxI7twmxgnOFYH
	 as44FF6z8Rr91V9kYRSpHBrBoE15901bkJupX+MLhIM4En8XVPkGjHQQEm7jalwnmL
	 x+4pYXemrLD9A==
Date: Thu, 9 Jul 2026 11:27:20 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG deprecation fallout
Message-ID: <20260709152720.GB3342@quark>
References: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
 <20260708011112.GA3890@sol>
 <04fbbc8611699e469f44edbccdf3cf1ac65075d3.camel@scientia.org>
 <20260708030153.GA14700@sol>
 <aac82bdd-6a28-4e65-97f4-3d5942d2a6af@gmail.com>
 <5B8D2771-3FBD-4FF0-A2A0-A57120A53F5A@scientia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8D2771-3FBD-4FF0-A2A0-A57120A53F5A@scientia.org>

On Thu, Jul 09, 2026 at 02:38:50PM +0200, Christoph Anton Mitterer wrote:
> Hey.
> 
> Am 9. Juli 2026 12:47:06 MESZ schrieb Milan Broz <gmazyland@gmail.com>:
> >On 7/8/26 5:01 AM, Eric Biggers wrote:
> >See my explanation here
> >https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/420#note_2520172869
> 
> Do you strictly need an RFC?
> 
> Nevertheless, I've mailed to the author of draft-irtf-cfrg-xchacha whether he has still any plans with it.
> At least then we'd know if it's worth waiting.

XChaCha is seeing significant use in practice, both in the kernel
already and in the broader community.  It is secure if ChaCha is secure.
An RFC would be nice but I would not consider it necessary.

- Eric
