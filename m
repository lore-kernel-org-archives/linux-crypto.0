Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EEBC433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Nov 2021 13:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9071B61183
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Nov 2021 13:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbhKNNr0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Nov 2021 08:47:26 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:43398 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbhKNNrP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Nov 2021 08:47:15 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 144431FD32;
        Sun, 14 Nov 2021 13:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636897453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QrHkmKGbYmITS8a/7t0Ro+g4X5QH+zs9pEanB1HcmCo=;
        b=0MJxIiHPCMvbt1famOwEyW+yt36CZl73NYH+t2WBV7w/oYqga8fBhZ6X6T6gQ7Lm3WMOI1
        1s8ulD62q1WSEHVL1cH8H5Ack6JQFGBojjY/l/kjQrNzu2OY22NofEocW5zPkmiuSrijkF
        37ZrcLT5LyHBYvABBUeyAKkp8mPO4HI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636897453;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QrHkmKGbYmITS8a/7t0Ro+g4X5QH+zs9pEanB1HcmCo=;
        b=EEe8fdqAiAHMunG7Pbtrw9fKpEoJoWZNCYGSZcA0M1r6ybmRPTtpAR5Ad/BcjHghjOZ4BK
        MkbxqcXo/7ZaWbCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C42411348A;
        Sun, 14 Nov 2021 13:44:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CjotLawSkWHqVgAAMHmgww
        (envelope-from <hare@suse.de>); Sun, 14 Nov 2021 13:44:12 +0000
Subject: Re: [PATCHv5 00/12] nvme: In-band authentication support
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211112125928.97318-1-hare@suse.de>
 <74db7c77-7cbf-4bc9-1c80-e7c42acaea64@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f67ca46e-f421-33f7-da8b-ff6e47acf8c2@suse.de>
Date:   Sun, 14 Nov 2021 14:44:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <74db7c77-7cbf-4bc9-1c80-e7c42acaea64@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/14/21 11:40 AM, Sagi Grimberg wrote:
> 
> 
> On 11/12/21 2:59 PM, Hannes Reinecke wrote:
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
>>
>> Changes to v4:
>> - Validate against blktest suite
> 
> Nice! thanks hannes, this is going to be very useful moving
> forward.
> 
Oh, definitely. The number of issue these tests found...

>> - Fixup base64 decoding
> 
> What was fixed up there?
> 
The padding character '=' wasn't handled correctly on decoding (the 
character itself was skipped, by the 'bits' value wasn't increased, 
leading to a spurious error in decoding an any key longer than 32 bit 
not being accepted.

>> - Transform secret with correct hmac algorithm
> 
> Is that what I reported last time? Can you perhaps
> point me to the exact patch that fixes this?

Well, no, not really; the patch itself got squashed in the main patches.
But problem here was that the key transformation from section 8.13.5.7 
had been using the hash algorithm from the initial challenge, not the 
one specified in the key itself.
This lead to decoding errors when using a key with a different length 
than the hash algorithm.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
