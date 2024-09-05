Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB25C19DFAE;
	Thu,  5 Sep 2024 20:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725567472; cv=none; b=D4p5wvPqobAMWCG/fUBGruSJsgzma66grpywLoGbzhVDNn6B8Kdb1s/6pD05ifKGqPJMKkgA5QxRwdNvz+ICH5P43fQv9Zanb62O7GPrMlWK7o2Cd/AsPiG9Pr1MY7rN06oSe7jZMFXWbG9+lCh3XaQZ1nXrcHarvHhsqMEZM08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725567472; c=relaxed/simple;
	bh=PqF86rgHSwVUXJ2XaWvB0y7i6D95Qb9KbyajzS44B0c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jj1KYERSFQDztiZnt7gUnuDCsuA6DJS5wg3wqJ49mJj+thgEb1kUOT9SySBWkrmivPNO5t6QAnUDo3BKIwWwV8V62+U9RExxAPecELUjQa0Hj1QfP6bAvfX5fTgBeChc+0M+mh80U0a7g0DHQ5Ov+7oqQ7U7/6oOzrEVIxibQx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s7pFJdCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s7pFJdCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6129AC4CEC9;
	Thu,  5 Sep 2024 20:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725567472;
	bh=PqF86rgHSwVUXJ2XaWvB0y7i6D95Qb9KbyajzS44B0c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s7pFJdCN8DlHiFmW7XdSif5gBYorELMSo13D/FeCAauNaUTqqro3QjXeOIHu3nIkp
	 AvPUYiUvI9jN0+qVqCiOiBV+pz7Jm7/zFraq/nzSa4JgHJq0WttZsRyuEMB0MXmckY
	 T8njBycV3oMHGAtw/Cce4XgLdNm+uQP67lh0BINfObJ8+qdQ7iAAVRnXyh92w5EJoo
	 WvRjd83jPKLuWFh5wNvCM1/T3HZAsYaqgfUsTPKbSVgh2TYxL++B7B3oqseP9iZNBQ
	 5ZBtLDoaXu9VtX39oTaSOVU6L9OTNY4CZV4ZcKAF9suL1KkHsQWe0ysBTfdHb+8fWR
	 YN/p6/eMhaamA==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2f74b6e1810so10077551fa.2;
        Thu, 05 Sep 2024 13:17:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVOyQHdoRdmgXWpvdL3gAVHpnGPtE+CgJL3/QZpaJGscGmWjA79ICdlnQUYGWR0ruTrAwRN9xXPuAkXiYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YynonH7LESm1fh5NoMCDlHLJ2rPmRn2aCyyECwoekmStClLnZNU
	JAV27NKY90w57kSshoMn30mqs8dMJ7tGyZkbogg8pbq6XD32DR3cNyLhf1PMsLZDiHP/sKgBAn8
	wJq1mwrmYiYqCZ2VVs9jT9Pm7DA==
X-Google-Smtp-Source: AGHT+IFIaTOIm6wDjFY/K9qo1vtqPJMW2DOHGqE9tPQJ/qWCBIKjFfGykiOEPXKVyp0tqMpqB/Z4sNOgLMW9mHfmgms=
X-Received: by 2002:a05:651c:506:b0:2f7:4fac:f69f with SMTP id
 38308e7fff4ca-2f751ec9751mr1769511fa.12.1725567470696; Thu, 05 Sep 2024
 13:17:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240905150910.239832-1-pavitrakumarm@vayavyalabs.com>
 <20240905150910.239832-2-pavitrakumarm@vayavyalabs.com> <20240905182345.GA2432714-robh@kernel.org>
 <CALxtO0mkmyaDYta0tfx9Q1qi_GY0OwUoFDDVmcL15UH_fEZ25w@mail.gmail.com>
