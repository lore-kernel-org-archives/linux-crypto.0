Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE63C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 05:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EDF1610A6
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 05:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244888AbhIQFkv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Sep 2021 01:40:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43614 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhIQFku (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Sep 2021 01:40:50 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AA6EF223D6;
        Fri, 17 Sep 2021 05:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631857167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zwpvkk7fUN97D6tfIfLdNxYQn4+G07i9NKDiltPKe9I=;
        b=ucgVEW5ZnU4o6ESHSC5QHhqElCBH6fPmtJjcUKBerAWGTfW+uvPTiacJbKUbqFOtzhHfgC
        4W7UKbw2oihiFGp8jXmDZO0PZ9dkE1UPrQzrP+7YBDedPE/sWDKrtyU9piLYcWebyutmBA
        U7zyfxFmH92l7wVg9NbbzS/5rZNC838=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631857167;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zwpvkk7fUN97D6tfIfLdNxYQn4+G07i9NKDiltPKe9I=;
        b=bGYgikJf626dVI5r9OkLInm6EJ5OeMLufAYtCSY8vPGeH8tQF/VJEI+XoOtpUyRxvre3Ir
        TjPpwSRTw/GbshBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5928113A67;
        Fri, 17 Sep 2021 05:39:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GUjSEA8qRGGNZwAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 17 Sep 2021 05:39:27 +0000
Subject: Re: [PATCH 05/12] nvme: add definitions for NVMe In-Band
 authentication
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-6-hare@suse.de>
 <01a48055-c292-5383-efff-6d1ef86d404f@nvidia.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <779cc530-534e-8b2c-f82d-3675ab685673@suse.de>
Date:   Fri, 17 Sep 2021 07:39:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <01a48055-c292-5383-efff-6d1ef86d404f@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/16/21 7:04 PM, Chaitanya Kulkarni wrote:
> On 9/9/21 11:43 PM, Hannes Reinecke wrote:
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>    include/linux/nvme.h | 186 ++++++++++++++++++++++++++++++++++++++++++-
>>    1 file changed, 185 insertions(+), 1 deletion(-)
>>
> 
> Probably worth mentioning a TP name here so we can refer later,
> instead of empty commit message ?
> 
Had been thinking about it, but then decided against it. Once the TPAR
is folded into the main spec it's getting really hard to figure out 
exactly what individual TPARs were referring to, so I prefer to stick
with 'In-Band authentication' instead of the TPAR number.
But I can add that to the commit message, sure.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
