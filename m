Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057BF37189C
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 08:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784796251; cv=none; b=i1okrYhZSPiYexFV4glCXfjOJd14IJEFy6Uqe0yodClWlrm9SIGkFP8M8Sm0VLUhv+4PdPW9FVGhFpIBVuqO201E2PCbRQB+R5UZcys+JA8dsGa0V2PycyRI2ZHodCq4iwhFmsyKRE2ccYrKdSTrJ8rHdj7q/apO0oQ5qKhTzbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784796251; c=relaxed/simple;
	bh=j2EBRvjl4THMhyqlpfuX6DTQgfmPpqpfKHZum4qGV80=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EREKJE3PuKSd4sJWsREagh3j490syOoFEDMlffVDbwH/83fmXNdKz9QVRKfaomq2dofODwbdsd3jYe6/A/WvQh0qNiVB0GVtZ4j0uqDfS2mBolu8Dr7apCJrl/+8uIfPYuYI5eXLJC9AwRcEQeT7C5nxBETeWeGnWmkhhj0kjJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F6F1F00A3D
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 08:44:07 +0000 (UTC)
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-39b22d0e488so3072761fa.3
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 01:44:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoZSDQs4ZwoKoZXMsqD5vID0LcCXBoy5UAfOQ4rXNdgE2miv+rpMi9t0f9dK6+tvfTtiYo360WOpZ+cVmQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKjnFYPeANQggXvwrFdwrazMtK3q42NciYIi8hr99AqvGoun3u
	dG9fO4CFrHZVWhUkOmWaLTaMdBoJRoLSA+EXeLhIqMU7CzJ1k3TZscsoWqqUq3oHtpWQ9I9oxlM
	Hd3mb4MyjSzqOOoMbgCPbnrqpyzl5fbWWNIo/lQY7eQ==
X-Received: by 2002:a2e:b8d5:0:b0:39c:8124:93b3 with SMTP id
 38308e7fff4ca-39f07bcfce0mr4681721fa.9.1784796246084; Thu, 23 Jul 2026
 01:44:06 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 23 Jul 2026 01:44:04 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 23 Jul 2026 01:44:04 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <amDuqoRBg5qGafi2@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
 <20260721-qcom-qce-cmd-descr-v23-6-1be02deffda9@oss.qualcomm.com>
 <20260721134853.2B2401F000E9@smtp.kernel.org> <amCGXUUd4VmuQRGD@linaro.org>
 <CAMRc=MfBNB0pvv1kPPcswE4Y2m7PXBO49bwJg=v0+aY=JmJKWw@mail.gmail.com>
 <amC7_M-HjVZ3sQuT@linaro.org> <CAMRc=MdnSyPmbK0skMx686=wSe52nnuWgCNJ0uSoKs_=HyAq-Q@mail.gmail.com>
 <amDRxPkdvbA-iVer@linaro.org> <CAMRc=Me523xQbfJvML9taJ-fR128SJurJS4eX9N9E9WtHF5W5Q@mail.gmail.com>
 <amDuqoRBg5qGafi2@linaro.org>
Date: Thu, 23 Jul 2026 01:44:04 -0700
X-Gmail-Original-Message-ID: <CAMRc=McJBVkCT+rFToY-Sn+nrLy-Sb8otz1NYWkQj1J-4-RK-A@mail.gmail.com>
X-Gm-Features: AUfX_mwJQKKrlt_uOHiEXNJho9ROwjpR_PSftHZZM5GhDPu9qwbx9QpVEO72mS0
Message-ID: <CAMRc=McJBVkCT+rFToY-Sn+nrLy-Sb8otz1NYWkQj1J-4-RK-A@mail.gmail.com>
Subject: Re: [PATCH v23 06/14] dmaengine: qcom: bam_dma: add support for BAM locking
To: Stephan Gerhold <stephan.gerhold@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Udit Tiwari <quic_utiwari@quicinc.com>, 
	Md Sadre Alam <mdalam@qti.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>, 
	Peter Ujfalusi <peter.ujfalusi@gmail.com>, Michal Simek <michal.simek@amd.com>, 
	Frank Li <Frank.Li@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Vignesh Raghavendra <vigneshr@ti.com>, dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	sashiko-reviews@lists.linux.dev, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Bartosz Golaszewski <brgl@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 18:24:10 +0200, Stephan Gerhold
<stephan.gerhold@linaro.org> said:
>
> FWIW, I couldn't stop myself trying to finish my "write lock descriptors
> directly into FIFO" idea, once I started I was curious how it would turn
> out. I think it's actually quite elegant, the loop in bam_start_dma() is
> wrapped with LOCK and UNLOCK, later process_channel_irqs() looks at the
> FIFO again and just skips over these descriptors. lock_ce is allocated
> once at channel creation time, no other allocations are needed. (Could
> probably move lock_ce allocation to slave_config() so it's allocated
> only when locking is configured for a channel).
>
> See diff below. It doesn't crash badly in a quick test, but didn't check
> in detail if the locking is actually working correctly. :')
>
> I'm okay with whatever is "free of known races" and works with the use
> cases we have, so use/adapt whatever you like best.
>
> If you want to use this, feel free to add
> Co-developed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
> Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
>
> Good luck! :D
>

Oh, neat! Thanks, I may use some of that. And that makes you have a stake in
this series now. :)

Bartosz
