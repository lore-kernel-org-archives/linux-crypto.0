Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE724C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Feb 2022 13:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiBTNJc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Feb 2022 08:09:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiBTNJb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Feb 2022 08:09:31 -0500
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2C94ECD8
        for <linux-crypto@vger.kernel.org>; Sun, 20 Feb 2022 05:09:09 -0800 (PST)
Received: by mail-wr1-f53.google.com with SMTP id v12so22498978wrv.2
        for <linux-crypto@vger.kernel.org>; Sun, 20 Feb 2022 05:09:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/PIz1tzmMOUQbPkNfW2Uw27clUkmdEpzg1cGypJGe3g=;
        b=goc8D/yYBFDn+wd3rdxFsy+fJuqgNNStTlED4q/OkfNbgvpgX7P9U7ehvspnwuuTvl
         qf5Gr0MV6q5aSJL1lLtSVnm5L6v0gB9glD/ypB4A2QetSnpRE2YSCXRKLv/SsnjooVx4
         sHZzAhkBfgm7W7Y8XX7EdTnf4mz+XFJG9hFfZElfb29Hi/SQ2MxoUzajCzPNDjCue/ze
         Rlmcfxud+uejDZYeVEk114TNsnIRwbl9B/XrY4r/vi2sn/eoYS424FLdCqwCJSS52DUH
         gkbCD9YsTOmccoj5l2HwAoLxsObuKvZYuSVlirZAO3iYy18nE3E0B1RdJuGDvlfdw5n0
         uB/Q==
X-Gm-Message-State: AOAM5309ziIWEHodNt8cD2q/ULS5YUI2y0usiCT+cyTDIf6fLnlHSkPA
        hZwq6T9qW0d4BlA+HNvUkPw=
X-Google-Smtp-Source: ABdhPJxHokMErjOzNjOm2cLpNQzOzj0CfrBnH8zhWpDTs6Vnh7wtC/SCMSYxDzckLRJd8quRPAg+Wg==
X-Received: by 2002:adf:f448:0:b0:1e3:2bfe:8e5 with SMTP id f8-20020adff448000000b001e32bfe08e5mr12160249wrp.130.1645362548116;
        Sun, 20 Feb 2022 05:09:08 -0800 (PST)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id t2sm28954710wrr.55.2022.02.20.05.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 05:09:07 -0800 (PST)
Message-ID: <1d1522c6-7f6b-7023-9e66-a05ac5a5a0be@grimberg.me>
Date:   Sun, 20 Feb 2022 15:09:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCHv8 00/12] nvme: In-band authentication support
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
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
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <e2ccd5bf-c13f-8660-c4c0-31a1053846ed@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>>>>>>> Question is how to continue from here; I can easily rebase my 
>>>>>>> patchset
>>>>>>> and send it relative to Nicolais patches. But then we'll be bound to
>>>>>>> the acceptance of those patches, so I'm not quite sure if that's the
>>>>>>> best way to proceed.
>>>>>>
>>>>>> Don't know if we have a choice here... What is the alternative you 
>>>>>> are
>>>>>> proposing?
>>>>>
>>>>> That's the thing, I don't really have a good alternative, either.
>>>>> It's just that I have so no idea about the crypto subsystem, and
>>>>> consequently wouldn't know how long we need to wait...
>>>>>
>>>>> But yeah, Nicolais patchset is far superior to my attempts, so I'd be
>>>>> happy to ditch my preliminary attempts there.
>>>>
>>>> Can we get a sense from the crypto folks to the state of Nicolais
>>>> patchset?
>>>
>>> According to Nicolai things look good, rules seem to be that it'll be
>>> accepted if it has positive reviews (which it has) and no-one objected
>>> (which no-one did).
>>> Other than that one would have to ask the maintainer.
>>> Herbert?
>>
>> Any updates on this?
> 
> Sigh.
> 
> Herbert suggested reworking the patch, and make ffdhe a separate 
> algorithm (instead of having enums to specify the values for the 
> existing DH algorithm).
> Discussion is ongoing :-(

Hannes and co,

Do you know what is the state of this dependency? Or when should
we expect to revisit this patch set?
