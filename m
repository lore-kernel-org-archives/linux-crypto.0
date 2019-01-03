Return-Path: <SRS0=pN5v=PL=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40683 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731353AbfACROq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 12:14:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id p4so34247321wrt.7
        for <linux-crypto@vger.kernel.org>; Thu, 03 Jan 2019 09:14:45 -0800 (PST)
Date: Thu, 3 Jan 2019 17:14:41 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Sumit Garg <sumit.garg@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
Subject: Re: [PATCH v1 1/2] dt/bindings: add bindings for optional optee
 rng-uuid property
Message-ID: <20190103171441.6ymnhbxnb4asr3kl@holly.lan>
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
 <1545908831-25910-2-git-send-email-sumit.garg@linaro.org>
 <CAKv+Gu8o_6Mu8_2vNHXEy46mZ6xrSPekcwPH7BvxR8nec37Ktw@mail.gmail.com>
 <CAFA6WYOpw-URTYJ4i0Y_Tie0_ccMwekbOVzXz3d05NttyL9sHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYOpw-URTYJ4i0Y_Tie0_ccMwekbOVzXz3d05NttyL9sHg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 28, 2018 at 02:41:01PM +0530, Sumit Garg wrote:
> On Thu, 27 Dec 2018 at 19:10, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > On Thu, 27 Dec 2018 at 12:08, Sumit Garg <sumit.garg@linaro.org> wrote:
> > >
> > > Add bindings for OP-TEE based optional hardware random number
> > > generator identifier property. It could be used on ARM based devices
> > > where entropy source is not accessible to normal world (linux in this
> > > case).
> > >
> > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > > ---
> > >  Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > > index d38834c..e3a4c35 100644
> > > --- a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > > +++ b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > > @@ -20,6 +20,9 @@ the reference implementation maintained by Linaro.
> > >                     "hvc" : HVC #0, with the register assignments specified
> > >                            in drivers/tee/optee/optee_smc.h
> > >
> > > +- rng-uuid       : Optional OP-TEE based RNG service identifier in case
> > > +                   hardware entropy source is not accesible to normal world
> > > +                   (Linux).
> > >
> > >
> > >  Example:
> > > @@ -27,5 +30,6 @@ Example:
> > >                 optee {
> > >                         compatible = "linaro,optee-tz";
> > >                         method = "smc";
> > > +                       rng-uuid = "ab7a617c-b8e7-4d8f-8301-d09b61036b64";
> >
> > If OP-TEE is going to expose devices in this way, it should be modeled
> > more like a bus driver, i.e., sub-nodes that represent the devices,
> > with compatible strings, and perhaps even 'reg' properties for the
> > UUIDs.
> >
> 
> This is something Daniel also suggested during our discussion. But we
> agreed to discuss in upstream to get more feedback.
> 
> I think generic TEE should be modelled as a bus driver with devices
> identified via UUIDs, probably queried from underline implementations
> like OP-TEE regarding which resident devices (pseudo-TA UUIDs) it
> supports. Then this list of device UUIDs can be compared against child
> driver's UUID as part of match callback during driver registration.
> Also the child driver could maintain list of device UUIDs which it
> supports.
> 
> If we go via this approach we may not require device tree entry for
> corresponding device UUIDs.

That's pretty much aligned with my thinking.

Having said that I had wondered whether all TEEs would be prepared to
describe the set of available UUIDs since AFAIK UUID enumeration isn't
part of the GlobalPlatform standards so it is not implemented by GP
based TEEs (such as OP-TEE).

Is it feasible to extend OP-TEE to enumerate the available UUIDs?
If nothing else can it provide an (optional) pseudo TA to provide such a
service? Personally I'd be OK with a kernel TEE bus infrastructure that
mandated such a service (e.g. a TEE that does not provide the service
can only interact with TEE from userspace).


Daniel.
