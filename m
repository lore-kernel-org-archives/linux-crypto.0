From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 3/3] crypto: keywrap - add testmgr support
Date: Thu, 15 Oct 2015 18:17:21 +0800
Message-ID: <20151015101721.GA2429@gondor.apana.org.au>
References: <5314960.0aGFzHXOSP@myon.chronox.de>
 <14602522.JAGjWGXiOv@myon.chronox.de>
 <20151015071712.GA1300@gondor.apana.org.au>
 <3096789.LEo1AbLp1U@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45334 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbbJOKR3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 06:17:29 -0400
Content-Disposition: inline
In-Reply-To: <3096789.LEo1AbLp1U@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 15, 2015 at 12:10:41PM +0200, Stephan Mueller wrote:
> 
> That would work, if you replace the ablkcipher calls in Boris' patch with 
> skcipher to make that patch work.

Right I'll do that when I merge the patch.

Thanks for the heads up.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
