Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C19523182D;
	Mon, 23 Jun 2025 09:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670732; cv=none; b=U74acWGuNmfi1ROopW/T71QPOXO51ghw0T6ijmAtZugQ6CstLlO5qYOuJNYd9ElKltXuykpZHK0NNB1eGht6J1QBz660eBnemW1EdtdN+O3IpFJ3PEAmsTdYhOsnBdh8k844D6RWQhOuJvgCfhdwbLu4kDrhgwP/R4ss1UOfrJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670732; c=relaxed/simple;
	bh=d02BmAZfJ8kB5mE1KMaolAYNYiTWYC3sZlK+9oFtjRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qiRcmH5aeu30dJelbwwkKd8KU8mXjdHtlby6Lk05lC9E/oIT87ALbHbA5+lxAya4Xrv1AuSuiDd6WsEtFzAGaWuOPlvH7WIMbrK5/LAsiHjkKmyTA04n9QVbmPN/7q5qpfvZy9mS682GidCBPPaZ/3dJlUiyNh2GuC0xSGZOmto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cVMD7wrU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cVMD7wrU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+rAAA0ljhuvo9KrQxJ7qfIdHnKBAZ+/9/faUB49NiEI=; b=cVMD7wrUgEz/txjFlHl5Q4gJ1C
	fGfQjtdKewr8CGzO5X+SwEhAbeQWp12uhj9t9IaSn3ZJTdGoapPWtyrAp84s1mXk6d/Lx8MajIDXP
	E+r3GTb9GdXrZ/3Bdy9z/7fXQJ0ucKnu42zw6JsFNgn8JJq8wj5c3WUmC1XH5+am0+asy36b3ehSu
	Jpmhh0e0qlf1A2cGpsfqyfCpLGVZJp97a5LvgXWy4Jff/mK2aNsgg7i0blkL0lQhVvbSpgxM/0A8/
	q2VvlIZEE4vWEfS1ylTsxPfVJ5OiwSbWkUiRRZsUVHmR2tjcbAcTpadjUfAlY03v52M/fp2DzswLQ
	bQgzhPrA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTdB9-000Ffi-1U;
	Mon, 23 Jun 2025 17:25:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:25:23 +0800
Date: Mon, 23 Jun 2025 17:25:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: Restore sha384 and hmac_sha384 drbgs in FIPS mode
Message-ID: <aFkdgzg7J6MA1OhC@gondor.apana.org.au>
References: <20250617193005.1756307-1-jeffbarnes@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617193005.1756307-1-jeffbarnes@linux.microsoft.com>

On Tue, Jun 17, 2025 at 03:30:05PM -0400, Jeff Barnes wrote:
> Set .fips_allowed in the following drbg alg_test_desc structs.
> 
> drbg_nopr_hmac_sha384
> drbg_nopr_sha384
> drbg_pr_hmac_sha384
> drbg_pr_sha384
> 
> The sha384 and hmac_sha384 DRBGs with and without prediction resistance
> were disallowed in an early version of the FIPS 140-3 Implementation
> Guidance document. Hence, the fips_allowed flag in struct alg_test_desc
> pertaining to the affected DRBGs was unset. The IG has been withdrawn
> and they are allowed again.
> 
> Furthermore, when the DRBGs are configured, /proc/crypto shows that
> drbg_*pr_sha384 and drbg_*pr_hmac_sha384 are fips-approved ("fips: yes")
> but because their self-tests are not run (a consequence of unsetting
> the fips_allowed flag), the drbgs won't load successfully with the seeming
> contradictory "fips: yes" in /proc/crypto.
> 
> This series contains a single patch that sets the fips_allowed flag in
> the sha384-impacted DRBGs, which restores the ability to load them in
> FIPS mode.
> 
> Link: https://lore.kernel.org/linux-crypto/979f4f6f-bb74-4b93-8cbf-6ed653604f0e@jvdsn.com/
> Link: https://csrc.nist.gov/CSRC/media/Projects/cryptographic-module-validation-program/documents/fips%20140-3/FIPS%20140-3%20IG.pdf
> 
> To: Herbert Xu <herbert@gondor.apana.org.au>
> To: David S. Miller <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Jeff Barnes <jeffbarnes@linux.microsoft.com>
> ---
>  crypto/testmgr.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
