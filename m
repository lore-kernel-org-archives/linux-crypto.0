Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469C9C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 May 2022 06:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbiE0Gbe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 02:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237220AbiE0Gbd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 02:31:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E47F4DF4A
        for <linux-crypto@vger.kernel.org>; Thu, 26 May 2022 23:31:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 44B2D21A80;
        Fri, 27 May 2022 06:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653633089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7HBCF9efx3p84GKtHtWLw6g/KaC2bwjOorQoN8FZ76I=;
        b=rEw+MetWCwrTNk2j97PNS0GBey+J4cShkStK2EKMSYPUOksSuz4SmuloRk5dyayTNa1uEU
        dDF5EJnT/DJ9wV+3g5RpKyS2jm2rco5n+rOJAH0VsyWk421YEFBdyPu8170CGyKfPaZuBb
        cAwqbAJj7AlWVT5LzFXkGTyDjov7ibQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653633089;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7HBCF9efx3p84GKtHtWLw6g/KaC2bwjOorQoN8FZ76I=;
        b=2GuHu0PhYS0f/ZSqRwAst2g4PDpO+B8RghpDAzjFM2mZnYjJqD9umQ13TbW/4Qv+80zfXI
        LFj5Ylg8A1KSpUBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2A36E139C4;
        Fri, 27 May 2022 06:31:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dRKWCUFwkGKLEAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 May 2022 06:31:29 +0000
Message-ID: <8f66aed7-2a46-d3bb-1121-a81f94763864@suse.de>
Date:   Fri, 27 May 2022 08:31:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCHv12 00/11] nvme: In-band authentication support
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20220518112234.24264-1-hare@suse.de>
 <bc8bea8b-2cdf-4d41-65b0-5c2bf28457d2@suse.de>
 <20220526090056.GA27050@lst.de>
 <99126556-65b8-d0eb-bcd5-7b850493b51f@suse.de>
In-Reply-To: <99126556-65b8-d0eb-bcd5-7b850493b51f@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/27/22 07:50, Hannes Reinecke wrote:
> On 5/26/22 11:00, Christoph Hellwig wrote:
>> On Wed, May 25, 2022 at 11:54:54AM +0200, Hannes Reinecke wrote:
>>> How do we proceed herese h
>>> This has been lingering for quite some time now, without any real 
>>> progress.
>>
>> As said it is a high priority for the upcoming merge window.  But we
>> also really need reviews from the crypto maintainers for the crypto
>> patches, without that I can't merge the series even if I'd like to.
> 
> Hmm. Guess I can remove those helpers; after all,
> both are just wrappers around existing exported helpers.
> I'll resend.
> 
Bummer. There was a reason after all why I coded those helpers; they 
require an internal pointer :-(
But all of these are just checks if specific hash/kpp functions are 
supported; replacing them with appropriate CONFIG_ statements should 
work as well.
I'll check.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
