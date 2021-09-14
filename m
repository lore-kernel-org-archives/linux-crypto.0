Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E43C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Sep 2021 07:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA4B610A6
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Sep 2021 07:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240614AbhINHVH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Sep 2021 03:21:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46518 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbhINHVG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Sep 2021 03:21:06 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 449462003A;
        Tue, 14 Sep 2021 07:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631603989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qa6FB0uYQ2RYdrHZTs6vTxf+pqm8aDnKtUrZl6NWqYA=;
        b=rtxMine2n/wlRj205bVSePa/irX65O6ydD/Qrz5clC1jOBY3u98CAXCI/dBImd5sqD6pnj
        oM3lyZ99/sBr8Vrh8joXg7kNToYGACEt6c5yxbxeA027GnnBXLKxHj/yTJkxZRCHrDrnDq
        1+HF17pH+zMKST9SXNxlrq0GxTJgfIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631603989;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qa6FB0uYQ2RYdrHZTs6vTxf+pqm8aDnKtUrZl6NWqYA=;
        b=kaKLN+oGmQWiFnK0soeTOuWWuNA/16eyNkswJsQLXshLpGRk5QkxZ0R0muFhzLRbfH2eg/
        JTqzn+aVsyU/qQCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2503B13E55;
        Tue, 14 Sep 2021 07:19:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NsIJBxVNQGEqfQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Sep 2021 07:19:49 +0000
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-8-hare@suse.de>
 <99cbf790-c276-b3d0-6140-1f5bfa8665eb@grimberg.me>
 <8bff9a88-a5d4-d7bb-8ce9-81d30438bfbb@suse.de>
 <6eeae78a-a4eb-bb18-6cad-273e1a21050a@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7ea0e477-be74-80e4-a89b-9e14f5395011@suse.de>
Date:   Tue, 14 Sep 2021 09:19:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <6eeae78a-a4eb-bb18-6cad-273e1a21050a@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/14/21 9:06 AM, Sagi Grimberg wrote:
>>>> @@ -361,11 +366,13 @@ static inline void nvme_end_req(struct request
>>>> *req)
>>>>      void nvme_complete_rq(struct request *req)
>>>>    {
>>>> +    struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
>>>> +
>>>>        trace_nvme_complete_rq(req);
>>>>        nvme_cleanup_cmd(req);
>>>>    -    if (nvme_req(req)->ctrl->kas)
>>>> -        nvme_req(req)->ctrl->comp_seen = true;
>>>> +    if (ctrl->kas)
>>>> +        ctrl->comp_seen = true;
>>>>          switch (nvme_decide_disposition(req)) {
>>>>        case COMPLETE:
>>>> @@ -377,6 +384,15 @@ void nvme_complete_rq(struct request *req)
>>>>        case FAILOVER:
>>>>            nvme_failover_req(req);
>>>>            return;
>>>> +    case AUTHENTICATE:
>>>> +#ifdef CONFIG_NVME_AUTH
>>>> +        if (nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
>>>> +            queue_work(nvme_wq, &ctrl->dhchap_auth_work);
>>>
>>> Why is the state change here and not in nvme_dhchap_auth_work?
>>>
>> Because switching to 'resetting' is an easy way to synchronize with the
>> admin queue.
> 
> Maybe fold this into nvme_authenticate_ctrl? in case someone adds/moves
> this in the future and forgets the ctrl state serialization?

Yeah; not a bad idea. Will be looking into it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
