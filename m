Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D8DC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 04:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9EE264F94
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 04:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhCLEwp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Mar 2021 23:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhCLEwa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Mar 2021 23:52:30 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E637DC061574;
        Thu, 11 Mar 2021 20:52:29 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id q204so1016901pfq.10;
        Thu, 11 Mar 2021 20:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZyZIkybO9SxVwDwL8RwkKTDFi+dXqtciO35Y0No2LCo=;
        b=cz8rzGqvx+1E0Z4Oyw5vbTDSn5NWLKSP+l0BQtXFVCguq7eBSdfmiLNKAwGILEFBK/
         OkFR4dYE5ZrGCAJfWDm/8iVNwgSfzJfhxZDqz4f5vPWMQTKJi19d3/iSLIaBE6tGHAcU
         9cM4Y1WWOs0AjQNdiQdZZSfdbXQ9Jg/lkNX/aNbwNiItGGe+LbF4qkT0/3EVRxytcNH8
         GyE4VnQQ2Q0ePbjCDHdxJ3vxNe6QGu0Zb76KxjKNW3LMaTtZ+UX/AP2GmVGvuttLNLz4
         UA0PbEGSAb11uhC8XOzbVN59Me6hyL9b4j/PY/VjqbRncLm5+ZsnQQpV57Zq3RgtAhuT
         mLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZyZIkybO9SxVwDwL8RwkKTDFi+dXqtciO35Y0No2LCo=;
        b=AWhfj/yGfp6fMvLiWto/VDtqbVAtoRonn2fBmYY1bUjCwppnrsw0aenG/SlEDMuWXI
         u9d0H+D4AJ9As9gZl01cCajKKnDQ3zM30hSuWtZQVzptKSDZoCBL1rYKblfDZ4RXckpv
         D0y/oIUunRAQjYKrU/qiuM+noFi6XvtNYqtT0c1HAmi2pNJuoUHzNWAVRnS0vMUtMDo7
         eUZIZ6FDirr/EAs5kIZhqa63DvPqPyH+WRu5IazGxaaH3t09+N68NqkeeGaGfsVZheX+
         zuM9CFdusmTCMFmHHgYm7aEYjds7d96HuFj2OgXXeg5IZCritNmzGjr1LLt5JwfjDLBW
         qgmw==
X-Gm-Message-State: AOAM532Vq14R3/4ciukXyu2uH09hntPHEXi9jDHdo0Dwkhj+vADzFhch
        GHBmhpnbX1aAR+bkiSal9GtCTlINkM4=
X-Google-Smtp-Source: ABdhPJyWHWMWF5PyeVDaqgyY9OiUQgsUChZnVS0fX54wJz6JswyP0/mFO6uDEV9J7IZ7xCXOCOODqg==
X-Received: by 2002:a63:2214:: with SMTP id i20mr9846875pgi.189.1615524743541;
        Thu, 11 Mar 2021 20:52:23 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g5sm4367970pfb.77.2021.03.11.20.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 20:52:23 -0800 (PST)
Subject: Re: [PATCH] hwrng: bcm2835: set quality to 1000
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephan Mueller <smueller@chronox.de>
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Lunn <andrew@lunn.ch>, Matt Mackall <mpm@selenic.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stijn Tintel <stijn@linux-ipv6.be>, ynezz@true.cz
References: <20210220174741.23665-1-noltari@gmail.com>
 <YDFeao/bOxvoXI9D@lunn.ch> <9b86c773-7153-1e18-472a-f66b01c83173@gmail.com>
 <20210303092019.GB8134@gondor.apana.org.au>
 <66AED5A4-3227-47CA-A4A2-B5AD6A571AAC@gmail.com>
 <c76c82668142710ba5a7a8454759c9aa2423d72f.camel@suse.de>
 <b0cf1be0-4c7c-57ee-fea5-789fe215b85d@gmail.com>
 <6D1459DF-A7E1-422C-AA05-655156AEBA23@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c8d9602f-682d-a82f-abb4-3f3f37ec9f02@gmail.com>
Date:   Thu, 11 Mar 2021 20:52:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <6D1459DF-A7E1-422C-AA05-655156AEBA23@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 3/4/2021 10:26 PM, Álvaro Fernández Rojas wrote:
> Hi Florian,
> 
>> El 4 mar 2021, a las 23:28, Florian Fainelli <f.fainelli@gmail.com> escribió:
>>
>> On 3/4/21 7:11 AM, Nicolas Saenz Julienne wrote:
>>> On Wed, 2021-03-03 at 10:29 +0100, Álvaro Fernández Rojas wrote:
>>>> Hi Herbert,
>>>>
>>>>> El 3 mar 2021, a las 10:20, Herbert Xu <herbert@gondor.apana.org.au> escribió:
>>>>>
>>>>> On Sat, Feb 20, 2021 at 08:12:45PM +0100, Álvaro Fernández Rojas wrote:
>>>>>>
>>>>>> I ran rngtest and this is what I got:
>>>>>
>>>>> This is meaningless except for sources that have not been whitened.
>>>>>
>>>>> Your justification needs to be based on what the hardware does or
>>>>> is documented to do.
>>>>
>>>> Ok, so I guess that we’re never setting that value to anything since there’s
>>>> no public documentation about that ¯\_(ツ)_/¯.
>>>
>>> @Florian, is there a way you might be able to get the official value?
>>
>> I will be looking into the documentation this weekend and let you know
>> whether we can change the driver's quality accordingly.
> 
> Could you do that for iproc-rng200.c too?

From looking at some documentation and the design of the 6368 RNG which
is supposedly the same as the Raspberry Pi 1/2/3 RNG, this appears to be
a random number generator that does not go through any post-processing
and just collects random bits into a FIFO.

The rbg200 is also similar except that it is integrated into a wrapper
called the rng200 which supposedly only accepts data that has passed
"NIST industry standard random data quality algorithm" without being
specific. So it seems to me you may be able to set the quality field for
bcm2835-rng, but not for iproc-rng200.

Stephan does that sound right?
-- 
Florian
