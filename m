From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: Issues with HW RNG / SSS on Exynos 5422
Date: Mon, 17 Aug 2015 09:19:48 +0900
Message-ID: <CAJKOXPdVh2jFYURjO9Bubti-4wd6nJNGoR+B4Re0LQUtnn2xMA@mail.gmail.com>
References: <55CF2027.2050707@gmail.com>
	<55D0717B.1060706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
	"Naveen Krishna Chatradhi <ch.naveen@samsung.com>, Jonghwa Lee"
	<jonghwa3.lee@samsung.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <55D0717B.1060706@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

2015-08-16 20:18 GMT+09:00 Heiner Kallweit <hkallweit1@gmail.com>:
> Am 15.08.2015 um 13:19 schrieb Heiner Kallweit:
>> I'm having issues making the hardware RNG work on a Samsung Exynos 5422 (Odroid XU4) with kernel 4.2rc6.
>> No random number generation is started if I write the appropriate value (0x18) to the hash control register.
>>
>> What I did so far:
>> Splitted the sss DT node in exynos5420.dtsi into one for the s5p-sss driver and one for the exynos-rng driver.
>> (s5p-sss doesn't seem to need the hash registers from offset 0x400)
>>
>> sss: sss@10830000 {
>>       icompatible = "samsung,exynos4210-secss";
>>       reg = <0x10830000 0x400>;
>>       interrupts = <0 112 0>;
>>       clocks = <&clock CLK_SSS>;
>>       clock-names = "secss";
>> };
>>
>> rng: rng@10830400 {
>>       compatible = "samsung,exynosrng-secss";
>>       reg = <0x10830400 0x300>;
>>       clocks = <&clock CLK_SSS>;
>>       clock-names = "secss";
>> };
>>
>> The DT binding is just for testing and after adding some DT glue logic (of_device_id table) to the exynos-rng driver
>> it binds to the rng platform device.
>> The clock also seems to be ok with a rate of 266 MHz.
>> As is the driver hangs in a loop because the PRNG_DONE in the status register bit never gets set.
>>
>> I traced it back to the hash control register not accepting value 0x8 (or 0x18 incl. the start bit) for the PRNG.
>> Writing a value and reading it back works for values from 0 to 5 only.
>> As I have no SSS datasheet my only other reference is drivers/crypto/ace_sha.h in the uboot source code
>> which also uses the HW RNG.
>>
>> Any hint would be appreciated.
>>
> After some more testing it seems like SSS in general has problems on Exynos 5422.
> Also the AES implementation in s5p-sss doesn't work. dmesg output:
>
> [    7.116739] alg: skcipher: encryption failed on chunk test 1 for ecb-aes-s5p: ret=22
> [    7.123673] s5p-sss driver registered

Have you tried or looked at vendor code for Samsung mobile devices?
The code can be downloaded from opensource.samsung.com. I think the
model with Exynos5422 is SM-G900H.

I don't have any other hints...

Best regards,
Krzysztof
