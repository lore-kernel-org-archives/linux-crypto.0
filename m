Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DE9C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 07:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80EB761041
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 07:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhI0H2F (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Sep 2021 03:28:05 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57394 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbhI0H2F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Sep 2021 03:28:05 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3990D20092;
        Mon, 27 Sep 2021 07:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632727587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mL4i4Gs+wKRW9H5FFq5ITwf4d7abfhTXN9PqX2OpPT4=;
        b=d/BUGuaCWN6LTrX0maJibNIZu/OmmqHxTj+psTgX8oJRjat4x+FjMSrmARfz2uGoy8mgmy
        yhg6VEJbXWz842E/hNABCVCW13KIxuitf03V8rOUVHlB17f+B9/3cmwRyAPS1ueNBWdWt0
        aI/EBjelss6VE31GpREIxfdcgE2ux54=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632727587;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mL4i4Gs+wKRW9H5FFq5ITwf4d7abfhTXN9PqX2OpPT4=;
        b=s3PpZt2qUW3FZiSKhINJNbZ1M2FRP9fFIgXR3myVaBIOC/+tU/ckv142la7l/tkx05TJ4/
        gYR1V3y0GBe+olCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1A84D13A1E;
        Mon, 27 Sep 2021 07:26:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ynDiBSNyUWEsLgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 27 Sep 2021 07:26:27 +0000
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-8-hare@suse.de>
 <22a5f9bf-5fbc-a0d3-b188-c67706a77600@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e8e4a164-5803-5110-ab48-751def26b976@suse.de>
Date:   Mon, 27 Sep 2021 09:26:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <22a5f9bf-5fbc-a0d3-b188-c67706a77600@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/27/21 12:04 AM, Sagi Grimberg wrote:
> 
>> +/* Assumes that the controller is in state RESETTING */
>> +static void nvme_dhchap_auth_work(struct work_struct *work)
>> +{
>> +    struct nvme_ctrl *ctrl =
>> +        container_of(work, struct nvme_ctrl, dhchap_auth_work);
>> +    int ret, q;
>> +
>> +    nvme_stop_queues(ctrl);
> 
>      blk_mq_quiesce_queue(ctrl->admin_q);
> 
>> +    /* Authenticate admin queue first */
>> +    ret = nvme_auth_negotiate(ctrl, NVME_QID_ANY);
>> +    if (ret) {
>> +        dev_warn(ctrl->device,
>> +             "qid 0: error %d setting up authentication\n", ret);
>> +        goto out;
>> +    }
>> +    ret = nvme_auth_wait(ctrl, NVME_QID_ANY);
>> +    if (ret) {
>> +        dev_warn(ctrl->device,
>> +             "qid 0: authentication failed\n");
>> +        goto out;
>> +    }
>> +    dev_info(ctrl->device, "qid 0: authenticated\n");
>> +
>> +    for (q = 1; q < ctrl->queue_count; q++) {
>> +        ret = nvme_auth_negotiate(ctrl, q);
>> +        if (ret) {
>> +            dev_warn(ctrl->device,
>> +                 "qid %d: error %d setting up authentication\n",
>> +                 q, ret);
>> +            goto out;
>> +        }
>> +    }
>> +out:
>> +    /*
>> +     * Failure is a soft-state; credentials remain valid until
>> +     * the controller terminates the connection.
>> +     */
>> +    if (nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
>> +        nvme_start_queues(ctrl);
>          blk_mq_unquiesce_queue(ctrl->admin_q);
> 
>> +}

Actually, after recent discussions on the fmds group there shouldn't be 
a requirement to stop the queues, so I'll be dropping the stop/start 
queue things.
(And the change in controller state, too, as it isn't required, either).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
