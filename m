Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC70C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Mar 2022 06:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbiCNGzm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Mar 2022 02:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbiCNGzm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Mar 2022 02:55:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF413FBCB
        for <linux-crypto@vger.kernel.org>; Sun, 13 Mar 2022 23:54:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3EAD01F37E;
        Mon, 14 Mar 2022 06:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647240869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0IIs81W2FxeUevWdsCGWllIVGXXDkTFcUp7md2mozlg=;
        b=ZJvpx/7JuYqhVFrlHQXQrjK07+ZIDN9fdfuJ9zV4m9C10f4XsT9jvK3C6yuMPHaWoMvhTW
        yui3Oybn02d7L2nIQ3qMiyz72zIZWMpVctqaOxt+bv/UuKJEVohBTRv43L7K9oWk9wsGqI
        Jd2XK8u5Zdnqv0XiPFpWfcW/ozl8DzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647240869;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0IIs81W2FxeUevWdsCGWllIVGXXDkTFcUp7md2mozlg=;
        b=6T2pD+JRAsWpPXPYUxJOWUkkMIx4gVlWXWK9NlNRpkgb5x1WtEr6dQVR2Osjkr9hXKKytf
        oddnuAKkuRn6S6BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 050A613ADA;
        Mon, 14 Mar 2022 06:54:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QARPO6TmLmLJMgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 14 Mar 2022 06:54:28 +0000
Message-ID: <e9b43c80-0eb7-99ae-55d5-aca9bf2a308b@suse.de>
Date:   Mon, 14 Mar 2022 07:54:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCHv8 00/12] nvme: In-band authentication support
Content-Language: en-US
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Niolai Stange <nstange@suse.com>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211213080853.GA21223@lst.de>
 <9853d36a-036c-7f2b-5fb4-b3fb4bae473f@suse.de>
 <4328e4f0-9674-9362-4ed5-89ec7edba4a2@grimberg.me>
 <56f1ce1c-2272-bed2-fd6b-642854b612bb@suse.de>
 <483836f5-f850-6eac-8c38-3f03db3189ab@grimberg.me>
 <0c4613ff-ba30-c812-a6e9-1954d77b1d1b@suse.de>
 <ad9af172-4b7b-4206-feab-8ab54ba7cfe5@grimberg.me>
 <e2ccd5bf-c13f-8660-c4c0-31a1053846ed@suse.de>
 <1d1522c6-7f6b-7023-9e66-a05ac5a5a0be@grimberg.me>
 <ac3056fe-e5bb-92cb-2d4f-a86c04117e5d@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <ac3056fe-e5bb-92cb-2d4f-a86c04117e5d@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/13/22 22:33, Sagi Grimberg wrote:
> 
>> Hannes and co,
>>
>> Do you know what is the state of this dependency? Or when should
>> we expect to revisit this patch set?
> 
> Ping?

Pondering what the next steps should be. Herbert Xu has merged Nicolais 
patchset, so I _could_ submit the patches, but then I would need to base 
it on Herberts cryptodev-2.6 branch.
And without these patches my patchset won't compile.
So no sure how to proceed; sending the patches relative to Herberts 
tree? Waiting for the patches to appear upstream? Not sure what'll be 
best...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
