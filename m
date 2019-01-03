Return-Path: <SRS0=pN5v=PL=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729598AbfACQUV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 11:20:21 -0500
MIME-Version: 1.0
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
 <1545908831-25910-2-git-send-email-sumit.garg@linaro.org> <CAKv+Gu8o_6Mu8_2vNHXEy46mZ6xrSPekcwPH7BvxR8nec37Ktw@mail.gmail.com>
In-Reply-To: <CAKv+Gu8o_6Mu8_2vNHXEy46mZ6xrSPekcwPH7BvxR8nec37Ktw@mail.gmail.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Thu, 3 Jan 2019 10:20:08 -0600
Message-ID: <CAL_JsqKWLb1fYC6yT-w8eHFvsfYnVEK5EA85OhJ0dmGx5SaemA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] dt/bindings: add bindings for optional optee
 rng-uuid property
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 27, 2018 at 7:40 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
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

Please, no. We have DT for things that are not discoverable. Make
OP-TEE services/devices discoverable. We only need the OP-TEE node in
the first place because sub-functions of the SMC-CC itself isn't
discoverable. I suppose there could be some need to expose providers
to consumer nodes in DT, but that's not the case here.

Rob
