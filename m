Return-Path: <SRS0=pN5v=PL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AA4C43387
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jan 2019 16:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBEE0208E3
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jan 2019 16:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546532422;
	bh=vm5cR3zFoUVG+fPx8qlkrOi2i8FaYtA6GZRA5uYv7x4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=p+MZcYIl57Av/jspkZo7lDBWxwLsBOnr/AZNynykE4RnwCnfVOhKG+1r68AXf36c3
	 A7JfRFK04fjYJyHQF+c6mwWUScHhUDsTNXDWCvx6bO00vRUQudY2ZkrwqbZ+5W7xxu
	 kXsiPfD8wokE67rLNPAeyI/5ggG4NRlqpLzbVu8g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731667AbfACQUV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jan 2019 11:20:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729598AbfACQUV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 11:20:21 -0500
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F101C21874;
        Thu,  3 Jan 2019 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546532420;
        bh=vm5cR3zFoUVG+fPx8qlkrOi2i8FaYtA6GZRA5uYv7x4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DytJu2Api1MeatyHo4o+UDhoV30bce8XKniMXbqniWN3whQCpyhdJ4qNb+MN/Bf8s
         5jwKVtSOs0AESWMWXvSPPsMoUjRW45xIGmXmyayFNp05VH/D6HgnrDO2MW2j70Qtu2
         Ct18307Lyj5ufyaHcCgwgH3lXdqLlQkJ3h7wwn0c=
Received: by mail-qt1-f173.google.com with SMTP id v11so37440397qtc.2;
        Thu, 03 Jan 2019 08:20:19 -0800 (PST)
X-Gm-Message-State: AJcUukdQ1m2ucHoVQUnl0V4OBrfGkyMbUozu+3oIw7OcmWcW14dDUW6W
        2nunMsTeTuY9q0RQkdDa1Wa50PGihddPEMf3yQ==
X-Google-Smtp-Source: ALg8bN4RFgYrgsuWbK9InrgAjL5zLC5dm1s69JnebTURHCzn0sDqdnZLu/p8FGF06Nv/zw3eMkcnI8IesCxcH7oiZfI=
X-Received: by 2002:aed:3ecf:: with SMTP id o15mr47811012qtf.26.1546532419073;
 Thu, 03 Jan 2019 08:20:19 -0800 (PST)
MIME-Version: 1.0
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
 <1545908831-25910-2-git-send-email-sumit.garg@linaro.org> <CAKv+Gu8o_6Mu8_2vNHXEy46mZ6xrSPekcwPH7BvxR8nec37Ktw@mail.gmail.com>
In-Reply-To: <CAKv+Gu8o_6Mu8_2vNHXEy46mZ6xrSPekcwPH7BvxR8nec37Ktw@mail.gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 3 Jan 2019 10:20:08 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKWLb1fYC6yT-w8eHFvsfYnVEK5EA85OhJ0dmGx5SaemA@mail.gmail.com>
Message-ID:
 <CAL_JsqKWLb1fYC6yT-w8eHFvsfYnVEK5EA85OhJ0dmGx5SaemA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] dt/bindings: add bindings for optional optee
 rng-uuid property
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
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
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20190103162008.8iVnRxMUvMSo8bEyM33l2o_55KLP1GsPINdn62uF76U@z>

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
