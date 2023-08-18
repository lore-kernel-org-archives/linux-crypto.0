Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06103C7112B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 09:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359104AbjHRJad (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359173AbjHRJa1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 05:30:27 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DB930E6;
        Fri, 18 Aug 2023 02:30:24 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qWvo6-005FRg-Ot; Fri, 18 Aug 2023 17:30:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Aug 2023 17:30:15 +0800
Date:   Fri, 18 Aug 2023 17:30:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam: fix unchecked return value error
Message-ID: <ZN86J0NLa2nkhZIG@gondor.apana.org.au>
References: <20230808105527.1707039-1-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808105527.1707039-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 08, 2023 at 12:55:25PM +0200, meenakshi.aggarwal@nxp.com wrote:
> From: Gaurav Jain <gaurav.jain@nxp.com>
> 
> error:
> Unchecked return value (CHECKED_RETURN)
> check_return: Calling sg_miter_next without checking return value
> 
> fix:
> added check if(!sg_miter_next)
> 
> Fixes: 8a2a0dd35f2e ("crypto: caam - strip input zeros from RSA input buffer")
> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
> Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> ---
>  drivers/crypto/caam/caampkc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
