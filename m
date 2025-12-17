Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A133101A6;
	Wed, 17 Dec 2025 23:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766015867; cv=none; b=P9DFcyCam3tO9uik/YcaXjfNgUBRSQxziPUscboWhvFUF0LQ77Pf7QaKYL+lD2oT5P7imuucYxKtDg1Hbzyyq22g/SfbAsw2JGe+0vm1PEBjk80uLu5/xS/v258A9JhKCMpocbTguzP6pgm7BDAzXci1kPsVPNs20i+sYyhWZtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766015867; c=relaxed/simple;
	bh=0MQVXoPZt5do7P7n7SWEqJce27v0zvKvJL9bInS7rq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZV7VyIv2cRbWIos8tbU9w25WWL18iPq5jGvGE7UjrhefK30kK/dDFt+A1nRhVm6aB4JtYwV9MOBqBeqZvkC9LRdZOyBWkA95qAv5/jZjxFZ+jjtDtlhyqJnl9F1NScSN9cVowZTOiU9q1haK5S/Kx8P80GYkZUtUr7XieVBMG5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tmvs+vBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tmvs+vBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DD9C116B1;
	Wed, 17 Dec 2025 23:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766015867;
	bh=0MQVXoPZt5do7P7n7SWEqJce27v0zvKvJL9bInS7rq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tmvs+vBwefHZC9rjP+BGSEP17ne6/SUGvmaWPwJBCbaZDsD6B0hD5asyuttFy8DDB
	 dcepLRaU0vSmdShbQQ08Ha2vL4NikBEfQrAauMYcdwbIW3isXkeAG0vodfXAKqtlOH
	 K2FcjPDA4jvy13wI5uFtP457OWac2Hp9yJz5rxHl7MU1FomkqFpHWqvUU19ngGE5Wp
	 JyA0dmvPcR/cw3WbdmMdmF5ZVCVxlW3UZlUWqkn30iqNi+iOhUGJ8HjIRv6O8Lw57F
	 tz9XdIE717X1a2YUKkqX/j96+ytsa7zSj+zglN5rpms/D/xHvGaXj+ookfgsWd+Bu5
	 5EzV2ZdNf9p5A==
Date: Wed, 17 Dec 2025 23:57:45 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ross Philipson <ross.philipson@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Jason@zx2c4.com, ardb@kernel.org, dpsmith@apertussolutions.com,
	kanth.ghatraju@oracle.com, andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: Re: [PATCH] crypto: lib/sha1 - use __DISABLE_EXPORTS for SHA1 library
Message-ID: <20251217235745.GB89113@google.com>
References: <20251217233826.1761939-1-ross.philipson@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217233826.1761939-1-ross.philipson@oracle.com>

On Wed, Dec 17, 2025 at 03:38:26PM -0800, Ross Philipson wrote:
> Allow the SHA1 library code in lib/crypto/sha1.c to be used in a pre-boot
> environments. Use the __DISABLE_EXPORTS macro to disable function exports and
> define the proper values for that environment as was done earlier for SHA256.
> 
> This issue was brought up during the review of the Secure Launch v15 patches
> that use SHA1 in a pre-boot environment (link in tags below). This is being
> sent as a standalone patch to address this.
> 
> Link: https://lore.kernel.org/r/20251216002150.GA11579@quark
> Cc: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ross Philipson <ross.philipson@oracle.com>
> ---
>  lib/crypto/sha1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
> index 52788278cd17..e5a9e1361058 100644
> --- a/lib/crypto/sha1.c
> +++ b/lib/crypto/sha1.c
> @@ -154,7 +154,7 @@ static void __maybe_unused sha1_blocks_generic(struct sha1_block_state *state,
>  	memzero_explicit(workspace, sizeof(workspace));
>  }
>  
> -#ifdef CONFIG_CRYPTO_LIB_SHA1_ARCH
> +#if defined(CONFIG_CRYPTO_LIB_SHA1_ARCH) && !defined(__DISABLE_EXPORTS)
>  #include "sha1.h" /* $(SRCARCH)/sha1.h */
>  #else
>  #define sha1_blocks sha1_blocks_generic

Shouldn't this be part of the patchset that needs this?

Also, when __DISABLE_EXPORTS is defined, only the functionality actually
used by pre-boot environments should be included.  HMAC support for
example probably isn't needed.

The commit title is also misleading.  How about:
"lib/crypto: sha1: Add support for pre-boot environments".

- Eric
