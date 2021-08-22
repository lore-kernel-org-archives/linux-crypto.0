Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB4EC4338F
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Aug 2021 13:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B81C360725
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Aug 2021 13:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhHVNYp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Aug 2021 09:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhHVNYo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Aug 2021 09:24:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB99A61354;
        Sun, 22 Aug 2021 13:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629638643;
        bh=+0KLb9o630gwsAklksMT+OiAbRBsvMLZHD8SBqtnUus=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iTpGkQGBW0QaKllQHFS84RT2heM9sXV/6IKcYuEeJcpP02OJpX/7OlimUA8o/bntn
         z9xstex+4bb0M0IhMs3sEkvM+NKX9/pW8HtJd3rm8e6/jrY7bHWzoOQsz4vDveyQko
         W/BYR1/Ii6BM78f1eq2XZeuI/BQIz8URji4HTqViv8nOAzMjuw0FMzBYCXn8Q+UZK+
         79NvwGYIxGRevspoJ/xRpPP0yegpKafCjsAAv+LFzzRlhLEpoN4UIZE6KEOYQb+ZU5
         bNTBfyPm51Ndu0dybfJtdkmPqEeepwuqUAL2NwZXXGjhkWy0D8aojo0K7kGSPXivf1
         /LREEZ8gHGi2A==
Received: by mail-oo1-f54.google.com with SMTP id t2-20020a4ae9a2000000b0028c7144f106so3447283ood.6;
        Sun, 22 Aug 2021 06:24:03 -0700 (PDT)
X-Gm-Message-State: AOAM532DqJNXpOm1HCboIupGBctodFbi8Wv0wGek20Q6sR0V2SOmqmNN
        xpBViYvUi1R9uETBivnuMD8ZJrxSDOg+6p57oFc=
X-Google-Smtp-Source: ABdhPJyFgHF/pYD3PAz8sWJVS2fTtBUpAQY87RdiATdCa+OOpC4w2u+fSSW6TcgHyDZxt+I7QmDh7PTmPTldhDarXQ4=
X-Received: by 2002:a4a:dfac:: with SMTP id k12mr22727674ook.41.1629638643184;
 Sun, 22 Aug 2021 06:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <YQ0Qm+Xs1g/7Eant@fedora> <20210809141027.860850-1-chouhan.shreyansh630@gmail.com>
 <20210820083111.GA28484@gondor.apana.org.au> <CAMj1kXGMPimX0_dR_kLuzZjuJK9rM=uCpRDtoJq0UjWq12M10A@mail.gmail.com>
 <20210820125315.GB28484@gondor.apana.org.au>
In-Reply-To: <20210820125315.GB28484@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 22 Aug 2021 15:23:52 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGCtH2V23S+b=dBj_owxjbhpnarOzZxjfjRM38Wt2XFdg@mail.gmail.com>
Message-ID: <CAMj1kXGCtH2V23S+b=dBj_owxjbhpnarOzZxjfjRM38Wt2XFdg@mail.gmail.com>
Subject: Re: [PATCH] crypto: xts_crypt() return if walk.nbytes is 0
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 20 Aug 2021 at 14:53, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Aug 20, 2021 at 01:14:52PM +0200, Ard Biesheuvel wrote:
> >
> > In spite of that, I have a slight preference for this version, given
> > that it makes it obvious that we bail on two separate conditions:
> > - an error has occurred
> > - no error has occurred but the resulting walk is empty
> >
> > Testing walk.nbytes only needlessly obfuscates the code, as we need to
> > return 'err' in the end anyway.
>
> I disagree, this is how most skcipher walkers are structured, they
> never explicitly test on err and only terminate the loop when
> walk->nbytes hits zero, in which case err is returned as is.
>
> I don't see why this particular skcipher walker should deviate
> from that paradigm.  In fact it is exactly that deviation that
> caused the bug in the first instance.
>

Fair enough.
