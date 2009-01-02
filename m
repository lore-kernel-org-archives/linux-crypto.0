From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: alg: cipher: Test 1 failed on encryption for aes-asm
Date: Sat, 3 Jan 2009 08:57:39 +1100
Message-ID: <20090102215739.GB29294@gondor.apana.org.au>
References: <20081219202603.GA31265@lst.de> <20081220032159.GA15615@gondor.apana.org.au> <1230022166.17529.82.camel@yhuang-dev.sh.intel.com> <20081223130154.GA23717@Chamillionaire.breakpoint.cc> <1230083021.17529.98.camel@yhuang-dev.sh.intel.com> <20081224044851.GA20851@gondor.apana.org.au> <20090102212427.GA19624@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>, Christoph Hellwig <hch@lst.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [64.62.148.172] ([64.62.148.172]:56429 "EHLO arnor.apana.org.au"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757066AbZABWFm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Jan 2009 17:05:42 -0500
Content-Disposition: inline
In-Reply-To: <20090102212427.GA19624@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 02, 2009 at 10:24:27PM +0100, Sebastian Andrzej Siewior wrote:
> 
> No matter what you pick as your final solution, should I send a
> 's/module_init/subsys_initcall/' patch for cryptomgr & algapi?

cryptomgr already uses subsys_initcall and algapi doesn't need
it yet because it only registers the proc entry.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
