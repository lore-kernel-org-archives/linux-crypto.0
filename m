Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC34C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Dec 2021 13:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhLMNxj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Dec 2021 08:53:39 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:56094 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbhLMNxj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Dec 2021 08:53:39 -0500
Received: by mail-wm1-f43.google.com with SMTP id p18so11944902wmq.5
        for <linux-crypto@vger.kernel.org>; Mon, 13 Dec 2021 05:53:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mRImVUXizjXFbyDIshaydV7yCJAO62vsecbpn87GvaY=;
        b=tVZdW70BAvDfi906SxYRV5lK3/iLRHsuFJ7ny85EgVKBPrZKwGy9C6YJIlvkE1pQ4b
         Uo53belCMpPZdDdY6xFke8RXV1qNU9LFDR5ulI9bwehB5Zba5mFfkc4uMJ5gDZc+wS6f
         7VmtunzxmnjLZaHIshpUIWLw1QtyM/u4Q9rYrLwD0Fe3X6u4xcZIjG9JPyQdwjD8qWwm
         Cv96rBx+BvA1tie8fwv3dApe2oNMms1HUvvwTIj3rHg+2sYb6sm9VzrWidU3UuD20sHX
         IHRnEtIO6rusdx0E4Kr7ZedqaKcifuoMVxyB1EAPnMYJTetOtZdFUuargunJPPZuyRsb
         dGMA==
X-Gm-Message-State: AOAM5329SI8W2gG207j4GWZAlj42b9Y9QUd4+06ESkyVyVCeUCYLR5zk
        vXxMkamV12d8NKpbHge5hB7AS7Wz/Ww=
X-Google-Smtp-Source: ABdhPJyQ7p8lmXTzWOLLv4vijJl5l30p84V8FIxcXpLNzmS+IaE7MpNxHgfNAptzXLqvQipW7KalWQ==
X-Received: by 2002:a05:600c:4e45:: with SMTP id e5mr37587819wmq.43.1639403617712;
        Mon, 13 Dec 2021 05:53:37 -0800 (PST)
Received: from [10.100.102.14] (85-250-228-224.bb.netvision.net.il. [85.250.228.224])
        by smtp.gmail.com with ESMTPSA id e7sm13951741wrg.31.2021.12.13.05.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 05:53:37 -0800 (PST)
Subject: Re: [PATCHv8 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211213080853.GA21223@lst.de>
 <9853d36a-036c-7f2b-5fb4-b3fb4bae473f@suse.de>
 <4328e4f0-9674-9362-4ed5-89ec7edba4a2@grimberg.me>
 <56f1ce1c-2272-bed2-fd6b-642854b612bb@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <483836f5-f850-6eac-8c38-3f03db3189ab@grimberg.me>
Date:   Mon, 13 Dec 2021 15:53:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <56f1ce1c-2272-bed2-fd6b-642854b612bb@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>>>> So if we want to make progress on this we need the first 3 patches
>>>> rewviewed by the crypto maintainers.  In fact I'd prefer to get them
>>>> merged through the crypto tree as well, and would make sure we have
>>>> a branch that pulls them in for the nvme changes.  I'll try to find
>>>> some time to review the nvme bits as well.
>>>>
>>> That is _actually_ being addressed already.
>>> Nicolai Stange send a patchset for ephemeral keys, FFDHE support, and
>>> FIPS-related thingies for the in-kernel DH crypto implementation
>>> (https://lore.kernel.org/linux-crypto/20211209090358.28231-1-nstange@suse.de/).
>>>
>>> This obsoletes my preliminary patches, and I have ported my patchset
>>> to run on top of those.
>>>
>>> Question is how to continue from here; I can easily rebase my patchset
>>> and send it relative to Nicolais patches. But then we'll be bound to
>>> the acceptance of those patches, so I'm not quite sure if that's the
>>> best way to proceed.
>>
>> Don't know if we have a choice here... What is the alternative you are
>> proposing?
> 
> That's the thing, I don't really have a good alternative, either.
> It's just that I have so no idea about the crypto subsystem, and
> consequently wouldn't know how long we need to wait...
> 
> But yeah, Nicolais patchset is far superior to my attempts, so I'd be
> happy to ditch my preliminary attempts there.

Can we get a sense from the crypto folks to the state of Nicolais
patchset?
