From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [RESEND PATCH 3/6] ARM: dts: imx7s: add CAAM device node
Date: Wed, 24 Jan 2018 22:48:20 +0000
Message-ID: <0b3c415f-64e4-1fcf-45ef-c447d65e8e89@nexus-software.ie>
References: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
 <1516805435-15034-4-git-send-email-pure.logic@nexus-software.ie>
 <1516817565.29323.74.camel@aisec.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "peng.fan@nxp.com" <peng.fan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ryan.harkin@linaro.org" <ryan.harkin@linaro.org>,
        "fabio.estevam@nxp.com" <fabio.estevam@nxp.com>,
        "rui.silva@linaro.org" <rui.silva@linaro.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: "Auer, Lukas" <lukas.auer@aisec.fraunhofer.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aymen.sghaier@nxp.com" <aymen.sghaier@nxp.com>,
        "horia.geanta@nxp.com" <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516817565.29323.74.camel@aisec.fraunhofer.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 24/01/18 18:12, Auer, Lukas wrote:
> On Wed, 2018-01-24 at 14:50 +0000, Bryan O'Donoghue wrote:
>> From: Rui Miguel Silva <rui.silva@linaro.org>
>>
>> Add CAAM device node to the i.MX7s device tree.
>>
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> Cc: "Horia Geantă" <horia.geanta@nxp.com>
>> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
>> Cc: Fabio Estevam <fabio.estevam@nxp.com>
>> Cc: Peng Fan <peng.fan@nxp.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Lukas Auer <lukas.auer@aisec.fraunhofer.de>
>> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
>> ---
>>   arch/arm/boot/dts/imx7s.dtsi | 26 ++++++++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/imx7s.dtsi
>> b/arch/arm/boot/dts/imx7s.dtsi
>> index 82ad26e..0da146e 100644
>> --- a/arch/arm/boot/dts/imx7s.dtsi
>> +++ b/arch/arm/boot/dts/imx7s.dtsi
>> @@ -805,6 +805,32 @@
>>   				status = "disabled";
>>   			};
>>   
>> +			crypto: caam@30900000 {
>> +				compatible = "fsl,sec-v4.0";
>> +				fsl,sec-era = <4>;
>> +				#address-cells = <1>;
>> +				#size-cells = <1>;
>> +				reg = <0x30900000 0x10000>;
>> +				ranges = <0 0x30900000 0x10000>;
>> +				clocks = <&clks IMX7D_CAAM_MEM_CLK>,
>> +					 <&clks
>> IMX7D_CAAM_ACLK_CLK>,
>> +					 <&clks IMX7D_CAAM_IPG_CLK>,
>> +					 <&clks IMX7D_EIM_ROOT_CLK>;
>> +				clock-names = "mem", "aclk", "ipg",
>> "emi_slow";
>> +
>> +				sec_jr0: jr0@1000 {
>> +					compatible = "fsl,sec-v4.0-
>> job-ring";
>> +					reg = <0x1000 0x1000>;
>> +					interrupts = <GIC_SPI 105
>> IRQ_TYPE_LEVEL_HIGH>;
>> +				};
>> +
>> +				sec_jr1: jr1@2000 {
>> +					compatible = "fsl,sec-v4.0-
>> job-ring";
>> +					reg = <0x2000 0x1000>;
>> +					interrupts = <GIC_SPI 106
>> IRQ_TYPE_LEVEL_HIGH>;
>> +				};
>> +			};
>> +
>>   			flexcan1: can@30a00000 {
>>   				compatible = "fsl,imx7d-flexcan",
>> "fsl,imx6q-flexcan";
>>   				reg = <0x30a00000 0x10000>;
> 
> Looking at the device tree from the NXP kernel [1], the job ring and
> clock configurations should be slightly different.
> 
> The job ring configuration has one additional job ring at offset 3000
> and interrupt 114.

Yes true, that should be added.

We will do that in v2, thanks for spotting.

> The clock configuration has changed to just one CAAM-specific clock in
> addition to the ahb clock. This also means that additional
> modifications to the CAAM driver are necessary or it will complain that
> it doesn't find all clocks.

Sure - but, those clock changes aren't merged to upstream just yet, so 
we won't those changes to this DTS addition yet.

Thanks for the review.

---
bod
