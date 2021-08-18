Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8B7C4338F
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 05:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB5261076
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 05:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbhHRFpI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Aug 2021 01:45:08 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50848 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbhHRFpH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Aug 2021 01:45:07 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F1B921FF80;
        Wed, 18 Aug 2021 05:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629265471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7gt9xQcpg8cLompgwAs2sgaTiNyRhomg3wa5s6AJxE=;
        b=GwJqqya4wErklpUfsHhkvceUHxU7++zXRRxL1ZA2tPLDfzCMF+E2KXG3ftzPT01KZL3t0o
        j/PQx+pkhVSHClamIyhh0/dVCtBOivIv/qn9gB/TU9xckEgKlF0RxeL7tl28HETYm1oSOA
        x615NaF4YbY/6cWJhs1fmGMznR/8D3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629265471;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7gt9xQcpg8cLompgwAs2sgaTiNyRhomg3wa5s6AJxE=;
        b=zKV4yycOMmovdQAhULrtF00NIo0gAUBBWL+J9SR27LszChgC1urhm3C1hlkMTV+ATONW8k
        E0xGU0Re4SI724AQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id CC28C13357;
        Wed, 18 Aug 2021 05:44:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 1m86MD+eHGEqagAAGKfGzw
        (envelope-from <hare@suse.de>); Wed, 18 Aug 2021 05:44:31 +0000
Subject: Re: [PATCHv2 00/13] nvme: In-band authentication support
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210810124230.12161-1-hare@suse.de>
 <5a69187b-cfb1-d09a-87e2-8435e27612a7@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <dbf2ca1f-32f6-2aff-da08-d3fd2f977fa5@suse.de>
Date:   Wed, 18 Aug 2021 07:44:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <5a69187b-cfb1-d09a-87e2-8435e27612a7@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/17/21 11:21 PM, Sagi Grimberg wrote:
> 
>> Hi all,
>>
>> recent updates to the NVMe spec have added definitions for in-band
>> authentication, and seeing that it provides some real benefit
>> especially for NVMe-TCP here's an attempt to implement it.
>>
>> Tricky bit here is that the specification orients itself on TLS 1.3,
>> but supports only the FFDHE groups. Which of course the kernel doesn't
>> support. I've been able to come up with a patch for this, but as this
>> is my first attempt to fix anything in the crypto area I would invite
>> people more familiar with these matters to have a look.
>>
>> Also note that this is just for in-band authentication. Secure
>> concatenation (ie starting TLS with the negotiated parameters) is not
>> implemented; one would need to update the kernel TLS implementation
>> for this, which at this time is beyond scope.
>>
>> As usual, comments and reviews are welcome.
> 
> Hey Hannes,
> 
> First, can you also send the nvme-cli/nvmetcli bits as well?
> 
Yes, will be done with the next round.
It first required a larger update to libnvme/nvme-cli to get everything 
in order :-)

> Second, one thing that is not clear to me here is how this
> works with the discovery log page.
> 
> If the user issues a discovery log page to establish connections
> to the controllers entries, where it picks the appropriate
> secret?
> 
> In other words, when the user runs connect-all, how does it handle
> the secrets based on the content of the discovery log-page?

With the latest nvme-cli update I've implemented a json configuration, 
which allows to store configuration on a per-controller basis.
This will be updated to hold the dhchap secrets, and we should be able 
to specify individual secrets for each controller.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
