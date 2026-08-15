Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E7B17C211;
	Sat, 15 Aug 2026 01:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786757608; cv=none; b=RoT7IpVOyAPw3uaDWoJS2rtxba2YQGXBe1bAL71Fr1Gi1c8YXROvZgEBBti5Io7T+/60IUyalus2QkdkqrtQeGlF8lZXa0P4882dNuLG1rX5wElmfBhGHzcU7HyzAaIJZD3hgzFzz3e3d9aDWNpXd7ZJpRjIGeciHKEhEeioziM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786757608; c=relaxed/simple;
	bh=NOTBLLzeADhHogBRZZ2XCWfUnqNZeecfhF2+8ITAJIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cAr7OTqdgTu002TuyCAQKisNlnw1fqpo2orT7t1uRlj19dPrnPG5Aihuvs85wiU1E+4lI6kr3i7OTMix7e2VpWoEEIAU682QT1oFSHmflGie2+fF4NDK8Gakp+6GBbtEZKhAekoitSsDUc0E4Mj4GmdKYF+friR4F9QnaM3IYJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=BkyITeUk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="BkyITeUk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xRn381oaK9zbzeK/m8OATVbyaS34Av/eXYUW/elMIT4=; 
	b=BkyITeUkB6FCnimdadb1UocLt/6GGAfwTZ6dq68RDXwa8NABO/0GcKcL4db2WaJkNbVyOzlmknb
	VMWwLvyixBJBRZDyhEyPJW4wEVRCnVKfaSslVTXWfjHIAW6vjYWGCtNKd/fTVwXht9Bu7YYioYKTu
	mo8Nota2KEsIbEq9Ozy0Ql2+hJ0mOaSghr81Xtq3MGklfyZ/gsHuIiVeAHVi7rpAYKFUZAgfA4fSX
	MAhfek2+mFiS72QYQmD+9OiC/+aME3rPaC7CRLdrESaU6QI5qN9x4Lm5CgsvadJaFbgtocdQ/pxIt
	7GHwCP7fFWCVnWVloQSnxA00Pz1MMP0fGC+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv3H0-0000000559I-3kKg;
	Sat, 15 Aug 2026 09:33:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:33:22 +1000
Date: Sat, 15 Aug 2026 11:33:22 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Huth <thuth@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v5 01/10] crypto: Provide a wrapper function for
 zeroizing crypto_aes_ctx
Message-ID: <an_B4o5xotOSgoUx@gondor.apana.org.au>
References: <20260810093009.608090-1-thuth@redhat.com>
 <20260810093009.608090-2-thuth@redhat.com>
 <05aa107e-36cf-48d2-8190-7a0c10c77dbc@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05aa107e-36cf-48d2-8190-7a0c10c77dbc@redhat.com>

On Thu, Aug 13, 2026 at 04:08:31PM +0200, Thomas Huth wrote:
>
> Just a quick note: I've included an updated version of this patch in the
> series that targets libcrypto here:
> 
>  https://lore.kernel.org/linux-crypto/20260813134953.979481-2-thuth@redhat.com/
> 
> ... so I think I'll best resubmit the remaining patches of this series here
> once the libcrypto series got accepted.

OK, sure.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
