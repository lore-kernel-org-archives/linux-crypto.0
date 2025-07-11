Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D3318D;
	Fri, 11 Jul 2025 21:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752269680; cv=none; b=k25rL+F5u0ycH/DwnAhAWzDKq0WoM5tdj+XziUB63I+IpmywBu1tgrdDINP79qg1ozIFmIW0ZWWAdWkr+ERQ5+CAfx7FPVJsN6YgBb7+JINBaxwVSd3rb1wlQOXVYRDvIeoxoGb3EkNVuSV4nNNg4KMTZK8jMsPUAgj9ThZpO0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752269680; c=relaxed/simple;
	bh=uxNJ3MT7YYUbAGq+i1Gn2JV1vfW0Pg19WuAN9rmZhcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kvwol1+oCA5HkRyIl30G3Jg4eok9AHNmFIKqjofPK9aRuHG6zDCufY+KG7fs/y3iq3Ax5v4tcR1+cNGbAdgnjGiZhhacHJsC9M777LpAWV9Ih3o4yd2rWMIxl8E9YVlOeGgm8MykYHVeiCFXIvTXa81Jqr/9jiL2wOY0NUfpGUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUgdMQJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUgdMQJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6351BC4CEED;
	Fri, 11 Jul 2025 21:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752269679;
	bh=uxNJ3MT7YYUbAGq+i1Gn2JV1vfW0Pg19WuAN9rmZhcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZUgdMQJ2Iy3BlCTXd88qsyzmv3pMv5J+UOnweHa4IEKtdX6MzlDw/GBx79csDQeLz
	 zIS3Sybn/o/bmv4PkKFYAQS0GVdpF2nJyJyEaQbLLpvKnXU8NMzeVGOMvDPny41sJs
	 /HSSyy8DZ8zg5pDeXjS9HbQwOxvRPzQurDixyxhyYr8XLazv5aMEi+jFcBad2sQiVc
	 +IXM2qf4NvIuda5ReO7o4VkoCmKKOHsSpSwLgANEhg/lfMcTTIhUvRFDgXe4+vSjxP
	 8gAhU22W/oMR8exrFOhgS+pn3y1v3IeBV52VHRljd/7iuefvi4HVbT2+YJvz2ZFxOY
	 E2PIP2uHb/9xg==
Date: Fri, 11 Jul 2025 14:34:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sohil Mehta <sohil.mehta@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: arm/poly1305: fix poly1305_blocks_neon link
 failure
Message-ID: <20250711213437.GA4300@quark>
References: <20250711072404.2629868-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711072404.2629868-1-arnd@kernel.org>

On Fri, Jul 11, 2025 at 09:23:59AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The reference to poly1305_blocks_neon from generated assembler code is
> apparently the reason we had the silly __weak function in the wrapper.
> Removing it introduced a link failure:
> 
> ERROR: modpost: "poly1305_blocks_neon" [lib/crypto/arm/poly1305-arm.ko] undefined!
> 
> Moving the reference inside of the #if ARMv7 block avoids this problem.
> 
> Fixes: 16f9e0cc99ec ("lib/crypto: arm/poly1305: Remove unneeded empty weak function")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I see that the neon code is always built when targetting ARMv7, even in
> configurations without CONFIG_KERNEL_MODE_NEON where it is never called.
> I tried cleaning that up as well but couldn't figure it out.
> ---
>  lib/crypto/arm/poly1305-armv4.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks!  That's an interesting one... unfortunately the "perlasm" files
are kind of a mess.

To avoid a bisection hazard, I'm replacing the original patch with an
updated version that includes your fix:
https://lore.kernel.org/r/20250711212822.6372-1-ebiggers@kernel.org

- Eric
