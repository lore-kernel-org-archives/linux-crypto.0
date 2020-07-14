Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15DFC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 15:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A888922285
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 15:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Xd4LneIa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgGNPeq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 11:34:46 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:29555 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgGNPep (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 11:34:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594740878;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=eDp1c61gODZaduiFEkah+Og1dwDcdB68lu3kdvo4BRg=;
        b=Xd4LneIaq0VRzbgaTIe2/gkSkFvzieL48sxZ40Je4Pjxsv6TXQYd3JlO+Pc5wyAq0X
        /JolHbqzTK5wwb+CLAVCcKslNU/mpz/lZYt6IwPaU+vazFL4YgsIl5wdFQFHC5YupFpM
        OvVTei/HyNuY5mg2ysCR7uRbL0Pua9DeoHv1+775OKt5BTBy0+LXxdHjUXpm84QCG5ED
        XLYJNxn7TkT92qYlbXwJiut4xtfQ8gE25F3WfzDLwV4btW/tSR3UZMzOIks90siQ/sbz
        PYgO6qJGzL3pHav/P7Vyi5SYUkgTJfxI4PlFrHVty/PFaB95nkd0NR2bufKbe+MU92rW
        xh0w==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaI/SfxmJ+"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6EFYZuRC
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 14 Jul 2020 17:34:35 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Elena Petrova <lenaptr@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 0/1] crypto: af_alg - add extra parameters for DRBG interface
Date:   Tue, 14 Jul 2020 17:34:34 +0200
Message-ID: <3312053.iIbC2pHGDl@tauon.chronox.de>
In-Reply-To: <CABvBcwauK_JyVzONdwJRGU81ZH5sYuiJSH0F2g+i5qCe363+fQ@mail.gmail.com>
References: <20200713164857.1031117-1-lenaptr@google.com> <2941213.7s5MMGUR32@tauon.chronox.de> <CABvBcwauK_JyVzONdwJRGU81ZH5sYuiJSH0F2g+i5qCe363+fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 14. Juli 2020, 17:23:05 CEST schrieb Elena Petrova:

Hi Elena,

> Hi Stephan,
> 
> On Tue, 14 Jul 2020 at 06:17, Stephan Mueller <smueller@chronox.de> wrote:
> > Am Montag, 13. Juli 2020, 18:48:56 CEST schrieb Elena Petrova:
> > 
> > Hi Elena,
> > 
> > > This patch extends the userspace RNG interface to make it usable for
> > > CAVS testing. This is achieved by adding ALG_SET_DRBG_ENTROPY
> > > option to the setsockopt interface for specifying the entropy, and using
> > > sendmsg syscall for specifying the additional data.
> > > 
> > > See libkcapi patch [1] to test the added functionality. The libkcapi
> > > patch is not intended for merging into libkcapi as is: it is only a
> > > quick plug to manually verify that the extended AF_ALG RNG interface
> > > generates the expected output on DRBG800-90A CAVS inputs.
> > 
> > As I am responsible for developing such CAVS/ACVP harness as well, I
> > played
> > with the idea of going through AF_ALG. I discarded it because I do not see
> > the benefit why we should add an interface solely for the purpose of
> > testing. Further, it is a potentially dangerous one because the created
> > instance of the DRBG is "seeded" from data provided by the caller.
> > 
> > Thus, I do not see the benefit from adding that extension, widening a user
> > space interface solely for the purpose of CAVS testing. I would not see
> > any
> > other benefit we have with this extension. In particular, this interface
> > would then be always there. What I could live with is an interface that
> > can be enabled at compile time for those who want it.
> 
> Thanks for reviewing this patch. I understand your concern about the
> erroneous use of the entropy input by non-testing applications. This was an
> approach that I had discussed with Ard. I should have included you, my
> apologies. I'll  post v2 with the CAVS testing stuff hidden under CONFIG_
> option with appropriate help text.
> 
> With regards to the usefulness, let me elaborate. This effort of extending
> the drbg interface is driven by Android needs for having the kernel crypto
> certified. I started from having an out-of-tree chrdev driver for Google
> Pixel kernels that was exposing the required crypto functionality, and it
> wasn't ideal in the following ways:
>  * it primarily consisted of copypasted code from testmgr.c
>  * it was hard for me to keep the code up to date because I'm not aware of
>    ongoing changes to crypto
>  * it is hard for other people and/or organisations to re-use it, hense a
> lot of duplicated effort is going into CAVS: you have a private driver, I
> have mine, Jaya from HP <jayalakshmi.bhat@hp.com>, who's been asking
> linux-crypto a few CAVS questions, has to develop theirs...
> 
> In general Android is trying to eliminate out-of-tree code. CAVS testing
> functionality in particular needs to be upstream because we are switching
> all Android devices to using a Generic Kernel Image (GKI)
> [https://lwn.net/Articles/771974/] based on the upstream kernel.

Thank you for the explanation.
> 
> > Besides, when you want to do CAVS testing, the following ciphers are still
> > not testable and thus this patch would only be a partial solution to get
> > the testing covered:
> > 
> > - AES KW (you cannot get the final IV out of the kernel - I played with
> > the
> > idea to return the IV through AF_ALG, but discarded it because of the
> > concern above)
> > 
> > - OFB/CFB MCT testing (you need the IV from the last round - same issue as
> > for AES KW)
> > 
> > - RSA
> > 
> > - DH
> > 
> > - ECDH
> 
> For Android certification purposes, we only need to test the modules which
> are actually being used. In our case it's what af_alg already exposes plus
> DRBG. If, say, HP would need RSA, they could submit their own patch.
> 
> As for exposing bits of the internal state for some algorithms, I hope
> guarding the testing functionality with a CONFIG_ option would solve the
> security part of the problem.

Yes, for all other users.

But if you are planning to enable this option for all Android devices across 
the board I am not sure here. In this case, wouldn't it make sense to require 
capable(CAP_SYS_ADMIN) for the DRBG reset operation just as an additional 
precaution? Note, the issue with the reset is that you loose all previous 
state (which is good for testing, but bad for security as I guess you agree 
:-) ).
> 
> > With these issues, I would assume you are better off creating your own
> > kernel module just like I did that externalizes the crypto API to user
> > space but is only available on your test kernel and will not affect all
> > other users.
> I considered publishing my kernel driver on GitHub, but there appears to be
> a sufficiently large number of users to justify having this functionality
> upstream.

So, I should then dust off my AF_ALG KPP and AF_ALG akcipher patches then? :-D
> 
> Hope that addresses your concerns.
> 
> > Ciao
> > Stephan
> 
> Thanks,
> Elena


Ciao
Stephan


