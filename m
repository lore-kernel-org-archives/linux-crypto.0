From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Mon, 29 Jun 2009 13:04:10 +0200
Message-ID: <20090629110410.GE20366@secunet.com>
References: <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com> <20090603115931.GA13361@gondor.apana.org.au> <20090605092030.GO20366@secunet.com> <20090605092021.GB8724@gondor.apana.org.au> <20090605093430.GP20366@secunet.com> <20090608052808.GB19826@gondor.apana.org.au> <20090608064518.GQ20366@secunet.com> <20090625065112.GA31869@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:58581 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZF2LBd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jun 2009 07:01:33 -0400
Content-Disposition: inline
In-Reply-To: <20090625065112.GA31869@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 25, 2009 at 02:51:12PM +0800, Herbert Xu wrote:
> 
> OK, the patch I just posted to the list should fix the problem.
> 
> I was able to test it suing
> 
> modprobe tcrypt alg='pcrypt(authenc(hmac(sha1-generic),cbc(aes-generic)))' type=3
> 

I applied your patch on top of the last pcrypt patchset, but
unfortunately it does not change anything here.

If I do
modprobe tcrypt alg='pcrypt(authenc(hmac(sha1-generic),cbc(aes-generic)))' type=3

it instantiates

authenc(hmac(sha1-generic),cbc(aes-generic))

but not 

pcrypt(authenc(hmac(sha1-generic),cbc(aes-generic)))

regardless your patch applied or not.
