Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6824C43387
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jan 2019 06:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B80C21871
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jan 2019 06:39:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="WVNaUjcJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfADGjf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Jan 2019 01:39:35 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:45129 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfADGjf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jan 2019 01:39:35 -0500
Received: by mail-vs1-f66.google.com with SMTP id x28so22126460vsh.12
        for <linux-crypto@vger.kernel.org>; Thu, 03 Jan 2019 22:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lidbEyUvLzPXJidCFAq6Xm2w0Oq4dU6T6tEiOhSAPWI=;
        b=WVNaUjcJwvVba4gDTMlCVGEz4YQ7Wn3dQGGjToxojUXp1+BT4ryhe4PJlCiubX1tcq
         fwmy9d5IQvlSurabCNd4R1yjYPf8qtvLy6n4fjR15LKySjURQvIIwZaTA22naPujUOlN
         sN7ismVLFk9U2EuCVgCb69KVdh6ml1ad//rEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lidbEyUvLzPXJidCFAq6Xm2w0Oq4dU6T6tEiOhSAPWI=;
        b=hWB92o+KlWcNhytmnQ3NBMV8YvzhM5YvIfafcSeT3Z2rXbdowCxvm9Kut3untb7XkF
         lUL3leg/KLVVCC2+m4xmbh1rTbf436G5YyeEDlhJJuVIF5B3npcF6kkib0Pz23u831MR
         pIld20dLdrnMZer/5g5z9reh0IJeOe72MFV6kGsbLDMzJGXbH/YZkFlhM3zol4tu5pUD
         LAz5Apqsg7Hcxebwu8dtRGjc1yS3UQ1StpWYYiF2gwTSZRcW097RiISr30fPWh9hWoZY
         eZT/zeqn5Kk6uZM3aqLFI3IbgLG0kXVjBl/Xi9SRWAHEWI+jDnGE/KiViYqSs/am9JhC
         jZTw==
X-Gm-Message-State: AA+aEWa5C3qlamV+vu7NqVP0LtwnZ0m7ZK/RO3kWuQaE7CIeJvmfgoLO
        4vqAMY+tORit9sSEtgs6fcPMWjuJ0PqKM1gyId/PvA==
X-Google-Smtp-Source: AFSGD/XR1QQKcBuXxKtqrxD+sT+Drg04UkUElDPBx9vkZvqnuR3rCYQo9kpHeJh1hcoVzP3HxWKXiwe5yDQoUyQPPWo=
X-Received: by 2002:a67:2045:: with SMTP id g66mr20795041vsg.180.1546583974067;
 Thu, 03 Jan 2019 22:39:34 -0800 (PST)
MIME-Version: 1.0
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
 <1545908831-25910-2-git-send-email-sumit.garg@linaro.org> <CAKv+Gu8o_6Mu8_2vNHXEy46mZ6xrSPekcwPH7BvxR8nec37Ktw@mail.gmail.com>
 <CAFA6WYOpw-URTYJ4i0Y_Tie0_ccMwekbOVzXz3d05NttyL9sHg@mail.gmail.com> <20190103171441.6ymnhbxnb4asr3kl@holly.lan>
In-Reply-To: <20190103171441.6ymnhbxnb4asr3kl@holly.lan>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 4 Jan 2019 12:09:22 +0530
Message-ID:
 <CAFA6WYP4TgWHaZpathACsKgtcG5xx81FJ+=saimQP6ZyHnL1=w@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] dt/bindings: add bindings for optional optee
 rng-uuid property
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20190104063922.6SarJhp46YQyCWqA-3eIScawLAb3PtyO6Ze6E87F_P8@z>

