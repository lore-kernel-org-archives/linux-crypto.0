From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 4/9] crypto: acomp - add support for lzo via scomp
Date: Tue, 27 Sep 2016 11:07:01 +0800
Message-ID: <20160927030701.GA8579@gondor.apana.org.au>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
 <1473770981-9869-5-git-send-email-giovanni.cabiddu@intel.com>
 <20160920092618.GA20808@gondor.apana.org.au>
 <20160920115140.GA12332@sivswdev01.ir.intel.com>
 <20160922092244.GA5379@gondor.apana.org.au>
 <20160922225425.GA25907@SILVIXA00369791-F22-1>
 <20160923150518.GA20384@gondor.apana.org.au>
 <20160926172704.GA24726@SILVIXA00369791-F22-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52012 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752075AbcI0DHI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2016 23:07:08 -0400
Content-Disposition: inline
In-Reply-To: <20160926172704.GA24726@SILVIXA00369791-F22-1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 26, 2016 at 06:27:04PM +0100, Giovanni Cabiddu wrote:
>
> I think the definition of the acomp interface already allows for this.
> If the destination scatterlist inside the request is NULL, the
> algorithm/driver can allocate pages of memory for the output buffers as
> well as the scatterlist. In this case, the destination length, if not zero,
> could be used to specify the maximum size to allocate.
> What do you think?

Sounds good to me.  We should also add a function to free the
resulting SG list along with the allocated pages.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
