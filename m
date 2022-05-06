Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC86C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 10:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390854AbiEFK0y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 06:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390957AbiEFK0w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 06:26:52 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF9366235
        for <linux-crypto@vger.kernel.org>; Fri,  6 May 2022 03:23:09 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nmv6v-00AgK7-Dw; Fri, 06 May 2022 20:22:58 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 May 2022 18:22:57 +0800
Date:   Fri, 6 May 2022 18:22:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel - Avoid flush_scheduled_work() usage
Message-ID: <YnT3AeQslt2+bpuw@gondor.apana.org.au>
References: <35da6cb2-910f-f892-b27a-4a8bac9fd1b1@I-love.SAKURA.ne.jp>
 <Ymt4BfQXbXkY2qo0@gondor.apana.org.au>
 <5de198b9-7488-13e4-bf22-6c58c1c8b401@I-love.SAKURA.ne.jp>
 <YmulfBqsSON47lDR@gondor.apana.org.au>
 <15b21200-c639-7d62-bd7f-a559d2ee0ac5@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15b21200-c639-7d62-bd7f-a559d2ee0ac5@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Apr 30, 2022 at 04:01:46PM +0900, Tetsuo Handa wrote:
> Flushing system-wide workqueues is dangerous and will be forbidden.
> Replace system_wq with local atmel_wq.
> 
> If CONFIG_CRYPTO_DEV_ATMEL_{I2C,ECC,SHA204A}=y, the ordering in Makefile
> guarantees that module_init() for atmel-i2c runs before module_init()
> for atmel-ecc and atmel-sha204a runs.
> 
> Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
> Changes in v2:
>   Add a comment for built-in case to Makefile, suggested by Herbert Xu <herbert@gondor.apana.org.au>
> 
>  drivers/crypto/Makefile        |  1 +
>  drivers/crypto/atmel-ecc.c     |  2 +-
>  drivers/crypto/atmel-i2c.c     | 24 +++++++++++++++++++++++-
>  drivers/crypto/atmel-i2c.h     |  1 +
>  drivers/crypto/atmel-sha204a.c |  2 +-
>  5 files changed, 27 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
