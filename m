Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668ED5695
	for <linux-crypto@vger.kernel.org>; Sat,  5 Apr 2025 02:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743821521; cv=none; b=NL2R38/Qdc1TKA7Wq5hoVi/a7vZFeKvh57fQcVFbeRCCMRFuZC/p7sKsJr9wnlTjFTd/0PUVcauI/C+wH5ArxNVo9NjQD/78H991+D3LvoeUsk8m1hqY09kNP3ZpA8a+dZseCLZU43SQhxmUe4Vt6Inwp2EpaoKsYEqrJYKo3qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743821521; c=relaxed/simple;
	bh=PzDiYIXiT4qV7j99+SEDS7NUkNdgdAH825CcNms1K7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AbDYeheDyCnnG/ofb7HVra39l92rMXOERnrCjvr/Mi5S1blsu4qvNeKBF5zaSCy2f8Q185cRBezA6nKoq5VHVxNifG9bVTTjjMI1A48ycGWGGX2XHZUJixuTs4uvS/i8J1yFIV7XEvR7wZnhtSkcPu5FYLdC6SW99rm3rYy/Wsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akYWiaIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akYWiaIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DCDC4CEDD;
	Sat,  5 Apr 2025 02:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743821520;
	bh=PzDiYIXiT4qV7j99+SEDS7NUkNdgdAH825CcNms1K7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=akYWiaIpudqYuh/RU5mUvUpyjHQ9SsRC2e6O8Q6mWOaTfc1rl/Xm4ye0GFnKPa8j7
	 gZ+ZeFVE+LKlcasCzx4Ym6eGmDPTbgzIBuToPndu2DJim9j28dKoROFtiBWktOHxr5
	 5CRnpTUBPA2mQJZODX/bCDD20PcFMPcig8PvPUfq/F7vWAl8+d+CuF3gricqVC/NTo
	 pArbQE4WLxb+pHEyC0U0GCNnuyJ5uGPP1I7AJ3gSlmXB95HwcLxQaH6UzDK4dfIkvm
	 aWcygHkRedG4WHhMsCSTzmcceB1vJtKZYAO2ussw8u45CCSAxOztaRDMWIdaikrea3
	 oJqStuO7jvsEw==
Date: Fri, 4 Apr 2025 19:51:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 0/3] crypto: arm - drop dependency on SIMD helper
Message-ID: <20250405025158.GA175983@sol.localdomain>
References: <20250403071953.2296514-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403071953.2296514-5-ardb+git@google.com>

On Thu, Apr 03, 2025 at 09:19:54AM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The non-SIMD fallbacks in the ARM skcipher implementations have become
> dead code now that SIMD is always allowed in the contexts where
> skciphers may be used. So remove them.
> 
> While at it, remove the sync CTR helper function now that its last
> users have been dropped.
> 
> v2:
> - drop unnecessary includes
> - add patch #3
> 
> Ard Biesheuvel (3):
>   crypto: arm/aes-ce - stop using the SIMD helper
>   crypto: arm/aes-neonbs - stop using the SIMD helper
>   crypto: ctr - remove unused crypto_ctr_encrypt_walk()
> 
>  arch/arm/crypto/Kconfig           |   2 -
>  arch/arm/crypto/aes-ce-glue.c     | 104 ++----------------
>  arch/arm/crypto/aes-neonbs-glue.c | 116 ++------------------
>  include/crypto/ctr.h              |  47 --------
>  4 files changed, 20 insertions(+), 249 deletions(-)
> 

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
