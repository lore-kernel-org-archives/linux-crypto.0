Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9334C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 13:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbhKVNYM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:24:12 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60920 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhKVNYL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 08:24:11 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2111C1FD26;
        Mon, 22 Nov 2021 13:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637587264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgbQA4VO8Brp7kqvGpioMnLbrB6/onwWX4pk06EK7Ws=;
        b=O/yVR1ocsSC+WMXRd2ios8z4zqPD+lN0sTjx9WmcgqxFLdnxeEoI1ekckQ9Y4ZMWK+MhHp
        zHhsYkvWZnfB6Wz5eRx61Ihf4gckZOzqp6Bi/2d5x+39Rc6Lrpy/qani15RYc+oOw/G/FI
        UiyVndizjjYmBWPJP1wLuopvItHOtPo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637587264;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgbQA4VO8Brp7kqvGpioMnLbrB6/onwWX4pk06EK7Ws=;
        b=swtzo2AHVGq/M+pQxc4oAOyfqiJAqObW2NfuXC23XRGRMtO4ux2Kt3mk6pdUE5dym99NgR
        LkOLLesXzpiWtXDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5A8DC13C97;
        Mon, 22 Nov 2021 13:21:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ItpiFT+Zm2ECUgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 22 Nov 2021 13:21:03 +0000
Subject: Re: [PATCH 10/12] nvmet: Implement basic In-Band Authentication
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
 <20211122074727.25988-11-hare@suse.de>
 <762ce404-9035-30ca-078d-eb0b36223e4c@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <313b19d2-ea54-ce1c-f9cb-3f1fb6743787@suse.de>
Date:   Mon, 22 Nov 2021 14:21:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <762ce404-9035-30ca-078d-eb0b36223e4c@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/22/21 12:59 PM, Sagi Grimberg wrote:
> 
>> +void nvmet_execute_auth_send(struct nvmet_req *req)
>> +{
>> +    struct nvmet_ctrl *ctrl = req->sq->ctrl;
>> +    struct nvmf_auth_dhchap_success2_data *data;
>> +    void *d;
>> +    u32 tl;
>> +    u16 status = 0;
>> +
>> +    if (req->cmd->auth_send.secp !=
>> NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER) {
>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +        req->error_loc =
>> +            offsetof(struct nvmf_auth_send_command, secp);
>> +        goto done;
>> +    }
>> +    if (req->cmd->auth_send.spsp0 != 0x01) {
>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +        req->error_loc =
>> +            offsetof(struct nvmf_auth_send_command, spsp0);
>> +        goto done;
>> +    }
>> +    if (req->cmd->auth_send.spsp1 != 0x01) {
>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +        req->error_loc =
>> +            offsetof(struct nvmf_auth_send_command, spsp1);
>> +        goto done;
>> +    }
>> +    tl = le32_to_cpu(req->cmd->auth_send.tl);
>> +    if (!tl) {
>> +        status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +        req->error_loc =
>> +            offsetof(struct nvmf_auth_send_command, tl);
>> +        goto done;
>> +    }
>> +    if (!nvmet_check_transfer_len(req, tl)) {
>> +        pr_debug("%s: transfer length mismatch (%u)\n", __func__, tl);
>> +        return;
>> +    }
>> +
>> +    d = kmalloc(tl, GFP_KERNEL);
>> +    if (!d) {
>> +        status = NVME_SC_INTERNAL;
>> +        goto done;
>> +    }
>> +
>> +    status = nvmet_copy_from_sgl(req, 0, d, tl);
>> +    if (status) {
>> +        kfree(d);
>> +        goto done;
>> +    }
>> +
>> +    data = d;
>> +    pr_debug("%s: ctrl %d qid %d type %d id %d step %x\n", __func__,
>> +         ctrl->cntlid, req->sq->qid, data->auth_type, data->auth_id,
>> +         req->sq->dhchap_step);
>> +    if (data->auth_type != NVME_AUTH_COMMON_MESSAGES &&
>> +        data->auth_type != NVME_AUTH_DHCHAP_MESSAGES)
>> +        goto done_failure1;
>> +    if (data->auth_type == NVME_AUTH_COMMON_MESSAGES) {
>> +        if (data->auth_id == NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE) {
>> +            /* Restart negotiation */
>> +            pr_debug("%s: ctrl %d qid %d reset negotiation\n", __func__,
>> +                 ctrl->cntlid, req->sq->qid);
>> +            if (!req->sq->qid) {
>> +                status = nvmet_setup_auth(ctrl);
> 
> Aren't you leaking memory here?

I've checked, and I _think_ everything is in order.
Any particular concerns?
( 'd' is free at 'done_kfree', and we never exit without going through
it AFAICS).
Have I missed something?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
