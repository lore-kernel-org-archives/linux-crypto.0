Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FAF1D415B
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 23:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730849285; cv=none; b=Kq1+W2sDM+KGj6524N2thIs+zvwS9wfkhopdz32XXslaxRzjyyDCNbFPTDDVRMJ5l0X2gRY2ZcQHMtAZ3szlkmNABv+Wl20DjUCdmozX/mTRfkQRfDTTF7m8wx/QVQuZs+cJjQbc9b3Tw/VHqAfuGUrK9zGi4k7X79ks0uaCcLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730849285; c=relaxed/simple;
	bh=n1vEPREZon40ka4gmqhaGxi6znmIDfbNDaEW0WyG+mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pFejiSd1+v0uUyUscpOuL5V+eykQpcjYDKFKE80t/DzE+Btn/o3HW+ggkBiduST4UZ0akJnoCFtv7tI/bO+hscXKVf6WfdAgoW03+28y/et/SJ0uCdpZuC3l1uX6vRz2fLguAzlf+iA1wY/zUlf82Hic09xK6W6YObhYEegLKS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TbA5GwUc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TbA5GwUc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4EIfh1RhWadPB7sbiv3iHi27E8qgWoyKC4wG+UNuVpg=; b=TbA5GwUcFtnxdRKpmEe+lFncjS
	JdYoXRNgft0vhRDyjw962TV7L2BCy+gJZTWyw9Pn1eB5Ymy3Tj1f2eYK9kg9Bpj8YMtWqCEQDcAb0
	ntzh3gXCmddAwQ/qOG7rvhPgy60j5naIuvn4BJwiK/OQa/+VopNa0vEcW6Cvu/alujLzcEcY7GOLJ
	SjXfPZL7txb1Xu2TNR95m85wiMsAwfB+UtK8BqI8+n5CgcY/mgp1iOUrpEZdsclB4pb5ysNCYulHJ
	DDzMNgquct4IySAc0MsIPNjD49arTrd0zA/R/Drq1WEoLYPrG1ruMZAu7+71k6Y+hbxmxgaGdHXMh
	RbEEkWJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t8StV-00EkKl-29;
	Wed, 06 Nov 2024 07:23:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 06 Nov 2024 07:23:29 +0800
Date: Wed, 6 Nov 2024 07:23:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, davem@davemloft.net, hca@linux.ibm.com,
	linux390-list@tuxmaker.boeblingen.de.ibm.com,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 3/3] s390/crypto: New s390 specific shash phmac
Message-ID: <Zyqo8UQVBR_exls4@gondor.apana.org.au>
References: <20241030162235.363533-1-freude@linux.ibm.com>
 <20241030162235.363533-4-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030162235.363533-4-freude@linux.ibm.com>

On Wed, Oct 30, 2024 at 05:22:35PM +0100, Harald Freudenberger wrote:
>
> +static int s390_phmac_sha2_clone_tfm(struct crypto_shash *dst,
> +				     struct crypto_shash *src)
> +{
> +	struct s390_phmac_ctx *dst_ctx = crypto_shash_ctx(dst);
> +	struct s390_phmac_ctx *src_ctx = crypto_shash_ctx(src);
> +	int rc;
> +
> +	rc = s390_phmac_sha2_init_tfm(dst);
> +	if (rc)
> +		return rc;
> +
> +	if (src_ctx->key && src_ctx->keylen) {
> +		dst_ctx->key = kmemdup(src_ctx->key, src_ctx->keylen,
> +				       GFP_KERNEL);

Any allocations in clone_tfm must be GFP_ATOMIC since this is
supposed to be used on paths where we can't sleep (otherwise
you could just allocate a new tfm).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
