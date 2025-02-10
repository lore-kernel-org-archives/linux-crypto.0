Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EFD25EFAC;
	Mon, 10 Feb 2025 23:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739229285; cv=none; b=gk5rgzZaAh7Yv+gEhTZB6kQF9WPPXyPK67gThPH8s+x66cIFQjSUghf/9PmpUNnC+WSU33t4OKicFJybmkdX7SjBex3XvblHkcRX06j7ezuMEr+uwcMYSMfSxqd3hf9lzyHeb8XkPtxhm4Q0VMiGs41UX8kIbhKFWQFCOW3FImE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739229285; c=relaxed/simple;
	bh=COrp6hWGzz8/siYvHimfWfsoXzmyNa/p3dR3OMKEEnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qrf3e8mYWgQ9AY+kvcQNT+86amTcXHA2CplsDBKJ434aOzvficbF9laGMk6P386NzAQycCJzFpNfO2dHWtH358RpgM1+c1d8wI7/8dv+ugYWO3kuHaxA/Q/DB4SqbZgA7Vbbr+v2wJKDvSJwQn8ET8F7knQFuyWhm7tW1GmAGbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WEoASmAk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WEoASmAk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2pClLF4sbthFxm3CTGXCUQu05y9qNQMNR5mihhu0gv0=; b=WEoASmAkNhYWMTh+g9+nnGuSE/
	T/G0eVrAMHE+31fkAylQmhxZOSqM7SPo0iCL22NatKIl8fBHjE9OB0W2yeScR9kpnOZUuhnSbpL0/
	JC2LjlqxqSZCRvZH6C3vLa6sBL4mJJmTNf1HAmNIAgqzHlIaJMEj6bZIm7zi03BqjA6ZoYy/LxoiC
	eOc991GA0uSeeLbhWWqfM4uk2V7cA8yxQc90em64fqfICvr+rxieh3jcVW7GBU3t8YhSVpi2pnS+z
	+saHNY2d2EMdSS3lp+4uXH0KpnHxssRv6YrSurKxMSnaP6u4883jUlSl64apzTgu2m0YRAbEidUrI
	GTLnrRwg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1thclx-00Grrl-2h;
	Tue, 11 Feb 2025 07:14:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Feb 2025 07:14:22 +0800
Date: Tue, 11 Feb 2025 07:14:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, davem@davemloft.net,
	dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <Z6qITvR7LPBjyEf6@gondor.apana.org.au>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <Z6hrvQzb5G_wqlni@gondor.apana.org.au>
 <20250209163430.GB1230@sol.localdomain>
 <Z6mxZ8lfO6zzD7x0@gondor.apana.org.au>
 <20250210163246.GD1264@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210163246.GD1264@sol.localdomain>

On Mon, Feb 10, 2025 at 08:32:46AM -0800, Eric Biggers wrote:
>
> Which is of course entirely theoretical, given that the proposed user waits
> synchronously for each request to complete anyway.  And hardly anyone wants to
> do otherwise since it is way too much of a pain.

We don't design things for a single user.  When you write an
algorithm through the Crypto API, it becomes available to *all*
users.

Just because a single user might be naturally resistant to congestion,
it doesn't make this a non-issue or theoretical.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
