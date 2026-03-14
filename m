Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907DB1FB1;
	Sat, 14 Mar 2026 19:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773517045; cv=none; b=OTQmjY1FhdHYDF7NFwh+bmY2YOcblSVXT+Hz6X3G3f7nbtu3Jor9AQcehKVCZm64NX73+zDuFm0dshM5cXxiMVIEYjF9hHMcBRK7OMFrOjv15a0zxU1CmOe4NuAWPpi1ezm6lPcgW9fZJk9tMGCKXSUdCKhqD0nHXRQqjntVwuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773517045; c=relaxed/simple;
	bh=icNnrJBtPkCYZbXYgN0Ssm/kSEKEn2rPOY0B8ZibpuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NyGP95A2BgROUFjUmg3g2oXqaPnRshQr+VXny0Aln8KztQdFU0A8wQZYZDykP911QXJJwrGb3sMyF1D9zRZUdX+MIwuL3Fo1dS/LrTf62o8lL3YK3QkrYmYMPlg/EHUww6R5hL4xdQMH+6pV8mSOYowLUtdMfRsz1ZvrJZivVpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyAzloDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyAzloDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51C2C19425;
	Sat, 14 Mar 2026 19:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773517045;
	bh=icNnrJBtPkCYZbXYgN0Ssm/kSEKEn2rPOY0B8ZibpuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UyAzloDhl5lAVMoRokNU6dI4pZ6uulEXwDhlHJRHfYnk7xZ6Zm2lz+O0zteSpNKAj
	 a86eGS0Jaoq8E38LkdWustz/LffhBHJh6h5p2wyHLpjDqHr1ek2l6tIwfy0AEa9e6y
	 IZ/dVnTsxPcr9/4Su2SGYIYlk7LLVTcDSYvKAiyUdQXamOhBUuE6KQaOsP9yqz7tRK
	 zlSjBuBhZdThU7ah0WqkjaQDAD7J3qkenYZT4UhYCY2UlO9zdNTpv3pW6KsXLPuiZA
	 VxL2rWdlyNeBdDVe0nAepzMp8Bb4wjbOyVkGlEZBobWUYMFfQmyQgNRVIqeZbS/1NM
	 wKLTreCg0W5Tw==
Date: Sat, 14 Mar 2026 12:37:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Joachim Vandersmissen <git@jvdsn.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jeff Barnes <jeffbarnes@microsoft.com>
Subject: Re: [PATCH] crypto: aead: add service indicator flag for RFC4106
 AES-GCM
Message-ID: <20260314193723.GD40504@quark>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
 <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
 <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>
 <aaKtujHwV0zDFWxi@gondor.apana.org.au>
 <a73a2556-3fa3-45fc-bf06-a62e8367e953@jvdsn.com>
 <145cfedf-7510-44b7-b1b7-6569144e7b21@linux.microsoft.com>
 <aaZXa9GHhbvmyqLR@gondor.apana.org.au>
 <a9e6bf51-1222-4901-b7a9-9d47c0abbac5@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9e6bf51-1222-4901-b7a9-9d47c0abbac5@linux.microsoft.com>

On Thu, Mar 12, 2026 at 10:00:59AM -0400, Jeff Barnes wrote:
> 
> 
> On 3/2/26 22:37, Herbert Xu wrote:
> > On Mon, Mar 02, 2026 at 04:51:38PM -0500, Jeff Barnes wrote:
> > > 
> > > For instance, ceph, samba, tls, to name a few. They all instantiate the
> > > gcm(aes) template. They all construct their own IV. They are all compliant
> > > to SP 800-38d. I am pretty sure that at least one constructs it per 8.2.2
> > > while the rest construct per 8.2.1.
> > 
> > Perhaps they could switch to IV generation in a way that's similar
> > to seqiv?
> Actually, there's no need to do that. They are all compliant already with
> the spec.
> 
> The issue according to the CMVP (NIST) is that because the kernel crypto api
> is, well, an api, that it is *possible* to instantiate the gcm(aes) template
> and generate an IV in a non-compliant way. Even when pressing the point that
> the kernel is monolithic, hence self-contained, and booted with
> lockdown=integrity, the point is lost on the certifying body. Their response
> is to implement the service indicator "like all the other distros". That is
> a very unfortunate way of putting it. It is what it is.
> 
> So currently, for the kernel (crypto api) to pass FIPS 140-3 certification,
> the only viable solution is to either implement the out-of-tree patch or
> disallow gcm(aes) in FIPS mode. Of the two, the out-of-tree patch is
> expensive but the lesser of the two evils.
> 
> I like the idea of automatically switching to seqiv or rfc4106 templates
> when in FIPS mode. The unfortunate consequence is scale. There are 24
> gcm(aes) template instantiations spread out through the kernel tree with
> about as many maintainers. Each of them generate an IV. That seems to me to
> be too large scale.
> 
> Please reconsider.

This whole exercise seems awfully silly, given that no code is actually
going to check the CRYPTO_TFM_FIPS_COMPLIANCE flag, either upstream or
downstream.  So this is just unused code which exists only to satisfy a
check box for something that FIPS 140 says has to be there but is never
used in practice.  While upstream does have limited support for FIPS
140, that limited support tends to be for things which at least actually
do *something*, not completely unused code.

I guess I have to ask, if the theoretical possibility of code calling
'crypto_tfm_get_flags(tfm) & CRYPTO_TFM_FIPS_COMPLIANCE' is sufficient
to count as a service indicator for AES-GCM, is there any reason why the
procedure for retrieving the service indicator can't be something like
'strncmp("seqiv(", crypto_tfm_alg_name(tfm), 6) == 0'?  That would
effectively be the same thing, and it wouldn't require any new code.

If that's not enough and your FIPS certification lab will only accept
the solution with unused code, I don't think that's very compatible with
upstream, sorry.  Any unused code upstream is going to tend to be
removed, as per the usual kernel development practices.

- Eric
