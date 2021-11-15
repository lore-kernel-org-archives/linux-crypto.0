Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC87DC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 11:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9252961B39
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 11:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhKOLio (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 06:38:44 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47656 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbhKOLiC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 06:38:02 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 950EB1FD66;
        Mon, 15 Nov 2021 11:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636976081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cfm/br8ciSB/Blss6XeRkivoaPgXuyBzMKbznPf98+E=;
        b=KbnRlZ7uZdY4J6zJn+7jMzhwTH/rb+Y95SFS4yz6psTFlPbHtxc5pSS2Dfx+P+naIoHv22
        qPTobTcTjHPonsT0eyk4VnfhN7LXRCJ3lCEHdbrB3s67sUKLazGMyd0NxOzBa1hTY2GbDY
        39STV97u6g45vQNzu3GA/HHkoktGhIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636976081;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cfm/br8ciSB/Blss6XeRkivoaPgXuyBzMKbznPf98+E=;
        b=FQSPQg67rOCjqwwfFMPh7qE54sNiRj0LJdagPwsGnPxPCFRJSF/ULYQb0D8N6W86O75MXG
        v0cnI7TM6uao8HCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 82F8A13DF2;
        Mon, 15 Nov 2021 11:34:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id U6O0H9FFkmGpSQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 15 Nov 2021 11:34:41 +0000
Subject: Re: [PATCHv5 00/12] nvme: In-band authentication support
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20211112125928.97318-1-hare@suse.de>
 <74db7c77-7cbf-4bc9-1c80-e7c42acaea64@grimberg.me>
 <f67ca46e-f421-33f7-da8b-ff6e47acf8c2@suse.de>
 <8553266f-005c-f947-4737-2108cb7062d1@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a7363853-05af-9d7f-4d6f-b02ec756ce6b@suse.de>
Date:   Mon, 15 Nov 2021 12:34:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <8553266f-005c-f947-4737-2108cb7062d1@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/15/21 11:20 AM, Sagi Grimberg wrote:
> 
>>>> Changes to v4:
>>>> - Validate against blktest suite
>>>
>>> Nice! thanks hannes, this is going to be very useful moving
>>> forward.
>>>
>> Oh, definitely. The number of issue these tests found...
> 
> Great, good that this was useful for you.
> 
>>>> - Fixup base64 decoding
>>>
>>> What was fixed up there?
>>>
>> The padding character '=' wasn't handled correctly on decoding (the
>> character itself was skipped, by the 'bits' value wasn't increased,
>> leading to a spurious error in decoding an any key longer than 32 bit
>> not being accepted.
> 
> I see.
> 
>>>> - Transform secret with correct hmac algorithm
>>>
>>> Is that what I reported last time? Can you perhaps
>>> point me to the exact patch that fixes this?
>>
>> Well, no, not really; the patch itself got squashed in the main patches.
>> But problem here was that the key transformation from section 8.13.5.7
>> had been using the hash algorithm from the initial challenge, not the
>> one specified in the key itself.
>> This lead to decoding errors when using a key with a different length
>> than the hash algorithm.
> 
> That is exactly what I reported, changing the key length leads to
> authentication errors.

Right-o. So it should be sorted then.

BTW, I've created a pull request for nvme-cli
(https://github.com/linux-nvme/nvme-cli/pull/1237)
to add a new command-line option 'dump-config'; can you check if that's
what you had in mind or whether it needs to be improved further?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
