Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7A4C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 14:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhKVOeX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 09:34:23 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:33460 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhKVOeW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 09:34:22 -0500
Received: by mail-wr1-f47.google.com with SMTP id d24so33155896wra.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 06:31:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NOpI29WK93kPIoQN+4npStzaJDQP3VzNREpVcUJTXwI=;
        b=745E9EfxCBwJRmuBxD1n0e2nLvizwcNlfHwEp6Jkm/QH76zivISuF27/wNPIDIZqcL
         8X17PI9dFhU12ytnSgRZq6fki1S/i4576iciASnjAzTTO390RRTufMIUn0KeJqZkGFdo
         Vz7kv16KmDQ9GgWNtP+w5yeknVLQcr9vpVNCLnb1D1MWr3bKWaZPHqOxvKDkFS3YTLiw
         ohEuJ1fvr2ZM/+St9OCxdvXo5cPZ0vpzstoau9LksDAn98Nwk9/wkQD7ZfSU0kT1FHGH
         qPj1DZwY/slGOjBprDohcz++rBYIto9asWxCW/d1djloaO14GOwZagHAw9OMihJF4lhR
         7YrQ==
X-Gm-Message-State: AOAM532D+PHxbBHQF75r1ORHwTven1RlJ+n9CgD9FHG6uWroJPLsl/kn
        dYam6tXW0zXx32CSTtUC18iu49+LUHM=
X-Google-Smtp-Source: ABdhPJx3q5pqRSYEpp0EUSXAYEjgOp7ZwMBhmfiocfElS4LJr62IrLXfEQybOL8EzHGD3G34nBAdbw==
X-Received: by 2002:adf:d1cb:: with SMTP id b11mr40733574wrd.33.1637591475370;
        Mon, 22 Nov 2021 06:31:15 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id g6sm12354677wmq.36.2021.11.22.06.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 06:31:14 -0800 (PST)
Subject: Re: [PATCH 10/12] nvmet: Implement basic In-Band Authentication
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
 <20211122074727.25988-11-hare@suse.de>
 <762ce404-9035-30ca-078d-eb0b36223e4c@grimberg.me>
 <313b19d2-ea54-ce1c-f9cb-3f1fb6743787@suse.de>
 <891fe077-40d3-5bad-52fb-f0ee6f6107b6@grimberg.me>
 <f7011868-4542-bd09-6d44-3aaa192a9212@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <27432703-8e83-10c0-c428-090e6ec4b9af@grimberg.me>
Date:   Mon, 22 Nov 2021 16:31:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f7011868-4542-bd09-6d44-3aaa192a9212@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>>>>> +    if (data->auth_type == NVME_AUTH_COMMON_MESSAGES) {
>>>>> +        if (data->auth_id == NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE) {
>>>>> +            /* Restart negotiation */
>>>>> +            pr_debug("%s: ctrl %d qid %d reset negotiation\n",
>>>>> __func__,
>>>>> +                 ctrl->cntlid, req->sq->qid);
>>>>> +            if (!req->sq->qid) {
>>>>> +                status = nvmet_setup_auth(ctrl);
>>>>
>>>> Aren't you leaking memory here?
>>>
>>> I've checked, and I _think_ everything is in order.
>>> Any particular concerns?
>>> ( 'd' is free at 'done_kfree', and we never exit without going through
>>> it AFAICS).
>>> Have I missed something?
>>
>> You are calling nvmet_setup_auth for re-authentication, who is calling
>> nvmet_destroy_auth to free the controller auth stuff?
>>
>> Don't you need something like:
>> -- 
>>          if (!req->sq->qid) {
>>              nvmet_destroy_auth(ctrl);
>>              status = nvmet_setup_auth(ctrl);
>>              ...
>>          }
>> -- 
> 
> nvme_setup_auth() should be re-entrant, ie it'll free old and reallocate
> new keys as required. Hence no need to call nvmet_destroy_auth().
> At least that's the plan.

OK, I see.

> Always possible that I messed up things somewhere.

Worth checking with kmemleak but it looks ok to me.
