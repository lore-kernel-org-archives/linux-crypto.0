Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD29C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 14:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17A1B61164
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 14:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhIPOYQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 10:24:16 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:51782
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237959AbhIPOYQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 10:24:16 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 01C5E3F499
        for <linux-crypto@vger.kernel.org>; Thu, 16 Sep 2021 14:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631802175;
        bh=NqBeXRZSXPu/pWuNPFMTGW3saf3D8TCWn1YG5xMJQwQ=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=D12r3FaZ+NH3jOCgdt814t7VSIFl+yAQp2X1qIWjHsUYPGEgwFMES8l90jZAu2FKp
         nEdXg4ARyw27ksCdnLXYokoH5YlFsmuhyy6xB8jFytOV/UOpa0R7xnagZgAMbSruGa
         7aYDIWw5ebnIyT9kVpNalP1GEuL+2DbFA/VvIp2kFpY8b8fvQUhE46O8TxRD+PmFsV
         bGHwmYwDirL+HUpxNC8rdStKb1ifAHTxz2ON0GkpO9S+7lNxeDN72uNeoyZE/4cG6O
         98Y07BJ7oSdDJBD9sjm6Lzf2+pSV39h2VtW0jsHZMIGIlhJ2ILzaAT5ajUmNLbGAqH
         UCwx1MVfPPAqQ==
Received: by mail-wm1-f71.google.com with SMTP id j16-20020a1c2310000000b0030b3dce20e1so406479wmj.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Sep 2021 07:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NqBeXRZSXPu/pWuNPFMTGW3saf3D8TCWn1YG5xMJQwQ=;
        b=MgsXbiUAT30pCmbcl6yq2howkGx/6F1QfPf/n739pzk8lz9QxHWYrgvekqu/vd8IVg
         XkpxIdF9vd5fY8XvTG70iJ+qKvIqiLBeo94dBHzX013jNwrpsGTi8PN7vpdhNPWbyNls
         DW0om7CCnx+AJAdKd6/9KUSUAw79kc1fZWGiYi+G8SPrFPiRgY4q8n8dVGwAWOvv2PwT
         dVgPs98BzXgQI+3wNKRQhC5QsR6/CAyTUukIh666TZbo7RIdp4rxq/r/JCHMHuwOB/K8
         s2Kn8iEEoobpTCtD3nArYjFjNhZxDxfdzYi10MJkQnXWFogofruxM915Z7BzCbyg4Nkv
         J6OA==
X-Gm-Message-State: AOAM531S3Yz9BuwDZPNS3hL9cNzs5md0qA/yP/eXL2TXjjXDhzV6SL0A
        geD8eSTCISlIWeC7SjGoO15eX6sKXl8Ni4EsLB1McKKjqZymFjA4kWAQJmYx/4m5KYU2ZVVXjlg
        hSGVehVIJY+syVSUsnsQGcy7NordKuYph0nq5w6xwJw==
X-Received: by 2002:a05:6000:168b:: with SMTP id y11mr2151614wrd.350.1631802174726;
        Thu, 16 Sep 2021 07:22:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAAz9JhskIUtHa4kkTqDRNI5TZiFNAFQnBbn2YukyGbqIRnnwT7erACudFQ5JXKwwDEsJdJQ==
X-Received: by 2002:a05:6000:168b:: with SMTP id y11mr2151596wrd.350.1631802174568;
        Thu, 16 Sep 2021 07:22:54 -0700 (PDT)
Received: from [192.168.2.211] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id t17sm3489067wra.95.2021.09.16.07.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 07:22:53 -0700 (PDT)
Subject: Re: [RFC][PATCH] crypto: caam - Add missing MODULE_ALIAS
To:     Marek Vasut <marex@denx.de>, linux-crypto@vger.kernel.org
Cc:     ch@denx.de, Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20210916134154.8764-1-marex@denx.de>
 <441a7e2e-7ac8-5000-72e0-3793ae7e58d5@canonical.com>
 <08afb147-07c7-9fbb-4a0c-8a79717b06b7@denx.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <0d2b7eee-dd3a-fcac-08df-29a8eb67b133@canonical.com>
Date:   Thu, 16 Sep 2021 16:22:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <08afb147-07c7-9fbb-4a0c-8a79717b06b7@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 16/09/2021 16:06, Marek Vasut wrote:
> On 9/16/21 3:59 PM, Krzysztof Kozlowski wrote:
>> On 16/09/2021 15:41, Marek Vasut wrote:
>>> Add MODULE_ALIAS for caam and caam_jr modules, so they can be auto-loaded.
>>>
>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>>> Cc: Horia Geantă <horia.geanta@nxp.com>
>>> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
>>> Cc: Krzysztof Kozlowski <krzk@kernel.org>
>>> ---
>>>   drivers/crypto/caam/ctrl.c | 1 +
>>>   drivers/crypto/caam/jr.c   | 1 +
>>>   2 files changed, 2 insertions(+)
>>>
>>
>> Since you marked it as RFC, let me share a comment - would be nice to
>> see here explanation why do you need module alias.
>>
>> Drivers usually do not need module alias to be auto-loaded, unless the
>> subsystem/bus reports different alias than one used for binding. Since
>> the CAAM can bind only via OF, I wonder what is really missing here. Is
>> it a MFD child (it's one of cases this can happen)?
> 
> I noticed the CAAM is not being auto-loaded on boot, and then I noticed 
> the MODULE_ALIAS fixes cropping up in the kernel log, but I couldn't 
> find a good documentation for that MODULE_ALIAS. So I was hoping to get 
> a feedback on it.

Some busses, e.g. SPI or I2C, always reports matching name of
"i2c:<foo>" even if actual matching of device was done via OF. The
uevent will be i2c:<foo>.

If the I2C/SPI table does not have above <foo> entry, but it has <foo>
in OF table, you will have a case:
1. built-in works, because device matching happens via OF table,
2. module autoloading does not work, because module matching happens via
I2C ID table.

MFD children, which are usually platform devices, is another example.

However your case looks different. What uevent do you get for this
device? What does modinfo print?

Best regards,
Krzysztof
