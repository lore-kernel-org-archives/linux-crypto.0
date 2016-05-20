From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Fix AES XTS error for request sizes above
 4096
Date: Sat, 21 May 2016 07:35:43 +0800
Message-ID: <20160520233543.GB18006@gondor.apana.org.au>
References: <20160520223303.7738.5391.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Gary Hook <gary.hook@amd.com>,
	David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36168 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbcETXft (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 May 2016 19:35:49 -0400
Content-Disposition: inline
In-Reply-To: <20160520223303.7738.5391.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 20, 2016 at 05:33:03PM -0500, Tom Lendacky wrote:
> The ccp-crypto module for AES XTS support has a bug that can allow requests
> greater than 4096 bytes in size to be passed to the CCP hardware. The CCP
> hardware does not support request sizes larger than 4096, resulting in
> incorrect output. The request should actually be handled by the fallback
> mechanism instantiated by the ccp-crypto module.
> 
> Add a check to insure the request size is less than or equal to the maximum
> supported size and use the fallback mechanism if it is not.
> 
> Cc: <stable@vger.kernel.org> # 3.14.x-
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

I'm OK with this patch but I think it doesn't always need to go into
the fallback.  I made a test vector split as 4064 bytes + 48 bytes
and ccp handled it just fine.  It appears that the bug is actually
in the handling of a single SG entry that's longer than a page,
presumably because sg_next is used unconditionally instead of
checking whether there is more in the current SG entry.

But I'll merge your fix as it fixes a real problem.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
