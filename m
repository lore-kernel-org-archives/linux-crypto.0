From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v7 4/9] crypto: acomp - add support for lzo via scomp
Date: Thu, 22 Sep 2016 23:54:25 +0100
Message-ID: <20160922225425.GA25907@SILVIXA00369791-F22-1>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
 <1473770981-9869-5-git-send-email-giovanni.cabiddu@intel.com>
 <20160920092618.GA20808@gondor.apana.org.au>
 <20160920115140.GA12332@sivswdev01.ir.intel.com>
 <20160922092244.GA5379@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56806 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933647AbcIVWy1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 18:54:27 -0400
Content-Disposition: inline
In-Reply-To: <20160922092244.GA5379@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 22, 2016 at 05:22:44PM +0800, Herbert Xu wrote:
> I'm suggesting that we have just one set of buffers for all scomp
> algorithms.  After all, a CPU can only process one request at a
> time.
Makes sense. Implemented in v8.

> Yes scomp should just be flat.  A sync algorithm capable of producing
> partial output should use the acomp interface.
I went back to scomp interface in v6.
>
> I think you may have misread my earlier message from June.  What
> I'd like to see is for the acomp layer to allocate the output
> memory, rather than have it provided by the user as is the case
> with the current interface.  The user could provide a maximum to
> prevent crazy cases consuming unlimited memory.
Why would you prefer to have the output buffer allocated in the acomp
layer? Is there a use case for this? Who would free that memory?

We believe that the output buffer should be allocated by the user of the
API. A caller might decide to allocate memory upfront or point the
buffer list to pre-allocate buffers. This would happen in BTRFS where
its block buffers are already allocated for submission to the
compression API.

Thanks,

--
Giovanni
