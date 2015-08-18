From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Issues with HW RNG / SSS on Exynos 5422
Date: Tue, 18 Aug 2015 08:02:46 +0200
Message-ID: <55D2CA86.2080407@gmail.com>
References: <55CF2027.2050707@gmail.com> <55D0717B.1060706@gmail.com> <CAJKOXPdVh2jFYURjO9Bubti-4wd6nJNGoR+B4Re0LQUtnn2xMA@mail.gmail.com> <55D17AEF.9030706@gmail.com> <55D17F90.80304@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
	Jonghwa Lee <jonghwa3.lee@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35834 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbHRGC6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Aug 2015 02:02:58 -0400
In-Reply-To: <55D17F90.80304@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am 17.08.2015 um 08:30 schrieb Krzysztof Kozlowski:
> On 17.08.2015 15:10, Heiner Kallweit wrote:
>> Am 17.08.2015 um 02:19 schrieb Krzysztof Kozlowski:
>>> 2015-08-16 20:18 GMT+09:00 Heiner Kallweit <hkallweit1@gmail.com>:
>>>> Am 15.08.2015 um 13:19 schrieb Heiner Kallweit:
>>>>> I'm having issues making the hardware RNG work on a Samsung Exynos 5422 (Odroid XU4) with kernel 4.2rc6.
>>>>> No random number generation is started if I write the appropriate value (0x18) to the hash control register.
>>>>>
>>>>> What I did so far:
>>>>> Splitted the sss DT node in exynos5420.dtsi into one for the s5p-sss driver and one for the exynos-rng driver.
>>>>> (s5p-sss doesn't seem to need the hash registers from offset 0x400)
>>>>>
>>>>> sss: sss@10830000 {
>>>>>       icompatible = "samsung,exynos4210-secss";
>>>>>       reg = <0x10830000 0x400>;
>>>>>       interrupts = <0 112 0>;
>>>>>       clocks = <&clock CLK_SSS>;
>>>>>       clock-names = "secss";
>>>>> };
>>>>>
>>>>> rng: rng@10830400 {
>>>>>       compatible = "samsung,exynosrng-secss";
>>>>>       reg = <0x10830400 0x300>;
>>>>>       clocks = <&clock CLK_SSS>;
>>>>>       clock-names = "secss";
>>>>> };
>>>>>
>>>>> The DT binding is just for testing and after adding some DT glue logic (of_device_id table) to the exynos-rng driver
>>>>> it binds to the rng platform device.
>>>>> The clock also seems to be ok with a rate of 266 MHz.
>>>>> As is the driver hangs in a loop because the PRNG_DONE in the status register bit never gets set.
>>>>>
>>>>> I traced it back to the hash control register not accepting value 0x8 (or 0x18 incl. the start bit) for the PRNG.
>>>>> Writing a value and reading it back works for values from 0 to 5 only.
>>>>> As I have no SSS datasheet my only other reference is drivers/crypto/ace_sha.h in the uboot source code
>>>>> which also uses the HW RNG.
>>>>>
>>>>> Any hint would be appreciated.
>>>>>
>>>> After some more testing it seems like SSS in general has problems on Exynos 5422.
>>>> Also the AES implementation in s5p-sss doesn't work. dmesg output:
>>>>
>>>> [    7.116739] alg: skcipher: encryption failed on chunk test 1 for ecb-aes-s5p: ret=22
>>>> [    7.123673] s5p-sss driver registered
>>>
>>> Have you tried or looked at vendor code for Samsung mobile devices?
>>> The code can be downloaded from opensource.samsung.com. I think the
>>> model with Exynos5422 is SM-G900H.
>>>
>>> I don't have any other hints...
>>>
>>> Best regards,
>>> Krzysztof
>>> .
>>>
>> Thanks for your feedback.
>>
>> I now took a look at the kernel code Odroid provides, especially the ACE crypto driver.
>> It's a 3.10.82 kernel with a lot of Samsung code which is not (yet) upstreamed.
>>
>> There seem to be different revisions of SSS (ACE driver mentions v.4, v.5, v.6, and Slim SSS).
>> The vendor kernel uses Slim SSS and the HW AES encryption works.
>> The code there looks like Exynos 5422 should support also v.5, but it's disabled.
>>
>> I didn't test all SSS registers but for the ones I tested I can change the value.
>> Having said that access to SSS registers is not forbidden.
>>
>> Then I changed the memory mapped region to 0x10900000, offset 0x800. According to the
>> vendor kernel code there should be the registers for hash functions under Slim SSS.
>>
>> Not much luck either .. Maybe because Slim SSS uses another clock.
>> The Slim SSS clock is defined in include/dt-bindings/clock/exynos5420.h already.
>> I added a clock definition based on the one in the vendor kernel and changed the DT node to use it.
>>
>>         GATE(CLK_SSS, "sss", "aclk266_g2d", GATE_IP_G2D, 2, 0, 0),
>> +       GATE(CLK_SLIM_SSS, "slimsss", "aclk266_g2d", GATE_IP_G2D, 12, 0, 0),
>>
>> But this didn't do the trick yet.
> 
> Try booting with "clk_ignore_unused" in command line to reduce the
> chance that wrong clock-hierarchy causes some important clocks to be gated.
> 
> The clock hierarchy for SSS in mainline is not fully implemented. Beside
> multiple SSS clocks in GATE_IP_G2D and other places, there are also SSS
> bus clocks in GATE_BUS_G2D. By default (after reset) they are not gated
> but who knows what bootloader does with them?
> 
> Best regards,
> Krzysztof
> 
I'm primarily interested in the HW RNG and a closer look to ace_sfr.h of the vendor kernel
revealed that Slim SSS doesn't seem to support the SEED / PRNG registers.
Therefore I didn't follow the SSS path further.
Instead I checked exyswd-rng.c, the driver for the TRNG. But no luck either.
SMC calls in general work but exynos_smc(SMC_CMD_RANDOM, HWRNG_INIT, 0, 0) returns -1.
Not sure whether the firmware is somehow restricted or whether Exynos 5422 doesn't support the TRNG.
Is there any publicly available information?

By the way: Seems like a bug in the driver, the return values of exynos_smc are defined as
positive values (#define HWRNG_RET_INVALID_ERROR 1) but actually it returns negative values
in error case.

Rgds, Heiner
