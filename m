Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFD81946CA;
	Wed,  5 Jun 2024 09:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717580794; cv=none; b=R/+6u+oDkhxOBn+eRYzWzarfyxRUpTobeS913JRcBeJazbS0aJgy29a6Qk01+ytSJ9fKtOHBeiKzyEVGzz7IjsPXuGSjSmnC/r6EsslW6RCdz0q/LFtmTuXRVaaQJPowq/LIPi8fAuU36Ra6Ml2GstGR8/Xg6hNTLIQns8DdWB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717580794; c=relaxed/simple;
	bh=N/XcE/peJnE3AD34Jonq4zKuWhzLKlbhgTJDxZKby5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qy2QCozTHG8MZpJAEc2LYdbKmXnGW4f5mfUYvN35KGfVYCYSROK7Si7haAaUDzyK1Nmo3thHbzYVmPMQq7mEldFvLS9HIrWgR4/JZ2JdmGk+J5c7dfPQHp16of5s3U2Xe4S1AUN029hutldMHAj3YwemN7gBOTC1mNQPf/sNE+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sEnDt-005tuj-0L;
	Wed, 05 Jun 2024 17:46:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Jun 2024 17:46:27 +0800
Date: Wed, 5 Jun 2024 17:46:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZmAz8-glRX2wl13D@gondor.apana.org.au>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-7-ebiggers@kernel.org>
 <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
 <20240604184220.GC1566@sol.localdomain>
 <ZmAthcxC8V3V3sm3@gondor.apana.org.au>
 <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmAuTceqwZlRJqHx@gondor.apana.org.au>

On Wed, Jun 05, 2024 at 05:22:21PM +0800, Herbert Xu wrote:
>
> However, I really dislike the idea of shoehorning this into shash.
> I know you really like shash, but I think there are some clear
> benefits to be had by coupling this with ahash.

If we do this properly, we should be able to immediately use the
mb code with IPsec.  In the network stack, we already aggregate
the data prior to IPsec with GSO.  So at the boundary between
IPsec and the Crypto API, it's dividing chunks of data up to 64K
into 1500-byte packets and feeding them to crypto one at a time.

It really should be sending the whole chain of packets to us as
a unit.

Once we have a proper mb interface, we can fix that and immediately
get the benefit of mb hashing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
