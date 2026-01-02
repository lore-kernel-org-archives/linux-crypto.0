Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F58425D1E6
	for <linux-crypto@vger.kernel.org>; Fri,  2 Jan 2026 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767374057; cv=none; b=GoJyNRU0Pt64RgKoMXlw97leU9Pryl2W4iKreM7ZU+/nzSz7BJJryShMSPPLNH9z3wNFcCVRuxYtY5H1Cn+f28sbYoduGiVZeUqsRicfAYkycf4Ps+I7anHY6lxjWgN52yi/bMvZcPCg+vf3e2RIm8rbqgm0XKP0P2d1LNwIHvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767374057; c=relaxed/simple;
	bh=R6dmOb7p8xJel1QxDvWRfkmJfdH87GHXzodWhp+pqzQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NWo2ug00bWjWYUwi460stnz+3dAavnzXCYsJv37jXxcrOKxGy79fiGDmPlk/gKfdz/sTv3lsH7POo6XnEagyB1Z7AUgPfhfsYSQq5pjZP8w9DuK3ZCl6ydRjcV0oNhqVTbVSG3Y61dBc5iwG2v6AKaYuX1Nvgqv8zQo6Z+xFpW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J3EYhsYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J3EYhsYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DBDC116D0
	for <linux-crypto@vger.kernel.org>; Fri,  2 Jan 2026 17:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767374056;
	bh=R6dmOb7p8xJel1QxDvWRfkmJfdH87GHXzodWhp+pqzQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=J3EYhsYXLaTPvLYjI/KupDqvZ7LTNM5z/Nn6h6Uh2teUS/Mhw2f/+Fn6ZFGbKeNc/
	 bKhHvEfpXTOUQFSHBHaxPDTG7TX3IOV7WmgsSoOhApiebgnql6WDW8RJqPtsIZKQwD
	 wIk8GKbYPkMlhq03cTN/vXBeAYbWF9jje0MRBZ4ojCo3J7DyNvuKa7e9IKCipktt1t
	 tABqNs7LlAuZb71EXG7N5rx4X9xvjEycGBkdQbzyP0xZMZkuOpdRVGkNz0Zfqp4IKt
	 C9O5fYggHuvzxua+k7j9iV0lrLZ0luevwWaPcq5DLrg+jV0N8bcQ8IIWbPHWFb/ND5
	 8HIo1B1HIc6lg==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-598eaafa587so14022312e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jan 2026 09:14:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV8NeXBBl/Xq+u0TNi7SW2wvUR0xC3jE7/hGykPDqJhJUXbpclbTsoVEedpKV1jQstEVQSz5ER6rfK8Ua8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGo8+MKbFu3rWlCm8/HbuupGEq3m0lHIxxHRucSeeQ11FOstqx
	C7hspoyKPFErd6bBuwFQ9wAG5O9FpWMQc0yvn2Z0Pb9BSqmSypX5/7V3yR2b+szWIA4l7cha1EY
	MH+AR6PDfZOb2tRBkYLOhnYDjPSpJc0wRKJQ9fKKjfA==
X-Google-Smtp-Source: AGHT+IHV2zByoLl6AUOgy1s7wJzSUumpVgbYasCQ8jZfLwQVGm88Ij0ul2K30P8OfX5b1FsgpDShkqlq2bAFvN8YTbU=
X-Received: by 2002:a05:6512:3f09:b0:595:81c1:c55 with SMTP id
 2adb3069b0e04-59a17d74426mr16156505e87.8.1767374055558; Fri, 02 Jan 2026
 09:14:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
 <20251128-qcom-qce-cmd-descr-v9-3-9a5f72b89722@linaro.org>
 <aUFX14nz8cQj8EIb@vaman> <CAMRc=MetbSuaU9VpK7CTio4kt-1pkwEFecARv7ROWDH_yq63OQ@mail.gmail.com>
 <aUF2gj_0svpygHmD@vaman> <CAMRc=McO-Fbb=O3VjFk5C14CD6oVA4UmLroN4_ddCVxtfxr03A@mail.gmail.com>
 <aUpyrIvu_kG7DtQm@vaman> <CAMRc=Md6ucK-TAmtvWMmUGX1KuVE9Wj_z4i7_-Gc7YXP=Omtcw@mail.gmail.com>
 <aVZh3hb32r1oVcwG@vaman> <CAMRc=MePAVMZPju6rZsyQMir4CkQi+FEqbC++omQtVQC1rHBVg@mail.gmail.com>
 <aVf5WUe9cAXZHxPJ@vaman>
