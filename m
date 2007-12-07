From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: scatterwalk_map_and_copy may cause kernel oops
Date: Fri, 7 Dec 2007 17:23:34 +0800
Message-ID: <20071207092334.GB8496@gondor.apana.org.au>
References: <200712060625.lB66Pv3P006826@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2697 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624AbXLGJXg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 04:23:36 -0500
Content-Disposition: inline
In-Reply-To: <200712060625.lB66Pv3P006826@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 06, 2007 at 12:25:57AM -0600, Joy Latten wrote:
> In scatterwalk_map_and_copy(), sg_next(sg) is called, 
> loop goes back to top and scatterwalk_start() gets called
> again. When next sg is NULL, BUG_ON may occur in next call to
> scatterwalk_start().
> 
> Please let me know if following patch takes
> right approach to fix this.

If it's NULL it means that the sg you're giving it doesn't have
sufficient data so you need to find out why that is the case.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
