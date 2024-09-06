Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C6914264A
	for <linux-crypto@vger.kernel.org>; Fri,  6 Sep 2024 06:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725605951; cv=none; b=Kn7TWjOlgZl6a6YUXo/Pp1RBrNEyh+3gjAgoXUnvpwY13vg8ntWUe+onCiAec0fQRxTCDEGXDMZCDTXMU5P+Judv3nZuzuYsOQo3VVraH8Vs5U8DnzXrP+uFqSZG1PBA2z/sU5LfeDeIvO3OFiHvNXkQO8qW/AEaWOUhpioK+oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725605951; c=relaxed/simple;
	bh=hoqy8/LtGLieG2IHryWmfRqOMxfwVy1hoEBz/JAtG1k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ViKWMB3uw50U5LdBPR0LUCwZhgQ+eVVWHhuFyOeAv5acNpnkl89YLx/DUrjSxZ0pGRICu4NPdJCxzmkpjnaoxKWO/HzQ2+ViS6MRKOpl1k7PRg5SL4ABpg4QqwVbAYTiaDujhcTpYdquBky/T1qtUOv1jAFlChiWJAfsWih9kkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=W9SIeTRj; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="W9SIeTRj"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6d74ff7216eso15814127b3.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 23:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725605947; x=1726210747; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTOcnPukofNY69q9xx/LxLv2ThFgZ7XXlqPjPaPgfLU=;
        b=W9SIeTRjREmQpUTbS8NBdIfE1kzQopCVK/QyrtjQS1P7eXW0aOB8ncSFKsJ/huOmBa
         otNuRndrKrb0cenvFftHrC0e1ZVjO7S6uXR8CxAZhZoxp34MEuTkVyehwn+c4crXmHGh
         J5zTXmd9ImH4g514AhLsjMTyAk21S1Ci/4mD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725605947; x=1726210747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uTOcnPukofNY69q9xx/LxLv2ThFgZ7XXlqPjPaPgfLU=;
        b=WN/fvF9dAIJTtSk2JK8Nk+R1bNdXD7VyWQHFTsJReOQKObpzh+Tt0u4qo3tp1FcMKw
         pUl6MkCt2S+fegh51sF8J7Ndx+jXuhq3dkjIaFwNGptUGzL38HR9ChDtuiDOgMhJ1sU2
         Tpv8fiNQg0VcosgQvSritkrtftjCmLmwfmllOAI0lZBT5fqnm9O8t7JA5LznLr9PACI9
         YVn+0peeTGEvRW5tKiXGSxoq1KuoEmCL+PU0DTgOy0KesfPh+ybSaur/enVIdCTYHNwS
         WlYZko6VCAovxcd59fePGLRV5aZ5+AbGkU/C19pQhEprSkChr3D4K2TvjICCgYhCe/aI
         n02g==
X-Forwarded-Encrypted: i=1; AJvYcCUHb26i5I8QmuU8iY/twvT/qKsKKfENza6oormLeqSq9oM2T1LxySAJiNeVIyUfGdLPNgzKtNIfMtzdw/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDyr9oFtsMv7bXxRCvBCItLyNDKw4RwT3C77BA5D0lguKLekSe
	/CZIClxvgYxkW21Qgg9UvK0kSp49tQanxHXfv8vcLDXRA6loeUI9E+4oCBJ1SQt7XIBkdp5qPcI
	2k8wJJOIuYnZ/IoyL1u5qXRbbactEK/aurTwxjg==
X-Google-Smtp-Source: AGHT+IE/bW4JDRzeOrZX8a/Y2PxcGKbkLkVWrWjlTGm1JtfTLsPgjZNUEHKOT8rAhBQxpb/BeSYPQHeajzPowmitfNU=
X-Received: by 2002:a05:690c:2d06:b0:6ac:d0ac:f74d with SMTP id
 00721157ae682-6db44f33cc2mr13345417b3.26.1725605947349; Thu, 05 Sep 2024
 23:59:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240905150910.239832-1-pavitrakumarm@vayavyalabs.com>
 <20240905150910.239832-2-pavitrakumarm@vayavyalabs.com> <20240905182345.GA2432714-robh@kernel.org>
 <CALxtO0mkmyaDYta0tfx9Q1qi_GY0OwUoFDDVmcL15UH_fEZ25w@mail.gmail.com> <CAL_JsqJKi56z2xUfkrTa3xRKFhSo3P=269Yq_bw3tnxgpV+_eA@mail.gmail.com>
In-Reply-To: <CAL_JsqJKi56z2xUfkrTa3xRKFhSo3P=269Yq_bw3tnxgpV+_eA@mail.gmail.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 6 Sep 2024 12:28:56 +0530
Message-ID: <CALxtO0kM_GtDtoZUvD6eKpLE2GmBtLotjbKLfakmyB9E2EoTJQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] dt-bindings: crypto: Document support for SPAcc
To: Rob Herring <robh@kernel.org>
Cc: devicetree@vger.kernel.org, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rob,
  Thanks for the review, I will update and push the patches accordingly.

Warm regards,
PK

