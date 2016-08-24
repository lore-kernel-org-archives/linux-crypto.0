From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next v2] crypto: sun4i-ss - fix missing unlock on error
 in sun4i_hash()
Date: Wed, 24 Aug 2016 21:14:19 +0800
Message-ID: <20160824131419.GD3850@gondor.apana.org.au>
References: <1471560130-5265-1-git-send-email-weiyj.lk@gmail.com>
 <1471690133-24396-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47994 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755965AbcHXNOm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 09:14:42 -0400
Content-Disposition: inline
In-Reply-To: <1471690133-24396-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 20, 2016 at 10:48:53AM +0000, Wei Yongjun wrote:
> Add the missing unlock before return from function sun4i_hash()
> in the error handling case.
> 
> Fixes: 477d9b2e591b ("crypto: sun4i-ss - unify update/final function")
> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
