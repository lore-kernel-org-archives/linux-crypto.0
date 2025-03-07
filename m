Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693D1DF71;
	Fri,  7 Mar 2025 03:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741316519; cv=none; b=chUZ/lbE/yKfe2g17dDAp9YFx4OxBv+SBQ9GtWe0Lbp/JTleGJKlkuB1S1Tav8eI8WNd8F7vnMD5q985gP3T+3mup19afsZOnr/rwe92jDwjn7eJ+qBJk4hlz5CJQY+iem6GTgygmu4x7VzMWoPm0CouU8JM98IQWaw5Rc6B+DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741316519; c=relaxed/simple;
	bh=P3FrZyJOxGE17ZwJGvmque3rDknFqX6vTONmj35VY/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLz+G/0+ABpTBbWcK6svNbrucNK5mIGilfUjQiddW+BbLjTcXAK8EfkrNeSLL8kAWdcAKlwzWilfz0dHIIcSbWm5AUn9PeXfTVn64V6rZjPgyZEQtS6LqDGRNaIlzU1rr9obBmgbYnpPIqkhPpVGkT9M4BfWgilOF/9iU9wDcYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FRu6/yor; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FRu6/yor"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8p6H1XRld9I1UNikHiaJ/Tj0ya1eXUwPLH8GvVhGTzA=; b=FRu6/yor+L+rOuqtIbwRQSxdaO
	jP4lSp7oclW22qanqsKm+qG8skbF4WdIXYCLHKQVD2btcac+rEZUbW8lX+0MmqTTaZ+uYlDrqszsm
	ozqIXOoyMQgtO8EIMlbEh2e9uvLdExZr/G98noPv2f3SOa+0SRpG58fI+kaF/q0xgwGybOIWpahj1
	iiuM57Qx2eWtw87sNn8FnhFnOuYEktkK1W1U1riwOdwgOhsqK+UNNi9a/5uHdWe0AzhRsCNoVtLvK
	o769sDUSF2+0tMn4gFf4yWAyQsC7PdBH6JVXIN4TSbRrLKs0VKO/exTDs6Cjd6x74idbsLYVaeByz
	2tl5qvnA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqNyB-004UBD-1T;
	Fri, 07 Mar 2025 11:01:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Mar 2025 11:01:51 +0800
Date: Fri, 7 Mar 2025 11:01:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/crypto: Rework protected key AES for true
 asynch support
Message-ID: <Z8phn5Ddk5ZBvyzY@gondor.apana.org.au>
References: <20250306171201.17961-1-freude@linux.ibm.com>
 <20250306171201.17961-2-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306171201.17961-2-freude@linux.ibm.com>

On Thu, Mar 06, 2025 at 06:12:01PM +0100, Harald Freudenberger wrote:
>
> +	/* fetch and check protected key state */
>  	spin_lock_bh(&ctx->pk_lock);
> +	pk_state = ctx->pk_state;
>  	memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
>  	spin_unlock_bh(&ctx->pk_lock);
> +	switch (pk_state) {
> +	case PK_STATE_NO_KEY:
> +		rc = -ENOKEY;
> +		goto out;
> +	case PK_STATE_CONVERT_IN_PROGRESS:
> +		rc = -EKEYEXPIRED;
> +		goto out;

Shouldn't this go async rather than failing?

> +	case PK_STATE_VALID:
> +		break;
> +	default:
> +		rc = pk_state < 0 ? pk_state : -EIO;
> +		goto out;
> +	}
> +
> +	/* setkey() should have updated the function code */
> +	if (!ctx->fc) {

The locking is wrong for this field.  It gets written to without
any locks in cbc_paes_wq_setkey_fn, and here you're reading it
without any locking.

In fact the whole switch statement smells fishy.  One tfm could
be used by any number of encryption requests in parallel.  So
your pk_state could change from right under your nose as soon as
you let go of the pk_lock.

Please describe the high-level picture of how pk_lock and its
protected fields are meant to work in the face of requests being
issued in parallel on one tfm.
  
> -static int cbc_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
> -			    unsigned int key_len)
> +static int cbc_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
> +			   unsigned int key_len)
>  {
>  	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
>  	int rc;
>  
> -	_free_kb_keybuf(&ctx->kb);
> -	rc = _key_to_kb(&ctx->kb, in_key, key_len);
> +	rc = key_to_ctx(ctx, in_key, key_len);
>  	if (rc)
>  		return rc;
>  
> -	return __cbc_paes_set_key(ctx);
> +	/* Always trigger an asynch key convert */
> +	spin_lock_bh(&ctx->pk_lock);
> +	ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
> +	spin_unlock_bh(&ctx->pk_lock);
> +	queue_work(paes_wq, &ctx->work);

Why does this need to be async? The setkey function is the one
part of the API that is competely synchronous.  It is not allowed
to occur while any encryption is still incomplete.

By making it asynchronous, you risk creating new issues.  For example,
what is supposed to happen when a second setkey occurs while the first
setkey's scheduled work is yet to complete?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
