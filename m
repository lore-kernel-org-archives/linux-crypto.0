Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AF3C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7379320644
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfG3QH7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 12:07:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36818 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbfG3QH6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 12:07:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so66471102wrs.3
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2019 09:07:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XugcqmO1pV3yrRWZfbHGzGAG8Jv+RlraEAIYCnkVVEw=;
        b=eFp5SBnltNBLb3vD26RNp6ata0rfkvmmzrsbkiC/Qfs/KdKUXtJLl/d4aBQFf5PG6g
         qFONS3SQEFoRc+5lqdLdVAA92EGp042Rk3OiNg/IV8pnoBDNW6TmZYSO7DpDMzoRLvHI
         h13bl1vq/SYzDCIPGP+ZRsmU9/3d6w2y9YBby+b8P9coKI27qhpSYU8gklIeqvpqjTvA
         l6EyIeqqlVHVdM3RqMzTCmEZeO2zrmAfT1Y2Mf6JJLQEGzO+MwHCVMnZj9x8hZ16RG7C
         zAGj6wmYkVlnRvkaZ3OnNgLUvhqkN+KOig6O6gl0Hf30gA2A4ANWpNJovCGTvI+50Hha
         uEsw==
X-Gm-Message-State: APjAAAWd2vrQB5iBi0wrvRxiUcZwpoNJ+QNXU/qGOaFBkz3S2Bj+BVN1
        UoWRZ1kQGh3uJTEgnrKcpqpzkA==
X-Google-Smtp-Source: APXvYqyoN+NbqDloVT6ub8XdbBtSlUEa14exZNH0N1lZckziCyVnC5/dm49sN0Pb1mbgq3krHeUugg==
X-Received: by 2002:a5d:60c5:: with SMTP id x5mr40624093wrt.253.1564502876652;
        Tue, 30 Jul 2019 09:07:56 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id z1sm66936082wrp.51.2019.07.30.09.07.55
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 09:07:55 -0700 (PDT)
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
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <cb888bfa-dd46-de7a-3b90-b54fa79fa3d4@redhat.com>
Date:   Tue, 30 Jul 2019 18:07:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730160335.GA27287@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 30-07-19 18:03, Eric Biggers wrote:
> On Tue, Jul 30, 2019 at 03:15:35PM +0200, Stephan Mueller wrote:
>> Am Dienstag, 30. Juli 2019, 14:38:35 CEST schrieb Hans de Goede:
>>
>> Hi Hans,
>>
>>> From: Andy Lutomirski <luto@kernel.org>
>>>
>>> This just moves code around -- no code changes in this patch.  This
>>> wil let BPF-based tracing link against the SHA256 core code without
>>> depending on the crypto core.
>>>
>>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>>> ---
>>>   crypto/Kconfig                               |   8 +
>>>   crypto/Makefile                              |   1 +
>>>   crypto/{sha256_generic.c => sha256_direct.c} | 103 +--------
>>
>> There is a similar standalone code present for SHA-1 or ChaCha20. However,
>> this code lives in lib/.
>>
>> Thus, shouldn't the SHA-256 core code be moved to lib/ as well?
>>
>> Ciao
>> Stephan
>>
>>
> 
> What's wrong with lib/sha256.c?  It's already there.

That is currently not build under lib/ it is only build as part of
the helper executable which deals with transitioning from one kernel to
the next on kexec, specifically it is used by arch/x86/purgatory/purgatory.c
and also be the s390 purgatory code.

Since the purgatory use is in a separate binary / name space AFAICT, we
could add sha256.o to lib/Makefile and then I could use that, but then the
normal kernel image would have 2 SHA256 implementations.

Regards,

Hans
