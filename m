Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94261CAA62;
	Mon, 21 Apr 2025 12:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745237163; cv=none; b=JkjeOUVx+tZg0LS+m9EZsFQE7Ooshj5qUL2eYxqEKROrKwS+4RSbVsIjNM1L7DQ+4SuSRQm64mSVz9VCyC+uiMDX3UGyHk99WrEuLzz+toxnC1/+E5+NsVv1vRRnj4TDICxwsARX8+p5GDqTS9DT2CnyELcvwAekXAlYkdHopTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745237163; c=relaxed/simple;
	bh=1dCc6mOczHaHKNhgjTG1vfLZU1G4PKkgRIurjo4wHZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LPsVgtftaR+byWAX0q/SZzv/PLZ+1pQ0LIwsNO6ipvoyhVQ02IIfTv47dc5tTXp1pcH02AELubzMrXEtiUgJa1/QUM+Z0QEvZKzHBqzQ/VkQMKBncGvj7hEuBqZ3GCXnSJYsDBgnZXIQfFkR1r/O/VVNE4awN92e1hW5GHNO5/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GrGMcmr8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GrGMcmr8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VDKHNDkjFMnK/p2S73Tig7JwCYw2XzJyuUxjtUmiwc8=; b=GrGMcmr8X6hW0Ul8qcDjhsBQtg
	zZVLkcOVhByCGXnbcKm8CjM1fuHsQCIPgfJ7koZ2Wf4LCCzz1Z7MQjRXmRUFUY10A8xH1hembpXPR
	BwovjdcHMT8Czh4DIUO7FzYZZQWCQLf/cJBu5sdoFmAde3o+mnO5wXq/7+Im8lRNMuo7BsgL5PrUk
	nWdVKoWHqVgzggJjn3IHvrkuW3AH3qo4wgox6PWDvz1rJNQtpT0ks5xurASqF4IYfzTF5CNeKUzKH
	jrCq1IzwP1mp5PtlsvuzzQ4aiQZOaR3gIfIQSXEZ6jLcGzCaRuJHs4SdHQ6raWJ9JmajIGoKzSvBa
	ocCF+cLQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u6puB-00HJo0-1R;
	Mon, 21 Apr 2025 20:05:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 21 Apr 2025 20:05:43 +0800
Date: Mon, 21 Apr 2025 20:05:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Su Hui <suhui@nfschina.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: using size_add() for kmalloc()
Message-ID: <aAY0lyWzsRVDge_f@gondor.apana.org.au>
References: <20250421055104.663552-1-suhui@nfschina.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250421055104.663552-1-suhui@nfschina.com>

On Mon, Apr 21, 2025 at 01:51:06PM +0800, Su Hui wrote:
>
> @@ -433,7 +434,7 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
>  {
>  	struct aead_request *req;
>  
> -	req = kmalloc(sizeof(*req) + crypto_aead_reqsize(tfm), gfp);
> +	req = kmalloc(size_add(sizeof(*req), crypto_aead_reqsize(tfm)), gfp);

This is just wrong.  You should fail the allocation altogether
rather than proceeding with a length that is insufficient.

However, reqsize shouldn't be anywhere near overflowing in the
first place.  If you're truly worried about this, you should
change the algorithm registration code to check whether reqsize
is sane.

And that needs to wait until the algorithms are fixed to not use
dynamic reqsizes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
