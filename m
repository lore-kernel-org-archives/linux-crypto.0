Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FA4C433E6
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 13:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1EC464ED7
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 13:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhBINhD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 08:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhBINgx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 08:36:53 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23F2C06178C
        for <linux-crypto@vger.kernel.org>; Tue,  9 Feb 2021 05:36:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id df22so23636468edb.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Feb 2021 05:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cPDAUpXbA+JnVXxl9uBCwZMoXP6jIITgEmOLa1yK4zY=;
        b=SP9ZlLN6kEAaa9UNPgNEdED6iutWeHDZNB7/mbhSvyTcuf82RopLZXkMEMTyYt4BEr
         LCOSW15CB4iWGN+3HD9/7uP5tZjsOQYMfX+wQz2QW80lFV2HjaVg6qe5+6EY+8uqLntM
         edgpwBzyzfzEY4e3RNwG1USg1KLDd9oijkav6m1kVYTdExrkiuQUDE1iHSJAtQK82hb/
         KfiO+o58MqCM2MvsULLQVFE4TaHtTtSt8oP9Ekuhv+ZeNR2adPmaoOXMGT+COA+orzdp
         uiA4WZrNWASk5VFAsBUwDC0fd9HI1ZLH++KEWE0LU7B7lj93j27oinYY7cBdyFH0bXnZ
         O4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cPDAUpXbA+JnVXxl9uBCwZMoXP6jIITgEmOLa1yK4zY=;
        b=aOxvWDm96sVN/VO7CerQ3HfzyEizteqSL7peSeoPDkPLsdt5J1orrcEZOIUBA6neA4
         eazPV/u522Mb2eNH6BlgB72d8UJMWOKi9Hai9Blrc/0qbN5Lyw4akaF0HRAal2dYczMj
         kizpupX3H0ob9c4U43pCX3t6G700KBBP9734Awyz+5XFWxSuRvcox8ehbknGP1WqWlm9
         RZ6n/muG6rT7Jxmm3xEuKtMKe/3n/3PzARg74knDWGhpj68ZPzeywjet0E8IvAkKX+GP
         POLATdmrS/mB11QdXXUR7wE/FhM6YZpbSDsRBo3SJByYtLAiEQ060UpjnW/wV+9UItNp
         BqoQ==
X-Gm-Message-State: AOAM531YsfOtLJ1XBRyAxcRyH1/HkrdXUYvLI7cJ+xQ152tak0qmvz8r
        PtLAkgMTzV1RS/rOqBx9xmkfWnC4v1UnwaN4g5k+rg==
X-Google-Smtp-Source: ABdhPJwRrL44bF5BZzveounKjsy/vy9ySmbfDKZ8kwwvB9QDrJ75O77qaxGJN453O600vWE2mN8HSEnH0UsO9zyUINc=
X-Received: by 2002:aa7:cc98:: with SMTP id p24mr23425806edt.126.1612877771264;
 Tue, 09 Feb 2021 05:36:11 -0800 (PST)
MIME-Version: 1.0
References: <20210108173849.333780-1-lenaptr@google.com> <4b688e56ae45defedb08603945741218736923c0.camel@chronox.de>
In-Reply-To: <4b688e56ae45defedb08603945741218736923c0.camel@chronox.de>
From:   Elena Petrova <lenaptr@google.com>
Date:   Tue, 9 Feb 2021 13:35:59 +0000
Message-ID: <CABvBcwbOoeQqvJh=VkamF+qaRO-52mk54fEGMEQ16WWEb+TYEA@mail.gmail.com>
Subject: Re: [PATCH] crypto: testmgr - add NIAP FPT_TST_EXT.1 subset of tests
To:     Stephan Mueller <smueller@chronox.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

On Fri, 8 Jan 2021 at 18:57, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Freitag, dem 08.01.2021 um 17:38 +0000 schrieb Elena Petrova:
> > NIAP FPT_TST_EXT.1 [1] specification requires testing of a small set of
> > cryptographic modules on boot for devices that need to be NIAP
> > compliant. This is also a requirement for FIPS CMVP 140-2/140-3
> > certification.
> >
> > Currently testmgr adds significant boot time overhead when enabled; we
> > measured 3-5 seconds for Android.
>
> I am not sure whether this is necessary. If you build the ciphers as modules,
> you can insmod them during boot time before general user space is made
> available. Once you insmoded all needed KOs, you load tcrypt to invoke them
> which implies that they are verified. This approach allows user space to
> determine which KOs are self-tested during boot.

We've asked our certification lab whether they'd approve the tcrypt
testing, but they say they are concerned that the test would run too
late and it won't exactly match the NIAP requirements.

> This is the approach all Linux validations took in the past.

If you could provide an example of some validation that folks from the
ecosystem did successfully with tcrypt, then I might be able to point
the lab to their CMVP certificate (like
https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/3753),
and maybe that'd make them happy with Android using tcrypt...

> Besides, for FIPS 140-3, it is now allowed to have "lazy" self testing which
> allows the self-tests to be executed before first use (just like what the
> kernel testmgr already does).

Yeah, that's what I was intending to utilize in my patch: I just
reduced the number of crypto modules to which the self-tests should
apply, to avoid testing ones that aren't essential to certification.

> Can you please help us understand why the mentioned approach is not
> sufficient?

Well, as I mentioned above, the certification lab is concerned about
invoking tcrypt for testing because user-space controls it and "it's
too late". And the testmgr, when fully enabled, introduces a big
enough boot time increase for our Android team to shout at me angrily
:) So I decided to go with "testmgr but partial".


Cheers,
Elena
