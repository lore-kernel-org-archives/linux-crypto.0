From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.23-rc4-mm1
Date: Sun, 2 Sep 2007 09:46:10 +0800
Message-ID: <20070902014610.GA15533@gondor.apana.org.au>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070901155353.8a09db69.kamezawa.hiroyu@jp.fujitsu.com> <20070831235815.a09c7865.akpm@linux-foundation.org> <20070901085429.GA7213@gondor.apana.org.au> <alpine.LFD.0.999.0709020157580.20781@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Satyam Sharma <satyam@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1411 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933221AbXIBBqm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Sep 2007 21:46:42 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709020157580.20781@enigma.security.iitk.ac.in>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Sep 02, 2007 at 02:39:15AM +0530, Satyam Sharma wrote:
> 
> Tangential, but I've often wondered what are the upsides of keeping
> CONFIG_CRYPTO_ALGAPI as a separate config option in the first place? Every
> single item in crypto/ ends up "select"ing it (directly or transitively)
> so it makes all sense to just do away with it and keep it == CONFIG_CRYPTO
> in the Makefile, thusly:

NACK.  ALGAPI exists so that it can be built as a module, as
opposed to CRYPTO which is always built-in.  It's already
invisible to the user so I don't see why you have a problem
with it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
