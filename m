Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-vs1-f66.google.com ([209.85.217.66]:42158 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfAGGqd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Jan 2019 01:46:33 -0500
Received: by mail-vs1-f66.google.com with SMTP id b74so26106532vsd.9
        for <linux-crypto@vger.kernel.org>; Sun, 06 Jan 2019 22:46:31 -0800 (PST)
MIME-Version: 1.0
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
 <1545908831-25910-2-git-send-email-sumit.garg@linaro.org> <CAKv+Gu8o_6Mu8_2vNHXEy46mZ6xrSPekcwPH7BvxR8nec37Ktw@mail.gmail.com>
 <CAFA6WYOpw-URTYJ4i0Y_Tie0_ccMwekbOVzXz3d05NttyL9sHg@mail.gmail.com>
 <20190103171441.6ymnhbxnb4asr3kl@holly.lan> <CAFA6WYP4TgWHaZpathACsKgtcG5xx81FJ+=saimQP6ZyHnL1=w@mail.gmail.com>
 <CAHUa44GwwfW9diUbar4+3L8OhJs3K9iiE2DfBxEBrwmLfczXKA@mail.gmail.com>
 <CAFA6WYNobWZq3Y1oK0UXrTzhuG6wQEU+koCWkKgXwpLAGXpfPA@mail.gmail.com>
 <CAHUa44GZz=MGiRUAgPzCGH_XCTJizX15KBq5=HEFw4rZ7Z_Riw@mail.gmail.com>
 <CAFA6WYP8fYO_6239_w+eOkN+zvMpcQBVfo+FC1nvhPx5bteDTg@mail.gmail.com> <CAKv+Gu-VjXisamK8P0LM5=LrtY7fGzAc3Vm3z9FcDV2eEiaR+Q@mail.gmail.com>
In-Reply-To: <CAKv+Gu-VjXisamK8P0LM5=LrtY7fGzAc3Vm3z9FcDV2eEiaR+Q@mail.gmail.com>
From: Sumit Garg <sumit.garg@linaro.org>
Date: Mon, 7 Jan 2019 12:16:18 +0530
Message-ID: <CAFA6WYMbxGa6qm0iV-p3D1iTv_110YV+k0igUWPJcY0oGXW-EA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] dt/bindings: add bindings for optional optee
 rng-uuid property
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Jens Wiklander <jens.wiklander@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 7 Jan 2019 at 11:29, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Mon, 7 Jan 2019 at 06:32, Sumit Garg <sumit.garg@linaro.org> wrote:
> >
> > On Fri, 4 Jan 2019 at 18:33, Jens Wiklander <jens.wiklander@linaro.org> wrote:
> > >
> > > On Fri, Jan 4, 2019 at 1:02 PM Sumit Garg <sumit.garg@linaro.org> wrote:
> > > >
> > > > On Fri, 4 Jan 2019 at 16:31, Jens Wiklander <jens.wiklander@linaro.org> wrote:
> > > > >
> > > > > On Fri, Jan 4, 2019 at 7:39 AM Sumit Garg <sumit.garg@linaro.org> wrote:
> > > > > >
> > > > > > On Thu, 3 Jan 2019 at 22:44, Daniel Thompson <daniel.thompson@linaro.org> wrote:
> > > > > > >
> > > > > > > On Fri, Dec 28, 2018 at 02:41:01PM +0530, Sumit Garg wrote:
> > > > > > > > On Thu, 27 Dec 2018 at 19:10, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > > > > > > > >
> > > > > > > > > On Thu, 27 Dec 2018 at 12:08, Sumit Garg <sumit.garg@linaro.org> wrote:
> > > > > > > > > >
> > > > > > > > > > Add bindings for OP-TEE based optional hardware random number
> > > > > > > > > > generator identifier property. It could be used on ARM based devices
> > > > > > > > > > where entropy source is not accessible to normal world (linux in this
> > > > > > > > > > case).
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > > > > > > > > > ---
> > > > > > > > > >  Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt | 4 ++++
> > > > > > > > > >  1 file changed, 4 insertions(+)
> > > > > > > > > >
> > > > > > > > > > diff --git a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > > > > > > > > > index d38834c..e3a4c35 100644
> > > > > > > > > > --- a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > > > > > > > > > +++ b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
> > > > > > > > > > @@ -20,6 +20,9 @@ the reference implementation maintained by Linaro.
> > > > > > > > > >                     "hvc" : HVC #0, with the register assignments specified
> > > > > > > > > >                            in drivers/tee/optee/optee_smc.h
> > > > > > > > > >
> > > > > > > > > > +- rng-uuid       : Optional OP-TEE based RNG service identifier in case
> > > > > > > > > > +                   hardware entropy source is not accesible to normal world
> > > > > > > > > > +                   (Linux).
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >  Example:
> > > > > > > > > > @@ -27,5 +30,6 @@ Example:
> > > > > > > > > >                 optee {
> > > > > > > > > >                         compatible = "linaro,optee-tz";
> > > > > > > > > >                         method = "smc";
> > > > > > > > > > +                       rng-uuid = "ab7a617c-b8e7-4d8f-8301-d09b61036b64";
> > > > > > > > >
> > > > > > > > > If OP-TEE is going to expose devices in this way, it should be modeled
> > > > > > > > > more like a bus driver, i.e., sub-nodes that represent the devices,
> > > > > > > > > with compatible strings, and perhaps even 'reg' properties for the
> > > > > > > > > UUIDs.
> > > > > > > > >
> > > > > > > >
> > > > > > > > This is something Daniel also suggested during our discussion. But we
> > > > > > > > agreed to discuss in upstream to get more feedback.
> > > > > > > >
> > > > > > > > I think generic TEE should be modelled as a bus driver with devices
> > > > > > > > identified via UUIDs, probably queried from underline implementations
> > > > > > > > like OP-TEE regarding which resident devices (pseudo-TA UUIDs) it
> > > > > > > > supports. Then this list of device UUIDs can be compared against child
> > > > > > > > driver's UUID as part of match callback during driver registration.
> > > > > > > > Also the child driver could maintain list of device UUIDs which it
> > > > > > > > supports.
> > > > > > > >
> > > > > > > > If we go via this approach we may not require device tree entry for
> > > > > > > > corresponding device UUIDs.
> > > > > > >
> > > > > > > That's pretty much aligned with my thinking.
> > > > > > >
> > > > > > > Having said that I had wondered whether all TEEs would be prepared to
> > > > > > > describe the set of available UUIDs since AFAIK UUID enumeration isn't
> > > > > > > part of the GlobalPlatform standards so it is not implemented by GP
> > > > > > > based TEEs (such as OP-TEE).
> > > > > > >
> > > > > > > Is it feasible to extend OP-TEE to enumerate the available UUIDs?
> > > > > > > If nothing else can it provide an (optional) pseudo TA to provide such a
> > > > > > > service? Personally I'd be OK with a kernel TEE bus infrastructure that
> > > > > > > mandated such a service (e.g. a TEE that does not provide the service
> > > > > > > can only interact with TEE from userspace).
> > > > > > >
> > > > > >
> > > > > > Following is the kernel interface for OP-TEE device enumeration that I
> > > > > > would like to propose:
> > > > > >
> > > > > > /*
> > > > > >  * Get next OP-TEE based kernel device
> > > > > >  *
> > > > > >  * Secure world can provide support for resident kernel devices/services
> > > > > >  * as pseudo/early trusted applications. So this function is used to
> > > > > >  * enumerate OP-TEE based kernel devices.
> > > > > >  *
> > > > > >  * Call register usage:
> > > > > >  * a0   SMC Function ID, OPTEE_SMC_GET_NEXT_DEVICE
> > > > > >  * a1-6 Not used
> > > > > >  * a7   Hypervisor Client ID register
> > > > > >  *
> > > > > >  * Possible return values:
> > > > > >  *
> > > > > >  * OP-TEE OS returns next device UUID.
> > > > > >  * a0   OPTEE_SMC_RETURN_OK
> > > > > >  * a1-4 Device UUID
> > > > > >  * a5-7 Preserved
> > > > > >  *
> > > > > >  * OP-TEE OS does not recognize this function.
> > > > > >  * a0   OPTEE_SMC_RETURN_UNKNOWN_FUNCTION
> > > > > >  * a1-7 Preserved
> > > > > >  *
> > > > > >  * OP-TEE OS done with device enumeration.
> > > > > >  * a0   OPTEE_SMC_RETURN_ENOTAVAIL
> > > > > >  * a1-7 Preserved
> > > > > >  */
> > > > > > #define OPTEE_SMC_FUNCID_GET_NEXT_DEVICE       15
> > > > > > #define OPTEE_SMC_GET_NEXT_DEVICE \
> > > > > >         OPTEE_SMC_FAST_CALL_VAL(OPTEE_SMC_FUNCID_GET_NEXT_DEVICE)
> > > > > >
> > > > > > Also at OP-TEE end, we should add additional TA_FLAG_KERNEL_DEVICE to
> > > > > > detect particular pseudo/early TA as a kernel device during
> > > > > > enumeration.
> > > > >
> > > > > I'd rather provide this enumeration via a pseudo TA, to keep the SMC
> > > > > interface as small as possible. The pseudo TA can be optional, if it's
> > > > > not available then there's no need to try to instantiate any dependent
> > > > > drivers either.
> > > > >
> > > >
> > > > I did thought about having a pseudo TA but following are some
> > > > negatives to this approach:
> > > > 1. Where do we specify UUID for this pseudo TA? Should it come from devicetree?
> > >
> > > This should be a well known UUID, provided in the .h file describing the TA.
> > >
> >
> > Ok.
> >
> > > > 2. Adds whole TEE call sequence (ctx, session, shared memory etc.)
> > > > during "optee_probe".
> > >
> > > Yes, is that a problem?
> > >
> >
> > Not a problem but simply fast call interface is comparatively quicker.
> >
> > > > 3. This pseudo TA would be exposed to user-space as well. I am not
> > > > sure if we would like user-space to access kernel device specific
> > > > info.
> > >
> > > Doesn't matter, that's not a secret. We can assume that an attacker
> > > already know the UUID of whatever TA it will target.
> > >
> >
> > Okay then as per your suggestion will implement enumeration via pseudo
> > TA approach.
> >
>
> But this also requires some kind of well-known GUID for the RNG function, no?

I don't think so. For optee-rng driver I plan to use following
rng_id_table (used during match callback) which could be populated
with other platform specific RNG UUID/GUID later:

struct tee_client_device_id rng_id_table[] = {
        {UUID_INIT(0xab7a617c, 0xb8e7, 0x4d8f,
                   0x83, 0x01, 0xd0, 0x9b, 0x61, 0x03, 0x6b, 0x64)},
        {}
};

-Sumit
