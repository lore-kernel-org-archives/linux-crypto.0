From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: PATCH crypto/zlib: Allow Z_OK return value from zlib_deflate
Date: Wed, 23 Dec 2009 20:01:57 +0800
Message-ID: <20091223120157.GA29795@gondor.apana.org.au>
References: <20091220192122.M17448@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	vtaras@cs.sunysb.edu,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Aseem Rastogi <arastogi@cs.sunysb.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53088 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754493AbZLWMCB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Dec 2009 07:02:01 -0500
Content-Disposition: inline
In-Reply-To: <20091220192122.M17448@cs.sunysb.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 20, 2009 at 02:34:09PM -0500, Aseem Rastogi wrote:
> From: Aseem Rastogi
> 
> crypto/zlib: When zlib_deflate is called with Z_FINISH flag, it should be
> considered valid if it returns Z_OK instead of Z_STREAM_END.
> 
> zlib_defalte allows callers to call it with Z_FINISH flag multiple times. This
> is useful if output buffer did not have enough space first time zlib_deflate
> was called with Z_FINISH set. zlib_deflate returns Z_OK in that case and
> expects that caller will invoke it again with Z_FINISH set to collect
> remaining data. So, return value from zlib_deflate can be Z_OK OR
> Z_STREAM_END. zlib_compress_final is modified to allow return value of Z_OK.
> 
> Signed-off-by: Aseem Rastogi <arastogi@cs.sunysb.edu>
> Tested-by: Aseem Rastogi <arastogi@cs.sunysb.edu>
> Reviewed-by: Vasily Tarasov <vtaras@cs.sunysb.edu>

Hmm, it seems that the semantics of the final function isn't
quite right.  It was never meant to be called multiple times.

Let me see if we can fix this up without touching the interface.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
