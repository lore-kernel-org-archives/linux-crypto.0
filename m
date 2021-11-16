Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9ABC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 10:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3185161C4F
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 10:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhKPKWf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 05:22:35 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:40482 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbhKPKWV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 05:22:21 -0500
Received: by mail-wr1-f48.google.com with SMTP id r8so36428504wra.7
        for <linux-crypto@vger.kernel.org>; Tue, 16 Nov 2021 02:19:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2pVUUhOW+PPHRe1owVHKWAC0hNxvDcyMPYMZUcLWpfo=;
        b=VIyGboDRF2Ffo5ssK9ht0mId8DDFE3D1zjXHMbLvRwb3hJ8LODhdtofI6e6lC226R1
         SPTr1ZR9P1ZVUlLyAarLOAUVjIWnASqcGOjdJ4vwNo3tpzxYfNCmbxIvMDNai1nm5MDs
         /dEUPzwr4b+QI2YOU7uhhO+iGgVHm7nNbTylA8n2tQdwS2R+fVFzAUq4kZO2rNuUtPxq
         4456u45c38jfQic1tDeAjRAmurtMsO+oXXDREFiniEdbM2VMTCVN9NN9VDjixUuEYN8k
         gART6yCQam6GE5/9b9g3faUpVvi1pVA4yI3g/gnFS9l2KQvyQkrCw0FjX/6gFstZa9uw
         Bh0A==
X-Gm-Message-State: AOAM532aovIZd6t4MU2asd4ltZLrAzx69Knfc8pw2VBft3mWnxceBB/K
        SHT3Phfopa8PNErBVEPrItcCbUG4cSo=
X-Google-Smtp-Source: ABdhPJwqefqf0wNR0FMTlsltbl/SJPJHAGRP8LTifsg0vB3tNEwjvpbKaPNg2IP7kWKdjELhfRti7Q==
X-Received: by 2002:adf:e882:: with SMTP id d2mr7934329wrm.389.1637057964056;
        Tue, 16 Nov 2021 02:19:24 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id z6sm2560612wmp.1.2021.11.16.02.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 02:19:08 -0800 (PST)
Subject: Re: [PATCHv5 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211112125928.97318-1-hare@suse.de>
 <74db7c77-7cbf-4bc9-1c80-e7c42acaea64@grimberg.me>
 <f67ca46e-f421-33f7-da8b-ff6e47acf8c2@suse.de>
 <8553266f-005c-f947-4737-2108cb7062d1@grimberg.me>
 <a7363853-05af-9d7f-4d6f-b02ec756ce6b@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <50095ec8-3825-efa5-98bb-76b0f0fdc21e@grimberg.me>
Date:   Tue, 16 Nov 2021 12:18:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a7363853-05af-9d7f-4d6f-b02ec756ce6b@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>>>>> - Transform secret with correct hmac algorithm
>>>>
>>>> Is that what I reported last time? Can you perhaps
>>>> point me to the exact patch that fixes this?
>>>
>>> Well, no, not really; the patch itself got squashed in the main patches.
>>> But problem here was that the key transformation from section 8.13.5.7
>>> had been using the hash algorithm from the initial challenge, not the
>>> one specified in the key itself.
>>> This lead to decoding errors when using a key with a different length
>>> than the hash algorithm.
>>
>> That is exactly what I reported, changing the key length leads to
>> authentication errors.
> 
> Right-o. So it should be sorted then.

Hannes, was the issue on the host side or the controller side?

I'm a little lost into what was the actual fix...
