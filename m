Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1ABCCA473
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jun 2022 00:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiFGAuu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jun 2022 20:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiFGAut (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jun 2022 20:50:49 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 324A6BA559;
        Mon,  6 Jun 2022 17:50:48 -0700 (PDT)
Received: from [192.168.87.104] (unknown [50.47.106.71])
        by linux.microsoft.com (Postfix) with ESMTPSA id 87E1320BE625;
        Mon,  6 Jun 2022 17:50:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 87E1320BE625
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654563047;
        bh=mNIWq9mEXLrb2v1fqG+qEYhLSaH2HfCn23YiIjp/ozs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MmasGyKFt3+ENYRwLKiFpoiehKjYBtnkFGsVFLDwFYkPbHgu4xCmT9g3LpBW98z80
         QZqERPjYGTiFrDX5ozdsaBbkYtYsVNQW2IAFvxy8LczsPaFDWcNSo+EoVpO3wT/ykY
         tQ2GxmhBC/gs2UkznfLjNQ6TI1QR9WyzwWInZ7lc=
Message-ID: <bba832ec-ea64-71db-385a-ab9816e7239c@linux.microsoft.com>
Date:   Mon, 6 Jun 2022 17:50:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 3/5] ARM: dts: aspeed: Add HACE device controller node
Content-Language: en-US
To:     Neal Liu <neal_liu@aspeedtech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Johnny Huang <johnny_huang@aspeedtech.com>
Cc:     devicetree@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        BMC-SW@aspeedtech.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20220606064935.1458903-1-neal_liu@aspeedtech.com>
 <20220606064935.1458903-4-neal_liu@aspeedtech.com>
From:   Dhananjay Phadke <dphadke@linux.microsoft.com>
In-Reply-To: <20220606064935.1458903-4-neal_liu@aspeedtech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/5/2022 11:49 PM, Neal Liu wrote:
> diff --git a/arch/arm/boot/dts/aspeed-g6.dtsi b/arch/arm/boot/dts/aspeed-g6.dtsi
> index 3d5ce9da42c3..371d2a6b56ef 100644
> --- a/arch/arm/boot/dts/aspeed-g6.dtsi
> +++ b/arch/arm/boot/dts/aspeed-g6.dtsi
> @@ -304,6 +304,14 @@ apb {
>   			#size-cells = <1>;
>   			ranges;
>   
> +			hace: crypto@1e6d0000 {
> +				compatible = "aspeed,ast2600-hace";
> +				reg = <0x1e6d0000 0x200>;
> +				interrupts = <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&syscon ASPEED_CLK_GATE_YCLK>;
> +				resets = <&syscon ASPEED_RESET_HACE>;

Shouldn't the left side be also 'crypto', see existing crypto nodes in 
arch/arm64/dts for example.

			crypto: crypto@1e6d0000 {
				...

Regards,
Dhananjay
