From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] Add Niagara2 crypto driver
Date: Wed, 19 May 2010 14:15:44 +1000
Message-ID: <20100519041544.GA21601@gondor.apana.org.au>
References: <20100517.222226.42804224.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:33639 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713Ab0ESEPr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 00:15:47 -0400
Content-Disposition: inline
In-Reply-To: <20100517.222226.42804224.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 17, 2010 at 10:22:26PM -0700, David Miller wrote:
> 
> These patches do the work necessary to add the Niagara2 crypto
> driver.
> 
> The main enablers are a set of generic ablkcipher_walk helpers, and
> testing support for async hash algorithms.
> 
> Some work still remains, in particular tcrypt still can't perf test
> async ciphers :-/
> 
> These changes are also available from the GIT tree at:
> 
> 	master.kernel.org:/pub/scm/linux/kernel/git/davem/cryptodev-2.6.git

All applied to cryptodev.  This is truely awesome as it is probably
the first piece of async driver in our tree that is capable of doing
IPsec at 10Gb/s!

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
