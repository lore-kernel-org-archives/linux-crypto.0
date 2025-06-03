Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFD0AD5E
	for <linux-crypto@vger.kernel.org>; Tue,  3 Jun 2025 11:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748951146; cv=none; b=Afqihop/ze3SgjfmT9Vnzq7iE2M1pViDckKMZ7kAlZyW/3cXffOHCdZBTyO3/WZXIqyNhwKE4y/80be11oVcLmHZGzcH81+UDX+jt9D3VAva8xHEIjks7Ya7ihP/2fL3lNHGFbgobBLHnPrMRBDHSteM3Kx4IT4t0QQ7hvMu6so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748951146; c=relaxed/simple;
	bh=Wtk6AFHWfq6XPA5wRUyQI9qTTYvmaR7EWEbBvQSTd4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gxlq1T212K71B6pGQROE5/M2sSh3OjK7Aps4rpJ59IAApIwGwh5+4e8+fBiJ+ogweAcnW0z1N24Lsn5VDqmT8NgjriOqnVYjn/UvG13rxNCbKcZrIsxAbLDifP7cGKtOnPwjby8LhGbQcu2OavN6VRv+dPiuXQmDeAm8TayQP+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=HAHggRZ7; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="HAHggRZ7"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e73e9e18556so5024799276.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jun 2025 04:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1748951143; x=1749555943; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WU2jL29VSYgtyt74swmZUn3uXnZniaAi4pgLdOtSj3A=;
        b=HAHggRZ7FlxI9loqStLqrmv+eEe0P0pHJ+oXG//ZhWVZ1Hl2NnLBGHR8jMsMoTUNYY
         WXCwLNhmOSNPPuFmRGHV+wUaqdQUS11ybAzvQCQqW5h0ou75kRQh6ADOBUD3jwShKqUu
         MyHu87I1ERWHZYnIM9mRYrquW31KKH6+HAGsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748951143; x=1749555943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WU2jL29VSYgtyt74swmZUn3uXnZniaAi4pgLdOtSj3A=;
        b=Wl+eHHzwIM40jnFMMvViT3q8g/JZoKaeERhbhf0mzCahs+3B7vaSIin0Uj4K4xCsu9
         fjyA2STAQwtDpvHcCy/124Ya1g2v6pVGXXvfMWLTQDP2HNqs1PGNDyH6vjlnbIIgTfgD
         jMZy5E0chuC3FH9YmeLbnYaNz41eJleIDnCcqlqbVfY4qyboN37kAUMwVSkMTMSyZPLr
         QdRetH08gprsR8Wyhjr3MAOVRWsKIX9SiXlTCaZ2vG+kMYPOXoQzqNKZfXt1MElYKKCo
         CoCdV5KOYXguGY240UM6xR2YGLZkM+t5B2oC3zlODfm/8BuWQ68beBPqQShzfuTvtpFX
         4YVQ==
X-Gm-Message-State: AOJu0YzPyIXT7wU5gfg5Dg5FjnOKuAtM6YD81Gf/gQAyluAA2r74pgyn
	RavSOT1dxzY4FOab34JBRsfqBkcRiGubL67sFn//wQQFibsF4b/uMLPIytP+FTs1AvaoyJmsduy
	q1Bf+ypODMoWmcj6sZsBr1qo4yTyb4iPykJyRqSxE4g==
X-Gm-Gg: ASbGnctOC9fDD/Wfr1wJhZv7faQxRyL3BBLbUSKIXdV4pedl2DnU9hlkCPq4WrOJTmh
	TEwev2CvkFio49LUCXnqFxQwHEpB+Uhr+SDNVDJSkScU/i7LCKlWIp9bxYAO2Di61CK7V4xyDdF
	j1jqpKsCRbys8lw3WG6S94omumWpvf6iu9DA==
X-Google-Smtp-Source: AGHT+IFZFuVWzeSCYr5E7m41i/9aDNVpyn69bOnsaB/aNiCiM41tO005L0j039m41q399lOdfjixO5eaHFaDG/FfEfo=
X-Received: by 2002:a05:6902:4911:b0:e7d:c9e1:170d with SMTP id
 3f1490d57ef6-e8161e52682mr2384135276.11.1748951142488; Tue, 03 Jun 2025
 04:45:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250602053231.403143-1-pavitrakumarm@vayavyalabs.com>
 <20250602053231.403143-2-pavitrakumarm@vayavyalabs.com> <fae97f84-bdb9-42de-b292-92d2b262f16a@kernel.org>
