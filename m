Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92081C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Sep 2021 07:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 743DC61163
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Sep 2021 07:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbhINHH3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Sep 2021 03:07:29 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:38612 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240490AbhINHH2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Sep 2021 03:07:28 -0400
Received: by mail-wr1-f51.google.com with SMTP id u16so18476983wrn.5
        for <linux-crypto@vger.kernel.org>; Tue, 14 Sep 2021 00:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ASSw//9AOWQ7NN/5WP5M7iKdi8iqcYmLot2EnNzllx0=;
        b=MIQZOp0SYnbs2EJzEFEsx1y/kW8BrXBnbIzTxEy50vREtDOc3o0DFhElq+/4cv3xTV
         2puXWHaXrae9A+9OrxLaM2ZvOOQyia2CT5FlZFThWO2/dqnhqgwUfZ699tpPVcNQBz7u
         Ib3QNiATNL6XERtEfW9j4C2154+9M8oxFkMzGce1rSlLMG2twaQoVWhD6s+ztBfidkVu
         otsd117NWSwOBKXBqWD5hMSfkDoG/Hxe7ZXEoj7yMqmnQ2JxPupkhMGumKLftEey7biC
         danUf6RcSz2PnkMD6Ek9tHB01NrYPBAIDDvkR26gX2i+6AAWyLXv4j28NMsIyPdmShCL
         y4hg==
X-Gm-Message-State: AOAM532X5uvD6Jlhox/ZvU2t9U9tlwsTPPh4ZXJ/McCMpRwmZudxXPXR
        j7q8G6zJCCmk+TqeSwS4HoaiZBYCpTM=
X-Google-Smtp-Source: ABdhPJw5mBypqnu0KyfJVJ+5gN7bFeUoaS6ohgXx4qavWkVs1uUllKQWLn+LnGJbRAdeIGDnqnycIg==
X-Received: by 2002:adf:eb4f:: with SMTP id u15mr16598752wrn.352.1631603170982;
        Tue, 14 Sep 2021 00:06:10 -0700 (PDT)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id n66sm239555wmn.2.2021.09.14.00.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 00:06:10 -0700 (PDT)
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-8-hare@suse.de>
 <99cbf790-c276-b3d0-6140-1f5bfa8665eb@grimberg.me>
 <8bff9a88-a5d4-d7bb-8ce9-81d30438bfbb@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <6eeae78a-a4eb-bb18-6cad-273e1a21050a@grimberg.me>
Date:   Tue, 14 Sep 2021 10:06:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8bff9a88-a5d4-d7bb-8ce9-81d30438bfbb@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>>> @@ -361,11 +366,13 @@ static inline void nvme_end_req(struct request
>>> *req)
>>>      void nvme_complete_rq(struct request *req)
>>>    {
>>> +    struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
>>> +
>>>        trace_nvme_complete_rq(req);
>>>        nvme_cleanup_cmd(req);
>>>    -    if (nvme_req(req)->ctrl->kas)
>>> -        nvme_req(req)->ctrl->comp_seen = true;
>>> +    if (ctrl->kas)
>>> +        ctrl->comp_seen = true;
>>>          switch (nvme_decide_disposition(req)) {
>>>        case COMPLETE:
>>> @@ -377,6 +384,15 @@ void nvme_complete_rq(struct request *req)
>>>        case FAILOVER:
>>>            nvme_failover_req(req);
>>>            return;
>>> +    case AUTHENTICATE:
>>> +#ifdef CONFIG_NVME_AUTH
>>> +        if (nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
>>> +            queue_work(nvme_wq, &ctrl->dhchap_auth_work);
>>
>> Why is the state change here and not in nvme_dhchap_auth_work?
>>
> Because switching to 'resetting' is an easy way to synchronize with the
> admin queue.

Maybe fold this into nvme_authenticate_ctrl? in case someone adds/moves
this in the future and forgets the ctrl state serialization?
