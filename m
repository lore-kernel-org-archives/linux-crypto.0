Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E372C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 05:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376B26115C
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 05:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhI0FuC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Sep 2021 01:50:02 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37498 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbhI0FuC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Sep 2021 01:50:02 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 094051FF4E;
        Mon, 27 Sep 2021 05:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632721704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8sEji05pcYac50uS2f9y7kF2zF7HbkHKk3CSQyhuxZQ=;
        b=PhRKPpt+m45+7rn67w6BUWcohnZw2gj/oeIESbP451WVXTtkuCf5/Kd0K6QzDcbW6QnUjY
        XYmf3LS04HJ+92J4N5p78TMRPNe/EI0UoyGBDTLdLpYsUob/Ms00GWs8r/TddK9jOwhq/B
        8OPRZnCLYZnrgZLEmIq62xg2jITBA1E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632721704;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8sEji05pcYac50uS2f9y7kF2zF7HbkHKk3CSQyhuxZQ=;
        b=hiWsxEDmCqQvtCGJcPZ4En5yglp3ya3kw4EBp4xLvVir6ZLeHSmK/RbWWWsKAZt5NnI4no
        kyoHxviCWUS8maDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D9C8813A1E;
        Mon, 27 Sep 2021 05:48:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1r04MCdbUWFQCAAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 27 Sep 2021 05:48:23 +0000
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-8-hare@suse.de>
 <745c58b2-e508-25c0-f094-8d24af0631ed@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0a7e7f2a-3f62-96c3-3b04-549afb8343ff@suse.de>
Date:   Mon, 27 Sep 2021 07:48:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <745c58b2-e508-25c0-f094-8d24af0631ed@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/27/21 12:53 AM, Sagi Grimberg wrote:
> 
>> +/* Assumes that the controller is in state RESETTING */
>> +static void nvme_dhchap_auth_work(struct work_struct *work)
>> +{
>> +    struct nvme_ctrl *ctrl =
>> +        container_of(work, struct nvme_ctrl, dhchap_auth_work);
>> +    int ret, q;
>> +
> 
> Here I would print a single:
>      dev_info(ctrl->device, "re-authenticating controller");
> 
> This is instead of all the queue re-authentication prints that
> should be dev_dbg.
> 
> Let's avoid doing the per-queue print...

Hmm. Actually the spec allows to use different keys per queue, even 
though our implementation doesn't. And fmds has struggled to come up 
with a sane usecase for that.
But yes, okay, will be updating it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
