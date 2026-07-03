Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F14B38398D;
	Fri,  3 Jul 2026 06:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783061665; cv=none; b=d/T8sLWP53fsCotmarDPZ9Zu/5EQqiblRbVp7fk2B7870rHEzhi4MVQAQaXqxs6Mn7wfAVpLNTa7JGz8M0yz9+twhG6ZKARBTSL8fbVsu2gZFdgfEzRrvaEYW7SvmWN4sqyJQFKxLWrZrgHWyRwyGumVsvG6SR870QM5zjqv7Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783061665; c=relaxed/simple;
	bh=FhFuq5qnj9EZkAKiIWV+Te12W1lRRLVXu3XEpEvO4sA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFeaZf1R5ktmlLWfUlFP860lWiA+eWr4qfWIHMAG3tnwiAyPQ4a3bi/1JR4pWmit7Ac/GY52t7X+CD02SQ6RzM3CL7X+7uZ1cpCk08EteIDueip6E1hp6CF1ZI7g3RifhH8w1qdlWbvEB/8yWfE0Qy0VjD6lmme4EmehQ7J4Hn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kd68TaoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kd68TaoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7671F000E9;
	Fri,  3 Jul 2026 06:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783061663;
	bh=0+BA8waOfM6MAkyBn4YCvzbeQct3LYrMLR2zjG21jIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kd68TaoReLeAFZLkI9iHtW2pfut3p938qr6Gs784eNGmWC8Pc/PMJvRIlm3EK/sSy
	 lAFB8kKW1D8+vLD0uU2Ruu9Cxq8CWMl3b1Y/7tGSZ6oI8SsSZuC9R/54j77cMtkVe/
	 N8xUvhmfBEDq0Hq4hWNlDMgq/jTNcXn0RlLB/HLs4C8yRve2TAiL834aR4PRGZIF6Y
	 PCpcBQz1GzsV3Fbj2cvfb9+Eo90JvS7jHrR19FUyGwgmIuApXcelqCawoM6TAMZX/L
	 Wh7gFTfU10/vZFT5SjOWre1gXETUwhtR6ZHOMUW6thAVAu55gCIkwevASmnGZtF6/s
	 NAyNxnV9NV/4g==
Date: Fri, 3 Jul 2026 08:54:19 +0200
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
Subject: Re: [PATCH v2 5/6] dt-bindings: dma: qcom,bam-dma: Increase iommus
 maxItems to seven
Message-ID: <20260703-steadfast-greedy-seagull-ad32ab@quoll>
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
 <20260702-b4-shikra_crypto_changse-v2-5-66173f2f28b3@qti.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260702-b4-shikra_crypto_changse-v2-5-66173f2f28b3@qti.qualcomm.com>

On Thu, Jul 02, 2026 at 01:47:15AM +0530, Kuldeep Singh wrote:
> Upcoming Shikra BAM DMA uses 7 IOMMU entries and not 6, so increase the
> `iommus` maxItems constraint.
> 
> Fix below error:
> dma-controller@1b04000 (qcom,bam-v1.7.4): iommus: [[25, 132, 17], [25,

There is no dma-controller@1b04000 in DTS. Please drop all the warnings
which do not exist.

You cannot add incorrect code, cause warnings and then based on that
claim that there is a warning to fix. It's like adding NULL ptr
exception in next patch and therefore now you add some additional checks
for that future NULL ptr exception.

Solution is: do not add NULL ptr exception...

> 134, 17], [25, 146, 0], [25, 148, 17], [25, 150, 17], [25, 152, 1], [25,
> 159, 0]] is too long
>       from schema $id: http://devicetree.org/schemas/dma/qcom,bam-dma.yaml

Best regards,
Krzysztof

