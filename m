Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3BDC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 09:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiBKJhn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 04:37:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbiBKJhn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 04:37:43 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A05216;
        Fri, 11 Feb 2022 01:37:42 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nISMt-0004VV-UO; Fri, 11 Feb 2022 20:37:33 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Feb 2022 20:37:31 +1100
Date:   Fri, 11 Feb 2022 20:37:31 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        alexandre.belloni@bootlin.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kavyasree.kotagiri@microchip.com
Subject: Re: [PATCH] crypto: atmel-tdes: Add support for the TDES IP
 available on sama7g5 SoC
Message-ID: <YgYuW7MNkcAx7Sp2@gondor.apana.org.au>
References: <20220204133522.498387-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204133522.498387-1-tudor.ambarus@microchip.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 04, 2022 at 03:35:22PM +0200, Tudor Ambarus wrote:
> Add support for the TDES IP found on sama7g5.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  drivers/crypto/atmel-tdes.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
