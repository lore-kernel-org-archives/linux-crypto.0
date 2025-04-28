Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D36C25E462
	for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 08:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745828816; cv=none; b=qIk08ac1G9UQbiQ7HoSSFABCqbWBwf8KUi0PgAWy6+Y1yyuVw8E0TOF043PqWme01P5LFY1rb8B0IJHF/Pq6jNuDvGA+82l1GRuq5ibkupBQ+SEzdJwxZLBthM3TaexF88EgN0kitKiYyrXmEbiCRXFKo27/XgQWRYCqGgpxIQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745828816; c=relaxed/simple;
	bh=T8SZ8DX9DHzGXS1oxkAHhDLvJLkNaoXfwhhJ1PwP9/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mMAg+pVugvPd7rh2nVBDyFDypx7Nkzp2ALmbrufYPx0rHcBGKFO3vtn9qNUdC4YJhPr7Iur8wh5h+3j7eglLgM4IHRnHzDTJUEE5UaAP2qWd4J9MSbijoh4kwb2qUa/+R0XVmUkH2hGz7lTvyYhJliRUizrcuUQ1SBAPNK2QxVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=IUrYIwQU; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="IUrYIwQU"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6fece18b3c8so35759457b3.3
        for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 01:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1745828813; x=1746433613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghcmrgUgSbDm4wcZcCaNT1wwBWxdZ/sWHCjglVCfqe4=;
        b=IUrYIwQUukq4nyZO5RzjXewKZUEbUCD90ztNaG39Y/7gOE+r2ezY5l9z5eJL2ctosU
         oY7tMOtdZBQ2Z58zEpkoclaRlqRByxDa5nhOBDM5fG0ZeFigWsveQI2ycKZ8Yhy8v3cb
         LfTx/LCmTAvePwUmn/q6lZv5OLWGACJlSy2PA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745828813; x=1746433613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ghcmrgUgSbDm4wcZcCaNT1wwBWxdZ/sWHCjglVCfqe4=;
        b=SxbBhpLDnQkTwhF/zsN/wF3v5Y968c6iCZLF58Z0j+VkKBz3OHJMDxm9taJv7/60Pp
         kRYasQ6ccsCQlNV01Qg4JhHFquM4y3dEt5M97OxsaJ0mU/N0g5KVtdIrf8bgv42iZEVP
         0ikcI7FhRuR0LYLt4av3xDkpLx1dtbrsyrlaBGwXqODv6+7u7YQt7PuRdbTF+BI6+Siu
         HV4wyMp42nr81tgfRP1hDgeIFyiTkPqz4Wm7SRU4VHWiJeIUOLczNWhdInJPkZU4LT3k
         kTA0IjWvWpDEASxStEnwiI2kg6E0wMDBkR1mSG7R5HFFfj+ZaXwiOsbPs8ABmXgcHMyg
         JvPw==
X-Gm-Message-State: AOJu0Yxsqr+XoJZd38aMI7zmouaBQ1XMz7GNlJaOiHFKXX+DhY6uEFBS
	I29sRgiK7IKJ+T2KPDTjCi6mlJEmIniltNFMmYU9RwsjFwkuytjrTZx4w80VU4RysYJgF6VgTfJ
	7gx3Qw90xQNSrnSiVYTJnGks3eSbyaRxHHap1BA==
X-Gm-Gg: ASbGncshcdDF5XrYhTarFoLSYJDcWmhPMUJOcJR6Dta84o+htT+woj+O7cZx2uzUSx1
	BMYsJH7I1slLW7lMhLxE1fIQSc5QoCxAnYk6O8wELY1CKYAjYltvMfrVMwayscsgWYsrdpwRpBO
	KXYu2MX2o7zoeZ4e3Xf7YYTUgEdMnd/EiVG18LnMyIZMq2AGcyDm31e+o=
X-Google-Smtp-Source: AGHT+IGTTOWD4mqDocBPkLm6H5LR08W1IDUGz6syBbpKa0wuDFnm8koHpJ/z7Hcj77PexwAyVbb4syjzYQ/2lsza3UA=
X-Received: by 2002:a05:6902:e92:b0:e6e:4d8:81cf with SMTP id
 3f1490d57ef6-e73165df443mr14045801276.23.1745828813532; Mon, 28 Apr 2025
 01:26:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250423101518.1360552-1-pavitrakumarm@vayavyalabs.com>
 <20250423101518.1360552-2-pavitrakumarm@vayavyalabs.com> <e5f47f52-807d-45ce-bd62-090f4af72b3a@kernel.org>
