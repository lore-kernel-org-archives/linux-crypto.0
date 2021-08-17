Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F01CC4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 21:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB3676102A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 21:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhHQVWI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 17:22:08 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:43970 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhHQVWI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 17:22:08 -0400
Received: by mail-qt1-f173.google.com with SMTP id l3so18403218qtk.10
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 14:21:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h4c9eridmxkphFFOBoPmYKgD9hRWmeja2kwztcEKjsg=;
        b=Jf1C/cjlRFVTDEz4mALs8qE9iC8hEszScFhJl18tx0/LMUlxvGDqGpc9nMfKVaszkk
         LhjknGbz9zwClgH3m/wLarFsyn53sTSDvE52GtrPw7rQmEj1coKdWizYDKy0ntq5u62/
         OzLrsADGV7GHvpwlX0uqkgm+W4IueVzQFitu/BAEx0Pu2rw1EvTXi6Zls5MM5ZnW4AyB
         EU2Xev55yCJp/xw5TbiOLSwbpicXGmW+B7hkjA1zWAh3ilE/GRfQa0w7NVkTmrFmmOSY
         cnL5wrDwEbncQl7NduF7iqNhR5iBl4TRrgCa+1d07DZzTZ9u4uZ6wSGfx3UakHPUHbxW
         Pwzg==
X-Gm-Message-State: AOAM533l4J1OuAT0crH2wFNA+5yyCdPovfcq3gkGx0LGhL6vJkHZ43al
        /ohgw7UvKlGPR6jtiP+OUDZTbzGKKns=
X-Google-Smtp-Source: ABdhPJwp7/RJGu4+3s+1aAyhr+on3BNtiGRUuYGVc+5vDmQrUcTornptNrZIQG+S9AQH/noHwR+J7g==
X-Received: by 2002:ac8:7e81:: with SMTP id w1mr5007450qtj.81.1629235293764;
        Tue, 17 Aug 2021 14:21:33 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:6c86:2864:dd78:e408? ([2600:1700:65a0:78e0:6c86:2864:dd78:e408])
        by smtp.gmail.com with ESMTPSA id 75sm2204474qko.100.2021.08.17.14.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 14:21:33 -0700 (PDT)
Subject: Re: [PATCHv2 00/13] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210810124230.12161-1-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <5a69187b-cfb1-d09a-87e2-8435e27612a7@grimberg.me>
Date:   Tue, 17 Aug 2021 14:21:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210810124230.12161-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> Hi all,
> 
> recent updates to the NVMe spec have added definitions for in-band
> authentication, and seeing that it provides some real benefit
> especially for NVMe-TCP here's an attempt to implement it.
> 
> Tricky bit here is that the specification orients itself on TLS 1.3,
> but supports only the FFDHE groups. Which of course the kernel doesn't
> support. I've been able to come up with a patch for this, but as this
> is my first attempt to fix anything in the crypto area I would invite
> people more familiar with these matters to have a look.
> 
> Also note that this is just for in-band authentication. Secure
> concatenation (ie starting TLS with the negotiated parameters) is not
> implemented; one would need to update the kernel TLS implementation
> for this, which at this time is beyond scope.
> 
> As usual, comments and reviews are welcome.

Hey Hannes,

First, can you also send the nvme-cli/nvmetcli bits as well?

Second, one thing that is not clear to me here is how this
works with the discovery log page.

If the user issues a discovery log page to establish connections
to the controllers entries, where it picks the appropriate
secret?

In other words, when the user runs connect-all, how does it handle
the secrets based on the content of the discovery log-page?
