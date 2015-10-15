From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 3/3] crypto: keywrap - add testmgr support
Date: Thu, 15 Oct 2015 15:11:50 +0800
Message-ID: <20151015071150.GA1223@gondor.apana.org.au>
References: <5314960.0aGFzHXOSP@myon.chronox.de>
 <2963701.QnyuGqI2Hv@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57926 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbbJOHL5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 03:11:57 -0400
Content-Disposition: inline
In-Reply-To: <2963701.QnyuGqI2Hv@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 15, 2015 at 09:07:40AM +0200, Stephan Mueller wrote:
> The testmanager code for symmetric ciphers is extended to allow
> verification of the IV after a cipher operation.
> 
> In addition, test vectors for kw(aes) for encryption and decryption are
> added.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Oh I see.  This patch can be applied without affect any existing
drivers.  In that case I'll just apply Boris's original patch #1
and then reapply your previous submission.

Sorry for the confusion.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
