Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898D42AF16;
	Sat, 21 Dec 2024 08:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734771448; cv=none; b=R3C40WpvK+T8Ya4vKaeZstDVpusGiV/62QAth6Qxq9nm+JCyWR9xbj6LcjffZTiLN7hX+g8fpTa6cbtHQQbeAVs9f+/BOXxRFE62yvU/BMyh8n18pe7uXzPYjn/SCLJSqZqYNJszx2hQVpEoQIGN0GOi7JmmAbDF17vXKsfrYwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734771448; c=relaxed/simple;
	bh=DL1nckMrNqYSmoo8ndycUOmfoPMkmyOPi8N+3W32EM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bw6BI3caamz2omosFzIl0oTZ9mQSOY34dp1Tx5qL6xqoSSbhBVLuGIhwIHbglf4zYiY7GUjCq7ip/0ne9v39jajaW7IjF5scLwQJqNZXZ8U2FOoLIrx607L2SHH7eNhZHh9eeOeygZ9nKkjNTW5E3YTp3CwaWBBPeUF7728Sjas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MgcJrVat; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MgcJrVat"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=64LSUbYBKfcsTB5VhbQqqofrClK56EVU4TkqqM/B9Gs=; b=MgcJrVatOXeBgd1i3o2yFBjh+W
	Y51MGEYT54OKX+sZghquaqKlmsLJ5qbVHkSQNXUoFm7YqYf9JkBRenpuWG/MZAz5Wrx9acve4/kMy
	F2wUiVO+9ACi78KI0wxN5t+aXLq+I561Pd+4Oy/4PCNzzN1wbX/SxWdDqI6fw05r5MFpGrLrYdFbg
	OIU7W/m90JT8y6KZuxpZTXiZrIkIDf2bctX6XSM5HfQBw6XcrEWoZheBTSHVYjjwksC6LFBYCp///
	5/WDVCTUYx8ayRuS//6B2fIuvvli8a+qi3CQI92cc8DrkPs8OyvByGE4S7dJVqoVxtLNNKmuJycFR
	9krjBfpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tOv5R-002Pzd-1K;
	Sat, 21 Dec 2024 16:57:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Dec 2024 16:57:10 +0800
Date: Sat, 21 Dec 2024 16:57:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: davem@davemloft.net, dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v8 2/3] s390/crypto: New s390 specific protected key hash
 phmac
Message-ID: <Z2aC5g-7_yc6ziL4@gondor.apana.org.au>
References: <20241218140530.82581-1-freude@linux.ibm.com>
 <20241218140530.82581-3-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241218140530.82581-3-freude@linux.ibm.com>

On Wed, Dec 18, 2024 at 03:05:28PM +0100, Harald Freudenberger wrote:
>
> +static void phmac_wq_init_fn(struct work_struct *work)
> +{
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct s390_phmac_req_ctx *req_ctx =
> +		container_of(dwork, struct s390_phmac_req_ctx, work);
> +	struct ahash_request *req = req_ctx->req;
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
> +	int rc;
> +
> +	rc = phmac_init(tfm, ctx, true);
> +
> +	pr_debug("req complete with rc=%d\n", rc);
> +	crypto_request_complete(&req->base, rc);

This should be ahash_request_complete, and you should also call
local_bh_disable before calling it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
