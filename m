From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Fri, 9 Jan 2009 20:18:14 +1100
Message-ID: <20090109091814.GA10881@gondor.apana.org.au>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com> <20090109070144.GA7358@gondor.apana.org.au> <1231491273.5937.94.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34356 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750780AbZAIJSU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Jan 2009 04:18:20 -0500
Content-Disposition: inline
In-Reply-To: <1231491273.5937.94.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 09, 2009 at 04:54:33PM +0800, Huang Ying wrote:
> 
> - cryptd thread is not per-CPU, so I think there will be some
> unnecessary cache inter-CPU migration. Why not use a dedicate workqueue

Well it shouldn't be hard to make cryptd per-cpu.

> or just system events workqueue?

That's actually bad because the system events queue is a shared
resource which is often subject to starvation problems.  On the
one hand we may be starved by others and we may also starve others
by doing too much crypto.

> - with cryptd(__*-aes-aesni), we need 4 internal tfms for each external
> tfm allocation request. For example, for one external cbc(aes) tfm
> allocation request, we need one cbc(aes) ablkcipher tfm, one
> cryptd(cbc-aes-aesni) tfm, and two cbc-aes-aesni tfm. Do we use too much
> memory? And we need to call aesni_set_key() twice.

Not at all, tfms are just "shell" objects and they were designed
to be used in thie way.  Calling setkey twice is an issue but it's
not a show-stopper.  We have the same problem in other places to
so this something that we can potentially optimise.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
