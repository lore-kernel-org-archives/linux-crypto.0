Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3456C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 11:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2BD161166
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 11:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhIULUu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Sep 2021 07:20:50 -0400
Received: from phobos.denx.de ([85.214.62.61]:46730 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232270AbhIULUt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Sep 2021 07:20:49 -0400
Received: from [10.88.0.104] (dslb-002-207-026-172.002.207.pools.vodafone-ip.de [2.207.26.172])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: ch@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 4D99B8326B;
        Tue, 21 Sep 2021 13:19:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1632223159;
        bh=glqX6AsVJ/n8RP2wkc3clkds4S5+Oy3PKsBZhZZ0bEo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PE1BPImT/NGGC8MfmEW7me+1fqdDSCBpGoy9UDUnN9BSjJ7X8hLTomr9iwIEvGcej
         /2KQu+Yb/M8KVJN2Cse7CHVQR4f1m8HdZMhKxdLhVD8Dbcxk5GRgrZI/wy4hmRxHqS
         Ile24A/pPAcNVyl5waxEjtwqOUu+kxUgqZEBZMX8In7VcCvVuB8g5cdw9y/3LEkrUA
         ybqi2ppsQDJCKasQUQFOzwJQaxhTEc9OI4Ckx7EvW3JQ7o5FFArHGXqM1ZBLGTSToo
         Dnbd4HF++NvBrYmbRIelFJuC06BibNfoBOWYzklAMM1tFHQCiiL1rrdWVbtk39aqAH
         BN8Zsg1JMhzZw==
Subject: Re: [RFC][PATCH] crypto: caam - Add missing MODULE_ALIAS
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Marek Vasut <marex@denx.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20210916134154.8764-1-marex@denx.de>
 <441a7e2e-7ac8-5000-72e0-3793ae7e58d5@canonical.com>
 <08afb147-07c7-9fbb-4a0c-8a79717b06b7@denx.de>
 <ea7e5aae-be43-057a-2710-fbcb57d40ddc@nxp.com>
 <a8900033-d84d-d741-7d72-b266f973e0d6@canonical.com>
 <bc94681c-58e5-8c6f-42d3-0e51ddd060c7@nxp.com>
 <77467cbf-afad-d7e1-5042-569d5a276c20@canonical.com>
 <b1a68e04-b0ce-9610-9992-6eb2f110d36f@canonical.com>
 <04c9705b-9fd8-dde1-33ee-fa58aad96d4a@denx.de>
 <a690721b-072b-203f-3b30-f2d2b8ba6996@denx.de>
 <CAOMZO5Bq4wSreYOjB6A86MpZVtudQN7ypJVsL93NsU40S4sN9A@mail.gmail.com>
From:   Claudius Heine <ch@denx.de>
Organization: Denx Software Engineering
Message-ID: <91b14d32-17e9-545c-65a3-0a5c0437af33@denx.de>
Date:   Tue, 21 Sep 2021 13:19:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAOMZO5Bq4wSreYOjB6A86MpZVtudQN7ypJVsL93NsU40S4sN9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Fabio,

On 2021-09-21 13:08, Fabio Estevam wrote:
> Hi Claudius,
> 
> On Mon, Sep 20, 2021 at 1:54 PM Claudius Heine <ch@denx.de> wrote:
> 
>> Here are the uevent entries without this RFC patch applied:
>>
>> ```
>> # udevadm info -q all -p devices/platform/soc@0/30800000.bus/30900000.crypto
>> P: /devices/platform/soc@0/30800000.bus/30900000.crypto
>> L: 0
>> E: DEVPATH=/devices/platform/soc@0/30800000.bus/30900000.crypto
>> E: DRIVER=caam
>> E: OF_NAME=crypto
>> E: OF_FULLNAME=/soc@0/bus@30800000/crypto@30900000
>> E: OF_COMPATIBLE_0=fsl,sec-v4.0
>> E: OF_COMPATIBLE_N=1
>> E: MODALIAS=of:NcryptoT(null)Cfsl,sec-v4.0
>> E: SUBSYSTEM=platform
>> E: USEC_INITIALIZED=4468986
>> E: ID_PATH=platform-30900000.crypto
>> E: ID_PATH_TAG=platform-30900000_crypto
> 
> Looking at the addresses above, it looks like you have a device from
> the i.MX8M family.
> 
> caam module is being correctly autoloaded on imx8mn-evk, for example
> on kernel 5.14.6:
> https://storage.kernelci.org/stable/linux-5.14.y/v5.14.6/arm64/defconfig/gcc-8/lab-baylibre/baseline-imx8mn-ddr4-evk.html
> 
> It works on 5.10.67 too:
> https://storage.kernelci.org/stable/linux-5.10.y/v5.10.67/arm64/defconfig/gcc-8/lab-baylibre/baseline-imx8mn-ddr4-evk.html
> 
> Which kernel version do you use?

I never have any issues with auto loading of the module. I just had an 
issue where the rngd daemon didn't wait until the module was loaded and 
failed to start. I found out that there was just some 
`Wants=systemd-udev-settle.service` missing in the service file and then 
everything worked. [1]

Marek just suspected at first that a `MODULE_ALIAS` might be necessary 
in the driver and submitted this RFC patch for it.

So all is well from my end :) And thanks for everyone looking into this!

regards,
Claudius

[1] https://lists.openembedded.org/g/openembedded-core/message/156129
