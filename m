From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 4/9] crypto: acomp - add support for lzo via scomp
Date: Fri, 23 Sep 2016 23:05:18 +0800
Message-ID: <20160923150518.GA20384@gondor.apana.org.au>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
 <1473770981-9869-5-git-send-email-giovanni.cabiddu@intel.com>
 <20160920092618.GA20808@gondor.apana.org.au>
 <20160920115140.GA12332@sivswdev01.ir.intel.com>
 <20160922092244.GA5379@gondor.apana.org.au>
 <20160922225425.GA25907@SILVIXA00369791-F22-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44299 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034887AbcIWPFY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2016 11:05:24 -0400
Content-Disposition: inline
In-Reply-To: <20160922225425.GA25907@SILVIXA00369791-F22-1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 22, 2016 at 11:54:25PM +0100, Giovanni Cabiddu wrote:
> > I think you may have misread my earlier message from June.  What
> > I'd like to see is for the acomp layer to allocate the output
> > memory, rather than have it provided by the user as is the case
> > with the current interface.  The user could provide a maximum to
> > prevent crazy cases consuming unlimited memory.
> Why would you prefer to have the output buffer allocated in the acomp
> layer? Is there a use case for this? Who would free that memory?

When I said acomp layer I'm referring specifically to the algorithm
or driver.  As to your last question it would be the caller's
responsibility to free that memory.

The use-case is our oldest user, IPcomp.  Most packets are 1500 bytes
max but we have to allocate 64K of memory to cover the worst case.
For an algorithm that can deal with SG lists it can easily allocate
pages of memory as it goes and place them in an SG list.

> We believe that the output buffer should be allocated by the user of the
> API. A caller might decide to allocate memory upfront or point the
> buffer list to pre-allocate buffers. This would happen in BTRFS where
> its block buffers are already allocated for submission to the
> compression API.

Sure if you already have memory allocated then we don't want to
force you to allocate it again in the algorithm/driver.  But our
interface should allow the memory to be allocated in the driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
