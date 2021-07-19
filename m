Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0FFC07E9B
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 12:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B17D6112D
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 12:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhGSL12 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 07:27:28 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:53632 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbhGSL12 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 07:27:28 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8AC2A20258;
        Mon, 19 Jul 2021 12:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626696487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AiBVZRbDoLWvaewLny2kvpduEqU+pgM/X0VwmVoIT3w=;
        b=p60ilip4jpJvsqpMIaZg3QupG6g8Mi2s52/y6+dbsMfLb4QwH7DtezsR1T5EmUV0xTbkQz
        dl8L4oULuMtSp4rINo/mSmCkNGlSxAdWScibsYhLN3lcj5rimgFURb+BmHewWQVdOdKyfs
        kfIxta6sWWbYbAJZ2l5RbDcC4zKHgaI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626696487;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AiBVZRbDoLWvaewLny2kvpduEqU+pgM/X0VwmVoIT3w=;
        b=FaP9n3C9SdvwzF+rV2PbmbIQAVxDaPf6x97zbq0C+cQgkWP2VwlftsMM/o/OdKunx+lxE6
        kpv7kxx+bZA4ndCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7B21F13CE9;
        Mon, 19 Jul 2021 12:08:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bo7FHSdr9WBSXAAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 19 Jul 2021 12:08:07 +0000
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
To:     Stephan Mueller <smueller@chronox.de>,
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
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4f7ab2fc-0802-3040-dedc-63d04fbc1f0b@suse.de>
Date:   Mon, 19 Jul 2021 14:08:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <24d115c9b68ca98a3cf363e1cfcb961cc6b38069.camel@chronox.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/21 1:52 PM, Stephan Mueller wrote:
> Am Montag, dem 19.07.2021 um 13:10 +0200 schrieb Hannes Reinecke:
>> On 7/19/21 12:19 PM, Stephan Mueller wrote:
>>> Am Montag, dem 19.07.2021 um 11:57 +0200 schrieb Hannes Reinecke:
>>>> On 7/19/21 10:51 AM, Stephan Mueller wrote:
>>>>> Am Montag, dem 19.07.2021 um 10:15 +0200 schrieb Hannes Reinecke:
>>>>>> On 7/18/21 2:56 PM, Stephan Müller wrote:
>>>>>>> Am Sonntag, 18. Juli 2021, 14:37:34 CEST schrieb Hannes Reinecke:
>>>>>
>>>>>>>> The key is also used when using the ffdhe algorithm.
>>>>>>>> Note: I _think_ that I need to use this key for the ffdhe
>>>>>>>> algorithm,
>>>>>>>> because the implementation I came up with is essentially plain
>>>>>>>> DH
>>>>>>>> with
>>>>>>>> pre-defined 'p', 'q' and 'g' values. But the DH implementation
>>>>>>>> also
>>>>>>>> requires a 'key', and for that I'm using this key here.
>>>>>>>>
>>>>>>>> It might be that I'm completely off, and don't need to use a key
>>>>>>>> for
>>>>>>>> our
>>>>>>>> DH implementation. In that case you are correct.
>>>>>>>> (And that's why I said I'll need a review of the FFDHE
>>>>>>>> implementation).
>>>>>>>> But for now I'll need the key for FFDHE.
>>>>>>>
>>>>>>> Do I understand you correctly that the dhchap_key is used as the
>>>>>>> input
>>>>>>> to
>>>>>>> the 
>>>>>>> DH - i.e. it is the remote public key then? It looks strange that
>>>>>>> this
>>>>>>> is
>>>>>>> used 
>>>>>>> for DH but then it is changed here by hashing it together with
>>>>>>> something
>>>>>>> else 
>>>>>>> to form a new dhchap_key. Maybe that is what the protocol says.
>>>>>>> But it
>>>>>>> sounds 
>>>>>>> strange to me, especially when you think that dhchap_key would be,
>>>>>>> say,
>>>>>>> 2048 
>>>>>>> bits if it is truly the remote public key and then after the
>>>>>>> hashing
>>>>>>> it is
>>>>>>> 256 
>>>>>>> this dhchap_key cannot be used for FFC-DH.
>>>>>>>
>>>>>>> Or are you using the dhchap_key for two different purposes?
>>>>>>>
>>>>>>> It seems I miss something here.
>>>>>>>
>>>>>> No, not entirely. It's me who buggered it up.
>>>>>> I got carried away by the fact that there is a
>>>>>> crypto_dh_encode_key()
>>>>>> function, and thought I need to use it here.
>>>>>
>>>>> Thank you for clarifying that. It sounds to me that there is no
>>>>> defined
>>>>> protocol (or if there, I would be wondering how the code would have
>>>>> worked
>>>>> with a different implementation). Would it make sense to first specify
>>>>> a
>>>>> protocol for authentication and have it discussed? I personally think
>>>>> it
>>>>> is a
>>>>> bit difficult to fully understand the protocol from the code and
>>>>> discuss
>>>>> protocol-level items based on the code.
>>>>>
>>>> Oh, the protocol _is_ specified:
>>>>
>>>>  
>>>> https://nvmexpress.org/wp-content/uploads/NVM-Express-Base-Specification-2_0-2021.06.02-Ratified-5.pdf
>>>>
>>>> It's just that I have issues translating that spec onto what the kernel
>>>> provides.
>>>
>>> according to the naming conventions there in figures 447 and following:
>>>
>>> - x and y: DH private key (kernel calls it secret set with dh_set_secret
>>> or
>>> encoded into param.key)
>>>
>>
>> But that's were I got confused; one needs a private key here, but there
>> is no obvious candidate for it. But reading it more closely I guess the
>> private key is just a random number (cf the spec: g^y mod p, where y is
>> a random number selected by the host that shall be at least 256 bits
>> long). So I'll fix it up with the next round.
> 
> Here comes the crux: the kernel has an ECC private key generation function
> ecdh_set_secret triggered with crypto_kpp_set_secret using a NULL key, but it
> has no FFC-DH counterpart.
> 
> That said, generating a random number is the most obvious choice, but not the
> right one.
> 
> The correct one would be following SP800-56A rev 3 and here either section
> 5.6.1.1.3 or 5.6.1.1.4.
> 

Oh fsck. Of course. Would've been too easy.
Well, more coding required then. Let's see how it goes.
But thanks for your help!

(And I wouldn't say no if someone would step in an provide a 'real'
FFDHE crypto algorithm; now that the parameters are already present :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
