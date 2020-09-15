Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05000C43461
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 06:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC5FF20829
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 06:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600152376;
	bh=8KMSM24PrVIDL1UF87zsxD8qGdF8aF40rlyoPLgdnRQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=f+lGrKb2mHFPKVvGzG40ecn3WwZEJql/Khjx41vTVcGCOHJF7psJBWElu4psmjZMn
	 YqkgMgTaxkQQKNCIJLQ7dUKyzrome7KUijyJShmxuAWrJj3kN7mokXWqBoM+tqvtzc
	 gENCbmkM2mF0Ke742efa4k/h4oB2CSyxYOPxan2I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgIOGqP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 02:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgIOGqO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 02:46:14 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E71C061788
        for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2020 23:46:12 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id x69so1922034lff.3
        for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2020 23:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Arb/NJZf3RvSWdo2XGt0U808ae95hYhvCHxGQOFhAuA=;
        b=TWMi96qFEmbnv+fzUE0tWqbV5DVfrHOErkfMfIFqS5M1qIyGrDe8yY56tUm90f2mt2
         1MfPGLB+0y+IvQ7tQ6g580mq/IxRLgQxsgNiC9hAdasNO6svhNHU3sYcADkA+JlxcUt/
         vcK+eibaxs1EQrdk12O8j9ZpbYquqyKtztHdE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Arb/NJZf3RvSWdo2XGt0U808ae95hYhvCHxGQOFhAuA=;
        b=f3cHL68TPJl5cX6EFrgfj6z+LGvmVxRAsQar/ZP7g3/5kJ7l+v53SiAJLkKeKJDPUu
         o0qiUfuE34wLdlOQNze4TWN+dkTh4DZYkGC7bsRiIYNs6T5iLs+fV/WnUpQPH2Iq4gj3
         CtXOt1EF9T3PA7OzV6SlxJMuVP6QS03rFdufP2DKIMg1leFtrAwII9qmn7uaSd7wmvyi
         XHnTOmzkTKYIGSgzCLnhNvdZr54kxPXx/rXOgwOsKelITS/bRvM0EL+i1ut0xYPnukqe
         cH9ltJD4CU6q87NESoBKJjw3K8E8kaToC6130PB8ORMHf/NKaA5ctHtwrv8T1DaWqFhF
         MFWw==
X-Gm-Message-State: AOAM532rebXnHdvNFWhKujDPve1iiPeaGywSCN5oIMXNUQL1Rvg1fmgC
        Qq12Z2C5hGojfidqt/+ncdGOyARhmfyQ/A==
X-Google-Smtp-Source: ABdhPJzpzk5Laz1Ao3ZQz0AnJLc+Np7RHo8sULx3uIk/3Lec1KOkw0Ag1R0HKweQPjBqtAzOtTtUTw==
X-Received: by 2002:a05:6512:3131:: with SMTP id p17mr4900054lfd.225.1600152370803;
        Mon, 14 Sep 2020 23:46:10 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id 78sm3394201lfi.81.2020.09.14.23.46.09
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 23:46:09 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id k25so1832578ljk.0
        for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2020 23:46:09 -0700 (PDT)
X-Received: by 2002:a05:651c:32e:: with SMTP id b14mr5804981ljp.314.1600152369175;
 Mon, 14 Sep 2020 23:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200914204209.256266093@linutronix.de> <CAHk-=win80rdof8Pb=5k6gT9j_v+hz-TQzKPVastZDvBe9RimQ@mail.gmail.com>
 <871rj4owfn.fsf@nanos.tec.linutronix.de> <CAHk-=wj0eUuVQ=hRFZv_nY7g5ZLt7Fy3K7SMJL0ZCzniPtsbbg@mail.gmail.com>
 <CAHk-=wjOV6f_ddg+QVCF6RUe+pXPhSR2WevnNyOs9oT+q2ihEA@mail.gmail.com> <20200915033024.GB25789@gondor.apana.org.au>
In-Reply-To: <20200915033024.GB25789@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 14 Sep 2020 23:45:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgX=ynJAXYYOAM7J8Tee8acERrGOopNu6ZcLN=SEXdGKA@mail.gmail.com>
Message-ID: <CAHk-=wgX=ynJAXYYOAM7J8Tee8acERrGOopNu6ZcLN=SEXdGKA@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - Set SG_MITER_ATOMIC unconditionally
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 14, 2020 at 8:30 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> There is no reason for the chacha20poly1305 SG miter code to use
> kmap instead of kmap_atomic as the critical section doesn't sleep
> anyway.  So we can simply get rid of the preemptible check and
> set SG_MITER_ATOMIC unconditionally.

So I'd prefer to make SG_MITER_ATOMIC go away entirely, and just
remove the non-atomic case..

A quick grep seems to imply that just about all users set the ATOMIC
bit anyway. I didn't look at everything, but every case I _did_ look
at did seem to set the ATOMIC bit.

So it really did seem like there isn't a lot of reason to have the
non-atomic case, and this flag could go away - not by virtue of the
atomic case going away, but by virtue of the atomic case being the
only actual case.

I mean, I did find one case that didn't set it (cb710-mmc.c), but
pattern-matching to the other mmc cases, that one looks like it
_should_ have set the atomic flag like everybody else did.

Did I miss something?

             Linus
