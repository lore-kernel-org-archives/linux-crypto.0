Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627431386DA
	for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2024 07:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732866830; cv=none; b=eVHH3k3QiVBOfKzEHvS4/stSzFg5GpQPljOOFqPB8xFaC38W97AZNfrMb/4JfqEjvzrN+m/MdPsVA5SwaNUKbj1ZKq+i2+6bTqXliQtLycARMYpY31vJtO7y0esb2nomBbsU+S4+CdbtxFW3rG9aMaFHGE0DQYYhccTxadj5Qmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732866830; c=relaxed/simple;
	bh=iHexB0u3SJMC/O+J5kuBVL9M813nkNFaiSxgNonF9dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KGxxnE+r+RpUOW9BgxHZmA990OU/j9TBvinGBjbi5kKCu3W13sdJp06Qx3saaQTgEOqvrthg/vP6TwNZ6XI/s1fcOHvckt5qvZ7A8ZjLDTJE5nygxv/gbNyNaNAdqQzWcigqagV8iE4bcfbYaWNe7Zg9mE7h3Y01OifrNUNohiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MYbyHZbZ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MYbyHZbZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kBU90g0zbJJQ4NqQPadVmh0gJRiHB7AzAcAaoVrZqKs=; b=MYbyHZbZPBLzViDU9DJhVbTfeR
	vN/ILl22qF3OiknGBvGTrh6iiDYkx3f2jMs0bTLLJBSJecIMq1e0JLlV3otZLJGPkAZBhFSCfo/Oc
	A2lF6/I6PK7gjF+LCd3B2gdTbcVvInGTCjxGJX/7JymuZJHRRbJShHr5PrEYJgW4U7bHnGOa3Rwrq
	pvIEO4U4lLn93yNUD4pOy+LW+5fZmqhuWrtlx/CXPJ+SDq9qkrBEMMlPwQ9mShDHSSWfpKX7oMiul
	0hKcO+gzzmi8TAgiG5gE8ysC2AvB8P3CTShWANqMj+ZZ8OtkPAerKQO2uNspXBsPp1ipKB4dRA5l6
	5FBUzelA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tGvof-002LPV-1L;
	Fri, 29 Nov 2024 15:53:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Nov 2024 15:53:29 +0800
Date: Fri, 29 Nov 2024 15:53:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>, Zorro Lang <zlang@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto-2.6] crypto: rsassa-pkcs1 - Avoid pointing to
 rodata in scatterlists
Message-ID: <Z0ly-QVERkD5Wtfu@gondor.apana.org.au>
References: <3de5d373c86dcaa5abc36f501c1398c4fbf05f2f.1732865109.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3de5d373c86dcaa5abc36f501c1398c4fbf05f2f.1732865109.git.lukas@wunner.de>

On Fri, Nov 29, 2024 at 08:46:58AM +0100, Lukas Wunner wrote:
>
> @@ -185,6 +187,16 @@ static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
>  	if (slen + hash_prefix->size > ctx->key_size - 11)
>  		return -EOVERFLOW;
>  
> +	/*
> +	 * Only kmalloc virtual addresses shall be used in a scatterlist,
> +	 * so duplicate src if it points e.g. into kernel or module rodata.
> +	 */
> +	if (!virt_addr_valid(src)) {

Please don't do this.  You cannot turn a virtual address into
an SG list in general.  This is just one of the many failure
scenarios.

The only safe way to do this is for the user to tell us that it's
OK.

So please switch over to the sync interface.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
