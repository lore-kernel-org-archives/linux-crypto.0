Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61DA1C2324
	for <linux-crypto@vger.kernel.org>; Fri,  2 Oct 2026 19:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790969507; cv=none; b=aLUbhEJjaE00pPLS7KsWMBo3MY3ZCqPDS4+VMRPdDx0BAxU4haYWNT/G54xR94+ETdonOA2oBb+y8TimD+zAHWNiFQEqITMyZcfEChc1wPw5ALkRZKrVnLLr7U+OPOuFctW/3kboQi6igvGTmgXsKoolSqM+0x+/aZqoAHWuZZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790969507; c=relaxed/simple;
	bh=Gj+PEAhdIV/uFJgJbAghSUHPHdZ/2r0J4sOrBe2CBfI=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aVclU4+CFoHwaPyRcg1ynPSjFo93jeLWRYjPPr+3GFMdtoq+GlU5EnNxpnu7DApjigYgSy/fe6UJbzEqg479krbTit2vY0HMINWDVfPrkokIK68WgYV0mKLuB3TJ6Dbk3jttP1bLCLyoGwTU5LO5IeRnx/LWdk/4eF5KGQaRxAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZSEymhM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZSEymhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91421F0089C
	for <linux-crypto@vger.kernel.org>; Fri,  2 Oct 2026 19:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790969505;
	bh=Gj+PEAhdIV/uFJgJbAghSUHPHdZ/2r0J4sOrBe2CBfI=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=IZSEymhMRmymU/5mjnOE3y5B/8QhrXrNBFWEdRmLHSCXxuw/2tuSkkBpfxtDZ8C2+
	 6+a2iCX4rgvLAkGlUd/0DkXOY7QXWdSX7jD03TM6NgI5j3Rf7TEqOEwJAEChQGF2T6
	 YLoXKyiHiEW1/pRdMFRvXBhxISIxzxA04E+sed3xoqoInnXXzlVEPsSHZlK/PLQB/S
	 iuYH9efUKViXPqdL9P8iPCOsP6wiLSHDkirGQVmkWXAaJFc/R8bzy+A1QtyvhnKCYc
	 yz45RPWrNAX/CIVRFwrTN4C6g4N4AYN3aRmHOoettwByFFPh1Vk3zA1vHmXF1XpdCI
	 8JasszxgRAB+A==
Received: by mail-lr2-f35.google.com with SMTP id 38308e7fff4ca-3a6124046f0so2342781fa.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Oct 2026 12:31:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy58I09RawGbnXfVC9TgaA1qpdCx2GLe6trppoNU7T2vr375VrWeGaJPIbvlgHPqV43svT+D2F5v/LgJRA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLG9KGKXN1Nu4PA8e+gViPvGqHqU3G8D7hYUY9L3gbFvFGlvG0O
	nqL1JPLHQF+W6gr7bhkohlBRDom222ExpgrACH79Eom7QjuqJJV4DrblpWRqJrWRZPnpRvYNOeS
	KdURmMnxQVQa7h2yWmLh271e16mbtv3GI43O7aUbNYg==
X-Received: by 2002:a05:651c:2121:b0:3a8:7b84:be9b with SMTP id
 38308e7fff4ca-3a8877b73a8mr9365471fa.5.1790969503992; Fri, 02 Oct 2026
 12:31:43 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 2 Oct 2026 22:31:41 +0300
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 2 Oct 2026 22:31:41 +0300
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <ar9qNirrzOTDLipN@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com> <ar9qNirrzOTDLipN@gondor.apana.org.au>
Date: Fri, 2 Oct 2026 22:31:41 +0300
X-Gmail-Original-Message-ID: <CAMRc=MdRBu5gg7Q3pz8Wn9Da4RpmmiKLP2-LwiszKCd3o8jQdQ@mail.gmail.com>
X-Gm-Features: AclHuK8wQ6TwGfqRhG76u8I4Ivw1PHBRVeaKEhxJd2tlBCqG9_-Cl1JOHG4NPMU
Message-ID: <CAMRc=MdRBu5gg7Q3pz8Wn9Da4RpmmiKLP2-LwiszKCd3o8jQdQ@mail.gmail.com>
Subject: Re: [PATCH v9 00/14] crypto: qce - Fix crypto self-test failures
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Stanimir Varbanov <svarbanov@mm-sol.com>, Eneas U de Queiroz <cotequeiroz@gmail.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Eric Biggers <ebiggers@kernel.org>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, brgl@kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 2 Oct 2026 10:24:22 +0200, Herbert Xu
<herbert@gondor.apana.org.au> said:
> On Tue, Sep 22, 2026 at 02:57:15PM +0200, Bartosz Golaszewski wrote:
>> This iteration - in addition to the previous fixes - proposes to split
>> the QCE driver into a core part necessary to bind to the QCE DT node and
>> enable runtime power management in order to allow to drop the
>> interconnect votes, and the crypto part registering the crypto
>> algorithms. The core module is then enabled in arm64 defconfig while the
>> crypto part stays disabled by default. In addition: the actual
>> registration of crypto algos is gated with a module parameter that
>> default to false.
>
> Please check the Sashiko comments:
>
> https://sashiko.dev/#/patchset/20260922-qce-fix-self-tests-v9-0-b1aa742e79af%40oss.qualcomm.com
>

I've gone through them. None of the issues were introduced by this series, all
are pre-existing. I've added them to my list and will fix them. Can we not
delay this series any longer and instead work in smaller steps since the crypto
algos will be disabled by default anyway?

Bartosz
