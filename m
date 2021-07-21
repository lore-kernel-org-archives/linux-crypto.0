Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A0EC07E9B
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 06:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C7FE6024A
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 06:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbhGUF00 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jul 2021 01:26:26 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47316 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbhGUF0Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jul 2021 01:26:25 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9BBE020309;
        Wed, 21 Jul 2021 06:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626847618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDKjmwZBzuhTX/zXo42Os5PnZWO5pbPwuwZBvd9jOh4=;
        b=XbhmW09AKmdYLULB6qyPFcfQc2B1beut3E6UMGFeLiyNO4xpuPNUVhbhCAe5xD1bbUfur3
        8fRGqrlQ9miQLX/Y2zYwRcXH00Hwo6XLpRepw8BSUWlYs889Bhyk0oS/T2Bl5aHpbu9ZD3
        2/BINIwyQzLsH/Kw0vAwdICNwOjlfM4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626847618;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDKjmwZBzuhTX/zXo42Os5PnZWO5pbPwuwZBvd9jOh4=;
        b=FwGkorSMBKo8lHB2XOpELu9ooXOxP32bYCHC7fwdizpWNGcsscnAIqS+lBxbpcUtoAWzmj
        PchIEgHo2xe98WBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8A67C133D1;
        Wed, 21 Jul 2021 06:06:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wAOCIYK592CTbAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 21 Jul 2021 06:06:58 +0000
To:     Vladislav Bolkhovitin <vst@vlnb.net>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <66b3b869-02bd-9dee-fadc-8538c6aad57a@vlnb.net>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 00/11] nvme: In-band authentication support
Message-ID: <e339e6e7-fc32-2480-ca99-516547105776@suse.de>
Date:   Wed, 21 Jul 2021 08:06:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <66b3b869-02bd-9dee-fadc-8538c6aad57a@vlnb.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/20/21 10:26 PM, Vladislav Bolkhovitin wrote:
> Hi,
> 
> Great to see those patches coming! After some review, they look to be
> very well done. Some comments/suggestions below.
> 
> 1. I strongly recommend to implement DH exponentials reuse (g x mod p /
> g y mod p as well as g xy mod p) as specified in section 8.13.5.7
> "DH-HMAC-CHAP Security Requirements". When I was working on TP 8006 I
> had a prototype that demonstrated that DH math has quite significant
> latency, something like (as far as I remember) 30ms for 4K group and few
> hundreds of ms for 8K group. For single connection it is not a big deal,
> but imagine AMD EPYC with 128 cores. Since all connections are created
> sequentially, even with 30 ms per connection time to complete full
> remote device connection would become 128*30 => almost 4 seconds. With
> 8K group it might be more than 10 seconds. Users are unlikely going to
> be happy with this, especially in cases, when connecting multiple of
> NVMe-oF devices is a part of a server or VM boot sequence.
> 
Oh, indeed, I can confirm that. FFDHE calculations are quite time-consuming.
But incidentally, ECDH and curve25519 are reasonably fast, so maybe
there _is_ a value in having a TPAR asking for them to be specified, too ...

> If DH exponential reuse implemented, for all subsequent connections the
> DH math is excluded, so authentication overhead becomes pretty much
> negligible.
> 
> In my prototype I implemented DH exponential reuse as a simple
> per-host/target cache that keeps DH exponentials (including g xy mod p)
> for up to 10 seconds. Simple and sufficient.
> 

Frankly, I hadn't looked at exponential reuse; this implementation
really is just a first step to get feedback from people if this is a
direction they want to go.

> Another, might be ever more significant reason why DH exponential reuse
> is important is that without it x (or y on the host side) must always be
> randomly generated each time a new connection is established. Which
> means, for instance, for 8K groups for each connection 1KB of random
> bytes must be taken from the random pool. With 128 connections it is now
> 128KB. Quite a big pressure on the random pool that DH exponential reuse
> mostly avoids.
> 
> Those are the 2 reasons why we added this DH exponential reuse sentence
> in the spec. In the original TP 8006 there was a small informative piece
> explaining reasonings behind that, but for some reasons it was removed
> from the final version.
> 

Thanks for the hint. I'll be adding exponential reuse to the code.

> 2. What is the status of this code from perspective of stability in face
> of malicious host behavior? Seems implementation is carefully done, but,
> for instance, at the first look I was not able to find a code to clean
> up if host in not acting for too long in the middle of exchange. Other
> observation is that in nvmet_execute_auth_send()
> nvmet_check_transfer_len() does not check if tl size is reasonable,
> i.e., for instance, not 1GB.
> 

That is true; exchange timeouts are missing. Will be adding them, of
course. And haven't thought of checking for tl size overflows; will be
adding them, too.

> For sure, we don't want to allow remote hosts to hang or crash target.
> For instance, because of OOM conditions that happened, because malicious
> host asked target to allocate too much memory or open to many being
> authenticated connections in which the host is not going to reply in the
> middle of exchange.
> 
This is something I'll need to look at, anyway. What we do not want is a
userspace application chipping in and send a 'negotiate' command without
any subsequent steps, thereby invalidating the existing authentication.

> Asking, because don't want to go in my review too far ahead from the
> author ;)
> 
> In this regard, it would be great if you add in your test application
> ability to perform authentication with random parameters and randomly
> stop responding. Overnight running of such test would give us good
> degree of confidence that it will always work as expected.
> 

That indeed would be good; let me think on how something like that can
be implemented.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
