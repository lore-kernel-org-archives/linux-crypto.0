From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: DRBG - fix freeing of resources
Date: Thu, 21 Sep 2017 16:05:31 +0800
Message-ID: <20170921080530.GA7718@gondor.apana.org.au>
References: <5295371.QYDBsUotKj@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:44852 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdIUIFu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 04:05:50 -0400
Content-Disposition: inline
In-Reply-To: <5295371.QYDBsUotKj@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 14, 2017 at 05:10:28PM +0200, Stephan Müller wrote:
> During the change to use aligned buffers, the deallocation code path was
> not updated correctly. The current code tries to free the aligned buffer
> pointer and not the original buffer pointer as it is supposed to.
> 
> Thus, the code is updated to free the original buffer pointer and set
> the aligned buffer pointer that is used throughout the code to NULL.
> 
> Fixes: 3cfc3b9721123 ("crypto: drbg - use aligned buffers")
> CC: <stable@vger.kernel.org>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
