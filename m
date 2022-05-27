Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE9BC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 27 May 2022 10:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241726AbiE0KWC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 06:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiE0KWC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 06:22:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8573F5F8F4
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 03:22:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4119D1F916;
        Fri, 27 May 2022 10:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653646920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QpiKqWZVtYeezTU24EvdDLlhApiuU/F6GkO8aX8b2Q=;
        b=wiom1hyeLpOv6kzRQwY7O9W5gOAOyaVrzlUS7O21Q2ay+72tEw4Avnkh7xyAUzpyeluq9i
        tn+Epl0tDBH2959w+f5p5UZqeIuJxc94cKjnzwa2FudBTuWNuIkM8qAXpM99Tb8lHZNT9z
        rzhFtwu8bz3edC/iIfs6tt5PJF2wVdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653646920;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QpiKqWZVtYeezTU24EvdDLlhApiuU/F6GkO8aX8b2Q=;
        b=VlZd5+IwT8aoVoVNj+RIs/zj+hUwIQ9xHrSdKgKPiEzHo3g7UDiUCUToWe7yDU52GYhHDI
        vNm7zBVCTzYz1bAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 255E813A84;
        Fri, 27 May 2022 10:22:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3ypgCEimkGIwawAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 May 2022 10:22:00 +0000
Message-ID: <c1114e13-79cd-364c-b9d2-7a149a642919@suse.de>
Date:   Fri, 27 May 2022 12:21:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCHv12 00/11] nvme: In-band authentication support
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20220518112234.24264-1-hare@suse.de>
 <bc8bea8b-2cdf-4d41-65b0-5c2bf28457d2@suse.de>
 <20220526090056.GA27050@lst.de>
 <99126556-65b8-d0eb-bcd5-7b850493b51f@suse.de>
 <YpCis+8bv/EJqdlc@gondor.apana.org.au>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <YpCis+8bv/EJqdlc@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/27/22 12:06, Herbert Xu wrote:
> On Fri, May 27, 2022 at 07:50:42AM +0200, Hannes Reinecke wrote:
>> On 5/26/22 11:00, Christoph Hellwig wrote:
>>> On Wed, May 25, 2022 at 11:54:54AM +0200, Hannes Reinecke wrote:
>>>> How do we proceed here?
>>>> This has been lingering for quite some time now, without any real progress.
>>>
>>> As said it is a high priority for the upcoming merge window.  But we
>>> also really need reviews from the crypto maintainers for the crypto
>>> patches, without that I can't merge the series even if I'd like to.
>>
>> Hmm. Guess I can remove those helpers; after all,
>> both are just wrappers around existing exported helpers.
>> I'll resend.
> 
> I've just acked those two patches.
> 
Ah. Thanks for this.

Christoph, you can pick either v12 or v13; the difference is just the 
check for available hash and kpp functions. v12 has the dynamic version
using the crypto helpers, v13 has the static version checking 
compile-time configuration.
Either way would work.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
