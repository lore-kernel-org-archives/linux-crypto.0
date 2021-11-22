Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FC6C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 11:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhKVLft (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:35:49 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:45693 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbhKVLft (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 06:35:49 -0500
Received: by mail-wm1-f45.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so13297996wme.4
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 03:32:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kviJokxr4QloTY2PjSmL1SOdZnGOhuURKjR3IayPBq8=;
        b=sr1iPH/Eu4DGkv5jnP0eTVYC5sLzHsGXFVl08G0HhfZLG5yV3sYnlq8mRdHofF1THx
         7QuhqAx5NsOXzTyCQO3QaINpfgg6GQOfeHG9+TOG0f9pPSa+xwxVZMYuOmJk3eL1KlUz
         gc6fdqKj8TCpUrbeRqBYdFZ6rKdcePwetvJ9XGIaGDuNWEInxOXZ6XdMlmG2WSHtr6Rw
         QKuE2po7j+xQL5oytZJPTorDVxKtNzDUIJAgTIxZrqZBJvp4Pbd9dsydHhNpH5kobh5t
         BEb9i+hJ/Nha1VDIw6o/J/iprWvGmba2H1SHD7saep+P3Q6h6J0Eo74osCyCAiT0BYTK
         neIQ==
X-Gm-Message-State: AOAM532HUxewAomi82yLXLd4oJ8/VEM2eStoAi0j6tjIVAxH8kIy6QVY
        NG1V5chq3AyG53r9dbZU1h+bBh+qMCY=
X-Google-Smtp-Source: ABdhPJyncsgITIAMiA4Rj0pZKn1+M7Oz+23DbM17NtoFCyprdp21I1t47XLxFkLYgX+uz0LiDy5kfA==
X-Received: by 2002:a1c:9d48:: with SMTP id g69mr30286377wme.188.1637580761743;
        Mon, 22 Nov 2021 03:32:41 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id a12sm8541498wrm.62.2021.11.22.03.32.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 03:32:41 -0800 (PST)
Subject: Re: [PATCHv6 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
 <14b025bc-746f-ea73-a325-7805c4b46c28@grimberg.me>
 <8e0909ad-f431-2600-7b68-d86d014fc9ec@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <8ba377cc-5c33-7cba-456e-bfc890f1ad88@grimberg.me>
Date:   Mon, 22 Nov 2021 13:32:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <8e0909ad-f431-2600-7b68-d86d014fc9ec@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>>> Hi all,
>>>
>>> recent updates to the NVMe spec have added definitions for in-band
>>> authentication, and seeing that it provides some real benefit
>>> especially for NVMe-TCP here's an attempt to implement it.
>>>
>>> Tricky bit here is that the specification orients itself on TLS 1.3,
>>> but supports only the FFDHE groups. Which of course the kernel doesn't
>>> support. I've been able to come up with a patch for this, but as this
>>> is my first attempt to fix anything in the crypto area I would invite
>>> people more familiar with these matters to have a look.
>>>
>>> Also note that this is just for in-band authentication. Secure
>>> concatenation (ie starting TLS with the negotiated parameters) is not
>>> implemented; one would need to update the kernel TLS implementation
>>> for this, which at this time is beyond scope.
>>>
>>> As usual, comments and reviews are welcome.
>>>
>>> Changes to v5:
>>> - Unify nvme_auth_generate_key()
>>> - Unify nvme_auth_extract_key()
>>
>> You mean nvme_auth_extract_secret() ?
>>
> Yes.
> 
>>> - Include reviews from Sagi
>>
>> What about the bug fix folded in?
> 
> Yeah, and that, to
> Forgot to mention it.

It is not the code that you shared in the other thread right?

> 
> Also note that I've already folded the nvme-cli patches into the git
> repository to ease testing; I gather that the interface won't change
> that much anymore, so I felt justified in doing so.

It's ok, we can still change if we want to.
