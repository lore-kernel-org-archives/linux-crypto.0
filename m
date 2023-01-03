Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771EEC4708D
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Jan 2023 19:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjACTJG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 14:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbjACTJA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 14:09:00 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E87113F34
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 11:08:59 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id z12so25304903qtv.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 11:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dfSqSd0mxRLyCP4JPwoGgPSv4V5DgFE+NWQibLY7nHY=;
        b=LQt5OMztUt6H+6pe/VIHwx3Jz4d08J1ZZ7gv40yLS2RfQ9FYAN2BdqaHFaDSeqruh5
         UdriUa0s5l2hHmuDgCVQyqdP1mZma/3SqbLGsgMr+3W5DNoGaGK3GwMdoJI3ZUgmswPc
         hfRjTsp+o7b/O9CFRqovudaZXidsusavosKQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dfSqSd0mxRLyCP4JPwoGgPSv4V5DgFE+NWQibLY7nHY=;
        b=5x6t2BG2qtrD5f7XL/IveF4SGDGgbq0276Qyryfgu/jEwNjNyPEiMmR+h0/KHF+1dU
         836/EcEp1LFCTEfqd8+x7Ya31uwryjB17msU0oiF+B4BB71osHq/pDSdYL9iCviyB0dI
         B27CYRnGbIIqhbNlUzwBK3+B8cY1R2nqGQSbqOHCF6lYz/Yi8aMsSI2kZxQFL7czqZSN
         jjRF5e72EJfetuLOCajABo8lsNwv8qRj7CnM56R7rwH3mfRTxsdwztVt5V79GDZDj8zr
         HHkw5EiwZX/nwizOC6SbsCOHpEvl2puq1JWV/W/61oiIZ96QQrrLxDL6BPCN5IV54Thg
         bX/Q==
X-Gm-Message-State: AFqh2kr3gB6DTOWsml7aTfihUTGAJPomVDuJv3dCBvCE9VNRQzx+i7kM
        lbmgsTjKtM1R3XO3FDJs606uB+ryGcCMIwfH
X-Google-Smtp-Source: AMrXdXtlvojQ5Cuc21uFJ9kayplhnz9nIEDSfplzQiQflws21D2hXMGNBgpxlfXyvmL1yKvSXeZPww==
X-Received: by 2002:ac8:7c99:0:b0:3a7:e727:a015 with SMTP id y25-20020ac87c99000000b003a7e727a015mr54166748qtv.20.1672772938375;
        Tue, 03 Jan 2023 11:08:58 -0800 (PST)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com. [209.85.160.181])
        by smtp.gmail.com with ESMTPSA id h24-20020ac87458000000b003a7ef7a758dsm19191213qtr.59.2023.01.03.11.08.56
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 11:08:57 -0800 (PST)
Received: by mail-qt1-f181.google.com with SMTP id v14so22523718qtq.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 11:08:56 -0800 (PST)
X-Received: by 2002:a05:620a:1379:b0:6fc:c48b:8eab with SMTP id
 d25-20020a05620a137900b006fcc48b8eabmr1650146qkl.216.1672772925520; Tue, 03
 Jan 2023 11:08:45 -0800 (PST)
MIME-Version: 1.0
References: <20221219153525.632521981@infradead.org> <20221219154119.550996611@infradead.org>
 <Y7Ri+Uij1GFkI/LB@osiris>
In-Reply-To: <Y7Ri+Uij1GFkI/LB@osiris>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 3 Jan 2023 11:08:29 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9nK825MyHXu7zkegc7Va+ZxcperdOtRMZBCLHqGrr=g@mail.gmail.com>
Message-ID: <CAHk-=wj9nK825MyHXu7zkegc7Va+ZxcperdOtRMZBCLHqGrr=g@mail.gmail.com>
Subject: Re: [RFC][PATCH 11/12] slub: Replace cmpxchg_double()
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, corbet@lwn.net,
        will@kernel.org, boqun.feng@gmail.com, mark.rutland@arm.com,
        catalin.marinas@arm.com, dennis@kernel.org, tj@kernel.org,
        cl@linux.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        joro@8bytes.org, suravee.suthikulpanit@amd.com,
        robin.murphy@arm.com, dwmw2@infradead.org,
        baolu.lu@linux.intel.com, Arnd Bergmann <arnd@arndb.de>,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        Andrew Morton <akpm@linux-foundation.org>, vbabka@suse.cz,
        roman.gushchin@linux.dev, 42.hyeyoo@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux.dev,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 3, 2023 at 9:17 AM Heiko Carstens <hca@linux.ibm.com> wrote:
>
> On Mon, Dec 19, 2022 at 04:35:36PM +0100, Peter Zijlstra wrote:
> >
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  include/linux/slub_def.h |   12 ++-
> >  mm/slab.h                |   41 +++++++++++--
> >  mm/slub.c                |  146 ++++++++++++++++++++++++++++-------------------
> >  3 files changed, 135 insertions(+), 64 deletions(-)
>
> Does this actually work? Just wondering since I end up with an instant
> list corruption on s390. Might be endianness related, but I can't see
> anything obvious at a first glance.

I don't see anything that looks related to endianness, because while
there is that 128-bit union member, it's always either used in full,
or it's accessed as other union members.

But I *do* note that this patch seems to be the only one that depends
on the new this_cpu_cmpxchg() updates to make it just automatically do
the right thing for a 128-bit value. And I have to admit that all
those games with __pcpu_cast_128() make no sense to me. Why isn't it
just using "u128" everywhere without any odd _Generic() games?

I could also easily see that if the asm constraints are wrong (like
the "cast pointer to (unsigned long *) instead of keeping it pointing
to a 128-bit type" thing discussed earlier), then code like this:

+       freelist_aba_t old = { .freelist = freelist_old, .counter = tid };
+       freelist_aba_t new = { .freelist = freelist_new, .counter =
next_tid(tid) };
+
+       return this_cpu_cmpxchg(s->cpu_slab->freelist_tid.full,
+                               old.full, new.full) == old.full;

would easily make the compiler go "the second word of 'old' is never
used by the asm, so I won't initialize it".

But yeah, that patch is hard to read, so hard to say. Does everything
leading up to it work fine?

                 Linus
