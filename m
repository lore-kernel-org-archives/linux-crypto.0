Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55F5C2B9F4
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jun 2021 07:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E596128A
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jun 2021 07:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFVHu4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jun 2021 03:50:56 -0400
Received: from gw2.atmark-techno.com ([35.74.137.57]:60098 "EHLO
        gw2.atmark-techno.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhFVHuz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jun 2021 03:50:55 -0400
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id 8BC9020D0B
        for <linux-crypto@vger.kernel.org>; Tue, 22 Jun 2021 16:48:39 +0900 (JST)
Received: by mail-pj1-f72.google.com with SMTP id 15-20020a17090a0f0fb029016ad0f32fd0so5024857pjy.6
        for <linux-crypto@vger.kernel.org>; Tue, 22 Jun 2021 00:48:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K2/PCim2TgrlrpWsUBXXxC0v9+AUPcQxYb8PsC1cUMs=;
        b=mGuauHMQ6rIYAF59vm4Eiw4oVj9i9gkuL2AYzV5jp29IRFIqOUYYJCcRUjCRN7um7J
         mJ/Uifnluokyg1167EZIGDM5SFUqBEQA3VUVVCZuX4JsseDoOUFOX4RkW6PnvVFJ9R9M
         F2oZzsLtY/t9DFTnYu1dXlqaFk9M1jmomoG9+eGRSARg++1culVKBD9cMTifzfEds3uB
         rZZYfS3t5m9bcskVIKQR+N1028/1jmwlXFXg+mY48PW0L8+0J7wF7k49e3ZXabgPXs8b
         h5mnGQDNYfyuRvDtz/Cu74Z19ZXi8/fCKZlKb3gXG29IcCTfymDCQwAi4mGvX0dLjE/r
         Ks1g==
X-Gm-Message-State: AOAM533/rfmjPO63S/SweJIfaAZD7lJDZX/17DNskfIl0aTEI3El9EbJ
        lD9kK7DmVH/uP8YeJ23TCaoQDCz8ATF5drowntIpBddhVOqHp39SGnPIWBvwHQsnluxyx2s7qEr
        sABwPH3SLDmxUxUEA++sTTi3z5A==
X-Received: by 2002:a17:90a:4812:: with SMTP id a18mr2670006pjh.40.1624348118681;
        Tue, 22 Jun 2021 00:48:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfgoRVVp6JmSP2/8H6vwINnTVMm7MriWlKRzk6O1jIIF/9JeL5ZPHTpSyHUlltCbzyiAQDkQ==
X-Received: by 2002:a17:90a:4812:: with SMTP id a18mr2669988pjh.40.1624348118458;
        Tue, 22 Jun 2021 00:48:38 -0700 (PDT)
Received: from pc-0115 (178.101.200.35.bc.googleusercontent.com. [35.200.101.178])
        by smtp.gmail.com with ESMTPSA id n12sm7972919pfu.5.2021.06.22.00.48.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jun 2021 00:48:37 -0700 (PDT)
Received: from martinet by pc-0115 with local (Exim 4.94.2)
        (envelope-from <martinet@pc-0115>)
        id 1lvb98-002Mj2-Pa; Tue, 22 Jun 2021 16:48:34 +0900
Date:   Tue, 22 Jun 2021 16:48:24 +0900
From:   'Dominique MARTINET' <dominique.martinet@atmark-techno.com>
To:     Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc:     Chanho Park <chanho61.park@samsung.com>,
        'Jianxiong Gao' <jxgao@google.com>,
        'Christoph Hellwig' <hch@lst.de>,
        'Konrad Rzeszutek Wilk' <konrad.wilk@oracle.com>,
        'Linus Torvalds' <torvalds@linux-foundation.org>,
        'Horia =?utf-8?Q?Geant=C4=83'?= <horia.geanta@nxp.com>,
        linux-kernel@vger.kernel.org, 'Lukas Hartmann' <lukas@mntmn.com>,
        'Aymen Sghaier' <aymen.sghaier@nxp.com>,
        'Herbert Xu' <herbert@gondor.apana.org.au>,
        "'David S. Miller'" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        'Marc Orr' <marcorr@google.com>,
        'Erdem Aktas' <erdemaktas@google.com>,
        'Peter Gonda' <pgonda@google.com>,
        'Bumyong Lee' <bumyong.lee@samsung.com>
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb)
 stable/for-linus-5.12)
Message-ID: <YNGVyOyD+CAMmPos@atmark-techno.com>
References: <YMqW+/gQvM+uWUTw@fedora>
 <YMqZswFnSNKk4Z7B@atmark-techno.com>
 <20210617051232.GB27192@lst.de>
 <YMrfWBLsJxCRhX5U@atmark-techno.com>
 <CAMGD6P0=9RE1-q1WHkwR1jymK5jyvN6QgypQ2KgdvBQn0CUTHw@mail.gmail.com>
 <CGME20210621020328epcas2p207e9fa2df119730ceb993543621437d8@epcas2p2.samsung.com>
 <YM/zWyZlk1bzHWgI@atmark-techno.com>
 <2038148563.21624247281621.JavaMail.epsvc@epcpadp4>
 <YNASOEGsDxhFC8qJ@atmark-techno.com>
 <YNCROxI328u7IKdQ@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YNCROxI328u7IKdQ@fedora>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Konrad Rzeszutek Wilk wrote on Mon, Jun 21, 2021 at 09:16:43AM -0400:
> The beaty of 'devel' and 'linux-next' is that they can be reshuffled and
> mangled. I pushed them original patch from Bumyong there and will let
> it sit for a day and then create a stable branch and give it to Linus.

Thanks, that should be good.

Do you want me to send a follow-up patch with the two extra checks
(tlb_addr & (IO_TLB_SIZE -1)) > swiotlb_align_offset(dev, orig_addr)
tlb_offset < alloc_size

or are we certain this can't ever happen?
(I didn't see any hit in dmesg when I ran with these, but my opinion is
better safe than sorry...)


> Then I need to expand the test-regression bucket so that this does not
> happen again. Dominique, how easy would it be to purchase one of those
> devices?

My company is making such a device, but it's not on the market yet
(was planned for august, with some delay in approvisionning it'll
probably be a bit late), and would mean buying from Japan so I'm not
sure how convenient that would be...

These are originally NXP devices so I assume Horia would have better
suggestions, if you would?


> I was originally thinking to create a crypto device in QEMU to simulate
> this but that may take longer to write than just getting the real thing.
> 
> Or I could create some fake devices with weird offsets and write a driver
> for it to exercise this.. like this one I had done some time ago that
> needs some brushing off.

Just a fake device with fake offsets as a test is probably good enough,
ideally would need to exerce both failures we've seen (offset in
dma_sync_single_for_device like caam does and in the original mapping (I
assume?) like the NVMe driver does), but that sounds possible :)


Thanks again!
-- 
Dominique
