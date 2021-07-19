Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A87EC636C9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 09:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D97F61175
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 09:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbhGSJQ2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 05:16:28 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:53136 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhGSJQ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 05:16:28 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 58EB522211;
        Mon, 19 Jul 2021 09:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626688627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hm0zebaLB1hjuy5JvbxVdPV/pSPvr5dtUW8IyF6POIw=;
        b=yTP5pKNoCyI7Jjy4ptxGgMmsdn8+gFd9uPryJOgL9cozn/N81BRGJzcrjgEeFM2YpgKDFg
        FclstTKBeA/eUCVoqA2ymDNDeLHF/Mya/UXiiBJPNrY4NNZZBdIDW1/2k5FkYPKhoTDqbC
        kR/deS+NQw5ZahK41LQN2s5Re0e193A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626688627;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hm0zebaLB1hjuy5JvbxVdPV/pSPvr5dtUW8IyF6POIw=;
        b=GDN7uLNmt7P8pyASVwy1uZF2gyMwKA7nG4gR3IWm2c90DUxBiXdNKt174lEHyi7+rEdtqd
        1OxpoPGePQfGwODg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3F21C13CA7;
        Mon, 19 Jul 2021 09:57:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Gr41D3NM9WDWMwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 19 Jul 2021 09:57:07 +0000
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
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
Message-ID: <2af95a8e-50d9-7e2d-a556-696e9404fee4@suse.de>
Date:   Mon, 19 Jul 2021 11:57:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <463a191b9896dd708015645cfc125988cd5deaef.camel@chronox.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/21 10:51 AM, Stephan Mueller wrote:
> Am Montag, dem 19.07.2021 um 10:15 +0200 schrieb Hannes Reinecke:
>> On 7/18/21 2:56 PM, Stephan Müller wrote:
>>> Am Sonntag, 18. Juli 2021, 14:37:34 CEST schrieb Hannes Reinecke:
> 
>>>> The key is also used when using the ffdhe algorithm.
>>>> Note: I _think_ that I need to use this key for the ffdhe algorithm,
>>>> because the implementation I came up with is essentially plain DH with
>>>> pre-defined 'p', 'q' and 'g' values. But the DH implementation also
>>>> requires a 'key', and for that I'm using this key here.
>>>>
>>>> It might be that I'm completely off, and don't need to use a key for our
>>>> DH implementation. In that case you are correct.
>>>> (And that's why I said I'll need a review of the FFDHE implementation).
>>>> But for now I'll need the key for FFDHE.
>>>
>>> Do I understand you correctly that the dhchap_key is used as the input to
>>> the 
>>> DH - i.e. it is the remote public key then? It looks strange that this is
>>> used 
>>> for DH but then it is changed here by hashing it together with something
>>> else 
>>> to form a new dhchap_key. Maybe that is what the protocol says. But it
>>> sounds 
>>> strange to me, especially when you think that dhchap_key would be, say,
>>> 2048 
>>> bits if it is truly the remote public key and then after the hashing it is
>>> 256 
>>> this dhchap_key cannot be used for FFC-DH.
>>>
>>> Or are you using the dhchap_key for two different purposes?
>>>
>>> It seems I miss something here.
>>>
>> No, not entirely. It's me who buggered it up.
>> I got carried away by the fact that there is a crypto_dh_encode_key()
>> function, and thought I need to use it here.
> 
> Thank you for clarifying that. It sounds to me that there is no defined
> protocol (or if there, I would be wondering how the code would have worked
> with a different implementation). Would it make sense to first specify a
> protocol for authentication and have it discussed? I personally think it is a
> bit difficult to fully understand the protocol from the code and discuss
> protocol-level items based on the code.
> 
Oh, the protocol _is_ specified:

https://nvmexpress.org/wp-content/uploads/NVM-Express-Base-Specification-2_0-2021.06.02-Ratified-5.pdf

It's just that I have issues translating that spec onto what the kernel
provides.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
