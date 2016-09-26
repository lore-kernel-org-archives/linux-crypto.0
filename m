From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v7 4/9] crypto: acomp - add support for lzo via scomp
Date: Mon, 26 Sep 2016 18:27:04 +0100
Message-ID: <20160926172704.GA24726@SILVIXA00369791-F22-1>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
 <1473770981-9869-5-git-send-email-giovanni.cabiddu@intel.com>
 <20160920092618.GA20808@gondor.apana.org.au>
 <20160920115140.GA12332@sivswdev01.ir.intel.com>
 <20160922092244.GA5379@gondor.apana.org.au>
 <20160922225425.GA25907@SILVIXA00369791-F22-1>
 <20160923150518.GA20384@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:14849 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161478AbcIZR1G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2016 13:27:06 -0400
Content-Disposition: inline
In-Reply-To: <20160923150518.GA20384@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 23, 2016 at 11:05:18PM +0800, Herbert Xu wrote:
> When I said acomp layer I'm referring specifically to the algorithm
> or driver.  As to your last question it would be the caller's
> responsibility to free that memory.
>
> The use-case is our oldest user, IPcomp.  Most packets are 1500 bytes
> max but we have to allocate 64K of memory to cover the worst case.
> For an algorithm that can deal with SG lists it can easily allocate
> pages of memory as it goes and place them in an SG list.
It is clear now. Thanks.

> Sure if you already have memory allocated then we don't want to
> force you to allocate it again in the algorithm/driver.  But our
> interface should allow the memory to be allocated in the driver.
I think the definition of the acomp interface already allows for this.
If the destination scatterlist inside the request is NULL, the
algorithm/driver can allocate pages of memory for the output buffers as
well as the scatterlist. In this case, the destination length, if not zero,
could be used to specify the maximum size to allocate.
What do you think?

--
Giovanni
