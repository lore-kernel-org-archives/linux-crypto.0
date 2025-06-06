Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45A5288C03
	for <linux-crypto@vger.kernel.org>; Fri,  6 Jun 2025 12:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749214718; cv=none; b=Wuxj/Eu7uOvKZi8R/LpBXsgnkuIJwZ7NyUrMT2eXDDC/zEdZgrs/px0r+idBXFFJIAYo3rKIZkuZshCtOr+buaeacoIZ8IpGB915XMX1mD247fTcyiNC8GHMqPFUwZODZBWE2JRv0RZpL6cBJ8nQ67YkrR9X4h0hpIVywWlZhp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749214718; c=relaxed/simple;
	bh=uha/h2PgevouYEmmRxRudFkJsETHpxRuQukXfnQhRqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cvkeEUQFVX1ztCxrKgplgpJLqL+OBUoVzJGwNzFjMhJcLUdihZWT462LdqDmkxJPLalx2AdQ8BHzJuHXk+S/cXS23TEQfQnDZe/yJZgU8BmESlYIMGnWrjktdbaSnOgL9pvTMTv+8ZjehnZN9wctvYQJF30QkzDAWjfzFe9ZB+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=OaGyYPOp; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="OaGyYPOp"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e7569ccf04cso1878687276.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jun 2025 05:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1749214715; x=1749819515; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PYVM84VoP6sUarPE9u1qb7GqcXhlKnWyP+lB1fAcnnY=;
        b=OaGyYPOpDrckLwTVUDX9k+4Yzdpwrhe3Pek6SVngf+p+PKrnnG0Wx9ZPE7Ux6SAI+Z
         GWLj1BAoOkvbrvlu3m78lUeXinSY+/nX4RkFtIRNISxEBuDfIdijizepEwdboTWx71ah
         Iq1CXtFZEaDpEGYlkBzMtfED2OuEoICromTqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749214715; x=1749819515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYVM84VoP6sUarPE9u1qb7GqcXhlKnWyP+lB1fAcnnY=;
        b=K0tfIFqoiMxVxo54J/nBFhpe9CPVXNHIL1sB5JPupb3vGoB3WUb35WjSfZewha5elo
         Amcba7aj+nosNztginJOjOvbYvSJWkbqiZ4P1QvKWeEbiHLzetpHG6wWZlJD/nAnsF1p
         6Jh8axLDMMHHeO2NPkLobnYY076VI3kjk6zIj7OJN6C63VVgDvKhUt6P64CtkqmZ8EyN
         C6hx7dW3BV/+W2A4INyG2M6YIctodPUOrwu6KvZK0O0w2OS8OokkPEqhYKJyiY1E+zn8
         YQXFbXp1IjM60+Rs12ZDF7p/bteJkAeQoWEdxtcX2QbQiaVEPiIJbOlXVYfRMcJv4OnZ
         dwuw==
X-Gm-Message-State: AOJu0YwGqs3rUuB1xIz3FyIktYqyyViEhBy0B5LXiIRD/KJLohUTSyh2
	Dpd0AStqDau8z5dacGbrPYm6UWIcZCIw811KCpt1x0pVw55fdYPF0rNLejdLD64tzltIpzjhYxQ
	ATK8ssezqOyjtux+QCeaY+i+jUMN6JV1Mztmt0/ZaWA==
X-Gm-Gg: ASbGnctPwjSxLA9btYwB3KfrsghwgLzd43uoYWh7r0iYS+VjGO6InG8Q992vXmwJ7Gc
	pVhx7ih7xhy/1tjrdB85qeMsQPXpM9ksBxX9i1cA21YznxUGu1Rp9AauaaIArY1QW7iMYQlJ1Jr
	OFZKZuSSwhO/UvwW5h7VTqNne3jxVdvfYMog==
