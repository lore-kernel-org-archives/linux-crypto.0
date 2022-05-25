Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E234C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 25 May 2022 10:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbiEYKhq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 May 2022 06:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiEYKhp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 May 2022 06:37:45 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0519346C
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 03:37:44 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id 67-20020a1c1946000000b00397382b44f4so3079238wmz.2
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 03:37:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pyIdYTdUZwKmyF7GRjFGTDPirurocFZ70YWrVGnMIrs=;
        b=5aI21qDskXX2Ud1vZaixuuJZM/bZeL2hALPi5A8hS7cR2VFZ3csyEf6ZV2IM6GoMlL
         44wG+JKw2rSkvnifCmONXO9L+Ycc28j1pVKt2bfIQBTWzpVBXL3Lu6rmJg6/7s9C2JgC
         RMCDOizgh/Bfx2SfgVRO1k7xgve+xlxJTjZcIJVo+t+bYDga36xLDNlfK+0jHVuRAEIj
         +YQzHFcxjdpJoS8dOF23C16uJFmBQqZWXEeUEBdPGT4Pp8Q/2r8DQpTcfFNbmxc6yxU1
         P9cdTTtz79fTblwiFMpy7JDcy0ibWmc1RyNjRDPwJIP84h7wEU8PZHW+KpXz2VU451IS
         x22w==
X-Gm-Message-State: AOAM533tV0uGA5Fmt7qQbH8GBQh5pfX0vnIFq0ydIt0kbjXi/t9JIXQ9
        IjmKIXf0wYvDC+A9L2JtcvE=
X-Google-Smtp-Source: ABdhPJyBT7m/jA8uuy6Utfj+LkQCQBC1BaCndTfi4ilJDfEx94eJyf1CeGHxZqCr96UDZmI3HQeyVA==
X-Received: by 2002:a05:600c:d4:b0:397:5dfa:d16c with SMTP id u20-20020a05600c00d400b003975dfad16cmr6206158wmm.182.1653475062905;
        Wed, 25 May 2022 03:37:42 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id t9-20020a05600c198900b003974cb37a94sm1509002wmq.22.2022.05.25.03.37.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 03:37:42 -0700 (PDT)
Message-ID: <8dd97d9c-f241-9ce8-2aea-a703cbda25b1@grimberg.me>
Date:   Wed, 25 May 2022 13:37:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCHv12 00/11] nvme: In-band authentication support
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
        linux-crypto@vger.kernel.org
References: <20220518112234.24264-1-hare@suse.de>
 <bc8bea8b-2cdf-4d41-65b0-5c2bf28457d2@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <bc8bea8b-2cdf-4d41-65b0-5c2bf28457d2@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>> Hi all,
>>
>> recent updates to the NVMe spec have added definitions for in-band
>> authentication, and seeing that it provides some real benefit
>> especially for NVMe-TCP here's an attempt to implement it.
>>
>> Thanks to Nicolai Stange the crypto DH framework has been upgraded
>> to provide us with a FFDHE implementation; I've updated the patchset
>> to use the ephemeral key generation provided there.
>>
>> Note that this is just for in-band authentication. Secure
>> concatenation (ie starting TLS with the negotiated parameters)
>> requires a TLS handshake, which the in-kernel TLS implementation
>> does not provide. This is being worked on with a different patchset
>> which is still WIP.
>>
>> The nvme-cli support has already been merged; please use the latest
>> nvme-cli git repository to build the most recent version.
>>
>> A copy of this patchset can be found at
>> git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel
>> branch auth.v12
>>
>> It is being cut against the latest master branch from Linus.
>>
>> As usual, comments and reviews are welcome.
>>
> How do we proceed here?
> This has been lingering for quite some time now, without any real 
> progress. Despite everyone agreeing that we would need to have it.
> Anything which is missing from my side?
> Any other obstacles?

I've been through it a number of times during the iterations, I feel
comfortable with it. I'd be more comfortable to get a second review
at least on this code.

But regardless, for the patches where it is missing:
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
