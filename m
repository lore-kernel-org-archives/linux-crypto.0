From: jonghwa3.lee@samsung.com
Subject: Re: Issues with HW RNG / SSS on Exynos 5422
Date: Mon, 17 Aug 2015 09:45:29 +0900
Message-ID: <55D12EA9.4060406@samsung.com>
References: <55CF2027.2050707@gmail.com> <55D0717B.1060706@gmail.com>
 <55D07227.1010209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Heiner Kallweit <hkallweit1@gmail.com>,
	linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52507 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbbHQApc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 16 Aug 2015 20:45:32 -0400
In-reply-to: <55D07227.1010209@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi
On 2015=EB=85=84 08=EC=9B=94 16=EC=9D=BC 20:21, Heiner Kallweit wrote:
> Am 16.08.2015 um 13:18 schrieb Heiner Kallweit:
>> Am 15.08.2015 um 13:19 schrieb Heiner Kallweit:
>>> I'm having issues making the hardware RNG work on a Samsung Exynos =
5422 (Odroid XU4) with kernel 4.2rc6.
>>> No random number generation is started if I write the appropriate v=
alue (0x18) to the hash control register.
>>>
>>> What I did so far:
>>> Splitted the sss DT node in exynos5420.dtsi into one for the s5p-ss=
s driver and one for the exynos-rng driver.
>>> (s5p-sss doesn't seem to need the hash registers from offset 0x400)
>>>
>>> sss: sss@10830000 {
>>> 	icompatible =3D "samsung,exynos4210-secss";
>>> 	reg =3D <0x10830000 0x400>;
>>> 	interrupts =3D <0 112 0>;
>>> 	clocks =3D <&clock CLK_SSS>;
>>> 	clock-names =3D "secss";
>>> };
>>>
>>> rng: rng@10830400 {
>>> 	compatible =3D "samsung,exynosrng-secss";
>>> 	reg =3D <0x10830400 0x300>;
>>> 	clocks =3D <&clock CLK_SSS>;
>>> 	clock-names =3D "secss";
>>> };
>>>
>>> The DT binding is just for testing and after adding some DT glue lo=
gic (of_device_id table) to the exynos-rng driver
>>> it binds to the rng platform device.
>>> The clock also seems to be ok with a rate of 266 MHz.
>>> As is the driver hangs in a loop because the PRNG_DONE in the statu=
s register bit never gets set.
>>>
>>> I traced it back to the hash control register not accepting value 0=
x8 (or 0x18 incl. the start bit) for the PRNG.
>>> Writing a value and reading it back works for values from 0 to 5 on=
ly.
>>> As I have no SSS datasheet my only other reference is drivers/crypt=
o/ace_sha.h in the uboot source code
>>> which also uses the HW RNG.
>>>
>>> Any hint would be appreciated.
>>>
>> After some more testing it seems like SSS in general has problems on=
 Exynos 5422.
>> Also the AES implementation in s5p-sss doesn't work. dmesg output:
>>
>> [    7.116739] alg: skcipher: encryption failed on chunk test 1 for =
ecb-aes-s5p: ret=3D22
>> [    7.123673] s5p-sss driver registered
>>
> Sorry, there was a typo in the mail agent cc line.
>
I suspect Trustzone would prohibit to access SSS IP. I never tested it =
Exynos
hwrng under Trustzone enabled,
however some said it cannot be used manually after being protected by S=
ecure OS.

And I don't know neither how to check whether Trustzone is enabled.
Can you access all other registers in SSS IP? If not, it might be relat=
ed with it.

Thanks.
Jonghwa
