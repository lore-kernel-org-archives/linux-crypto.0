Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C5D2ECEA3;
	Wed, 18 Feb 2026 21:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771450813; cv=none; b=al03ld3XlRaxooEXyQcwOZ+jNvGddgmkhtv3kzKv2JrOnfEvvNdfSzTVdVE4PG76Pp2dNDPW5qr9RbQSjpB066jnPigTOKGMcPScohWvx+R4KGuvZ2FGE1f6t1XCOMDMpCipPbDn02WhsTpLuKN0NBSlmlmqfga3eoUssH2RzS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771450813; c=relaxed/simple;
	bh=OnNhwTWGy/gIc8Om3z5bDNQcIBpK83c1vmDUBtOLdGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdZRcG/RazQoMGG0++5kvrLODh/11D7Baa6snbofeFpV+AHraMmDap7ef7OiUqSSQRlVPst+FiVKjAbtq8HeDlbUvYg8Uy+kUfYl5wnk+AYC0fpqYDDrk9FEuE+DvDfA1vWjQTe7857H/UgxPfmLPGN7bArQluCxBo0s8fbMBZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FoVc5i96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FoVc5i96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73187C116D0;
	Wed, 18 Feb 2026 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771450812;
	bh=OnNhwTWGy/gIc8Om3z5bDNQcIBpK83c1vmDUBtOLdGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FoVc5i96SJAUmQbtszCb/kqsj8vDjLUA6HIeHKU8lyS+U/nA8WTQCF+sN0/FZNOQW
	 lPknCSE86KipezFLgw8J+DFyNHF4eYVFe7Z3R2z1M54qbcGhz9al2wgH2Hht3bMfCG
	 sikVKakhO6YPrBXk1PZstcoYNGg4g3P9uFXyrRH4TX4Dcbxe54rNUMuF3HwklS6PtO
	 y3qSN/YibzJxa/MIRwoFR1hAXYGqvWnp9FOiS47kRS3wZQsGvOjHcNfDQI+2xb0ihO
	 q8MEtRtu9jVKDbkEQDO8V9c4Tp9dtVlr2jPxH2Pvu5aNvfIwSwaQLZXAYHuu5lsobK
	 N/xEoE+Cs15jA==
Date: Wed, 18 Feb 2026 13:40:10 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] lib/crypto: powerpc/aes: Fix rndkey_from_vsx() on big
 endian CPUs
Message-ID: <20260218214010.GA2128@quark>
References: <20260216022104.332991-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216022104.332991-1-ebiggers@kernel.org>

On Sun, Feb 15, 2026 at 06:21:04PM -0800, Eric Biggers wrote:
> I finally got a big endian PPC64 kernel to boot in QEMU.  The PPC64 VSX
> optimized AES library code does work in that case, with the exception of
> rndkey_from_vsx() which doesn't take into account that the order in
> which the VSX code stores the round key words depends on the endianness.
> So fix rndkey_from_vsx() to do the right thing on big endian CPUs.
> 
> Fixes: 7cf2082e74ce ("lib/crypto: powerpc/aes: Migrate POWER8 optimized code into library")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/powerpc/aes.h | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
