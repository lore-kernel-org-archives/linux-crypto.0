Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0CAC433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Sep 2021 10:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1920C61041
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Sep 2021 10:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhISKEA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Sep 2021 06:04:00 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:34314 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhISKD6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Sep 2021 06:03:58 -0400
Received: by mail-wm1-f47.google.com with SMTP id y198-20020a1c7dcf000000b0030b69a49fe9so1415023wmc.1
        for <linux-crypto@vger.kernel.org>; Sun, 19 Sep 2021 03:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uzlhXYrj/MO0yY+a5q5EmM2pUQnuR7pMdP+Jpjxe7h8=;
        b=zKG2GEfLgpMNOvAz9KK9fnxrJquqjDux1AX4NheRAKCHtVzdEEGGZquw9piSDQPXXL
         LbyIbCn+MdrBu9+fU6Ke1T9K9BdO4YpPFiDao78bCCn7Ow1M41+AXY1MoRviWNFDG6KW
         UfguRMFqJ5OG0osYGjHGntBOokmPVGRDNTtM5dbpTclWjLv+cFr4pZz+mPYBXvZEzfQ1
         M2HN4WtFB4vHMPvxA1wwANEx3gpCo6czuDYRql+Vx8poHdccWpSD1IzU+385ByoGh8Tc
         5HdJJXavVGjPfPrnl3iP8e8jTVxuo2bbrYMmelO82Uq9QKXj2J4kRtE6lpLPYAKL+sNE
         lcwg==
X-Gm-Message-State: AOAM533dp3ksaMLUfflf167VZRX937gLEmkfmZ4cB6XHTnIL5wIVOXIA
        6fvvB4O79VMcmS8gG28KEo22FDhlykw=
X-Google-Smtp-Source: ABdhPJzg5dpDyByhCgQt9QN0xJKleBX2+1Aar0pTJuCgzRSyYjTATMV64zYzgxb/ey6BxBlLO3EMcQ==
X-Received: by 2002:a1c:4c14:: with SMTP id z20mr24228637wmf.82.1632045752064;
        Sun, 19 Sep 2021 03:02:32 -0700 (PDT)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id c17sm15005850wrn.54.2021.09.19.03.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Sep 2021 03:02:31 -0700 (PDT)
Subject: Re: [PATCHv3 00/12] nvme: In-band authentication support
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <47a839c3-1c8d-9ccf-3b3d-387862227c4f@grimberg.me>
 <0ab8d79a-6403-9177-319d-ad41dfa4c41b@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <e9b8ff1a-59dd-d959-3ef6-176bb8fbd279@grimberg.me>
Date:   Sun, 19 Sep 2021 13:02:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0ab8d79a-6403-9177-319d-ad41dfa4c41b@suse.de>
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
>>
>> Still no nvme-cli nor nvmetcli :(
> 
> Just send it (for libnvme and nvme-cli). Patch for nvmetcli to follow.

Hey Hannes,

I think that this series is getting into close-to-inclustion shape.
Please in your next respin:
1. Make sure to send nvme-cli and nvmetcli with the series
2. Collect Review tags

Thanks!
