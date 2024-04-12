Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A2A4AEDA;
	Fri, 12 Apr 2024 07:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712907132; cv=none; b=tyDCEoXLgmg9/HSBRRJBQ6zFqmJ1JqivHsn1Km1J2dM/dC84M0IH3NaE3JuYe+XOgu4QaQq6VhWxA7zSgMYr2M4wREho3bdJItFKTbPjBvaX9y2eoSGmuNuU82acbXKZunnqKaZU8tC9tjGPEXtdzURp7/SMsR8YMJnzfyExgYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712907132; c=relaxed/simple;
	bh=vS6pr2OtU8Z6I/6LH/5KfxEmrjsgH3NZTYuDXF9jBBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2/hDsAI5w5aDo7h9n6B9b2f4J23oPBfNSXFvswoGcUBUjJpne+2vNOGaJ+Qqp8UrUKjBCw8TTeYA2YXZccRnBIzzCX9K/pX1NvhDR0caIVehCcXp9EtnqC+Fs+KxDjIpPXmd+1/cXMOy62ZfCDH4M1fBbqE2DfsDgyPSX62APM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rvBOF-000llm-98; Fri, 12 Apr 2024 15:32:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 Apr 2024 15:32:20 +0800
Date: Fri, 12 Apr 2024 15:32:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Use cpumask_weight() when rebalancing
Message-ID: <ZhjjhABflstFztrA@gondor.apana.org.au>
References: <afef90304a6985474a9d367efb21423b8c56cc88.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afef90304a6985474a9d367efb21423b8c56cc88.camel@linux.intel.com>

On Fri, Apr 05, 2024 at 01:57:30PM -0500, Tom Zanussi wrote:
> If some cpus are offlined, or if the node mask is smaller than
> expected, the 'nonexistent cpu' warning in rebalance_wq_table() may be
> erroneously triggered.
> 
> Use cpumask_weight() to make sure we only iterate over the exact
> number of cpus in the mask.
> 
> Also use num_possible_cpus() instead of num_online_cpus() to make sure
> all slots in the wq table are initialized.
> 
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
