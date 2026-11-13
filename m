Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575216;
	b=2WPG+q+BG/kkyYQfP4eTWRd79FH8fezaoI3JFfJ5Yb5CkvaBejSEWDvFXGkbfNsilJCl
	 ozaI12wAUvB1qIKd9g5XzTtfoaInOvSjGXsClLvp242uCPAaa7BI46YSC0b0ew1cn1pIr
	 kK7ErNsl7cj3mHUAOaQyqA1tEc9AjcZPCSDo0IrYvAQfFYqf0ozlLvmZcRXvYdkh/jgXw
	 ufpbsLzSuD2wlXD+v5wrBGQMedVRJ5ftiS8hS7ZSSxcfpmBOXlvmwDUpfdxs8KmUYdbA1
	 UsHePk8K8PREmFfSfdDQ5p8lyP/XIwX0afEQCDX7ulfJMHqLDvITRf76YQa1He2rRRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575216;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=qMmM1Wqt/V0Guz2zDkNgYZJ/st/cwAavD0MGmpEnxoo=;
	b=4fei65RhjfK4QFS/xUlYFCyXb+m7ZOBQ8mSOsjBkeJ65eKV7MzJKxKOOWWWi55JkHY9/
	 /q1IbZW7cS5Vm5rdExhJKBRbaNbf8sgIDSwNq373izVr3E6Yx7O752r4JMZwFkIbw4XmE
	 +dZ/uKPUTIeVXkK2tb1MmMsfZN4bdlVHd6pIa8jF1m6bS91twPZAtiK5eZ9F5i4N06ZZS
	 gELTtcjsU8ifX4pwx5nvqD7zSireKOAirqztbG3APbC2/Yc0swY/BCB3tJotM4+V2Xp5a
	 ZLEdmUZPJmM9eoFmMRXkQl/qcsOCRBdOW71I/qURVkupYUPlO4kjZr0qjiwhGIAPFWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=gktjeKiR;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFAB606A323;
	Fri, 13 Nov 2026 13:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DFAB606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=gktjeKiR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qMmM1Wqt/V0Guz2zDkNgYZJ/st/cwAavD0MGmpEnxoo=; 
	b=gktjeKiRMDmu1KysWcdWn3TRw+La228RGMINxn1JmKwK3Bjd7DSz9r8jgeBB7782YX4C4kEKYB1
	MkplfPQHl8il5RXkW0gA2Wdhd8gvpX6D+ZOvxengfAUZBaPrWgEgovI2vzxmMI/eO4/gsN+DmYUCs
	PYJfiJrAfJNRCD9qtcdXDSnfIU0joV5P8NcOVH9B9Y/NQzXhDzRaePJziuT7DXQ+0n/N0rQg5we/k
	iUnQ+Fald3QI2OHWYar5n8XXHWW0yLPfazTb0wcg06qSB+3AVj5HLFA5PuNuxdwtALhLJPxcZcPZH
	SSCtNgYO/GlHjKcn2cQRDnyxHIs3q+/Sdjzg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqzU-0000000EfJe-3pGO;
	Fri, 13 Nov 2026 21:06:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:06:52 +0800
Date: Fri, 13 Nov 2026 21:06:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] crypto: ccp - Bump minimum firmware version for
 SEV-SNP support
Message-ID: <avcLbMdvNaIuzfW8@gondor.apana.org.au>
References: <20261103181002.2200214-1-tycho@kernel.org>
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
In-Reply-To: <20261103181002.2200214-1-tycho@kernel.org>

On Tue, Nov 03, 2026 at 11:10:01AM -0700, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> The SEV firmware has received many critical bug and security fixes since
> 1.52. Bump the minimum supported firmware version for SEV-SNP to 1.55
> (first available in linux-firmware release 20230919). See
> https://www.amd.com/en/developer/sev.html for firmware release notes with
> exact bug fixes and CVE details.
> 
> While these macros are called SNP_MIN_API_*, since 6131e119f579 ("crypto:
> ccp - Abort doing SEV INIT if SNP INIT fails") both SEV and SNP fail if SNP
> fails to initialize, so this firmware requirement really applies to SEV
> hosts that are SNP capable at the time of init.
> 
> Also upgrade the debug log to an error log to give people some idea about
> why things failed.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
