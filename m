Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FED22BD1B;
	Wed,  2 Apr 2025 04:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743566690; cv=none; b=rgKxSEhL4I5KsYBc8JdN/12eeb984QHbrAetq51BJkYa2QE/seXcVWYDzgKDFYM3PmLBPSmYhc7rLrnONmp0tbFZx6VDoRKEsdMcNOpwYLEpJv9SidtLdx9KCAm7RnVOwRHHe/lFPu5qaCppbY0be/bcwZaA9Im2ksUGg+/vIT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743566690; c=relaxed/simple;
	bh=1s0swUoTlOS+9aTYKFHvEJREuZrIOqXyvwNB1Dz/R2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eF6hB71uNJ2a2iNg6Fyqyr1VK2rA8qUc5uzjv4Pk0VKjfrC1P068l4Y4oOZcXCmk6YMe913hw88Xe2Hd28S82ZzxPiJaMcD41tlXgVdPJYGd3wc48C03CS2PKw2bSpMBLB35my8m35IxgYnsM3oaByq/k4ceTT2mnvxmCFzAC2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WyBFZQtr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WyBFZQtr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Vn4Fw6iH7tQfF6tNfZanVr7yGgz0Th49fEBqTPe7cJA=; b=WyBFZQtry+nFJ8oTLdaS6JM+Ax
	dsj8w/RGv5/kTnhx+2OUvsx4EendvT7qzu2c32HwMzZxraRLQ63p1Wfo4OJQrlYNYhO7qGSoDpLho
	EVGZEVAV6RiwmTIW8ooUhQyWftyL2Myty0Q7YZdKnxeb1hgSUmr2FX4P2B2rtM1PiCDG2so8xymGA
	y35OTS0rc3+kvCSRxGz1Fv85RWjXga3No72qKtBDcuWpYuYS8zvnyQmk9qhEhvTVNTD3Tfd104FJB
	aI7S5QCCQOAjEEqmf3RDPtT2F/K5SYaLfmgc52Sf8ouB7NhXVT8/7tMjjCoSILB6DyyVmzPlqzrig
	6m5FICwg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzpLH-00C1Se-0Y;
	Wed, 02 Apr 2025 12:04:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Apr 2025 12:04:43 +0800
Date: Wed, 2 Apr 2025 12:04:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 2/3] s390/crypto: Rework protected key AES for true
 asynch support
Message-ID: <Z-y3W4o5nz9qfijs@gondor.apana.org.au>
References: <20250401145048.52564-1-freude@linux.ibm.com>
 <20250401145048.52564-3-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401145048.52564-3-freude@linux.ibm.com>

On Tue, Apr 01, 2025 at 04:50:47PM +0200, Harald Freudenberger wrote:
>
> +static int ecb_paes_do_crypt(struct s390_paes_ctx *ctx,
> +			     struct s390_pecb_req_ctx *req_ctx,
> +			     bool maysleep)

...

> +	/* always walk on the ... */
> +	while ((nbytes = walk->nbytes) != 0) {
> +		/* only use complete blocks */
> +		n = nbytes & ~(AES_BLOCK_SIZE - 1);
> +		k = cpacf_km(ctx->fc | req_ctx->modifier, param,
> +			     walk->dst.virt.addr, walk->src.virt.addr, n);
> +		if (k)
> +			rc = skcipher_walk_done(walk, nbytes - k);
> +		if (k < n) {
> +			if (!maysleep) {
> +				rc = -EKEYEXPIRED;
> +				goto out;
> +			}

So this leaves the skcipher walk in a mapped state, to be resumed in
a work queue later.  Now I don't believe you guys have the horror of
HIGHMEM so it's not fatal, but it's still a bit of a hack and worthy
of a comment to at least stop people from other architectures copying
this.

> +			rc = paes_convert_key(ctx);

At first I thought this was racy, but then I realised that it is not
because only the crypto_engine thread gets called with maysleep ==
true.  Since there is only one crypto_engine thread this is safe.

I think this is not really obvious though and worthy of a comment to
explain the reliance on the single crypto engine thread.

There is one more subtle issue to do with request ordering.  Because
networking requires packets to not be reordered, we enforce this in
the Crypto API.  An algorithm must not reorder the requests sent to
the same tfm.

To do that here, once a ctx goes into the crypto_engine, all future
requests to the same ctx must also go through the crypto_engine, as
long as at the time of the request being submitted prior work is still
outstanding.

The easiest way would be to have a counter in the ctx that keeps
track of how many requests are currently outstanding in the engine.
Then in paes_do_crypt you'd simply check the counter, and if it is
non-zero you always put the request into the engine.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
