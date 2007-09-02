From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.23-rc4-mm1
Date: Sun, 2 Sep 2007 11:59:53 +0800
Message-ID: <20070902035953.GA16196@gondor.apana.org.au>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070901155353.8a09db69.kamezawa.hiroyu@jp.fujitsu.com> <20070831235815.a09c7865.akpm@linux-foundation.org> <20070901085429.GA7213@gondor.apana.org.au> <alpine.LFD.0.999.0709020157580.20781@enigma.security.iitk.ac.in> <20070902014610.GA15533@gondor.apana.org.au> <alpine.LFD.0.999.0709020746250.20781@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Satyam Sharma <satyam@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1871 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750715AbXIBEAX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Sep 2007 00:00:23 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709020746250.20781@enigma.security.iitk.ac.in>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Sep 02, 2007 at 08:22:42AM +0530, Satyam Sharma wrote:
>
> So what finally got exported out of crypto/ to the rest of the kernel
> was just the crypto_alloc_xxx() wrapper. That resolves to a call to
> crypto_alloc_base() in crypto/api.c, which first loads the specific
> low-level algo modules, and then proceeds to crypto_init_ops(), which
> itself may, say, resolve to a crypto_init_digest_ops() -- the only
> interface exported from digest.c.

The mid-level code such as digest.c are only built-in because
they are legacy code.  All the new mid-level code such as
blkcipher/hash are registered dynamically.

Once all the digest stuff have been converted to hash digest.c
will be removed.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
