From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v3 10/17] crypto: Add userspace report for ablkcipher
 type algorithms
Date: Mon, 26 Sep 2011 07:35:17 +0200
Message-ID: <20110926053516.GY1808@secunet.com>
References: <20110921085855.GE1808@secunet.com>
 <20110921090716.GO1808@secunet.com>
 <20110924032125.GA26475@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:37734 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab1IZFfU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Sep 2011 01:35:20 -0400
Content-Disposition: inline
In-Reply-To: <20110924032125.GA26475@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 24, 2011 at 01:21:25PM +1000, Herbert Xu wrote:
> 
> I don't think you should distinguish between BLKCIPHER and ABLKCIPHER.
> A good rule of thumb would be if the report data structure is the
> same, then the type value should be the same.
> 

Ok, will do that. I'll update the patches and resend.

Thanks for the review!
