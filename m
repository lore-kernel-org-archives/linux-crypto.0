Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA8722AE7C
	for <linux-crypto@vger.kernel.org>; Tue, 29 Apr 2025 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745944862; cv=none; b=aB8PGgJByOZN6eiDFNFgYKJgROFoWoNBK+MAcweT/axuDGYhdOpYB1dT/4Ukgo5gkNwU/0a82BHt/2FgWrVyDvaxsiOgCmU02X5g6A9FA8RR2BsuIG1IvsGZ2vVPHOzK2V0KzJ3aFjjx19xKzmG6c6dKXsPF5MYpDW0r3vRQeV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745944862; c=relaxed/simple;
	bh=i6BuMH3Yd2UVM9B6nfAQGZm56UcltSA8KU3h6qndEGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXZZwJHYbU36Pybkj6bkpt/I/wxtEhakPua1PFi/59Aha6Z0+fxoT4e6+79q8stGtCa97ARD1jfTXCqA8aVh8kx6UDtP/nUauEnMAKTbvSRgCcHPvbPE7Cc+d4H4uM/myUxvPJiLthlgfhsbRa4tmmSy7Z7mOqwBXmhccraumg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLnX4yV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLnX4yV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2DEC4CEE3;
	Tue, 29 Apr 2025 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745944861;
	bh=i6BuMH3Yd2UVM9B6nfAQGZm56UcltSA8KU3h6qndEGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kLnX4yV37ZH3O+J9XzoS9iamKmkosuPVr8gGsPshyUuRC9K7lDc+fLbGd99lO6PWY
	 bb3ly+VjhrOXbWnGmYLzNRRquNGNaoafr7cCi4tvh7DEpVJclN0J3BWBG7hnOHFFjB
	 bx4vn+i21feBJ1BZuIZOask19faRDd5ES9NYzkV8CpFe1ob9rroUjSvCb3+0vyLoO4
	 nkXUkeqnu/8psm1hXBJTOleKvslEKIysoJi6OLKGCCnNmSEqxYKoGb8EJsEK6URgHO
	 qNm1wWtIheZB4JSMQvm/x1kWqads3P0dFCWDWKNoBdbxgH6Vk9Pdwug4fNYO9m78zJ
	 R0Slh+CDNmYJA==
Date: Tue, 29 Apr 2025 09:41:00 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] Revert "crypto: run initcalls for generic
 implementations earlier"
Message-ID: <20250429164100.GA1743@sol.localdomain>
References: <aBBoqm4u6ufapUXK@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBBoqm4u6ufapUXK@gondor.apana.org.au>

On Tue, Apr 29, 2025 at 01:50:34PM +0800, Herbert Xu wrote:
> diff --git a/arch/arm/lib/crypto/chacha-glue.c b/arch/arm/lib/crypto/chacha-glue.c
> index 12afb40cf1ff..eb73ff0eaf2e 100644
> --- a/arch/arm/lib/crypto/chacha-glue.c
> +++ b/arch/arm/lib/crypto/chacha-glue.c
> @@ -122,7 +122,7 @@ static int __init chacha_arm_mod_init(void)
>  	}
>  	return 0;
>  }
> -arch_initcall(chacha_arm_mod_init);
> +module_init(chacha_arm_mod_init);

arch/*/lib/ should be kept at arch_initcall.  It makes sense (it's arch/ code);
it's library code with no dependencies on any other initcalls; and it can be
used during initialization of other modules, notably with crypto/ depending on
*_is_arch_optimized().  I understand that this patch sets the initcall level
conditionally depending on whether each individual file uses static keys in
*_is_arch_optimized() or not, but there's no need to add that complexity.  Just
use arch_initcall.  (And FWIW I'll keep doing that arch/*/lib/crc*.c, even if
you decide to mess up arch/*/lib/crypto/.)

- Eric
