Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CD63CAA51;
	Tue, 12 May 2026 20:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778617415; cv=none; b=SC7qgA3YQ2JkR0I3Ojx9svz1kVsWi3z6/DOZUjvS3eIW/aY1BIdgnJitXBgg7eG+rHe+wwpv0OssRgXtpkjAqpL07hblFEzEr3PM+7K+4gH9xFdIaNgINRAt6OSihC5SsYW3FMC1qYsvQX/T+3peH6AVqhOSyYVPoGGiCmyMVt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778617415; c=relaxed/simple;
	bh=Ziiq1lQIaRMTdSAD5F7GQogjzHQoMWPR8kOGGdizVt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uy4QizP//z8LuhycDD4M4i0wBQ5W405IwjH6vQf2eEpycjSdXT+ELPLPfxnF9PELK6vSl1M/ZUUycKv+l5RrpB8eVZ6tdoeeThMqDu2Jd2Tf3TEOwia+on13HYMEG97TxhHyBrRFreiy5ENuDiJ5qTkCEpvzlmag/9xy9Y6KSmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrhOpK/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrhOpK/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0453C2BCFA;
	Tue, 12 May 2026 20:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778617415;
	bh=Ziiq1lQIaRMTdSAD5F7GQogjzHQoMWPR8kOGGdizVt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrhOpK/U6AGh1ueawrEZm/YFdXeXSFjFq3VI1QJ29XEnH8AaFGP6NLtiGlWEwzU04
	 qs/tjbzVHNCcBxgeVt8P1PMW591/58boXhQzOBOvBUo4prTDv52nn2ruGe6e6tT3BM
	 oVwKojiMA0YK6bcJ/SxPWoSqJfbghS6PEN/kii3ErMbktOo47T5VyvVeOhTIvGyMJ6
	 NvgLQwmF9uVECYk6mcSya8lI3IfllcpE4CqKwkrELlvVj4gRjRD+znzeGJJzHHDgGn
	 uFEOK/6IooQ/OjnQGXfvDLFOSx/t+3a0bbyBSgQXXLQJLV9+7F34oopTf0nH8NZG1S
	 4Jml0eGCyLGQg==
From: Bjorn Andersson <andersson@kernel.org>
To: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v2 0/2] Add Crypto Engine support for the Glymur SoC
Date: Tue, 12 May 2026 15:22:46 -0500
Message-ID: <177861739350.1242344.1525682685379618223.b4-ty@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505-glymur_crypto_enablement-v2-0-bf115aeb1459@oss.qualcomm.com>
References: <20260505-glymur_crypto_enablement-v2-0-bf115aeb1459@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 05 May 2026 13:10:02 +0530, Harshal Dev wrote:
> Document and add the device-tree nodes to enable the Crypto Engine
> and its BAM for Glymur.
> 
> 

Applied, thanks!

[2/2] arm64: dts: qcom: glymur: Add crypto engine and BAM
      commit: 93e08fdc55f227847dc9b249fd5eb43403e7e8b9

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
