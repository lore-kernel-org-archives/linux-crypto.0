Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DD33E317B
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780070309; cv=none; b=LQRuO2Xqb6ButfK6dernuqDJQ1+Z329L0nN7GjlMwGRlqSuh8VurKwfBvg/omLWvyJtQoLp0/HOsqqBFrhAfU8Pv0yMDQ21sOsAsDL7iTzgcwf4WJOiCJIiaf3XX0brQRh7Ao3hdXbUbd+m1hPWgMgdK4M9rn01PdlqGrxtlX1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780070309; c=relaxed/simple;
	bh=9BCS56pVRryY7pWjuzmcS8K36R35NfR88+/6XLLhN6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tgqMt8aCNNHcGzKGXpmQ32XX2AqUOqtjibtWXiAkHfs2UiPZAUQAN+PO/vWrOWoXxgLBohM6lTHSAMWvbKCYCHt8ZwMtlkoFZkOfJOxIANAg5PQD+zoITnWGoWw6EHTcLr1X7U/n6EGhhAf1EtzQgzgc3ZsH9tU6FQcn5apJv/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P3d54xtL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3d54xtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0188E1F00A02
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780070308;
	bh=9q8bnA8Cybs5JYtZeRk2lM9ckb6ZQxrxMyz/lWzwvTQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=P3d54xtLn7Ia7Nk5lngi8u5E3xjbRP6p/xAKljQBbrNrug1jMH/sDsM9xCIdtYLHb
	 T1ns8r6FvNwhZaO18DtrHjb4baqPSWJ/3YiGqWL9p5L1rIRP87PhMXNAQu9TGp8EzF
	 f5W2S4zL62KwX6VO0XF/ZlBat0Fzkjis4YdcNAvQ4HUNeEQNEh2GB/rq4RVJMZqMTH
	 Q1aOE2+MUi5lVzOVCxno9KCFyI87w9vM/cYntbVKAZzt5kUm014zfOzF8kD7GHOAvy
	 qnrQFwbYhVf5JsBHS9Uztif27v2rwCXRcGyGIpAimDGDoVk7748Z2q8y5A3OvtgY1S
	 hBi7szKWxWhNw==
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1353c2f35cfso7458157c88.1
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 08:58:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8a7mtJu3kdd5uz3tW/w2xcGIm/xq3SMGbSQpfVfS8/X56qcfxbEw3vcWbMA4GFUi6bejIQXCI3gm37IgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEhaQVCpkYCcfIG0GgVfDpL6od7LSHMFakrUsdUmIdDT+wHSec
	3hv8QfdOq5/qVgU0ofNgqMqJh8YUZicmodk1d23h15RI+Mdit/82glb5JhnCDsjlkbPUwarfCl4
	2ilzT3UmBJzRJZsioQA1lg7phd/UO3MgaI+g46IgOyg==
X-Received: by 2002:a05:7022:6299:b0:135:dc3d:ab50 with SMTP id
 a92af1059eb24-137d4242f26mr125225c88.29.1780070307047; Fri, 29 May 2026
 08:58:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
 <20260514194735.GA1939213@google.com> <d4d35e17-84fa-4c95-9bfb-abfd25ea7f4a@oss.qualcomm.com>
 <20260522024912.GC5937@quark> <c1697372-54ec-4f57-85d9-ad375ff1a44d@oss.qualcomm.com>
 <20260525142843.GA2018@quark> <e49c4a45-6455-47f3-a91f-c32c1a0b99be@oss.qualcomm.com>
 <CAMRc=MfC6CEwOXYttsav3mwqyJ2F4sburBj+zNJ25qMoweyL-Q@mail.gmail.com>
 <lj7geczhthury476ilkjym2k5fblo5pqroefsbdfgh5jcf7zy2@qrss5xc7umn3>
 <CAMRc=Me6cqasdBknbAjUZ5BqcpERYwV+NvseRJp4P0aTSYAMUw@mail.gmail.com> <20260528175214.GA3936298@google.com>
In-Reply-To: <20260528175214.GA3936298@google.com>
From: Bartosz Golaszewski <brgl@kernel.org>
Date: Fri, 29 May 2026 17:58:12 +0200
X-Gmail-Original-Message-ID: <CAMRc=MfY-tmMCdw9FVBgfkX-FvB5Nx2X06S023GhASenSCQSNA@mail.gmail.com>
X-Gm-Features: AVHnY4LP_t91eok9MEp4yvSeZMeVRFiXKE_WmFYVgc-of5NzGm-5x7t-ox5gugo
Message-ID: <CAMRc=MfY-tmMCdw9FVBgfkX-FvB5Nx2X06S023GhASenSCQSNA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add support for qcrypto on shikra
To: Eric Biggers <ebiggers@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dmaengine@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>, 
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2026 at 7:52=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Thu, May 28, 2026 at 11:13:47AM -0400, Bartosz Golaszewski wrote:
> > On Thu, 28 May 2026 15:50:10 +0200, Dmitry Baryshkov
> > <dmitry.baryshkov@oss.qualcomm.com> said:
> > > On Thu, May 28, 2026 at 09:13:23AM -0400, Bartosz Golaszewski wrote:
> > >> On Thu, 28 May 2026 13:54:51 +0200, Kuldeep Singh
> > >> <kuldeep.singh@oss.qualcomm.com> said:
> > >> >>> +Bartosz, Gaurav, Neeraj
> > >>
> > >> I know about the self-tests etc., I will address them next.
> > >
> > > My 2c, the self-tests would be more important, as they are fixes. Doi=
ng
> > > the crypto in a wrong way is a bad idea...
> > >
> >
> > Then let that be "in parallel". :)
>
> The race conditions between Linux and other environments (modem, TEE,
> etc) are of course about correctness as well, even though the self-tests
> don't expose race condition bugs.  The self-tests have always just done
> a few serialized tests.  That's sufficient for CPU-based code, but not
> for offload drivers, which need to be stress-tested to find the
> concurrency bugs that occur during actual use.
>
> Is there a plan to improve the tests to do stress testing as well?
>

I'm not sure if we can easily implement linux-only tests using
multiple execution environments. I will look into it and come back
with an answer.

> It's kind of odd that they don't do that yet.  But it makes sense: the
> CPU-based code doesn't need it, while the offload driver authors have
> never cared enough about correctness and test coverage to add it.
>
> I still don't really see a path forward here, given the track record and
> poor performance numbers.  This approach just doesn't work.
>

Sorry but I'm not sure what your point is. What this series does is:
it documents the compatible for the crypto engine that very much *does
exist* on the SoC and describes how it's wired up as a real HW
component in devicetree. Whatever the state of the driver is, it's not
grounds for NAKing HW description. The IP *is* there, we're allowed to
describe it in DTS.

Qualcomm wants to use this IP and I will keep on improving it. I think
that - given the BAM locking series is at v19 now and has been
initially posted in 2023 - I've a proven track record of not
abandoning it. :)

I'm away next week but will look into self-tests the week after. This
series - once fixed - should go upstream independently.

Bart