In-Reply-To: <CALxtO0mkmyaDYta0tfx9Q1qi_GY0OwUoFDDVmcL15UH_fEZ25w@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 5 Sep 2024 15:17:37 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJKi56z2xUfkrTa3xRKFhSo3P=269Yq_bw3tnxgpV+_eA@mail.gmail.com>
Message-ID: <CAL_JsqJKi56z2xUfkrTa3xRKFhSo3P=269Yq_bw3tnxgpV+_eA@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] dt-bindings: crypto: Document support for SPAcc
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: devicetree@vger.kernel.org, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 2:28=E2=80=AFPM Pavitrakumar Managutte
<pavitrakumarm@vayavyalabs.com> wrote:
>
> HI Rob,
>   Thanks for the review and feedback.
>
> On Thu, Sep 5, 2024 at 11:53=E2=80=AFPM Rob Herring <robh@kernel.org> wro=
te:
> >
> > On Thu, Sep 05, 2024 at 08:39:10PM +0530, Pavitrakumar M wrote:
> > > Add DT bindings related to the SPAcc driver for Documentation.
> > > DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> > > Engine is a crypto IP designed by Synopsys.
> >
> > This belongs with the rest of your driver series.
> PK: I will club this with the SPAcc driver patch-set.
>
> >
> > >
> > > Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
> > > Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> >
> > There's 2 possibilities: Bhoomika is the author and you are just
> > submitting it, or you both developed it. The former needs the git autho=
r
> > fixed to be Bhoomika. The latter needs a Co-developed-by tag for
> > Bhoomika.
> PK:  Its co-developed. I will add co-developed-by tag for Bhoomika in
> all the patches.

Also, please use full names.

> > > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> > > ---
> > >  .../bindings/crypto/snps,dwc-spacc.yaml       | 79 +++++++++++++++++=
++
> > >  1 file changed, 79 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc=
-spacc.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.=
yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> > > new file mode 100644
> > > index 000000000000..a58d1b171416
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> > > @@ -0,0 +1,79 @@
> > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Synopsys DesignWare Security Protocol Accelerator(SPAcc) Cryp=
to Engine
> > > +
> > > +maintainers:
> > > +  - Ruud Derwig <Ruud.Derwig@synopsys.com>
> > > +
> > > +description:
> > > +  DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto =
Engine is
> > > +  a crypto IP designed by Synopsys, that can accelerate cryptographi=
c
> > > +  operations.
> > > +
> > > +properties:
> > > +  compatible:
> > > +    contains:
> >
> > Drop contains. The list of compatible strings and order must be defined=
.
> PK: Will drop it as the SPAcc driver is using just "snps,dwc-spacc".
> >
> > > +      enum:
> > > +        - snps,dwc-spacc
> > > +        - snps,dwc-spacc-6.0
> >
> > What's the difference between these 2? The driver only had 1 compatible=
,
> > so this should too.
> PK: Will fix this to "snps,dwc-spacc"
> >
> > > +
> > > +  reg:
> > > +    maxItems: 1
> > > +
> > > +  interrupts:
> > > +    maxItems: 1
> > > +
> > > +  clocks:
> > > +    maxItems: 1
> > > +
> > > +  clock-names:
> > > +    maxItems: 1
> >
> > No, you must define the name. But really, just drop it because you don'=
t
> > need names with only 1 name.
> PK: Will remove it.
> >
> > > +
> > > +  little-endian: true
> >
> > Do you really need this? You have a BE CPU this is used with?
> PK: Its a configurable IP. Can be used in little and big-endian configura=
tions.
>        We have tested it on Little-endian CPUs only. (Xilinx Zynq
> Ultrascale ZCU104)

Not testing BE is clear from reading the driver...

It's probably safe to assume the IP will be configured to match the
processor. The endian properties are for the exceptions where the
peripherals don't match the CPU's endianness. This property can be
added when and if there's a platform needing it. Any specific platform
should have a specific compatible added as well.

> >
> > > +
> > > +  vspacc-priority:
> >
> > Custom properties need a vendor prefix (snps,).
> PK: Will add vendor prefix.
> >
> > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > +    description:
> > > +      Set priority mode on the Virtual SPAcc. This is Virtual SPAcc =
priority
> > > +      weight. Its used in priority arbitration of the Virtual SPAccs=
.
> > > +    minimum: 0
> > > +    maximum: 15
> > > +    default: 0
> > > +
> > > +  vspacc-index:
> > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > +    description: Virtual spacc index for validation and driver funct=
ioning.
> >
> > We generally don't do indexes in DT. Need a better description of why
> > this is needed.
> PK: This is NOT for indexing into DT but more like an ID of a virtual SPA=
cc.
>        The SPAcc IP can be configured as virtual SPAccs for
> multi-processor support,
>        where they appear to be dedicated to each processor.
>        The SPAcc hardware supports 2-8 virtual SPAccs (each vSPAcc has
> its Register
>        bank and context-memory for crypto operations). The index here
> represents the
>        vSPAcc to be referenced.

Okay, I'd use 'id' rather than 'index' in that case.

Rob
