Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812CAC54FCB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 18:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D81E20704
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 18:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587667633;
	bh=IdJFdAGIXST8Snulp++rKWFCxXADaCE4jG/SKoSzfEw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=E041La8kEKUPMfyA+nEWtd30bCwvhMxO6HzfrwsRLVlokM+RTSuL+aStujuZyTKwS
	 wxtDIJ3apcWzOYkiFohs4F7gnwd1PWO8jXDPAi7yGIAA6VgEyKAxXGYcpbjg070Ow8
	 ZZ2Beb4M/hbyLUwtE/ZUtCvUiLRTkdfdOO1tZtF0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgDWSrM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 14:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbgDWSrM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 14:47:12 -0400
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0606D20704;
        Thu, 23 Apr 2020 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587667632;
        bh=IdJFdAGIXST8Snulp++rKWFCxXADaCE4jG/SKoSzfEw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hyCNA1wB/aJ5hsc4a67e/5wUVylpnYQ/h8r0S815V/7XPaNC2dRDVUG5PBdltbIs5
         QH3uVOITwNvike7zKIklrXyUZsY8BptTf+xgvxPonofNti+ilxq0ES6JECn5omx/Jl
         RwDkTsIHagrfBRS4ewGnV3rmDJvkbI/D7Ryni4IU=
Received: by mail-io1-f43.google.com with SMTP id w20so7610397iob.2;
        Thu, 23 Apr 2020 11:47:12 -0700 (PDT)
X-Gm-Message-State: AGi0PubFWzttxOF1lO9noKXgTRVXMcdYNNfsb6yK6H2Y3p7H36VL5Rr5
        kEahWzybW0NfGtrMGkIR72kdWUBGI8FSaEWdDRs=
X-Google-Smtp-Source: APiQypLK7CqRqF014KuvChdtuujDAqDdGvytjo4xYTra2PCbmXRM12cuo33sm28ipCfEhCwR6Ki0SVghpWg8+Pq5u0M=
X-Received: by 2002:a5d:9b8a:: with SMTP id r10mr5085026iom.171.1587667631436;
 Thu, 23 Apr 2020 11:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200422200344.239462-1-Jason@zx2c4.com> <20200422231854.675965-1-Jason@zx2c4.com>
 <CAMj1kXHV=ryaFmj0jhQVGBd31nfHs7q5RtSyu7dY6GdEJJsr7A@mail.gmail.com> <20200423184219.GA80650@kroah.com>
In-Reply-To: <20200423184219.GA80650@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 23 Apr 2020 20:47:00 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF9uLUE3=rX1i_yYoigB7j-nLMZpGc35ve2KV+NxjRhVQ@mail.gmail.com>
Message-ID: <CAMj1kXF9uLUE3=rX1i_yYoigB7j-nLMZpGc35ve2KV+NxjRhVQ@mail.gmail.com>
Subject: Re: [PATCH crypto-stable v3 1/2] crypto: arch/lib - limit simd usage
 to 4k chunks
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 23 Apr 2020 at 20:42, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Apr 23, 2020 at 09:18:15AM +0200, Ard Biesheuvel wrote:
> > FYI: you shouldn't cc stable@vger.kernel.org directly on your patches,
> > or add the cc: line. Only patches that are already in Linus' tree
> > should be sent there.
>
> Not true at all, please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.  Please do not spread incorrect
> information.
>
> And Jason did this properly, he put cc: stable@ in the s-o-b area and
> all is good, I will pick up this patch once it hits Linus's tree.
>
> And there is no problem actually sending the patch to stable@vger while
> under development like this, as it gives me a heads-up that something is
> coming, and is trivial to filter out.
>
> If you really want to be nice, you can just do:
>         cc: stable@kernel.org
> which goes to /dev/null on kernel.org, so no email will be sent to any
> list, but my scripts still pick it up.  But no real need to do that,
> it's fine.
>

OK, thanks for clearing this up.

So does this mean you have stopped sending out 'formletter'
auto-replies for patches that were sent out to stable@vger.kernel.org
directly, telling people not to do that?

> > Also, the fixes tags are really quite sufficient.
>
> No it is not, I have had to dig out patches more and more because people
> do NOT put the cc: stable and only put Fixes:, which is not a good thing
> as I then have to "guess" what the maintainer/developer ment.
>
> Be explicit if you know it, cc: stable please.
>

OK

> > In fact, it is
> > actually rather difficult these days to prevent something from being
> > taken into -stable if the bots notice that it applies cleanly.
>
> Those "bots" are still driven by a lot of human work, please make it
> easy on us whenever possible.
>

Sure.
