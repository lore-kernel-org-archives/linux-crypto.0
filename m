Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E3F3BE64C;
	Tue,  5 May 2026 05:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777960510; cv=none; b=U5eVYyCR26I+tNh0874adZEdyNr9Sp1Mz50TCsMHXW9kWnQhB/sZnii6uiRoyTQ3HZf3b+3+krZSFhXzyXFczSvO/juJJCE9YDT0w+r6yWxlUmavpD4cRQ6cWaGm7+3ZidpBFodf7dv1xYtNn/Fbiqpg1kOk+mUmvh+fI7uef3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777960510; c=relaxed/simple;
	bh=q3kIojH3qLjZnfYeKp9JRtu1dhGZUdBS2TlRePyHnR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bv4A4VeaZ9ls560tXuM1u4BIQtNc4smtuplUJcHGaLNIkwnE81J9HjUoe0FPBsGJFX5rIKjJ7vyDWhSbhFUXdtkSJ5BYU/njZpgsJH/jcrL1Cl+QpBj1onv0hiTifNBPN2KeM+eP97LwuF+av4deRsm2YrIQZaHTbDs+6M/pgZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=aQh+6KMb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="aQh+6KMb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=uDt4u9eRgEpe1e3vy/GTET7RYCGZv5A39tmKQUlV1js=; 
	b=aQh+6KMbP+ccqcwQCpqtwzfbHJJseMj0v6zcyvRS07yrA2jTyl+t7UYIgKTH+BxtDN1ToJGMeXZ
	lyFZ5SXYKaLtIH+p8SV6fCPSmyDQ2DTxJ2BGZQTD/Q9iWHijUp7HzHEfc5ETD7pwaAyUrak6LT75X
	/PmEIugVSsDNclVY3MnySnDn4yL/cJKFDYrrxjUlELnRKFv8o7GQQBp2IaudhzPUS/Gmm25VXzB9g
	b55xN6gKzDowWP4hv7O10uGAHog9hESAxjdUfJ43jX2qcvYYj2eVoP0Xq15Ji7mAntnjm4FLZkv+q
	gDHbCc9UGreHB93VshXAGZwszdCfhuwDtqSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wK8jx-00BKhI-0q;
	Tue, 05 May 2026 13:54:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 13:54:41 +0800
Date: Tue, 5 May 2026 13:54:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org, Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: krb5 - wait for async aead completion before
 freeing buffer
Message-ID: <afmGIUFhQoP4dPsA@gondor.apana.org.au>
References: <20260502132506.1936358-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260502132506.1936358-1-michael.bommarito@gmail.com>

On Sat, May 02, 2026 at 09:25:06AM -0400, Michael Bommarito wrote:
>
> diff --git a/crypto/krb5/rfc3961_simplified.c b/crypto/krb5/rfc3961_simplified.c
> index e49cbdec7c40..c4b8e9b89c7b 100644
> --- a/crypto/krb5/rfc3961_simplified.c
> +++ b/crypto/krb5/rfc3961_simplified.c
> @@ -543,6 +543,7 @@ ssize_t krb5_aead_encrypt(const struct krb5_enctype *krb5,
>  			  size_t data_offset, size_t data_len,
>  			  bool preconfounded)
>  {
> +	DECLARE_CRYPTO_WAIT(wait);
>  	struct aead_request *req;
>  	ssize_t ret, done;
>  	size_t bsize, base_len, secure_offset, secure_len, pad_len, cksum_offset;
> @@ -588,9 +589,10 @@ ssize_t krb5_aead_encrypt(const struct krb5_enctype *krb5,
>  	iv = buffer + krb5_aead_size(aead);
>  
>  	aead_request_set_tfm(req, aead);
> -	aead_request_set_callback(req, 0, NULL, NULL);
> +	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				  crypto_req_done, &wait);
>  	aead_request_set_crypt(req, sg, sg, secure_len, iv);
> -	ret = crypto_aead_encrypt(req);
> +	ret = crypto_wait_req(crypto_aead_encrypt(req), &wait);
>  	if (ret < 0)
>  		goto error;

Since this code was written synchronously, it's probably best
to change the allocation to filter out async algorithms:

	ci = crypto_alloc_aead(krb5->encrypt_name, 0, CRYPTO_ALG_ASYNC);

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
