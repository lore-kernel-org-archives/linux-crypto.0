Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76020C43334
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jun 2022 11:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiF2Ltd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jun 2022 07:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiF2Ltc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jun 2022 07:49:32 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62D2E36B66;
        Wed, 29 Jun 2022 04:49:32 -0700 (PDT)
Received: from [192.168.87.140] (unknown [50.47.106.71])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9735720CDF3E;
        Wed, 29 Jun 2022 04:49:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9735720CDF3E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1656503372;
        bh=AEyPLBYYSo/wX4+qiUmPddKmayPPSCumjui9dS8KgUE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fC6LK0gvTlLyx/plpmWv8fA+3Nq/iABKGRS+dnEFFUFKbYvYaQ/i58EaXwy4tkSBT
         zy03y+sF/qzjd5obPYh0s2pEMeeZxpIGYKvWgq/AsgGE4RT1xJnepTDI0XcMnK9IXA
         5sn2XHuPJM3OozemERefqT9c0gmkcz/a9c+I9wdM=
Message-ID: <c24d0e6d-d9ba-68c5-b1c8-13ad31d39ec8@linux.microsoft.com>
Date:   Wed, 29 Jun 2022 04:49:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 2/5] dt-bindings: clock: Add AST2500/AST2600 HACE reset
 definition
Content-Language: en-US
To:     Neal Liu <neal_liu@aspeedtech.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Randy Dunlap <rdunlap@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Dhananjay Phadke <dhphadke@microsoft.com>,
        Johnny Huang <johnny_huang@aspeedtech.com>
Cc:     devicetree@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        BMC-SW@aspeedtech.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20220629094426.1930589-1-neal_liu@aspeedtech.com>
 <20220629094426.1930589-3-neal_liu@aspeedtech.com>
From:   Dhananjay Phadke <dphadke@linux.microsoft.com>
In-Reply-To: <20220629094426.1930589-3-neal_liu@aspeedtech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/29/2022 2:44 AM, Neal Liu wrote:
> Add HACE reset bit definition for AST2500/AST2600.
> 
> Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
> Signed-off-by: Johnny Huang <johnny_huang@aspeedtech.com>
> ---
>   include/dt-bindings/clock/aspeed-clock.h  | 1 +
>   include/dt-bindings/clock/ast2600-clock.h | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/include/dt-bindings/clock/aspeed-clock.h b/include/dt-bindings/clock/aspeed-clock.h
> index 9ff4f6e4558c..06d568382c77 100644
> --- a/include/dt-bindings/clock/aspeed-clock.h
> +++ b/include/dt-bindings/clock/aspeed-clock.h
> @@ -52,5 +52,6 @@
>   #define ASPEED_RESET_I2C		7
>   #define ASPEED_RESET_AHB		8
>   #define ASPEED_RESET_CRT1		9
> +#define ASPEED_RESET_HACE		10

NAK.

I replied to older v5 of this patch, but this v6 also looks incorrect
as per HW manual.

https://lore.kernel.org/linux-arm-kernel/20220629032008.1579899-1-neal_liu@aspeedtech.com/T/#m000bd3388b3e41117aa0eef10bf6f8a6a3a85cce

For both AST2400 and AST2500:
SCU04[10] = PECI.

It will be best to refactor/split aspeed-clock.h into separate files.

Regards,
Dhananjay
