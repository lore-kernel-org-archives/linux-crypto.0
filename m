Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1DB3C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 25 May 2022 09:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbiEYJzG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 May 2022 05:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240198AbiEYJy6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 May 2022 05:54:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154C83B292
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 02:54:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C94111F381;
        Wed, 25 May 2022 09:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653472495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dPoS6tTAzIT9GSFsK8tCzq7kbDmsveydGcvIwarTytA=;
        b=FARXe43I27aI2GX3Pi9cUoCZ216BMmYoMBQAfhN9Efn8kJnOW/yVz3HmXhb5intBE6hs9X
        3I3dwp4YzG8v8fU687T6XoGRESnLaAChXqV2UGSr7VI2eLo2Keloj0QS5F65wD1TSYR2jF
        oksD3/f5+kZuCrPQ5LBQPjcfoQYOR/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653472495;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dPoS6tTAzIT9GSFsK8tCzq7kbDmsveydGcvIwarTytA=;
        b=lN1mOZV9aXbyK27wkYZ9cwLkzKm26QxFl6d2qoypigGEcbwgZ3FDF7xfUh9AvsOOXngj9m
        KW3GLx6mOEI/d4Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7E60513487;
        Wed, 25 May 2022 09:54:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +H/RG+/8jWJbYAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 25 May 2022 09:54:55 +0000
Message-ID: <bc8bea8b-2cdf-4d41-65b0-5c2bf28457d2@suse.de>
Date:   Wed, 25 May 2022 11:54:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCHv12 00/11] nvme: In-band authentication support
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20220518112234.24264-1-hare@suse.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220518112234.24264-1-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/18/22 13:22, Hannes Reinecke wrote:
> Hi all,
> 
> recent updates to the NVMe spec have added definitions for in-band
> authentication, and seeing that it provides some real benefit
> especially for NVMe-TCP here's an attempt to implement it.
> 
> Thanks to Nicolai Stange the crypto DH framework has been upgraded
> to provide us with a FFDHE implementation; I've updated the patchset
> to use the ephemeral key generation provided there.
> 
> Note that this is just for in-band authentication. Secure
> concatenation (ie starting TLS with the negotiated parameters)
> requires a TLS handshake, which the in-kernel TLS implementation
> does not provide. This is being worked on with a different patchset
> which is still WIP.
> 
> The nvme-cli support has already been merged; please use the latest
> nvme-cli git repository to build the most recent version.
> 
> A copy of this patchset can be found at
> git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel
> branch auth.v12
> 
> It is being cut against the latest master branch from Linus.
> 
> As usual, comments and reviews are welcome.
> 
How do we proceed here?
This has been lingering for quite some time now, without any real 
progress. Despite everyone agreeing that we would need to have it.
Anything which is missing from my side?
Any other obstacles?

Thanks.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
