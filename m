Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27540C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 14:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8CCD64E25
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 14:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhBIOGm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 09:06:42 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.25]:19860 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhBIOGl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 09:06:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1612879363;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
        From:Subject:Sender;
        bh=al3aXJJUhL1Wdg78kyMa4Aeutgo+kj3aKLm9dJbkSIo=;
        b=m8lHiDuMRKahNjqsxqhzZbS22iDCoamqbmxPlcwDEPG2PTcVDMUop1JTecTx1PsKm4
        QeR6jnuwmNVhAAeyN5uAk+S3UVMkktzdrgQAYBL4XQv51ohRyPnKdYlod6tVB20OjmoM
        4Z83ihSW8xHJWwrswnhYO7+1vLgAq+wnC0QPaC6G+mxv4c1yFh0oMW6/T9ihaJM1raZY
        AVCjo/v0noD0K4k3JrVKjhmkdDxF1O3xGqihdAYKlc3pF6BBl3FK8IUWLtLGcWlZmCpu
        af88lpS5TFnlhqQmBdiC38gpn5eG1oLUn6WlXfQrz1MTirrk0HLmyw1wLz6MDfPzJXEI
        eWLA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJSlHkMBaXg=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.17.1 DYNA|AUTH)
        with ESMTPSA id w01116x19E2e0Di
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 9 Feb 2021 15:02:40 +0100 (CET)
Message-ID: <a723e9dda54b5c874fde69f82a18276824364bb5.camel@chronox.de>
Subject: Re: [PATCH] crypto: testmgr - add NIAP FPT_TST_EXT.1 subset of tests
From:   Stephan Mueller <smueller@chronox.de>
To:     Elena Petrova <lenaptr@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Date:   Tue, 09 Feb 2021 15:02:39 +0100
In-Reply-To: <CABvBcwbOoeQqvJh=VkamF+qaRO-52mk54fEGMEQ16WWEb+TYEA@mail.gmail.com>
References: <20210108173849.333780-1-lenaptr@google.com>
         <4b688e56ae45defedb08603945741218736923c0.camel@chronox.de>
         <CABvBcwbOoeQqvJh=VkamF+qaRO-52mk54fEGMEQ16WWEb+TYEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, dem 09.02.2021 um 13:35 +0000 schrieb Elena Petrova:
> Hi Stephan,
> 
> On Fri, 8 Jan 2021 at 18:57, Stephan Mueller <smueller@chronox.de> wrote:
> > 
> > Am Freitag, dem 08.01.2021 um 17:38 +0000 schrieb Elena Petrova:
> > > NIAP FPT_TST_EXT.1 [1] specification requires testing of a small set of
> > > cryptographic modules on boot for devices that need to be NIAP
> > > compliant. This is also a requirement for FIPS CMVP 140-2/140-3
> > > certification.
> > > 
> > > Currently testmgr adds significant boot time overhead when enabled; we
> > > measured 3-5 seconds for Android.
> > 
> > I am not sure whether this is necessary. If you build the ciphers as
> > modules,
> > you can insmod them during boot time before general user space is made
> > available. Once you insmoded all needed KOs, you load tcrypt to invoke
> > them
> > which implies that they are verified. This approach allows user space to
> > determine which KOs are self-tested during boot.
> 
> We've asked our certification lab whether they'd approve the tcrypt
> testing, but they say they are concerned that the test would run too
> late and it won't exactly match the NIAP requirements.

Tcrypt does not do any testing, it simply allocates the ciphers to ensure that
the self tests defined in testmgr are executed.

If tcrypt is loaded as one of the first steps in user space boot, the self
tests are executed before any algo is put to use.

> 
> > This is the approach all Linux validations took in the past.
> 
> If you could provide an example of some validation that folks from the
> ecosystem did successfully with tcrypt, then I might be able to point
> the lab to their CMVP certificate (like
>  
> https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/3753
> ),
> and maybe that'd make them happy with Android using tcrypt...

Search for all RHEL/SLES/Ubuntu CMVP kernel validations.

The key is in the dracut component:

https://github.com/dracutdevs/dracut/tree/master/modules.d/01fips
> 
> > Besides, for FIPS 140-3, it is now allowed to have "lazy" self testing
> > which
> > allows the self-tests to be executed before first use (just like what the
> > kernel testmgr already does).
> 
> Yeah, that's what I was intending to utilize in my patch: I just
> reduced the number of crypto modules to which the self-tests should
> apply, to avoid testing ones that aren't essential to certification.

What I mean is that with 140-3 the current kernel behavior of invoking the
testmgr during the first-time allocation of an algorithm is sufficient without
any changes to the current code.
> 
> > Can you please help us understand why the mentioned approach is not
> > sufficient?
> 
> Well, as I mentioned above, the certification lab is concerned about
> invoking tcrypt for testing because user-space controls it

Yes, user space controls it, but not the user. It is hard-wired into the boot
process.

>  and "it's
> too late".

Not sure how it can be too late if it is one of the first steps in the user
space boot.

>  And the testmgr, when fully enabled, introduces a big
> enough boot time increase for our Android team to shout at me angrily
> :) So I decided to go with "testmgr but partial".

Check the dracut approach - there you have your selection ability.

Ciao
Stephan
> 
> 
> Cheers,
> Elena


