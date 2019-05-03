Return-Path: <SRS0=LfhG=TD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76D5C004C9
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 13:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 822C72075E
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 13:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfECNZh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 May 2019 09:25:37 -0400
Received: from [5.180.42.13] ([5.180.42.13]:38092 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfECNZg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 May 2019 09:25:36 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hMRNh-0005mA-HQ; Fri, 03 May 2019 14:09:13 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hMRNe-0003D6-9I; Fri, 03 May 2019 14:09:10 +0800
Date:   Fri, 3 May 2019 14:09:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: atmel - remove set but not used variable
 'alg_name'
Message-ID: <20190503060910.4zm2k5lmmhamx5m7@gondor.apana.org.au>
References: <20190424075352.22828-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424075352.22828-1-yuehaibing@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 24, 2019 at 03:53:52PM +0800, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> 
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/crypto/atmel-tdes.c: In function 'atmel_tdes_setkey':
> drivers/crypto/atmel-tdes.c:803:14: warning: variable 'alg_name' set but not used [-Wunused-but-set-variable]
> 
> It is not used any more since
> commit 52ea3cd2917b ("crypto: atmel - Forbid 2-key 3DES in FIPS mode")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/atmel-tdes.c | 3 ---
>  1 file changed, 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
