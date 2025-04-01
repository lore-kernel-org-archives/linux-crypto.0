Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347AE2E3398;
	Tue,  1 Apr 2025 03:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743479716; cv=none; b=PVQF13tC8Ih48D11xQre0F/H6bpRWaz1RQOYTfEhAlSO4WVpa3X+RjNIuoI+pvq8kvKjwHrCsk1rpjmYl8PPHIAkL/kA9hxYODABxrHJ6pjLbOpmP86up2sP0bg+KJxL0Z7cmnr6Acu/qnHujIlhlttsCMRrYAvB49+C4vKFS7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743479716; c=relaxed/simple;
	bh=4DI89Kdnjj6kSPWKEchqMVObf0VVVoyCkBWmJoxsySA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V/oQwHar2ZXtiIPH6W+17CNFCzvrQP8/3ExDjK4h82LOd+9wyM8QR4vJ45iKVopkixNkoZoKTU0lTkzJNeUf4s/HHYFgMkCdr83ichS0/1q4e069vZ2ZRo89pNRYvClZAbVNlRS/KIz0uzLn+7rgNtCtqfV8yFbV5mOU+ZcN3f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=E10MYRBV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="E10MYRBV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A8PlVwBjraGpOwYIdORUctCRcKdyBQF4w3RWiSehy7U=; b=E10MYRBVXR7JCggA6d1sYwiVj1
	4esJXk/3UsvOuao2XHUbDyhOVOseJuT3iAV30i3b6YoKFCmIT4JnN8JJXuqeEXC0PUaBnrhN8KhZA
	rVmquPes9BAOvcdiE6RB2m7tFQsYuT7TZNpREYTy2w/OYZuyoYX7oYvBO+VCuzzvLAtyk72suaLmg
	J4BF8TRXHx1ozFuzGg3LZYhgiNQto6yzDtucBysUijOCMPKbO8b4lPvz6vm4eKtRplHxCZqntcSOK
	3NPXX3zCmNnLV+dDi7W2+Nq7GS/34lUMd2Li6pWcXH/fyUdMybqmNBnbauEcW1zjjSSDv2QdzcLZy
	hYJ7Dktw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzSiM-00BjrM-1y;
	Tue, 01 Apr 2025 11:55:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 11:55:02 +0800
Date: Tue, 1 Apr 2025 11:55:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Chaining is dead
Message-ID: <Z-tjluCx71ti6Ngq@gondor.apana.org.au>
References: <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
 <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
 <20250331165630.GA3893920@google.com>
 <Z-tTEjCzpgDr9a-3@gondor.apana.org.au>
 <20250401033303.GA56851@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401033303.GA56851@sol.localdomain>

On Mon, Mar 31, 2025 at 08:33:03PM -0700, Eric Biggers wrote:
>
> - It would add the overhead of keyslot management to software crypto

That seems to be a design error in blk_crypto.  Why should we
model the inadequacies of hardware in software?

If we're going through the software crypto path in blk_crypto,
it should be done as a first-clsas citizen, and not as a poor
man's version of hardware crypto.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
