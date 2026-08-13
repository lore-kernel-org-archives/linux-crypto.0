Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B95933438F;
	Thu, 13 Aug 2026 02:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786588202; cv=none; b=vEolJkaEFhzvST7w5Qee3dCIktem+ZMZ8K7KITIb54gycOMmtzl2khWLXMyqd8Wlsa6j9sHhOaVzRi2kZVfRi7snoJXmcKp5K4t/kAiuU9v3TShwW2670Xgyqn1VyHr1qjrxys7AM8mMHa8dplKAiwJRCp59o+vRR0BWOsrZCMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786588202; c=relaxed/simple;
	bh=e37jQvjPu6ienyPFNUQhHVhHKZ4lT+Zn0g3sr/ZOofw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtXCut3evwQq6b0H+BgAMRw5WL54deXAgPwMwwqrFwRdJ3vFjjt8n3xQYJQ0kFcOp5aEt/5fFEIqmf7qshYvCgLFMmxYKdpYv5xJAa4sq1CCO0bu2xntSv6YzJXTha28s+1pqCtNbAxvjRqty2Fvdk4TqubXTlPnOIMTEw9X49s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZJI5UAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZJI5UAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9138C1F000E9;
	Thu, 13 Aug 2026 02:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786588201;
	bh=ldA2b5JA/ixOTBjitmdgcewakzqqvq2vOoE+PSMudng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DZJI5UASUQMJzL1iU/e9TrgQ8yToD/YWaV22e7zMKxx85cscP26ZOaa/TBECz49TP
	 jA3W7KOLrh06cDe3GgP7wuQb1sGXfIZOVY33X5Llv+os4hL7U/xxrEEnc7qAbbv6NU
	 rP8YS2Mh0smArYTnjCWkjat13fKxLL+ONsjc4btbIYSDxdmhZpc1nxbKjwpykVNU28
	 8nlF1KcpyJhxEx1HIcaFRS+u+IGRA5b71cCLRNnpUhG5yg1uhLKTGCjQmN3bOptR+7
	 j7Fp0K7vRGEDigTCTJo9PA69a6KHWFC0XLREZ8IxeG02v/V7pUZVc9SFOsnGeADMNT
	 CsfknAs30hXXg==
Date: Wed, 12 Aug 2026 19:27:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 0/3] lib/crypto: Provide a function for zeroizing
 hmac_sha1_ctx
Message-ID: <20260813022757.GB28329@sol>
References: <20260812163336.3103835-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812163336.3103835-1-thuth@redhat.com>

On Wed, Aug 12, 2026 at 06:33:33PM +0200, Thomas Huth wrote:
> It's maybe not worth the effort for hmac_sha1_ctx right now (since there
> is only one spot that forgot to zeroize the structure in case of errors),
> but offering a function for zeroizing the data via __cleanup might help to
> get future code into the proper shape right from the start. Thus let's
> introduce a hmac_sha1_zeroize_ctx() function now and use it in the
> appropriate spots.
> 
> Thomas Huth (3):
>   crypto: Provide a wrapper for zeroizing hmac_sha1_ctx

Subject prefix should be "lib/crypto: sha1:"

>   security: keys: trusted: always clear the hmac_sha1_ctx before
>     returning
>   lib/crypto: sha1: Use hmac_sha1_zeroize_ctx() instead of
>     memzero_explicit()
> 
>  include/crypto/sha1.h                     | 17 +++++++++++++++++
>  lib/crypto/sha1.c                         |  2 +-
>  security/keys/trusted-keys/trusted_tpm1.c |  2 +-
>  3 files changed, 19 insertions(+), 2 deletions(-)

As you probably know, SHA-1 is a bit outdated.  Will these be coming for
SHA-2 as well?  It would be nice to introduce all the APIs at the same
time so that we can make sure they're consistent.  I would actually
prioritize that over introducing callers of them right now, as that can
be done later and often requires acks from other maintainers (and they
can go through other trees as well).

- Eric
