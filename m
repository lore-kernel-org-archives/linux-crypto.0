Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7392222BD;
	Mon,  7 Apr 2025 05:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003721; cv=none; b=LLErbMi4UqZiGVeByxgyJQKTtsahSRfJQiCQUjmcynh8E9fLN/LgjG1bAUkpg5ChGG9oNPFVQl/AA6khZtTfy+3CTyuxdvVFsOWoPsKHxazFoeYCnEGvEPB1c+4Uhd2a8zBMuWRo/n4LdnlA7yT/JuRfK/JN+ApoRF46A7LqzI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003721; c=relaxed/simple;
	bh=EFD73LQuFuA1jk+lTSZ1xiPXGUInsrl17qRbwl/9vTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8B0TWvKGFtfbGWfwHGXQPHeek8AlQi5tHCVZilTeFASh6qpazugDVnKYSrhi8ZpryvnukqmSTCAfK8h0NwY8xislUR9HT/QmDBkhBGPe4K1l6YyClziVwuzggq8Jymv0AmnFuiQQoQfeyJIr4v2y33SZT5Z4GHQpPGRtBau0/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QYjSR3HE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QYjSR3HE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7tyMa8I0QJLTVxsdECxREAG+GX7VpZyzgElAp4iFNzg=; b=QYjSR3HEsaYdhv7N53jsUg8t32
	HHzIVjsBHfu5rpPngksHfidV3BggxJmALluXTI/ZcBepMI2Rruzu5jb2bXXSMTNcUcIctcZt1CkpG
	1cfJxojVFH55tFJ5JL9Ryxg2PR9Mj8ixEpAeWoLAinlZXck48I+jWfqTbCnLLXLDM/WWBnOBJgnx6
	2xP5S58wCCqBctBzZVusa6FJU+AMeInWn7rW72TtEDvnusEYJqcqWwqAPyHxXHWueSEl+nceY+9t9
	q6yHaxQbKzZuDrfCJerIOXRi7Z61nUUOlzdkhFf6qjBdY5F37JYdKH44CbQLnKfIZUx/eDjKDI4nE
	Wkm2VEvA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1f2B-00DNMt-35;
	Mon, 07 Apr 2025 13:28:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:28:35 +0800
Date: Mon, 7 Apr 2025 13:28:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 1/3] crypto: x86 - Remove CONFIG_AS_SHA1_NI
Message-ID: <Z_Nig5eZTkFGyfQj@gondor.apana.org.au>
References: <20250404074135.520812-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404074135.520812-1-ubizjak@gmail.com>

On Fri, Apr 04, 2025 at 09:41:00AM +0200, Uros Bizjak wrote:
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
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  arch/x86/Kconfig.assembler        |  5 -----
>  arch/x86/crypto/Makefile          |  3 +--
>  arch/x86/crypto/sha1_ssse3_glue.c | 10 ----------
>  3 files changed, 1 insertion(+), 17 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
