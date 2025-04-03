Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBBA1514F6;
	Thu,  3 Apr 2025 16:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743698617; cv=none; b=kHMh/Vc2amRVMnVJqgL5smH384gQ71MN+W/6E8EUuhnJiKZh8M7Aj1AzUEd+w5pLZ2qzV1VNDj6S8uPvj2liGODwlmMJqYEojP2p3EWEa31KLdjR1inB7zM/lVHIwvHLA/+yZCmCqiX+QRsUUQexi5fbmq8xpWlnPOUisiGQBIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743698617; c=relaxed/simple;
	bh=h9Dt/HXu7Jf0P8K9Dik4eWguXuWRX4kHZ2VH5NJVZ88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UvFJI7TU/TJtC+UTlSeU8Rd/L5gpacVURSFRhEsESEl9YNZxlhIGTnE8z4lsDMj6pD/x0b8kbWe4X2cInTulz8gJxIOr8daFO09khTekUrcLLe3yOkeuwQBMOVb0awwy2AqpO5SFno2WyX5irII9J8x3IqZmj7ZXs3BS+otmwMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XWXLwUK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XWXLwUK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7075C4CEE3;
	Thu,  3 Apr 2025 16:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743698617;
	bh=h9Dt/HXu7Jf0P8K9Dik4eWguXuWRX4kHZ2VH5NJVZ88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XWXLwUK2Fy6WHBcqC/Q3b4sTxS22ObNGKUMe9eMINQ9bk/NLTU5/HV2CLEjyIsiKF
	 oku7UFhFPvGrnjNxvrtj1YKXAlfAJQxNThuclI89h1qU2H9KjPJ/4dmIHob8/m9A5E
	 m+Vbxqq6l6aKEsm0xCTZznxcmdSvFxJv1chbfRr//ga3INClzh0CyjaXFRB7v9z65R
	 gUlbJ1A351q9oUGSExDwXpmpqjJWShyuZDrcmmfsTD5Va0dt8ERJE0wUra8+GEnTHE
	 ACXSWHVe6wRokQb4qdz0E5xgsUd5Cvf/oMpcwmgFkcLKAIqp3PgDIhIoFiEMhHECDd
	 KEmEQsmg4icsA==
Date: Thu, 3 Apr 2025 09:43:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] crypto: x86 - Remove CONFIG_AS_SHA1_NI
Message-ID: <20250403164335.GA1241@sol.localdomain>
References: <20250403094527.349526-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403094527.349526-1-ubizjak@gmail.com>

On Thu, Apr 03, 2025 at 11:44:39AM +0200, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.25,
> which supports SHA-1 instruction mnemonics.
> 
> Remove check for assembler support of SHA-1 instructions
> and all relevant macros for conditional compilation.
> 
> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/Kconfig.assembler        |  5 -----
>  arch/x86/crypto/Makefile          |  3 +--
>  arch/x86/crypto/sha1_ssse3_glue.c | 10 ----------
>  3 files changed, 1 insertion(+), 17 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
