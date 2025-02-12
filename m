Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841E51DA60D;
	Wed, 12 Feb 2025 03:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739330626; cv=none; b=Fc0qta+mP4axC0gQbYQ/H2blzrGbmoiV4rD6rcFGONhy/ztw7pGiodK1bRfphpjdVM8FcgWdFG0BA3eo49DEbNfqqeFRZaLIjyPA2gyo7tPiCpP54i4L9gCNXjff+MA3ozH1TUWWXD8WfACO9+5+6RpIDYwgMQpMMn6bTon16wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739330626; c=relaxed/simple;
	bh=hYxwlx7/vJH9aAW0+6mrimxQGN6rJvOzmQdeBkGYI9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ThowZvw1Ti8rlbiQ5WGuwBf5ZS7ovTaPz/nz5WlCc0t9D2LtDjD+axrGnLXnkAtnLYyF7lvHe1EZGOFvwe52cbcJ7CeUYWNTPbGG+v5GBFaJRGDoWwNRe0tViXJjIaYgV9y5EKlUqnp2lgFT6MkKqmyq3qW75yslS+iEuD8i+hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZwDqcpY3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZwDqcpY3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7LNzmLc86QuQXr60IV80LowA60698yLGfQEoOWkwtQY=; b=ZwDqcpY3tRgD7BNmLPRCvsJRF6
	oXoAYGjDTuPCLcOKTS+hiDajQVwdoI7vLB3LAaR/xEa4REE4oHygDDtD9KCqa3aA2IbrauMLMoMbQ
	tiYomR4h8oD8nxJv9+FQFHYvJnP3qnpwa6YP8D/iKWs3UsZGUBz6rL4xEy4YR8l3cFSiFHmNPVP/Z
	k8V6Lo3QL494BWZSUalM2YhLkWu1keKsT1aWKTQL/hwHnBW2Sib4FBUpOM/0giwETOnXWx1FCmK9h
	hozs3agpNWmTuo2mL4ADK0DaJTJDLvB9ljOHPSBGRhbxHfe4bMb5ekPiRSzdl2v/NkGzwM0wEH3t9
	0mO6Kg6w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ti38k-00HDF8-2m;
	Wed, 12 Feb 2025 11:23:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Feb 2025 11:23:39 +0800
Date: Wed, 12 Feb 2025 11:23:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: ebiggers@google.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	dengler@linux.ibm.com
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <Z6wUO-8wPTyzF5SK@gondor.apana.org.au>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <265b5abbf32fcb6748abad7d0ec360cc@linux.ibm.com>
 <Z6wTTJz8uUNwT8Gg@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6wTTJz8uUNwT8Gg@gondor.apana.org.au>

On Wed, Feb 12, 2025 at 11:19:40AM +0800, Herbert Xu wrote:
>
> Don't worry about this.  It can easily be reverted once a patch
> using it is submitted.

I just reverted it in cryptodev.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
