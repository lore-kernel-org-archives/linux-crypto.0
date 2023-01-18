Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC16AC32793
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Jan 2023 16:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjARQhz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Jan 2023 11:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjARQhf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2023 11:37:35 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2884048618
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2023 08:37:25 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r9so11747266wrw.4
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2023 08:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SvcyApmvYKbhMxRU1lBU5lO8l2c63hcs0Nh63H9OSkU=;
        b=WAKsBPCUGvdQDm9d8EgdgiebxIqoGD/TnPD/w4Unj0sr4AsjT6TM6CMiY0uD0gqeci
         YqLZyBc8iv2IIeV8t7rn//eAy22qGuN4EfUgvj9kFemITC2BOP10ahxMM/JfT+IHzWDO
         DPjp55JFoK6pAnVpZEIYb0QAeNmLUuNeENob4gq8iW4c4gGuEXfdFUvFVlwIUkvGkgoY
         9EVBLd2CQobELCrqjpEZzh096zCLFmgOGyTE3Q2/upXDJonXm8XT/s5rS2RlprQmsFqB
         aYILB9VKNw8ggi/NSKU8tdvoxHpYBCsYzojY6wc+HkAyaySgJMRheYluMfdletPR5oK+
         TReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SvcyApmvYKbhMxRU1lBU5lO8l2c63hcs0Nh63H9OSkU=;
        b=rtIVePbZtoRWOCkoHiCp3OzP7RIY82kjiD+RUAZ3H8Kz/nmJ/ijPLPorlpd9mIkBFX
         HQYSyiYCK3KrklQFB2ahWEkj9GIPo3KYpVCqpIBVlqcqhatMLubbpXc4Kmb3Y33HB8c3
         0gZNKri2azjuT/qs0jOYr9K8Dt/NAhacT+pZNAVcr+qsNXamHZwFeOoIk16OgOEFLMp7
         PpLv2pKRRi45fGWLV9uu+ifafQXdWFIjBQwBDHWyYqLTPSsgWTuhDhXGdN6R1D9LAiEd
         nfJWZXi3BM10Wa9C6yUHuId/T2uaobMx3Ldtn8Y30jiiQZCXvvm6Hn3gJuGum2c4DBRy
         N1VA==
X-Gm-Message-State: AFqh2kpypl571MtceBcxWWBQKE0kbY+OU5n3d9vnxh2e7gFqGc5R4w+I
        Qdro1BtjgtyNVglrL1AQsa0Ndw==
X-Google-Smtp-Source: AMrXdXsCy/j9nV45B+2uqVon/wd9l2XwrMH20gcWUjVTm/cksrL2RHvILrsrS9SZCKz5q0c3ug/XBQ==
X-Received: by 2002:a5d:4fce:0:b0:242:1bdf:a02 with SMTP id h14-20020a5d4fce000000b002421bdf0a02mr6504812wrw.37.1674059843738;
        Wed, 18 Jan 2023 08:37:23 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m16-20020adfe0d0000000b002be36beb2d9sm666486wri.113.2023.01.18.08.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 08:37:23 -0800 (PST)
Message-ID: <2c0de89e-0842-21af-cedf-2aa9184c6d1a@arista.com>
Date:   Wed, 18 Jan 2023 16:37:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 3/4] crypto/net/ipv6: sr: Switch to using crypto_pool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20230116201458.104260-1-dima@arista.com>
 <20230116201458.104260-4-dima@arista.com>
 <20230117194856.55ec5458@kernel.org>
Content-Language: en-US
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <20230117194856.55ec5458@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/18/23 03:48, Jakub Kicinski wrote:
> On Mon, 16 Jan 2023 20:14:57 +0000 Dmitry Safonov wrote:
>> The conversion to use crypto_pool has the following upsides:
>> - now SR uses asynchronous API which may potentially free CPU cycles and
>>   improve performance for of CPU crypto algorithm providers;
>> - hash descriptors now don't have to be allocated on boot, but only at
>>   the moment SR starts using HMAC and until the last HMAC secret is
>>   deleted;
>> - potentially reuse ahash_request(s) for different users
>> - allocate only one per-CPU scratch buffer rather than a new one for
>>   each user
>> - have a common API for net/ users that need ahash on RX/TX fast path
> 
> breaks allmodconfig build:
> 
> ERROR: modpost: "seg6_hmac_init" [net/ipv6/ipv6.ko] undefined!
> make[2]: *** [../scripts/Makefile.modpost:138: Module.symvers] Error 1
> make[1]: *** [/home/nipa/net-next/Makefile:1960: modpost] Error 2
> make: *** [Makefile:242: __sub-make] Error 2

Thanks!
Yeah, I thought I barely touched seg6 in v3 and it seems I didn't even
build it in current .config assuming not much changed. Oops!

Will send a better version 4 today,
          Dmitry

