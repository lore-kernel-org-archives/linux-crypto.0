Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75797C04FDF
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 09:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjHDJew (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 05:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjHDJe3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 05:34:29 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E296A49D8;
        Fri,  4 Aug 2023 02:34:25 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qRrC8-003bYF-65; Fri, 04 Aug 2023 17:34:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Aug 2023 17:34:04 +0800
Date:   Fri, 4 Aug 2023 17:34:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wang Ming <machel@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH v2] crypto: atmel: Use dev_err_probe instead of dev_err
Message-ID: <ZMzGDIa4Ov9Mneza@gondor.apana.org.au>
References: <20230726120451.6099-1-machel@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726120451.6099-1-machel@vivo.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 26, 2023 at 08:04:41PM +0800, Wang Ming wrote:
> It is possible that dma_request_chan will return EPROBE_DEFER,
> which means that dd->dev is not ready yet. In this case,
> dev_err(dd->dev), there will be no output. This patch fixes the bug.
> 
> Signed-off-by: Wang Ming <machel@vivo.com>
> ---
>  drivers/crypto/atmel-sha.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
