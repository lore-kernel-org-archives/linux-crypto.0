Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2757C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 13:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbiCVNf0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 09:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiCVNfX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 09:35:23 -0400
X-Greylist: delayed 1226 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Mar 2022 06:33:56 PDT
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.51.253])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B858B6D38E
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 06:33:56 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id E50CB2A48
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 08:13:28 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id WeKGngsSPb6UBWeKGnx9VE; Tue, 22 Mar 2022 08:13:28 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=A+xNZ3MvECqWmVurH8kTIBYeensVUd574nB3jEFM9QA=; b=IaO90SuNkjvu0rc3bzfU3AAwxC
        G6mgIyiJJD37N4vFEBE8h1DQul9RNySgTDmrN+sZWwfN1g7APykRCg17R5slOKP/+3QyMNgruWIYN
        gCPgOFOQAMVQXrnjDNkLvLj1gqzywawVBrZE+2uVP3HTV4RJwNvMaJpcF5LApArDTOGh3V2WxoXyl
        Pou0i5xbIlFQ0qLfrQ1T60GtpnsUQLWqZ1zI3mlw4H6QboxwfxvjK+Ngd0jIJhukD0jlUWUkH51pe
        7AyFEReEZ21zdg+zIr4V/R5EGjnyHMB8jJZliJ429hvFgKqYKHIRxFx33aofSBZ8x81PQbhr2Kdq1
        rSjlxl6g==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57608 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nWeKF-0034fO-UT; Tue, 22 Mar 2022 13:13:28 +0000
Date:   Tue, 22 Mar 2022 06:13:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Harsha <harsha.harsha@xilinx.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: crypto: xilinx - Turn SHA into a tristate and allow COMPILE_TEST
Message-ID: <20220322131327.GA747088@roeck-us.net>
References: <Yigc4cQlTJRRZsQg@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yigc4cQlTJRRZsQg@gondor.apana.org.au>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nWeKF-0034fO-UT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57608
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 7
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 09, 2022 at 03:20:01PM +1200, Herbert Xu wrote:
> This patch turns the new SHA driver into a tristate and also allows
> compile testing.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

This results in:

Building s390:allmodconfig ... failed
--------------
Error log:
In file included from drivers/crypto/xilinx/zynqmp-sha.c:6:
include/linux/cacheflush.h:12:46: error: 'struct folio' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]
   12 | static inline void flush_dcache_folio(struct folio *folio)

Guenter

> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 5d7508230b7d..97455a5f05c1 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -809,8 +809,8 @@ config CRYPTO_DEV_ZYNQMP_AES
>  	  for AES algorithms.
>  
>  config CRYPTO_DEV_ZYNQMP_SHA3
> -	bool "Support for Xilinx ZynqMP SHA3 hardware accelerator"
> -	depends on ZYNQMP_FIRMWARE
> +	tristate "Support for Xilinx ZynqMP SHA3 hardware accelerator"
> +	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
>  	select CRYPTO_SHA3
>  	help
>  	  Xilinx ZynqMP has SHA3 engine used for secure hash calculation.
