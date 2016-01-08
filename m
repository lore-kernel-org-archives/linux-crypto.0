From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: relocate ALG_MAX_PAGES to uapi
Date: Fri, 8 Jan 2016 20:51:54 +0800
Message-ID: <20160108125154.GA5533@gondor.apana.org.au>
References: <2751031.ZCTdkaqdWA@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38297 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbcAHMv5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jan 2016 07:51:57 -0500
Content-Disposition: inline
In-Reply-To: <2751031.ZCTdkaqdWA@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 25, 2015 at 06:14:54PM +0100, Stephan Mueller wrote:
> The define of ALG_MAX_PAGES is relevant for user space as this macro
> defines the maximum number of pages to be processed in one go by
> vmsplice/splice. If user space does not obey that limit, the calling
> thread will hang until a recvmsg is called (by another thread).
> 
> As user space should have the ability to prevent such blocks, it needs
> to know about the limit. Therefore, the define is moved to the uapi
> header file.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

I don't like exporting details like this.  User-space should not
be relying on voodoo like this to avoid hanging.

Please show me the program that actually hangs so we can figure
out what if anything needs to be done to address this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
