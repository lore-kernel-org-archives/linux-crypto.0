Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A2917A2EA;
	Wed, 15 Apr 2026 22:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776291224; cv=none; b=a2hMUUl6db6EwsKzqUdBNmgtiVqT5SDhLYgPNMy/mf5SBJfIOfpSqjchZT8hCsky9+XP8p4FOoTu4BwJjDsF1/LJ4Au3Sywz5kaN2e3p6D7gTXc/QsxaEnJzgZUqxJngOpVaqwHmIef6DMBChxfm0zGwoR5sDsNYIqkSxsR8P5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776291224; c=relaxed/simple;
	bh=Ri/2rRxTy0OrCH3pbbm+vOIszfKTcETUyYT3jYCGOyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P65xr0oJKArbGpQ0nBLe66g8ju0rswT5iu3MxQcBtt6dJgw1RpZv27Fhu1GeJnKI5sAvB4N6o/2A1tO0jlDiUDgsV0SYIMFRslAvVWBE7FAUMJYDFJ/MuRwQ/5CCilnaDgUHJ1mmIttl/yBeq8N7q1yNIYPCtTgEWOvar3x/4ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqYXvbiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqYXvbiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC77C19424;
	Wed, 15 Apr 2026 22:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776291223;
	bh=Ri/2rRxTy0OrCH3pbbm+vOIszfKTcETUyYT3jYCGOyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dqYXvbiJSPi1N8zBxtUAwNxmGDzvk0zd968yUScxP8slRNccogn1HnLCgdlOfGG3v
	 EFgFgSnMBo61G7tmac5vPgVCQzrY61FEX+3TTMsIzL9fxB659pAalOrCOIPAcvmfhb
	 ZJJLpM6oLVj8xNJ4udOO8ojsImpHX55457Zp4oU9+tc0HI7LWIcVywrahOO4j6T2LT
	 VYLDWXzaPyq10Jb7zKacqF50sDsN4RkX1WabXYMnfEkAFJDu9wJpjZOHHGaRInxuHK
	 drWkjev3r+7O3sbhzEIwv0amkQqxHw8R2sOGj9eBUhueic5QS/04AyTDMC45h6DXaX
	 2LFifeg05viBw==
Date: Wed, 15 Apr 2026 17:13:41 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	Bjorn Andersson <andersson@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
	Konrad Dybcio <konradybcio@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	devicetree@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Add Qualcomm Eliza QCE
Message-ID: <177629121955.793028.12836250636771941736.robh@kernel.org>
References: <20260407-crypto-qcom-eliza-v1-0-40f61a1454a2@oss.qualcomm.com>
 <20260407-crypto-qcom-eliza-v1-1-40f61a1454a2@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407-crypto-qcom-eliza-v1-1-40f61a1454a2@oss.qualcomm.com>


On Tue, 07 Apr 2026 15:51:42 +0200, Krzysztof Kozlowski wrote:
> Document the QCE crypto engine on Qualcomm Eliza SoC, fully compatible
> with earlier generations.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

