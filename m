Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36916C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 07:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16C5560F70
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 07:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhI0H5f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Sep 2021 03:57:35 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:41959 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhI0H5f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Sep 2021 03:57:35 -0400
Received: by mail-ed1-f43.google.com with SMTP id s17so46925381edd.8
        for <linux-crypto@vger.kernel.org>; Mon, 27 Sep 2021 00:55:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CEfyV3bO4REPvQLYiyX7K5tvvC78lPlojdNMt9eiWt8=;
        b=qIW/bGunvtGpTgNXP/kFkiAxaXj9pcKI8jgI3uyFfzB7CIEfz+ZqpX29DGWAFmY96s
         qaXcPyjS6G7/Z/WZJur1moiUfoVDUrnTKv2WMbX6gfiM3stiD2jf7GI6WKBTaMZnIK6g
         AAE0H414HoBun1Dxyfs8FcktDJDSJTnzcS5zIJQfrnIxk8sSWbKLO4RRkSwxM8rMdPFI
         B9KHyyv0hJm+Oh4AR6gxN62bF7Gb7fWCSsLXy3KntbXZvMM9VA+qiB5nj8CPhUzABUjP
         l+4BGxUw6ZvNJvpmd/yFf1kVkB03OHMs1+Isfcdly0rI3KGj6zQzFgkD2zzJauZbKow7
         Ot6Q==
X-Gm-Message-State: AOAM531mrI0ddT3IiblwY1KbGQKp8u0fEiSxJuzpucpyDXFz7fQ4GxRY
        R55EgriTnpytuK4pb0Fs3iJ34AHK22w=
X-Google-Smtp-Source: ABdhPJx2hY5NCWmUhNrON4GRHig9d7ViASTdB3IxTNx61QXk86vkU8zOWZx9Y6CgaXdG0IPV0CyY5A==
X-Received: by 2002:a17:906:9401:: with SMTP id q1mr26000067ejx.313.1632729356447;
        Mon, 27 Sep 2021 00:55:56 -0700 (PDT)
Received: from [10.100.102.14] (109-186-240-23.bb.netvision.net.il. [109.186.240.23])
        by smtp.gmail.com with ESMTPSA id q18sm8370620ejc.84.2021.09.27.00.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 00:55:56 -0700 (PDT)
Subject: Re: [PATCH 10/12] nvmet: Implement basic In-Band Authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-11-hare@suse.de>
 <79742bd7-a41c-0abc-e7de-8d222b146d02@grimberg.me>
 <c7739610-6d0b-7740-c339-b35ca5ae34e2@suse.de>
 <a2596777-25b2-f633-4b00-18b1a319c5c2@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <32d8f860-9fdb-606c-62b7-ad89837d8e71@grimberg.me>
