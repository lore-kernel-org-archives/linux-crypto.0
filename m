Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E6DC07E9B
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 06:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F817600EF
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 06:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhGUFb3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jul 2021 01:31:29 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47744 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhGUFb2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jul 2021 01:31:28 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9BDAD20309;
        Wed, 21 Jul 2021 06:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626847924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23Da93x2OamZkrjR7W059ebzA9RY2IGBwKnHeBHK5SU=;
        b=PeNne0pGyUGWa2BTrvclh6ps1qlNHNCZWdF7dTCA+6fc0Fj+2PG8gu4F7zTS0OOnxfSu94
        UGTOD/iId2nOAaxGhP5u2Lb2/PiDvA1cORstTc9wMs9OVjZh9p+e6L8zcqMS6E0L+USI7Q
        ybdotj77oCC1tr/kjWPXDH2PwdtUTK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626847924;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23Da93x2OamZkrjR7W059ebzA9RY2IGBwKnHeBHK5SU=;
        b=VdKJuwzVvR7D8rog49FyRYVIDGCjcCSqDPWl/NsCfgHsvFStxZ+B13I/uHw/P7FHOGUQsb
        WAmEC0n/mHHDZYDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 86BF9133D1;
        Wed, 21 Jul 2021 06:12:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kh8sILS692CPbQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 21 Jul 2021 06:12:04 +0000
Subject: Re: [PATCH 06/11] nvme: Implement In-Band authentication
To:     Vladislav Bolkhovitin <vst@vlnb.net>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-7-hare@suse.de>
 <bd588839-8acc-91cf-5946-f702007b0c7d@grimberg.me>
 <d74c29b8-1c64-e439-9015-6c424baad3d3@suse.de>
 <a3098fb2-2127-6f81-97e9-ab5de503508e@vlnb.net>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <14949004-6ef5-b8e5-f133-c50fe311a693@suse.de>
Date:   Wed, 21 Jul 2021 08:12:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a3098fb2-2127-6f81-97e9-ab5de503508e@vlnb.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/20/21 10:28 PM, Vladislav Bolkhovitin wrote:
> 
> On 7/18/21 3:21 PM, Hannes Reinecke wrote:
>> On 7/17/21 9:22 AM, Sagi Grimberg wrote:
>>>> Implement NVMe-oF In-Band authentication. This patch adds two new
>>>> fabric options 'dhchap_key' to specify the PSK
>>>
>>> pre-shared-key.
>>>
>>> Also, we need a sysfs knob to rotate the key that will trigger
>>> re-authentication or even a simple controller(s-plural) reset, so this
>>> should go beyond just the connection string.
>>>
>>
>> Yeah, re-authentication currently is not implemented. I first wanted to
>> get this patchset out such that we can settle on the userspace interface
>> (both from host and target).
>> I'll have to think on how we should handle authentication; one of the
>> really interesting cases would be when one malicious admin will _just_
>> send a 'negotiate' command to the controller. As per spec the controller
>> will be waiting for an 'authentication receive' command to send a
>> 'challenge' payload back to the host. But that will never come, so as it
>> stands currently the controller is required to abort the connection.
>> Not very nice.
> 
> Yes, in this case after some reasonable timeout (I would suggest 10-15
> seconds) the controller expected to abort connection and clean up all
> allocated resources.
> 
> To handle DoS possibility to make too many such "orphan" negotiations,
> hence consume all controller memory, some additional handling is needed.
> For simplicity as a first step I would suggest to have a global limit on
> number of currently being authenticated connections.
> 
> [...]
> 
>>>> +    chap->key = nvme_auth_extract_secret(ctrl->opts->dhchap_secret,
>>>> +                         &chap->key_len);
>>>> +    if (IS_ERR(chap->key)) {
>>>> +        ret = PTR_ERR(chap->key);
>>>> +        chap->key = NULL;
>>>> +        return ret;
>>>> +    }
>>>> +
>>>> +    if (key_hash == 0)
>>>> +        return 0;
>>>> +
>>>> +    hmac_name = nvme_auth_hmac_name(key_hash);
>>>> +    if (!hmac_name) {
>>>> +        pr_debug("Invalid key hash id %d\n", key_hash);
>>>> +        return -EKEYREJECTED;
>>>> +    }
>>>
>>> Why does the user influence the hmac used? isn't that is driven
>>> by the susbsystem?
>>>
>>> I don't think that the user should choose in this level.
>>>
>>
>> That is another weirdness of the spec.
>> The _secret_ will be hashed with a specific function, and that function
>> is stated in the transport representation.
>> (Cf section "DH-HMAC-CHAP Security Requirements").
>> This is _not_ the hash function used by the authentication itself, which
>> will be selected by the protocol.
>> So it's not the user here, but rather the transport specification of the
>> key which selects the hash algorithm.
> 
> Yes, good catch. It looks as a minor errata material to specify that
> hash function here is implementation specific.
> 
> I would suggest to just hardcode SHA512 here. Users don't have to be
> confused by this.
> 
Sure, can do. My reasoning was that the target absolutely has to support
the hash functions specified in the PSK, so that will be a safe bet to
choose for the hash function in the protocol itself.
(Any other hash function _might_ not be preset on the target.)
But if the PSK does not specify a hash the target need to pick one; and
for that of course we can use SHA512.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
