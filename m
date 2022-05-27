Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB70C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 May 2022 05:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbiE0Fur (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 01:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235470AbiE0Fuq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 01:50:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7424FB481
        for <linux-crypto@vger.kernel.org>; Thu, 26 May 2022 22:50:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2EE0B1F8D5;
        Fri, 27 May 2022 05:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653630643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r847XQ0d5S6Cd8DX0ImmONalPnfrBt+aQgcTMcDUKpY=;
        b=liEf9Yn0Tny6FXfccUelxNNUnSJuL4PLFI6JFrX8kAP4nbOf0ZXYMd2DjW34kM+sdktAc4
        KJEwuoO6RvoaZgnV55sSX5RvQb8bXI7OJePMOXds8EV3CcZgt1UkqO7SKFxXH/n9AGspeN
        O60lkSDsWnYuXjeKNlIeK1GUWep6iUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653630643;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r847XQ0d5S6Cd8DX0ImmONalPnfrBt+aQgcTMcDUKpY=;
        b=hxDvBWsnrK3fab0i2YJq1kjvOq67cFqWjncQKb7pdLxO0gDJOrsv3hvH/ScQqsKGPqpsYX
        vHD6g7Yrz/OEq2Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0CAC21346B;
        Fri, 27 May 2022 05:50:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LlpLArNmkGKAAgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 May 2022 05:50:43 +0000
Message-ID: <99126556-65b8-d0eb-bcd5-7b850493b51f@suse.de>
Date:   Fri, 27 May 2022 07:50:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCHv12 00/11] nvme: In-band authentication support
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20220518112234.24264-1-hare@suse.de>
 <bc8bea8b-2cdf-4d41-65b0-5c2bf28457d2@suse.de>
 <20220526090056.GA27050@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220526090056.GA27050@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/26/22 11:00, Christoph Hellwig wrote:
> On Wed, May 25, 2022 at 11:54:54AM +0200, Hannes Reinecke wrote:
>> How do we proceed here?
>> This has been lingering for quite some time now, without any real progress.
> 
> As said it is a high priority for the upcoming merge window.  But we
> also really need reviews from the crypto maintainers for the crypto
> patches, without that I can't merge the series even if I'd like to.

Hmm. Guess I can remove those helpers; after all,
both are just wrappers around existing exported helpers.
I'll resend.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
