From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Issues with HW RNG on Exynos 5422
Date: Sat, 15 Aug 2015 13:19:03 +0200
Message-ID: <55CF2027.2050707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "Naveen Krishna Chatradhi <ch.naveen@samsung.com; Jonghwa Lee"
	<jonghwa3.lee@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36027 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbHOLTd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 15 Aug 2015 07:19:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm having issues making the hardware RNG work on a Samsung Exynos 5422 (Odroid XU4) with kernel 4.2rc6.
No random number generation is started if I write the appropriate value (0x18) to the hash control register.

What I did so far:
Splitted the sss DT node in exynos5420.dtsi into one for the s5p-sss driver and one for the exynos-rng driver.
(s5p-sss doesn't seem to need the hash registers from offset 0x400)

sss: sss@10830000 {
	icompatible = "samsung,exynos4210-secss";
	reg = <0x10830000 0x400>;
	interrupts = <0 112 0>;
	clocks = <&clock CLK_SSS>;
	clock-names = "secss";
};

rng: rng@10830400 {
	compatible = "samsung,exynosrng-secss";
	reg = <0x10830400 0x300>;
	clocks = <&clock CLK_SSS>;
	clock-names = "secss";
};

The DT binding is just for testing and after adding some DT glue logic (of_device_id table) to the exynos-rng driver
it binds to the rng platform device.
The clock also seems to be ok with a rate of 266 MHz.
As is the driver hangs in a loop because the PRNG_DONE in the status register bit never gets set.

I traced it back to the hash control register not accepting value 0x8 (or 0x18 incl. the start bit) for the PRNG.
Writing a value and reading it back works for values from 0 to 5 only.
As I have no SSS datasheet my only other reference is drivers/crypto/ace_sha.h in the uboot source code
which also uses the HW RNG.

Any hint would be appreciated.
