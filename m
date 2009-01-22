From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
Date: Thu, 22 Jan 2009 18:30:40 +1100
Message-ID: <20090122073040.GA12395@gondor.apana.org.au>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com> <20090116033105.GB10390@gondor.apana.org.au> <1232591537.6101.3.camel@yhuang-dev.sh.intel.com> <20090122030400.GA10229@gondor.apana.org.au> <1232608558.6101.13.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52140 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754672AbZAVHan (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Jan 2009 02:30:43 -0500
Content-Disposition: inline
In-Reply-To: <1232608558.6101.13.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 22, 2009 at 03:15:58PM +0800, Huang Ying wrote:
> 
> Yes. Except that, now we do not need a spin lock really. I think the
> spin lock may be useful if we enqueue a request on other CPU's queue to
> do load balance. And if it is possible that the work_struct to be
> executed on CPU other original CPU for CPU hotplug (current code do
> not).

Right, but I think load-balancing should be explicitly enabled,
i.e., we probably don't want to do it by default for AES-NI.

The way I see load balancing work is if you had a template that
sat on top of cryptd pass the requests to the cryptd on a CPU
it chooses.

Then we can enable it for any algorithm in the system simply
by instantiating that template for it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
