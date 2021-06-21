Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF62DC49EA2
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jun 2021 13:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFCB461164
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jun 2021 13:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhFUNTF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Jun 2021 09:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhFUNTD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Jun 2021 09:19:03 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C13EC061574;
        Mon, 21 Jun 2021 06:16:48 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id g4so29036698qkl.1;
        Mon, 21 Jun 2021 06:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9XTlsTLlkBEYe8ol8LyyT7LEeIfS9A4b08iDrrekDpY=;
        b=PIRykwMfGGjSO6qdHCfr4joaEAUov0orGAxskj8/4IwUE9JkgEGsPwyZ4uVFVrCAKl
         gx4DI7WYSvqTHffT5X+Yqq7iWyWKCZzRbfivFCbeot6s2hriwbR/cqsSdiQ2fANdMWbS
         RE1GOcwvRGDnKpHdSwIsd2rVyxFwLft3HAYsnVy9UqMqSJvYBq7FMJ5vcw1qcdZRByvT
         i+c8Sa1aGBsX7xFow/gE44AahIVvryWi12YvetWwUgUeAjK8cCWdBLavaBGouC0FrV9D
         Lzx08oHVaXI3PmiPkIXTRUZKdNYRjxq56r1N9u50YiLgBx3xf5NXgh8tZONpzQkKHmUC
         zx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9XTlsTLlkBEYe8ol8LyyT7LEeIfS9A4b08iDrrekDpY=;
        b=VxDXY2T6qPsP1SQ8vCI9azPPhjrjYzoJqjA7XCLYCFRiodIY2azBUUyMTUQ6PhX0tZ
         zKgF3eoHvd7/kzmGa7tU2wKt4kLHEh9navz+PbM7zI/AZNWYE+X0t2tWi8sEglMFUxyk
         odzm1NIdMOewqLTUlHdlMb4gSCY2u/4IdTc4nqo+j7zSi8kXleQug2J6b3asOt3xzjN8
         bkYOS5Br2/9v0y/+JMb4rci1PseaLBKrVjh5v06aqUvMS3Hx+4YvIvlnR2VIkl5oF9/y
         emB/K8B5YQWKqbC2z9h7IxlZpHcZna64s6vqRf48HMvjE4JH/b4JDaxRtY1JgXCU48+j
         Lw/w==
X-Gm-Message-State: AOAM5318OE43aO359K+IGzuhHXvW+G9LgwIRZbXA3aNgT+qY+XNDrDNG
        I7N9UoB3zaGHh5zAQ2aYO1w=
X-Google-Smtp-Source: ABdhPJyDFz+1dqhOAcIIkMWa6Sliq8B7hHaFaIFozLG71wqA8DbP1fs2hyPnYIkqc7WIL219TwVIjQ==
X-Received: by 2002:a37:8407:: with SMTP id g7mr23434618qkd.123.1624281407788;
        Mon, 21 Jun 2021 06:16:47 -0700 (PDT)
Received: from fedora ([130.44.160.152])
        by smtp.gmail.com with ESMTPSA id h12sm9710218qkj.52.2021.06.21.06.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:16:46 -0700 (PDT)
Sender: Konrad Rzeszutek Wilk <konrad.r.wilk@gmail.com>
Date:   Mon, 21 Jun 2021 09:16:43 -0400
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
Message-ID: <YNCROxI328u7IKdQ@fedora>
References: <CAMGD6P1v2JoJoxSuAYL8UjdtCaLCc4K_7xzVkumspeb0qn=LBQ@mail.gmail.com>
 <YMqW+/gQvM+uWUTw@fedora>
 <YMqZswFnSNKk4Z7B@atmark-techno.com>
 <20210617051232.GB27192@lst.de>
 <YMrfWBLsJxCRhX5U@atmark-techno.com>
 <CAMGD6P0=9RE1-q1WHkwR1jymK5jyvN6QgypQ2KgdvBQn0CUTHw@mail.gmail.com>
 <CGME20210621020328epcas2p207e9fa2df119730ceb993543621437d8@epcas2p2.samsung.com>
 <YM/zWyZlk1bzHWgI@atmark-techno.com>
 <2038148563.21624247281621.JavaMail.epsvc@epcpadp4>
 <YNASOEGsDxhFC8qJ@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNASOEGsDxhFC8qJ@atmark-techno.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 21, 2021 at 01:14:48PM +0900, 'Dominique MARTINET' wrote:
> Chanho Park wrote on Mon, Jun 21, 2021 at 11:55:22AM +0900:
> > Sure. No problem. But, the patch was already stacked on Konrad's tree
> > and linux-next as well.
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git/commit/?h=devel/for-linus-5.14&id=33d1641f38f0c327bc3e5c21de585c77a6512bc6 
> 
> That patch is slightly different, it's a rewrite Konrad did that mixes
> in Linus' suggestion[1], which breaks things for the NVMe usecase
> Jianxiong Gao has.
> 
> [1] offset = (tlb_addr - mem->start) & (IO_TLB_SIZE - 1)
> 
> 
> Konrad is aware so I think it shouldn't be submitted :)

The beaty of 'devel' and 'linux-next' is that they can be reshuffled and
mangled. I pushed them original patch from Bumyong there and will let
it sit for a day and then create a stable branch and give it to Linus.

Then I need to expand the test-regression bucket so that this does not
happen again. Dominique, how easy would it be to purchase one of those
devices?

I was originally thinking to create a crypto device in QEMU to simulate
this but that may take longer to write than just getting the real thing.

Or I could create some fake devices with weird offsets and write a driver
for it to exercise this.. like this one I had done some time ago that
needs some brushing off.
