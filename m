Return-Path: <SRS0=SXL7=D3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB24C388F7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 19:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A17522282
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 19:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FIVPt1C3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438312AbgJTTp7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Oct 2020 15:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438310AbgJTTp7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Oct 2020 15:45:59 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527A0C0613CE;
        Tue, 20 Oct 2020 12:45:59 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id b11so1481636qvr.9;
        Tue, 20 Oct 2020 12:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sK1elVQQ2NrMHu7mvagLbiYZu4C55oZZTQPkobK5nAA=;
        b=FIVPt1C3GPLD58Aht5yhIbLIJzNX1qLh/+8Y2D5jFcbJl2GUjJEul+B2u4Keysi+Ky
         Iuh/wpq2xu1ui3HpmYredW8rivQt7akCpk0zKxvOoNMgUW25Y2d3paLZ8M1ycZf3qIs7
         avn7T9rIG7z+VrDrkEbD2GKZiQqm+4u7k8Dxi8tIB+HKs/LjjtNSbzx1EuH7/x3QzDig
         gKhbkPbTPSV7Gm10JqoQZIKw4B71WL9jJCTMdgTIFn10CZOofjF3hyPMVhoautKpzc1G
         tPOKDXSlCFdnhOKIJIblN6LMGHeN8/pDAlP3dhn9iddLufrTnXv80QunczIh8o5GteTX
         Krgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=sK1elVQQ2NrMHu7mvagLbiYZu4C55oZZTQPkobK5nAA=;
        b=jOlzJf3Mh44Lya107tG9aTgtsCcsODz9Q3/mXQfkmPEBskGSc88dhNn8uNZ0otiCa7
         9DOkcD61AqPseXHemIp3RO86QnBwujA06pWvNPQw4ukibCyLvnwKPlYcyF/Uov6XytV/
         zNN5KBMeQbguZBAoX0r77gUi94S9VH/veoX+xJ6rdC3EzAcBRc3m4bGkogv0a/T2gihd
         iNl4QTVn/U+CQiJZ/588Q7Rx8PmQzCYubSxPdsMKo1qlZrbEFZyZ8a2zNhkV7bx4Re9I
         4B0wFCIqAQpxFB/N+QMyt0eph8siZ9xIR2Rr2Ir9KnMaWOUQxVOh6nmQiJR0Z63/AEfY
         6PIw==
X-Gm-Message-State: AOAM531T880ck/WvSdtezjtKOyPGbWPr9QtyEPT+etx5Z9rIg+dVJ/W4
        2bHaC1FaPd0tRELrt5R96nAs6SEFu82RDg==
X-Google-Smtp-Source: ABdhPJxELK7oZ0oYWJ0WnphNoAGjBJqnGvEKQxdUVArKHywaT4exP6kWtSzC21mDExeS+Ye2rbpHMA==
X-Received: by 2002:ad4:4701:: with SMTP id k1mr5058780qvz.47.1603223158412;
        Tue, 20 Oct 2020 12:45:58 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id z26sm1276353qtb.85.2020.10.20.12.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 12:45:57 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Tue, 20 Oct 2020 15:45:55 -0400
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Arvind Sankar' <nivedita@alum.mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] crypto: lib/sha256 - Unroll SHA256 loop 8 times
 intead of 64
Message-ID: <20201020194555.GA3464628@rani.riverdale.lan>
References: <20201019153016.2698303-1-nivedita@alum.mit.edu>
 <20201019153016.2698303-5-nivedita@alum.mit.edu>
 <1324eb3519d54ddd9469d30a94c11823@AcuMS.aculab.com>
 <20201020140726.GB2996696@rani.riverdale.lan>
 <6ee12f8fa3914fbcb5e4a1388e430acd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6ee12f8fa3914fbcb5e4a1388e430acd@AcuMS.aculab.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 20, 2020 at 02:55:47PM +0000, David Laight wrote:
> From: Arvind Sankar
> > Sent: 20 October 2020 15:07
> > To: David Laight <David.Laight@ACULAB.COM>
> > 
> > On Tue, Oct 20, 2020 at 07:41:33AM +0000, David Laight wrote:
> > > From: Arvind Sankar> Sent: 19 October 2020 16:30
> > > > To: Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>; linux-
> > > > crypto@vger.kernel.org
> > > > Cc: linux-kernel@vger.kernel.org
> > > > Subject: [PATCH 4/5] crypto: lib/sha256 - Unroll SHA256 loop 8 times intead of 64
> > > >
> > > > This reduces code size substantially (on x86_64 with gcc-10 the size of
> > > > sha256_update() goes from 7593 bytes to 1952 bytes including the new
> > > > SHA256_K array), and on x86 is slightly faster than the full unroll.
> > >
> > > The speed will depend on exactly which cpu type is used.
> > > It is even possible that the 'not unrolled at all' loop
> > > (with the all the extra register moves) is faster on some x86-64 cpu.
> > 
> > Yes, I should have mentioned this was tested on a Broadwell Xeon, at
> > least on that processor, no unrolling is a measurable performance loss.
> > But the hope is that 8x unroll should be generally enough unrolling that
> > 64x is unlikely to speed it up more, and so has no advantage over 8x.
> 
> (I've just looked at the actual code, not just the patch.)
> 
> Yes I doubt the 64x unroll was ever a significant gain.
> Unrolling completely requires a load of register moves/renames;
> probably too many to be 'zero cost'.
> 
> With modern cpu you can often get the loop control instructions
> 'for free' so unrolling just kills the I-cache.
> Some of the cpu have loop buffers for decoded instructions,
> unroll beyond that size and you suddenly get the decoder costs
> hitting you again.
> 
> ...
> > > If you can put SHA256_K[] and W[] into a struct then the
> > > compiler can use the same register to address into both
> > > arrays (using an offset of 64*4 for the second one).
> > > (ie keep the two arrays, not an array of struct).
> > > This should reduce the register pressure slightly.
> > 
> > I can try that, could copy the data in sha256_update() so it's amortized
> > over the whole input.
> 
> Having looked more closely the extra copy needed is probably
> bigger than any saving.
> 

On x86-64 it doesn't make much difference, but it speeds up x86-32 by
around 10% (on long inputs).
