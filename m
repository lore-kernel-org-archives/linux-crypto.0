Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663E1C07E95
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 11:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C5F56113A
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 11:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhGTKvS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 06:51:18 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35996 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbhGTKvL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 06:51:11 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1997D2245C;
        Tue, 20 Jul 2021 11:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626780705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HKJuwvlbpq9y+50Lzz2FJYdnyQhvoYmQQwpN1Z2oGU0=;
        b=Zls6/hODZeTBb1YVm/s2efgmc4zBk1AYen7YCXkhWilqZLrqpSvpnaufNW6fxk+TKN1W4G
        UmOzKtOlxLdNEfaqhmS6J10J1KALf+XNMo+6u7jyPMT/bGkz4ztB/c1eVQ2X7Hf++LhxTb
        QUAp1bBE19M1rgVzfhOlCJ9qS9tZ7Qo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626780705;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HKJuwvlbpq9y+50Lzz2FJYdnyQhvoYmQQwpN1Z2oGU0=;
        b=eEuGuzxiemKWNC577WViXUvTomRFMaoVL/PIS1rouPvlw/tRlCrI36/aw9wLILCT2zWFKX
        SlVzff6dZ4hm8sDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 00F7E13C8A;
        Tue, 20 Jul 2021 11:31:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TuUIOyC09mAdUgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 20 Jul 2021 11:31:44 +0000
To:     Simo Sorce <simo@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <2510347.locV8n3378@positron.chronox.de>
 <a4d4bda0-2bc8-0d0c-3e81-55adecd6ce52@suse.de>
 <6538288.aohFRl0Q45@positron.chronox.de>
 <59695981-9edc-6b7a-480a-94cca95a0b8c@suse.de>
 <463a191b9896dd708015645cfc125988cd5deaef.camel@chronox.de>
 <2af95a8e-50d9-7e2d-a556-696e9404fee4@suse.de>
 <740af9f7334c294ce879bef33985dfab6d0523b3.camel@chronox.de>
 <1eab1472-3b7b-307b-62ae-8bed39603b96@suse.de>
 <24d115c9b68ca98a3cf363e1cfcb961cc6b38069.camel@chronox.de>
 <aac9448e-29e9-6d03-1077-148be3c10f50@suse.de>
 <11ab4001f580a6b2c3cce959282259c1f9095f63.camel@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
Message-ID: <4cd673a8-a503-c29a-85f6-3c2703558181@suse.de>
Date:   Tue, 20 Jul 2021 13:31:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <11ab4001f580a6b2c3cce959282259c1f9095f63.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/20/21 12:49 PM, Simo Sorce wrote:
> On Tue, 2021-07-20 at 12:14 +0200, Hannes Reinecke wrote:
>> On 7/19/21 1:52 PM, Stephan Mueller wrote:
>>> Am Montag, dem 19.07.2021 um 13:10 +0200 schrieb Hannes Reinecke:
>>>> On 7/19/21 12:19 PM, Stephan Mueller wrote:
>>>>> Am Montag, dem 19.07.2021 um 11:57 +0200 schrieb Hannes Reinecke:
>>>>>> On 7/19/21 10:51 AM, Stephan Mueller wrote:
>> [ .. ]
>>>>>>>
>>>>>>> Thank you for clarifying that. It sounds to me that there is no
>>>>>>> defined protocol (or if there, I would be wondering how the code would have
>>>>>>> worked
>>>>>>> with a different implementation). Would it make sense to first specify
>>>>>>> a protocol for authentication and have it discussed? I personally think
>>>>>>> it is a bit difficult to fully understand the protocol from the code and
>>>>>>> discuss protocol-level items based on the code.
>>>>>>>
>>>>>> Oh, the protocol _is_ specified:
>>>>>>
>>>>>>  
>>>>>> https://nvmexpress.org/wp-content/uploads/NVM-Express-Base-Specification-2_0-2021.06.02-Ratified-5.pdf
>>>>>>
>>>>>> It's just that I have issues translating that spec onto what the kernel
>>>>>> provides.
>>>>>
>>>>> according to the naming conventions there in figures 447 and following:
>>>>>
>>>>> - x and y: DH private key (kernel calls it secret set with dh_set_secret
>>>>> or
>>>>> encoded into param.key)
>>>>>
>>>>
>>>> But that's were I got confused; one needs a private key here, but there
>>>> is no obvious candidate for it. But reading it more closely I guess the
>>>> private key is just a random number (cf the spec: g^y mod p, where y is
>>>> a random number selected by the host that shall be at least 256 bits
>>>> long). So I'll fix it up with the next round.
>>>
>>> Here comes the crux: the kernel has an ECC private key generation function
>>> ecdh_set_secret triggered with crypto_kpp_set_secret using a NULL key, but it
>>> has no FFC-DH counterpart.
>>>
>>> That said, generating a random number is the most obvious choice, but not the
>>> right one.
>>>
>>> The correct one would be following SP800-56A rev 3 and here either section
>>> 5.6.1.1.3 or 5.6.1.1.4.
>>>
>> Hmm. Okay. But after having read section 5.6.1.1.4, I still do have some
>> questions.
>>
>> Assume we will be using a bit length of 512 for FFDHE, then we will
>> trivially pass Step 2 for all supported FFDHE groups (the maximum
>> symmetric-equivalent strength for ffdhe8192 is 192 bits).
> 
> N = 512 is not a good choice, minimum length these days for DH should
> be 2048 or more.
> 

According to RFC7919:
Peers using ffdhe8192 that want to optimize their key exchange with a
short exponent (Section 5.2) should choose a secret key of at least
400 bits.

So what is wrong with 512 bits?

>> From my understanding, the random number generator will fill out all
>> available bytes in the string (and nothing more), so we trivially
>> satisfy step 3 and 4.
>>
>> And as q is always larger than the random number, step 6 reduces to
>> 'if (c > 2^N - 2)',
> 
> Where is this coming from ?
> It seem you assume M = 2^N but M = min(2^N, q)
> 
> The point here is to make sure the number X you return is:
> 0 < X < (q-1)
> 

Which is what I've tried to argue. For 512 bits private key and the
smallest possible FFDHE group (which has 2048 bits, with the top bit
non-zero) 2^N is always smaller than (q - 1).
As the other FFHDE groups are using even larger 'q' values, this is true
for all FFHDE groups.

>>  ie we just need to check if the random number is a
>> string of 0xff characters. Which hardly is a random number at all, so
>> it'll be impossible to get this.
>>
>> Which then would mean that our 'x' is simply the random number + 1,
> 
> This is an artifact due to the random number being 0 <= c < 2^N - 1,
> therefore 1 needs to be added to make sure you never return 0.
> 

And my argument here is that all zeros (and all ones) are not a value I
would expect from our RNG.

>> which arguably is slightly pointless (one more than a random number is
>> as random as the number itself), so I do feel justified with just
>> returning a random number here.
>>
>> Am I wrong with that reasoning?
> 
> Looks to me you are not accounting for the fact that N = 512 is too
> small and a random number falling in the interval (q - 2) < X < 2^N is
> unsuitable?
> 

Only if (q - 2) < 2^N. And my point is that it's not.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
