Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CD7243369;
	Sun,  9 Feb 2025 08:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739090895; cv=none; b=HIRztVs0p1Qw0W+S0rnxypauaT9q+nYpAFXB0SufIJBQn7AUml75J61XKgTt98ps7pH0ArQzWd7eejQGpSdm09s7j6Olmktlfzhz0wGyryZKZBPVjD4++cuverfGfzGwobwUEjgamv30VgNuOzvvNMc22+BRDDg+ywGAcevxf8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739090895; c=relaxed/simple;
	bh=QYCRr9epxV+JgAwjDjMvCmaJCw3DkdDYUnW3+84fRis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qKwlc9oXR/r+3lnfpXtt85S3kpSqLwWXyJlv5oX10oOGzh+XJ7OjRVZMMVMJka62zne7er/522Qc2D96w/e709rbbE4bneh12nykjjd/gh6yHylGcub5ltOQRDMMtPu6kgUHEcPad8+FGsmQmESzJaSgbbQxPDzpXjvwQX6t4ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JRGLkU6+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JRGLkU6+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=etMfQ3lxTXvBB4CE6QAlJMLGBD2VqgjbK7uu4PlET9k=; b=JRGLkU6+PT1pm+SylRg2HlgfEZ
	fFka4JiQNBpHBx3m05cwB0OB7Oyy5UUNTnyjINzksT/02ddJrVUNMV0lIf1EuJEdKIou6BNdWLI8h
	mIF9iE9hbhGgZJr+vPZZ4lP4gVFXf3P9vJ/V19ZbAvdreqWY2S+/f4GEgnqgmfxxtjcfJvZUuzHbs
	1gmCTjz6FDggdsyyqhIAuYNx7pU1JV/K27UYMQ+QNfIXm9pWVdf5E0jTzV70jxtGxB1r/WbXzYSju
	AgrHYjnOgAH2fTv25Sy71zqnUT6SyWY/kbpqBCmNaUb2xVFK8KzhDcsnSrOLTpWjlf+FYZIS1/B45
	ALnPKzzQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th2lw-00GHxK-0w;
	Sun, 09 Feb 2025 16:47:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 16:47:57 +0800
Date: Sun, 9 Feb 2025 16:47:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: davem@davemloft.net, dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <Z6hrvQzb5G_wqlni@gondor.apana.org.au>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115162231.83516-3-freude@linux.ibm.com>

On Wed, Jan 15, 2025 at 05:22:28PM +0100, Harald Freudenberger wrote:
>
> +static int s390_phmac_init(struct ahash_request *req)
> +{
> +	struct s390_phmac_req_ctx *req_ctx = ahash_request_ctx(req);
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
> +	int rc;
> +
> +	/*
> +	 * First try synchronous. If this fails for any reason
> +	 * schedule this request asynchronous via workqueue.
> +	 */
> +
> +	rc = phmac_init(tfm, ctx, false);
> +	if (!rc)
> +		goto out;
> +
> +	req_ctx->req = req;
> +	INIT_DELAYED_WORK(&req_ctx->work, phmac_wq_init_fn);
> +	schedule_delayed_work(&req_ctx->work, 0);
> +	rc = -EINPROGRESS;

This creates a resource problem because there is no limit on how
many requests that can be delayed in this manner for a given tfm.

When we hit this case, I presume this is a system-wide issue and
all requests would go pending? If that is the case, I suggest
allocating a system-wide queue through crypto_engine and using
that to limit how many requests that can become EINPROGRESS.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
