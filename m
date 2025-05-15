Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30A6374C4
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 02:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747277286; cv=none; b=h5XV8ljsYGMzY/hhywecnhwg3Y+EfzDZ1Yfw0F9WEmjQQD4aHmmxJ++Byll9J8ZT1uOLJkgVVVWbQqWIyXcMDWpBUMrJAW49fS9afA4Zk769o+x5FBcchnhjRrFVx5Pxc5dSRhFWICHFCUl26seL6EuKHfpTjXrD3mWdrVmQxaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747277286; c=relaxed/simple;
	bh=Yso8SdrFX7xem4sCGdhgcvNN6oz4l15pdAc7hcDGrCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hejXUwcSZKWT7SuRkLAtN8irMzqfQoZEMsL4pGfzqo/c5aBEWonGorAouC6Wm3dhXjY20PUa8Nk/6aI0FUXj2IWcfB4JrC203WyAhWIAl0dHHZHpkI3vyT9A1PavPVr0S3+TDO3NnYqT6QMDOjyj1crM5i2zXBNNrlPoscJ1XRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=J3AbJBAx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="J3AbJBAx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MTmuiYlA6Mg26J/Ka73XKpRrupD8xzPizXSM8xfN1tk=; b=J3AbJBAxLP/bneyYBXPLOx9tf2
	OcN6/+HQ3gymVqAQ665E3M+OZu40LLrdsdi4Ov4Zhekoh6mX2E2RzGsC7kTQWcOaMRi0821uKugU5
	zUFVzr0AyWTT79BnrQH1oR0Nz6JojrsuETDimRGfarzyCeD1RoyBKi4DkrDPZE/fLaTjGk4i6h0VO
	v8ATAChCOiHKtBbHOWpBF+JwZUQ9l7Uo2SFL7dUpnUTr5DpLWgKmN8tUZ9+BXzdd+wZGW2qXBQbBr
	lt+4koy3RnkdH/NsNPkhuIhJoIrQ1TQRTmoa7bgJ1tCd3pNzQslmOpAC1PEplgHKEc10d2WLi2hVs
	LNNCX57Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFOdW-006Cvo-33;
	Thu, 15 May 2025 10:47:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 10:47:54 +0800
Date: Thu, 15 May 2025 10:47:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org
Subject: Re: CI found regression in s390 paes-ctr in linux-next
Message-ID: <aCVV2umr3dMk1nkL@gondor.apana.org.au>
References: <ee7489d9b2452e08584318419317f62b@linux.ibm.com>
 <aCVMxAaPW48_Hvm2@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCVMxAaPW48_Hvm2@gondor.apana.org.au>

On Thu, May 15, 2025 at 10:09:08AM +0800, Herbert Xu wrote:
> 
> That's strange.  AFAIK paes shouldn't even be tested.  Can you
> show me what the error looks like?

Oh I had forgotten that we have the special code that turns normal
test vectors into paes test vectors.

I guess we just never ran the extra fuzz tests on paes and now
it's discovering real bugs.  So it's all working as intended :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