Date:   Mon, 27 Sep 2021 10:55:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a2596777-25b2-f633-4b00-18b1a319c5c2@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/27/21 10:17 AM, Hannes Reinecke wrote:
> On 9/27/21 8:40 AM, Hannes Reinecke wrote:
>> On 9/27/21 12:51 AM, Sagi Grimberg wrote:
>>>
>>>> +void nvmet_execute_auth_send(struct nvmet_req *req)
>>>> +{
>>>> +    struct nvmet_ctrl *ctrl = req->sq->ctrl;
>>>> +    struct nvmf_auth_dhchap_success2_data *data;
>>>> +    void *d;
>>>> +    u32 tl;
>>>> +    u16 status = 0;
>>>> +
>>>> +    if (req->cmd->auth_send.secp != 
>>>> NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER) {
>>>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>>>> +        req->error_loc =
>>>> +            offsetof(struct nvmf_auth_send_command, secp);
>>>> +        goto done;
>>>> +    }
>>>> +    if (req->cmd->auth_send.spsp0 != 0x01) {
>>>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>>>> +        req->error_loc =
>>>> +            offsetof(struct nvmf_auth_send_command, spsp0);
>>>> +        goto done;
>>>> +    }
>>>> +    if (req->cmd->auth_send.spsp1 != 0x01) {
>>>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>>>> +        req->error_loc =
>>>> +            offsetof(struct nvmf_auth_send_command, spsp1);
>>>> +        goto done;
>>>> +    }
>>>> +    tl = le32_to_cpu(req->cmd->auth_send.tl);
>>>> +    if (!tl) {
>>>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>>>> +        req->error_loc =
>>>> +            offsetof(struct nvmf_auth_send_command, tl);
>>>> +        goto done;
>>>> +    }
>>>> +    if (!nvmet_check_transfer_len(req, tl)) {
>>>> +        pr_debug("%s: transfer length mismatch (%u)\n", __func__, tl);
>>>> +        return;
>>>> +    }
>>>> +
>>>> +    d = kmalloc(tl, GFP_KERNEL);
>>>> +    if (!d) {
>>>> +        status = NVME_SC_INTERNAL;
>>>> +        goto done;
>>>> +    }
>>>> +
>>>> +    status = nvmet_copy_from_sgl(req, 0, d, tl);
>>>> +    if (status) {
>>>> +        kfree(d);
>>>> +        goto done;
>>>> +    }
>>>> +
>>>> +    data = d;
>>>> +    pr_debug("%s: ctrl %d qid %d type %d id %d step %x\n", __func__,
>>>> +         ctrl->cntlid, req->sq->qid, data->auth_type, data->auth_id,
>>>> +         req->sq->dhchap_step);
>>>> +    if (data->auth_type != NVME_AUTH_COMMON_MESSAGES &&
>>>> +        data->auth_type != NVME_AUTH_DHCHAP_MESSAGES)
>>>> +        goto done_failure1;
>>>> +    if (data->auth_type == NVME_AUTH_COMMON_MESSAGES) {
>>>> +        if (data->auth_id == NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE) {
>>>> +            /* Restart negotiation */
>>>> +            pr_debug("%s: ctrl %d qid %d reset negotiation\n", 
>>>> __func__,
>>>> +                 ctrl->cntlid, req->sq->qid);
>>>
>>> This is the point where you need to reset also auth config as this may
>>> have changed and the host will not create a new controller but rather
>>> re-authenticate on the existing controller.
>>>
>>> i.e.
>>>
>>> +                       if (!req->sq->qid) {
>>> +                               nvmet_destroy_auth(ctrl);
>>> +                               if (nvmet_setup_auth(ctrl) < 0) {
>>> +                                       pr_err("Failed to setup 
>>> re-authentication\n");
>>> +                                       goto done_failure1;
>>> +                               }
>>> +                       }
>>>
>>>
>>>
>>
>> Not sure. We have two paths how re-authentication can be triggered.
>> The one is from the host, which sends a 'negotiate' command to the 
>> controller (ie this path).  Then nothing on the controller has 
>> changed, and we just need to ensure that we restart negotiation.
>> IE we should _not_ reset the authentication (as that would also remove 
>> the controller keys, which haven't changed). We should just ensure 
>> that all ephemeral data is regenerated. But that should be handled 
>> in-line, and I _think_ I have covered all of that.
>> The other path to trigger re-authentication is when changing values on 
>> the controller via configfs. Then sure we need to reset the controller 
>> data, and trigger reauthentication.
>> And there I do agree, that path isn't fully implemented / tested.
>> But should be started whenever the configfs values change.
>>
> Actually, having re-read the spec I'm not sure if the second path is 
> correct.
> As per spec only the _host_ can trigger re-authentication. There is no 
> provision for the controller to trigger re-authentication, and given 
> that re-auth is a soft-state anyway (ie the current authentication stays 
> valid until re-auth enters a final state) I _think_ we should be good 
> with the current implementation, where we can change the controller keys
> via configfs, but they will only become active once the host triggers
> re-authentication.

Agree, so the proposed addition is good with you?

> And indeed, that's the only way how it could work, otherwise it'll be 
> tricky to change keys in a running connection.
> If we were to force renegotiation when changing controller keys we would 
> immediately fail the connection, as we cannot guarantee that controller 
> _and_ host keys are changed at the same time.

Exactly, changing the hostkey in the controller must not trigger
re-auth, the host will remain connected and operational as it
authenticated before. As the host re-authenticates or reconnect
it needs to authenticate against the new key.
