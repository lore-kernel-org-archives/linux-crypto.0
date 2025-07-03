Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2683D2EFDB8;
	Thu,  3 Jul 2025 17:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751563277; cv=none; b=lAWuysgeTeaEisHhPeMG2ezFZ7K7O1J3cn1LZA7MKVhPZ2CpxIlxnV5AiFTfF1W3KWmi9M5E3J9HcdPcC/wrMY8JwpYJ4KJbyvqcBB979EwGVuMbCUtb69lK2Wyi8/vhhqgJ5ldl9ZjjfsMhGMqMK2w7YgqQ/ByhyiPrgvbMEWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751563277; c=relaxed/simple;
	bh=QSWSgP88K9/XOwXn+0LAYcUUYUYzmhBKlB//U0h7uNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUDJVLz0256+h/9EDeUxMaAfKM+maLpoJIJQKrwvPRa2wahrdsp7OxG73gHqdZQxHZNtTBiuXHdvAMuDR+YOjx2X6OilmUIdJDTJWxW7/vG9oxxue8mxb/8tI+Hj2rzg+l8BI+Ch1YW0ptjDLpLLSkOnMmgnSWFqZ5FtOqAjLug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmcCscFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmcCscFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D17C4CEE3;
	Thu,  3 Jul 2025 17:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751563274;
	bh=QSWSgP88K9/XOwXn+0LAYcUUYUYzmhBKlB//U0h7uNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cmcCscFGjUVTvi02LFPDrtB4XhBXhIkok/0xvyZvccqVpa4psFK6L82D2SPVCgnSP
	 UdPJc3izafcoHPP8TTH5V6WG52EYUvCR88QaT+1MMONc7pcor0o4bgRAzThfxGcT3A
	 FSH6//LbV9m6na8XsSQZmtvjnGuPaKzSj6CwIvpaGSBEcgCZghfBCKvE6zdoC33ijp
	 +e6dPq/CnEOb4b9LRtSbwgWjcgoK7BPakxin+/56rx+M6egpBw0a2ZzCnxrZEYC0Fu
	 J8UwCAyzEFVzEVJ1YCFwqGK2qEOpKNPFGO4KoKUFjIqjbSi/hBQ3Zxmox1SA9rQjmY
	 RqwZKWNOvznQw==
Date: Thu, 3 Jul 2025 10:20:32 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Joerg Schmidbauer <jschmidb@de.ibm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: s390/sha - Fix uninitialized variable in SHA-1
 and SHA-2
Message-ID: <20250703172032.GA2284@sol>
References: <20250627185649.35321-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627185649.35321-1-ebiggers@kernel.org>

On Fri, Jun 27, 2025 at 11:56:49AM -0700, Eric Biggers wrote:
> Commit 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> added the field s390_sha_ctx::first_message_part and made it be used by
> s390_sha_update_blocks().  At the time, s390_sha_update_blocks() was
> used by all the s390 SHA-1, SHA-2, and SHA-3 algorithms.  However, only
> the initialization functions for SHA-3 were updated, leaving SHA-1 and
> SHA-2 using first_message_part uninitialized.
> 
> This could cause e.g. CPACF_KIMD_SHA_512 | CPACF_KIMD_NIP to be used
> instead of just CPACF_KIMD_NIP.  It's unclear why this didn't cause a
> problem earlier; this bug was found only when UBSAN detected the
> uninitialized boolean.  Perhaps the CPU ignores CPACF_KIMD_NIP for SHA-1
> and SHA-2.  Regardless, let's fix this.  For now just initialize to
> false, i.e. don't try to "optimize" the SHA state initialization.
> 
> Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
> and earlier, we'll also need to patch SHA-224 and SHA-256, as they
> hadn't yet been librarified (which incidentally fixed this bug).
> 
> Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> Cc: stable@vger.kernel.org
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Closes: https://lore.kernel.org/r/12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This is targeting 6.16.  I'd prefer to take this through
> libcrypto-fixes, since the librarification work is also touching this
> area.  But let me know if there's a preference for the crypto tree or
> the s390 tree instead.
> 
>  arch/s390/crypto/sha1_s390.c   | 1 +
>  arch/s390/crypto/sha512_s390.c | 2 ++
>  2 files changed, 3 insertions(+)

I just realized this patch is incomplete: it updated s390_sha1_init(),
sha384_init(), and sha512_init(), but not s390_sha1_import() and sha512_import()
which need the same fix...  I'll send a v2.

- Eric
