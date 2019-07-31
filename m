Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95542C32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 08:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E5D1206A3
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 08:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfGaITd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 04:19:33 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44786 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfGaITd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 04:19:33 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so64848930edr.11
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 01:19:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1pP+TWB1HG61Ex+eG3hi5sT2TNyfpHU6qTtKs4mcQpo=;
        b=otcELMm7X2mZbfWx6AM9Vf91EVgJb6sl6j5c6ALllDhR42UIKUG4/iZi5q1GSoITKG
         rCh1pYWCRec4Qm96ICvqptjbheyvlcuONNE0gY1Uugy4UwHWziA6y1PsrnqYa2nENNqH
         mJFflQae9+iVyKn6EnE+ZFx6IzUvVHXVXwLAoJRCsa2pqw1QgBtmbMj58kZTiKgiqqsq
         vl/Th+52tPOWUx/2GuRwEgp8absDsQhtVZ/NUCxshHzKA5S1IU727a/X6AAiQqKtuto+
         MWunHHL1HTq9uLetaypuHBLa2gChAN/qOXpeDPnvIqt3ivbY0ErSF3A3543CKm+zMH2f
         ksxQ==
X-Gm-Message-State: APjAAAVZsrk1vWdaHp4jGxQcmLXhQHJx/nHuVBkTxDTWJDsLwHgIMe8E
        HAPsVd2Fe7sXBisFd8ECm8PWaA==
X-Google-Smtp-Source: APXvYqyh8BlQfntt3p1tAUgG2rsio5uIBanuTb9x+MrxjHM9IekdiYmkbDAyCtDI+++NzsVordxNuA==
X-Received: by 2002:a17:906:499a:: with SMTP id p26mr30025714eju.308.1564561172070;
        Wed, 31 Jul 2019 01:19:32 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id hh16sm12102397ejb.18.2019.07.31.01.19.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 01:19:31 -0700 (PDT)
Subject: Re: [RFC 3/3] crypto/sha256: Build the SHA256 core separately from
 the crypto module
To:     Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <20190730123835.10283-1-hdegoede@redhat.com>
 <20190730123835.10283-4-hdegoede@redhat.com>
 <4384403.bebDo606LH@tauon.chronox.de> <20190730160335.GA27287@gmail.com>
 <cb888bfa-dd46-de7a-3b90-b54fa79fa3d4@redhat.com>
 <20190730200719.GB27287@gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <3d9fcb23-edf5-eaf4-53f2-5a455fa45110@redhat.com>
Date:   Wed, 31 Jul 2019 10:19:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730200719.GB27287@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 30-07-19 22:07, Eric Biggers wrote:
> On Tue, Jul 30, 2019 at 06:07:54PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 30-07-19 18:03, Eric Biggers wrote:
>>> On Tue, Jul 30, 2019 at 03:15:35PM +0200, Stephan Mueller wrote:
>>>> Am Dienstag, 30. Juli 2019, 14:38:35 CEST schrieb Hans de Goede:
>>>>
>>>> Hi Hans,
>>>>
>>>>> From: Andy Lutomirski <luto@kernel.org>
>>>>>
>>>>> This just moves code around -- no code changes in this patch.  This
>>>>> wil let BPF-based tracing link against the SHA256 core code without
>>>>> depending on the crypto core.
>>>>>
>>>>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>>>>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>>>>> ---
>>>>>    crypto/Kconfig                               |   8 +
>>>>>    crypto/Makefile                              |   1 +
>>>>>    crypto/{sha256_generic.c => sha256_direct.c} | 103 +--------
>>>>
>>>> There is a similar standalone code present for SHA-1 or ChaCha20. However,
>>>> this code lives in lib/.
>>>>
>>>> Thus, shouldn't the SHA-256 core code be moved to lib/ as well?
>>>>
>>>> Ciao
>>>> Stephan
>>>>
>>>>
>>>
>>> What's wrong with lib/sha256.c?  It's already there.
>>
>> That is currently not build under lib/ it is only build as part of
>> the helper executable which deals with transitioning from one kernel to
>> the next on kexec, specifically it is used by arch/x86/purgatory/purgatory.c
>> and also be the s390 purgatory code.
>>
>> Since the purgatory use is in a separate binary / name space AFAICT, we
>> could add sha256.o to lib/Makefile and then I could use that, but then the
>> normal kernel image would have 2 SHA256 implementations.
>>
> 
> Well, seems like the solution needs to involve unifying the implementations.
> 
> Note that Ard Biesheuvel recently added the arc4 and aes algorithms to
> lib/crypto/, with options CONFIG_CRYPTO_LIB_ARC4 and CONFIG_CRYPTO_LIB_AES.  How
> about following the same convention, rather than doing everything slightly
> differently w.r.t. code organization, function naming, Kconfig option, etc.?

I'm fine with that, I'm still waiting for feedback from the crypto maintainers
that they are open to doing that ...

Herbert? Dave?

Regards,

Hans
