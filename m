Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F58C48BE5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jun 2021 04:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA05C61009
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jun 2021 04:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhFUERT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Jun 2021 00:17:19 -0400
Received: from gw2.atmark-techno.com ([35.74.137.57]:38860 "EHLO
        gw2.atmark-techno.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhFUERS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Jun 2021 00:17:18 -0400
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id 4572C20D07
        for <linux-crypto@vger.kernel.org>; Mon, 21 Jun 2021 13:15:03 +0900 (JST)
Received: by mail-pj1-f70.google.com with SMTP id om12-20020a17090b3a8cb029016a4ee7d56fso8894268pjb.7
        for <linux-crypto@vger.kernel.org>; Sun, 20 Jun 2021 21:15:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0cNPlfrR3mHT9UabyMptbK269y7CX6VJikwsTnrJUAE=;
        b=QJbcKQeChMZFWV/PBRTKRbmMpiT/g+uFzU5yYONhO1ActHr+x6AsjfWww2HD0q+H0H
         9wxrvo1z3+ngyxUMIBeeZGZrBFMtaWFwgkkRoH8XMQ5TMT6OQUoKztT4+QtdavnEhyAR
         dIoS5MVemyLwtnaOp8dnqbHyk1DctX60n4hWGRP1rZC0efbQoZEXk0ObuZExmmnFw/Et
         Hr5m/kOZirKn7fizVeT41ehGAFgtnkM4FQyyozyV3cvYCPv182jLlil7NlD4N5ktX3U/
         DL26DHv1IefRWkZUvHpXrYZb0lFLIJZq1I91+JhPE1enpO2UmPHkOqJgg/y1PIpaGvwB
         pV+A==
X-Gm-Message-State: AOAM533fJ/SEfgcPb5NfNXO/GXnTl7o7wnBoqB12n+Er5wV1o2Or1OZR
        3UH+ByiQRNBSt7bTYQyBtPU4r+aWEraYzjp/7hNGNGz2QTif7RBG4Im6WRPK4hS6l8M8L87b2V9
        oznS+mLR+wYnshC+wdEy6vTOpNA==
X-Received: by 2002:a63:db43:: with SMTP id x3mr21772895pgi.383.1624248902411;
        Sun, 20 Jun 2021 21:15:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwABzUQPm9SUU6k+/MVNgSXR0PAbNKc3mtW3pmxgxtF5tFRcVYbJO4+Phv3wJkMa6wTECEmiQ==
X-Received: by 2002:a63:db43:: with SMTP id x3mr21772865pgi.383.1624248902163;
        Sun, 20 Jun 2021 21:15:02 -0700 (PDT)
Received: from pc-0115 (117.209.187.35.bc.googleusercontent.com. [35.187.209.117])
        by smtp.gmail.com with ESMTPSA id t3sm1594918pfl.44.2021.06.20.21.15.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jun 2021 21:15:01 -0700 (PDT)
Received: from martinet by pc-0115 with local (Exim 4.94.2)
        (envelope-from <martinet@pc-0115>)
        id 1lvBKs-001Ecg-KK; Mon, 21 Jun 2021 13:14:58 +0900
Date:   Mon, 21 Jun 2021 13:14:48 +0900
From:   'Dominique MARTINET' <dominique.martinet@atmark-techno.com>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     'Jianxiong Gao' <jxgao@google.com>,
        'Christoph Hellwig' <hch@lst.de>,
        'Konrad Rzeszutek Wilk' <konrad@darnok.org>,
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
Message-ID: <YNASOEGsDxhFC8qJ@atmark-techno.com>
References: <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
 <CAMGD6P1v2JoJoxSuAYL8UjdtCaLCc4K_7xzVkumspeb0qn=LBQ@mail.gmail.com>
 <YMqW+/gQvM+uWUTw@fedora>
 <YMqZswFnSNKk4Z7B@atmark-techno.com>
 <20210617051232.GB27192@lst.de>
 <YMrfWBLsJxCRhX5U@atmark-techno.com>
 <CAMGD6P0=9RE1-q1WHkwR1jymK5jyvN6QgypQ2KgdvBQn0CUTHw@mail.gmail.com>
 <CGME20210621020328epcas2p207e9fa2df119730ceb993543621437d8@epcas2p2.samsung.com>
 <YM/zWyZlk1bzHWgI@atmark-techno.com>
 <2038148563.21624247281621.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2038148563.21624247281621.JavaMail.epsvc@epcpadp4>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Chanho Park wrote on Mon, Jun 21, 2021 at 11:55:22AM +0900:
> Sure. No problem. But, the patch was already stacked on Konrad's tree
> and linux-next as well.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git/commit/?h=devel/for-linus-5.14&id=33d1641f38f0c327bc3e5c21de585c77a6512bc6 

That patch is slightly different, it's a rewrite Konrad did that mixes
in Linus' suggestion[1], which breaks things for the NVMe usecase
Jianxiong Gao has.

[1] offset = (tlb_addr - mem->start) & (IO_TLB_SIZE - 1)


Konrad is aware so I think it shouldn't be submitted :)

-- 
Dominique
