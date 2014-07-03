From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: Testing the PRNG driver of the Allwinner Security System A20
Date: Thu, 03 Jul 2014 08:57:22 +0200
Message-ID: <53B4FED2.7000109@gmail.com>
References: <53B297FA.4050106@gmail.com> <CACXcFmmSWP1MAAzX0A1jVoCNdex9EoJ50S9zdDgf-WuiwjSA5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64451 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaGCG51 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2014 02:57:27 -0400
Received: by mail-wg0-f50.google.com with SMTP id m15so11962065wgh.21
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jul 2014 23:57:26 -0700 (PDT)
In-Reply-To: <CACXcFmmSWP1MAAzX0A1jVoCNdex9EoJ50S9zdDgf-WuiwjSA5w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/03/14 01:06, Sandy Harris wrote:
> On Tue, Jul 1, 2014 at 7:14 AM, Corentin LABBE
> <clabbe.montjoie@gmail.com> wrote:
> 
>> I am writing the PRNG driver for the Allwinner Security System SoC A20.
> 
> The datasheet my search turned up (v1, Feb. 2013) just says:  "160-bit
> hardware PRNG with 192-bit seed" and gives no other details. Do you
> have more info, perhaps from a more recent version or talking to the
> company?

The datasheet I used give some register info, just enough for having some "random" number out of the device.

> 
>> I didn't know how to test it, so ...
> 
> Unless you have much more info, I see no point in enabling it or
> writing a driver. You need a true hardware RNG to seed it, so you need
> random(4) /dev/random anyway and can just use /dev/urandom for PRNG
> requirements.
> 
> Using this device might have an advantage if it is much faster or less
> resource-hungry than urandom, but I see nothing in its documentation
> that indicates it is. Anyway, do your applications need that? And, if
> so, would an application-specific PRNG be better yet?
> 
> Then there is the crucial question of trusting the device. Kerckhoff's Principle
> (http://en.citizendium.org/wiki/Kerckhoffs%27_Principle)
> has been a maxim for cryptographers since the 19th century; no-one
> should even consider trusting it until full design details are made
> public and reviewed.
> 
> Even then, there might be serious doubts, since hardware can be very
> subtly sabotaged and an RNG is a tempting target for an intelligence
> agency.
> (http://arstechnica.com/security/2013/09/researchers-can-slip-an-undetectable-trojan-into-intels-ivy-bridge-cpus/)
> That article discusses Intel and the NSA, but similar worries apply
> elsewhere. Allwinner is a fabless company, so you also need to worry
> about whatever fab they use.
> 

The question of trusting is the reason that my preliminary driver made the PRNG optionnal and I think the next version will be without it.
But for people who do not care (or do not have a real RNG requirement), the output speed is better than /dev/urandom
Here is a comparison of the output speed of rng-test:
with /dev/urandom
rngtest: input channel speed: (min=623.523; avg=17402.670; max=3906250.000)Kibits/s
with /dev/hwrng and ss-rng/sunxi-ss loaded
rngtest: input channel speed: (min=1.193; avg=113.604; max=4768.372)Mibits/s
So an average speed gain of x5

Apart from trusting, does the results of rng-test are good enough ?

Thanks for your answer

Regards
