From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] pcrypt: Add pcrypt crypto parallelization
	wrapper
Date: Tue, 23 Jun 2009 18:19:45 +0800
Message-ID: <20090623101945.GA9692@gondor.apana.org.au>
References: <20090608070749.GR20366@secunet.com> <20090608071000.GT20366@secunet.com> <20090619122933.GB18631@gondor.apana.org.au> <20090623082921.GB20366@secunet.com> <20090623083438.GA8315@gondor.apana.org.au> <20090623091429.GC20366@secunet.com> <20090623091852.GA8701@gondor.apana.org.au> <20090623101958.GD20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54403 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752048AbZFWKTr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2009 06:19:47 -0400
Content-Disposition: inline
In-Reply-To: <20090623101958.GD20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 23, 2009 at 12:19:58PM +0200, Steffen Klassert wrote:
>
> Anyway, here are numbers for the network based versions:
> 
> I did forwarding tests with the thread version and two quad core machines
> (Intel Core 2 Quad Q6600):
> 
> linux-2.6.25.2 + thread based (network) parallelization
> Packetsize: 1420 byte
> Encryption: aes192-sha1
> Unidirectional throughput: 660 Mbit/s (tcp)
> 
> After rewriting this to use remote softirqs I've got with the same
> environment:
> 
> linux-2.6-git (Dec 01, 2008) + softirq based (network) parallelization
> Packetsize: 1420 byte
> Encryption: aes192-sha1
> Unidirectional throughput: 910 Mbit/s (tcp)

OK, as long as there something to justify the added complexity
it's fine by me.  We could always remove the softirqs later if
necessary.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
