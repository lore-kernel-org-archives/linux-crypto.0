From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Fix byte counter overflow in SHA-512
Date: Thu, 5 Apr 2012 20:36:39 +0800
Message-ID: <20120405123639.GA22120@gondor.apana.org.au>
References: <1331929588.3549.4.camel@key-ThinkPad-W510>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kent Yoder <key@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:36543 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751562Ab2DEMgr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Apr 2012 08:36:47 -0400
Content-Disposition: inline
In-Reply-To: <1331929588.3549.4.camel@key-ThinkPad-W510>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 16, 2012 at 08:26:28PM +0000, Kent Yoder wrote:
> The current code only increments the upper 64 bits of the SHA-512 byte
> counter when the number of bytes hashed happens to hit 2^64 exactly.
> 
> This patch increments the upper 64 bits whenever the lower 64 bits
> overflows.
> 
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>

Good catch.  Patch applied to crypto and stable.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
