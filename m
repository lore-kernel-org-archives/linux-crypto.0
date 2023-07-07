Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575FFC001B0
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jul 2023 04:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjGGEUp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jul 2023 00:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjGGEUo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2023 00:20:44 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6F89E;
        Thu,  6 Jul 2023 21:20:42 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qHcxI-000ihl-UY; Fri, 07 Jul 2023 14:20:30 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jul 2023 14:20:21 +1000
Date:   Fri, 7 Jul 2023 14:20:21 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] KEYS: asymmetric: Fix error codes
Message-ID: <ZKeShVE4UWMvU9zi@gondor.apana.org.au>
References: <c5e34c6a-da1e-4585-98c4-14701b0e093e@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5e34c6a-da1e-4585-98c4-14701b0e093e@moroto.mountain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 03, 2023 at 05:18:08PM +0300, Dan Carpenter wrote:
> These error paths should return the appropriate error codes instead of
> returning success.
> 
> Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  crypto/asymmetric_keys/public_key.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
