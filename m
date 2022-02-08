Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33739C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Feb 2022 14:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378833AbiBHOzV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Feb 2022 09:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378595AbiBHOzQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Feb 2022 09:55:16 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6983CC03FEED
        for <linux-crypto@vger.kernel.org>; Tue,  8 Feb 2022 06:55:12 -0800 (PST)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A3A523F32B
        for <linux-crypto@vger.kernel.org>; Tue,  8 Feb 2022 14:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644332110;
        bh=s1IMl3bQpWn4BmhYXFrJkGqIg7SbAYtbaNCslVtkn9A=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=HMAz8B7Dwmmca22gRczJKVzfb1knOeIvmBsbxZreOTVJVcaaT3db50py4DW/FlxuD
         PFFg1TLTIazeQ31Vyj0G1PiCPf597wcdHPLiwr3Ri1ulaZAJ0KpkGRLbhDg9URsP64
         aOUODZm98XB+vg39V84E3jvyumQvdLY7DgKouH4upi/GKkWA2OOpvqqej3AHGEfxwj
         9uoLnLGjumotGTq4sTXu8i81kieYfwAjJjT9z7hlhJpPusfRLIMzrJZ6VkK2OvzKq5
         +GvEPINRZMjxl8QUeurHsMR9ToW4vTThNwh1dxGKZJ+TaIA4cFGyZNo3hEupnBO7oI
         11fttRKcpHGrQ==
Received: by mail-ed1-f71.google.com with SMTP id b26-20020a056402139a00b004094fddbbdfso9860001edv.12
        for <linux-crypto@vger.kernel.org>; Tue, 08 Feb 2022 06:55:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s1IMl3bQpWn4BmhYXFrJkGqIg7SbAYtbaNCslVtkn9A=;
        b=a6cE5+FjjbpFInmHSlGndBMbJcHLw16JmhqAWYq7BCSA0tWtWE2g2cDqu4T+P857y4
         DAEBjXbEu2JRkrQ4RBt/N8wgkXDYoRG4GP0XxdhMLFJgacGBjgamOaz+qKVoAAm02bxC
         h8QiuHM8WF4cqAFo8WPPZRWWJEXLlqXFT9xkNpeKaBFlrZ8os2Wey0ZPbUTgA+HPw2nI
         tAaOxHtGNayIQ9pecQHf3at2FLfOctDOWLOJffr/Imamazt6+c1YiWvDBvbL29x/RjBp
         +xqj40buzdIYrP0agcXRUUmM7zwTOg48wVUoDf4OMPRqC/dZL01CAM8E3fGxWFJtoy04
         qOGA==
X-Gm-Message-State: AOAM533en405l4M7CGnKNsrYO3KFFPqp9KCvbBJi6QwCv2O7NHmEtpqz
        J9YxpEUWaZ18uyRZuper95ZMLcVm576qCVxVtMeyEcfp+9MRPOTiaL1wUWH+spdEP93Qe8aX/ce
        pVO8RNqwIo14pjPR/BISH/IfY8qWp33bNcsINlFY4FA==
X-Received: by 2002:a17:907:1c01:: with SMTP id nc1mr4166727ejc.659.1644332110283;
        Tue, 08 Feb 2022 06:55:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBDSawfyjI97i8H3epieO8DgpiikxUatxwAPQp6uSpUnl0g6llplmwOmXOOamh8buC1ms3Yg==
X-Received: by 2002:a17:907:1c01:: with SMTP id nc1mr4166711ejc.659.1644332110105;
        Tue, 08 Feb 2022 06:55:10 -0800 (PST)
Received: from [192.168.0.93] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id o11sm7026147edh.75.2022.02.08.06.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 06:55:09 -0800 (PST)
Message-ID: <bca78043-d552-a7e4-149b-087c6226d8bf@canonical.com>
Date:   Tue, 8 Feb 2022 15:55:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: Convert Atmel AES to yaml
Content-Language: en-US
To:     Tudor.Ambarus@microchip.com, herbert@gondor.apana.org.au
Cc:     Nicolas.Ferre@microchip.com, Claudiu.Beznea@microchip.com,
        alexandre.belloni@bootlin.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kavyasree.Kotagiri@microchip.com, devicetree@vger.kernel.org
References: <20220208104918.226156-1-tudor.ambarus@microchip.com>
 <20220208104918.226156-2-tudor.ambarus@microchip.com>
 <f5563605-7b61-c23e-68ec-6e315efb268d@canonical.com>
 <d72a96a9-f99c-5204-00d0-00f78ea96772@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <d72a96a9-f99c-5204-00d0-00f78ea96772@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/02/2022 15:40, Tudor.Ambarus@microchip.com wrote:
> On 2/8/22 13:58, Krzysztof Kozlowski wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On 08/02/2022 11:49, Tudor Ambarus wrote:
>>> Convert Atmel AES documentation to yaml format. With the conversion the
>>> clock and clock-names properties are made mandatory. The driver returns
>>> -EINVAL if "aes_clk" is not found, reflect that in the bindings and make
>>> the clock and clock-names properties mandatory. Update the example to
>>> better describe how one should define the dt node.
>>>
>>> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
>>> ---
>>>  .../crypto/atmel,at91sam9g46-aes.yaml         | 65 +++++++++++++++++++
>>>  .../bindings/crypto/atmel-crypto.txt          | 20 ------
>>>  2 files changed, 65 insertions(+), 20 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
>>>
>>
>> I understand that you keep the license GPL-2.0 (not recommended mix)
>> because of example coming from previous bindings or from DTS (both GPL-2.0)?
>>
> 
> The previous bindings did not have a license specified. We have DTS files with
> these nodes that are either (GPL-2.0+ OR MIT) or GPL-2.0-or-later. The drivers
> are GPL-2.0. I thought to follow the drivers. I see the example in [1] uses
> (GPL-2.0-only OR BSD-2-Clause). I see the crypto bindings that are converted
> to yaml are either (GPL-2.0-only OR BSD-2-Clause) or GPL-2.0-only. Is there
> another guideline that I miss?
> 

Yes, there is. Run checkpatch (your question kinds of point to the fact
that you did not run it...):
WARNING: DT binding documents should be licensed (GPL-2.0-only OR
BSD-2-Clause)


If your new bindings use copied/derivative description or DTS code which
is licensed as only GPL-2.0, the bindings itself as derivative work
might need to stay as GPL-2.0 as well. Unless copyright holders agree to
re-license this as GPL2-OR-BSD. As representing company, your patch
might be enough to re-license, but maybe other people contributed. I
don't know.

I just wanted to be sure that you use GPL-2.0 in purpose, because
GPL2-OR-BSD cannot be used.

Best regards,
Krzysztof
