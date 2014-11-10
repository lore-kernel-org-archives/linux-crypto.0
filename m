From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level spec
Date: Mon, 10 Nov 2014 02:41:56 +0100
Message-ID: <6378539.AB6lySjknM@tachyon.chronox.de>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de> <4163724.RCMDlx8dmE@tachyon.chronox.de> <545AD9B0.4090009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>,
	Jason Cooper <cryptography@lakedaemon.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tstruk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54305 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbaKJHxN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2014 02:53:13 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S609A> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 10 Nov 2014 08:53:09 +0100
In-Reply-To: <545AD9B0.4090009@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 5. November 2014, 18:15:12 schrieb Tadeusz Struk:

Hi Tadeusz,

> Hi,
> 
> On 11/02/2014 12:35 PM, Stephan Mueller wrote:
> > +	* type:
> > +		- blkcipher for symmetric block ciphers
> 
> blkcipher for synchronous block ciphers
> 
> > +		- ablkcipher for asymmetric block ciphers
> 
> ablkcipher for asynchronous block ciphers
> 
> > +		- cipher for single block ciphers that may be used with an
> > +		  additional template
> > +		- shash for symmetric message digest
> 
> shash for synchronous message digest
> 
> > +		- ahash for asymmetric message digest
> 
> ahash for asynchronous message digest
> 
> T.

Thanks a lot for this hint: I do not know how often I said "symmetric" or 
"asymmetric" when in fact I meant synchronous and asynchronous....

Maybe I spent too much time in the crypto arena ;-)

-- 
Ciao
Stephan
