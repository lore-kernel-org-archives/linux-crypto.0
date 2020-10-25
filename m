Return-Path: <SRS0=H1lS=EA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC874C388F7
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 20:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F7D922284
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 20:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E+jvyzoe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418664AbgJYUSY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Oct 2020 16:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1418663AbgJYUSY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Oct 2020 16:18:24 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE980C061755;
        Sun, 25 Oct 2020 13:18:23 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id m9so5301834qth.7;
        Sun, 25 Oct 2020 13:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4uNUycYHnRpOc67Mp8vwXOgNXt47TgJImjX3H53BPeI=;
        b=E+jvyzoeV2+pKYSB9cSCEFLTqsYO5x9TsdHQBKXkK5wWp5DKQLaUfkHI+okykmw7Ke
         vu/rXzd/KCOT6QeO/kTrZtFXQM5w7kAPSg+1bitmwkOdxDfznn7xDJtiAtGwsxgP63li
         NVCtDCk+4ZBFSVSoRLOIGC4HmQ6EOu2rDxnuDj511c40Paj3rNcDdsN1Omg1DN+rDDfj
         B51QBz11DW2tEggHqwkH1sMcpSYO9y9S8ZlJe/PNCxuG1vp2YWMYId/PfXpISPTBiVzD
         hfdHq+q6BDR1/AMny0fDlG0BiTBeD6S7IBjbq6f6AEzx0k3SYHHL6iGyMYJaE+lCkIkK
         ZnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4uNUycYHnRpOc67Mp8vwXOgNXt47TgJImjX3H53BPeI=;
        b=JorTvTdouiNP5gYGQbZ4HXfwrTRM9yT82esVF9flcG2mAjCH73IS2DYk/Gu0EujKer
         m/6iPetgQhAdNA9Oymiy/OyPFTiEl6CNCppuQLi77T7ZMb3DYnBKJQzj61KEL0Nzhi0k
         4NOAF1ZFxzYxDhtTZ/LdfBTbjr9tfEKVanQwJBh7+Em3DHeOYRaUeA/45FEpMxuyJHZZ
         rpMeMDnMzk4OZT6ZnAKHXGxAmg+d6IN/Y4f/VifJPByb6Zlx7H7QWhzEHTqHLAwQvZ5Z
         +LXXtRvIgY5bk8Z5ypwo6oZYzOYmit51VFyf0t10ttn1MA8YlJHAf1daOoXxLzCPdo1A
         U8WA==
X-Gm-Message-State: AOAM530xh2vLNx6dXLg1hYbpBbGtG5U0AAxAtzvVIVAeIR/ORxaS13OZ
        COX7omNBigMKpWtS+jfUAns=
X-Google-Smtp-Source: ABdhPJxsRZ4TAY9yeYwNWSL1+hHB0sj8zbk6BjdfLfGKXhU+hPW6BbFF+sEKbnMJSnTk4bfll9g4gA==
X-Received: by 2002:ac8:3975:: with SMTP id t50mr13575931qtb.53.1603657102368;
        Sun, 25 Oct 2020 13:18:22 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id a20sm5568856qtk.67.2020.10.25.13.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 13:18:21 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Sun, 25 Oct 2020 16:18:20 -0400
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Arvind Sankar' <nivedita@alum.mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v4 6/6] crypto: lib/sha256 - Unroll LOAD and BLEND loops
Message-ID: <20201025201820.GA1237388@rani.riverdale.lan>
References: <20201025143119.1054168-1-nivedita@alum.mit.edu>
 <20201025143119.1054168-7-nivedita@alum.mit.edu>
 <05150bdb3a4c4b2682ab9cb8fb2ed411@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <05150bdb3a4c4b2682ab9cb8fb2ed411@AcuMS.aculab.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 25, 2020 at 06:51:18PM +0000, David Laight wrote:
> From: Arvind Sankar
> > Sent: 25 October 2020 14:31
> > 
> > Unrolling the LOAD and BLEND loops improves performance by ~8% on x86_64
> > (tested on Broadwell Xeon) while not increasing code size too much.
> 
> I can't believe unrolling the BLEND loop makes any difference.

It's actually the BLEND loop that accounts for almost all of the
difference. The LOAD loop doesn't matter much in general: even replacing
it with a plain memcpy() only increases performance by 3-4%. But
unrolling it is low cost in code size terms, and clang actually does it
without being asked.

> WRT patch 5.
> On the C2758 the original unrolled code is slightly faster.
> On the i7-7700 the 8 unroll is a bit faster 'hot cache',
> but slower 'cold cache' - probably because of the d-cache
> loads for K[].
> 
> Non-x86 architectures might need to use d-cache reads for
> the 32bit 'K' constants even in the unrolled loop.
> X86 can use 'lea' with a 32bit offset to avoid data reads.
> So the cold-cache case for the old code may be similar.

Not sure I follow: in the old code, the K's are 32-bit immediates, so
they should come from the i-cache whether an add or an lea is used?

Why is the cold-cache case relevant anyway? If the code is only being
executed a couple of times or so, i.e. you're hashing a single say
64-128 byte input once in a blue moon, the performance of the hash
doesn't really matter, no?

> 
> Interestingly I had to write an asm ror32() to get reasonable
> code (in userspace). The C version the kernel uses didn't work.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
