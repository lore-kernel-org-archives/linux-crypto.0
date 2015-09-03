From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: testmgr: templates not tested
Date: Thu, 3 Sep 2015 21:18:32 +0800
Message-ID: <20150903131832.GA31260@gondor.apana.org.au>
References: <2425525.lUG5gvxoc6@myon.chronox.de>
 <20150903074539.GA28992@gondor.apana.org.au>
 <1503977.HnUv4rvHWj@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41512 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbbICNSh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Sep 2015 09:18:37 -0400
Content-Disposition: inline
In-Reply-To: <1503977.HnUv4rvHWj@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 03, 2015 at 12:21:37PM +0200, Stephan Mueller wrote:
> 
> I see. But then it seems to be a pervasive bug as xts suffers from the same 
> issue too.

Right.  Every ablkcipher template has the same issue.  That's why
I wanted to take care of this in bulk with the skcipher conversion
rather than fixing them one-by-one.

> Would you please be so kind and give me a hint what exactly would need to be 
> done with the cra_name? I continued working on the keywrap template and have 
> it now complete. The only lingering issue is the testmgr where the test for 
> keywrap is not invoked.

You just need to grab the cra_name of the underlying algorithm
rather than using the input string.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
