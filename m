From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Fix aead_{sendmsg,recvmsg}() signatures.
Date: Sat, 18 Apr 2015 09:33:17 +0800
Message-ID: <20150418013317.GB1329@gondor.apana.org.au>
References: <20150417.151953.196971237843380420.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43496 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbbDRBdU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 21:33:20 -0400
Content-Disposition: inline
In-Reply-To: <20150417.151953.196971237843380420.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 17, 2015 at 03:19:53PM -0400, David Miller wrote:
> 
> The kiocb argument is no longer present.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

I think Linus has already fixed this with

commit eccd02f32a2c25139da2d5e72ebab1fee7b5baab
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Apr 15 14:09:46 2015 -0700

    crypto: fix mis-merge with the networking merge

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
