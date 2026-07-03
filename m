Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026B8359A6F;
	Fri,  3 Jul 2026 06:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783061532; cv=none; b=Crz8GyQK4hzHDKz34BjGQvNqhIAloILc6rgAvicUY1Ldxxy3uHJUt30w64KbHEkKdCiTcYQYF5Ii1TfWZy/xldNLN22mjCdCOqyYsMfNUFxsNuJc8q8ejOkA+HoWi4It9/0FeEHhSRiQnCdIrmNLtKTIa2kBoRD5viYGImsHS1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783061532; c=relaxed/simple;
	bh=ASaUIf3P6lejgpZPz/2gzkA6H5vkwWzCgrmo6fQ61PI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIV55IMDroxp8fHweDjqTcwLmpWQKOXYjqcJs72iq0UyGKwEprbBZu7eZJm0Cfc9JztK8wCi3SuS1a+E8EWtlppHqFMXmxLOS0tmTlhUqDs8aVg/VzQORPgnHd1WMumq8UzYtwyQE5uHY8MuUcYrFhLOLuD5Lm5Y8q1nGjGYCyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfvPkMOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfvPkMOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA731F000E9;
	Fri,  3 Jul 2026 06:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783061531;
	bh=IikEcPnhrzjycOXkCJnGCaMtTJCsaRnbvxep6t3bCQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DfvPkMOBTOyiSHwEyAhA59RI2ad2bl1clZywrZVE/ixa0l+c9U6qcozk3+kDvPKHp
	 m62GNUCctRCtf5+EKZP9O8quDM11+k7bl7nrdBQEw2IdTi54BlcuIT+h1tWfzsrzN6
	 ZKB0hPMjiW8mhFnuHsr19Ls3OfHSO2Gybm2oWLrliCm0nfYtAY0hK1q5oH47N+iZE0
	 ngnGTvM0FEf0CqSpu+57zm6IHbNsjRt5GzTK8ZLLwOmext2eGMTHRNelsapTwkUeUM
	 gXwblB6f93el02hyPoCBvh1xjH2nUwLrU+QGQijEDLwHdVIA6mBgbuRHjjMuvYbpEN
	 V99+B0SEEdvYQ==
Date: Fri, 3 Jul 2026 08:52:07 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Harshal Dev <harshal.dev@oss.qualcomm.com>, 
	Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v2 3/6] dt-bindings: crypto: qcom,prng: Document Shikra
 TRNG
Message-ID: <20260703-talkative-observant-goat-be7e72@quoll>
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
 <20260702-b4-shikra_crypto_changse-v2-3-66173f2f28b3@qti.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260702-b4-shikra_crypto_changse-v2-3-66173f2f28b3@qti.qualcomm.com>

On Thu, Jul 02, 2026 at 01:47:13AM +0530, Kuldeep Singh wrote:
> Document shikra compatible for the True Random Number Generator.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

