Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEBFC2B9F4
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jun 2021 21:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65CFA61374
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jun 2021 21:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhFVWAg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jun 2021 18:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhFVWAg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jun 2021 18:00:36 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6906EC061574;
        Tue, 22 Jun 2021 14:58:18 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id q64so134022qke.7;
        Tue, 22 Jun 2021 14:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=An1CO7YkpX2LBRNnkvDhYRhDtsz5fNak0K0KltYMWHE=;
        b=G9hBpWsQA2qNJz6g8CmPS+fbzFFLh6rh7G15fLU4ZxcRyaU3QSU29x7NyPYmR8Ia/D
         n2B54HijZUbq2DwnXWIWTFpUjhpze+X82aSP8/LcdWVkRmYDlQxoRlHKyIo+qqE8FP9Q
         bZJ9oAe/6/gP2bUYJ5ZFFroBuXxolJekjgy3qddtVuXERWKt1Jcy1EIQjqWkw0C51ysM
         haXf2JVkp1uwcRw012LkgvKNWWUzIMpmOT1ctB0SsxOitZmrdQ5OIq+Lf5VI1fWUL5+I
         R8kn030r+rgR07DGG1Tpi11b0k3Is/XKRw94yDYcdtEwn5ozVyEdHEmcFv6vnQqH4GC8
         /eug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=An1CO7YkpX2LBRNnkvDhYRhDtsz5fNak0K0KltYMWHE=;
        b=cPSWQUPKae+7A9FpH4a/gbGtdFxDau0C8/9rqp0Hdg0T7fiO+tFDTqwv4RBUpAtQ7A
         TD8dlNhiSGLe5upvWJh0dXsYjluO/x9fGN5dVjTabS2TxaMoC3kLrtHAhVQwkVwjtzf3
         r45a02ZGSmei8wiIacDr8fza5jvwNJJphWCGBgeMjM6kTYwFvIhw+fRkEnT61hYMLu8g
         UYLYQqKStAJIGO9fKYTyjyUIAM6njXAS2QgvcVx3Zk78DQIKX3yfwa0i9vysixZL6+a9
         +17pRCDO4hvauWql1doGOfU0jVed2gXJBEUeBPJqscI3TGSKSJNE761lB9m4eJg01Wq2
         IHAQ==
X-Gm-Message-State: AOAM53173WPW7j8JHTGHtQm40WPciy2QDp6N9bVxPiiXk+Bkti1+RCoR
        7t6yR0/3MvgVGogEnhLOBTyfqfVkmuaWWg==
X-Google-Smtp-Source: ABdhPJxrJylyDE4d1u5hNmra4JCUXIlB65RCzJZS6mL8q5Nn7+pP3O583qQWV0u07LTl8dOSRnF9RA==
X-Received: by 2002:a05:620a:4509:: with SMTP id t9mr6703948qkp.403.1624399097540;
        Tue, 22 Jun 2021 14:58:17 -0700 (PDT)
Received: from fedora ([130.44.160.152])
        by smtp.gmail.com with ESMTPSA id 85sm12802577qkl.46.2021.06.22.14.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 14:58:16 -0700 (PDT)
Sender: Konrad Rzeszutek Wilk <konrad.r.wilk@gmail.com>
Date:   Tue, 22 Jun 2021 17:58:14 -0400
From:   Konrad Rzeszutek Wilk <konrad@darnok.org>
To:     'Dominique MARTINET' <dominique.martinet@atmark-techno.com>
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
Message-ID: <YNJc9qxeIjy6VuLt@fedora>
References: <YMqZswFnSNKk4Z7B@atmark-techno.com>
 <20210617051232.GB27192@lst.de>
 <YMrfWBLsJxCRhX5U@atmark-techno.com>
 <CAMGD6P0=9RE1-q1WHkwR1jymK5jyvN6QgypQ2KgdvBQn0CUTHw@mail.gmail.com>
 <CGME20210621020328epcas2p207e9fa2df119730ceb993543621437d8@epcas2p2.samsung.com>
 <YM/zWyZlk1bzHWgI@atmark-techno.com>
 <2038148563.21624247281621.JavaMail.epsvc@epcpadp4>
 <YNASOEGsDxhFC8qJ@atmark-techno.com>
 <YNCROxI328u7IKdQ@fedora>
 <YNGVyOyD+CAMmPos@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNGVyOyD+CAMmPos@atmark-techno.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 22, 2021 at 04:48:24PM +0900, 'Dominique MARTINET' wrote:
> Konrad Rzeszutek Wilk wrote on Mon, Jun 21, 2021 at 09:16:43AM -0400:
> > The beaty of 'devel' and 'linux-next' is that they can be reshuffled and
> > mangled. I pushed them original patch from Bumyong there and will let
> > it sit for a day and then create a stable branch and give it to Linus.
> 
> Thanks, that should be good.
> 
> Do you want me to send a follow-up patch with the two extra checks
> (tlb_addr & (IO_TLB_SIZE -1)) > swiotlb_align_offset(dev, orig_addr)
> tlb_offset < alloc_size
> 
> or are we certain this can't ever happen?

I would love more patches and I saw the previous one you posted.

But we only got two (or one) weeks before the next merge window opens
so I am sending to Linus the one that was tested with NVMe and crypto
(see above).

That is the
https://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git/commit/?h=stable/for-linus-5.14

And then after Linus releases the 5.14 - I would love to take your
cleanup on top of that and test it?

> (I didn't see any hit in dmesg when I ran with these, but my opinion is
> better safe than sorry...)
> 
> 
> > Then I need to expand the test-regression bucket so that this does not
> > happen again. Dominique, how easy would it be to purchase one of those
> > devices?
> 
> My company is making such a device, but it's not on the market yet
> (was planned for august, with some delay in approvisionning it'll
> probably be a bit late), and would mean buying from Japan so I'm not
> sure how convenient that would be...
> 
> These are originally NXP devices so I assume Horia would have better
> suggestions, if you would?
> 
> 
> > I was originally thinking to create a crypto device in QEMU to simulate
> > this but that may take longer to write than just getting the real thing.
> > 
> > Or I could create some fake devices with weird offsets and write a driver
> > for it to exercise this.. like this one I had done some time ago that
> > needs some brushing off.
> 
> Just a fake device with fake offsets as a test is probably good enough,
> ideally would need to exerce both failures we've seen (offset in
> dma_sync_single_for_device like caam does and in the original mapping (I
> assume?) like the NVMe driver does), but that sounds possible :)

Yup. Working on that now.
> 
> 
> Thanks again!
> -- 
> Dominique
