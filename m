Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23843B3895
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788816; cv=none; b=FYjayeLnt3EGpxZO7SGZrb699zeXzU6xe+l2sTRgIl2el5Wf6iTJEXLz7gISQRIgKs+CUWEWr/DhxRz7ncY96BXZn3Yaw3W51SQrkSpCkwSjMfYBPXOyisW3RgrqTAL/ir+TMGPMTgxVInvGqyiY+hJMszpkTDxWPnaw38hYNw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788816; c=relaxed/simple;
	bh=ENfMXRS8HMaJnBoWbcgdaMRuTOAt+yXRUIaPQqd4Q6I=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RMEBJu579gLKUUMGQyzMqu2hC52aIPgrWsFu4v1LJh7u5llhHzC+P0QX6/8EeYZecFV/+0PThcPCIXJm068Kt3P7uAgiS8/DuxIT7lpa2T3naCvMrVuNcNYJ192+/FY7SKIyjtu8JOvmzX7jo0rMVw3rrjKvqtwfj4VCgx22bQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4M5csEo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4M5csEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C081F0155A
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788788812;
	bh=ENfMXRS8HMaJnBoWbcgdaMRuTOAt+yXRUIaPQqd4Q6I=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=Q4M5csEoWZv9ZfU2m2qHx7utXPJs5kozOWfVMyP4m5WNYUOKVNqoqLoZ1ptmNaVL6
	 Z2FNCe2bqe/hZCbimOdtaIWuTyaQe3yBIV55Qj8vWm5CF2VLsQ22iFFISCfRdTMVld
	 Eh+m48NuiyvcVhyi4w7ZgYdTtEyOXXi480TsKM/2cAZJUI/97MzwtgtWxQM+IqIWHk
	 dmMcpx4IKaiMYs7FUtN6eRzGAgfxYegMUgThsF34L3jSFG2EOm3aJsNqpXg/NhL4Z2
	 aYhgzV3RUTEcFZdhKM9kWCGOVANuMgTeJZPSWLk9XIv3vRiF8922kkiTYZozBCkKjr
	 7VT2H1n47ZHXQ==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-39faa67fabaso22183131fa.3
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 06:46:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz87Qhb4azEARZpQVauXIIMPZcypsWnzsBOqt3F+2DQ+R32iRXNeOsaEy2b6+twzBvXd5rrlTHqR2S6+us=@vger.kernel.org
X-Gm-Message-State: AFuF++mDKQIV2RBPaqFzm5gtvpIovsjh125J0Yenk2JN6+1RVEfSq+Wf
	GNkCGANIm5JY0EJ7b7fGoGWhBOXswRkRP1pTndI6BN4dqodo+aqUZ1ITUG4igksO9T2MwxoWAwP
	oOLa5Yq9gKYHjkffq+OcOxdadawEwMrliQBKHA3V7SA==
X-Received: by 2002:a05:651c:31db:b0:3a3:7681:6d63 with SMTP id
 38308e7fff4ca-3a3768175aamr22453071fa.27.1788788810808; Mon, 07 Sep 2026
 06:46:50 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 7 Sep 2026 06:46:48 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 7 Sep 2026 06:46:48 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com>
Date: Mon, 7 Sep 2026 06:46:48 -0700
X-Gmail-Original-Message-ID: <CAMRc=Me=JxgZv=cuysWhmwQjUp5eHcxzkzoPUnDWipjoNdn4Ag@mail.gmail.com>
X-Gm-Features: AcwNN1Xv4UecDLD1MBX-AoviCLGMwDuPTN3cTzhpLP6LqWwHfNeos6xvGVTTdoY
Message-ID: <CAMRc=Me=JxgZv=cuysWhmwQjUp5eHcxzkzoPUnDWipjoNdn4Ag@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] Shikra: Support for QCE
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Bartosz Golaszewski <brgl@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Sep 2026 14:03:35 +0200, Kuldeep Singh
<kuldeep.singh@oss.qualcomm.com> said:
> This patch series enable QCE support on Shikra.
> Shikra is derived from agatti target and QCE was using different
> compatible configuration.
> Also, one more reason to update QCE is, clk-smd-rpm was doing proxy
> voting and crypto was consuming it. With proxy vote removal, qce need to
> vote for it's own clocks explicitly which is already being done for
> agatti target. Adapt same mechanism to Shikra QCE too.
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/arch/arm64/boot/dts/qcom/agatti.dtsi#n889
>

This looks like a set of fixes to something that's already been queued, why
is this a v6 and not its own new series?

Bartosz
