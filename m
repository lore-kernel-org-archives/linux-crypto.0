Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A8EC0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 13:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EE67206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 13:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfG3NVA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 09:21:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43152 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfG3NVA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 09:21:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so65738725wru.10
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2019 06:20:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A9EYRhI4+EE+ZGKp+ffQkK4p5ON1SSumspMkJAaec5Y=;
        b=qF2TxmNZ681evqDMsUaRIanLZLWwu/CUvvIWgeA+D79MYEH7Gblwxh9jX4KnYHkW8U
         n8NfgO2ECfhFQATqNLAetz/zGfHIa6mwb+9/JfJnjV/5pPBxy39HPVEYHIa6NPSScWT2
         96luAKB96Vfv07ej/eJRXhB/S+4D5DfCBTPWW94yT/bG4AlHwcVY3aIiFhUGelS7t30C
         YIOM7w+5aAFH9bcV+QaSRA/sBqWpCZUezFBEAL8IuvEit6Fo29cp/WXm4B4hx1iycLq3
         8hvJ4A63ZrfiDaM8PdR+3EkNJ3Hrg88of64OytYoYDr7cI+tBAAFwjWnZ5KfcSsUZY79
         162w==
X-Gm-Message-State: APjAAAUNXRNAIiOUqYF1P+HzJpo7VEaySvBMcRKtZCBQ+doStDBRVjZY
        ypeHCsDF8dPGORdPAgT8otixqos+kBc=
X-Google-Smtp-Source: APXvYqzxIZDE+U9SDxd92Oxaky87it5u3TGmCpUk7Pb+SzBgiojRWMt+USFBtOKJpM9Wo/vTFlgr8Q==
X-Received: by 2002:a5d:6b11:: with SMTP id v17mr50687572wrw.323.1564492858488;
        Tue, 30 Jul 2019 06:20:58 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id f2sm61263792wrq.48.2019.07.30.06.20.57
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 06:20:57 -0700 (PDT)
Subject: Re: [RFC 3/3] crypto/sha256: Build the SHA256 core separately from
 the crypto module
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <20190730123835.10283-1-hdegoede@redhat.com>
 <20190730123835.10283-4-hdegoede@redhat.com>
 <4384403.bebDo606LH@tauon.chronox.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <195e59d5-ea5e-9332-93ae-4a76a9301170@redhat.com>
Date:   Tue, 30 Jul 2019 15:20:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4384403.bebDo606LH@tauon.chronox.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 30-07-19 15:15, Stephan Mueller wrote:
> Am Dienstag, 30. Juli 2019, 14:38:35 CEST schrieb Hans de Goede:
> 
> Hi Hans,
> 
>> From: Andy Lutomirski <luto@kernel.org>
>>
>> This just moves code around -- no code changes in this patch.  This
>> wil let BPF-based tracing link against the SHA256 core code without
>> depending on the crypto core.
>>
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> ---
>>   crypto/Kconfig                               |   8 +
>>   crypto/Makefile                              |   1 +
>>   crypto/{sha256_generic.c => sha256_direct.c} | 103 +--------
> 
> There is a similar standalone code present for SHA-1 or ChaCha20. However,
> this code lives in lib/.
> 
> Thus, shouldn't the SHA-256 core code be moved to lib/ as well?

lib/ actually already has a sha256 implementation: lib/sha256.c
but that is currently only used by the x86 and s390 purgatory code.

Ideally the 2 would be merged I guess ...

Regards,

Hans
