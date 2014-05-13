From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/6] crypto: SHA1 multibuffer map scatter gather walk's
 buffer address directly for x86_64
Date: Wed, 14 May 2014 07:58:13 +0800
Message-ID: <20140513235813.GA28455@gondor.apana.org.au>
References: <cover.1399990803.git.tim.c.chen@linux.intel.com>
 <1400023182.2970.238.camel@schen9-DESK>
 <20140513233410.GA28134@gondor.apana.org.au>
 <1400024458.2970.247.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:42076 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbaEMX6a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 19:58:30 -0400
Content-Disposition: inline
In-Reply-To: <1400024458.2970.247.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 13, 2014 at 04:40:58PM -0700, Tim Chen wrote:
> On Wed, 2014-05-14 at 07:34 +0800, Herbert Xu wrote:
> 
> > 
> > Why do we need this patch since kmap_atomic is equivalent to
> > page_address plus preempt_disable on x86-64?
> 
> For multi-buffers, you may still have some data lanes with jobs 
> that are partially completed when you need to put the thread
> to sleep.  With kmap_atomic, you cannot sleep before unmapping.

Hmm, it seems that the existing users of this helper is abusing
the ahash interface since if they were really asynchronous they
would be sleeping on this kmap_atomic.

So we should keep the existing hash walk interface for sync users
only and create a new interface for async users.  They could in
fact share the same underlying code and use the ASYNC bit to
indicate that we're async.

In which case your patch would basically do kmap if ASYNC and
kmap_atomic otherwise.

I'll try to make such a patch.

Eventually the existing users (which appear to be polling) should
either be converted over to shash or switch to interrupt-based
completion.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
