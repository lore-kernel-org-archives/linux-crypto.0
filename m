Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81EB34250D
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 18:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776797418; cv=none; b=jrJHGOL7pRRttLuQFA+vaoQIQyitaZFrSplLSacbhCU24hGIFDUAQw/0HvnduDG0NZPuSGj11X0rDA6JWm6Pq3QSlecWNoTe5ECk6MZR9gAecphrS6Sra7cd+lO1T3iCXqLLXfNYpt/yytQ/nxowAtEsYNCs1KcZVjnTj+LeWUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776797418; c=relaxed/simple;
	bh=EPo6FNNjcWhdG4KhP6UIdw5E5GxlSmAr1AfY3wZx2FE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agI7DS3o1jDjBQX+9V803AwT77G6zjyQhU7ZaI8rafR2/9ElbhZDn7VXCw6uy80KkkeE81wY15FAt6Vr91MHqdtBXwz+pk4HJpPqqs9QMZ5eAo+44//WeVTWyPClohqKjz/OQZgUpYj/EoskiCYOkDOmnvq0KDJjSvdv1bBlock=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ujRXaX55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ujRXaX55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A2AC2BCB0;
	Tue, 21 Apr 2026 18:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776797417;
	bh=EPo6FNNjcWhdG4KhP6UIdw5E5GxlSmAr1AfY3wZx2FE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ujRXaX55h+MMxB91Emu4iztTsXp8cUOUgmizRCyGw5mTdo0vOqlRUWFrxaBd0Dh8k
	 PfnqXXV0bTVVemQJ6AFQ3ulkslcVYsU7tICnLNROqyN6Nbs+4LnpkWPHZkjy7sZ+X/
	 j9a6SoZUUHZSyOEfYn+VUTg5vp1RgvlMUzjVYEhfhVQvhOGccCpEz3UyPH9u9QLFLN
	 ZQQIRcMoRrEd/R+NI1HXveAbr15JzUdZQfQceVa0IDhegWqmNlCJfEIkI+NZkLFGVK
	 46nXYnpBh9FXu73ok8ytTRHY7lRxfiidObBpwLeVNmLa+FG6f5JM57NbHHZ5Ay3jEP
	 rhpLtzi73nq5Q==
Date: Tue, 21 Apr 2026 11:50:15 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH] crypto: Drop unused cipher_null crypto_alg
Message-ID: <20260421185015.GB2202@quark>
References: <20260420094120.5167-1-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420094120.5167-1-ardb@kernel.org>

On Mon, Apr 20, 2026 at 11:41:20AM +0200, Ard Biesheuvel wrote:
> The cipher_null crypto_alg cipher is never used in a meaningful way,
> given that it is always wrapped in ecb(), which has its own dedicated
> implementation. IOW, the cipher_null crypto_alg should never be used to
> implement the ecb(cipher_null) skcipher, and using it for other things
> is bogus.
> 
> However, it is accessible from user space, and due to the nature of the
> AF_ALG interface, it may be wrapped in arbitrary ways, exposing issues
> in template code that wasn't written with block ciphers with a block
> size of '1' in mind.
> 
> So drop this code.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/crypto_null.c | 35 ++------------------
>  1 file changed, 2 insertions(+), 33 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
