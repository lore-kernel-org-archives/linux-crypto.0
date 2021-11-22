Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B7DC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 09:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhKVJSb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:18:31 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:45786 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhKVJSa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 04:18:30 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 030011FD4A;
        Mon, 22 Nov 2021 09:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637572524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVG/pwuepxg++RIJMeKuF4CdYwjjCy/PQ5BqDr33lok=;
        b=N/z60bgMhjeadOeryuQzaPB+q6Pq6fyVW+rrnHs1QdqlolzcbaQpF8NxIojh+DRbJVVhgs
        8hq7Fu/4WnvBWNYQCQ8ecmo6+K4Kb4LGK7syrySp0/aKqB4pmzN2OQu3onTpJOY476EF4E
        rD1bH7GXv4I/dXhxmBACH7xrHSVbxFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637572524;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVG/pwuepxg++RIJMeKuF4CdYwjjCy/PQ5BqDr33lok=;
        b=G3/Wk9U/aQLzLQThiiFr5Aq1kj34sLalnG96SsY5/Nem8bMXEmctMMMO8jXa9pXcGSj5Br
        cuGL8T1+xQTSsdCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B650113B9E;
        Mon, 22 Nov 2021 09:15:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xztSK6tfm2HiTQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 22 Nov 2021 09:15:23 +0000
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
 <20211122074727.25988-8-hare@suse.de>
 <8f6c144d-0354-2753-ab58-1f5cabcafbdd@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <fe1596bf-9bc8-13b1-eb7a-67cde6bb7dbc@suse.de>
Date:   Mon, 22 Nov 2021 10:15:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <8f6c144d-0354-2753-ab58-1f5cabcafbdd@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/22/21 9:12 AM, Sagi Grimberg wrote:
> 
>> +int nvme_auth_generate_key(struct nvme_ctrl *ctrl, u8 *secret, bool
>> set_ctrl)
> 
> Maybe instead of set_ctrl introduct struct dhchap_key and pass a pointer
> into that?
> 
>> +{
>> +    u8 *key;
>> +    size_t key_len;
>> +    u8 key_hash;
>> +
>> +    if (!secret)
>> +        return 0;
>> +
>> +    if (sscanf(secret, "DHHC-1:%hhd:%*s:", &key_hash) != 1)
>> +        return -EINVAL;
>> +
>> +    /* Pass in the secret without the 'DHHC-1:XX:' prefix */
>> +    key = nvme_auth_extract_secret(secret + 10, key_hash,
>> +                       &key_len);
>> +    if (IS_ERR(key)) {
>> +        dev_dbg(ctrl->device, "failed to extract key, error %ld\n",
>> +            PTR_ERR(key));
>> +        return PTR_ERR(key);
>> +    }
>> +
>> +    if (set_ctrl) {
>> +        ctrl->dhchap_ctrl_key = key;
>> +        ctrl->dhchap_ctrl_key_len = key_len;
>> +        ctrl->dhchap_ctrl_key_hash = key_hash;
>> +    } else {
>> +        ctrl->dhchap_key = key;
>> +        ctrl->dhchap_key_len = key_len;
>> +        ctrl->dhchap_key_hash = key_hash;
>> +    }
> 
> Then it becomes:
>     dhchap_key->key = key;
>     dhchap_key->len = key_len;
>     dhchap_key->hash = key_hash;

Good point.
Will be folding it in.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
