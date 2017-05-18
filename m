From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: hifn_795x: Fix a handful of minor bugs spotted
 by eye
Date: Thu, 18 May 2017 00:02:34 -0400 (EDT)
Message-ID: <20170518.000234.2271722938216696157.davem@davemloft.net>
References: <20170518032506.GA31773@gondor.apana.org.au>
        <20170518032658.GA31836@gondor.apana.org.au>
        <66259d44-37d3-eac3-7193-1ea9741c793f@deltatee.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: logang@deltatee.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:39344 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbdERECj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 May 2017 00:02:39 -0400
In-Reply-To: <66259d44-37d3-eac3-7193-1ea9741c793f@deltatee.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 17 May 2017 21:33:22 -0600

> 
> 
> On 17/05/17 09:26 PM, Herbert Xu wrote:
>> On Thu, May 18, 2017 at 11:25:06AM +0800, Herbert Xu wrote:
>>> On Fri, Apr 28, 2017 at 11:02:40AM -0600, Logan Gunthorpe wrote:
>>>> * Cleaned up the formatting of ablkcipher_get arguments so it complies
>>>>   with kernel style
>>>> * The offset in ablkcipher_get sould be added to the source, not the
>>>>   destination. We rename it to soffset for clarity.
>>>> * dst++ should be dst=sg_next(dst)
>>>> * We call kunmap_atomic earlier so we only have to do it once.
>>>> * If ablkcipher_get fails, we should probably ensure the request
>>>>   completes with an error.
> 
>>> Please don't mix unrelated changes in the same patch.
> 
> Seriously? The patch is tiny and those are all incredibly minor changes.

Yes, seriously.

It is the only way to make your changes easy to review and audit.

Please do as Herbert is asking.
