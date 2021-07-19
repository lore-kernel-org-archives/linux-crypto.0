Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CEAC07E9D
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 11:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6FCC611ED
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 11:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbhGSKap (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 06:30:45 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41708 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbhGSKap (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 06:30:45 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 42D0620211;
        Mon, 19 Jul 2021 11:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626693084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ifLJS6gG3h3JfPSPBAaSbsZ8FktMPmEJAcxEtc8PggA=;
        b=FxodbbgtmOviT0rbr5nThGXSmfpNsFhhzGnh+34rmwUWvRWYZIwhC7Tf1cLeZAhcWITV/R
        S7rWEOU6YYWiFd8rdqhVcI/2jdVBcuRfWtFQvkwCg1Z14B+BEcMBP/rOZJ5hlV5wSB8NmC
        TbG/h7jaWHG7e6xUNIGznOwncgNkfDI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626693084;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ifLJS6gG3h3JfPSPBAaSbsZ8FktMPmEJAcxEtc8PggA=;
        b=Ry4KuHfjsKJoas5R0+5IIHHudRg08K4HqARIG23oWozAgirg+qjJNbMANujAW4CK1EXbBW
        y0Z6jGGQdiKahrDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3338013CDE;
        Mon, 19 Jul 2021 11:11:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Af0tDNxd9WATSgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 19 Jul 2021 11:11:24 +0000
Subject: Re: [RFC PATCH 00/11] nvme: In-band authentication support
To:     Simo Sorce <simo@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <fce7efe2a5f1047e9f4ab93eedf5ace1946d308c.camel@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <310097fc-03a9-dc13-6615-2715d59260a2@suse.de>
Date:   Mon, 19 Jul 2021 13:11:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fce7efe2a5f1047e9f4ab93eedf5ace1946d308c.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/21 12:02 PM, Simo Sorce wrote:
> On Fri, 2021-07-16 at 13:04 +0200, Hannes Reinecke wrote:
>> Hi all,
>>
>> recent updates to the NVMe spec have added definitions for in-band
>> authentication, and seeing that it provides some real benefit especially
>> for NVMe-TCP here's an attempt to implement it.
>>
>> Tricky bit here is that the specification orients itself on TLS 1.3,
>> but supports only the FFDHE groups. Which of course the kernel doesn't
>> support. I've been able to come up with a patch for this, but as this
>> is my first attempt to fix anything in the crypto area I would invite
>> people more familiar with these matters to have a look.
>>
>> Also note that this is just for in-band authentication. Secure concatenation
>> (ie starting TLS with the negotiated parameters) is not implemented; one would
>> need to update the kernel TLS implementation for this, which at this time is
>> beyond scope.
>>
>> As usual, comments and reviews are welcome.
> 
> Hi Hannes,
> could you please reference the specific standards that describe the
> NVMe authentication protocols?
> 

https://nvmexpress.org/wp-content/uploads/NVM-Express-Base-Specification-2_0-2021.06.02-Ratified-5.pdf

Section '8.13 NVMe-over-Fabrics In-band authentication'

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
