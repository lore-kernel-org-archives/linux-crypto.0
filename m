Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756645;
	b=Ns4vHriPgkrm33JZzykTHidMEM/PGticHhmcIXwk+miLWsm8wAOU0hTlySvLkOC47uYT
	 5UV5+tg5P/VhsYbgUy31yhayRFyJfMQ1OKVVKcxs6YKfpMyUTRyneamHIxix3AvtOWi3+
	 uSHHa/EywNTf1zGWra1geYQf/xtHNgd8Ho1BnZz2v95wfzaLQVcMWCcICls5DfQQtlfis
	 M4Thhwos0gUFksllKY96WxMmUxYuO+q7hjNZdBg5KDlJyNH3POLU7XmTeVqYFka6kJ1+c
	 y6OVYN5JFlCQmiIeTjxTB8tNTHcph9s13WwG+Rq9/SpK5R4jGHe/H06qaqiVct6JT7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756645;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=F395mWU0cbEoWGheGRHm0cHWazZCK9J26O8abSd/6Og=;
	b=Z+E1wkgK0QmgsJo4+uSy/kcnmAjGKvxla4YYbrigQyvRtXOJHoxIqvra0PmjTbTw4RZ+
	 Q3gfUJKlUaNYbokl/KBXGU39a9kqCR9ZZOEMhYn8I/jNfnL6ieZpQziZUe2w98+EoXNtO
	 n1So3zETK88nwtHz1//73MrIJnRXoHOAZp3jtDMOW9AKPVnNqqfrCwIXI61d8PkIZzmU3
	 wYY2i3/ef+q72uCFl3Qfe+PCcOMzorsr1D4GA0XfCx7+Rm+N0Z7ekE2dCHaUFV1AVjMsU
	 JaT5l9ey5FMfqN8mkHM1V75mHXtJPncV3fSup4LiuQy3PTwaQbeyRb2Ojpzu0Zl6lRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=KXlGvOGQ;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021D5606A31C;
	Fri, 27 Nov 2026 05:17:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 021D5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=KXlGvOGQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=F395mWU0cbEoWGheGRHm0cHWazZCK9J26O8abSd/6Og=; 
	b=KXlGvOGQfmG5uzdq3Djo1QuIDeg/qKeYTElU4gxsds4MxA5gbhm29imgZsKrSVxa632aMFbSprt
	i8Fp7r8zhw4FxsyDnrPA4B3hc2lJtN7NL2CDxtLvAhi6YOnVajz/aW5TuEBetS0W+wN7+YhPFn3Rl
	v8/0906RINqrgsgzz+AGbwv1MjKmnn3wYFlzD2neLpIun3ilSA/ch+LmLrhB10o4g1K/cG/S5DMKw
	v1LmljOhWkx9CnpLnlf8qa8KJwoIUrJCzbpdkVQvIKDDzqzwW0ncXqABqRzF0p/UKZrc3+y9yU11j
	E5ByiDCyl7jNMzkixDKPokTzVIRzdCQAcliQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoKn-00000002Vb3-1M39;
	Fri, 27 Nov 2026 13:17:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:17:21 +0800
Date: Fri, 27 Nov 2026 13:17:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: dormancygrace@gmail.com
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: eip93 - return request validation errors
 synchronously
Message-ID: <awkSYfvaBfY7sQe2@gondor.apana.org.au>
References: <20261120-eip93-sync-errors-v1-1-1a83ae607181@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-eip93-sync-errors-v1-1-1a83ae607181@gmail.com>

On Fri, Nov 20, 2026 at 07:37:18PM +0000, Gleb Pesin via B4 Relay wrote:
> From: Gleb Pesin <dormancygrace@gmail.com>
> 
> The skcipher and AEAD paths validate requests before submitting them
> to the hardware. On validation failure they invoke the completion
> callback and return the same error. Callers handle that return value
> as a synchronous failure and can complete the request a second time.
> 
> Return the validation error directly in both paths. Keep completion
> callbacks in the hardware result handlers.
> 
> Codex (gpt-6.2-sol) assisted with comparing the two paths, preparing the
> change and writing the changelog. The corresponding OpenWrt 6.18.64
> driver object was cross-compiled on MIPS.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
> Closes: https://lore.kernel.org/linux-crypto/aXxmIuU9PKJiDs7n@gondor.apana.org.au/
> Signed-off-by: Gleb Pesin <dormancygrace@gmail.com>
> ---
>  drivers/crypto/inside-secure/eip93/eip93-aead.c   | 4 +---
>  drivers/crypto/inside-secure/eip93/eip93-cipher.c | 4 +---
>  2 files changed, 2 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
