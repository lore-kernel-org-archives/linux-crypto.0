From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: s5p-sss - Use devm_clk_get()
Date: Sun, 20 Jan 2013 11:13:09 +1100
Message-ID: <20130120001309.GC26742@gondor.apana.org.au>
References: <007501cdeed6$f73f1150$e5bd33f0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"'David S. Miller'" <davem@davemloft.net>
To: Jingoo Han <jg1.han@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:54127 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751389Ab3ATANM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 19:13:12 -0500
Content-Disposition: inline
In-Reply-To: <007501cdeed6$f73f1150$e5bd33f0$%han@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 10, 2013 at 11:05:30AM +0900, Jingoo Han wrote:
> Use devm_clk_get() rather than clk_get() to make cleanup paths
> more simple.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
