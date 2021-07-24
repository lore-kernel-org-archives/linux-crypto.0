Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870AFC4338F
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jul 2021 11:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CCFE60E9C
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jul 2021 11:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhGXKhE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jul 2021 06:37:04 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54486 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbhGXKhD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jul 2021 06:37:03 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0768D2004F;
        Sat, 24 Jul 2021 11:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627125455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NkVWf78L+AoJgvAxJsjn66EGaBxm+SYMwkmixM6XH9I=;
        b=D8UWHPr3nT8G3QJl8mOWyoyMkloqPk3c7kb+geAfYRVSHj2uqsK/DKUI3YuO2ndyTHp555
        fv1hh0zaWK+0TLORtjKYvRkY2y1RBJIUfYdAm1k1m07anhFUQVlMs7un5A1uWl9pZisRGh
        EMrkXbqJRvkckeTr14T8LK6Pi+i/x/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627125455;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NkVWf78L+AoJgvAxJsjn66EGaBxm+SYMwkmixM6XH9I=;
        b=5ucQesTJjyzpPjf6QKPaWWrFKbny+4STqzMvso07sLVjN8IqMLu94xhLINjuZ72kjZubTI
        Dro8otJtwriqO+Cw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id D104F13982;
        Sat, 24 Jul 2021 11:17:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id FmmlMc72+2DpYgAAGKfGzw
        (envelope-from <hare@suse.de>); Sat, 24 Jul 2021 11:17:34 +0000
Subject: Re: [RFC PATCH 00/11] nvme: In-band authentication support
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
 <e339e6e7-fc32-2480-ca99-516547105776@suse.de>
 <833cfd62-1e1f-1dca-2e38-ff07b3a5e8fb@vlnb.net>
 <2f241490-3bfd-2151-9d76-970e0d6bfd68@vlnb.net>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d1ca46ef-4615-9385-f30b-281b6c39ac8a@suse.de>
Date:   Sat, 24 Jul 2021 13:17:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2f241490-3bfd-2151-9d76-970e0d6bfd68@vlnb.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/23/21 10:02 PM, Vladislav Bolkhovitin wrote:
> Another comment is that better to perform CRC check of dhchap_secret and
> generation of dhchap_key right where the secret was specified (e.g.,
> nvmet_auth_set_host_key() on the target side).
> 
> No need to do it every time for every connection and by that increase
> authentication latency. As I wrote in the other comment, it might be 128
> or more connections established during connecting to a single NVMe-oF
> device.
> 
And this is something I did deliberately.
The primary issue here is that the user might want/need to change the 
PSK for re-authentication. But for that he might need to check what the 
original/current PSK is, so I think we need to keep the original PSK as 
passed in from the user.
And I found it a waste of space to store the decoded secret in addition 
to the original one, seeing that it can be derived from the original one.
But your argument about the many connections required for a single NVMe 
association is certainly true, to it would make sense to keep the decode 
one around, too, just to speed up computation.
Will be updating the patchset.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
