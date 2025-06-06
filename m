Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDD22045AD
	for <linux-crypto@vger.kernel.org>; Fri,  6 Jun 2025 11:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749207766; cv=none; b=Td7If+VRGihyZNdccxg8wP1FFPs04aiBKKKeraj74pJYY5TdhhAPlYPfBMeGd8Q1UodHm1Q7XYkCnuYc2GRsO/A6sc82lO7uv85XmIqWdCSPlQDnmWcJGkkDuF68ZqbTU8oZKEJRVmkrtKjwrofHhiM7hMusStckM6KDjNGUHj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749207766; c=relaxed/simple;
	bh=sozKJ1pwU9KulGgyEdYs/zM27kuoxVEnTkT5+Zsz6DA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BSN/SjaD710SHOCprfGw2Gvmb8SqIPmyjOMmVUrlpU3JRVL8rXO3Gduurt3vvJyCKA8j5qVMnce14TcXduCcJsIE2h5u/FQNV/fWkWpaujQDPe8o2odOyEmFtidyBY4qFu0Tll2niyeZ5bS5YCKv5eLhQDZKOn4Tzo0DzS1MoCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=bgLhgynR; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="bgLhgynR"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e7387d4a336so1911677276.2
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jun 2025 04:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1749207763; x=1749812563; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahRtYL+8yDFcivQALpBf2mOu61lf53lXLD7NaXvC65s=;
        b=bgLhgynRYJXCbIemWLbGKSD0JM+LwkgiES6QeIwuoM8N659Q4sWIZMPLOsMlaA/9/U
         enBFcl0aFNzt31BPfVMt01cuNZdThraBCOfVipYOruONQ4fryUetYvet/H7ZrPoMPbiU
         diMeAPTrxOpTW6g5xLXp64KAfB2+iiy2/+IPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749207763; x=1749812563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahRtYL+8yDFcivQALpBf2mOu61lf53lXLD7NaXvC65s=;
        b=LN9uikqxmygk6yVCabK3upsHqmIXXsF+aASlHuiz5IuICg80FZn2aKucLhjv+/EuoH
         mKRip1B8ALPhcuvWWO/AMwzmswdolCQ39jZOpNl6oNJTf0edhW4JvJaDIKv/c9xXjnoh
         ir60r7GZ69i+Y/rMoKMlT6teHLj+9qwpc88j0lMyNWODOp1A5zBg9g0sH0VRAJTJWo2J
         GR0ES71y1IGFua2tyTNkl+KVVD/D+iiT0OqZuWtISN30cB4+xkL5hD8BuDNQo3WeZrY0
         895JoO3cJcBJPaRTj3VwERpLztivgLBzVZuzqXLlzzAjBXPbMSBsiEhg+c2pDz/k9wLJ
         8Dmw==
X-Gm-Message-State: AOJu0YyjPenZ7oUydokw9lOra5N175nYJgIgIPT4kC7biBGJT0TfJwUd
	MSEAQckpynQMvg51bT0Pn975sEnPT8TlkoPJT972OHlRAFJlMShVOPMog/FKHOigVHcyMKCq7mW
	phxbOdqDCvyO2G00PMGOfGK18fAVUmjEiGsYRwzFoQQ==
X-Gm-Gg: ASbGncsdsx3M31Dm4z0xb0JGU8gZ5/53fE/EWbGWbspaYrtUaQedDpRKPZK93v9IIvA
	v5a2skOriBxdRtn74of4dPSmJJflguJv8r/iPv4wH22L6Ui+1YrmcYu/DEd4i+DhQkD4+dI/zo/
	OMNzgrmrpTbOfp+9VWuiSNdCuycZHZlxQLng==
X-Google-Smtp-Source: AGHT+IGPzGcL995Ml8WGyM8F6pt8IT4FINGEryh/hRSPtX851l83sDh2GRSHk3nE//BpH0WioFvDwKZiue7AzRpCHR4=
X-Received: by 2002:a05:6902:18c7:b0:e7d:ca03:4474 with SMTP id
 3f1490d57ef6-e81a21c56b0mr4251268276.36.1749207763644; Fri, 06 Jun 2025
 04:02:43 -0700 (PDT)
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
 <cd6e92af-1304-4078-9ed7-de1cb53c66da@kernel.org>
In-Reply-To: <cd6e92af-1304-4078-9ed7-de1cb53c66da@kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 6 Jun 2025 16:32:32 +0530
X-Gm-Features: AX0GCFsCPqpKREAd4CvP0DqZO_E5hMC88EBV6qNiDOowkNyZIs0O6qWj-K7X0KI
Message-ID: <CALxtO0mVMTWqidSv7LQSQd-rA_TmJy_0xgBSd=mP27kg=AXQRg@mail.gmail.com>
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
  Appreciate your inputs and feedback. My comments are embedded below.

Warm regards,
PK

On Wed, Jun 4, 2025 at 7:37=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.org=
> wrote:
>
> On 04/06/2025 14:20, Pavitrakumar Managutte wrote:
> >>
> >>>>> +
> >>>>> +  snps,vspacc-id:
> >>>>> +    $ref: /schemas/types.yaml#/definitions/uint32
> >>>>> +    description: |
> >>>>> +      Virtual SPAcc instance identifier.
> >>>>> +      The SPAcc hardware supports multiple virtual instances (dete=
rmined by
> >>>>> +      ELP_SPACC_CONFIG_VSPACC_CNT parameter), and this ID is used =
to identify
> >>>>> +      which virtual instance this node represents.
> >>>>
> >>>> No, IDs are not accepted.
> >>>
> >>> PK: This represents the specific virtual SPAcc that is being used in
> >>> the current configuration. It is used to index into the register bank=
s
> >>> and the context memories of the virtual SPAcc that is being used. The
> >>> SPAcc IP can be configured as dedicated virtual SPAccs in
> >>> heterogeneous environments.
> >>
> >> OK. Why registers are not narrowed to only this instance? It feels lik=
e
> >> you provide here full register space for multiple devices and then
> >> select the bank with above ID.
> >
> > PK: No, we cant narrow the registers to only this instance since its
> > is just a single SPAcc with multiple virtual SPAcc instances. The same
> > set of registers(aka register banks) and context memories are
> > repeated, but sit at different offset addresses (i*4000 +
> > register-offsets). The crypto hardware engine inside is shared by all
> > the virtual SPAccs. This is very much for a heterogeneous computing
> > scenario.
>
> Then maybe you have one crypto engine? You ask us to guess all of this,
> also because you do not upstream the DTS for real product. Any
> mentioning of "virtual" already raises concerns...

PK: Yes this is a single crypto engine, maybe I should have detailed
that in the cover letter. I will fix that. And what I have pushed in
the patch is my complete DTS. It might need updating depending on the
vendor use case, which we are committed to support and maintain here.

>
> Best regards,
> Krzysztof
