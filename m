Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AD31392
	for <linux-crypto@vger.kernel.org>; Thu,  2 Jan 2025 01:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735779847; cv=none; b=lEeRDOWAP7ghXR8741h4gQc40+2GZWSXgJXEugwH/zh3y+DtEnCW32jUAqaJIFEIJK0IzgMq2sv3s0zXfrfXiAtRcSmH8YCSLJ52OBrgsqXUmHXH/s9xD9li5BK1zHiqqkHokSBY2HX1OHO9Kgt5tkad4tGjurfR7fRJrf2qxgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735779847; c=relaxed/simple;
	bh=p687JqiJYkt6xPZCQZ0fAbXEqSLDn+b3onpp7c1yrrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=peHYmmdHH9WB/GLpO8NGRxb5oI/831ndB6ELPccbUiq2HNt7mcQ0cDgEYEyHoCjKbhzoUUdd09flilHAVoP7hmXrf08R8iCIeYez56oUyB/ERvhQqaYOjywVXr/77sBY6Pn5NDZdcX5wxKOa1yCkllJjpWhbkV7gjweU/PFMdF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fL/GruSV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fL/GruSV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6OFdo6jbbHmj1yBB5k/zCrj+qcFnwcPSQxk0Su1iP5c=; b=fL/GruSVsJ/PM5mgQ4aYzbdcyd
	iCdBKhO2ur92Jxe4KkC/IzSnVQK9M3/twAi8eGhg8CiCZJcHCdIoCJ0kHNH3wymHiPZakNWWqPHaA
	sjXJ1harvaqaDPk1quOLod7/LuHc7lrqjY9k1+OHyOq7jXYw7pRQ5CLJuX3A4d0jJ31M2Ytz5yJam
	HnOruYGssh8R7ll+OM/IdiTHG0M1M+KWvLtvz04CiiK2l6HSQy7rfmvPO23atP2V2xm2+ELEQ7wAE
	eW12dwjesMiPBr8tWp29QTaUmSPosrpZrms5P6P/oDPvHhmSqB3C/C+2SgJZdBMmba+ueFts2ySQK
	OrHb62Ew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tT9Q6-004xY4-2d;
	Thu, 02 Jan 2025 09:04:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Jan 2025 09:03:59 +0800
Date: Thu, 2 Jan 2025 09:03:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 07/29] crypto: skcipher - optimize initializing
 skcipher_walk fields
Message-ID: <Z3Xl_8atPGBEmtuF@gondor.apana.org.au>
References: <20241221091056.282098-8-ebiggers@kernel.org>
 <Z2ajd9PdI3noj-oT@gondor.apana.org.au>
 <20241229221011.GA1332@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241229221011.GA1332@quark.localdomain>

On Sun, Dec 29, 2024 at 02:10:11PM -0800, Eric Biggers wrote:
>
> This seems strictly worse than my version, so I don't plan to do this.  It's
> more lines of code, and it causes an extra push and pop to be needed in
> skcipher_walk_virt() to free up enough registers to hold all values at once.  It
> may be intended that API users are supposed to use the helper functions instead
> of accessing the algorithm struct directly, but this code is not a user; it's
> part of the API implementation in crypto/skcipher.c.  There are already lots of
> other direct accesses to the algorithm struct in the same file, and even another
> in skcipher_walk_virt() already.  The helper functions are pointless in this
> context and just cause problems like the one this patch is fixing.

OK, but please add a comment where the accesses occur so that
people won't try to turn this back.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
