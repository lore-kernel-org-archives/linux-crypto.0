From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/testmgr: don't copy from source IV too much
Date: Thu, 3 Sep 2015 21:20:57 +0800
Message-ID: <20150903132057.GA31317@gondor.apana.org.au>
References: <1441279921-26838-1-git-send-email-aryabinin@odin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrey Ryabinin <aryabinin@odin.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40023 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbbICNVG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Sep 2015 09:21:06 -0400
Content-Disposition: inline
In-Reply-To: <1441279921-26838-1-git-send-email-aryabinin@odin.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 03, 2015 at 02:32:00PM +0300, Andrey Ryabinin wrote:
> While the destination buffer 'iv' is MAX_IVLEN size,
> the source 'template[i].iv' could be smaller. Thus
> copying it via memcpy() leads to invalid memory access.
> Use strlcpy() instead.
> 
> Signed-off-by: Andrey Ryabinin <aryabinin@odin.com>

Thanks for the patch.  Unfortunately it's broken because the IV
is not a string and can contain NULs.  So either fix it by using
the real ivsize, or change template[i].iv to a char array.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
