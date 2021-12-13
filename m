Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8053FC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Dec 2021 08:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhLMIqY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Dec 2021 03:46:24 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41548 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhLMIqY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Dec 2021 03:46:24 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6C7981F3B8;
        Mon, 13 Dec 2021 08:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639385183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0/VPm3ydm8Lh1MC71fJ8fF3QfSBxu4rUQ1hnUEyNTo=;
        b=Umv3EcPWav9kpkOGSeTNnT5A1pk5kKDoMDOxpmJ+FeLMlgT/ygv3WzeqghXUzQTjzAbX3+
        xbmp02dS/RC8QyHL5NRjs/FrEHyjvdwAMlSW4dKWWQIgs8iCeeBIVQMPZKLbVdX/h36yPf
        w1YaQ3YSQ6zoAfn3auwe1lpJKmrrNG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639385183;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0/VPm3ydm8Lh1MC71fJ8fF3QfSBxu4rUQ1hnUEyNTo=;
        b=y5uALWF3Rl51wYTuGyvFpEwjiIDfg74m+5LtNIWd86ssDIZ8kewdojUBBtd/NXguC+/Ayw
        8+kBl530LuhTtkBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 53AB113BB2;
        Mon, 13 Dec 2021 08:46:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id o4OhE18It2F5EAAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 13 Dec 2021 08:46:23 +0000
Subject: Re: [PATCHv8 00/12] nvme: In-band authentication support
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211213080853.GA21223@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9853d36a-036c-7f2b-5fb4-b3fb4bae473f@suse.de>
Date:   Mon, 13 Dec 2021 09:46:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211213080853.GA21223@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/13/21 9:08 AM, Christoph Hellwig wrote:
> So if we want to make progress on this we need the first 3 patches
> rewviewed by the crypto maintainers.  In fact I'd prefer to get them
> merged through the crypto tree as well, and would make sure we have
> a branch that pulls them in for the nvme changes.  I'll try to find
> some time to review the nvme bits as well.
> 
That is _actually_ being addressed already.
Nicolai Stange send a patchset for ephemeral keys, FFDHE support, and 
FIPS-related thingies for the in-kernel DH crypto implementation 
(https://lore.kernel.org/linux-crypto/20211209090358.28231-1-nstange@suse.de/).
This obsoletes my preliminary patches, and I have ported my patchset to 
run on top of those.

Question is how to continue from here; I can easily rebase my patchset 
and send it relative to Nicolais patches. But then we'll be bound to the 
acceptance of those patches, so I'm not quite sure if that's the best 
way to proceed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
