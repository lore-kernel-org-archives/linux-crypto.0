From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH] crypto: hifn_795x: Fix a handful of minor bugs spotted by
 eye
Date: Wed, 17 May 2017 21:33:22 -0600
Message-ID: <66259d44-37d3-eac3-7193-1ea9741c793f@deltatee.com>
References: <1493398960-25643-1-git-send-email-logang@deltatee.com>
 <20170518032506.GA31773@gondor.apana.org.au>
 <20170518032658.GA31836@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:40764 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754798AbdERDdb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 23:33:31 -0400
In-Reply-To: <20170518032658.GA31836@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 17/05/17 09:26 PM, Herbert Xu wrote:
> On Thu, May 18, 2017 at 11:25:06AM +0800, Herbert Xu wrote:
>> On Fri, Apr 28, 2017 at 11:02:40AM -0600, Logan Gunthorpe wrote:
>>> * Cleaned up the formatting of ablkcipher_get arguments so it complies
>>>   with kernel style
>>> * The offset in ablkcipher_get sould be added to the source, not the
>>>   destination. We rename it to soffset for clarity.
>>> * dst++ should be dst=sg_next(dst)
>>> * We call kunmap_atomic earlier so we only have to do it once.
>>> * If ablkcipher_get fails, we should probably ensure the request
>>>   completes with an error.

>> Please don't mix unrelated changes in the same patch.

Seriously? The patch is tiny and those are all incredibly minor changes.

>> Also was this tested on actual hardware? This is an old driver so
>> it's probably best to just let it be.

No, I don't have that hardware. I sent this patch because you requested it.

> Of course we do want fix the offset issue so could you please send
> a new patch with just that fix?

Sorry, no, I honestly don't see that as worth my time. Feel free to drop
the patch or roll your own.

Logan