In-Reply-To: <e5f47f52-807d-45ce-bd62-090f4af72b3a@kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Mon, 28 Apr 2025 13:56:42 +0530
X-Gm-Features: ATxdqUFzsFfzOiZTTfcSFEA0yKYwV1MYLNlGc_twQTlRFGhIWQAsmjFO7nR7c1I
Message-ID: <CALxtO0k4RkopERap_ykrMTZ4Qtdzm8hEPJGLCQ2pknQGjfQ4Eg@mail.gmail.com>
Subject: Re: [PATCH v1 1/6] dt-bindings: crypto: Document support for SPAcc
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	herbert@gondor.apana.org.au, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, 
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,
   My comments are embedded below.

Warm regards,
PK


On Wed, Apr 23, 2025 at 6:23=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On 23/04/2025 12:15, Pavitrakumar M wrote:
> > From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> >
> > Add DT bindings related to the SPAcc driver for Documentation.
> > DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
>
> These IP blocks are rarely usable on their own and need SoC
> customization. Where any SoC users? Where are any SoC compatibles?

PK: This is a new IP designed by Synopsys, tested on the Xilinx Zynqmp
FPGA (ZCU104 board).
       This is NOT a part of any SoC yet, but it might be in future.
       Could you offer suggestions on how to handle such a case?

>
> <form letter>
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC (and consider --no-git-fallback argument, so you will
> not CC people just because they made one commit years ago). It might
> happen, that command when run on an older kernel, gives you outdated
> entries. Therefore please be sure you base your patches on recent Linux
> kernel.
>
> Tools like b4 or scripts/get_maintainer.pl provide you proper list of
> people, so fix your workflow. Tools might also fail if you work on some
> ancient tree (don't, instead use mainline) or work on fork of kernel
> (don't, instead use mainline). Just use b4 and everything should be
> fine, although remember about `b4 prep --auto-to-cc` if you added new
> patches to the patchset.
> </form letter>
>
> > Engine is a crypto IP designed by Synopsys.
> >
> > Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> > Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> > Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> > ---
> >  .../bindings/crypto/snps,dwc-spacc.yaml       | 70 +++++++++++++++++++
> >  1 file changed, 70 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-s=
pacc.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.ya=
ml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> > new file mode 100644
> > index 000000000000..ffd4af5593a2
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> > @@ -0,0 +1,70 @@
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
> > +description:
> > +  DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto En=
gine is
> > +  a crypto IP designed by Synopsys, that can accelerate cryptographic
> > +  operations.
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - const: snps,dwc-spacc
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
> > +  snps,vspacc-priority:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description:
> > +      Set priority mode on the Virtual SPAcc. This is Virtual SPAcc pr=
iority
> > +      weight. Its used in priority arbitration of the Virtual SPAccs.
>
> Why would this be board configuration?

PK: Got it, its Policy vs Mechanism. I will remove this property.

>
> > +    minimum: 0
> > +    maximum: 15
> > +    default: 0
> > +
> > +  snps,vspacc-id:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description: Virtual spacc index for validation and driver functio=
ning.
>
> Driver? Bindings are for hardware, not driver. You described the desired
> Linux feature or behavior, not the actual hardware. The bindings are
> about the latter, so instead you need to rephrase the property and its
> description to match actual hardware capabilities/features/configuration
> etc.

PK: Will rephrase and fix that to convey the proper meaning.

>
> > +    minimum: 0
> > +    maximum: 7
> > +
> > +  snps,spacc-wdtimer:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description: Watchdog timer count to replace the default value in =
driver.
>
> If this is watchdog, then use existing watchdog schema and its property.
> If this is something else then... well, it cannot be something for
> driver, so then drop.

PK: I will rename this since its NOT a traditional watchdog, but its an
      internal device counter that generates an interrupt based on a
count value.
      This counter starts ticking when there is a completed job sitting on
      the status FIFO, to be serviced. This makes sure that there are no jo=
bs
      that get starved of processing.

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
> > +    crypto@40000000 {
> > +        compatible =3D "snps,dwc-spacc";
> > +        reg =3D <0x40000000 0x3FFFF>;
> > +        interrupt-parent =3D <&gic>;
> > +        interrupts =3D <0 89 4>;
>
> Use proper defines for typical flags.

PK: Will fix it.

>
>
>
> Best regards,
> Krzysztof
