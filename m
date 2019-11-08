Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBF3C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 15:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77D822178F
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 15:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfKHPVh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 10:21:37 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58052 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfKHPVh (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Fri, 8 Nov 2019 10:21:37 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iT64q-0007NY-Ij; Fri, 08 Nov 2019 23:21:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iT64o-0007AV-VB; Fri, 08 Nov 2019 23:21:30 +0800
Date:   Fri, 8 Nov 2019 23:21:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tudor.Ambarus@microchip.com
Cc:     Nicolas.Ferre@microchip.com, alexandre.belloni@bootlin.com,
        Ludovic.Desroches@microchip.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: atmel - Fix selection of CRYPTO_AUTHENC
Message-ID: <20191108152130.k5kftsyqqfjjoifm@gondor.apana.org.au>
References: <20191028073907.pbk6j5fvi7ludbvx@gondor.apana.org.au>
 <20191101164027.22478-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101164027.22478-1-tudor.ambarus@microchip.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 01, 2019 at 04:40:37PM +0000, Tudor.Ambarus@microchip.com wrote:
> From: Tudor Ambarus <tudor.ambarus@microchip.com>
> 
> The following error is raised when CONFIG_CRYPTO_DEV_ATMEL_AES=y and
> CONFIG_CRYPTO_DEV_ATMEL_AUTHENC=m:
> drivers/crypto/atmel-aes.o: In function `atmel_aes_authenc_setkey':
> atmel-aes.c:(.text+0x9bc): undefined reference to `crypto_authenc_extractkeys'
> Makefile:1094: recipe for target 'vmlinux' failed
> 
> Fix it by moving the selection of CRYPTO_AUTHENC under
> config CRYPTO_DEV_ATMEL_AES.
> 
> Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to...")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  drivers/crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
