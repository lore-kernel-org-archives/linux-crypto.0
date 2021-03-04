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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C16C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 22:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6446764F5B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 22:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhCDW2i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 17:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhCDW2i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 17:28:38 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C10C061574;
        Thu,  4 Mar 2021 14:28:37 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id t9so115838pjl.5;
        Thu, 04 Mar 2021 14:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QGTkbMjMvhOjPNZj43kjGavXYdondmbyryts8KXSdm8=;
        b=JqZEFh+wZYnJFc/Bu22qdeo3ii9XTxXA9kmc/tAu4o9lcuHsP3F86LIxig6PvLmgcH
         bWPDgM00KhiBP69mezT53poyGGxvkKW7BKRpPOIaCvz+LlW/fXur4kgJGPsDf2/1lH6R
         ZMS2V933XoGopl2K1ea/6My6k8xlhpFX2j16BizgmSJ13S7qDon8t4OpGZGyZPiSrutj
         1N94UnlEWgynMNh6slC8dDtEPfTp7PLWu2vHtq19iEHPskcOr/E4QZIpUUugwCAIHXwU
         5ySA8W0h92985B9g+B3iao4y+JAgQ4vXsTzIvCbM6ip8nlen4hJRxozB9RAwKvGThg73
         nXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QGTkbMjMvhOjPNZj43kjGavXYdondmbyryts8KXSdm8=;
        b=n+tpmPmz1uvTNbgz5vCA0dhJKK8tGHnOcX/8x1fY/u+cSaFnzVzjTChyDF1pnKqof9
         Q/YNDq2BrPOSFVE63v2+aRXjAhuSqxEfNxszOiYQcD3tUrvkmi966oB8VshlfNVbXyfj
         BghsmWAug6KFKZXEUu9dT6SAigKvNfWVfHSfJSHMFlevJLf9bdb8Vfg5qkuNz9aGXURN
         i10L/chYKEi9aEWSx1E6n3RXGV6wE3gkceYHdAy1iTRrHi8SQk/OtsnotshIHJjDxzsG
         0oDRnp22+Z/KeMAaOxF+vXONyAxyn6CeO5RxMNcJkdyJqozOX/7eye2Z6Y+2A3iKJlqN
         0aSQ==
X-Gm-Message-State: AOAM53068wogM1wsNaQnKAkCYS8gxrfGJkbGPRcxq+q47ZdGUvaW+Wxd
        CYCTMrmLvOmYPvio7JIHEzI=
X-Google-Smtp-Source: ABdhPJzNnTx628IwTkffe4agL3F/ap6im0NJmMGXAL3JovM1xNCU6RNjhYEd7ob/2PWc3GQMCDHfCw==
X-Received: by 2002:a17:90a:2a46:: with SMTP id d6mr6644334pjg.197.1614896917115;
        Thu, 04 Mar 2021 14:28:37 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o9sm369137pfh.47.2021.03.04.14.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 14:28:36 -0800 (PST)
Subject: Re: [PATCH] hwrng: bcm2835: set quality to 1000
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Lunn <andrew@lunn.ch>, Matt Mackall <mpm@selenic.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stijn@linux-ipv6.be, ynezz@true.cz
References: <20210220174741.23665-1-noltari@gmail.com>
 <YDFeao/bOxvoXI9D@lunn.ch> <9b86c773-7153-1e18-472a-f66b01c83173@gmail.com>
 <20210303092019.GB8134@gondor.apana.org.au>
 <66AED5A4-3227-47CA-A4A2-B5AD6A571AAC@gmail.com>
 <c76c82668142710ba5a7a8454759c9aa2423d72f.camel@suse.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b0cf1be0-4c7c-57ee-fea5-789fe215b85d@gmail.com>
Date:   Thu, 4 Mar 2021 14:28:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <c76c82668142710ba5a7a8454759c9aa2423d72f.camel@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/4/21 7:11 AM, Nicolas Saenz Julienne wrote:
> On Wed, 2021-03-03 at 10:29 +0100, Álvaro Fernández Rojas wrote:
>> Hi Herbert,
>>
>>> El 3 mar 2021, a las 10:20, Herbert Xu <herbert@gondor.apana.org.au> escribió:
>>>
>>> On Sat, Feb 20, 2021 at 08:12:45PM +0100, Álvaro Fernández Rojas wrote:
>>>>
>>>> I ran rngtest and this is what I got:
>>>
>>> This is meaningless except for sources that have not been whitened.
>>>
>>> Your justification needs to be based on what the hardware does or
>>> is documented to do.
>>
>> Ok, so I guess that we’re never setting that value to anything since there’s
>> no public documentation about that ¯\_(ツ)_/¯.
> 
> @Florian, is there a way you might be able to get the official value?

I will be looking into the documentation this weekend and let you know
whether we can change the driver's quality accordingly.
-- 
Florian