X-Google-Smtp-Source: AGHT+IERw6EH6isuoOp/tViAHSC9/1iGGlc7AkUNjP83hB+Xm1O+NBUINFmr2cFpvG9nP8zidAzav3pjNmYHuSi1FCw=
X-Received: by 2002:a05:6902:2401:b0:e7d:c87a:6249 with SMTP id
 3f1490d57ef6-e81a21d8096mr4996073276.36.1749214714686; Fri, 06 Jun 2025
 05:58:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250602053231.403143-1-pavitrakumarm@vayavyalabs.com>
 <20250602053231.403143-2-pavitrakumarm@vayavyalabs.com> <fae97f84-bdb9-42de-b292-92d2b262f16a@kernel.org>
 <CALxtO0mpQtqPB0h_Wff2dLGo=Mxk02JJQkK4rn+=TuScNdSfxQ@mail.gmail.com>
 <3570be5b-cb20-4259-9a9b-959098b902d0@kernel.org> <CALxtO0mH=GwhQxQBsmMQYd+qgAue9WxXN1XWo9BncVJvJk6d8A@mail.gmail.com>
 <cd6e92af-1304-4078-9ed7-de1cb53c66da@kernel.org> <CALxtO0mVMTWqidSv7LQSQd-rA_TmJy_0xgBSd=mP27kg=AXQRg@mail.gmail.com>
 <e08b2f76-17b1-4411-a428-b2f0f8a7d7fd@kernel.org>
In-Reply-To: <e08b2f76-17b1-4411-a428-b2f0f8a7d7fd@kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 6 Jun 2025 18:28:23 +0530
X-Gm-Features: AX0GCFsakdzQ7OpRugY0oL9f74JC3JUnvft7ryph7GBminNclioJcgtbl7Z0Pxc
Message-ID: <CALxtO0nReqeGKY+BNCBD10KSGttxxCrFzczxPjfrQM0eXv9Eug@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] dt-bindings: crypto: Document support for SPAcc
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, 
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 4:55=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.org=
> wrote:
>
> On 06/06/2025 13:02, Pavitrakumar Managutte wrote:
> > Hi Krzysztof,
> >   Appreciate your inputs and feedback. My comments are embedded below.
> >
> > Warm regards,
> > PK
> >
> > On Wed, Jun 4, 2025 at 7:37=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel=
.org> wrote:
> >>
> >> On 04/06/2025 14:20, Pavitrakumar Managutte wrote:
> >>>>
> >>>>>>> +
> >>>>>>> +  snps,vspacc-id:
> >>>>>>> +    $ref: /schemas/types.yaml#/definitions/uint32
> >>>>>>> +    description: |
> >>>>>>> +      Virtual SPAcc instance identifier.
> >>>>>>> +      The SPAcc hardware supports multiple virtual instances (de=
termined by
> >>>>>>> +      ELP_SPACC_CONFIG_VSPACC_CNT parameter), and this ID is use=
d to identify
> >>>>>>> +      which virtual instance this node represents.
> >>>>>>
> >>>>>> No, IDs are not accepted.
> >>>>>
> >>>>> PK: This represents the specific virtual SPAcc that is being used i=
n
> >>>>> the current configuration. It is used to index into the register ba=
nks
> >>>>> and the context memories of the virtual SPAcc that is being used. T=
he
> >>>>> SPAcc IP can be configured as dedicated virtual SPAccs in
> >>>>> heterogeneous environments.
> >>>>
> >>>> OK. Why registers are not narrowed to only this instance? It feels l=
ike
> >>>> you provide here full register space for multiple devices and then
> >>>> select the bank with above ID.
> >>>
> >>> PK: No, we cant narrow the registers to only this instance since its
> >>> is just a single SPAcc with multiple virtual SPAcc instances. The sam=
e
> >>> set of registers(aka register banks) and context memories are
> >>> repeated, but sit at different offset addresses (i*4000 +
> >>> register-offsets). The crypto hardware engine inside is shared by all
> >>> the virtual SPAccs. This is very much for a heterogeneous computing
> >>> scenario.
> >>
> >> Then maybe you have one crypto engine? You ask us to guess all of this=
,
> >> also because you do not upstream the DTS for real product. Any
> >> mentioning of "virtual" already raises concerns...
> >
> > PK: Yes this is a single crypto engine, maybe I should have detailed
> > that in the cover letter. I will fix that. And what I have pushed in
>
> So one node, thus no need for this entire virtual device split.

PK: Agreed, its one node for our test case.

>
> > the patch is my complete DTS. It might need updating depending on the
>
> If this is complete, then obviously "snps,vspacc-id" is not necessary.

PK: Yes, its one node, to keep things simple. So we pick a virtual
spacc with its vspacc-id for testing. That way we could test all the
virtual spaccs with a single node, on a need basis.

On the other hand we could create 'n' nodes for 'n' virtual spaccs and
register 'n' vspacc devices with the crypto subsystem. And bind the
individual nodes with unique vspacc-ids. That might depend on the
vendor use case, for which we will add incremental support.

>
>
> Best regards,
> Krzysztof
