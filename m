Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD602FA3736
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 12:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3E93214E0
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 12:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pxijlpnJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390624AbfJQMwb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 08:52:31 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44194 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732689AbfJQMwa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 08:52:30 -0400
Received: by mail-lj1-f195.google.com with SMTP id m13so2399852ljj.11
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 05:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QrLNGivHk+MX8xmqPNs4VJfLnymqhdD216JwoEaih2o=;
        b=pxijlpnJvH+0Meiyj9IJb82BApkYa5Amf8UD++PDk2Vmv6edkmCzoFFXCRLntxyrC1
         mLkWZCG6OSWH+5i+vHjTerMGjh9sWPTJes3VNAUhsCvYuQnTCdR4Tg7ba2ic4lRik6KE
         JG2/FQ276AuTq9GpU+msGysKBTdy0rzz/xr4IuUdwM/l5r5qC8kKsIfyn2meaOzRInGT
         o5ksIUdYOzr8rmUJLsCOb/VBis8RXjC35uW1/4glW/GT3AVSC4oswPriEz6NnvJNAVm/
         zsW1cnRSp0R4crrk2JCd+r+mabjMCA2aBmK670MduETPO6SboZEEuq/rHegWThVf6NzS
         nS6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QrLNGivHk+MX8xmqPNs4VJfLnymqhdD216JwoEaih2o=;
        b=nf0NVaXhoveCFmKaAtq8qLITPgnBHIXwEO2XnQMjcKnstjN4Jdb8/CU75+OlAhdR93
         QwEJhCE4XPPIKCssy1J3p0FyQXRrLJzDIO9nlmmJ7VkHA7kwv6EGeMukVaYQ1Oza7vXf
         2eAcgz2TG+Y41dMlUed06yb5h2rCnxtUl1dKCuAPqSL/oTCEFOVi2pMUUwctIpxpoT9O
         jcp5u5fI9CzejlVimGfSJJZMnZ1RrX1F42bKvXMRVlts7KtMPfkQM0aHXQgo833IWHsZ
         AtQaf6738jcQAg1g6kJRn5Y9HsfnxpQGLGzmitBgQZP4YBd4WyaXDZqUtInEqHj8t7e5
         LzQA==
X-Gm-Message-State: APjAAAVLd4PvDHa67OGuJ2BqK2uk7iNqoUPKh0YaHa+c42gLuwX0zqN/
        oNEjcwLg0iuIbH+be9hfRgHFgQjWh40IhzC7BO1sYw==
X-Google-Smtp-Source: APXvYqzkqvovU/sudHAtBIJQ9t1ZDyznyMb/4m7doUJ9DprBLfCEEqxIwDTEJvxsF+Qg9xk6jO7VE2ktilr7QFgkKZo=
X-Received: by 2002:a2e:1214:: with SMTP id t20mr2401231lje.191.1571316748450;
 Thu, 17 Oct 2019 05:52:28 -0700 (PDT)
MIME-Version: 1.0
References: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
 <20191007000520.GA17116@linux.intel.com> <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
 <20191008234935.GA13926@linux.intel.com> <20191008235339.GB13926@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2B995@ALPMBAPA12.e2k.ad.ge.com>
 <20191014190033.GA15552@linux.intel.com> <1571081397.3728.9.camel@HansenPartnership.com>
 <20191016110031.GE10184@linux.intel.com> <1571229252.3477.7.camel@HansenPartnership.com>
 <20191016162543.GB6279@linux.intel.com> <1571253029.17520.5.camel@HansenPartnership.com>
In-Reply-To: <1571253029.17520.5.camel@HansenPartnership.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 17 Oct 2019 18:22:17 +0530
Message-ID: <CAFA6WYNNNTWXDrp_R3M60srGJYjJdRoaNpSnP54V_BinYYXTMA@mail.gmail.com>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Safford, David (GE Global Research, US)" <david.safford@ge.com>,
        Ken Goldman <kgold@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 17 Oct 2019 at 00:40, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Wed, 2019-10-16 at 19:25 +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 16, 2019 at 08:34:12AM -0400, James Bottomley wrote:
> > > reversible ciphers are generally frowned upon in random number
> > > generation, that's why the krng uses chacha20.  In general I think
> > > we shouldn't try to code our own mixing and instead should get the
> > > krng to do it for us using whatever the algorithm du jour that the
> > > crypto guys have blessed is.  That's why I proposed adding the TPM
> > > output to the krng as entropy input and then taking the output of
> > > the krng.
> >
> > It is already registered as hwrng. What else?
>
> It only contributes entropy once at start of OS.
>

Why not just configure quality parameter of TPM hwrng as follows? It
would automatically initiate a kthread during hwrng_init() to feed
entropy from TPM to kernel random numbers pool (see:
drivers/char/hw_random/core.c +142).

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 3d6d394..fcc3817 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -548,6 +548,7 @@ static int tpm_add_hwrng(struct tpm_chip *chip)
                 "tpm-rng-%d", chip->dev_num);
        chip->hwrng.name = chip->hwrng_name;
        chip->hwrng.read = tpm_hwrng_read;
+       chip->hwrng.quality = 1024; /* Here we assume TPM provides
full entropy */
        return hwrng_register(&chip->hwrng);

 }

> >  Was the issue that it is only used as seed when the rng is init'd
> > first? I haven't at this point gone to the internals of krng.
>
> Basically it was similar to your xor patch except I got the kernel rng
> to do the mixing, so it would use the chacha20 cipher at the moment
> until they decide that's unsafe and change it to something else:
>
> https://lore.kernel.org/linux-crypto/1570227068.17537.4.camel@HansenPartnership.com/
>
> It uses add_hwgenerator_randomness() to do the mixing.  It also has an
> unmixed source so that read of the TPM hwrng device works as expected.

Above suggestion is something similar to yours but utilizing the
framework already provided via hwrng core.

-Sumit

>
> James
>
>
>
>
>
