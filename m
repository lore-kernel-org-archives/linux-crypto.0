Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7F739891E;
	Mon, 31 Aug 2026 20:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788207706; cv=none; b=kSko+xz3cNM6kdEJX+1oXNuoSIYFlGag9vJqiG/3Fj9bYxJCd13TzaTD4CDPwMcYQWTZDurt2pq832aK1zChSM+QdK+w+0kTh3fpY3LWhovDujMRxP+bA7fN+p6lyIAQwJuV8om8NvFc10NX+AdZnKGBOc6PxO4wd4p4uCbwwrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788207706; c=relaxed/simple;
	bh=/Y3EZxW6g7d5B/VNknmDyKXeSC0mAN9v2XpLzeh5uDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OAxvT/belk6O8DWvUV/6HNm1G8RTfHFG+SyW7XC1vWSDgE4KaSpHaxPVIx1osAX4HA4xKiL760R1Tg3BJoXzyM3J4N0jqe6dNw8Qr2V/4byqDc3E6W3nwp4zwlcmiLGPcJEgBRLU3CLhpXu6JB/hn9jg3ViHPxbNdDE700DrAlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W/T3s8o5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/T3s8o5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FE31F00A3D;
	Mon, 31 Aug 2026 20:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788207704;
	bh=TallvL90aPVr5j44xFEumLaFjCEv1DwUjfW0ndv9IbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/T3s8o5zidjbRKvHEyU6mwUFGaEa9/KjMdmRdtOdtFstKF49TDCNT/zvyEaTMsHK
	 OyaDYfyhDF6eJDm7tSUNytn9WeMlCFmondevUoLEa0m0EkLVFZa87UujizO7hDRcYR
	 7Udq7LnK/5ppodkROlqfDrjNPiSk+5fTjHzehO3KkwFr6JfWg8gaohQnsLcWs8qkEK
	 V5akRTnnDs7veo7ewgDy2+0RW7RVFC9Va9szEeBHn7zrkaO6lf+ivwxvlh4zxLtfN/
	 h1QNQ1kMCUgTYRZl7h0q38T/VZMV/oM/wAdL8SASCn+XyJscWP4KR0FaoGt6EiajSC
	 AmYbgwk0W0y6w==
From: Bjorn Andersson <andersson@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Andy Gross <agross@kernel.org>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v4 0/6] Shikra: Add DT support for ICE, RNG and QCE
Date: Mon, 31 Aug 2026 15:21:21 -0500
Message-ID: <178820768643.1699313.2761481849387372250.b4-ty@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
References: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 14 Jul 2026 15:35:11 +0530, Kuldeep Singh wrote:
> This patch series enables SDHC ICE, RNG and QCE support on Shikra,
> aligned with how similar support is modeled on other Qualcomm platforms.
> 
> These DT and dt-bindings updates were previously posted as three
> separate series. Based on review feedback, they are grouped here as one
> crypto-focused series.
> Previous threads:
> QCE: https://lore.kernel.org/lkml/20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com/
> RNG: https://lore.kernel.org/lkml/20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com/
> ICE: https://lore.kernel.org/lkml/20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com/
> 
> [...]

Applied, thanks!

[6/6] arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes
      commit: 099cd05d200ba241bcc7497c4384b8d657a5632e

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
