From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 1/6] crypto: SHA1 multibuffer map scatter gather walk's
 buffer address directly for x86_64
Date: Thu, 15 May 2014 11:12:03 -0700
Message-ID: <1400177523.2970.267.camel@schen9-DESK>
References: <cover.1399990803.git.tim.c.chen@linux.intel.com>
	 <1400023182.2970.238.camel@schen9-DESK>
	 <20140513233410.GA28134@gondor.apana.org.au>
	 <1400024458.2970.247.camel@schen9-DESK>
	 <20140513235813.GA28455@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18843 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaEOSU1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 May 2014 14:20:27 -0400
In-Reply-To: <20140513235813.GA28455@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2014-05-14 at 07:58 +0800, Herbert Xu wrote:
> On Tue, May 13, 2014 at 04:40:58PM -0700, Tim Chen wrote:
> > On Wed, 2014-05-14 at 07:34 +0800, Herbert Xu wrote:
> > 
> > > 
> > > Why do we need this patch since kmap_atomic is equivalent to
> > > page_address plus preempt_disable on x86-64?
> > 
> > For multi-buffers, you may still have some data lanes with jobs 
> > that are partially completed when you need to put the thread
> > to sleep.  With kmap_atomic, you cannot sleep before unmapping.
> 
> Hmm, it seems that the existing users of this helper is abusing
> the ahash interface since if they were really asynchronous they
> would be sleeping on this kmap_atomic.

The multi-buffer case certainly ran into trouble with kmap_atomic.
The scheduler complains when the crypto thread schedules out.

> 
> So we should keep the existing hash walk interface for sync users
> only and create a new interface for async users.  They could in
> fact share the same underlying code and use the ASYNC bit to
> indicate that we're async.
> 
> In which case your patch would basically do kmap if ASYNC and
> kmap_atomic otherwise.
> 
> I'll try to make such a patch.

It will be nice if scatterwalk_map and unmap can also be made
async aware. Right now it also uses kmap_atomic.
This will allow multi-buffer encryption to make use of it.  

> 
> Eventually the existing users (which appear to be polling) should
> either be converted over to shash or switch to interrupt-based
> completion.

Thanks.

Tim
