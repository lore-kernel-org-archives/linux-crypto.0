Return-Path: <SRS0=sHEo=PF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0350C43387
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Dec 2018 09:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B59CE20645
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Dec 2018 09:11:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="aaBSFVAu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbeL1JLN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Dec 2018 04:11:13 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:45914 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbeL1JLN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Dec 2018 04:11:13 -0500
Received: by mail-vs1-f65.google.com with SMTP id x28so12642180vsh.12
        for <linux-crypto@vger.kernel.org>; Fri, 28 Dec 2018 01:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xKszBAyxOPH5BA3QopoLYklExQ6N8k8XRioiYzaJVBQ=;
        b=aaBSFVAuXGQn9qg+sgTAaBAhyel8MpOb5+htBZBbWn8jU/Z2Rl87+BD6WyxrXCk2RY
         NM/pyO8ZNru2p5Cl2PmUeWOjBPisteuRBQNd6vjzB59CRBOmkFMANRiAJHc8k/LtpiPk
         BZCpvPlKgh0KfEibfje33lMWy4XwErUYJBmuM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xKszBAyxOPH5BA3QopoLYklExQ6N8k8XRioiYzaJVBQ=;
        b=A9Z1rRiYEFqciB13vMZw7ORbp0rtzCByJ2pUfpxpNJhk2Lkf+MWaFRmxHEGi6tWmMz
         6cApDb4ch416CzvGUCn8iQ3yDfGZ1IOJTKPmdcA1B+DUSlllK7Bbm6KdUNaymjZIx3MU
         m96xKjjWB8njVkev3TtSkI+Y6vhcrhciP/U2ijTpUJvNbU5CC24n6ciBxILtseouBOhV
         OsDFB1DU0S70lFSpaz5Z0+mgY/hXu3Bl7+KWbm8RujdO3mGMrT5U5Iqys+hIxRCT8Hrn
         HVRZbrpEWnZwnEBhDj89Bhdmb7R3416IacW9vh7srz2rjC3yp6mk9K9T94rXN5ycNyrQ
         M7TA==
X-Gm-Message-State: AA+aEWakbOsNpHxhlL6d6br7G3GEkFeLxgs9kndiYl7XfcaJWOUwFbDP
        YQb/lbolG1e+bRtNskzeh3EFHUDWxN856KUjvpqDUw==
X-Google-Smtp-Source: ALg8bN6tkLRrISae92/qQaYawKp9WXdZAfAZm+Hx560a8YSTLyEDqPbv5u/Wco6AMx/vlG4FHVrWLF0D+ZiR0N26KlY=
X-Received: by 2002:a67:1b04:: with SMTP id b4mr10915141vsb.141.1545988272313;
 Fri, 28 Dec 2018 01:11:12 -0800 (PST)
MIME-Version: 1.0
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
 <1545908831-25910-2-git-send-email-sumit.garg@linaro.org> <CAKv+Gu8o_6Mu8_2vNHXEy46mZ6xrSPekcwPH7BvxR8nec37Ktw@mail.gmail.com>
In-Reply-To: <CAKv+Gu8o_6Mu8_2vNHXEy46mZ6xrSPekcwPH7BvxR8nec37Ktw@mail.gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 28 Dec 2018 14:41:01 +0530
Message-ID:
 <CAFA6WYOpw-URTYJ4i0Y_Tie0_ccMwekbOVzXz3d05NttyL9sHg@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] dt/bindings: add bindings for optional optee
 rng-uuid property
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181228091101.Vu2MmEyoJ7eiLRcN_lBd4kia2-3TjM3esP3ybsQvhRY@z>

On Thu, 27 Dec 2018 at 19:10, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 27 Dec 2018 at 12:08, Sumit Garg <sumit.garg@linaro.org> wrote:
> >
> > Add bindings for OP-TEE based optional hardware random number
> > generator identifier property. It could be used on ARM based devices
> > where entropy source is not accessible to normal world (linux in this
> > case).
> >
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > index d38834c..e3a4c35 100644
> > --- a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > +++ b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > @@ -20,6 +20,9 @@ the reference implementation maintained by Linaro.
> >                     "hvc" : HVC #0, with the register assignments specified
> >                            in drivers/tee/optee/optee_smc.h
> >
> > +- rng-uuid       : Optional OP-TEE based RNG service identifier in case
> > +                   hardware entropy source is not accesible to normal world
> > +                   (Linux).
> >
> >
> >  Example:
> > @@ -27,5 +30,6 @@ Example:
> >                 optee {
> >                         compatible = "linaro,optee-tz";
> >                         method = "smc";
> > +                       rng-uuid = "ab7a617c-b8e7-4d8f-8301-d09b61036b64";
>
> If OP-TEE is going to expose devices in this way, it should be modeled
> more like a bus driver, i.e., sub-nodes that represent the devices,
> with compatible strings, and perhaps even 'reg' properties for the
> UUIDs.
>

This is something Daniel also suggested during our discussion. But we
agreed to discuss in upstream to get more feedback.

I think generic TEE should be modelled as a bus driver with devices
identified via UUIDs, probably queried from underline implementations
like OP-TEE regarding which resident devices (pseudo-TA UUIDs) it
supports. Then this list of device UUIDs can be compared against child
driver's UUID as part of match callback during driver registration.
Also the child driver could maintain list of device UUIDs which it
supports.

If we go via this approach we may not require device tree entry for
corresponding device UUIDs.

-Sumit

> >                 };
> >         };
> > --
> > 2.7.4
> >
