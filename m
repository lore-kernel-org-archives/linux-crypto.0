Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4FF38E5ED
	for <linux-crypto@vger.kernel.org>; Sun, 31 May 2026 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780244867; cv=none; b=VQBUdWCveHER5DSyfkX6SeJD4fKHB4aZuqUgDbtcqpCzUwku9wiXkG9drphfFLhChnQa0Isuy0/qY/tSj+cko145aWHpXryTjNQMDAOdrelgj51YHyERtt9aEQy193leJBx3gJKUByGj72chyUEj/rpfXu+JPlij1MVLqA2iCBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780244867; c=relaxed/simple;
	bh=0Z7N0xCYu6VkyFfhnSi8o2vTsl4Gm9ruQYGU2oUarIU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IvqQq/jvjjC1edQwRx4r/MVNrcI9SZM+nWqq067qsYYcJ1vbrp/G89A1yWCjpJfpP50iD42BXwjUcIJm813XJCC8IaUejrIvDWFvP0f00wldCMBr09U/SsyW1m3kAxOQd4a9JEKji4eSgV5YH2Jh7iTH7AaHA0hB9VjTMBtHLlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vbou+zIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vbou+zIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CC51F008A1
	for <linux-crypto@vger.kernel.org>; Sun, 31 May 2026 16:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780244866;
	bh=b/T/RdXiN7bhTsikP7tDXhBU6HaNdabK8ZTbQ4skuK0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Vbou+zIiA3Mr4kpYeiYJTqi2gIfmOZkK11YoGOHJXJolFeVAEfBS1YmHpT2wbl7E4
	 1TtFyx5TF2YuygGadxrQcJ1BbSDjThQNgIQTDV+k7mbJnCEVnmCp/WdYdPgTqysu3r
	 iMc/SXEPVkZBePzOusjof6PMTt34N5mN/BWjlITLi6GWFVDZrYjjZMV3nyOz0eZh0H
	 nSY9BsHNYDHM9flWN3Wyu66qytrnINpASR4KeaMgIHf179bUlLCtBEgwXjc2B1+jsG
	 pI0eIsJ5J4yCzh+imQOSoXBDCyq6QOJRceCoO6RwRvc+V1+Aw4d5g0j4MWmuAfjJGI
	 iJoGujrTk1fCg==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aa63daf2a5so918292e87.3
        for <linux-crypto@vger.kernel.org>; Sun, 31 May 2026 09:27:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/0HRqHMkCjxxhMdxRA37x5seU4MEBRjq8vZX/75cstYnoXTRVmve9wTEilIE7aBjLEwJSylDNur/DwsIs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/azduYv2c42jsAk+laD8gSJ0i33AjUA00y9U6M7waqfLxkviL
	7Fe/f2yqeP1KV5DGA4STieExK+TVutNb7D9y1S3M0KrBSLLsHLalY1WWjB0ASLKh29lFMUYCbhJ
	Vb+WJYMrtoohgwjDTQdrowviYpmgkP03DlWeaoHSKIQ==
X-Received: by 2002:a05:6512:800d:10b0:5a8:fca6:a537 with SMTP id
 2adb3069b0e04-5aa608ff3d8mr1341020e87.22.1780244864645; Sun, 31 May 2026
 09:27:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com> <20260529162251.GB2706@sol>
In-Reply-To: <20260529162251.GB2706@sol>
From: Bartosz Golaszewski <brgl@kernel.org>
Date: Sun, 31 May 2026 18:27:32 +0200
X-Gmail-Original-Message-ID: <CAMRc=MdJ5GN_Lbi9PeCoW=fNnjCz-WAq66TSa8f=fZGOHFZ41Q@mail.gmail.com>
X-Gm-Features: AVHnY4KA4mut6jG-LIp_D5JMZD7phc05G5rBuCgHgHRyzFVSAKUzF_CQJazrdyg
Message-ID: <CAMRc=MdJ5GN_Lbi9PeCoW=fNnjCz-WAq66TSa8f=fZGOHFZ41Q@mail.gmail.com>
Subject: Re: [PATCH v19 00/14] crypto/dmaengine: qce: introduce BAM locking
 and use DMA for register I/O
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Udit Tiwari <quic_utiwari@quicinc.com>, Md Sadre Alam <mdalam@qti.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Stephan Gerhold <stephan.gerhold@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	Peter Ujfalusi <peter.ujfalusi@gmail.com>, Michal Simek <michal.simek@amd.com>, 
	Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@codeaurora.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, dmaengine@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2026 at 6:24=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, May 26, 2026 at 03:10:48PM +0200, Bartosz Golaszewski wrote:
> > I feel like I fell into the trap of trying to address pre-existing
> > issues reported by sashiko and in the process provoking more reports so
> > let this be the last iteration where I do this. Vinod can we get this
> > queued for v7.2 now and iron out any previously existing problems in
> > tree?
> >
> > Merging strategy: there are build-time dependencies between the crypto
> > and DMA patches so the best approach is for Vinod to create an immutabl=
e
> > branch with the DMA part pulled in by the crypto tree.
> >
> > This iteration continues to build on top of v12 but uses the BAM's NWD
> > bit on data descriptors as suggested by Stephan. To that end, there are
> > some more changes like reversing the order of command and data
> > descriptors queuedy by the QCE driver.
> >
> > Currently the QCE crypto driver accesses the crypto engine registers
> > directly via CPU. Trust Zone may perform crypto operations simultaneous=
ly
> > resulting in a race condition. To remedy that, let's introduce support
> > for BAM locking/unlocking to the driver. The BAM driver will now wrap
> > any existing issued descriptor chains with additional descriptors
> > performing the locking when the client starts the transaction
> > (dmaengine_issue_pending()). The client wanting to profit from locking
> > needs to switch to performing register I/O over DMA and communicate the
> > address to which to perform the dummy writes via a call to
> > dmaengine_desc_attach_metadata().
> >
> > In the specific case of the BAM DMA this translates to sending command
> > descriptors performing dummy writes with the relevant flags set. The BA=
M
> > will then lock all other pipes not related to the current pipe group, a=
nd
> > keep handling the current pipe only until it sees the the unlock bit.
> >
> > In order for the locking to work correctly, we also need to switch to
> > using DMA for all register I/O.
> >
> > On top of this, the series contains some additional tweaks and
> > refactoring.
> >
> > The goal of this is not to improve the performance but to prepare the
> > driver for supporting decryption into secure buffers in the future.
> >
> > Tested with tcrypt.ko, kcapi and cryptsetup.
> >
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.co=
m>
>
> None of these fixes are Cc'ed to stable, so stable kernels will remain
> vulnerable to these race conditions.
>
> Shouldn't this be preceded by a patch, Cc'ed to stable, that marks the
> driver as BROKEN?  As discussed in the other thread
> (https://lore.kernel.org/linux-crypto/20260515-shikra_qcrypto-v1-0-80f07b=
345c29@oss.qualcomm.com/T/#u),
> none of the current functionality of this driver is actually useful in
> Linux.  It's just been causing problems.
>

I don't believe any of it should be backported. This is not a
regression, multiple EEs were never supported, so it's a new feature.
Also: backporting of over 500 diff lines across two subsystems doesn't
sound like a good idea to me.

On the other hand, if marking the driver as BROKEN for the time being
allows for a faster pace of queuing any changes to it, then I'm for
it. Let's unmark it once we fix it.

Bart
