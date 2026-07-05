Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4DB2D59E8;
	Sun,  5 Jul 2026 08:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240793; cv=none; b=QvLadbf/DX4clMDS+NiZSRU8e4xhwp13yQhADtRqZDsGk4FpRPIVooOVcIItVyeES5aiWjMO/wpgzQmNZSW+Mv7jLhNLlZ3/vM4ZpC1DY75SRB75pAjOXpYxUBU5YkXHNAbAVQe2Se5XGYh5FINPOs3jdFayHbBWJEjZQ+41nuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240793; c=relaxed/simple;
	bh=C3BukSu5erxGjRk+9Bm8skI9hlhX/D75doPj3ONoYBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kYJeoKFs32s4QfmBAv8oJM0P4YyKYGLMN+jXOaoOaFHcwvhWCAtRaCHhA2FbB3XGvNs/YmCCmgttaJik4UfIHxfhsKCCxTnAFug8SUWISBBJ1134owEQCQsqlPAJNopNaQpKmwX+3560MHq4mjSgz8fO3Yiv6IxJg7AeOQDmB6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Y5aao2DG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Y5aao2DG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=FgBp6RJENiz+FGkO6ZKFYN3cdqkjSajz9Mpd8cA5PN0=; 
	b=Y5aao2DGMkbJP2NZ2mZmTaaHd6gu8e4V8fCA9NylYM0lvHZSVWF+yFDc1uL/pFZfUxzRnu27qog
	uko1cCWuaNRtm3xLDEhpeN1ahkUvScHG/iNMvNaYA6aTwWahQofm5DSsmh5+8MAlL0ZV5wF88elIt
	pWzNKxkv7YTJYmNTPFHjaa/BMuVg5deOiIBSE9AixgspoHNPqCYSD2q8yjryA2+9V/xC/wMsqTKG+
	gP4j9jsjWn1AGcEZmvK8L/+O5ELAn1cCC7jSzPV+GUUetB5ADogPmQT60I32FNcSC8UkfV0cQtZMh
	Bt8F+uFIFx2mAZey7MbjPiKBSA2L5t31VuQA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIOB-0000000Al6v-3LGM;
	Sun, 05 Jul 2026 16:39:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:39:47 +0800
Date: Sun, 5 Jul 2026 16:39:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	iwd@lists.linux.dev, linux-hardening@vger.kernel.org,
	Milan Broz <gmazyland@gmail.com>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
Message-ID: <akoYUzceY0bC1jP1@gondor.apana.org.au>
References: <20260622234803.6982-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622234803.6982-1-ebiggers@kernel.org>

On Mon, Jun 22, 2026 at 04:48:03PM -0700, Eric Biggers wrote:
> AF_ALG is a frequent source of vulnerabilities and a maintenance
> nightmare.  It exposes far more functionality to userspace than ever
> should have been exposed, especially to unprivileged processes.  Recent
> exploits have targeted kernel internal implementation details like
> "authencesn" that have zero use case for userspace access.
> 
> Fortunately, AF_ALG is rarely used in practice, as userspace crypto
> libraries exist.  And when it is used, only some functionality is known
> to be used, and many users are known to hold capabilities already.
> iwd for example requires CAP_NET_ADMIN and has a known algorithm list
> (https://lore.kernel.org/linux-crypto/bcbbef00-5881-421b-8892-7be6c04b832d@gmail.com/).
> 
> Thus, let's restrict the set of allowed algorithms by default, depending
> on the capabilities held.
> 
> Add a sysctl /proc/sys/crypto/af_alg_restrict with meaning:
> 
>     0: unrestricted
>     1: limited functionality
>     2: completely disabled
> 
> Set the default value to 1, which enables an algorithm allowlist for
> unprivileged processes and a slightly longer allowlist for privileged
> processes.
> 
> Note that the list may be tweaked in the future.  However, the common
> use cases such as iwd and bluez are taken into account already.  I've
> tested that iwd still works with the default value of 1.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  Documentation/admin-guide/sysctl/crypto.rst | 36 +++++++++++
>  Documentation/crypto/userspace-if.rst       | 13 +++-
>  crypto/af_alg.c                             | 72 +++++++++++++++++++--
>  crypto/algif_aead.c                         | 11 ++++
>  crypto/algif_hash.c                         | 24 +++++++
>  crypto/algif_rng.c                          |  9 +++
>  crypto/algif_skcipher.c                     | 20 ++++++
>  include/crypto/if_alg.h                     |  8 +++
>  8 files changed, 184 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
