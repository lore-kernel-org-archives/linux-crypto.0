Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810DA39E18F
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 07:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774856940; cv=none; b=VLhL89PalZsDdAKy3zTIlOh4i7r1Y7QFclsbxVzM//7+zB6fjkfuByBHigTtmitX32MSxVFVhdvwD4xnSiGGQH6UAIKEpWPhdFUWaUML4ftLffB/rdLlgOHGPy80Qfn+ssRnow9dZ1rjXL6b9nJCO6lM65ck554h0Xw76LENPTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774856940; c=relaxed/simple;
	bh=lD2Z6zQIgevKi2IqTHqInMxXV0jeIeXVIIwGCfGmDSU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OKAvJtdLtL1g22IeGJVCEgOGDXBHpfxY1lr1TOqVZJjvsGe1xp3nHGzI7kMN8alehjRXILIxWgbf77bDI31JkoWxNhgYExFHyrwfGZEbUIp6y3dZzbc9lwgO8JXDpqYYDdJ55tECMoCXRAQCksZWN/oTCAq3ApVXrZIKqZvjRoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kf+NQfW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kf+NQfW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6451FC2BCB2
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 07:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774856940;
	bh=lD2Z6zQIgevKi2IqTHqInMxXV0jeIeXVIIwGCfGmDSU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kf+NQfW6DdHb+ZdGOOxI66nekPvZ1tzokGCWXtUurIGyRdYRJL1CKQkzf5u3ByNwV
	 ANh/jdCwHDpbELE6GzHv0jIG4u0x4pi5ZHEVM9L5lu/A4ijVABN5c2iYxLdGBqSQ4u
	 Qrz5RiC2/+/hdjDDWIiWDjmb6ADBS0V2gFjbCU8Ur4QY9FLtJl5Cyo7dn5UQ3WOSfa
	 9cRNCj3T4O9BsG1Pm6RgTACFucHUzU89MMsde5HgzDACeDjpY3PD0u5dYw2eCL9EFA
	 fmMGrO59NYDrNhHRlxhXgqbxsTsDuwhQiaIyczRh0cQHsHi6PX7e2xN+h4recSULVJ
	 nwJC44BpFaE3Q==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-38b3ee785a5so34714081fa.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 00:49:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXnTXr1DNXUhH276hDQfpTgdHC7U5Mc08TIHkiEZrzOhBRirCrV5VpGv3JzularNTlMSnxIGFa+yRFarfs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3h0qU2vJKHzdglFT18Z2FmL9FP2LyvnBsImAYC9iz97PdnuTc
	3hf8D+NWcEzkBRusGdijIWeXvciT4/WjTdFfqdARmu/n+5gn1VfPL1AWap5VdflmaIh9H1DGZjE
	3RyMjLYTOCbC1V02BHUP9Y6yzR+p4DWLLswZHycMFnQ==
X-Received: by 2002:a2e:8a87:0:b0:38b:f838:dcd0 with SMTP id
 38308e7fff4ca-38c756d2050mr31367251fa.3.1774856938701; Mon, 30 Mar 2026
 00:48:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260323-qcom-qce-cmd-descr-v14-0-f323af411274@oss.qualcomm.com>
In-Reply-To: <20260323-qcom-qce-cmd-descr-v14-0-f323af411274@oss.qualcomm.com>
From: Bartosz Golaszewski <brgl@kernel.org>
Date: Mon, 30 Mar 2026 09:48:47 +0200
X-Gmail-Original-Message-ID: <CAMRc=Mek-OrzG5B6cJnz0ZVRn1paUYVdgf67LAJC_GKCzfU6qg@mail.gmail.com>
X-Gm-Features: AQROBzDctCw49nI4ZpKxOYPIv3NwI9Us8xjc3cHh8fG92eva9b9SctdyfBh_Ryc
Message-ID: <CAMRc=Mek-OrzG5B6cJnz0ZVRn1paUYVdgf67LAJC_GKCzfU6qg@mail.gmail.com>
Subject: Re: [PATCH v14 00/12] crypto/dmaengine: qce: introduce BAM locking
 and use DMA for register I/O
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Udit Tiwari <quic_utiwari@quicinc.com>, 
	Md Sadre Alam <mdalam@qti.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Stephan Gerhold <stephan.gerhold@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Peter Ujfalusi <peter.ujfalusi@gmail.com>, 
	Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>, dmaengine@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 23, 2026 at 4:17=E2=80=AFPM Bartosz Golaszewski
<bartosz.golaszewski@oss.qualcomm.com> wrote:
>
> This iteration is quite similar to v12 but uses the BAM's NWD bit on
> data descriptors as suggested by Stephan. To that end, there are some
> more changes like reversing the order of command and data descriptors
> queuedy by the QCE driver.
>
> Currently the QCE crypto driver accesses the crypto engine registers
> directly via CPU. Trust Zone may perform crypto operations simultaneously
> resulting in a race condition. To remedy that, let's introduce support
> for BAM locking/unlocking to the driver. The BAM driver will now wrap
> any existing issued descriptor chains with additional descriptors
> performing the locking when the client starts the transaction
> (dmaengine_issue_pending()). The client wanting to profit from locking
> needs to switch to performing register I/O over DMA and communicate the
> address to which to perform the dummy writes via a call to
> dmaengine_desc_attach_metadata().
>
> In the specific case of the BAM DMA this translates to sending command
> descriptors performing dummy writes with the relevant flags set. The BAM
> will then lock all other pipes not related to the current pipe group, and
> keep handling the current pipe only until it sees the the unlock bit.
>

Hi Vinod et al!

Any chance of this making v7.1? Stephan, Mani: any objections to the
current approach?

Bart
