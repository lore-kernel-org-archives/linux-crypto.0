Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443304;
	b=VkLjIQVatnOisgk5mLPhKSJwxUTioZ6iUg6izj830pTbR5AKuvuFf2spyaE4edmmbLQ9
	 bfGGuG23oVvWMzuHPOG3kflHXv/O89IMWwLsix8z7215vhML3sQphBzbXhAJlzdOY5uFP
	 edkuvIZj93ItaQbeO+Px5tfKj8hMx0rBf7pgq0AbbpkVR0GMwPTWVzAn+zEM7I9N45yWY
	 9JjfoYZ6CtFqdfyFbQInrGCsV42wkSXoVM5Rs4Gb02TDh/YYRujaFXhwXzVMf5/grBvZf
	 G9kIsZyHNi7+1781M5KGLCvDZzyx5T0pXfRSGM6KNLtLEnpZaH0jac1MzbJkTCfaxoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443304;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vMS5GsT+FQIMrcDcIClkix4yuVqpJWj2FVwp1tBqdZA=;
	b=YrWXvcrno8IrecyF59c7D5RSMDiqisysNss8i/ekYhTiR9ZoO8HIsNTOgEB9wrB0DFp1
	 lt3fQIOfAX6bX4v0FXsuiBKgebJRsnDGxJIKH9B+6ObGzHGFEhJPY89Sox+ZgfFvSVzMn
	 eMzPXX6gzFhFE73BKpBNFhOUwp1IZbomkNrsizXPo22vs09nYlVcwKmBfwVgtV741wQ1a
	 aBFGtUKxcZYEltMQsfJIHuDwkFQ/H3S+llGPyOCpKh2l0npPwOP1Ltf/PgheJDDy/bszL
	 Ppv8PyD5GVDbxnXhgDvLsqis3z+uZ0ZKZ6/i8UQdMpWjS8R6DWBqUBjSEmOTtXrQliw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dKoeBY5r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 19634606A331;
	Mon, 23 Nov 2026 14:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dKoeBY5r
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC8631F000C4;
	Mon, 23 Nov 2026 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795443303;
	bh=vMS5GsT+FQIMrcDcIClkix4yuVqpJWj2FVwp1tBqdZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dKoeBY5rW4/ez1gkQEIBPsXto3zTNST7Hs3HdUbeUStHoba6+w1E+izU8jVnvbNs2
	 NxvLViQRf5OBc/LnIxO1n9fvsQpDGeD2PQV/jGWnjBg5tOeP5jQiBkd6mersZmA52/
	 UsHwDV98N9gC3yEONBBA5lPH7bWA/JkHiamZexhcy9MmRxeILmQ/FYhj/yCMhTRMCC
	 JzJ8s0pcvf3msUyXP9LH96oqk+TISc0wL1ixY0X7xn/Af55lEQshol+0MFP0EkLpcu
	 BNDQOQlIkPh0Hon7/omAmIwIMvCLhj4QpT//m3fj0MBDGrQK1QpBiGb/LOzglXxBRu
	 7HbYnrvwF3+7Q==
Date: Mon, 23 Nov 2026 15:14:56 +0100
From: Bartosz Golaszewski <brgl@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Abel Vesa <abelvesa@kernel.org>, Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Subject: Re: [PATCH v4 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
Message-ID: <x5s55d47l5wi3ai476f57mkwlgsbup33mo4gsgoblaqirqasll@qrer3w2a5xmk>
References: <20261120-shikra_qce_fix-v4-0-5249e31394ce@oss.qualcomm.com>
 <20261120-shikra_qce_fix-v4-2-5249e31394ce@oss.qualcomm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-shikra_qce_fix-v4-2-5249e31394ce@oss.qualcomm.com>

On Fri, Nov 20, 2026 at 04:59:53PM +0530, Kuldeep Singh wrote:
> Shikra QCE requires an explicit core clock, which is missing from the
> current configuration. Adjust fallback compatible to "qcom,ipq4019-qce"
> and specify core clock to match updated binding description.
> 
> Cryptobam is controlled remotely and its clocks are therefore managed by
> remote crypto subsystem.
> 
> Fixes: 099cd05d200b ("arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes")
> Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com> #on shikra device
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com> 