On Fri, Sep 6, 2024 at 1:47=E2=80=AFAM Rob Herring <robh@kernel.org> wrote:
>
> On Thu, Sep 5, 2024 at 2:28=E2=80=AFPM Pavitrakumar Managutte
> <pavitrakumarm@vayavyalabs.com> wrote:
> >
> > HI Rob,
> >   Thanks for the review and feedback.
> >
> > On Thu, Sep 5, 2024 at 11:53=E2=80=AFPM Rob Herring <robh@kernel.org> w=
rote:
> > >
> > > On Thu, Sep 05, 2024 at 08:39:10PM +0530, Pavitrakumar M wrote:
> > > > Add DT bindings related to the SPAcc driver for Documentation.
> > > > DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> > > > Engine is a crypto IP designed by Synopsys.
> > >
> > > This belongs with the rest of your driver series.
> > PK: I will club this with the SPAcc driver patch-set.
> >
> > >
> > > >
> > > > Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
> > > > Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> > >
> > > There's 2 possibilities: Bhoomika is the author and you are just
> > > submitting it, or you both developed it. The former needs the git aut=
hor
> > > fixed to be Bhoomika. The latter needs a Co-developed-by tag for
> > > Bhoomika.
> > PK:  Its co-developed. I will add co-developed-by tag for Bhoomika in
> > all the patches.
>
> Also, please use full names.
PK: Will do that
>
> > > > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> > > > ---
> > > >  .../bindings/crypto/snps,dwc-spacc.yaml       | 79 +++++++++++++++=
++++
> > > >  1 file changed, 79 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/crypto/snps,d=
wc-spacc.yaml
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spac=
c.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> > > > new file mode 100644
> > > > index 000000000000..a58d1b171416
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> > > > @@ -0,0 +1,79 @@
> > > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > > +%YAML 1.2
> > > > +---
> > > > +$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
> > > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > > +
> > > > +title: Synopsys DesignWare Security Protocol Accelerator(SPAcc) Cr=
ypto Engine
> > > > +
> > > > +maintainers:
> > > > +  - Ruud Derwig <Ruud.Derwig@synopsys.com>
> > > > +
> > > > +description:
> > > > +  DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypt=
o Engine is
> > > > +  a crypto IP designed by Synopsys, that can accelerate cryptograp=
hic
> > > > +  operations.
> > > > +
> > > > +properties:
> > > > +  compatible:
> > > > +    contains:
> > >
> > > Drop contains. The list of compatible strings and order must be defin=
ed.
> > PK: Will drop it as the SPAcc driver is using just "snps,dwc-spacc".
> > >
> > > > +      enum:
> > > > +        - snps,dwc-spacc
> > > > +        - snps,dwc-spacc-6.0
> > >
> > > What's the difference between these 2? The driver only had 1 compatib=
le,
> > > so this should too.
> > PK: Will fix this to "snps,dwc-spacc"
> > >
> > > > +
> > > > +  reg:
> > > > +    maxItems: 1
> > > > +
> > > > +  interrupts:
> > > > +    maxItems: 1
> > > > +
> > > > +  clocks:
> > > > +    maxItems: 1
> > > > +
> > > > +  clock-names:
> > > > +    maxItems: 1
> > >
> > > No, you must define the name. But really, just drop it because you do=
n't
> > > need names with only 1 name.
> > PK: Will remove it.
> > >
> > > > +
> > > > +  little-endian: true
> > >
> > > Do you really need this? You have a BE CPU this is used with?
> > PK: Its a configurable IP. Can be used in little and big-endian configu=
rations.
> >        We have tested it on Little-endian CPUs only. (Xilinx Zynq
> > Ultrascale ZCU104)
>
> Not testing BE is clear from reading the driver...
>
> It's probably safe to assume the IP will be configured to match the
> processor. The endian properties are for the exceptions where the
> peripherals don't match the CPU's endianness. This property can be
> added when and if there's a platform needing it. Any specific platform
> should have a specific compatible added as well.
PK: Agreed, I will remove "little-endian" property but the code defaults to
       little endian implementation. In case the big-endian support
       comes, we will add a "big-endian" property.
>
> > >
> > > > +
> > > > +  vspacc-priority:
> > >
> > > Custom properties need a vendor prefix (snps,).
> > PK: Will add vendor prefix.
> > >
> > > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > > +    description:
> > > > +      Set priority mode on the Virtual SPAcc. This is Virtual SPAc=
c priority
> > > > +      weight. Its used in priority arbitration of the Virtual SPAc=
cs.
> > > > +    minimum: 0
> > > > +    maximum: 15
> > > > +    default: 0
> > > > +
> > > > +  vspacc-index:
> > > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > > +    description: Virtual spacc index for validation and driver fun=
ctioning.
> > >
> > > We generally don't do indexes in DT. Need a better description of why
> > > this is needed.
> > PK: This is NOT for indexing into DT but more like an ID of a virtual S=
PAcc.
> >        The SPAcc IP can be configured as virtual SPAccs for
> > multi-processor support,
> >        where they appear to be dedicated to each processor.
> >        The SPAcc hardware supports 2-8 virtual SPAccs (each vSPAcc has
> > its Register
> >        bank and context-memory for crypto operations). The index here
> > represents the
> >        vSPAcc to be referenced.
>
> Okay, I'd use 'id' rather than 'index' in that case.
PK: Sure, I will change it to "vspacc-id".
>
> Rob
