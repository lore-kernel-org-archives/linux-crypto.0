From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Thu, 25 Jun 2009 14:51:12 +0800
Message-ID: <20090625065112.GA31869@gondor.apana.org.au>
References: <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com> <20090603115931.GA13361@gondor.apana.org.au> <20090605092030.GO20366@secunet.com> <20090605092021.GB8724@gondor.apana.org.au> <20090605093430.GP20366@secunet.com> <20090608052808.GB19826@gondor.apana.org.au> <20090608064518.GQ20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41506 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751207AbZFYGvQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2009 02:51:16 -0400
Content-Disposition: inline
In-Reply-To: <20090608064518.GQ20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2009 at 08:45:18AM +0200, Steffen Klassert wrote:
>
> Yes, I will send the full patchset including the tcrypt changes to
> instantiate pcrypt.

OK, the patch I just posted to the list should fix the problem.

I was able to test it suing

modprobe tcrypt alg='pcrypt(authenc(hmac(sha1-generic),cbc(aes-generic)))' type=3

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
