Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDEE3D811B;
	Fri, 14 Aug 2026 19:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786737582; cv=none; b=uiYLXTCEH5QtQ8LrUADpZySE/YBPYAa2d6nBJGOlijjQgvh2bfLCdZV5P+/a+UKinMIQEmSIAT977uGDkSEqfhApys7jJAIlbzQ4OFntYxAr82/BOaBTJSf5p7pSQJb76474tGEcxhUTKwNeoLqyqy/DNmlQpx18BjHIP4bX/nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786737582; c=relaxed/simple;
	bh=gBYbZS/IQXYm8iJyWFiD3V2skqgTbClvVtR0QhCbF6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/v4TK1WxVvc3yK0/ATF1/InZEUv2syJPoeeNkjUbo9XNN+4k9EVel5p4EXV0WUbxjISg4OmFjFSVuqsOFYVNt7Z8FqhmF+olODcmpudNYQrKSVVsnHcceeNHTRp5vOt5mj2yY4E/mCsU7s33SA3V77WTnd7t0bh/Q17GQlTwMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f41BHtEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f41BHtEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6C91F000E9;
	Fri, 14 Aug 2026 19:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786737581;
	bh=KNy3zowlMT+tLsRA+SoZOmN7eNITguXwatnKmgFbVTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f41BHtEY9QWcfs5mZVZMBXQG7ERql2GZ+deFnkGy94qFdgOo6EW5gSKtcdYhvdHxo
	 kFsbsDPp98t3kdnJkqATSzHvwzyRzwtKuWyYcs2P1BM6CdMw4QaMpci49U+SD3X1BT
	 GbOUdGjxTbqva58+ptL2I06qvBJh/msKrGtS8qWqO3FWNbHaUJDdqdZEHi3h46T/pU
	 hFqZEQ4xFhi7A1+Y1kNphctSsCHFJ03DVDGgS14eXeEostHhOCORGHYMp8sE/HUBA0
	 9x5ZuaORj5TASD/rklHrOcdf99MY6HyBA2d01mKXVRZb0JtofGiOz15Es6adIeLWGX
	 tFk423eVKtN9g==
Date: Fri, 14 Aug 2026 19:59:39 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/8] x86: Remove cpu_has_xfeatures() and add AVX-512
 xor_gen()
Message-ID: <20260814195939.GB2644249@google.com>
References: <20260813021506.55129-1-ebiggers@kernel.org>
 <20260814003517.GBan5ixaTArd0Sf6X3@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814003517.GBan5ixaTArd0Sf6X3@fat_crate.local>

On Thu, Aug 13, 2026 at 05:35:17PM -0700, Borislav Petkov wrote:
> On Wed, Aug 12, 2026 at 07:14:58PM -0700, Eric Biggers wrote:
> > This series consolidates and cleans up how the kernel handles CPU
> > feature flags for AVX and AVX-512 when the underlying OS or hypervisor
> > (if any) doesn't enable the required xstate features in XCR0.
> > 
> > Specifically, it makes the checks for xstate features be done in a
> > single place at boot time for both UML and native x86, instead of
> > everywhere kernel code wants to check for AVX or AVX-512 support.
> > 
> > Patch 8 then adds an AVX-512 optimized implementation of xor_gen() for
> > RAID, which had been blocked on confusion around cpu_has_xfeatures() and
> > its lack of implementation on UML.
> 
> Sashiko complains about a missing VZEROUPPER there in patch 8:
> 
> https://sashiko.dev/#/patchset/20260813021506.55129-1-ebiggers%40kernel.org

Yeah, missing vzeroupper is a common mistake...  All the other code in
lib/raid/ that uses ymm and zmm registers misses it too.  I've fixed
various instances of this in the crypto code before, but no one ever
checked the RAID code.  I guess I'll send out a v4 that fixes patch 8,
and also separate patches that try to fix all the existing instances of
missing vzeroupper.  Besides lib/raid/, some also have slipped in in
arch/x86/crypto/aria-* and net/netfilter/nft_set_pipapo_avx2.c.

- Eric
