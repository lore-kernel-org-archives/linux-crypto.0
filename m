Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F211C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 07:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D8A207D3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 07:01:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="QoIx19aZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgETHBL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 03:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgETHBK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 03:01:10 -0400
Received: from mo6-p02-ob.smtp.rzone.de (mo6-p02-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5302::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EF4C061A0E
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2020 00:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589958068;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ZXbdSR51vsexYPQyO6+XHaWV+/YRvrsTI2dhYbAFkWE=;
        b=QoIx19aZKw5cNa4wr88s64Bd9MkqUKJH+fPU0GPQF9ydX6/whX7kig3tQz+I2+0rYe
        G7Q8nTKEd1m8d35nk4KX1G6KJbWyntM3c8qxxdehB/vvsxZFu/IEtyJSMzbSmds1FZAW
        9NPAMxeC8FlRYqxSGZ4/ZcsW2pgP5CCx7/Wd45MJR8YlzHVSuAn1MCnZhUU5OiQfyQYP
        KDeklx9HwUgjtMyvUUVSFn/psPzxByBoEZPkDXpoe29kOOulqheD15LVPIB+9IyzdHld
        EU/OxVCIXurwiCSCFSM6XP0cY/uHe5d1glBPn9gOWBHRDtmd5/OQnLgKg8dyP4+Sqnkq
        isqw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/Sc5g=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4K7143HY
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 20 May 2020 09:01:04 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
Date:   Wed, 20 May 2020 09:01:03 +0200
Message-ID: <2010567.jSmZeKYv2B@tauon.chronox.de>
In-Reply-To: <CAMj1kXF=Duh1AsAQy+aLWMcJPQ4RFL5p9-Mnmn-XAiCkzyGFbg@mail.gmail.com>
References: <20200519190211.76855-1-ardb@kernel.org> <16394356.0UTfFWEGjO@tauon.chronox.de> <CAMj1kXF=Duh1AsAQy+aLWMcJPQ4RFL5p9-Mnmn-XAiCkzyGFbg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 20. Mai 2020, 08:54:10 CEST schrieb Ard Biesheuvel:

Hi Ard,

> On Wed, 20 May 2020 at 08:47, Stephan Mueller <smueller@chronox.de> wrote:
> > Am Mittwoch, 20. Mai 2020, 08:40:57 CEST schrieb Ard Biesheuvel:
> > 
> > Hi Ard,
> > 
> > > On Wed, 20 May 2020 at 08:03, Stephan Mueller <smueller@chronox.de> 
wrote:
> > > > Am Dienstag, 19. Mai 2020, 21:02:09 CEST schrieb Ard Biesheuvel:
> > > > 
> > > > Hi Ard,
> > > > 
> > > > > Stephan reports that the arm64 implementation of cts(cbc(aes))
> > > > > deviates
> > > > > from the generic implementation in what it returns as the output IV.
> > > > > So
> > > > > fix this, and add some test vectors to catch other non-compliant
> > > > > implementations.
> > > > > 
> > > > > Stephan, could you provide a reference for the NIST validation tool
> > > > > and
> > > > > how it flags this behaviour as non-compliant? Thanks.
> > > > 
> > > > The test definition that identified the inconsistent behavior is
> > > > specified
> > > > with [1]. Note, this testing is intended to become an RFC standard.
> > > 
> > > Are you referring to the line
> > > 
> > > CT[j] = AES_CBC_CS_ENCRYPT(Key[i], PT[j])
> > > 
> > > where the CTS transform is invoked without an IV altogether?
> > 
> > Precisely.
> > 
> > > That
> > > simply seems like a bug to me. In an abstract specification like this,
> > > it would be insane for pseudocode functions to be stateful objects,
> > > and there is nothing in the pseudocode that explicitly captures the
> > > 'output IV' of that function call.
> > 
> > I think the description may be updated by simply refer to IV[j-1]. Then
> > you
> > would not have a stateful operation, but you rest on the IV of the
> > previous
> > operation.
> 
> But that value is not the value you are using now, right? I suspect
> that the line
> 
> IV[i+1] = MSB(CT[j], IV.length)

Yes, such a line would be needed.
> 
> needs to be duplicated in the inner loop for j, although that would
> require different versions for CS1/2/3

Correct in the sense to specify exactly what the IV after a cipher operation 
actually is.
> 
> > The state of all block chaining modes we currently have is defined with
> > the
> > IV. That is the reason why I mentioned it can be implemented stateless
> > when I am able to get the IV output from the previous operation.
> 
> But it is simply the same as the penultimate block of ciphertext. So
> you can simply capture it after encrypt, or before decrypt. There is
> really no need to rely on the CTS transformation to pass it back to
> you via the buffer that is only specified to provide an input to the
> CTS transform.

Let me recheck that as I am not fully sure on that one. But if it can be 
handled that way, it would make life easier.
> 
> > > > To facilitate that testing, NIST offers an internet service, the ACVP
> > > > server, that allows obtaining test vectors and uploading responses.
> > > > You
> > > > see the large number of concluded testing with [2]. A particular
> > > > completion of the CTS testing I finished yesterday is given in [3].
> > > > That
> > > > particular testing was also performed on an ARM system with CE where
> > > > the
> > > > issue was detected.
> > > > 
> > > > I am performing the testing with [4] that has an extension to test the
> > > > kernel crypto API.
> > > 
> > > OK. So given that that neither the CTS spec nor this document makes
> > > any mention of an output IV or what its value should be, my suggestion
> > > would be to capture the IV directly from the ciphertext, rather than
> > > relying on some unspecified behavior to give you the right data. Note
> > > that we have other implementations of cts(cbc(aes)) in the kernel as
> > > well (h/w accelerated ones) and if there is no specification that
> > > defines this behavior, you really shouldn't be relying on it.
> > 
> > Agreed, but all I need is the IV from the previous round without relying
> > on
> > any state.
> 
> So just grab it from the ciphertext of the previous round.
> 
> > > That 'specification' invokes AES_CBC_CS_ENCRYPT() twice using a
> > > different prototype, without any mention whatsoever what the implied
> > > value of IV[] is if it is missing. This is especially problematic
> > > given that it seems to cover all of CS1/2/3, and the relation between
> > > next IV and ciphertext is not even the same between those for inputs
> > > that are a multiple of the blocksize.
> > 
> > I will relay that comment back to the authors for update.
> 
> Thanks.

Thank you for your ideas!
> 
> > > > [1]
> > > > https://github.com/usnistgov/ACVP/blob/master/artifacts/draft-celi-acv
> > > > p-b
> > > > lock-ciph-00.txt#L366
> > > > 
> > > > [2]
> > > > https://csrc.nist.gov/projects/cryptographic-algorithm-validation-prog
> > > > ram
> > > > /
> > > > validation-search?searchMode=validation&family=1&productType=-1&ipp=2
> > > > 5
> > > > 
> > > > [3]
> > > > https://csrc.nist.gov/projects/cryptographic-algorithm-validation-prog
> > > > ram
> > > > / details?validation=32608
> > > > 
> > > > [4] https://github.com/smuellerDD/acvpparser
> > > > 
> > > > > Cc: Stephan Mueller <smueller@chronox.de>
> > > > > 
> > > > > Ard Biesheuvel (2):
> > > > >   crypto: arm64/aes - align output IV with generic CBC-CTS driver
> > > > >   crypto: testmgr - add output IVs for AES-CBC with ciphertext
> > > > >   stealing
> > > > >  
> > > > >  arch/arm64/crypto/aes-modes.S |  2 ++
> > > > >  crypto/testmgr.h              | 12 ++++++++++++
> > > > >  2 files changed, 14 insertions(+)
> > > > 
> > > > Ciao
> > > > Stephan
> > 
> > Ciao
> > Stephan


Ciao
Stephan


