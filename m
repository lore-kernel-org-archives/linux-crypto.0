Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1129C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 09:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjJ3JLp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 05:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjJ3JLp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 05:11:45 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43328A7;
        Mon, 30 Oct 2023 02:11:42 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qxOIw-00CS2p-Ob; Mon, 30 Oct 2023 17:11:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 30 Oct 2023 17:11:33 +0800
Date:   Mon, 30 Oct 2023 17:11:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Mahmoud Adam <mngyadam@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: rsa - add a check for allocation failure
Message-ID: <ZT9zRaTmFp6xl9x3@gondor.apana.org.au>
References: <d870c278-3f0e-4386-a58d-c9e2c97a7c6c@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d870c278-3f0e-4386-a58d-c9e2c97a7c6c@moroto.mountain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 30, 2023 at 12:02:59PM +0300, Dan Carpenter wrote:
> Static checkers insist that the mpi_alloc() allocation can fail so add
> a check to prevent a NULL dereference.  Small allocations like this
> can't actually fail in current kernels, but adding a check is very
> simple and makes the static checkers happy.
> 
> Fixes: 6637e11e4ad2 ("crypto: rsa - allow only odd e and restrict value in FIPS mode")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  crypto/rsa.c | 2 ++
>  1 file changed, 2 insertions(+)

Nack.  Please fix the static checker instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
