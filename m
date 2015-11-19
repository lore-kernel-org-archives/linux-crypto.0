From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add asynchronous compression support
Date: Thu, 19 Nov 2015 17:42:46 +0800
Message-ID: <20151119094246.GB27655@gondor.apana.org.au>
References: <1445008260-39367-1-git-send-email-weigang.li@intel.com>
 <20151016151354.GA16648@gondor.apana.org.au>
 <929511EA6367314D8E32364A24D45FA61301F63F@shsmsx102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Struk, Tadeusz" <tadeusz.struk@intel.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: "Li, Weigang" <weigang.li@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44721 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbKSJmv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Nov 2015 04:42:51 -0500
Content-Disposition: inline
In-Reply-To: <929511EA6367314D8E32364A24D45FA61301F63F@shsmsx102.ccr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 19, 2015 at 05:52:41AM +0000, Li, Weigang wrote:
>
> After sync-up with Joonsoo Kim, we think it may be not feasible for a s/w implementation of the sg-list based asynchronous interface, we propose separate interfaces (patches) for acomp & ccomp. The reasons are:
> 1. to support sg-list in the ccomp (like what shash/ahash did), the partial update is required, some algorithms do not support partial update (i.e., lzo), that means:

No this is not true.  For the ones that don't support partial
updates you can always linearise the input and then feed it in
as one chunk.  Because the overall interface you're proposing
does not allow partial updates the underlying implementation
doesn't need to do it either.  Only linearisation is necessary.

> 2. the format of output buffer (sg-list) will be different, e.g., the lzo need contain the "length" info for each block in the output sg-list in order to de-compression, while zlib doesn't need, then it is difficult to have a single async sg-list i/f.

I have no idea what you mean here.  Please explain.

> 3. to compress a sg-list buffer, the lzo also requires an intermediate buffer to save the output of a block, and copy it back to the sg-list output buffer, it will introduce the complexity and cost, we don't see value for sg-list support in a s/w compression.

Such an intermediate buffer would only  be needed if the SG list is
actually non-linear.  So I don't see this as an issue.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
