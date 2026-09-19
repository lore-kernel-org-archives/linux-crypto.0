Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0323D8121;
	Sat, 19 Sep 2026 01:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789782829; cv=none; b=qYK9LxDe+X7JCprxMuCo+AWmvyamrlqlFB9JWI3kaj8Hc1Aw6IL9cZGwHZvsDy3P12CagXuW8cAxa94PdiK1CVVRfN6Hm+hetEuYFOsOBlR3qu0yDuozIvr1g4Z5PWrOxH0632gYOOLrOg3ouay31TIF3YhDulCedRXmpWCUWkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789782829; c=relaxed/simple;
	bh=wLe9OWnfDr11qLYVF8DBDM+OfvRjyRDeaAEbbaPvwig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQtn0JmpE67tnqhuXW4raqhBKMrXxd2Bn4IGbstSwPtQT+Olw6VFwhHRed1JT3Xq0besmO9yT3R4iMxN5ykNBXY2WC4QU2AW9EflFjliW8/UvrgTvBVOQ0CvdT9FpgWPCamuNxNK1lSmw1fhUKiV/1CG4esZ7TRwi76rmYsMzks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=OZQGj+WQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="OZQGj+WQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=emva1d1eEYHqYEnQrO9fNOj1YFovnJ+Shw2XgKOXxgc=; 
	b=OZQGj+WQ2eSVG+orxy7v+JXoXhUeVBTOb9oF4Ruee1pPsMdMrEvX0J9eJDGP4DbvbelLsI3e5aU
	Fu1XeHrMwAuO3yXticWLxtejxd6W3shLEd2RyHyToj19DwCZoWBFy+OjGaXXUiFtrtspOezpvLiZs
	1fF9HAHX+v/mSTy0QLY4Zeu/Bn5M+qcBVo8nlManm0r8te2gi8+kCz7U59gLOqG+PwYruGIJcmeCV
	8qzSXkGmCU+iKkaSvXNwXEeYBZ2wyQ6dSoyoMcbbU+SPgJhR6lsfucMPqPDp+yQcvKeHxV+nSnx2R
	yYMg5EeWoFfyrMPG38D9k/IoWDqTFrVB1wlg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7kGr-0000000Fci4-17fi;
	Sat, 19 Sep 2026 09:53:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Sep 2026 11:53:41 +1000
Date: Sat, 19 Sep 2026 11:53:41 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	linux-s390@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org, ifranzki@linux.ibm.com
Subject: Re: [PATCH v1 0/1] s390/crypto: Generate iintermediate chaining
 value on export
Message-ID: <aq3rJRw-mWKxQfBF@gondor.apana.org.au>
References: <20260814142010.259918-1-dengler@linux.ibm.com>
 <5e9a75a1-54f4-4425-806d-55d27569602e@linux.ibm.com>
 <20260918152641.20386I1b-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918152641.20386I1b-hca@linux.ibm.com>

On Fri, Sep 18, 2026 at 05:26:41PM +0200, Heiko Carstens wrote:
> On Thu, Sep 17, 2026 at 11:13:05AM +0200, Holger Dengler wrote:
> > Can someone please pick this series? Either via crypto or s390
> > maintainers. Thx.
> 
> This should go via the crypto tree. Herbert?

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
