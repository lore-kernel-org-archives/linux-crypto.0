Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FD525DB16
	for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2025 09:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742808615; cv=none; b=WZVimeDhS2QZiMoOgiBOKAVyps51xVBZWV1hnZLnOcWiqYys/VsiShD4OsGUHD2VBtLadQOQESzvrCq2weWTFKEW9xJHOaFYDp7sXjTkUo8l6um2ByxAA6TqefgwW3Hi/ks0/yl7IbGtNIG16VTeOMWUD/+hcjGD3Wtv9Rbv+JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742808615; c=relaxed/simple;
	bh=C5qLkuDFuohNHnIlOKIY99ud+du+AbbW20sTZjEQ7gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLfi6ndzuXQLZvE5h+x1FiNuzHOz7Df0h8e0mBK8rPRqp+kje9JoWpZfoQ3WZQenRiP75J6PUImRMpV4weGUWqrIqVwrFiI2smeei/lifliJvRJx6Lrs0eyu+L8CkFCXmaV9A+Oo6BrNetcdN20ZqxPtBLw+8DoeHkunY1W9p34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TNRC/GVU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TNRC/GVU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BSwN0BTB3PliBGyhfvxFypPSTo5ytnssbY6L/ZPPLFs=; b=TNRC/GVUm4b4rS2bgRRDUHbYde
	oqw7Vqas067b6ibZwUvKlLDTMU3zl5fy+IkpIu1Mv1P+3YIOfaET3hADy+Tlxg9EK1ANJUDPuAK8P
	vKsWnpb5325lDe3/yAws+E1J/vf+IMnGgP9ebLKusZyblzDenT08lex5Uh+T29HgDFbYmWYs3Sq3D
	OIlQqAS8YOvToBrWmz5Guc6yC/pfof4reuyfu4lrCHRG8YHIJdSj1j281R4Uw2Hf/dBH/HyGPXXgw
	I6CULzfXasUz8IqPCfK9MgFDLhqjtuAdaVphYtbaYDy5X7UxbADLLrO1G3+d4tZNlXvSy3bczg9He
	GFDDZCtg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twe8F-009fua-2C;
	Mon, 24 Mar 2025 17:30:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Mar 2025 17:30:07 +0800
Date: Mon, 24 Mar 2025 17:30:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gaurav Jain <gaurav.jain@nxp.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>
Subject: Re: [EXT] caam hashing
Message-ID: <Z-EmH9n5u05iJ47p@gondor.apana.org.au>
References: <Z-AJx1oPRE2_X1GE@gondor.apana.org.au>
 <DB9PR04MB840907ADF03612B64D1CF910E7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>
 <Z-ESpJxIG8jTGHZM@gondor.apana.org.au>
 <DB9PR04MB8409D73449B57FABE1B3031CE7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB9PR04MB8409D73449B57FABE1B3031CE7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>

On Mon, Mar 24, 2025 at 09:26:20AM +0000, Gaurav Jain wrote:
>
> I discussed the same with Horia. data loaded into or stored from caam_ctx is message data which is regarded as byte strings.

So is it big endian?

> Also, we want to understand why it is needed? as this data is interpreted by caam internally.

I'm trying to make all drivers export their hash state in a format
that is compatible with the generic implementation.  That way if
there is a memory allocation error, we could just fall back to the
generic algorithm even if we are in the middle of a hash.

Obviously if you export then you'd need to import as well.  So I
need to be able to import a generic hash state into caam and continue
from there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
