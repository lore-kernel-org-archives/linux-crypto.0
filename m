Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03BB30F541;
	Fri, 30 Jan 2026 08:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769760318; cv=none; b=IuJkfbPfCfXwjvGE1L5sgb/K9EBNfGmVr7dJPn7uxfM2bO0PDMw9CLrnQnq5i+5mn9Zs9Sc6mAZzrwHjfMrreBxghh40BMSz4A2FKTVFC+zZ2fXXX2A9DJ2HA4DS22rjkxXQqiExS5nCSplRQRIt+z95Sgu2+QYVJnwhU3VwVDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769760318; c=relaxed/simple;
	bh=gQP584bHiu4hPcLh8zTJBz6I26gyqo++ilerToiBUcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5wjPlGVbE/EX3C4RIk1LMBvWA0NnUrXow9ci3YVchS5omcMDFOIC3hedsuytBXNSEjsZ/ScO/JuTwVu9TsNJwfIlPDY30J1cGgiBsZarFg9HNlmYAlYBBOnMMtVbJGVciaU8M3Hp5t53nPZ37z7K2ux9WpPDa6ZOVsNuVp0ySI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cVyTl/8P; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cVyTl/8P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=YFCQ/mUQZLo2bgf8Cp/yVUNvJ6HF+C/mQGcFj4z/rPQ=; 
	b=cVyTl/8P5eOYzRZyryq3jI0YA7zTOBw8yWYVNkN1s7uhYJhNUP/Z+dEdG5g9WVK0O218L/UK0rH
	oqhv+/SMMeCT5jaPk5fFS5xVY9tzV3JMTlz5IDUC9y3T3q+wl9uf23TeZ43BMM9N0fEK/U/IFPpYE
	TaBRIR/eeYBlszxbRbpuQY3N3kAoEYavwU5k1CZmMxfxy6SnCLp8NZ8sNOa+UDy3TZqnnbY7WTX0U
	AnJNMkn5Daty3ZnqPLRClh+t1Y/Ba/yWCHK28NJmsV3ht+sj5W3cPTKcy9yixYm97iJj9rARYb0Ne
	I+9Fu6UldFIM/pnXyBOdukioQRzGtJxp4YZQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vljUo-003FET-0M;
	Fri, 30 Jan 2026 16:04:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Jan 2026 16:04:50 +0800
Date: Fri, 30 Jan 2026 16:04:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Qingfang Deng <dqfext@gmail.com>
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: Re: [PATCH] crypto: eip93: fix sleep inside atomic
Message-ID: <aXxmIuU9PKJiDs7n@gondor.apana.org.au>
References: <20260120025400.54294-1-dqfext@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120025400.54294-1-dqfext@gmail.com>

On Tue, Jan 20, 2026 at 10:54:00AM +0800, Qingfang Deng wrote:
> A crypto request is allowed to sleep only if CRYPTO_TFM_REQ_MAY_SLEEP is
> set. Avoid GFP_KERNEL and usleep_range() if the flag is absent.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Signed-off-by: Qingfang Deng <dqfext@gmail.com>
> ---
>  .../crypto/inside-secure/eip93/eip93-aead.c   |  2 +-
>  .../crypto/inside-secure/eip93/eip93-cipher.c |  2 +-
>  .../crypto/inside-secure/eip93/eip93-cipher.h |  3 +-
>  .../crypto/inside-secure/eip93/eip93-common.c | 36 ++++++++++++-------
>  .../crypto/inside-secure/eip93/eip93-hash.c   |  9 +++--
>  5 files changed, 35 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-aead.c b/drivers/crypto/inside-secure/eip93/eip93-aead.c
> index 18dd8a9a5165..b5a47b583397 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-aead.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-aead.c
> @@ -46,7 +46,7 @@ static int eip93_aead_send_req(struct crypto_async_request *async)
>  	struct eip93_cipher_reqctx *rctx = aead_request_ctx(req);
>  	int err;
>  
> -	err = check_valid_request(rctx);
> +	err = check_valid_request(async, rctx);
>  	if (err) {
>  		aead_request_complete(req, err);

The aead_request_complete call is buggy too as you cannot call it
unless you're in the async path, which this clearly is not since
you're still checking the request flags.

I think a better solution is to add crypto_engine to this driver
which would guarantee a sleepable context for the driver.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
