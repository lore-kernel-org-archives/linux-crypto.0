From: "Joonsoo Kim" <iamjoonsoo.kim@lge.com>
Subject: RE: [PATCH] crypto: add asynchronous compression support
Date: Fri, 20 Nov 2015 15:04:47 +0900
Message-ID: <003101d12359$5c1f9450$145ebcf0$@lge.com>
References: <1445008260-39367-1-git-send-email-weigang.li@intel.com> <20151016151354.GA16648@gondor.apana.org.au> <929511EA6367314D8E32364A24D45FA61301F63F@shsmsx102.ccr.corp.intel.com> <20151119094246.GB27655@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	"'Struk, Tadeusz'" <tadeusz.struk@intel.com>,
	"'Sergey Senozhatsky'" <sergey.senozhatsky.work@gmail.com>,
	<minchan@kernel.org>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>,
	"'Li, Weigang'" <weigang.li@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from LGEAMRELO12.lge.com ([156.147.23.52]:49904 "EHLO
	lgeamrelo12.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbbKTGEt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Nov 2015 01:04:49 -0500
In-Reply-To: <20151119094246.GB27655@gondor.apana.org.au>
Content-Language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello, Herbert.

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Thursday, November 19, 2015 6:43 PM
> To: Li, Weigang
> Cc: linux-crypto@vger.kernel.org; Struk, Tadeusz; Joonsoo Kim; Sergey
> Senozhatsky
> Subject: Re: [PATCH] crypto: add asynchronous compression support
> 
> On Thu, Nov 19, 2015 at 05:52:41AM +0000, Li, Weigang wrote:
> >
> > After sync-up with Joonsoo Kim, we think it may be not feasible for a
> s/w implementation of the sg-list based asynchronous interface, we propose
> separate interfaces (patches) for acomp & ccomp. The reasons are:
> > 1. to support sg-list in the ccomp (like what shash/ahash did), the
> partial update is required, some algorithms do not support partial update
> (i.e., lzo), that means:
> 
> No this is not true.  For the ones that don't support partial
> updates you can always linearise the input and then feed it in
> as one chunk.  Because the overall interface you're proposing
> does not allow partial updates the underlying implementation
> doesn't need to do it either.  Only linearisation is necessary.

Linearization would be enough to use sg-list but it has a problem.
Linearization needs sleepable function such as vmap() and it makes
sync (de)compression in atomic context impossible. Currently, zram
did sync (de)compression in atomic context. It uses map_vm_area() which
isn't sleepable function to linearize two separate pages. This is possible
because zram already knows that maximum number of spread pages is just two
and have allocated vm area in advance. But, if we implement linearization
in general API, we can't be sure of request input size so we need
sleepable function, vmap().

And, this sleep could degrade performance.

> > 2. the format of output buffer (sg-list) will be different, e.g., the
> lzo need contain the "length" info for each block in the output sg-list in
> order to de-compression, while zlib doesn't need, then it is difficult to
> have a single async sg-list i/f.
> 
> I have no idea what you mean here.  Please explain.
> 
> > 3. to compress a sg-list buffer, the lzo also requires an intermediate
> buffer to save the output of a block, and copy it back to the sg-list
> output buffer, it will introduce the complexity and cost, we don't see
> value for sg-list support in a s/w compression.
> 
> Such an intermediate buffer would only  be needed if the SG list is
> actually non-linear.  So I don't see this as an issue.

Intermediate buffer size could vary greatly so it would be allocated and
Freed whenever requested. This could affect performance.

I think that supporting unified API has more loss than gain.
I'm not expert on this area so please let me know what I missed.

Thanks.
