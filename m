Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1A41BBBE5;
	Sun, 23 Nov 2025 20:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763929987; cv=none; b=UmIRLTl54bElMEuRNC87w8GTflRnsoronWCIjZItzAhWF/sBZPDPg7/+cFH56v5buv33weZzS8ze6oz37aMAJwNsIvjLTEuxdhh3aKlEHVxWr68/DIFr1jnnzb2ISuAtmufLCTaaqkogdCHvpUTjJ/wRLHhoffFFdqX/EPIgA78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763929987; c=relaxed/simple;
	bh=o7iJO8dFdTGykgOIvjgpsuygEEKgW58Fr4jClza39eI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCJWQl0jXkpIB6tG0OeISCIPvOgjPsFJykVJdPw6cwzdzvwsN30BBvpR3W58UaXSeHN6eeC/b5O8ZURuRwKTUnDfq/bEHEAPrtavX2okT1qJwcNac5CsODv5tioiERv5gf0ChC0PE0LCIvju8uSTi47mzWJn01fLIWev0ZUKfRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AdLar502; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AdLar502"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0163AC113D0;
	Sun, 23 Nov 2025 20:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763929986;
	bh=o7iJO8dFdTGykgOIvjgpsuygEEKgW58Fr4jClza39eI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AdLar502LAmLVO1hO7ODBN0noHZGJl9MZCUraaqM07vr6rJMLAqKdbSyQv7Ycx5cd
	 SJPJNm/CWpay5lwWWHA8cg2qLeTac5yyi4KB0HDUc3iU9UJnsRTNQnC7Id8l4137XI
	 VakA+BiYXihlG+cdkd0SWFXm+6FWVouPG/vTxzKw0HN6z+wxEaFjEeIg45nZipEhJF
	 YU73ZM5i/EHAk6nGi3TjquqrrYXvpmG2ayJZXDbtE3mRg96iNLm0MlGfIobBXaNjgA
	 LSkl6d3UVUFsfHQyBwx7F+9mXvfbYmyW6sxGiSb/ph5LifdwAqmq8xPtrwJ+S0RhLA
	 k73MZZaDQBFcg==
Date: Sun, 23 Nov 2025 12:31:20 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH 0/6] lib/crypto: More at_least decorations
Message-ID: <20251123203120.GC49083@sol>
References: <20251122194206.31822-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122194206.31822-1-ebiggers@kernel.org>

On Sat, Nov 22, 2025 at 11:42:00AM -0800, Eric Biggers wrote:
> This series depends on the 'at_least' macro added by
> https://lore.kernel.org/r/20251122025510.1625066-4-Jason@zx2c4.com
> It can also be retrieved from
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git more-at-least-decorations-v1
> 
> Add the at_least (i.e. 'static') decoration to the fixed-size array
> parameters of more of the crypto library functions.  This causes clang
> to generate a warning if a too-small array of known size is passed.
> 
> Eric Biggers (6):
>   lib/crypto: chacha: Add at_least decoration to fixed-size array params
>   lib/crypto: curve25519: Add at_least decoration to fixed-size array
>     params
>   lib/crypto: md5: Add at_least decoration to fixed-size array params
>   lib/crypto: poly1305: Add at_least decoration to fixed-size array
>     params
>   lib/crypto: sha1: Add at_least decoration to fixed-size array params
>   lib/crypto: sha2: Add at_least decoration to fixed-size array params
> 

Applied this series to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

The build errors should be gone now, since I rebased it on top of
Jason's v4 patch
(https://lore.kernel.org/linux-crypto/20251123054819.2371989-3-Jason@zx2c4.com/).

- Eric
