Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794478536;
	b=pNnIOzDcmLd7Oa4ucyK3PFxCZBflTphaoiajkQ/0JyHM9+QBp9clP0qmZu0EToIVO+a4
	 p+7Zb9zpmWnCe1w6gO+NFzfXTjKq6x06kEgaDTaptstHjU4RMO3dr9CopkAhIKfAntaau
	 1Y+KHYTY3tQnc8Dg/pRdoOzB6hXAxAu3U5/X01M6X1dWk+qAwQszawNJ9tPjbKSjT49Ka
	 S2s5hN0s5C2h8j9rtaTqIUOgCl37CMKgQXgZ0m4ieL7IgMtHZ4N1CkgMJ6ykC800LQqCn
	 CPS3A335C4FkKKJrpb1Q3qn9qLhAIu1gB7j2Su+U1e2/4yuSJxnuxUVt4mcHqhxBwgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478536;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=jGEXQeCUm38UyrjLGty8bX3RGpMJZp9wxl5zMeALPd0=;
	b=JWahCLHMm++3kPqIQxFRPocAJu1yxNGHEGiDb+1q9daMOceGBBUJvXK8J2L29QkQc9VG
	 dcFZYRRGYS6BDQSTVE/z205dIc+Fko8V9TyOVm6ViKPfRN3NTz+T027hJdcOXQ2OmDn2J
	 DgAaSLKq5tiuaxvlGZe3ohDdKfACY3v4+45IROGiwrgv5tiOHojguqRd4Bsadr+nsOyVd
	 2I/JVwlQdGfH77FnDc11n68fRL9LdLvFJgPxQcsAzJ/DiKuG5oJr6HKWC440T6LxIWU8z
	 59L0v8g+tfOaxG6mIeXyjDDfepNadFHpmu9+HPNBsiiLHRelIloGjQHaXqPdMW1++eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=FDRVrZEB;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB7B606A327
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 10:15:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EB7B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=FDRVrZEB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=jGEXQeCUm38UyrjLGty8bX3RGpMJZp9wxl5zMeALPd0=; 
	b=FDRVrZEBjsNgKb40C2NcooI2jO/uzFvwhsw8npBpKrgwMpisA4T92nnWfqLgU2NsE4G9UBQk/tb
	m4RBsgDJ057PE3W3cOvemrraMhXvKmf5EKMMWluJXkWik3Q8lMbe9ABD3CTUkwf7I+0TycB/ez5gS
	mQ7RWBcHS346XwRjFf1MD6GxWbmd1jf/QJ/1p7xHjTV0jH8VQwhHEfKY1u4oE1LfJFPJcQ07ZlFY6
	NgChVx/K8KvrXfOUCkvNQTWFfoOQgLZsP00kPuq0ISLsMnF4AQ4UsAIkrltp3ZyoWrZiies9iCAVe
	M2FE1bYkqbjRgFV8RrEPZAJFmm9C3Q6PXOOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRq8-0000000EEE7-2jVp;
	Thu, 12 Nov 2026 18:15:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 18:15:32 +0800
Date: Thu, 12 Nov 2026 18:15:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - make adf_ae_shutdown() a void function
Message-ID: <avWRxEOu6JGoK-tD@gondor.apana.org.au>
References: <20261030111916.483870-1-ahsan.atta@intel.com>
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
In-Reply-To: <20261030111916.483870-1-ahsan.atta@intel.com>

On Fri, Oct 30, 2026 at 11:19:16AM +0000, Ahsan Atta wrote:
> From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> 
> adf_ae_shutdown() has no failure mode and has always returned 0, yet
> its only caller in adf_dev_shutdown() carries an error branch that
> reports a shutdown failure and skips clearing
> ADF_STATUS_AE_INITIALISED. That branch is unreachable.
> 
> Change the return type to void and drop the dead error handling.
> 
> Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_accel_engine.c | 5 ++---
>  drivers/crypto/intel/qat/qat_common/adf_common_drv.h   | 2 +-
>  drivers/crypto/intel/qat/qat_common/adf_init.c         | 8 ++------
>  3 files changed, 5 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
