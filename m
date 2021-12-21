Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC4BC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Dec 2021 20:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhLUUzO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Dec 2021 15:55:14 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:40488 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235188AbhLUUzO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Dec 2021 15:55:14 -0500
Received: by mail-wm1-f49.google.com with SMTP id j140-20020a1c2392000000b003399ae48f58so2542730wmj.5
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2021 12:55:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=peNfjyvSHuZS7d9Xq56OU5X9wJb2moCNRIFyWTeF44U=;
        b=E2j0iKFWOoVNtTNqSAB5s/pNdr8Ai1jghS6OSud6TgEJVY7r5lPzGmA6sGkH//Gw7N
         dJAlWrMuaRECkNjhBl5C6CG01fX9yVtEDAcO1umAbkJmU3AID4JMeqAxr2nyfgH64iQe
         HlqOCtZYcyFDFLHrjhPgRiRfsD8/q0yDM47rvQkbm2S4FBl0At3R9mhI5Jy+RXx3CFuU
         OYo7rQpF5s3aOwbN0CW4xjDMiVdJqCO9J5zOP5QChU/9uFhsOQh4DEiJYV/yqwY1rXKv
         bkjSjTTZguReUYxL8e5rkuJxC0vIDoeSLL+NP61imLQLC2SiaDT5QFa5kyV2mK4SbBIS
         TTIA==
X-Gm-Message-State: AOAM533zkWjxsmgjLVP/tUV1KFE3jMTd8dAisO2zK2tKT05mSOoJOI6v
        vx6hVhv8ZTtD6hcKqM7tgmYjEkbkXGg=
X-Google-Smtp-Source: ABdhPJwz9LKtv8NBwwD/rXtvurbTPQSVP9FjBir9aEXo9I87yLgO2SWiIbCcuobvBlgBMPZqQA9TYg==
X-Received: by 2002:a05:600c:19cb:: with SMTP id u11mr181967wmq.142.1640120113292;
        Tue, 21 Dec 2021 12:55:13 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id h27sm3576587wmc.43.2021.12.21.12.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 12:55:12 -0800 (PST)
Subject: Re: [PATCHv8 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211213080853.GA21223@lst.de>
 <9853d36a-036c-7f2b-5fb4-b3fb4bae473f@suse.de>
 <4328e4f0-9674-9362-4ed5-89ec7edba4a2@grimberg.me>
 <56f1ce1c-2272-bed2-fd6b-642854b612bb@suse.de>
 <483836f5-f850-6eac-8c38-3f03db3189ab@grimberg.me>
 <0c4613ff-ba30-c812-a6e9-1954d77b1d1b@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <ad9af172-4b7b-4206-feab-8ab54ba7cfe5@grimberg.me>
Date:   Tue, 21 Dec 2021 22:55:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0c4613ff-ba30-c812-a6e9-1954d77b1d1b@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>>>>> Question is how to continue from here; I can easily rebase my patchset
>>>>> and send it relative to Nicolais patches. But then we'll be bound to
>>>>> the acceptance of those patches, so I'm not quite sure if that's the
>>>>> best way to proceed.
>>>>
>>>> Don't know if we have a choice here... What is the alternative you are
>>>> proposing?
>>>
>>> That's the thing, I don't really have a good alternative, either.
>>> It's just that I have so no idea about the crypto subsystem, and
>>> consequently wouldn't know how long we need to wait...
>>>
>>> But yeah, Nicolais patchset is far superior to my attempts, so I'd be
>>> happy to ditch my preliminary attempts there.
>>
>> Can we get a sense from the crypto folks to the state of Nicolais
>> patchset?
> 
> According to Nicolai things look good, rules seem to be that it'll be
> accepted if it has positive reviews (which it has) and no-one objected
> (which no-one did).
> Other than that one would have to ask the maintainer.
> Herbert?

Any updates on this?
