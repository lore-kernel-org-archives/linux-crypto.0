From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 3/3] crypto: keywrap - add testmgr support
Date: Thu, 15 Oct 2015 15:17:12 +0800
Message-ID: <20151015071712.GA1300@gondor.apana.org.au>
References: <5314960.0aGFzHXOSP@myon.chronox.de>
 <2963701.QnyuGqI2Hv@myon.chronox.de>
 <20151015071150.GA1223@gondor.apana.org.au>
 <14602522.JAGjWGXiOv@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55088 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbbJOIAe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 04:00:34 -0400
Content-Disposition: inline
In-Reply-To: <14602522.JAGjWGXiOv@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 15, 2015 at 09:13:55AM +0200, Stephan Mueller wrote:
> Note, I had to convert akcipher to skcipher -- thus, I guess you want to take 
> the newer patch and once you get back to Boris' original submission, just pull 
> the updates to the test vectors.

What I'll do is apply Boris's patch #1, and then followed by your
v3.  That should work, right?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
