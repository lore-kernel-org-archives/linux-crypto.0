Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BF4C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 07:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5506B610E8
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 07:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhI0Hyf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Sep 2021 03:54:35 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:36824 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhI0Hyf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Sep 2021 03:54:35 -0400
Received: by mail-ed1-f42.google.com with SMTP id y35so14412318ede.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Sep 2021 00:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c4vg9lCY/kiWphc1Nxc6GTJqMY/xHxF59vvytmu19J4=;
        b=dwFk9k2oRef7SZE+Mm6Ta+EWoe/vkypGY05TCt7DLJkjlWi8VB8eo4WkWs2aQQ6dE4
         w6lb2X6/Zv22kMp8UFhjoZoSHHmQ5STmqBFb7JMMmAA6ai3HCygOHru6CoYoyAwnMnPx
         Sl3QoDNrxE7TIgkWO6qtL/M49fxI7Bp6i/Ec1p38GH2Z1Fhx0hJ5KmbYHN8N6QEaMnOE
         WlLkc1zVm6uGLlgnz7DrQJgcrm6ezxEDwcQWrgtZJHn7WIoi2LFD5tWOmm8+0bH9Yzcp
         7i2IFlmBk6HfABW2FjqKZkSApyANkzP1eSJVX/QsV3cDAVTS/7cobyUp2AdwytM8uKqv
         +B0g==
X-Gm-Message-State: AOAM533xP9+m3qBN048c/JzMOfj8rlTbK9ROEOoeR3c2lAobpZVRNt0y
        ltmUgPcAdtY+F9zKoRw/h/IEgsB6J3w=
X-Google-Smtp-Source: ABdhPJztf1I2x0WrbSWOTttQF+vDEjpXayD6Aht7FksaP5YIBlq1c0SS5LEolznJ7mRR5XqipnEYsQ==
X-Received: by 2002:a17:906:3699:: with SMTP id a25mr25522459ejc.452.1632729176684;
        Mon, 27 Sep 2021 00:52:56 -0700 (PDT)
Received: from [10.100.102.14] (109-186-240-23.bb.netvision.net.il. [109.186.240.23])
        by smtp.gmail.com with ESMTPSA id 19sm8283726ejw.31.2021.09.27.00.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 00:52:56 -0700 (PDT)
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-8-hare@suse.de>
 <22a5f9bf-5fbc-a0d3-b188-c67706a77600@grimberg.me>
 <e8e4a164-5803-5110-ab48-751def26b976@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <77845fe5-79b7-62fd-95ae-ae95f3744663@grimberg.me>
Date:   Mon, 27 Sep 2021 10:52:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e8e4a164-5803-5110-ab48-751def26b976@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> Actually, after recent discussions on the fmds group there shouldn't be 
> a requirement to stop the queues, so I'll be dropping the stop/start 
> queue things.
> (And the change in controller state, too, as it isn't required, either).

Hmm, ok.