On Thu, 3 Jan 2019 at 22:44, Daniel Thompson <daniel.thompson@linaro.org> wrote:
>
> On Fri, Dec 28, 2018 at 02:41:01PM +0530, Sumit Garg wrote:
> > On Thu, 27 Dec 2018 at 19:10, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > >
> > > On Thu, 27 Dec 2018 at 12:08, Sumit Garg <sumit.garg@linaro.org> wrote:
> > > >
> > > > Add bindings for OP-TEE based optional hardware random number
> > > > generator identifier property. It could be used on ARM based devices
> > > > where entropy source is not accessible to normal world (linux in this
> > > > case).
> > > >
> > > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > > > ---
> > > >  Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > > > index d38834c..e3a4c35 100644
> > > > --- a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > > > +++ b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > > > @@ -20,6 +20,9 @@ the reference implementation maintained by Linaro.
> > > >                     "hvc" : HVC #0, with the register assignments specified
> > > >                            in drivers/tee/optee/optee_smc.h
> > > >
> > > > +- rng-uuid       : Optional OP-TEE based RNG service identifier in case
> > > > +                   hardware entropy source is not accesible to normal world
> > > > +                   (Linux).
> > > >
> > > >
> > > >  Example:
> > > > @@ -27,5 +30,6 @@ Example:
> > > >                 optee {
> > > >                         compatible = "linaro,optee-tz";
> > > >                         method = "smc";
> > > > +                       rng-uuid = "ab7a617c-b8e7-4d8f-8301-d09b61036b64";
> > >
> > > If OP-TEE is going to expose devices in this way, it should be modeled
> > > more like a bus driver, i.e., sub-nodes that represent the devices,
> > > with compatible strings, and perhaps even 'reg' properties for the
> > > UUIDs.
> > >
> >
> > This is something Daniel also suggested during our discussion. But we
> > agreed to discuss in upstream to get more feedback.
> >
> > I think generic TEE should be modelled as a bus driver with devices
> > identified via UUIDs, probably queried from underline implementations
> > like OP-TEE regarding which resident devices (pseudo-TA UUIDs) it
> > supports. Then this list of device UUIDs can be compared against child
> > driver's UUID as part of match callback during driver registration.
> > Also the child driver could maintain list of device UUIDs which it
> > supports.
> >
> > If we go via this approach we may not require device tree entry for
> > corresponding device UUIDs.
>
> That's pretty much aligned with my thinking.
>
> Having said that I had wondered whether all TEEs would be prepared to
> describe the set of available UUIDs since AFAIK UUID enumeration isn't
> part of the GlobalPlatform standards so it is not implemented by GP
> based TEEs (such as OP-TEE).
>
> Is it feasible to extend OP-TEE to enumerate the available UUIDs?
> If nothing else can it provide an (optional) pseudo TA to provide such a
> service? Personally I'd be OK with a kernel TEE bus infrastructure that
> mandated such a service (e.g. a TEE that does not provide the service
> can only interact with TEE from userspace).
>

Following is the kernel interface for OP-TEE device enumeration that I
would like to propose:

/*
 * Get next OP-TEE based kernel device
 *
 * Secure world can provide support for resident kernel devices/services
 * as pseudo/early trusted applications. So this function is used to
 * enumerate OP-TEE based kernel devices.
 *
 * Call register usage:
 * a0   SMC Function ID, OPTEE_SMC_GET_NEXT_DEVICE
 * a1-6 Not used
 * a7   Hypervisor Client ID register
 *
 * Possible return values:
 *
 * OP-TEE OS returns next device UUID.
 * a0   OPTEE_SMC_RETURN_OK
 * a1-4 Device UUID
 * a5-7 Preserved
 *
 * OP-TEE OS does not recognize this function.
 * a0   OPTEE_SMC_RETURN_UNKNOWN_FUNCTION
 * a1-7 Preserved
 *
 * OP-TEE OS done with device enumeration.
 * a0   OPTEE_SMC_RETURN_ENOTAVAIL
 * a1-7 Preserved
 */
#define OPTEE_SMC_FUNCID_GET_NEXT_DEVICE       15
#define OPTEE_SMC_GET_NEXT_DEVICE \
        OPTEE_SMC_FAST_CALL_VAL(OPTEE_SMC_FUNCID_GET_NEXT_DEVICE)

Also at OP-TEE end, we should add additional TA_FLAG_KERNEL_DEVICE to
detect particular pseudo/early TA as a kernel device during
enumeration.

-Sumit

>
> Daniel.
