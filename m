Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81297304BCE
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 12:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757937639; cv=none; b=bDdO8w/h2DGOeaTqb8tslR777tnHOR8SkoxsLjoFrTfIYRUuopEBZPzTeTlDUxZKpExEXWhxtKeAP/9SgpbiENB8Ux8xFDTryOdjYZL2xgob8S5IDKkmzkN0iwHaYIEybHDw03d8COrCrFj3rh6plUbLAsRCIZGlp+uJomXIyoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757937639; c=relaxed/simple;
	bh=x2wXx2H1X3WaeJaSo9KcFYK70RCRrudIMLrwFmdQMnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=biVqdPAgrzC1Ui2CmcsE0xqTnQoPZcenEIaRIW/dC9hSioZN5mq3imL9iG+mpZ0xVxga3O10TJQ4TQX+fOjSqbPRwQ1IJXXHqxFZeNdsFCZLG47WxUEtlmBDg7HUKVM8UpeoxoaLLiwMkVBHPXjEZ9ARV7wTBsQU2rK1zA3jK8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=stEoMpHY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="stEoMpHY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yIEuqdO8a/w1qUP+xBMaNU5x5A5tYd0xmQXVDWJg/Eg=; b=stEoMpHYlBNwmN8R/aH38RxwVM
	rQ/yU3t10TjMaTwOlIUkX5PqDQQ7wbIS8MaGX2ncSuZVOskxHy5EQeMJtXSOH5mszVrjjaq+KPCpt
	uayJjKwsOGdQsjyNv6k0/p2VBSaHExE7n0ym89Kl0uAmyZoZPQ25n9oo0QZAVAqrfqb7vvuAMQR/q
	eZYRTxYWs5hD930vb7co5yv6cnqzu5F1K7jivWkC5XtSX1QgEPYMP0dEsYgndBlr7f8oPg9CwrWdx
	dZhwZ6NXv41lc6gLSnO5yIAYpwnqPWUCuIqVvrvIQBQ5KqHWdx30vj+UYkIbP9d6ORA4ZII5muumx
	abqyYvug==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uy7d9-005ZBd-1k;
	Mon, 15 Sep 2025 20:00:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 15 Sep 2025 20:00:19 +0800
Date: Mon, 15 Sep 2025 20:00:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Howells <dhowells@redhat.com>
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
Subject: Re: Adding SHAKE hash algorithms to SHA-3
Message-ID: <aMf_0xkJtcPQlYiI@gondor.apana.org.au>
References: <2552917.1757925000@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2552917.1757925000@warthog.procyon.org.uk>

On Mon, Sep 15, 2025 at 09:30:00AM +0100, David Howells wrote:
> Hi Herbert,
> 
> I'm looking at adding ML-DSA from leancrypto to the kernel to support PQC
> module signing.  This requires some SHAKE algorithms, however.  Leancrypto
> comes with its own SHA-3 implementation that also implements these, but I'd
> rather use the already existing kernel one.
> 
> The problem is that struct shash_alg expects the digestsize to be fixed - but
> with SHAKE this isn't the case.  If it's okay with you, I'll replace the
> digestsize field with a set_digestsize and a get_digestsize function as
> leancrypto does.

I presume the algorithm choice is fixed, right? If so you should be
using lib/crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
