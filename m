Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9FD35E1A2;
	Wed,  5 Aug 2026 19:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785959193; cv=none; b=gW6ZJe+UkkK5Q/zPr3iR/PzA/ljgdwoqyBHT9u404tGuynqV7hEf+YUo/RLbaN4YNhfrTt7iLpqO+ZMD737ivYQNJNn5VWAlV7hUeURUuQkm7Fq02JiZQgD5BLoLqZt6Gb1yckX956ax3zGRB1Tp+9pcP9meuAlIvbHxZV1oNIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785959193; c=relaxed/simple;
	bh=lxyJW5Qz3G4OjcRtADdSTPVKDKKlI/d33nva9PSgspA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=frUHPCNhJwdtJA3LcPkysnWJirWZ9MrF6nzDqnn9xgqhy40PUANMWfoFN8TggKJKixX/uvPvnNtdUWH13NCD2YEN+ZFpdk3wvHVnFZyt9SjpILhRuvkjBN1lhs/PT7bmGgHpg30NqkjkbrUYnGP0nqfsCqP9/Dkcw4N2MBh9dLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0C/hNmh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0C/hNmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DC51F000E9;
	Wed,  5 Aug 2026 19:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785959192;
	bh=jIrt1/uMoY8HLEuUAV2v5wZzZkp56wKSAym5jTFEzRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J0C/hNmhQhngWzjQKsZ9s6mBXK7VFb2cZlxnAO6N4KO7Xg+QImLQyjpxAiRW3ZzEa
	 jQe9p2OtoBrE8pmmR07RhSsaUFST79A5n+/YZeKXr7M4qVmN57BffeejJ/Xit1HNs4
	 t0fdxqXI+aOZjMebje9KVwntvsfdcl1vRf/fBVAZgP+aKS3DyPkkVXGoIUh6Q0pcmb
	 ivqNPPrtjFON62PRt7SsA4ShrO5hxbfDpQyurBRYgGMzBqXGmPMzsbw+sTdAZHo7B/
	 2FMGe7lSjA3v2OWca/HLrpUZvrByi4KYoHxI6HPysrL8hwArcqN5Am2vdd62a1I09c
	 XA6lsmuwtpbVg==
Date: Wed, 5 Aug 2026 12:46:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] lib/crypto: FIPS self-tests for AES encryption modes
Message-ID: <20260805194630.GA3438@quark>
References: <20260802222408.91757-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802222408.91757-1-ebiggers@kernel.org>

On Sun, Aug 02, 2026 at 03:24:05PM -0700, Eric Biggers wrote:
> Add FIPS self-tests for all the FIPS-approved AES modes implemented in
> aes.c.  These are needed to exercise the inverse direction of the block
> cipher, and to prepare for the planned integration of
> architecture-optimized implementations of individual modes.
> 
> Eric Biggers (3):
>   lib/crypto: fips: Split fips.h into fips-aes.h and fips-sha.h
>   lib/crypto: aes: Add FIPS self-tests for unauthenticated modes
>   lib/crypto: aes: Add FIPS self-tests for GCM and CCM
> 
>  lib/crypto/aes.c                    | 259 ++++++++++++++++++++++++++--
>  lib/crypto/fips-aes.h               |  78 +++++++++
>  lib/crypto/{fips.h => fips-sha.h}   |   6 +-
>  lib/crypto/sha1.c                   |   2 +-
>  lib/crypto/sha256.c                 |   2 +-
>  lib/crypto/sha3.c                   |   2 +-
>  lib/crypto/sha512.c                 |   2 +-
>  scripts/crypto/gen-fips-testvecs.py | 164 ++++++++++++++----
>  8 files changed, 459 insertions(+), 56 deletions(-)
>  create mode 100644 lib/crypto/fips-aes.h
>  rename lib/crypto/{fips.h => fips-sha.h} (90%)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
