Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F4C1AA1F4;
	Sat,  2 May 2026 19:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777749380; cv=none; b=dbqLLprISV01MIvu+Sqwd3JSfe40i3s2PzYX1RSCq+I4wv40zmbQBEhkM7IFNKvCr7WkJ2ReaDuoPHKqFe9eLztavXzjQOSmXlpdsusAWKHsXr+KAjVybsTs4Ya8buICxcZld5u9h+DPbHDOxUkkXsrc20nPyme/TmM/zdTjq9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777749380; c=relaxed/simple;
	bh=7uN3jtPk91aiWMgJ4OW3pQf4zAgfesW+pc9AEaFhR7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLWs3clxm8rVX+4Vk9nTo7wBIzDl/upPFQdl12F3n4SbiDCJZvxDgAjdv86ktJi1HORNYBqawjGxeQLMjXa24LwloCzpBDEi7vucq2uNHQ4yiSJpleh6Kpq1wNOKd/y07bewPshNO1fZcKjVJi04R4SiYQQ4944198dZ1I/N/wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spYDCTMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spYDCTMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B98DC19425;
	Sat,  2 May 2026 19:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777749380;
	bh=7uN3jtPk91aiWMgJ4OW3pQf4zAgfesW+pc9AEaFhR7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=spYDCTMwiWL0uI5Cx79VymlasZX/0jwWul4Yi8AXVZ90zlpg40ewzo6jSIF9Xn6Eq
	 sZn/w/jMJRsB2krSJ8d84PQy8ivb3lsdGXCUZ6eF90RI6dX/Ye8ic6wCsPsPz9PSJn
	 i9m+qfQA7+yMcc4ZteiB6pDbMSeJIgxENMUNLUwQGmfrmRrYvnL+PrrLHHyGTDHdPH
	 kCEKROFHVD19+0eX0eaERxzZQgiknf2xpD24bLx0lwRhTI+ZgNjurNn+cVMz4wB9sk
	 tZh2uyGj2R1SMGukh7RrRK3epG2a7cfJaZ2/Z6t4sDirXGTyiOqSnX8hQ0+gnQkQF0
	 nDCPvUkuYvSKg==
Date: Sat, 2 May 2026 19:16:18 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Jan Schaumann <jschauma@netmeister.org>, iwd@lists.linux.dev,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG hardening
Message-ID: <20260502191618.GA229884@google.com>
References: <87se8dgicq.fsf@gentoo.org>
 <afL-QhLfEKqHZqka@eldamar.lan>
 <20260430071917.GB54208@sol>
 <177abb5d-8ba9-4bb9-8b23-9fbc868ed3cd@gmail.com>
 <20260501180028.GA2260@sol>
 <19837ef5-e5b6-45f4-8336-3ce07423dfb1@gmail.com>
 <20260501201841.GA2540@quark>
 <c13dd3c5-ddc1-431e-bc7d-2de39c551f8e@gmail.com>
 <20260502033556.GA3872267@google.com>
 <3cc88b2d-fbd6-4e47-b82c-3c685fec0581@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cc88b2d-fbd6-4e47-b82c-3c685fec0581@gmail.com>

On Sat, May 02, 2026 at 12:52:57AM -0400, Demi Marie Obenour wrote:
> > Either way, the first step will be to create the algorithm allowlist,
> > which should happen anyway, regardless of the other changes.
> 
> The simplest changes I can see are:
> 
> 1. Get rid of zero-copy support (splice()).
> 2. Get rid of AIO support.
> 3. Only allow software implementations.
> 
> All of these are really simple.  I can send patches, but be warned
> that they would only be compile-tested, as I don't know how to test
> the code.

If you're interested, please send patches, and we'll see where things go
from there.  We need to get more people helping with this stuff.

For (1), it probably should work like the way the zero-copy support was
disabled in the 6.1 LTS kernel last year, where (I think) the splice()
syscall still succeeds but it just copies the data.

For (2) and (3), you can find examples of disabling asynchronous crypto
API stuff at
https://lore.kernel.org/linux-fscrypt/20250704070322.20692-1-ebiggers@kernel.org/
and
https://lore.kernel.org/linux-fscrypt/20250708181313.66961-1-ebiggers@kernel.org/.
Note that to request a synchronous algorithm you have to pass
CRYPTO_ALG_ASYNC (yes, really).

I think there are a few test scripts for AF_ALG in libkcapi.  Besides
that AF_ALG is barely tested.  So you're in good company.

- Eric
