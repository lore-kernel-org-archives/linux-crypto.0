Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8438C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Dec 2021 06:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbhLVGxQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Dec 2021 01:53:16 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:46098 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbhLVGxP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Dec 2021 01:53:15 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B9A56210E0;
        Wed, 22 Dec 2021 06:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640155994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mKstoHJVTIw83fYZgbjpZQNKfAMuH8FQXoKzValTw3g=;
        b=YzX9nPkeFHIckc8hpG9qtu36zOJLCcI15N3FMUe5stMGExykKfGm08J6+0XtuTZmbCZqmA
        Twx7ea3CxIYKjXPaQAO75Q3ugpgc4jlfmuvVmZlT/cEuXoyuP6rc8bFcSrn7aWdyLKOG4D
        NS104rDQ4i0BTjPpY+1Y3cAynLpt6r0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640155994;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mKstoHJVTIw83fYZgbjpZQNKfAMuH8FQXoKzValTw3g=;
        b=IDjsGy4/4o1KWsQwyhUX0mjESF9NRYzKIQhn4SPohpSJiGcVfr3Q8Np6d4ALtCACIp4H5M
        R5vy47ghZlmBpyDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 904AD13CD4;
        Wed, 22 Dec 2021 06:53:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id y0SAG1rLwmFGHAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 22 Dec 2021 06:53:14 +0000
Subject: Re: [PATCHv8 00/12] nvme: In-band authentication support
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Niolai Stange <nstange@suse.com>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211213080853.GA21223@lst.de>
 <9853d36a-036c-7f2b-5fb4-b3fb4bae473f@suse.de>
 <4328e4f0-9674-9362-4ed5-89ec7edba4a2@grimberg.me>
 <56f1ce1c-2272-bed2-fd6b-642854b612bb@suse.de>
 <483836f5-f850-6eac-8c38-3f03db3189ab@grimberg.me>
 <0c4613ff-ba30-c812-a6e9-1954d77b1d1b@suse.de>
 <ad9af172-4b7b-4206-feab-8ab54ba7cfe5@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e2ccd5bf-c13f-8660-c4c0-31a1053846ed@suse.de>
Date:   Wed, 22 Dec 2021 07:53:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ad9af172-4b7b-4206-feab-8ab54ba7cfe5@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/21/21 9:55 PM, Sagi Grimberg wrote:
> 
>>>>>> Question is how to continue from here; I can easily rebase my 
>>>>>> patchset
>>>>>> and send it relative to Nicolais patches. But then we'll be bound to
>>>>>> the acceptance of those patches, so I'm not quite sure if that's the
>>>>>> best way to proceed.
>>>>>
>>>>> Don't know if we have a choice here... What is the alternative you are
>>>>> proposing?
>>>>
>>>> That's the thing, I don't really have a good alternative, either.
>>>> It's just that I have so no idea about the crypto subsystem, and
>>>> consequently wouldn't know how long we need to wait...
>>>>
>>>> But yeah, Nicolais patchset is far superior to my attempts, so I'd be
>>>> happy to ditch my preliminary attempts there.
>>>
>>> Can we get a sense from the crypto folks to the state of Nicolais
>>> patchset?
>>
>> According to Nicolai things look good, rules seem to be that it'll be
>> accepted if it has positive reviews (which it has) and no-one objected
>> (which no-one did).
>> Other than that one would have to ask the maintainer.
>> Herbert?
> 
> Any updates on this?

Sigh.

Herbert suggested reworking the patch, and make ffdhe a separate 
algorithm (instead of having enums to specify the values for the 
existing DH algorithm).
Discussion is ongoing :-(

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
