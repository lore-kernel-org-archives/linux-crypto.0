Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225371D54FA;
	Fri, 18 Apr 2025 14:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744988388; cv=none; b=EW50aHDLXKDNxKhNxugt0QdugaAVVSTeOD2m5Sb9Vdn4InCBMX6omg9jYb/YWsPYdnMfJtrdzGMQ4UGlwvvpm6ysUHswNpKu2P8vhjaJ6wqrGSMp8P6OQgJtUB44CKJNNhf6f5TlgHPYPYTvvSm2I82AFJLllSAxeCr1Z9rUqqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744988388; c=relaxed/simple;
	bh=xkTUgC6sK3DseH4P4/XIAmlFMPEA3HoZdDU7mdTWKF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spHDTEjeNVmEApvSvfkLWRpChJ3ILdNrLoaz2Co7FmvUVRqeIZt9DWa1SQxeJ7Yt7QDCNxsgyAz7+vijrK3WSgzY5G3utNEZEZWJyMYeRpfxYT34M9T+JBDWWKUpLRXA5cANF8/bmXuFWlpWznTFjSA+DyR5duwFtps7nJumgz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lEDQnsKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lEDQnsKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AC3C4CEE2;
	Fri, 18 Apr 2025 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744988387;
	bh=xkTUgC6sK3DseH4P4/XIAmlFMPEA3HoZdDU7mdTWKF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lEDQnsKaOzWYLFnGKIw2Q3T36cmvSrB8guYoOcxkq/ArdOrycc9qReIH8FQRGv8Sv
	 cFCsNJjsOBwDwe064lzJLJqemNDkNQEzAvewY3bLP3/mdh0+IR8y/6AvtmsrTY7nah
	 0i5wkxS/4O+n1vy6Il+3gnLxWUtz7+I9TCFIBnZxRrBLUwoK04xYz9qClIR1tWWhKN
	 rDWq3X3NvSiJScIIkYA/v8gWCD5vGbOFULC/hsqWENWx65hzUtp80qTVT8gsvHPl+k
	 4fUwov6cimurbGaDeNy8pVpj5wo/gl5S6vhlEJrHPk+x3OC/B5vWs5OZnKk78XDSLK
	 G2YTmUKLP1SCg==
Date: Fri, 18 Apr 2025 07:59:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Palmer <daniel@0x0f.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, Jason@zx2c4.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Palmer <daniel@thingy.jp>
Subject: Re: [PATCH] lib/crypto: blake2s: Disable self test if CONFIG_CRYPTO
 isn't enabled
Message-ID: <20250418145945.GA1890@quark.localdomain>
References: <20250418120216.2968994-1-daniel@0x0f.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418120216.2968994-1-daniel@0x0f.com>

On Fri, Apr 18, 2025 at 09:02:16PM +0900, Daniel Palmer wrote:
> From: Daniel Palmer <daniel@thingy.jp>
> 
> Currently CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is used to remove
> the self test code. CONFIG_CRYPTO_MANAGER_DISABLE_TESTS depends on
> CONFIG_CRYPTO so its impossible to disable the self test without
> enabling CONFIG_CRYPTO.
> 
> If you don't want CONFIG_CRYPTO you probably don't want self tests
> so remove the self tests in that case too.
> 
> Fixes: 66d7fb94e4ff ("crypto: blake2s - generic C library implementation and selftest")
> 
> Signed-off-by: Daniel Palmer <daniel@thingy.jp>
> ---
>  lib/crypto/blake2s.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Eric Biggers <ebiggers@kernel.org>

This is okay as a quick fix, but really the lib/crypto/ tests should be
refactored into KUnit tests that aren't dependent on CRYPTO.  FWIW, I recently
fixed this for the CRC functions: lib/tests/crc_kunit.c.

- Eric
