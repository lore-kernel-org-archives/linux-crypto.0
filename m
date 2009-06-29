From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Mon, 29 Jun 2009 19:59:50 +0800
Message-ID: <20090629115950.GA6594@gondor.apana.org.au>
References: <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com> <20090603115931.GA13361@gondor.apana.org.au> <20090605092030.GO20366@secunet.com> <20090605092021.GB8724@gondor.apana.org.au> <20090605093430.GP20366@secunet.com> <20090608052808.GB19826@gondor.apana.org.au> <20090608064518.GQ20366@secunet.com> <20090625065112.GA31869@gondor.apana.org.au> <20090629110410.GE20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59650 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751073AbZF2L7w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jun 2009 07:59:52 -0400
Content-Disposition: inline
In-Reply-To: <20090629110410.GE20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 29, 2009 at 01:04:10PM +0200, Steffen Klassert wrote:
>
> I applied your patch on top of the last pcrypt patchset, but
> unfortunately it does not change anything here.
> 
> If I do
> modprobe tcrypt alg='pcrypt(authenc(hmac(sha1-generic),cbc(aes-generic)))' type=3
> 
> it instantiates
> 
> authenc(hmac(sha1-generic),cbc(aes-generic))
> 
> but not 
> 
> pcrypt(authenc(hmac(sha1-generic),cbc(aes-generic)))
> 
> regardless your patch applied or not.

OK.  Can you send me the patches you used against the current
cryptodev tree (I only just pushed so give it an hour or so)?
I'll see if I can reproduce it here.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
