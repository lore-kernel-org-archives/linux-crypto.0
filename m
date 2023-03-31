Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987C4C76196
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 10:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjCaKNC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 06:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbjCaKLr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 06:11:47 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D9C22E91;
        Fri, 31 Mar 2023 03:06:22 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1piBdx-00AlaG-E7; Fri, 31 Mar 2023 18:06:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Mar 2023 18:06:01 +0800
Date:   Fri, 31 Mar 2023 18:06:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: mxs-dcp - Use the
 devm_clk_get_optional_enabled() helper
Message-ID: <ZCawiUe2oX+YlArR@gondor.apana.org.au>
References: <c1049046280d78d92c7d0342e354e2429ce0176a.1679840050.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1049046280d78d92c7d0342e354e2429ce0176a.1679840050.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 26, 2023 at 04:14:25PM +0200, Christophe JAILLET wrote:
> Use devm_clk_get_optional_enabled() instead of hand writing it.
> This saves some loC and improves the semantic.
> 
> update the error handling path and the remove function accordingly.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/crypto/mxs-dcp.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
