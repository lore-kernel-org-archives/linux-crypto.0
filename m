From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Mon, 31 Aug 2009 10:45:39 +0200
Message-ID: <20090831084539.GA32705@secunet.com>
References: <20090605092021.GB8724@gondor.apana.org.au> <20090605093430.GP20366@secunet.com> <20090608052808.GB19826@gondor.apana.org.au> <20090608064518.GQ20366@secunet.com> <20090625065112.GA31869@gondor.apana.org.au> <20090629110410.GE20366@secunet.com> <20090629115950.GA6594@gondor.apana.org.au> <20090629135257.GG20366@secunet.com> <20090819071549.GB14755@secunet.com> <20090831055816.GA26693@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:36605 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbZHaImx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Aug 2009 04:42:53 -0400
Content-Disposition: inline
In-Reply-To: <20090831055816.GA26693@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 31, 2009 at 03:58:16PM +1000, Herbert Xu wrote:
> 
> In fact it was being instantiated, it was just getting killed
> immediately after completing its self-test :)
> 
> Please let me know if this fixes it for you.
> 

Yes, it fixes it. Thanks a lot!

So pcrypt would be ready to use from my point of view.
I'll send a next version of pcrypt and padata later.
