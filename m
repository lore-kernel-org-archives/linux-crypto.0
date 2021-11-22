Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC028C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 14:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbhKVODa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 09:03:30 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:41484 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239625AbhKVODX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 09:03:23 -0500
Received: by mail-wm1-f43.google.com with SMTP id f7-20020a1c1f07000000b0032ee11917ceso13709443wmf.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 06:00:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P3O+fD9w5JJOLz6WDLps0JCyPSQtsDkjmTzs6tjbSx0=;
        b=p+cfSqmWp/w+rRSqp3rHtMtv2hvr/CLRvRaGN+2kF+afX9sc0jGQbyb+5pAD17G0zV
         fzfNkunW9CeEjOTU4njIIzupazw5pi5WUcRmmVYJnDtDNUsPinUFQubpjAv39OIiucZV
         R1kaUAKGxr8rCshaeb/M4KHjLL+3tI0h+LqcPahyhMbK5UAcCkV9g+hmL5yZml68O22N
         V7hspU/JOvM59AeAvMFe+ilpqniQRYnSij9mpniwUCW5Nl8n0CKvDrkGr4xBo6FdPT1G
         K7lu7UT1N2iXKo0dT83Uxqtewy30xPbXxkWe9uwX5Ojs23UKQFnXrOiGoldnZ+PjtznK
         2grw==
X-Gm-Message-State: AOAM531WRNHnQ5Z3hl0+KJMdPU7IrMd40zznuIGp5r55uSioTxpABaS9
        YWxSwsYAaFi0IwEhdk0fH55IbKcE/hw=
X-Google-Smtp-Source: ABdhPJzZUCpqXdycf1RfqUNonaCY+6vCaMe0pQwfc5my7tic5qJhas+uT3YkP5pM9EYwT13CEZNA9Q==
X-Received: by 2002:a05:600c:3505:: with SMTP id h5mr29420683wmq.22.1637589615254;
        Mon, 22 Nov 2021 06:00:15 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id n4sm11102168wri.41.2021.11.22.06.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 06:00:14 -0800 (PST)
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
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <891fe077-40d3-5bad-52fb-f0ee6f6107b6@grimberg.me>
Date:   Mon, 22 Nov 2021 16:00:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <313b19d2-ea54-ce1c-f9cb-3f1fb6743787@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/22/21 3:21 PM, Hannes Reinecke wrote:
> On 11/22/21 12:59 PM, Sagi Grimberg wrote:
>>
>>> +void nvmet_execute_auth_send(struct nvmet_req *req)
>>> +{
>>> +    struct nvmet_ctrl *ctrl = req->sq->ctrl;
>>> +    struct nvmf_auth_dhchap_success2_data *data;
>>> +    void *d;
>>> +    u32 tl;
>>> +    u16 status = 0;
>>> +
>>> +    if (req->cmd->auth_send.secp !=
>>> NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER) {
>>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>>> +        req->error_loc =
>>> +            offsetof(struct nvmf_auth_send_command, secp);
>>> +        goto done;
>>> +    }
>>> +    if (req->cmd->auth_send.spsp0 != 0x01) {
>>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>>> +        req->error_loc =
>>> +            offsetof(struct nvmf_auth_send_command, spsp0);
>>> +        goto done;
>>> +    }
>>> +    if (req->cmd->auth_send.spsp1 != 0x01) {
>>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>>> +        req->error_loc =
>>> +            offsetof(struct nvmf_auth_send_command, spsp1);
>>> +        goto done;
>>> +    }
>>> +    tl = le32_to_cpu(req->cmd->auth_send.tl);
>>> +    if (!tl) {
>>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>>> +        req->error_loc =
>>> +            offsetof(struct nvmf_auth_send_command, tl);
>>> +        goto done;
>>> +    }
>>> +    if (!nvmet_check_transfer_len(req, tl)) {
>>> +        pr_debug("%s: transfer length mismatch (%u)\n", __func__, tl);
>>> +        return;
>>> +    }
>>> +
>>> +    d = kmalloc(tl, GFP_KERNEL);
>>> +    if (!d) {
>>> +        status = NVME_SC_INTERNAL;
>>> +        goto done;
>>> +    }
>>> +
>>> +    status = nvmet_copy_from_sgl(req, 0, d, tl);
>>> +    if (status) {
>>> +        kfree(d);
>>> +        goto done;
>>> +    }
>>> +
>>> +    data = d;
>>> +    pr_debug("%s: ctrl %d qid %d type %d id %d step %x\n", __func__,
>>> +         ctrl->cntlid, req->sq->qid, data->auth_type, data->auth_id,
>>> +         req->sq->dhchap_step);
>>> +    if (data->auth_type != NVME_AUTH_COMMON_MESSAGES &&
>>> +        data->auth_type != NVME_AUTH_DHCHAP_MESSAGES)
>>> +        goto done_failure1;
>>> +    if (data->auth_type == NVME_AUTH_COMMON_MESSAGES) {
>>> +        if (data->auth_id == NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE) {
>>> +            /* Restart negotiation */
>>> +            pr_debug("%s: ctrl %d qid %d reset negotiation\n", __func__,
>>> +                 ctrl->cntlid, req->sq->qid);
>>> +            if (!req->sq->qid) {
>>> +                status = nvmet_setup_auth(ctrl);
>>
>> Aren't you leaking memory here?
> 
> I've checked, and I _think_ everything is in order.
> Any particular concerns?
> ( 'd' is free at 'done_kfree', and we never exit without going through
> it AFAICS).
> Have I missed something?

You are calling nvmet_setup_auth for re-authentication, who is calling
nvmet_destroy_auth to free the controller auth stuff?

Don't you need something like:
--
		if (!req->sq->qid) {
			nvmet_destroy_auth(ctrl);
			status = nvmet_setup_auth(ctrl);
			...
		}
--
