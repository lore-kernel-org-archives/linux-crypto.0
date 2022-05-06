Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC565C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 10:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390900AbiEFKY5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 06:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390918AbiEFKYz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 06:24:55 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376D062BD4;
        Fri,  6 May 2022 03:21:12 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nmv4u-00AgCD-An; Fri, 06 May 2022 20:20:53 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 May 2022 18:20:52 +0800
Date:   Fri, 6 May 2022 18:20:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a: Add support for ATSHA204
 cryptochip
Message-ID: <YnT2hEGHs5YXnKr2@gondor.apana.org.au>
References: <20220421134457.5867-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220421134457.5867-1-pali@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 21, 2022 at 03:44:57PM +0200, Pali Rohár wrote:
> ATSHA204 is predecessor of ATSHA204A which supports less features and some
> of them are slightly different.
> 
> Introduce a new compatible string for ATSHA204 cryptochip "atmel,atsha204".
> 
> Current version of Linux kernel driver atmel-sha204a.c implements only hw
> random number generator which is same in both ATSHA204 and ATSHA204A
> cryptochips. So driver already supports also ATSHA204 hw generator, so just
> simply extends list of compatible strings.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  Documentation/devicetree/bindings/trivial-devices.yaml | 4 +++-
>  drivers/crypto/atmel-sha204a.c                         | 2 ++
>  2 files changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
