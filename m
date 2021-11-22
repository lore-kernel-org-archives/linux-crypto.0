Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CC5C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 09:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbhKVJGj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:06:39 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35302 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbhKVJGi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 04:06:38 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0DD432114E;
        Mon, 22 Nov 2021 09:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637571811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=whPOZezOG/c+6mEuvMoWrjak4ggZA/ulEtBj3hK6sNE=;
        b=w12OB1bYJ9+zl+//D6K2MW5asuPBurPX8LBLg1lgsa5cZikskQSVXExX9rxTZbUmpRS199
        jydbl0/aw/wXEC/SIQh7ji0nigkorPHXaQG1OSm+pRGKZL4/L7jzu/iTeVwfE8gRU59BcL
        Wn6yI7C7ob/BxHLv/fnj1qyobeT3pbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637571811;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=whPOZezOG/c+6mEuvMoWrjak4ggZA/ulEtBj3hK6sNE=;
        b=vKs5wd7ugukbK/Kry/nGnkhUC3TRtHxYPr/8vgwrpV5RBUGm5rrCxB1qrQWwW3fwNcANTm
        MnXthn1Mt3uHXTCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8624513B9E;
        Mon, 22 Nov 2021 09:03:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PRZPFeFcm2HTRwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 22 Nov 2021 09:03:29 +0000
Subject: Re: [PATCHv6 00/12] nvme: In-band authentication support
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
 <14b025bc-746f-ea73-a325-7805c4b46c28@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <8e0909ad-f431-2600-7b68-d86d014fc9ec@suse.de>
Date:   Mon, 22 Nov 2021 10:03:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <14b025bc-746f-ea73-a325-7805c4b46c28@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/22/21 9:13 AM, Sagi Grimberg wrote:
> 
> 
> On 11/22/21 9:47 AM, Hannes Reinecke wrote:
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
>> Changes to v5:
>> - Unify nvme_auth_generate_key()
>> - Unify nvme_auth_extract_key()
> 
> You mean nvme_auth_extract_secret() ?
> 
Yes.

>> - Include reviews from Sagi
> 
> What about the bug fix folded in?

Yeah, and that, to
Forgot to mention it.

Also note that I've already folded the nvme-cli patches into the git
repository to ease testing; I gather that the interface won't change
that much anymore, so I felt justified in doing so.
And I got tired of explaining to interested parties how to build a
non-standard nvme-cli :-)
But that's why I didn't post separate patches for nvme-cli.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
