Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA3B3F23A4;
	Thu, 23 Jul 2026 08:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794519; cv=none; b=FTs/IL/MZ6ZMGSuN91ziclXbqQGlNbRTi8V4iQdbimKn/RvtlghVYrYgHmr2uoEtYMJbJEJZbTtSg4HcRkSV9GT0SQIZaU1YBLLyBSoAOMca6Z9LiFrrWkjv98NpXPtzkQB+VeiD8DdvJBDBEZSKAfK43wqLjGibQkzAhuuR+PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794519; c=relaxed/simple;
	bh=iohF7JqZvzwPQDaoRv/8sIZHTAjK7IjbrRtu9LPSGzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7rlXawU61WYtJXKukhYbE+WW9YPKYPLzwuhG87EFbDkQYY1mltCsRtCvQoW6XbrrvHiLWbTA1FKeJRDzJe2UNKeTFsvbaT2sEqT/Z9Hk2fim5rnXoygozxqXYSsNb8bwsvhX0TFb0zeXRU6UDv/05qkCgy3zRkwKGo+GGZCK8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C781F000E9;
	Thu, 23 Jul 2026 08:15:17 +0000 (UTC)
Date: Thu, 23 Jul 2026 10:15:02 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel@quicinc.com
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Add x1e80100 support
Message-ID: <20260723-impossible-invaluable-sturgeon-3b2ce1@quoll>
References: <20260722-devtool-v2-0-d7e609ef7388@oss.qualcomm.com>
 <20260722-devtool-v2-1-d7e609ef7388@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260722-devtool-v2-1-d7e609ef7388@oss.qualcomm.com>

On Wed, Jul 22, 2026 at 05:26:28PM +0800, Wenjia Zhang wrote:
> Document the compatible string for inline crypto engine found
> on the Qualcomm X1E80100 SoC, used by the Hamoa IoT EVK board.
> 
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)
>

This is incomplete, although maybe you based this on Kuldeep's work but
nothing explains that here nor in the cover letter.

Best regards,
Krzysztof

