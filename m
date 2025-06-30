Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D303042AA4;
	Mon, 30 Jun 2025 16:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751302667; cv=none; b=TdsJa6goczehr/IowKvZDLMyHQ5FL5tn2EYYPDgyV5PC4fw0nDyfqLTDsDe5fL8ALYTzxQldixTImBWj3PcLQzpJylDiPL3pKC9sfa+VbKg4cgztdziB2lM5Lrs2ddPxwMWQhVHto2QneIdyI+51WuqOTfr5LJEbIwHaJ7dAepk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751302667; c=relaxed/simple;
	bh=6Z2Qj+uEHv7Zft5dg+lOnwNTPLU8cLEsi3/Alylcj/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ig5VeCpm0hNYKP5JjwIEbVY8WoG2roqRgn2VeJBLdlZMI++91GkYETh08HkodX/WVL1fOZuIg8DtQZUIQI2jjCZ6E1GD5jx/pUitltmhRHax09fydaetNqeg/gqVJCD4oSDQQx0RFWZ28IucNSRNYFK0NQih6Cqk+R8bYJtAE9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c3usc9UY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3usc9UY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF35DC4CEE3;
	Mon, 30 Jun 2025 16:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751302666;
	bh=6Z2Qj+uEHv7Zft5dg+lOnwNTPLU8cLEsi3/Alylcj/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c3usc9UYaPthaADE9IHDYr2Jh60ChSexp7vPz8BtVSmvbecE5iTmlgRpJcziBG6Vx
	 2azEEG5wkDwT4tsyvbr3Etgu9+nGzjW5OqC6OWIldwNSb3j3I8kwA63MwRBd8Lner7
	 oy5wJAeXFx/2gNDbMPlkg36eSdiENgAMThwMcp7qZI66FjRNiDr4Yo4nNJ3dvpGw7q
	 59vvTOd1OAEYVKnnS/DGeJUoXiBgUSkpmnxLVQTTLynBjIxwFTYqxz6c6BoPYZqwSe
	 iSUNQ5y4yGrxtglwtQ+6y97SdbRRs3HEh15iE+orze9B60qgF3RvEKn6k8MakAJtDY
	 XXH4F5Bz34sTA==
Date: Mon, 30 Jun 2025 09:57:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
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
	"Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: s390/sha - Fix uninitialized variable in SHA-1
 and SHA-2
Message-ID: <20250630165707.GB1220@sol>
References: <20250627185649.35321-1-ebiggers@kernel.org>
 <73477fe9-a1dc-4e38-98a6-eba9921e8afa@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73477fe9-a1dc-4e38-98a6-eba9921e8afa@linux.ibm.com>

On Mon, Jun 30, 2025 at 08:26:34AM +0200, Ingo Franzki wrote:
> On 27.06.2025 20:56, Eric Biggers wrote:
> > Commit 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> > added the field s390_sha_ctx::first_message_part and made it be used by
> > s390_sha_update_blocks().  At the time, s390_sha_update_blocks() was
> > used by all the s390 SHA-1, SHA-2, and SHA-3 algorithms.  However, only
> > the initialization functions for SHA-3 were updated, leaving SHA-1 and
> > SHA-2 using first_message_part uninitialized.
> > 
> > This could cause e.g. CPACF_KIMD_SHA_512 | CPACF_KIMD_NIP to be used
> > instead of just CPACF_KIMD_NIP.  It's unclear why this didn't cause a
> > problem earlier; 
> 
> The NIP flag is only recognized by the SHA3 function codes if the KIMD instruction, for the others (SHA1 and SHA2) it is ignored.
> 

Ah, that explains it then.

> > uninitialized boolean.  Perhaps the CPU ignores CPACF_KIMD_NIP for SHA-1
> > and SHA-2.  Regardless, let's fix this.  For now just initialize to
> > false, i.e. don't try to "optimize" the SHA state initialization.
> > 
> > Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
> > and earlier, we'll also need to patch SHA-224 and SHA-256, as they
> > hadn't yet been librarified (which incidentally fixed this bug).
> > 
> > Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> 
> If this patch is applied on 88c02b3f79a6 then the first_message_part field should
> probably set to 0 instead of false, since only since commit 
> 7b83638f962c30cb6271b5698dc52cdf9b638b48 "crypto: s390/sha1 - Use API partial block handling"
> first_message_part is a bool, before it was an int. 

Yes, when backporting this patch to 6.15 and 6.12 there will be 2 things that
I'll change:

1. Extend it to cover SHA-224 and SHA-256 (which had been reworked in 6.16)
2. Change false to 0

- Eric
