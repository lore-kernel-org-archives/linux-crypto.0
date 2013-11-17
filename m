From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: s390 - Fix aes-cbc IV corruption
Date: Sun, 17 Nov 2013 20:33:59 +0800
Message-ID: <20131117123359.GA20753@gondor.apana.org.au>
References: <20131031032547.GA16528@gondor.apana.org.au>
 <20131114161020.GA19229@hal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Jan Glauber <jang@linux.vnet.ibm.com>
To: Jan Glauber <jan.glauber@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55291 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453Ab3KQMeG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Nov 2013 07:34:06 -0500
Content-Disposition: inline
In-Reply-To: <20131114161020.GA19229@hal>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 14, 2013 at 05:10:20PM +0100, Jan Glauber wrote:
> On Thu, Oct 31, 2013 at 11:25:47AM +0800, Herbert Xu wrote:
> > Hi:
> 
> Hi Herbert,
> 
> just seen this as my old email address is dead... Your patch looks
> fine as it keeps the iv and the key together as required by the instruction.

Thanks for reviewing.

> However, I'm curious how this could be racy with threads. The encryption must
> be serialized because of the chaining. The decryption could in theory happen
> in parallel, but is this the case here?

A single tfm can be used by multiple threads in parallel.  For
example, two packets of the same IPsec SA may be processed by
two CPUs at the same time.  This applies both inbound and outbound
so it affects both encryption and decryption.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
