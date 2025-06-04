Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167AA28ECE2
	for <linux-crypto@vger.kernel.org>; Wed,  4 Jun 2025 12:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749039661; cv=none; b=Uw1CsykiRr1MS4DEIgp8WOYQX1D1uFlmRaL9oj7GkhoaNa2i+KNf6PW48Egqkkdr4VijmCWExdw6Kl0mK6k5rNfXlovpT7svqEGmoFI9xRD9CUlUf/RIkoLZ1bKpGGwBkkWAAIPMQH6UZ3D8DBcy0zj0Rqe/AjQBqt0bgYjjDnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749039661; c=relaxed/simple;
	bh=UJO8fx4zrjzUtoGazJLMeF4iUYaNpSkc62UBtLsRXWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jBYMg1yVwWldACF11oWkTe9og+oIV8h+CNNlBrlQyd8Nyu6NjCciJdEQN9KCp/EshmrJR+ck39TQpA8QDryhFLiM/Aw84JQqaIduu1Q1IQo8venBOiUdX88gJ/RkN2TPITrO+RO8TVfEE0PF3jCV1Oi8ze+HF5CnwCwcZCxV60g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=ZpMu0Eo0; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="ZpMu0Eo0"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7481600130eso34449b3a.3
        for <linux-crypto@vger.kernel.org>; Wed, 04 Jun 2025 05:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1749039659; x=1749644459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ztn23ugr0Et0nrkznY5+W0yWLUSMNK7u22fb8u5+6Hs=;
        b=ZpMu0Eo0qtcK5WBlSG5kDYrT0jl6Xly11uqregkcjLaN6Ct3KraWgpEXus8ydF+ab7
         kUjxasqzfZszlaOoWHoH6S7387zTOvq0NMJFAVhSgmliV9LFLu4/rHprhbZPINRXA0kf
         aEtqpVuUvsFxqXEiWkOlbuzAPNVnnllNmuktQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749039659; x=1749644459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ztn23ugr0Et0nrkznY5+W0yWLUSMNK7u22fb8u5+6Hs=;
        b=kaQXFl38iCLM7MTpu//DIdQd//zKu8l0ZWZK0XLz+ZQuA7NcUEdX74CPir2BsFTycw
         v/YMLJasTYDI29uvIUNPbV5RGS2yOozjaVHYXHJNF5M5AoIDP+LnNVfRIoC3a7Ln20Lq
         zakDm2XOEB+Cdr19ZKhit5VtKjQbyARKL+BsTAUIXKzVeC5i64ZoixvBUe8y6WwvX7WG
         QRi8qk5FxP8DHvzm9xnhxt6lBvrL32zQ8ifVqVY8lrqrL9LB5omNlIwwrzC47TmgCHB3
         iwa2dLzCZpmoUISi+J2jGJVBbWgmBLexK8hkNFIEIv/v5uFPmthvzaLsIqtjHsx+4aQc
         7UdA==
X-Gm-Message-State: AOJu0YzvB6LeZ3FzYSL8nNtQWjcl/C/Fi/3qQ6WnID5QtRbJKjjHXJLs
	VJrxkFbKHOYmO6J/lGdXgwlhQoVX8os8YgTfRZkYsK4CgsJRoYHkfLhlZrv4HrZ1c/am5uijpmn
	HLEbNJPlJtxD+SN5WOxsob5FIFoLZ6Y0bnLSYyEk9KSApgAPNJFw/usU=
X-Gm-Gg: ASbGncvjYhxXwmlwycnpO30lEyKdNM7g+m8OFpfj94NyxWQ9U8IDASkEkX7HlKwibLv
	3Ouvw2h7vB1PBPiC1SUPSJfwLKQSWrkjaVQuYP3+eRry988XwvGo+z4QAIsjBM49pnIXIQnj7gu
	OIW58Olry4TmxuxT6FNX4HVold61TCpM/KmA==
X-Google-Smtp-Source: AGHT+IEGMdIOkMV/uQ7zUK4UFRQ/YPtl1qy/zuPQpsLGtSK7QRRT2HbpWbVUamoQWNHk/kCuifvCQu4eWbBNQYRgwmA=
X-Received: by 2002:a05:6902:1207:b0:e7f:66d2:702b with SMTP id
 3f1490d57ef6-e8179dacd59mr3554043276.35.1749039645410; Wed, 04 Jun 2025
 05:20:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250602053231.403143-1-pavitrakumarm@vayavyalabs.com>
 <20250602053231.403143-2-pavitrakumarm@vayavyalabs.com> <fae97f84-bdb9-42de-b292-92d2b262f16a@kernel.org>
 <CALxtO0mpQtqPB0h_Wff2dLGo=Mxk02JJQkK4rn+=TuScNdSfxQ@mail.gmail.com> <3570be5b-cb20-4259-9a9b-959098b902d0@kernel.org>
