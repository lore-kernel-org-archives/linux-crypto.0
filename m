Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74272C433E6
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 15:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E0CB221EB
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 15:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BQ1p1rfM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgGNPXS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 11:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgGNPXS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 11:23:18 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29737C061755
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2020 08:23:18 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id i4so17644992iov.11
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2020 08:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aouzhcTH52EEzjSPHkmmEky38PcFMBNDQWyyTZujDlg=;
        b=BQ1p1rfMFuv5Ae8e99XhzwstRmMwLolv/Yo50s7DfO+wQcLo7ojqCoQnNACBVOS0aH
         Z0z8so+DvJ5GDinzLzP2YDcVyeQS0YGizqke06D1FRArSHMZPJ45+gvsKxgmWu35Od2k
         bAX6oXCb4nnHWNT1yXmdPubF4IH7fG0SmHEZAFCZO+uH1sP34iDchavj5lJ2DSUedvUf
         i+c7cCY9q1RRliAaR3sGRgL/C8hZMuY1iAJOnGeH2jNYR6TLFhXhf+V8aWOWYUB56C1c
         lTx9n+sLPVWMNZCOFWHkmLWHOzVHYrJ7BwvYMuFhgTdnt9vgxASfRBCoot6H2QlbUXQw
         OZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aouzhcTH52EEzjSPHkmmEky38PcFMBNDQWyyTZujDlg=;
        b=D6+ZQTPcyEicv7mS3dy7SAtMgF9LBZaDsUxDvtsPl/1hhw2Skh48wFtxtAO+jVLepw
         ydkbuof8UriEL4QtjuuBTISzprumPUt1au7a1Zjndm6vUtQbJLzNuM4WZ8eMeYJ2Lo0k
         ttsW1MWHqKAOSHrCCPdyoVz9JJAmkF81/ikT2ZTT/j6x0dQJ9O9MdcjmrgIzXAZ0THMV
         UpUYvu9RDSzCuUmYcBgiNkdxuI0pSp/5CUdDw8aymEjdRh8+CgRBZSq2g/F/fWjo1+8O
         HKwkGfVbIWsAbVVivgH5n6NpZI/PKPUFmP3l8oitxZmqJsyj/qm/27tL/qxNUBpIDiqr
         U0Gw==
X-Gm-Message-State: AOAM531aKyd3nFeMD4TygdCPCqhLh7y81AyfV71WmqkgFHaKaL2Qf6zu
        jDhp8uEFdN9zS5VWyIN6hEDV/eI6Gj/zc6JsmWPoXKQBmsM=
X-Google-Smtp-Source: ABdhPJx7QqLkc/UsbC/BcSJEl3fNzK3OM8UBh4JmUE6WJZmoVGwnh2IiJrwDlpa7Jlqc+49cM/bZXiKMu7Res2y/qXs=
X-Received: by 2002:a6b:661a:: with SMTP id a26mr5368258ioc.197.1594740197141;
 Tue, 14 Jul 2020 08:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200713164857.1031117-1-lenaptr@google.com> <2941213.7s5MMGUR32@tauon.chronox.de>
In-Reply-To: <2941213.7s5MMGUR32@tauon.chronox.de>
From:   Elena Petrova <lenaptr@google.com>
Date:   Tue, 14 Jul 2020 16:23:05 +0100
Message-ID: <CABvBcwauK_JyVzONdwJRGU81ZH5sYuiJSH0F2g+i5qCe363+fQ@mail.gmail.com>
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

On Tue, 14 Jul 2020 at 06:17, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Montag, 13. Juli 2020, 18:48:56 CEST schrieb Elena Petrova:
>
> Hi Elena,
>
> > This patch extends the userspace RNG interface to make it usable for
> > CAVS testing. This is achieved by adding ALG_SET_DRBG_ENTROPY
> > option to the setsockopt interface for specifying the entropy, and using
> > sendmsg syscall for specifying the additional data.
> >
> > See libkcapi patch [1] to test the added functionality. The libkcapi
> > patch is not intended for merging into libkcapi as is: it is only a
> > quick plug to manually verify that the extended AF_ALG RNG interface
> > generates the expected output on DRBG800-90A CAVS inputs.
>
> As I am responsible for developing such CAVS/ACVP harness as well, I played
> with the idea of going through AF_ALG. I discarded it because I do not see the
> benefit why we should add an interface solely for the purpose of testing.
> Further, it is a potentially dangerous one because the created instance of the
> DRBG is "seeded" from data provided by the caller.
>
> Thus, I do not see the benefit from adding that extension, widening a user
> space interface solely for the purpose of CAVS testing. I would not see any
> other benefit we have with this extension. In particular, this interface would
> then be always there. What I could live with is an interface that can be
> enabled at compile time for those who want it.

Thanks for reviewing this patch. I understand your concern about the erroneous
use of the entropy input by non-testing applications. This was an approach that
I had discussed with Ard. I should have included you, my apologies. I'll  post
v2 with the CAVS testing stuff hidden under CONFIG_ option with appropriate help
text.

With regards to the usefulness, let me elaborate. This effort of extending the
drbg interface is driven by Android needs for having the kernel crypto
certified. I started from having an out-of-tree chrdev driver for Google Pixel
kernels that was exposing the required crypto functionality, and it wasn't ideal
in the following ways:
 * it primarily consisted of copypasted code from testmgr.c
 * it was hard for me to keep the code up to date because I'm not aware of
   ongoing changes to crypto
 * it is hard for other people and/or organisations to re-use it, hense a lot of
   duplicated effort is going into CAVS: you have a private driver, I have mine,
   Jaya from HP <jayalakshmi.bhat@hp.com>, who's been asking linux-crypto a few
   CAVS questions, has to develop theirs...

In general Android is trying to eliminate out-of-tree code. CAVS testing
functionality in particular needs to be upstream because we are switching all
Android devices to using a Generic Kernel Image (GKI)
[https://lwn.net/Articles/771974/] based on the upstream kernel.

> Besides, when you want to do CAVS testing, the following ciphers are still not
> testable and thus this patch would only be a partial solution to get the
> testing covered:
>
> - AES KW (you cannot get the final IV out of the kernel - I played with the
> idea to return the IV through AF_ALG, but discarded it because of the concern
> above)
>
> - OFB/CFB MCT testing (you need the IV from the last round - same issue as for
> AES KW)
>
> - RSA
>
> - DH
>
> - ECDH

For Android certification purposes, we only need to test the modules which are
actually being used. In our case it's what af_alg already exposes plus DRBG.
If, say, HP would need RSA, they could submit their own patch.

As for exposing bits of the internal state for some algorithms, I hope guarding
the testing functionality with a CONFIG_ option would solve the security part of
the problem.

> With these issues, I would assume you are better off creating your own kernel
> module just like I did that externalizes the crypto API to user space but is
> only available on your test kernel and will not affect all other users.

I considered publishing my kernel driver on GitHub, but there appears to be a
sufficiently large number of users to justify having this functionality
upstream.

Hope that addresses your concerns.

> Ciao
> Stephan

Thanks,
Elena
