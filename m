From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 0/4] staging: add ccree crypto driver
Date: Wed, 19 Apr 2017 17:34:57 +0300
Message-ID: <CAOtvUMexVoojHMtxgJfxgGM+DVpVP2Yn9OZYtrYfdenKwQ_oVw@mail.gmail.com>
References: <1492524470-13847-1-git-send-email-gilad@benyossef.com> <20170418153951.GA31214@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36189 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764290AbdDSOe6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 10:34:58 -0400
Received: by mail-yw0-f194.google.com with SMTP id 203so1797700ywk.3
        for <linux-crypto@vger.kernel.org>; Wed, 19 Apr 2017 07:34:58 -0700 (PDT)
In-Reply-To: <20170418153951.GA31214@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 18, 2017 at 6:39 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Apr 18, 2017 at 05:07:50PM +0300, Gilad Ben-Yossef wrote:
>> Arm TrustZone CryptoCell 700 is a family of cryptographic hardware
>> accelerators. It is supported by a long lived series of out of tree
>> drivers, which I am now in the process of unifying and upstreaming.
>> This is the first drop, supporting the new CryptoCell 712 REE.
>>
>> The code still needs some cleanup before maturing to a proper
>> upstream driver, which I am in the process of doing. However,
>> as discussion of some of the capabilities of the hardware and
>> its application to some dm-crypt and dm-verity features recently
>> took place I though it is better to do this in the open via the
>> staging tree.
>>
>> A Git repository based off of Linux 4.11-rc7 is available at
>> https://github.com/gby/linux.git branch ccree.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>> CC: Binoy Jayan <binoy.jayan@linaro.org>
>> CC: Ofir Drang <ofir.drang@arm.com>
>>
>> Gilad Ben-Yossef (4):
>>   staging: add ccree crypto driver
>>   staging: ccree: add TODO list
>>   staging: ccree: add devicetree bindings
>>   MAINTAINERS: add Gilad BY as maintainer for ccree
>
> We can't do much without a real patch, sorry.  Digging in random git
> trees doesn't work :(
>
> I can't take this as-is, I need patches.

Got it.

I'll break the driver to a series of patches and post them .
Thanks for the feedback.

Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
