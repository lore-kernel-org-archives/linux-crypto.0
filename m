Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C6015444E
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 06:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723097424; cv=none; b=U/2oDw2rEb8EcniMDaQcQTEQpbn8adlfA+mP+SBy3tQ4eqWlAcIEswlVHmYWilcRMtC/qHb5ZbnfR6eZlRcf9KITBOR2HkSkuI8dTryBA7W4BLCFRLcdS+HQyiX9AZx4gA5P5bVhSen4VMKCsFuuTAYmZiW8HNB3nwYBA37bxgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723097424; c=relaxed/simple;
	bh=/JSJEsTEoWbZIwKsI9fRyxzgGWZjKxTx374gFvrjtbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btAfn8EIFvnjA5mLhKmYWU/A0Fgsg52aZWxKq6w6fqVbjmuL09BBgDMboeBW2wUGEGrPl68agiwgsHsSXqsgZpYNYCTlQbIgJiq0kGbgPq9SbDS5hxKPo7i1IxW2glwpCkwGyfThR0Ir0NB0/sf5jvJknoQIKzlqg/1km8o+i4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sbwDK-003Ed5-0T;
	Thu, 08 Aug 2024 14:10:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Aug 2024 14:10:15 +0800
Date: Thu, 8 Aug 2024 14:10:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Jeff Barnes <jeffbarnes@microsoft.com>,
	Vladis Dronov <vdronov@redhat.com>,
	"marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
	Tyler Hicks <Tyler.Hicks@microsoft.com>,
	Shyam Saini <shyamsaini@microsoft.com>
Subject: Re: Intermittent EHEALTH Failure in FIPS Mode - jitterentropy
 jent_entropy_init() in Kernel 6.6.14
Message-ID: <ZrRhR-IRZPrQ5DSe@gondor.apana.org.au>
References: <DM4PR21MB360932816FA7B848D7D8F7B0C7B82@DM4PR21MB3609.namprd21.prod.outlook.com>
 <2143341.7H5Lhh2ooS@tauon.atsec.com>
 <ZrRUzaPVqoDAcRLk@gondor.apana.org.au>
 <2533289.B1Duu4BR7M@tauon.atsec.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2533289.B1Duu4BR7M@tauon.atsec.com>

On Thu, Aug 08, 2024 at 07:56:39AM +0200, Stephan Mueller wrote:
>
> The user-space version uses an OSR of 3. Using this value, I have not heard of 
> any problems. I will prepare a patch.

Thanks Stephan.  Jeff, could you please let us know if the value of 3
fixes your problems?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
