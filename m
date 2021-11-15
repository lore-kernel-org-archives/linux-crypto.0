Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C32AC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 10:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA3263222
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 10:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbhKOKX3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:23:29 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:45901 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237584AbhKOKXO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 05:23:14 -0500
Received: by mail-wm1-f49.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so11976403wme.4
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 02:20:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BF/osmNNPfDts1fW+0kCRVGbiBTFAPA2CyU1oR+zBR0=;
        b=Z4JlmZ4zUTesHxfEnZcJqBYYPxvRbKWOE6MRwzvQmpkbV4aBospXjKxj9GxQdUIMON
         dN/AK1964h2y5pwDdSMTXLzFRzSZaBYdyv6ckn7Z+Du1H9sAeAr/dNhm35i7tx6nqrlK
         lkv6rOmFOJ20kFH3QwzCTGOKUnyjOrwz7lyd3qrT94TplHyvZzyOMETIx6Txhlso4JWJ
         4Ckcj/Vx9KpqFYbFwVL33YD6Ft7LRnpr9JphIhKLGQPXEt7e5X2SZBtyVzer+VanAbdO
         vg12lRlkKsLIt+8arGWh471Z/4mU9NEuYchxZEM97AdDijZk04sqezxdQBeFeQkDY/XA
         uFYA==
X-Gm-Message-State: AOAM533lTckGb+ZKd4K+uXEsUpunMpzWzuquZbFVlQLhI2XUPR0PwLLd
        D+FD3q1M4ebx9qXIbLzGWxcQ4PwG3pM=
X-Google-Smtp-Source: ABdhPJwHtMNWBlf6CjJhbujzn8Xi6oBFGscH9w9KFPZMp53i+L12Bbpfr2eQBs2SSk5aOMJkfm/25Q==
X-Received: by 2002:a1c:287:: with SMTP id 129mr44747564wmc.49.1636971618146;
        Mon, 15 Nov 2021 02:20:18 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id g5sm20696736wri.45.2021.11.15.02.20.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 02:20:17 -0800 (PST)
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
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <8553266f-005c-f947-4737-2108cb7062d1@grimberg.me>
Date:   Mon, 15 Nov 2021 12:20:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f67ca46e-f421-33f7-da8b-ff6e47acf8c2@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>>> Changes to v4:
>>> - Validate against blktest suite
>>
>> Nice! thanks hannes, this is going to be very useful moving
>> forward.
>>
> Oh, definitely. The number of issue these tests found...

Great, good that this was useful for you.

>>> - Fixup base64 decoding
>>
>> What was fixed up there?
>>
> The padding character '=' wasn't handled correctly on decoding (the 
> character itself was skipped, by the 'bits' value wasn't increased, 
> leading to a spurious error in decoding an any key longer than 32 bit 
> not being accepted.

I see.

>>> - Transform secret with correct hmac algorithm
>>
>> Is that what I reported last time? Can you perhaps
>> point me to the exact patch that fixes this?
> 
> Well, no, not really; the patch itself got squashed in the main patches.
> But problem here was that the key transformation from section 8.13.5.7 
> had been using the hash algorithm from the initial challenge, not the 
> one specified in the key itself.
> This lead to decoding errors when using a key with a different length 
> than the hash algorithm.

That is exactly what I reported, changing the key length leads to
authentication errors.
