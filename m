From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: Issues with HW RNG / SSS on Exynos 5422
Date: Mon, 24 Aug 2015 09:33:09 +0900
Message-ID: <CAJKOXPfBwSau-6c=4+V4OHOc9SbFneGnMNOD=XrJ8=66rNGhLQ@mail.gmail.com>
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

Indeed... Status has value 0x3 which means that buffer is not full,
seed setup is done and PRNG engine is idle. I tried this also on
Trats2 board (Exynos 4412) with exactly the same result. No idea.

>>
>> I traced it back to the hash control register not accepting value 0x8 (or 0x18 incl. the start bit) for the PRNG.
>> Writing a value and reading it back works for values from 0 to 5 only.

It's okay. Accepted values for engine are only from 0 to 5. The bit no
4 (start init bit) is automatically cleared by hardware.

Best regards,
Krzysztof
