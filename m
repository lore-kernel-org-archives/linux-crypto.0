Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912EEC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 13:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbhKWNeD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 08:34:03 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35810 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbhKWNeC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 08:34:02 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 12D2F21921;
        Tue, 23 Nov 2021 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637674254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vrJi5uPfWJ5hczlkJc8rwXM5Ug5ljtSq9/Ls3aVQjo0=;
        b=C/fcuRjuqtvzEeTONHn79mRtxAl3yMfs6uOA5NjHKPZnxpKF/OEFevci99L/dlqLN8ijKs
        4/tlp8g5V3Xnxa2mTOqukBTDsnIQ+wIR122GrHhmR1fm/DSLqNwxIse2YeU9IXEFLOhueL
        M26BccGN9RcFCShiFFbkrdFKMGbhf/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637674254;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vrJi5uPfWJ5hczlkJc8rwXM5Ug5ljtSq9/Ls3aVQjo0=;
        b=d0C+OricXxvUjNL2Ry0OI4dQ85sUIUmHtkn7B+Lz6nxR1ipZCPT9fiSo7Ru/US7I3KM1Ix
        AV7s151CZ8dSrOAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EB78D13DE9;
        Tue, 23 Nov 2021 13:30:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DNgeOQ3tnGEYEAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 23 Nov 2021 13:30:53 +0000
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211123123801.73197-1-hare@suse.de>
 <20211123123801.73197-8-hare@suse.de>
 <ffd1519b-1f39-898a-be7f-5d9db7377ad1@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <33461345-668f-112c-9552-9930714ab609@suse.de>
Date:   Tue, 23 Nov 2021 14:30:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ffd1519b-1f39-898a-be7f-5d9db7377ad1@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/23/21 2:11 PM, Sagi Grimberg wrote:
> 
>> +int nvme_auth_generate_key(struct nvme_ctrl *ctrl, u8 *secret, bool
>> set_ctrl)
> 
> Didn't we agree to pass the key pointer? i.e.
> int nvme_auth_generate_key(struct nvme_dhchap_key **key, u8 *secret)
> 
Ah. That's what you had in mind.
Why, of course we can do that.

>> +{
>> +    struct nvme_dhchap_key *key;
>> +    u8 key_hash;
>> +
>> +    if (!secret)
>> +        return 0;
>> +
>> +    if (sscanf(secret, "DHHC-1:%hhd:%*s:", &key_hash) != 1)
>> +        return -EINVAL;
>> +
>> +    /* Pass in the secret without the 'DHHC-1:XX:' prefix */
>> +    key = nvme_auth_extract_key(secret + 10, key_hash);
>> +    if (IS_ERR(key)) {
>> +        dev_dbg(ctrl->device, "failed to extract key, error %ld\n",
>> +            PTR_ERR(key));
> 
> The print here is slightly redundant - you already have prints inside
> nvme_auth_extract_key already.
> 
Yeah; I really need to go through the code and remove the redundant
messages. Especially on the error paths.

>> +        return PTR_ERR(key);
>> +    }
>> +
> 
> Then we instead just do:
>     *key = key;
> 
>> +    if (set_ctrl)
>> +        ctrl->ctrl_key = key;
>> +    else
>> +        ctrl->host_key = key;
>> +
>> +    return 0;
>> +}
> 
> ...
> 
>> +EXPORT_SYMBOL_GPL(nvme_auth_generate_key);
>> diff --git a/drivers/nvme/host/auth.h b/drivers/nvme/host/auth.h
>> new file mode 100644
>> index 000000000000..16e3d893d54a
>> --- /dev/null
>> +++ b/drivers/nvme/host/auth.h
>> @@ -0,0 +1,33 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2021 Hannes Reinecke, SUSE Software Solutions
>> + */
>> +
>> +#ifndef _NVME_AUTH_H
>> +#define _NVME_AUTH_H
>> +
>> +#include <crypto/kpp.h>
>> +
>> +struct nvme_dhchap_key {
>> +    u8 *key;
>> +    size_t key_len;
>> +    u8 key_hash;
> 
> Why not just name it len and hash? don't think the key_
> prefix is useful...

True.
Will do so.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
