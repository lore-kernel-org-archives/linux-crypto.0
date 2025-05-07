Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D781C84AA;
	Wed,  7 May 2025 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746639036; cv=none; b=C3n/xCI0PPDqY7HHRl8Eptds6AQbAxHx5lPoCFUoPbR/lNqgb4kDV1PSF9e+OLN3MWohmzd9fp+UFlMyTdwIGFOWzdZBIhB1U2LRVZVIaMl0Q7mIasnxPC4Py4ZAOVnq05RouXf+wYtk3qR9pgp6o09uQnSLIWpVwuBo4PvMhsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746639036; c=relaxed/simple;
	bh=BsKdkYXPBa3oS++DBUhi7lIss+ZRPE2J56PmaYOO5JA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBl2xFRn9hDTHdmNpbAlxqPWKTiNUlrPBXbYL+yp7izosv7/1fjdfAi7BoTsAhKx3PMob/Gc6l0mxO4aGM+a/uv6FvMztsjxKC+2bPhppwOgYmnG0gx381ZaSzDOyRtvaBGjNoebx5YCWGMohVBYxPqi0CfbbzcbTjF5MTRBUB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ffCjBDfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ffCjBDfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E21C4CEE2;
	Wed,  7 May 2025 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746639036;
	bh=BsKdkYXPBa3oS++DBUhi7lIss+ZRPE2J56PmaYOO5JA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ffCjBDfdf9z5FtMr+Hyge+HWy3FqkoaAxcBn4IRLNzZkyrkqVJTZarduzFYwBqn0p
	 h66sDt16gNL+Ov6FVkJuOTTU2Bk26+RKE2AWNHPdqXg04lx7X3pn0NEp2Ljtp2jRaA
	 hIGuwyvW/FBXt56ZiPbTj5v3Ee3pun8qwOKg9aAQFncsBtAWf88OUT9iXzj93gMN+l
	 mSx+4S7Oh8rA+kd/wA1bjWLGf67n1CdScOpC67LulLtvhP0rWhiK+evnm8cHLldCXj
	 0sxvpndQLYkDl1ZgCaOS4PRzWJzEVvo+xR2z/tCETklVyKVkf6Wxb5zqheEBOYONXn
	 iBFAoRTUz2kOg==
Date: Wed, 7 May 2025 10:30:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-kernel@vger.kernel.or, lkft-triage@lists.linaro.org,
	Linux Regressions <regressions@lists.linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: next-20250507: arm64 local label `"3" (instance number 1 of a fb
 label)' is not defined
Message-ID: <20250507173031.GC181648@sol>
References: <CA+G9fYvcXTuxC0ncXBQYh8FZE2BxGSuTi6dvN_sWxBRcOAN8tQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvcXTuxC0ncXBQYh8FZE2BxGSuTi6dvN_sWxBRcOAN8tQ@mail.gmail.com>

On Wed, May 07, 2025 at 10:58:18PM +0530, Naresh Kamboju wrote:
> Regressions on arm64 lkftconfig failed with gcc-12 on the Linux next-20250507.
> 
> First seen on the next-20250507
>  Good: next-20250506
>  Bad:  next-20250507
> 
> Regressions found on arm64:
>   - build/gcc-12-lkftconfig-graviton4
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: arm64 local label `"3" (instance number 1 of a fb
> label)' is not defined

Fix was already sent:
https://lore.kernel.org/linux-crypto/20250507170901.151548-1-ebiggers@kernel.org

- Eric
