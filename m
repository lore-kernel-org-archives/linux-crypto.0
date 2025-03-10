Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C79158538
	for <linux-crypto@vger.kernel.org>; Mon, 10 Mar 2025 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741625765; cv=none; b=G5N+dOjZHUMnkTuM8+sHM7REzR3PZmk6GzdmL4zmvc86kcffZLzjV9fQy96kErPFNdlI2bdCGUGQ8jOXZqcdQx73CCeKm0wHrG2Jhi4RT013sIdSGOl4LqUUk2Ou8xmmER0LUITBM3vuEYrip48Wjtd8JMUHYLFZlLt/ZHqM26I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741625765; c=relaxed/simple;
	bh=+CPNeNPcBE5hSmxSHP+t3AvK1Fef8XRr8Ss46L5YSrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DEEqPWUZVsEq1YB48hObMTbL1I6zHd5MEkcxuIRxLIzPx3OkXCkewz2VAsWbc9cfSH1HkkjL5QUTwYtZFEANgh2Gb2wVf+QwaqLgqiodKKO9BhifI1K4gfketdEHQQ4Q8g8O4IOuIQCW7lXbkumMICehoBmTui8LjxAkPXaOd+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fu4OCT/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fu4OCT/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556BDC4CEEB;
	Mon, 10 Mar 2025 16:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741625765;
	bh=+CPNeNPcBE5hSmxSHP+t3AvK1Fef8XRr8Ss46L5YSrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fu4OCT/5kgePOUzDL4c4/G1Yfdq+B+c/xNIFk4d5WozNQ+7mEuhRjSKU1y1Xgj+no
	 HT5gYSeZ9h0dZYC8bAPohFUv5FZMxb0ENGdMqDOQeqaQ/BYLR0ICvvwfnj+/NK3XNR
	 0dVIDL+7nN5sfUfQhhnorXS9KSuAKalVcD5B+o6bIzJD/8R8NsQDmEMn9Lft51YjOX
	 9vR/3nCBKK1IZk5u6KPZlItMFCxA6WmXAKtKkR4VqcIt0SqfMn5px/EImEPywFNk5b
	 n65v4/AgloT+Knt39xEyvJWXSX03SawQG7LyQtRXSQGbBVm+/q7KGhKXSxIISXQGgK
	 5ty6xEomZEtFw==
Date: Mon, 10 Mar 2025 09:56:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH 0/3] crypto: scatterwalk - scatterwalk_next and
 memcpy_sglist
Message-ID: <20250310165603.GB1701@sol.localdomain>
References: <cover.1741437826.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1741437826.git.herbert@gondor.apana.org.au>

On Sat, Mar 08, 2025 at 08:45:18PM +0800, Herbert Xu wrote:
> v3 renames maddr to __maddr.
> 
> This patch series changes the calling convention of scatterwalk_next
> and adds a new helper memcpy_sglist.
> 
> Herbert Xu (3):
>   crypto: scatterwalk - Change scatterwalk_next calling convention
>   crypto: scatterwalk - Add memcpy_sglist
>   crypto: skcipher - Eliminate duplicate virt.addr field
> 
>  arch/arm/crypto/ghash-ce-glue.c       |  7 ++---
>  arch/arm64/crypto/aes-ce-ccm-glue.c   |  9 +++---
>  arch/arm64/crypto/ghash-ce-glue.c     |  7 ++---
>  arch/arm64/crypto/sm4-ce-ccm-glue.c   |  8 +++---
>  arch/arm64/crypto/sm4-ce-gcm-glue.c   |  8 +++---
>  arch/s390/crypto/aes_s390.c           | 21 ++++++--------
>  arch/x86/crypto/aegis128-aesni-glue.c |  7 ++---
>  arch/x86/crypto/aesni-intel_glue.c    |  9 +++---
>  crypto/aegis128-core.c                |  7 ++---
>  crypto/scatterwalk.c                  | 41 +++++++++++++++++++++------
>  crypto/skcipher.c                     | 35 +++++++++++------------
>  drivers/crypto/nx/nx.c                |  7 ++---
>  include/crypto/algapi.h               |  8 ++++++
>  include/crypto/internal/skcipher.h    | 26 +++++++++++++----
>  include/crypto/scatterwalk.h          | 38 ++++++++++++++-----------
>  15 files changed, 140 insertions(+), 98 deletions(-)
> 

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
