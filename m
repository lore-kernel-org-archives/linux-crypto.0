From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AES-NI: fix memory usage in GCM decryption
Date: Wed, 11 Mar 2015 20:10:16 +1100
Message-ID: <20150311091016.GA7858@gondor.apana.org.au>
References: <22281096.OZkxDCz0xu@tachyon.chronox.de>
 <20150310094543.GA17358@gondor.apana.org.au>
 <1521038.6EeQHtyvI4@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:59601 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbbCKJKZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 05:10:25 -0400
Content-Disposition: inline
In-Reply-To: <1521038.6EeQHtyvI4@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 11, 2015 at 09:01:02AM +0100, Stephan Mueller wrote:
>
> However, I think there is an error in the calculation of the AAD pointer 
> offset. That offset is currently calculated as:
> 
> assoc = (src + req->cryptlen + auth_tag_len);
> 
> But instead, it should be:
> 
> assoc = (src + req->cryptlen);
> 
> as our buffer is only cryptlen + assolen in size.
> 
> If you concur, I will write a patch and test it.

Yes that's the problem I was referring to.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
