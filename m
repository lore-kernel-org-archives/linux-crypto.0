Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D358C48BE5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jun 2021 23:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D0776115A
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jun 2021 23:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFVXGn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jun 2021 19:06:43 -0400
Received: from gw2.atmark-techno.com ([35.74.137.57]:38358 "EHLO
        gw2.atmark-techno.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhFVXGl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jun 2021 19:06:41 -0400
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id 46DB320CB3
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jun 2021 08:04:23 +0900 (JST)
Received: by mail-pl1-f197.google.com with SMTP id l10-20020a17090270cab029011dbfb3981aso8713plt.22
        for <linux-crypto@vger.kernel.org>; Tue, 22 Jun 2021 16:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zi+YumSK8qJAN2mxkpNMysen7VAorvJsTi6oKg7UA3c=;
        b=FbD+uxUl5LrJvPffeRVs4Og59ge5eSz1hymjjgTliKy+9RVDmetT9GE+yva0KFLLud
         prmFtD8VUACcEN8qeHSWCjsxQCOY3WUsSjwYiCajZPZAuRUlFs0BNR12UsjUJ6eKi7Lu
         zk51yIxcIjrxhw+OTYyPyZhfNxF0wNCvpE6Dn0IXQ42JpPZbITmLrP6nLSmWL/xFtoc6
         jYqAriBkNCFInr1y+WujYbx+b6nOiJaIdMpDMjYv/s6FtssqhbUhqLm4S35WyIsv0Hy9
         IIfuHtmcmszBkpeKo6qWflHej7Rv9z5tby9M3T7+N95/MAIwD9Dob5txQoAqmFOKKRL8
         W5ag==
X-Gm-Message-State: AOAM533YfY0imAdXvIun+kLUles8/Vg9uqLClV27v26J5sws2iHINbOo
        ONdWTOgbVM1DRv5Roap3RMZOTTAFJS4gVB6ehd8b0CoaYxVQAh4EK+0LLDUjrHx9ETEjasEoRxp
        Iv0/rS0SZwIDfs1v/mhYPEOnGyw==
X-Received: by 2002:a63:f4b:: with SMTP id 11mr931666pgp.250.1624403062419;
        Tue, 22 Jun 2021 16:04:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1DPt62WJkfxA5t0B59dYOyebgMR0VQB3YdAJXalVVOArvyr9AtZ9hq+qnqQudOs5PrJkKPw==
X-Received: by 2002:a63:f4b:: with SMTP id 11mr931650pgp.250.1624403062198;
        Tue, 22 Jun 2021 16:04:22 -0700 (PDT)
Received: from pc-0115 (178.101.200.35.bc.googleusercontent.com. [35.200.101.178])
        by smtp.gmail.com with ESMTPSA id 206sm326731pfv.108.2021.06.22.16.04.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jun 2021 16:04:21 -0700 (PDT)
Received: from martinet by pc-0115 with local (Exim 4.94.2)
        (envelope-from <martinet@pc-0115>)
        id 1lvpRM-002Ue5-4i; Wed, 23 Jun 2021 08:04:20 +0900
Date:   Wed, 23 Jun 2021 08:04:10 +0900
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
Message-ID: <YNJsar/EYmCeTO3S@atmark-techno.com>
References: <20210617051232.GB27192@lst.de>
 <YMrfWBLsJxCRhX5U@atmark-techno.com>
 <CAMGD6P0=9RE1-q1WHkwR1jymK5jyvN6QgypQ2KgdvBQn0CUTHw@mail.gmail.com>
 <CGME20210621020328epcas2p207e9fa2df119730ceb993543621437d8@epcas2p2.samsung.com>
 <YM/zWyZlk1bzHWgI@atmark-techno.com>
 <2038148563.21624247281621.JavaMail.epsvc@epcpadp4>
 <YNASOEGsDxhFC8qJ@atmark-techno.com>
 <YNCROxI328u7IKdQ@fedora>
 <YNGVyOyD+CAMmPos@atmark-techno.com>
 <YNJc9qxeIjy6VuLt@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YNJc9qxeIjy6VuLt@fedora>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Konrad Rzeszutek Wilk wrote on Tue, Jun 22, 2021 at 05:58:14PM -0400:
> On Tue, Jun 22, 2021 at 04:48:24PM +0900, 'Dominique MARTINET' wrote:
> > Thanks, that should be good.
> > 
> > Do you want me to send a follow-up patch with the two extra checks
> > (tlb_addr & (IO_TLB_SIZE -1)) > swiotlb_align_offset(dev, orig_addr)
> > tlb_offset < alloc_size
> > 
> > or are we certain this can't ever happen?
> 
> I would love more patches and I saw the previous one you posted.
> 
> But we only got two (or one) weeks before the next merge window opens
> so I am sending to Linus the one that was tested with NVMe and crypto
> (see above).
> 
> That is the
> https://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git/commit/?h=stable/for-linus-5.14
> 
> And then after Linus releases the 5.14 - I would love to take your
> cleanup on top of that and test it?

That sounds good to me, will send with proper formatting after release.

-- 
Dominique