In-Reply-To: <fae97f84-bdb9-42de-b292-92d2b262f16a@kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Tue, 3 Jun 2025 17:15:31 +0530
X-Gm-Features: AX0GCFsi1_WhsXRy4U7lWQV3XKiZq8jOsIJ1nSTGBjFSBrQaz8ZfGBHLoV3EgL4
Message-ID: <CALxtO0mpQtqPB0h_Wff2dLGo=Mxk02JJQkK4rn+=TuScNdSfxQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] dt-bindings: crypto: Document support for SPAcc
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, 
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,
  Thanks for the inputs, my comments are embedded below.

Warm regards,
PK

On Mon, Jun 2, 2025 at 11:28=E2=80=AFAM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On 02/06/2025 07:32, Pavitrakumar Managutte wrote:
> > Add DT bindings related to the SPAcc driver for Documentation.
> > DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> > Engine is a crypto IP designed by Synopsys.
> >
> > Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> > Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> > Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
>
> Where was this Ack given? It's not on the lists, it's not public, so it
> cannot be after your SoB.

PK: Yes, its not on the mailing list. I will remove that.

>
> > ---
> >  .../bindings/crypto/snps,dwc-spacc.yaml       | 77 +++++++++++++++++++
> >  1 file changed, 77 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-s=
pacc.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.ya=
ml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> > new file mode 100644
> > index 000000000000..2780b3db2182
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> > @@ -0,0 +1,77 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Synopsys DesignWare Security Protocol Accelerator(SPAcc) Crypto=
 Engine
> > +
> > +maintainers:
> > +  - Ruud Derwig <Ruud.Derwig@synopsys.com>
> > +
> > +description: |
> > +  This binding describes the Synopsys DWC Security Protocol Accelerato=
r (SPAcc),
>
> Don't say that binding describes a binding.  Describe here hardware.

PK: Sure, I will fix that.

>
> > +  which is a hardware IP designed to accelerate cryptographic operatio=
ns, such
> > +  as encryption, decryption, and hashing.
> > +
> > +  The SPAcc supports virtualization where a single physical SPAcc can =
be
> > +  accessed as multiple virtual SPAcc instances, each with its own regi=
ster set.
> > +  These virtual instances can be assigned different priorities.
> > +
> > +  In this configuration, the SPAcc IP is instantiated within the Synop=
sys
> > +  NSIMOSCI virtual SoC platform, a SystemC simulation environment used=
 for
> > +  software development and testing. The device is accessed as a memory=
-mapped
> > +  peripheral and generates interrupts to the ARC interrupt controller.
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - const: snps,nsimosci-hs-spacc
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  snps,vspacc-id:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description: |
> > +      Virtual SPAcc instance identifier.
> > +      The SPAcc hardware supports multiple virtual instances (determin=
ed by
> > +      ELP_SPACC_CONFIG_VSPACC_CNT parameter), and this ID is used to i=
dentify
> > +      which virtual instance this node represents.
>
> No, IDs are not accepted.

PK: This represents the specific virtual SPAcc that is being used in
the current configuration. It is used to index into the register banks
and the context memories of the virtual SPAcc that is being used. The
SPAcc IP can be configured as dedicated virtual SPAccs in
heterogeneous environments.

This was also discssed with Rob Herring and updated from
"vpsacc-index" to "vspacc-id" based on Rob's inputs
https://lore.kernel.org/linux-crypto/CALxtO0mkmyaDYta0tfx9Q1qi_GY0OwUoFDDVm=
cL15UH_fEZ25w@mail.gmail.com/

>
> > +    minimum: 0
> > +    maximum: 7
> > +
> > +  snps,spacc-internal-counter:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description: |
> > +      Hardware counter that generates an interrupt based on a count va=
lue.
> > +      This counter starts ticking when there is a completed job sittin=
g on
> > +      the status fifo to be serviced. This makes sure that no jobs are
> > +      starved of processing.
>
> Not a DT property.

PK: This is a hardware counter which starts ticking when a processed
job is sitting on the STAT FIFO. This makes sure a JOB does not stay
in STATUS FIFO unprocessed.

This was called watchdog timer - wdtimer, which we renamed to
"spacc-internal-counter" based on your inputs.
https://lore.kernel.org/linux-crypto/CALxtO0k4RkopERap_ykrMTZ4Qtdzm8hEPJGLC=
Q2pknQGjfQ4Eg@mail.gmail.com/

If you think this "does not qualify" as a DT property, I will make
this into a Kconfig input for the driver.

>
> > +    minimum: 0x19000
> > +    maximum: 0xFFFFF
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +
>
> Drop blank line.

PK: I will fix that

>
> > +    crypto@40000000 {
> > +        compatible =3D "snps,nsimosci-hs-spacc";
> > +        reg =3D <0x40000000 0x3FFFF>;
>
> Lowercase hex only.

PK: I will fix that

>
>
>
> Best regards,
> Krzysztof
