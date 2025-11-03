Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DC631BC96;
	Mon,  3 Nov 2025 17:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762191451; cv=none; b=qrYeNvTlmZvBTMhMmqKydfTJ/oezYm4RlMm7uJZ+nhFU8EjYk/oBqWFoo6zlABMxjzCg7mcrpwcmOjN6gdD9YgHoRUT9Ie8wXEWAzJf3VTyrUyX4b82ASpqMUx6DsUPovQtYWyc+w15kSSfCyrALBuPTBJnaahovVFIRKypJqQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762191451; c=relaxed/simple;
	bh=16w8NQn77ir+9MQ06z54LspF+LEKi8+hdarLmC4ShbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3bK6ZvyyjUUQTFz2NTG+2RDJvEKr3Zay3P+80Qtwy8C61tJS3w38ffcVc6uMTDgQGyjwX301fWiXmcjMm1MPH+qhHxRSOYavz3/iXWVVsQH0NbsCd88b0iIGGXSaszc0EbD6hA9ZqM6842J/h+YFAx7fsEovPeiKe5+/4RZT+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E6HcPHqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E6HcPHqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C501C4CEE7;
	Mon,  3 Nov 2025 17:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762191451;
	bh=16w8NQn77ir+9MQ06z54LspF+LEKi8+hdarLmC4ShbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E6HcPHqbNQsjzq5uoEovbSwiGRjhLS/dPASC83YfBPmr7bFRYzDKGqAD4nAz9UnVA
	 aqu/zfwpbrHSH+2h5BZ65XwnyzAsSxdAyH6Z78UjjhYZwtTbKYmKzj1fZBeaBOh5AR
	 dfLImFt4w1GVRq+UsVui+33L6//Gn+V8D5WOeapE/v7OhgwD6Dn8aLqMG1oYphwa2l
	 jSn6pPPB6aoAV3DuLnoNi7lq83uC4NHLcaS1wZEERMy0OPaR0FBf/R+S0wpg1xU3An
	 +9wO7xBieP0pNr9zf0hdzibL5C4haWhghCcq7hcbC0dEkFPvwgj70hpgAI2XgfvLyd
	 w7VqdItG4uXYg==
Date: Mon, 3 Nov 2025 09:35:50 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
	Samuel Neves <sneves@dei.uc.pt>
Subject: Re: [PATCH 0/6] x86 BLAKE2s cleanups
Message-ID: <20251103173550.GH1735@sol>
References: <20251102234209.62133-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102234209.62133-1-ebiggers@kernel.org>

On Sun, Nov 02, 2025 at 03:42:03PM -0800, Eric Biggers wrote:
> Various cleanups for the SSSE3 and AVX512 implementations of BLAKE2s.
> 
> This is targeting libcrypto-next.
> 
> Eric Biggers (6):
>   lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit
>   lib/crypto: x86/blake2s: Drop check for nblocks == 0
>   lib/crypto: x86/blake2s: Use local labels for data
>   lib/crypto: x86/blake2s: Improve readability
>   lib/crypto: x86/blake2s: Avoid writing back unchanged 'f' value
>   lib/crypto: x86/blake2s: Use vpternlogd for 3-input XORs
> 
>  lib/crypto/x86/blake2s-core.S | 275 +++++++++++++++++++---------------
>  1 file changed, 157 insertions(+), 118 deletions(-)
> 
> base-commit: 5a2a5e62a5216ba05d4481cf90d915f4de0bfde9

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
