Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE102C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 06:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92ADA205CB
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 06:47:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Fp/n8bHy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgETGrp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 02:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgETGro (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 02:47:44 -0400
Received: from mo6-p02-ob.smtp.rzone.de (mo6-p02-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5302::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B83C061A0E
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 23:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589957262;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=7Bptyy9dxCdFVwdRa4JBhNQsRKOJ/eD+RxAuL10DQGo=;
        b=Fp/n8bHyvk2c4r3cGlqhMJ7ZCxnH1FXePV0gN5rIfeboJOlLBZV3kf2HNOFsADaSfU
        6pbpbTS246IZAyPzXWRw5bvI09PQPZeB8z7kbID7ODCgU7SWMJtj360CPaWjWOGLHCoA
        FMRjt4AdGdcVbKSr45k6UyGrJaA3tMsh/Ht/Mxi1lAUtEKTJkOOPvM/lXiOzM8daoIol
        3tA31IsbctY68zr9/dbxbsWWE2zAXo7CtZ63yyqBirFUu8DOTIPDGuk6bI/0mK9Io0Sb
        1i0N/8+J+ah41KHc0kWoHNLeODkmJ8iExl/xgaMR5jreNPzW+6OrRaJ6/xhsg2rUi/bG
        YhDA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/Sc5g=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4K6lc3Bz
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 20 May 2020 08:47:38 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
Date:   Wed, 20 May 2020 08:47:37 +0200
Message-ID: <16394356.0UTfFWEGjO@tauon.chronox.de>
In-Reply-To: <CAMj1kXFDcHncnb=aUkWnX22Co2r4g3DSM+wug0FQ231Gv7J01Q@mail.gmail.com>
References: <20200519190211.76855-1-ardb@kernel.org> <16565072.6IxHkjxkAd@tauon.chronox.de> <CAMj1kXFDcHncnb=aUkWnX22Co2r4g3DSM+wug0FQ231Gv7J01Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 20. Mai 2020, 08:40:57 CEST schrieb Ard Biesheuvel:

Hi Ard,

> On Wed, 20 May 2020 at 08:03, Stephan Mueller <smueller@chronox.de> wrote:
> > Am Dienstag, 19. Mai 2020, 21:02:09 CEST schrieb Ard Biesheuvel:
> > 
> > Hi Ard,
> > 
> > > Stephan reports that the arm64 implementation of cts(cbc(aes)) deviates
> > > from the generic implementation in what it returns as the output IV. So
> > > fix this, and add some test vectors to catch other non-compliant
> > > implementations.
> > > 
> > > Stephan, could you provide a reference for the NIST validation tool and
> > > how it flags this behaviour as non-compliant? Thanks.
> > 
> > The test definition that identified the inconsistent behavior is specified
> > with [1]. Note, this testing is intended to become an RFC standard.
> 
> Are you referring to the line
> 
> CT[j] = AES_CBC_CS_ENCRYPT(Key[i], PT[j])
> 
> where the CTS transform is invoked without an IV altogether?

Precisely.

> That
> simply seems like a bug to me. In an abstract specification like this,
> it would be insane for pseudocode functions to be stateful objects,
> and there is nothing in the pseudocode that explicitly captures the
> 'output IV' of that function call.

I think the description may be updated by simply refer to IV[j-1]. Then you 
would not have a stateful operation, but you rest on the IV of the previous 
operation.

The state of all block chaining modes we currently have is defined with the 
IV. That is the reason why I mentioned it can be implemented stateless when I 
am able to get the IV output from the previous operation.

> 
> > To facilitate that testing, NIST offers an internet service, the ACVP
> > server, that allows obtaining test vectors and uploading responses. You
> > see the large number of concluded testing with [2]. A particular
> > completion of the CTS testing I finished yesterday is given in [3]. That
> > particular testing was also performed on an ARM system with CE where the
> > issue was detected.
> > 
> > I am performing the testing with [4] that has an extension to test the
> > kernel crypto API.
> 
> OK. So given that that neither the CTS spec nor this document makes
> any mention of an output IV or what its value should be, my suggestion
> would be to capture the IV directly from the ciphertext, rather than
> relying on some unspecified behavior to give you the right data. Note
> that we have other implementations of cts(cbc(aes)) in the kernel as
> well (h/w accelerated ones) and if there is no specification that
> defines this behavior, you really shouldn't be relying on it.

Agreed, but all I need is the IV from the previous round without relying on 
any state.
> 
> 
> That 'specification' invokes AES_CBC_CS_ENCRYPT() twice using a
> different prototype, without any mention whatsoever what the implied
> value of IV[] is if it is missing. This is especially problematic
> given that it seems to cover all of CS1/2/3, and the relation between
> next IV and ciphertext is not even the same between those for inputs
> that are a multiple of the blocksize.

I will relay that comment back to the authors for update.
> 
> > [1]
> > https://github.com/usnistgov/ACVP/blob/master/artifacts/draft-celi-acvp-b
> > lock-ciph-00.txt#L366
> > 
> > [2]
> > https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program
> > / validation-search?searchMode=validation&family=1&productType=-1&ipp=25
> > 
> > [3]
> > https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program
> > / details?validation=32608
> > 
> > [4] https://github.com/smuellerDD/acvpparser
> > 
> > > Cc: Stephan Mueller <smueller@chronox.de>
> > > 
> > > Ard Biesheuvel (2):
> > >   crypto: arm64/aes - align output IV with generic CBC-CTS driver
> > >   crypto: testmgr - add output IVs for AES-CBC with ciphertext stealing
> > >  
> > >  arch/arm64/crypto/aes-modes.S |  2 ++
> > >  crypto/testmgr.h              | 12 ++++++++++++
> > >  2 files changed, 14 insertions(+)
> > 
> > Ciao
> > Stephan


Ciao
Stephan


