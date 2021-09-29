Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771BEC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Sep 2021 06:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4795161052
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Sep 2021 06:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242323AbhI2GDg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Sep 2021 02:03:36 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:53982 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243377AbhI2GDf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Sep 2021 02:03:35 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 267BB224A3;
        Wed, 29 Sep 2021 06:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632895314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fy+HHEjyxsfX20aMqiX6dE5rsMWNj0vZpaMr+LvVoa8=;
        b=rnb424Nklh+SK1OKcMOTWctdW9N0AbJlApOuNR18hQE/Q13Idg0bIBF+BslHp2B90jucbg
        rUKAkbr7Xwp94tShtJZaN7Q3/6ZJNh1FVAU5zE1B1oHa/9QampJykkl7NVEBi3ZznW9P+j
        a3i0jOqz4AgjOcsqShQ1bx2CD7HN9eU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632895314;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fy+HHEjyxsfX20aMqiX6dE5rsMWNj0vZpaMr+LvVoa8=;
        b=k2hcZkQbQBC46T/uBT1p9xwpE2pOAhkNFL7cO3rxgljZVLD7j6rjQq4f3rBMQKFCD0o2dd
        0FZ0oM74HErHCDAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ED82613A81;
        Wed, 29 Sep 2021 06:01:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4d9EOFEBVGHfRQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 29 Sep 2021 06:01:53 +0000
Subject: Re: [PATCH 10/12] nvmet: Implement basic In-Band Authentication
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-11-hare@suse.de>
 <79742bd7-a41c-0abc-e7de-8d222b146d02@grimberg.me>
 <c7739610-6d0b-7740-c339-b35ca5ae34e2@suse.de>
 <a2596777-25b2-f633-4b00-18b1a319c5c2@suse.de>
 <32d8f860-9fdb-606c-62b7-ad89837d8e71@grimberg.me>
 <2ccfb62a-d782-7bb2-4d41-6d1152851a4a@suse.de>
 <24d3ee65-83e7-c958-cd17-eb4351a8349c@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0ee67498-9630-af05-2207-a39d7f836b3e@suse.de>
Date:   Wed, 29 Sep 2021 08:01:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <24d3ee65-83e7-c958-cd17-eb4351a8349c@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/29/21 12:36 AM, Sagi Grimberg wrote:
> 
>>>> Actually, having re-read the spec I'm not sure if the second path is
>>>> correct.
>>>> As per spec only the _host_ can trigger re-authentication. There is no
>>>> provision for the controller to trigger re-authentication, and given
>>>> that re-auth is a soft-state anyway (ie the current authentication
>>>> stays valid until re-auth enters a final state) I _think_ we should be
>>>> good with the current implementation, where we can change the
>>>> controller keys
>>>> via configfs, but they will only become active once the host triggers
>>>> re-authentication.
>>>
>>> Agree, so the proposed addition is good with you?
>>>
>> Why would we need it?
>> I do agree there's a bit missing for removing the old shash_tfm if there
>> is a hash-id mismatch, but why would we need to reset the entire
>> authentication?
> 
> Just need to update the new host dhchap_key from the host at this point
> as the host is doing a re-authentication. I agree we don't need a big
> hammer but we do need the re-authentication to not access old host
> dhchap_key.

Sure. And, upon reviewing, I guess you are right; will be including your 
snippet.
For the next round :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
