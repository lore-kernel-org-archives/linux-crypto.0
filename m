Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BE7C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 14:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A98A206F4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 14:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uuQV62WG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgGPOlj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 10:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728630AbgGPOli (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 10:41:38 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BED6C061755
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 07:41:38 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id o3so5225643ilo.12
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 07:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cK8T7PxuMIyvYVXqVYJVGfYhwDrgslvyXeD+XSrTKa4=;
        b=uuQV62WGjvWSH35xnvf3C12rcZkmT0N18cUoRC4S4ecylYWGHm176G00QUa36k+IfN
         u2qkbhNJfQN0VZm1vOHOCR+S+pR6Fd2XbObUXE2aDbeclSy/t5OqoiJUz8Wuk94QUby6
         IyFq/vsKwiMs5PAMLxOjy2jBAZYcUi6H+aJuZ3bXNrd64Sfpt/auqrqlrbYKraEk/ZiT
         rBnD0BzNvlB4FBRDH4IhusRmZ6C3+WGHifra7fm7J20nIzM1no4Du+jJvY+s6MM9D+6+
         IX5G+G8VDZyJ7BFoDXntVWZNYbblAKWF+iasD67CqAgmqMvs0nR9EJisJEgsf3I0Y32D
         /rdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cK8T7PxuMIyvYVXqVYJVGfYhwDrgslvyXeD+XSrTKa4=;
        b=UcOaNvBt8JDJ9YwVIvNSlDruD/o+hNsv0mrLwht1v2vCkUzAv1IsCs1CrVGgPzxQm8
         UIH2Rh1Xt9MOw6YRRWt45Ar63kY5Y9wivVNAZ6azcDAGNotw2y/wCtPYiltF8+EKp6d5
         ZIUhhqPHWLOVXnE7dRx6ZAO2pPO6TQZzTrEL6MDc5r/H8TZ1U5aye4YoRWwd8LLo+qMb
         iYd8/dmRP0rHxRKpxN1mMkAp+L0g72fmxW8qb04hcF0Oyq5K0kvHX7GexdG4k9Sd4c3+
         CRafjD/lWoNeh+tdYGKQqe5C4AW3vRdpgYo0VKY26FTsa0+OxTLhaYpSWC3GERYvHfAf
         cmaw==
X-Gm-Message-State: AOAM532MfDWYttWn3lUrshckQP03Izfii6LgJnS/Kj4dS8qWnOYuhRRq
        k7McBT5+uVnvgyWiU5uihjR0NVQ+jHCfsnQ4yoYv8vczjio=
X-Google-Smtp-Source: ABdhPJyuGLmtMSDp0U/oXHHgFChbK+LWahqAF6cDfMh/xbfS8HzrqXacqdgr/hK9oXSewx7r+v01Xief57b6DujJoGg=
X-Received: by 2002:a92:d4cf:: with SMTP id o15mr4370857ilm.160.1594910497206;
 Thu, 16 Jul 2020 07:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200713164857.1031117-1-lenaptr@google.com> <2941213.7s5MMGUR32@tauon.chronox.de>
 <CABvBcwauK_JyVzONdwJRGU81ZH5sYuiJSH0F2g+i5qCe363+fQ@mail.gmail.com> <3312053.iIbC2pHGDl@tauon.chronox.de>
In-Reply-To: <3312053.iIbC2pHGDl@tauon.chronox.de>
From:   Elena Petrova <lenaptr@google.com>
Date:   Thu, 16 Jul 2020 15:41:26 +0100
Message-ID: <CABvBcwaB3RLuRWEzSoeADc4Jg28fK6mqwevaywLsZhvFgBi+BA@mail.gmail.com>
Subject: Re: [PATCH 0/1] crypto: af_alg - add extra parameters for DRBG interface
To:     Stephan Mueller <smueller@chronox.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

On Tue, 14 Jul 2020 at 16:34, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Dienstag, 14. Juli 2020, 17:23:05 CEST schrieb Elena Petrova:
>
> Hi Elena,
>
> > Hi Stephan,
> >
> > On Tue, 14 Jul 2020 at 06:17, Stephan Mueller <smueller@chronox.de> wrote:
> > > Am Montag, 13. Juli 2020, 18:48:56 CEST schrieb Elena Petrova:
> > >
> > > Hi Elena,
> > >
> > > > This patch extends the userspace RNG interface to make it usable for
> > > > CAVS testing. This is achieved by adding ALG_SET_DRBG_ENTROPY
> > > > option to the setsockopt interface for specifying the entropy, and using
> > > > sendmsg syscall for specifying the additional data.
> > > >
> > > > See libkcapi patch [1] to test the added functionality. The libkcapi
> > > > patch is not intended for merging into libkcapi as is: it is only a
> > > > quick plug to manually verify that the extended AF_ALG RNG interface
> > > > generates the expected output on DRBG800-90A CAVS inputs.
> > >
> > > As I am responsible for developing such CAVS/ACVP harness as well, I
> > > played
> > > with the idea of going through AF_ALG. I discarded it because I do not see
> > > the benefit why we should add an interface solely for the purpose of
> > > testing. Further, it is a potentially dangerous one because the created
> > > instance of the DRBG is "seeded" from data provided by the caller.
> > >
> > > Thus, I do not see the benefit from adding that extension, widening a user
> > > space interface solely for the purpose of CAVS testing. I would not see
> > > any
> > > other benefit we have with this extension. In particular, this interface
> > > would then be always there. What I could live with is an interface that
> > > can be enabled at compile time for those who want it.
> >
> > Thanks for reviewing this patch. I understand your concern about the
> > erroneous use of the entropy input by non-testing applications. This was an
> > approach that I had discussed with Ard. I should have included you, my
> > apologies. I'll  post v2 with the CAVS testing stuff hidden under CONFIG_
> > option with appropriate help text.
> >
> > With regards to the usefulness, let me elaborate. This effort of extending
> > the drbg interface is driven by Android needs for having the kernel crypto
> > certified. I started from having an out-of-tree chrdev driver for Google
> > Pixel kernels that was exposing the required crypto functionality, and it
> > wasn't ideal in the following ways:
> >  * it primarily consisted of copypasted code from testmgr.c
> >  * it was hard for me to keep the code up to date because I'm not aware of
> >    ongoing changes to crypto
> >  * it is hard for other people and/or organisations to re-use it, hense a
> > lot of duplicated effort is going into CAVS: you have a private driver, I
> > have mine, Jaya from HP <jayalakshmi.bhat@hp.com>, who's been asking
> > linux-crypto a few CAVS questions, has to develop theirs...
> >
> > In general Android is trying to eliminate out-of-tree code. CAVS testing
> > functionality in particular needs to be upstream because we are switching
> > all Android devices to using a Generic Kernel Image (GKI)
> > [https://lwn.net/Articles/771974/] based on the upstream kernel.
>
> Thank you for the explanation.
> >
> > > Besides, when you want to do CAVS testing, the following ciphers are still
> > > not testable and thus this patch would only be a partial solution to get
> > > the testing covered:
> > >
> > > - AES KW (you cannot get the final IV out of the kernel - I played with
> > > the
> > > idea to return the IV through AF_ALG, but discarded it because of the
> > > concern above)
> > >
> > > - OFB/CFB MCT testing (you need the IV from the last round - same issue as
> > > for AES KW)
> > >
> > > - RSA
> > >
> > > - DH
> > >
> > > - ECDH
> >
> > For Android certification purposes, we only need to test the modules which
> > are actually being used. In our case it's what af_alg already exposes plus
> > DRBG. If, say, HP would need RSA, they could submit their own patch.
> >
> > As for exposing bits of the internal state for some algorithms, I hope
> > guarding the testing functionality with a CONFIG_ option would solve the
> > security part of the problem.
>
> Yes, for all other users.
>
> But if you are planning to enable this option for all Android devices across
> the board I am not sure here. In this case, wouldn't it make sense to require
> capable(CAP_SYS_ADMIN) for the DRBG reset operation just as an additional
> precaution? Note, the issue with the reset is that you loose all previous
> state (which is good for testing, but bad for security as I guess you agree
> :-) ).

I believe that for Android, since CAVS is a one-off on demand
operation, we can create a separate build with CONFIG_CRYPTO_CAVS_DRBG
enabled, which won't go to the users. Thanks for suggesting
capabilities check, happy to add `capable(CAP_SYS_ADMIN)` regardless.

> > > With these issues, I would assume you are better off creating your own
> > > kernel module just like I did that externalizes the crypto API to user
> > > space but is only available on your test kernel and will not affect all
> > > other users.
> > I considered publishing my kernel driver on GitHub, but there appears to be
> > a sufficiently large number of users to justify having this functionality
> > upstream.
>
> So, I should then dust off my AF_ALG KPP and AF_ALG akcipher patches then? :-D

Sure :)

> >
> > Hope that addresses your concerns.
> >
> > > Ciao
> > > Stephan
> >
> > Thanks,
> > Elena
>
>
> Ciao
> Stephan
>
>
