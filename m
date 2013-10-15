From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 2/3] ARM: at91/dt/trivial: before sama5d3, Atmel MPU were
 using at91 prefix
Date: Tue, 15 Oct 2013 10:14:22 +0200
Message-ID: <525CF95E.9040609@atmel.com>
References: <ba9872c3bb29c9a06f06caa8e0b4528329f07675.1381769174.git.nicolas.ferre@atmel.com> <a7f43a96aaf83c3348dc631c71c54729f9d0e9e0.1381769174.git.nicolas.ferre@atmel.com> <20131014170951.GJ11420@ns203013.ovh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-arm-kernel@lists.infradead.org>, <ebenard@eukrea.com>,
	<herbert@gondor.apana.org.au>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:23398 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3JOIOZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Oct 2013 04:14:25 -0400
In-Reply-To: <20131014170951.GJ11420@ns203013.ovh.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 14/10/2013 19:09, Jean-Christophe PLAGNIOL-VILLARD :
> On 18:46 Mon 14 Oct     , Nicolas Ferre wrote:
>> Change the sha/aes/tdes compatibility string to match common
>> case for the at91sam9g45 family which is to keep the at91 prefix.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>   arch/arm/boot/dts/sama5d3.dtsi | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
>> index b2aabff..99bd4a6 100644
>> --- a/arch/arm/boot/dts/sama5d3.dtsi
>> +++ b/arch/arm/boot/dts/sama5d3.dtsi
>> @@ -342,19 +342,19 @@
>>   			};
>>
>>   			sha@f8034000 {
>> -				compatible = "atmel,sam9g46-sha";
>> +				compatible = "atmel,at91sam9g46-sha";
>>   				reg = <0xf8034000 0x100>;
>>   				interrupts = <42 IRQ_TYPE_LEVEL_HIGH 0>;
>>   			};
>>
>>   			aes@f8038000 {
>> -				compatible = "atmel,sam9g46-aes";
>> +				compatible = "atmel,at91sam9g46-aes";
>>   				reg = <0xf8038000 0x100>;
>>   				interrupts = <43 IRQ_TYPE_LEVEL_HIGH 0>;
>>   			};
>>
>>   			tdes@f803c000 {
>> -				compatible = "atmel,sam9g46-tdes";
>> +				compatible = "atmel,at91sam9g46-tdes";
>>   				reg = <0xf803c000 0x100>;
>>   				interrupts = <44 IRQ_TYPE_LEVEL_HIGH 0>;
> you keep the previous compatible in the driver too for backword compatiblity

No, as the consumer of the old compatibility string has never been sent 
to mainline (or even mailing-list) and as the "dma" property is not 
compatible with the one existing on our 3.6.9-based kernel.

So, anyway the DT has to be changed for a move from 3.6.9 => 3.10. As I 
do not want to bloat the DT forever, let's stick with this new 
compatibility string.

Bye,


>>   			};
>> --
>> 1.8.2.2
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>


-- 
Nicolas Ferre
