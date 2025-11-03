Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AEE21E0BB;
	Mon,  3 Nov 2025 17:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762191345; cv=none; b=iKzSqUebc0pcy/Aq2exGLGelXN60E8c5KhPqm0OAg9dDvHFCQnxMNG0rG6dSh50egiZvKz85B/vRCPpwZ/yFEqpTXXJRaGC6KYiz4yZvxPCqRoXEeFxlK0R6fSzrLKCt+mEJCGmUXqlIjoKG0CoUMW6yh2L7rtcPThlVUggrMhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762191345; c=relaxed/simple;
	bh=7SPiUWAHLoxBhCTDibws7Yl4LQL2kpjtzkmha3GEf84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ot0fBKFhQebMyEG8UtVS86Vw+39PBKzb0SnFVtdTZxyYWy12+eulsRLAxOe4dRdfBX37gjxQdCc2HmqUuy3CPPWDn2cT+sFF/GSXGTxMx0TJgiajl+/RgSR2ExQolFW6iuEYtPeJ7VB6mTJpbZnMjTMZQMK3iGwtlz048zeS4iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pZPIoRgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pZPIoRgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F89C4CEE7;
	Mon,  3 Nov 2025 17:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762191345;
	bh=7SPiUWAHLoxBhCTDibws7Yl4LQL2kpjtzkmha3GEf84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pZPIoRglX4r3pT8cy8dscMTi86qawbrv3MJa+fb2vPFIqdcgbS1tLJRIY0AflmhIe
	 Sy2Pm2FF/x/IZnPOn1bXPQyYe1k5v1BRw7F/W6dX++MljtAEo7lvhMs0vdVj2GV7po
	 goOqZC/HJOxabG0vh3zp/lMH56AqB52EELzsh75JG/6QuusS1hV5KuhoiZcQdlZrOg
	 j5tkVOnLbNgAT8YOfYuQqpqMk494FTnyzlKO5HyvjEQ3k7M5VzyTh2dbMv/cI5GiTO
	 AoWVkPt5orwzPuPe+WabxZJ5IxTyMqQbzDeGHgmimWW8LJGZHfuybSjBahPPHkyHam
	 OeLhW9nAhB8Kg==
Date: Mon, 3 Nov 2025 09:34:04 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/15] SHA-3 library
Message-ID: <20251103173404.GE1735@sol>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>

On Sat, Oct 25, 2025 at 10:50:17PM -0700, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git sha3-lib-v2
> 
> This series adds SHA-3 support to lib/crypto/.  This includes support
> for the digest algorithms SHA3-224, SHA3-256, SHA3-384, and SHA3-512,
> and also support for the extendable-output functions SHAKE128 and
> SHAKE256.  The SHAKE128 and SHAKE256 support will be needed by ML-DSA.
> 
> The architecture-optimized SHA-3 code for arm64 and s390 is migrated
> into lib/crypto/.  (The existing s390 code couldn't really be reused, so
> really I rewrote it from scratch.)  This makes the SHA-3 library
> functions be accelerated on these architectures.
> 
> Finally, the sha3-224, sha3-256, sha3-384, and sha3-512 crypto_shash
> algorithms are reimplemented on top of the library API.

I've applied this series to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next,
excluding the following 2 patches which are waiting on benchmark results
from the s390 folks:

    lib/crypto: sha3: Support arch overrides of one-shot digest functions
    lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest functions

I'd be glad to apply those too if they're shown to be worthwhile.

Note: I also reordered the commits in libcrypto-next to put the new
KUnit test suites (blake2b and sha3) last, and to put the AES-GCM
improvements on a separate branch that's merged in.  This will allow
making separate pull requests for the tests and the AES-GCM
improvements, which I think aligns with what Linus had requested before
(https://lore.kernel.org/linux-crypto/CAHk-=wi5d4K+sF2L=tuRW6AopVxO1DDXzstMQaECmU2QHN13KA@mail.gmail.com/).

- Eric
