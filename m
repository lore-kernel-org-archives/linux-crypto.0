Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7998C48BD1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 16:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA8961181
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 16:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhFKQYk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 12:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhFKQYk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 12:24:40 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159C1C0617AF
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jun 2021 09:22:42 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id f30so9400916lfj.1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jun 2021 09:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O7VLGpzo0pic/uCZ5FLPezepVfzXChJpgysJmVZaFsc=;
        b=J/Dt9jQa1QKH8awC7zPDGpIDCC1B4T52bk/xbJkYWmrsyiPBf1xyBpuuJ6YktX8o19
         OGXWD4ofRJ+1Y/e3NXpAm87lNARcyx+eUZLb2kGvTbni8Z4d4UmVsZbpfpQ1wYz+9Ynn
         Tu2YFuveWjy2F/JCy1EWycl4zSkeUBSU/byuI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O7VLGpzo0pic/uCZ5FLPezepVfzXChJpgysJmVZaFsc=;
        b=TwXuIVICd22R/qN57MWlKHqtI+I8mBy/Kd51Fqy/qZxupnPYZEB0oVMqvxgVhBgqVN
         juvRURSfuoGwsOlheQejl2LaXLJDIN/UjINJpU1eii4IkLo8XETfddEN8S1lUGJF9O2P
         CTRVDYJuJmxpZrRoLsa23QP3ZS4YfaGCnUMBO33mhzHb1LJBilsE0CillNaCFM1vWDJ5
         zCX8/OMEWqmOxQg8AI28ECzxBNJ+BwOLnfId46Gi/xFZF/YRMipxvye/D5BWQYSUqkVu
         xKpBwpKDSkT6zh7Q/xQnBQPkIRWu8x5xqnjVpldDKJJanLmgYZeIwkETDmMf73nhk5UD
         1/BA==
X-Gm-Message-State: AOAM531Yej/+6Cqt10BnGr5TFjyB7Qksf5Z66ARHoEe/0rBEc/ggAcH1
        YDIpKmv9tbXXsvHkrZF/xi46a0zoTNCZP2zV4b0=
X-Google-Smtp-Source: ABdhPJzYVOgVTgEhDdH9AOkaJ7v66TE3XzEFcPS4P2xnlJG8YShtPBjZsktOcCBekR2GJ5E4PQ3aBg==
X-Received: by 2002:a19:ed04:: with SMTP id y4mr3140783lfy.562.1623428560163;
        Fri, 11 Jun 2021 09:22:40 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id h22sm774252ljk.133.2021.06.11.09.21.59
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 09:22:12 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id r16so10540986ljc.0
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jun 2021 09:21:59 -0700 (PDT)
X-Received: by 2002:a2e:c52:: with SMTP id o18mr3611750ljd.411.1623428518600;
 Fri, 11 Jun 2021 09:21:58 -0700 (PDT)
MIME-Version: 1.0
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local> <YL7XXNOnbaDgmTB9@atmark-techno.com>
 <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com> <20210611062153.GA30906@lst.de>
 <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
In-Reply-To: <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 11 Jun 2021 09:21:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgxgTB=G7P6KRneAd0s310WYK2NDisXM5P-wsNibgLrQA@mail.gmail.com>
Message-ID: <CAHk-=wgxgTB=G7P6KRneAd0s310WYK2NDisXM5P-wsNibgLrQA@mail.gmail.com>
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb) stable/for-linus-5.12)
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        jianxiong Gao <jxgao@google.com>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Hartmann <lukas@mntmn.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 11, 2021 at 3:35 AM Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> Linus,
>
> Would you be terribly offended if I took your code (s/unsigned
> long/unsigned int), and used Chanho's description of the problem (see below)?

No offense to that at all - that looks like the right solution. See my
answer to Christoph: I do think my patch does the right one, but I
can't test it and my knowledge of the swiotlb code is not complete
enough to really do anything else than "this looks right".

And adding my sign-off to the patch is fine, but I don't necessarily
need the authorship credit - mine was a throw-away patch just looking
at what the bisection report said. All the real effort was by the
reporters (and for the commit message, Bumyong Lee & co).

Finally - looking at the two places that do have that
swiotlb_align_offset(), my reaction is "I don't understand what that
code is doing".

The index does that

        index = find_slots(dev, orig_addr, alloc_size + offset);

so that offset does seem to depend on how the find_slots code works.
Which in turn does use the same dma_get_min_align_mask() thing that
swiotlb_align_offset() uses.  So the offsets do seem to match, but
find_slots(dev() does a lot of stuff that I don't know. so...

IOW, it does reinforce my "I don't know this code AT ALL". Which just
makes me more convinced that I shouldn't get authorship of the patch
because if something goes wrong with it, I can't help.

So at most maybe a "Suggested-by:".

My patch really was based on very little context and "this is the
calculation that makes sense given the other calculations in the
function".

              Linus
