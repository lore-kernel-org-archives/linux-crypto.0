Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A18448D0E;
	Tue, 14 Jul 2026 12:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784032583; cv=none; b=oLWjBIvdiYybeTlfKmV8o17ysyMehny5kjXkP+caq9efSXdaimjVx10T1YvBajeSkLLZwyNBLWSXY5owh+ERjNLPyp7tw2uhYwbilYLhi49ON6Nq7D4Kcs0y9K3J8Dy2PJwiffUlv4SP/iJvFHtKFy2LTCwS/C96P8t8FgWDJM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784032583; c=relaxed/simple;
	bh=bo8iQUWXWp5xzgrm1O/c0e6m6RFVvR/l0YpwSl/AQM8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XJZUHAYUfL35zO0ulzH5hnR7NZa6gc9InsACHfKobmNkg9MkfGAr48yHv3VVQgZV35FPzBhgiQf9iJ90523nILZ0AydIgkjwaNf+66CSONwe5o5CSVVZAzPZZgMLdqngQ3BzDJCcjyOyicCnUBdwR3o+xQObj/Zag81PQBeoh0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUBWtPi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUBWtPi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979331F00A3A;
	Tue, 14 Jul 2026 12:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784032576;
	bh=dXE4pi54mffTdBM6BBdJAYt1qw/VZNomIEG41ez97LI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SUBWtPi//01h3GOUsQwXLWgcLV+x3cxRJwecvmCM7AXcsf7SfoYmpI0d8+4Oj+4yH
	 AszKpfkNWDz92Hiv8ACW4ZQrRB0IiFNgwXtg8lRhaAvjV1+Hv3HGBYlF43fp6u26u4
	 IX18IfhDnDRjC2WJyVKjUNc/RppTTmWk6KntX3BkU4Iq7BzLSCOezg7UHnIrNhpiw8
	 hsvSfBk3u3nD4YJ10BcM6RaRBwrdqlpn2tVVENTNFTRPcWkoAhPHYWRTzN5nk6P6yp
	 RnFyjhkWVIL3bBEITWr32+hsJpRMqQNHJvHW7jT+Qi8IR6dl47IwK5k9Dj+Oaqhep2
	 GM577i62Zb/7A==
From: Vinod Koul <vkoul@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Harshal Dev <harshal.dev@oss.qualcomm.com>, 
 Bartosz Golaszewski <brgl@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Andy Gross <agross@kernel.org>, 
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
In-Reply-To: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
References: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v4 0/6] Shikra: Add DT support for ICE, RNG
 and QCE
Message-Id: <178403257021.822807.4109816016403933349.b4-ty@kernel.org>
Date: Tue, 14 Jul 2026 18:06:10 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0


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

[5/6] dt-bindings: dma: qcom,bam-dma: Increase iommus maxItems to 7
      commit: 242a57d2d0b4de346cc33c385fec4f901c476517

Best regards,
-- 
~Vinod


