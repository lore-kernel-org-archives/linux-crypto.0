Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BC712BEA5
	for <linux-crypto@vger.kernel.org>; Thu, 15 Feb 2024 11:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996999; cv=none; b=eVkLMf4L1PoUm89dcNu3ej6qb4hGhBwqCzph1Pu062Nd++Gss3CN7C8GjwklsLsn+nReki4UiKNBbcXLLdDjVc74AvgdDD3R1QX5uMTPNfRab3sD2RrU+r+Dl93eMUbg2MOeu3T3LyAEBzgpHTeeTdTLMn7aREqJ1nOXW7CYtSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996999; c=relaxed/simple;
	bh=X51dPRS5hGboXMdOZ8eNbrjup3FrLg59u6AWzvt2aDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCwnmEcWhYqL+wCboYAhQiJFrSj0VK8MxIB3/ECUzbmCmrAU/GNVue5hYBvYwUx1aWRaNuj6Z/PJgca4I40j3Yom3i1RHAJNIVcfRHQfLy6fA9/tU3N8HlJWRqub7eTc4t0UFNh5hPpUKz8SNDF1bKR63OH/GRimxMl/dTwbPfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1raa2Y-00Dwar-15; Thu, 15 Feb 2024 19:36:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Feb 2024 19:36:44 +0800
Date: Thu, 15 Feb 2024 19:36:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: HelenH Zhang <helenz98@yahoo.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>
Subject: Re: code question for dh to kernel v6.5
Message-ID: <Zc33TJvFQCNSkjfw@gondor.apana.org.au>
References: <334623130.1130500.1707860532447.ref@mail.yahoo.com>
 <334623130.1130500.1707860532447@mail.yahoo.com>
 <Zc1yebAjAJoY2rwW@gondor.apana.org.au>
 <406531870.1502858.1707996841786@mail.yahoo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <406531870.1502858.1707996841786@mail.yahoo.com>

On Thu, Feb 15, 2024 at 11:34:01AM +0000, HelenH Zhang wrote:
> 
>> n is the number of 8-byte words at this point and is used as such
>> to allocate memory.
> 
> n is the number of 8-byte words. 8 bytes only needs to right shift 3, not 6.

n starts out being the number of bits.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
