Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AD5200B0;
	Wed, 12 Feb 2025 03:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739330395; cv=none; b=OtvN2DIuuNsB9SU6vSutGWoFfjwuAGoQTSFBWz7EDMVvG2Ig07+t0A2qHDARNFQ0+Fz36dZel7uokU3uSn4XJQ3YfqFAH03xvan/xlFOaNHcNhJX1llNf20ES4yYzLSKYcFIeqgAMAD7JBfNc/w5jdY55DaA+7cJxGhvJeiUYVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739330395; c=relaxed/simple;
	bh=emrk25r7Ju6VPNqX1WKWFgI29r9O7Ok1K8rvFaPoRWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKJzyhRiDjEru9DcYl4upe0J62wfXFIAinf7/nEgS1MbwibQUQOHQhE9OzwShhsDAuQEJ3b6hO5HHNulgESrnUGSRhvgif41iwO/cet6VGT4/+VizXaI3GL4iaY41RXvqHylZS7lu5HrRH14Kjuwk+f4OdKbiOes1Qz5e1uiycw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QProW5Ie; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QProW5Ie"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CdogObe4/arI0uarF3hRsRcdANeKic58CbOPj7ItN0g=; b=QProW5IeQgcWp+oQRy7zb5NX9L
	6RgwcAkaWI4zTwRq5okyQht8UuanWyX91eiKKgIVnSiiUQIEnPjbaBrqZEBJ5lmFEC96VSZjIxKwJ
	YvO9uTo6Eq6V19Ov0nN4Nl5yu2cYDcd7BIsFGwtfy2i7Iq+wR1qkSd+kf2247RlmaaNbfPMVdenBR
	MnQR9E7eqQuO9TumFxvgg5uvH33w+XPuKBedoTQ5qhIWo2/AGdijy0rcOroOyzIFAQbuB5EIouQew
	TRkGYIZ3qplquVzalE3AFVgIwvX/et688iGNcglYmKbKu1hgo9pX58f8niZG7oFqtdcSgpiSWVptj
	/02VCjiw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ti34t-00HDBc-2y;
	Wed, 12 Feb 2025 11:19:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Feb 2025 11:19:40 +0800
Date: Wed, 12 Feb 2025 11:19:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: ebiggers@google.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	dengler@linux.ibm.com
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <Z6wTTJz8uUNwT8Gg@gondor.apana.org.au>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <265b5abbf32fcb6748abad7d0ec360cc@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <265b5abbf32fcb6748abad7d0ec360cc@linux.ibm.com>

On Tue, Feb 11, 2025 at 01:09:12PM +0100, Harald Freudenberger wrote:
>
> with your commit
>   7fa481734016 crypto: ahash - make hash walk functions private to ahash.c
> you move the crypto_hash_walk_* functions to private context into ahash.c.
> So for example my new phmac does not compile any more.
> What is the replacement for these functions then? Should I really do
> the scatter walk by my own now or is there a set of new functions to come?

Don't worry about this.  It can easily be reverted once a patch
using it is submitted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
