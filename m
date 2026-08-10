Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB5E3A4F5B;
	Mon, 10 Aug 2026 08:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350992; cv=none; b=N2rAu2/t13AOnGH/id3Aqw2NjyMeGi8fY7uYBz8huf2mGyqaXn3LDJzLRgdsp7kkZkFtn43DK/KM9mB0a3v8Y/szT/8lzVLGRHfU1yUHYSCmvGeEx+Z0/f7sfCKp5Yl5/w3a6z2ojAMpA8/IlUnUM6XqEwXg17z0IleLp0YE2Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350992; c=relaxed/simple;
	bh=3K6QIGzSoTnkd/bPCyHML1D3rQAw29kosHQ3BfgsWdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AzCUo5pYDzZTb6XspNbZqfLC4Wxz9TRf2Inzaw2oPg9gTYwVk2+R0lvH5CRhQCeVtmh1AbHcn6LuSBvbfwnYtW9nq4lSopqMdQ6A4oxEOFe6Q1NXN+aAvQtzZmD7ySngvJmJC/7F4oyA96C+O9cIAZve/SHfaPWQTHXk+sCiIlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Co9qXMi1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Co9qXMi1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=3MRL8R2YEBILpikM7WNq7aKX2HmIpdF2s9ag41x1VJY=; 
	b=Co9qXMi1wJV0ZTN+SQI0nMF5gD9/BXiGz1iw4qnAH6HU3IVuNZskbW7HgBrRPZ2Ysk3llJ9TOZJ
	1AJQbBmv55BQF7b2YHAbTYio8c+5ZXTwIjXEbUM4bObHdnRDN2f0Pyf7Jbt7wTRHQ88zb68Oik0gB
	YrdUGRVMsaLgVzZS39O3pESKItz+lwpd+NmTUfXhzkuvV5ADAA5u+0CGqewIrSYm4uTQSLBF6pfXC
	+6LG5jSjsrg78vKEPDSm33gR40q/HkMk/99toPHRWN6rOnS/aMtGQ1Hw0H2Np0NhAAmGTktnm7eBJ
	jOUuPKNJYg/7+sfhZbotKJyw7BG6awoYjvDw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLUg-00000003WtJ-2NQr;
	Mon, 10 Aug 2026 16:36:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:36:26 +1000
Date: Mon, 10 Aug 2026 18:36:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Richard Weinberger <richard@nod.at>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: af_alg_restrict cleanups
Message-ID: <anmNigs3W1DwtTLG@gondor.apana.org.au>
References: <20260802230055.100746-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802230055.100746-1-ebiggers@kernel.org>

On Sun, Aug 02, 2026 at 04:00:52PM -0700, Eric Biggers wrote:
> - Make cbc(paes) privileged-only for now, as previously discussed
> - Make it more explicit when unprivileged use is allowed
> - Avoid some redundant work during allowlist checking
> 
> Eric Biggers (3):
>   crypto: af_alg - Make cbc(paes) privileged-only
>   crypto: af_alg - Replace 'bool privileged' with flags
>   crypto: af_alg - Stop after finding name in allowlist
> 
>  crypto/af_alg.c         | 10 +++++++---
>  crypto/algif_aead.c     |  2 +-
>  crypto/algif_hash.c     | 28 ++++++++++++++--------------
>  crypto/algif_skcipher.c | 28 ++++++++++++++--------------
>  include/crypto/if_alg.h |  6 +++++-
>  5 files changed, 41 insertions(+), 33 deletions(-)
> 
> 
> base-commit: 947d62c094367ef6064907d570b47612cd579df6
> -- 
> 2.55.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
