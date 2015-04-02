From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: api - Change crypto_unregister_instance argument type
Date: Thu, 2 Apr 2015 22:59:11 +0800
Message-ID: <20150402145911.GA10227@gondor.apana.org.au>
References: <20150402143122.GA9699@gondor.apana.org.au>
 <20150402143940.GA9947@gondor.apana.org.au>
 <2597941.K7IMfLeYM0@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41978 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbbDBO7P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Apr 2015 10:59:15 -0400
Content-Disposition: inline
In-Reply-To: <2597941.K7IMfLeYM0@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 02, 2015 at 04:54:03PM +0200, Stephan Mueller wrote:
>
> >@@ -316,7 +316,7 @@ static int crypto_del_alg(struct sk_buff *skb, struct
> >nlmsghdr *nlh, if (atomic_read(&alg->cra_refcnt) != 1)
> > 		return -EBUSY;
> >
> >-	return crypto_unregister_instance(alg);
> >+	return crypto_unregister_instance((struct crypto_instance *)alg);
> 
> Instead of using type casts, isn't container_of() a cleaner way (and hopefully 
> a safer way) of casting? 

Actually no that would only make sense if every alg sat within
an instance which is not the case.  So I don't think using that
would buy us much clarity.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
