Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3B516BE39
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 16:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729096048; cv=none; b=sa1JaNk4h6uWR7cC3sfzj/Xo4dk943ixSJOc3yX1FiLns0VZXYrj15VZwpj4SJNQGPqg0W2z1YR09EYN5xECeaDjm4PmvKIQPUSSjG6LX66EJjQIcDshzZ01fOHfYHpbkO1DtF2usdk4enWrh2/TefZQhIGUAOZefUj9zq0qpho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729096048; c=relaxed/simple;
	bh=Sj4hHfajy07xXHZDC3iAWKW0T1zkzy/GdmxY5XAzHYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c6NT8ILsrb8VTo1kDbZxYy5kybV/nPqyByyvc85iB5RE9Qk2HK9Q+Hn9szO+25vgUPtNoj/KvhXtFc6gzHWeaFVEeUSmfTTJgDNZIUXKjmcFfbZ6znhPqc/CH00sF7L1LAg/0Ev+5XolWZMuzDLeF5hou0dPAM2QOWZVJURaESk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcKtRxtC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcKtRxtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C08C4CEC5;
	Wed, 16 Oct 2024 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729096047;
	bh=Sj4hHfajy07xXHZDC3iAWKW0T1zkzy/GdmxY5XAzHYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kcKtRxtCXa501eMxIPR/9mPZSc4GwjCE+oKxZR/c6WhgB3+Urvf06JSqrmuP33iXg
	 dQ3RTyrB/U7AGc+wo/qGIatq2EGyWZ2QsjnmuMvFC8qmQetVqVbVU8jBiuaRp7Eru0
	 YPQ+9nsZHzSQ9EB4k9TH+tb3pIpd3FHJwopOfo2v7SE7GUD0d8uoHAS1nvsx6WQ7fb
	 gZv4Zt/cEkZLZnGdpD6fODB82i/onUwrew3m0zRxPfv4ccWhaGle871mvGIFy7wjrp
	 YKuqXznqV1/Yy0SCLRas6uoVxZQdyjSBmhpXm3MyKj8G+/JMokGGRgBSIP0aQPLLr0
	 XOCYR0YmR4azQ==
Date: Wed, 16 Oct 2024 16:27:25 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/9] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
Message-ID: <20241016162725.GB3228925@google.com>
References: <20241011155430.43450-1-hare@kernel.org>
 <20241011155430.43450-2-hare@kernel.org>
 <20241014193814.GB1137@sol.localdomain>
 <e9ea2690-b3ac-47f0-a148-9e355841b6d0@suse.de>
 <20241015154110.GA2444622@google.com>
 <83934544-0e4e-42eb-a15b-8189a46273c7@suse.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83934544-0e4e-42eb-a15b-8189a46273c7@suse.de>

On Wed, Oct 16, 2024 at 08:40:54AM +0200, Hannes Reinecke wrote:
> On 10/15/24 17:41, Eric Biggers wrote:
> > On Tue, Oct 15, 2024 at 05:05:40PM +0200, Hannes Reinecke wrote:
> > > On 10/14/24 21:38, Eric Biggers wrote:
> > > > On Fri, Oct 11, 2024 at 05:54:22PM +0200, Hannes Reinecke wrote:
> > > > > Separate out the HKDF functions into a separate module to
> > > > > to make them available to other callers.
> > > > > And add a testsuite to the module with test vectors
> > > > > from RFC 5869 to ensure the integrity of the algorithm.
> > > > 
> > > > integrity => correctness
> > > > 
> > > Okay.
> > > 
> > > > > +config CRYPTO_HKDF
> > > > > +	tristate
> > > > > +	select CRYPTO_SHA1 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> > > > > +	select CRYPTO_SHA256 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> > > > > +	select CRYPTO_HASH2
> > > > 
> > > > Any thoughts on including SHA512 tests instead of SHA1, given that SHA1 is
> > > > obsolete and should not be used?
> > > > 
> > > Hmm. The original implementation did use SHA1, so I used that.
> > > But sure I can look into changing that.
> > 
> > If you're talking about fs/crypto/hkdf.c which is where you're borrowing the
> > code from, that uses SHA512.
> > 
> Actually, I was talking about the test vectors themselves. RFC 5869 only
> gives test vectors for SHA1 and SHA256, so that's what I've used.
> I've found additional test vectors for the other functions at
> https://github.com/brycx/Test-Vector-Generation/blob/master/HKDF/hkdf-hmac-sha2-test-vectors.md
> so I'll be using them for adding tests for SHA384 and SHA512 (TLS on
> NVMe-over-TCP is using SHA384, too) and delete the SHA1 ones.

Right, it's an old spec, so that's why it has SHA1.  Using SHA512 test vectors
from elsewhere, or generating your own test vectors using a known-good
implementation, would be fine though.

- Eric
