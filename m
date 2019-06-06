Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F16FC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CCF1207E0
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFFG6R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 02:58:17 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39112 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFG6R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 02:58:17 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYmLk-00072Z-NW; Thu, 06 Jun 2019 14:58:12 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYmLj-0006n9-FY; Thu, 06 Jun 2019 14:58:11 +0800
Date:   Thu, 6 Jun 2019 14:58:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, ard.biesheuvel@linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 -next] crypto: atmel-i2c - Fix build error while CRC16
 set to m
Message-ID: <20190606065811.wxt5xy6jgol4svw6@gondor.apana.org.au>
References: <20190531094900.12708-1-yuehaibing@huawei.com>
 <20190531121749.9144-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190531121749.9144-1-yuehaibing@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 31, 2019 at 08:17:49PM +0800, YueHaibing wrote:
> If CRYPTO_DEV_ATMEL_ECC is set m, which select CRC16 to m,
> while CRYPTO_DEV_ATMEL_SHA204A is set to y, building fails.
> 
> drivers/crypto/atmel-i2c.o: In function 'atmel_i2c_checksum':
> atmel-i2c.c:(.text+0x16): undefined reference to 'crc16'
> 
> Add CRC16 dependency to CRYPTO_DEV_ATMEL_SHA204A
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2：use 'select' instead of 'depends on'
> ---
>  drivers/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
