Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F1A32C93B;
	Mon, 15 Dec 2025 10:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765793568; cv=none; b=dvwsoioevLMYtTfWr+BHxc359JAMM8aOPD4u1ns4nxdJI6QjZbJynQNDhQftqB1+xL18qnMopmRdqr4yZBV3hFHpglPAUgUrUOH/yarqggwXsopyAQSKP6+zA9gGcwko/2X/p70bFguqAkwJZdht7OO0c0lKnl4dmzshB7Vlxp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765793568; c=relaxed/simple;
	bh=bORCEufwn6SPY5ILyaOJ9RCZ2xK4ibrYlNxAafiRPHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2eJDw1aqy/AIFDQAe2py2mTUNP7qB3chxMKUg2xyFba8tg6c+u9fTWwWsrjg+a0fUHWAcsNrFueBQcxFb52HvLPvlSghfNixC8uDnhlYjXBOVkgHHtOfKpn6CEUOoCrQfrw6ma7oTYYUuYnxyA52pVScTriHTRs13Ro+OYSyug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GPmg++vZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GPmg++vZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=5rF7YA0Qmvd1egTEo54H64u9z4srw3ZwdBDPUlFVg/U=; 
	b=GPmg++vZ3cC7V6EhkVRIudH9hPB0X4PzDMcoMMVXVhGs8zRnBOBZCKYEr1+nCmiCT/0Mgpp3QrY
	zLIIQXJtYgKoepCQU6Fqti9d724bJTdrR5FE108K8kHMFLkiRUh3PH7e2rv4yugMxSF5MDDyrZC6g
	o0NkrraXUkeNoA3mjpVTPzVTtrgqeYdz1zQW5dKoKElnt/LO9GYdBDqeIYAgl2Mq7E2+MJUXhkjX3
	18vo3fbMDSMlpgfmq97yk6GRAz+MPx4fnRJ5hLq4ey3j10LvQhmM9rRxGYnv6M7UyYgzK0qt9aIDz
	Q4SeV6jYFhNCKqKKQQP2AstLAF740SPrQYiQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vV54N-00ACPx-1P;
	Mon, 15 Dec 2025 17:40:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 15 Dec 2025 17:40:43 +0800
Date: Mon, 15 Dec 2025 17:40:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto <linux-crypto@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: kernel-doc comment with anonymous variable in anonymous union?
Message-ID: <aT_XmzUSkbFMLHK4@gondor.apana.org.au>
References: <aT_RDASKMW4RI_Yf@archie.me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aT_RDASKMW4RI_Yf@archie.me>

On Mon, Dec 15, 2025 at 04:12:44PM +0700, Bagas Sanjaya wrote:
> Hi,
> 
> kernel-doc reports warning on include/crypto/skcipher.h:
> 
> WARNING: ./include/crypto/skcipher.h:166 struct member 'SKCIPHER_ALG_COMMON' not described in 'skcipher_alg'
> 
> skciper_alg struct is defined as:
> 
> struct skcipher_alg {
> 	int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
> 	              unsigned int keylen);
> 	int (*encrypt)(struct skcipher_request *req);
> 	int (*decrypt)(struct skcipher_request *req);
> 	int (*export)(struct skcipher_request *req, void *out);
> 	int (*import)(struct skcipher_request *req, const void *in);
> 	int (*init)(struct crypto_skcipher *tfm);
> 	void (*exit)(struct crypto_skcipher *tfm);
> 
> 	unsigned int walksize;
> 
> 	union {
> 		struct SKCIPHER_ALG_COMMON;
> 		struct skcipher_alg_common co;
> 	};
> };
> 
> Note the first member in the union, which is an anonymous (i.e. unnamed) variable.
> 
> What can I do on it? Should the offending member be deleted?

You could either add a comment about SKCIPHER_ALG_COMMON, or
fix up all the code that uses it by adding "co."

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
