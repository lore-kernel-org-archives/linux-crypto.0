From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: zip - Memory corruption in zip_clear_stats()
Date: Fri, 24 Mar 2017 22:14:07 +0800
Message-ID: <20170324141407.GG14780@gondor.apana.org.au>
References: <20170317204621.GD16505@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mahipal Challa <mahipalreddy2006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jan Glauber <jglauber@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42694 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935748AbdCXOOr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:14:47 -0400
Content-Disposition: inline
In-Reply-To: <20170317204621.GD16505@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 17, 2017 at 11:46:21PM +0300, Dan Carpenter wrote:
> There is a typo here.  It should be "stats" instead of "state".  The
> impact is that we clear 224 bytes instead of 80 and we zero out memory
> that we shouldn't.
> 
> Fixes: 09ae5d37e093 ("crypto: zip - Add Compression/Decompression statistics")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
