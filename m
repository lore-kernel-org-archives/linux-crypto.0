Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A42230F7F6;
	Tue, 16 Dec 2025 06:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765868210; cv=none; b=lnKouKdh/PDre4q53hce9a0o8UPDvfedfBz5jv4Esc6LW8sIoXbu9iK8ChzAx/DHMsLF7savQBTUVuMMJk8fBn5s7lbh4Ef6nPNrmFzAcx/1e2NeK5UYklbCgpoHStK6GFtuyLn3GwTfirZCZTo+xvZLBp5CUfNa2I4QuAU+IUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765868210; c=relaxed/simple;
	bh=LLE+QbRY67a3/8sNXwwh/61RXkS7dT2QF1fC3yE4th0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WxSgZ8UHzH/eZDPuzLU11vAPzx/Kh3WDZq4ZM/fhM4luJcJAlX1kY7rCeLx3GUaFaFA3+s93CLItiNQEQzkGs3G0BBsh+HPtoTtsnPn9rdYgsyBSwnmC/gqqQDqf0DxExqIxJOgEhADQtWEwx9WAx+/i3nB4XHt1hWkmK39gcwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tzyGReWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tzyGReWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698D3C113D0;
	Tue, 16 Dec 2025 06:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765868209;
	bh=LLE+QbRY67a3/8sNXwwh/61RXkS7dT2QF1fC3yE4th0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=tzyGReWDlEwh1z1MM9HPsAadMFHBj6pWiaFRf2JGQNSOlAT86omY5EWbWke3DvzOG
	 Cmgdp3j5lXHC7Kw0ShflvgPJbXKH1SJf+s9JtVseZ1cGC/ZzRfFBHFc5sO3QCDjVX8
	 HHLhIiR7WYpjdx5a5BYtyfFCTzzapwEmsSahyvp4WYA4De57sm565lPbNwYIRM5V0o
	 RhFxss8uJWIh7jlcq/PiK/Zb2OXgEnnfUZFAHzSP5Xl9jjn1Y5Hb8YLGmUmhun+7qf
	 bxATBlUecFT3j95N4i/j7ZTPfaf1SptyMzAttwKXgf9uJKxn7VRRHNoQB9ws++o9eX
	 4yUq/ycQwbIQA==
From: Krzysztof Kozlowski <krzk@kernel.org>
To: =?utf-8?q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
 Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: semen.protsenko@linaro.org, willmcvicker@google.com, 
 kernel-team@android.com, linux-samsung-soc@vger.kernel.org, 
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20251024-gs101-trng-v3-0-5d3403738f39@linaro.org>
References: <20251024-gs101-trng-v3-0-5d3403738f39@linaro.org>
Subject: Re: [PATCH v3 0/2] hwrng: exynos: enable GS101 TRNG support
Message-Id: <176586820615.20905.780207403546638829.b4-ty@kernel.org>
Date: Tue, 16 Dec 2025 07:56:46 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Fri, 24 Oct 2025 17:57:33 +0000, Tudor Ambarus wrote:
> I propose the bindings to go through the Samsung tree as well so that we
> can match the compatible with the schema when pulling the DT patch.
> 
> Thanks!
> ta
> 

Applied, thanks!

[1/2] dt-bindings: rng: add google,gs101-trng compatible
      https://git.kernel.org/krzk/linux/c/d9465635e051ddc0d9ebb312174ace55d38d2d40
[2/2] arm64: dts: exynos: gs101: add TRNG node
      https://git.kernel.org/krzk/linux/c/d45eafec01fa31fb9ab30902de35fbbe70f63411

Best regards,
-- 
Krzysztof Kozlowski <krzk@kernel.org>