In-Reply-To: <3570be5b-cb20-4259-9a9b-959098b902d0@kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Wed, 4 Jun 2025 17:50:33 +0530
X-Gm-Features: AX0GCFsFCDL3Q847lJwuNMF8LuDkhE19L7HG54evtY5CFetlay22p3RmnolgEVg
Message-ID: <CALxtO0mH=GwhQxQBsmMQYd+qgAue9WxXN1XWo9BncVJvJk6d8A@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] dt-bindings: crypto: Document support for SPAcc
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, 
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof.
  Appreciate your inputs. My comments are embedded below.

Warm regards,
PK

On Tue, Jun 3, 2025 at 5:34=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.org=
> wrote:
>
> On 03/06/2025 13:45, Pavitrakumar Managutte wrote:
> > Hi Krzysztof,
> >   Thanks for the inputs, my comments are embedded below.
> >
> > Warm regards,
> > PK
> >
> > On Mon, Jun 2, 2025 at 11:28=E2=80=AFAM Krzysztof Kozlowski <krzk@kerne=
l.org> wrote:
> >>
> >> On 02/06/2025 07:32, Pavitrakumar Managutte wrote:
> >>> Add DT bindings related to the SPAcc driver for Documentation.
> >>> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> >>> Engine is a crypto IP designed by Synopsys.
> >>>
> >>> Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> >>> Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> >>> Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> >>> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> >>
> >> Where was this Ack given? It's not on the lists, it's not public, so i=
t
> >> cannot be after your SoB.
> >
> > PK: Yes, its not on the mailing list. I will remove that.
>
> If it was given in private, then happened for sure before you sent the
> patch, so it should be above your SoB.

PK: Sure, I will fix that. Yes, that was an internal Ack.

>
> ...
>
> >>> +
> >>> +  snps,vspacc-id:
> >>> +    $ref: /schemas/types.yaml#/definitions/uint32
> >>> +    description: |
> >>> +      Virtual SPAcc instance identifier.
> >>> +      The SPAcc hardware supports multiple virtual instances (determ=
ined by
> >>> +      ELP_SPACC_CONFIG_VSPACC_CNT parameter), and this ID is used to=
 identify
> >>> +      which virtual instance this node represents.
> >>
> >> No, IDs are not accepted.
> >
> > PK: This represents the specific virtual SPAcc that is being used in
> > the current configuration. It is used to index into the register banks
> > and the context memories of the virtual SPAcc that is being used. The
> > SPAcc IP can be configured as dedicated virtual SPAccs in
> > heterogeneous environments.
>
> OK. Why registers are not narrowed to only this instance? It feels like
> you provide here full register space for multiple devices and then
> select the bank with above ID.

PK: No, we cant narrow the registers to only this instance since its
is just a single SPAcc with multiple virtual SPAcc instances. The same
set of registers(aka register banks) and context memories are
repeated, but sit at different offset addresses (i*4000 +
register-offsets). The crypto hardware engine inside is shared by all
the virtual SPAccs. This is very much for a heterogeneous computing
scenario.

>
>
> > This was also discssed with Rob Herring and updated from
> > "vpsacc-index" to "vspacc-id" based on Rob's inputs
> > https://lore.kernel.org/linux-crypto/CALxtO0mkmyaDYta0tfx9Q1qi_GY0OwUoF=
DDVmcL15UH_fEZ25w@mail.gmail.com/
>
> Yeah, it is still ID and thus look at his comment about proper
> justification.

PK: Agreed

>
> >
> >>
> >>> +    minimum: 0
> >>> +    maximum: 7
> >>> +
> >>> +  snps,spacc-internal-counter:
> >>> +    $ref: /schemas/types.yaml#/definitions/uint32
> >>> +    description: |
> >>> +      Hardware counter that generates an interrupt based on a count =
value.
> >>> +      This counter starts ticking when there is a completed job sitt=
ing on
> >>> +      the status fifo to be serviced. This makes sure that no jobs a=
re
> >>> +      starved of processing.
> >>
> >> Not a DT property.
> >
> > PK: This is a hardware counter which starts ticking when a processed
> > job is sitting on the STAT FIFO. This makes sure a JOB does not stay
> > in STATUS FIFO unprocessed.
> >
> > This was called watchdog timer - wdtimer, which we renamed to
> > "spacc-internal-counter" based on your inputs.
> > https://lore.kernel.org/linux-crypto/CALxtO0k4RkopERap_ykrMTZ4Qtdzm8hEP=
JGLCQ2pknQGjfQ4Eg@mail.gmail.com/
>
> I suggested to use watchdog schema if this device has a watchdog feature.
>
> Why would you configure here different values for the same hardware in
> different boards?

PK: Agreed, it does not make sense to have this here in DT. I am
moving this as a Kconfig option.

>
>
>
> Best regards,
> Krzysztof