In-Reply-To: <aVf5WUe9cAXZHxPJ@vaman>
From: Bartosz Golaszewski <brgl@kernel.org>
Date: Fri, 2 Jan 2026 18:14:02 +0100
X-Gmail-Original-Message-ID: <CAMRc=Mdaucen4=QACDAGMuwTR1L5224S0erfC0fA7yzVzMha_Q@mail.gmail.com>
X-Gm-Features: AQt7F2o_SWu6QkybNXv1EzXBF2ZAUPo7cvQ3Ie-kbYTBiaz38B4U0n86nK8RvVg
Message-ID: <CAMRc=Mdaucen4=QACDAGMuwTR1L5224S0erfC0fA7yzVzMha_Q@mail.gmail.com>
Subject: Re: [PATCH v9 03/11] dmaengine: qcom: bam_dma: implement support for
 BAM locking
To: Vinod Koul <vkoul@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Udit Tiwari <quic_utiwari@quicinc.com>, Daniel Perez-Zoghbi <dperezzo@quicinc.com>, 
	Md Sadre Alam <mdalam@qti.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, dmaengine@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 2, 2026 at 5:59=E2=80=AFPM Vinod Koul <vkoul@kernel.org> wrote:
>
> On 02-01-26, 10:26, Bartosz Golaszewski wrote:
> > On Thu, Jan 1, 2026 at 1:00=E2=80=AFPM Vinod Koul <vkoul@kernel.org> wr=
ote:
> > >
> > > > >
> > > > > > It will perform register I/O with DMA using the BAM locking mec=
hanism
> > > > > > for synchronization. Currently linux doesn't use BAM locking an=
d is
> > > > > > using CPU for register I/O so trying to access locked registers=
 will
> > > > > > result in external abort. I'm trying to make the QCE driver use=
 DMA
> > > > > > for register I/O AND use BAM locking. To that end: we need to p=
ass
> > > > > > information about wanting the command descriptor to contain the
> > > > > > LOCK/UNLOCK flag (this is what we set here in the hardware desc=
riptor)
> > > > > > from the QCE driver to the BAM driver. I initially used a globa=
l flag.
> > > > > > Dmitry said it's too Qualcomm-specific and to use metadata inst=
ead.
> > > > > > This is what I did in this version.
> > > > >
> > > > > Okay, how will client figure out should it set the lock or not? W=
hat are
> > > > > the conditions where the lock is set or not set by client..?
> > > > >
> > > >
> > > > I'm not sure what you refer to as "client". The user of the BAM eng=
ine
> > > > - the crypto driver? If so - we convert it to always lock/unlock
> > > > assuming the TA *may* use it and it's better to be safe. Other user=
s
> > > > are not affected.
> > >
> > > Client are users of dmaengine. So how does the crypto driver figure o=
ut
> > > when to lock/unlock. Why not do this always...?
> > >
> >
> > It *does* do it always. We assume the TA may be doing it so the crypto
> > driver is converted to *always* perform register I/O with DMA *and* to
> > always lock the BAM for each transaction later in the series. This is
> > why Dmitry inquired whether all the HW with upstream support actually
> > supports the lock semantics.
>
> Okay then why do we need an API?
>
> Just lock it always and set the bits in the dma driver
>

We need an API because we send a locking descriptor, then a regular
descriptor (or descriptors) for the actual transaction(s) and then an
unlocking descriptor. It's a thing the user of the DMA engine needs to
decide on, not the DMA engine itself.

Also: only the crypto engine needs it for now, not all the other users
of the BAM engine.

Bartosz
