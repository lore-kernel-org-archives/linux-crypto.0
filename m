Return-Path: <SRS0=g7fO=NJ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33352 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbeJ2WT2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Oct 2018 18:19:28 -0400
From: AnilKumar Chimata <anilc@codeaurora.org>
Subject: Re: [PATCH 2/3] dt-bindings: Add ICE device specific parameters
To: Rob Herring <robh@kernel.org>
Cc: andy.gross@linaro.org, david.brown@linaro.org,
        mark.rutland@arm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1539789476-6098-1-git-send-email-anilc@codeaurora.org>
 <1539789476-6098-3-git-send-email-anilc@codeaurora.org>
 <20181025181558.GC30244@bogus>
Message-ID: <9ddb1052-e481-022e-e9cb-7a09d75f6667@codeaurora.org>
Date: Mon, 29 Oct 2018 19:00:41 +0530
MIME-Version: 1.0
In-Reply-To: <20181025181558.GC30244@bogus>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Rob,

Thanks for the comments,

On 2018-10-25 23:45, Rob Herring wrote:
> On Wed, Oct 17, 2018 at 08:47:55PM +0530, AnilKumar Chimata wrote:
>> Add dt parameters information specific to the Inline
>> Crypto Engine (ICE) device.
>> 
>> Signed-off-by: AnilKumar Chimata <anilc@codeaurora.org>
>> ---
>>  .../devicetree/bindings/crypto/msm/ice.txt         | 34 
>> ++++++++++++++++++++++
>>  1 file changed, 34 insertions(+)
>>  create mode 100644 
>> Documentation/devicetree/bindings/crypto/msm/ice.txt
>> 
>> diff --git a/Documentation/devicetree/bindings/crypto/msm/ice.txt 
>> b/Documentation/devicetree/bindings/crypto/msm/ice.txt
>> new file mode 100644
>> index 0000000..86eed5e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/msm/ice.txt
>> @@ -0,0 +1,34 @@
>> +* Inline Crypto Engine (ICE)
>> +
>> +Required properties:
>> +  - compatible			: should be "qcom,ice"
> 
> Only 1 version ever? Probably not and this needs an SoC specific
> compatible string. Does this follow any standard or ICE is a QCom 
> thing?

Yes, currently one version and in future we might have to add if there 
are any hardware specific changes and this is Qualcomm specific hardware.

> 
>> +  - reg 			: <register mapping>
> 
> No need to define standard properties. You need to say how many 
> register
> ranges.

Changed.

> 
>> +
>> +Optional properties:
>> +  - interrupt-names     	: name describing the interrupts for ICE IRQ
> 
> No point to this if there is only 1 IRQ.

There are two IRQ lines which hardware can support one for non-secure 
operating system and another for secure operating system.

> 
>> +  - interrupts          	: <interrupt mapping for ICE IRQ>
>> +  - qcom,enable-ice-clk 	: should enable clocks for ICE HW
> 
> This shouldn't be needed.

Changed.

> 
>> +  - clocks              	: List of phandle and clock specifier pairs
>> +  - clock-names         	: List of clock input name strings sorted in 
>> the same
>> +				  order as the clocks property.
> 
> How many?  You need to give the

Currently four clocks are needed, details updated accordingly.

>> +  - qcom,op-freq-hz     	: max clock speed sorted in the same order 
>> as the clocks
>> +				  property.
> 
> Use the assigned-clocks properties for this.

Actually that is not a max clock speed, its any array of operating 
frequencies which ICE can support.

> 
>> +  - qcom,instance-type  	: describe the storage type for which ICE 
>> node is defined
>> +				  currently, only "ufs" and "sdcc" are supported storage type
> 
> What if there is more than one instance of ufs or SD? Do you need to
> know which ICE goes with which controller?

That is right, needs to have multiple device node entries which 
differentiate between storage instances.

> 
>> +  - power-domains		: regulator supply to be used by ICE HW
>> +
>> +Example:
>> +	ufs_ice: ufsice@1d90000 {
> 
> crytpo@...
> 
>> +		compatible = "qcom,ice";
>> +		reg = <0x1d90000 0x8000>;
>> +		qcom,enable-ice-clk;
>> +		clock-names = "ufs_core_clk", "bus_clk",
>> +				"iface_clk", "ice_core_clk";
>> +		clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
>> +			 <&gcc GCC_UFS_MEM_CLKREF_CLK>,
>> +			 <&gcc GCC_UFS_PHY_AHB_CLK>,
>> +			 <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
>> +		qcom,op-freq-hz = <0>, <0>, <0>, <300000000>;
>> +		power-domains = <&gcc UFS_PHY_GDSC>;
>> +		qcom,instance-type = "ufs";
>> +	};
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
>> 
