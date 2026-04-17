Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6543AEF36
	for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 08:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776415693; cv=none; b=YSPMaJjDXY+I/5zHKSSuF6ldvGEd81+oB3/+bK4fg9Vaq+B+2Tg9w3wTMvB4sRlmBcxbFPLpdSR1+79Ms7+e/LjTmzxujiLqo9LexwJ3W4LeJCbUZu+Wa38cymArCjKYeG9Uo/Mp0Zxc9X+HwdGRSv2HUXQbHT8IyWhYi32cDno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776415693; c=relaxed/simple;
	bh=H3ZolOc3T35Zdf5TITwPDw4Szl85spSYkVKOwFONdYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0MymP5hXhjf5Z8U3iBBllwB8l4yY012qeK9wvk79hmKG1FDK59RhkT7h7tYvgkVL+YEETl+kTrkXzZ3zUvwqW2diX9loiMgdPMSgvF/PxXZoSWkpyFW4h0quSmBQvmcz/cTQcUjXaksuc+Aubfx3jopM38yy5tkp9ekAH1mjvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=CB2w7ND7; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="CB2w7ND7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UUvLipqWzXh3kFSHIsA6pHiY0l9qGkgjkjzTZSifWLQ=; 
	b=CB2w7ND7uC5Mo8PaRvgAI4xrTSFfEdZyHyCwtNCmqTBDR0c/pyq+Eh/vIqJi4eDtVj8O22xW5Do
	mryUkiRofC596gO++CUsEi073j4XOnMkvzsgwHievPbAbYFPYdSvWy7dvhHoSMWYpCGj45GIeKn8D
	+EcrpQZyQ9uRs46RPbxQdwXMCeqe3ildL90s9Us15UvfYzZnMPoKgqW8v5a85dCImmI0hmnMVylMV
	HdSu3whZ1R1ElvfE9MR1pjBO+SxDix3hCXW6eRhC1nXRkInoZ9n0F/x0+h3Xg42jLLDvxZEgrNkEV
	gMTrkp7dTteM1dfgNF5Fxc5Loim2moIuk/Rg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDerv-006lOS-1a;
	Fri, 17 Apr 2026 16:48:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Apr 2026 16:48:07 +0800
Date: Fri, 17 Apr 2026 16:48:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dudu Lu <phx0fer@gmail.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: krb5enc - fix async decrypt skipping hash
 verification
Message-ID: <aeHzx8r1MK5ueUsc@gondor.apana.org.au>
References: <20260416135424.68785-1-phx0fer@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416135424.68785-1-phx0fer@gmail.com>

On Thu, Apr 16, 2026 at 09:54:24PM +0800, Dudu Lu wrote:
>
> diff --git a/crypto/krb5enc.c b/crypto/krb5enc.c
> index a1de55994d92..2490343873a9 100644
> --- a/crypto/krb5enc.c
> +++ b/crypto/krb5enc.c
> @@ -41,7 +41,7 @@ struct krb5enc_request_ctx {
>  
>  static void krb5enc_request_complete(struct aead_request *req, int err)
>  {
> -	if (err != -EINPROGRESS)
> +	if (err != -EINPROGRESS && err != -EBUSY)

This shouldn't filter anything out.  The filtering needs to occur
further up the call stack.  In fact just get rid of it and use
aead_request_complete directly.

The encrypt path is just as broken as the decrypt path and
needs to be fixed accordingly to filter out EBUSY/EINPROGRESS.
In particular, this should be done in krb5enc_encrypt_ahash_done.
Currently it's only filtering out EINPROGRESS.

> +static void krb5enc_decrypt_done(void *data, int err)
> +{
> +	struct aead_request *req = data;
> +
> +	if (err == -EINPROGRESS || err == -EBUSY)
> +		return krb5enc_request_complete(req, err);

EINPROGRESS should always get passed up here because it means
that we originally returned an EBUSY and the caller is potentially
blocking on this notification.

EBUSY cannot occur in the context of the callback so there is no
need to check for it.

So this should simply become

	if (err)
		goto out;

> +	err = krb5enc_dispatch_decrypt_hash(req);
> +	if (err == -EINPROGRESS || err == -EBUSY)
> +		return;

This is the only place where EBUSY needs to be checked.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
