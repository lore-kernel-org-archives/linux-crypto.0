Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5761F60A;
	Thu, 17 Oct 2024 02:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729132673; cv=none; b=ggbQNhvsEQ/JlmdMRvCoVTd0EWvw+ihLY11gii73YO7K9jEiGhF7H5Z7y6DGkSOTirOu/1iL7LDjOgMrkezPV0Zhhd6SBOL2HxI7tvoog3JHtcGc9D3xRoy+7t5clgpJt5yWRRVYaOi45GCtepU5XGCgbY15x1Ld3ppl2kS9pUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729132673; c=relaxed/simple;
	bh=WSsIBEfsPbip9F6mfb36q0p5MQac5KhNKsxsnPuS9Jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItoDYllRhdcvGcoFPpndnYuxViY4NXTe6a2bWhwc1gLwEIJhbwYpe8bhfXuyhSm/ZcbqHguN8czsQWz+317b11hSzdoDsU4zcztxc4KLczPD/sgBjZlKU/gAwH4W0schCSH2WzK/GLcWaUkbmCulswB0ma9TSJVpvttKQ59juyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+J0z41K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+J0z41K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A077C4CEC5;
	Thu, 17 Oct 2024 02:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729132673;
	bh=WSsIBEfsPbip9F6mfb36q0p5MQac5KhNKsxsnPuS9Jw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b+J0z41KFHQhTIF9rju/4KOx73aHX2pUclKJA/zmf68YgOHlDUYLmNA7+YghWgTng
	 6e4LMtMBsxJLB+b53X1t2hfvUmabSc6vMjKBOMG5oXhSPOACaKZZ+Pij1yEz44UKfR
	 TSMAs/M4GpwuGDDFfJz1o3LW5FkHesYTdWXq9COIp9w2EQ1lz8BR72MsCg/8xPwwnQ
	 jH+/PXj/PHmjxiiHiROid7IrjqdUiwwtDdnPWRhPG0wySvfq6Ro5HCn4iW9zDjOOa1
	 oa3wzoo+vstBzAXePr9t/PuwkHuU9bzuD2gnUQecm3o0MIe7FYUcKovnURd7iwkML4
	 McmEWbgtqMNNw==
Date: Wed, 16 Oct 2024 19:37:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	will@kernel.org, catalin.marinas@arm.com,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v2 1/2] arm64/lib: Handle CRC-32 alternative in C code
Message-ID: <20241017023751.GA1780@sol.localdomain>
References: <20241016192640.406255-4-ardb+git@google.com>
 <20241016192640.406255-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016192640.406255-5-ardb+git@google.com>

On Wed, Oct 16, 2024 at 09:26:42PM +0200, Ard Biesheuvel wrote:
> diff --git a/arch/arm64/lib/crc32.S b/arch/arm64/lib/crc32.S
> index 8340dccff46f..5dac63da4247 100644
> --- a/arch/arm64/lib/crc32.S
> +++ b/arch/arm64/lib/crc32.S
> @@ -136,25 +136,16 @@ CPU_BE( rev16		\reg, \reg	)
>  	.endm
>  
>  	.align		5
> -SYM_FUNC_START(crc32_le)
> -alternative_if_not ARM64_HAS_CRC32
> -	b		crc32_le_base
> -alternative_else_nop_endif

In case you happen to send a new version of this, note that the
#include <asm/alternative.h> can be removed from this file.

- Eric
