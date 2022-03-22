Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9CAC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 12:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiCVMBk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 08:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbiCVMBj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 08:01:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BD89522DA;
        Tue, 22 Mar 2022 05:00:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A58D153B;
        Tue, 22 Mar 2022 05:00:11 -0700 (PDT)
Received: from [10.57.43.230] (unknown [10.57.43.230])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 956A63F73B;
        Tue, 22 Mar 2022 05:00:08 -0700 (PDT)
Message-ID: <70422777-a3f9-b2f1-5faa-94d24fe200ac@arm.com>
Date:   Tue, 22 Mar 2022 12:00:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 18/26] arm64: dts: rockchip: rk3399: add crypto node
Content-Language: en-GB
To:     Corentin Labbe <clabbe@baylibre.com>, heiko@sntech.de,
        herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
References: <20220321200739.3572792-1-clabbe@baylibre.com>
 <20220321200739.3572792-19-clabbe@baylibre.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220321200739.3572792-19-clabbe@baylibre.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-03-21 20:07, Corentin Labbe wrote:
> The rk3399 has a crypto IP handled by the rk3288 crypto driver so adds a
> node for it.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>   arch/arm64/boot/dts/rockchip/rk3399.dtsi | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
> index 88f26d89eea1..ca2c658371a5 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
> @@ -573,6 +573,18 @@ saradc: saradc@ff100000 {
>   		status = "disabled";
>   	};
>   
> +	crypto0: crypto@ff8b0000 {
> +		compatible = "rockchip,rk3399-crypto";
> +		reg = <0x0 0xff8b0000 0x0 0x4000>,
> +		      <0x0 0xff8b8000 0x0 0x4000>;
> +		interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH 0>,
> +			     <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH 0>;
> +		clocks = <&cru SCLK_CRYPTO0>, <&cru HCLK_M_CRYPTO0>, <&cru HCLK_S_CRYPTO0>,
> +			 <&cru SCLK_CRYPTO1>, <&cru HCLK_M_CRYPTO1>, <&cru HCLK_S_CRYPTO1>;
> +		resets = <&cru SRST_CRYPTO0>, <&cru SRST_CRYPTO0_S>, <&cru SRST_CRYPTO0_M>,
> +			 <&cru SRST_CRYPTO1>, <&cru SRST_CRYPTO1_S>, <&cru SRST_CRYPTO1_M>;
> +	};

What's going on here? If these are simply two instances of the same IP 
block as the evidence suggests, why are they crammed into a single DT 
node rather than simply being described as two separate instances? I was 
rather wondering what all the confusing mess in patch #16 was about, 
until I got here.

If there's something in the crypto API that means the driver can't 
simply naively register itself multiple times, there should be any 
number of ways for the probe routine to keep track of whether it's 
already registered something and associate any subsequent devices with 
the first one internally if need be. Linux implementation details should 
not leak out as non-standard DT weirdness.

I know the Rockchip IOMMU driver does this, but in that case the two 
IOMMU instances are closely coupled and sharing work such that they 
effectively need to be programmed identically at all times, so it was a 
bit more justifiable. I don't know the full story here, but it certainly 
looks like rk_get_engine_number() is just a means to schedule work on 
any available unit independently, so looks like it wouldn't take much to 
select between distinct devices at that point, and actually end up a lot 
simpler and cleaner overall.

Robin.

> +
>   	i2c1: i2c@ff110000 {
>   		compatible = "rockchip,rk3399-i2c";
>   		reg = <0x0 0xff110000 0x0 0x1000>;
