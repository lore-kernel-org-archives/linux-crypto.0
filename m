Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB343ACF1F;
	Thu, 14 May 2026 12:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778763355; cv=none; b=jsSSBJwyry+zxyRbRQDhvE6MMSOBZGNotRPnBKRXOSmPp4qG7xkRSH7oV02uJjQiZPqBo+PI5xNDoKwjbi2uC20oYZGNBcc0vgvGCdBWUK46UCD5kOo9Yo4s8gq0x8WY+QZtfzaVYhVu4xhlCkfldROX2YfT3URqM+0wo49l59A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778763355; c=relaxed/simple;
	bh=Kl6rjwD5lss7Ys+vR/4lgns3I6fTme/y3cvYdypPvqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvauLRmEHGA+78Z+qeTZiGT3dp6KzOsmX5N+LwS7KvvHqwtogso0lyuBOS+1pOL+IUU8RT014roFHa4jRkxnhZUCrlKkOFH4aBYGu1xox+/gUZKcejYSOlXvvw6AJGwaFTjhCbQskJeyz46uhjVijieDwj6nqZmS/SpAuczanps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p1duOp4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p1duOp4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61CEC2BCC7;
	Thu, 14 May 2026 12:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778763355;
	bh=Kl6rjwD5lss7Ys+vR/4lgns3I6fTme/y3cvYdypPvqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p1duOp4T8umV7HePgFId5/sHuqbkczfEri80dNTnrE7crWaSuljlTUDTA+aL9UGnp
	 hibPH7BQ/w5g5BbLQ5TlWao67A1RBfqs+k+FVP0ercoGDsb7WzsHwwQe1FRv4WhCUY
	 lnZ4VUMQKFRkE6/2zCACzBONI3cxWoNKtTPQoBsS3LeC0AHASJ078Kl38tE74EB7t+
	 PYBpHDekd9JTN+rJptmMQj03S6S/2Tf+Wi+4d8onDVYfvZ6V4F2gg+i8+WWH/w4eUZ
	 7iIxxDbIsjKzpBtKUNROjlrTWQ/no32Ag7Gx+SRMKuJEesWdNy8MaqcMnnBdWyzfoP
	 yJWR02cjHX09A==
Date: Thu, 14 May 2026 14:55:53 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: qcom,ice: Add sa8255p support
Message-ID: <20260514-clever-apricot-goose-acc827@quoll>
References: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
 <20260512033750.3393050-2-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260512033750.3393050-2-linlin.zhang@oss.qualcomm.com>

On Mon, May 11, 2026 at 08:37:48PM -0700, Linlin Zhang wrote:
> On sa8255p, resources such as PHY, clocks, regulators, and resets are
> managed by remote firmware via the SCMI power protocol. As a result, the
> ICE driver cannot directly access clocks and must instead use power-domains
> to request resource configuration.

Then how can it be compatible with qcom,inline-crypto-engine?

> 
> Add the qcom,sa8255p-inline-crypto-engine compatible string and make clocks
> optional for platforms that use power-domains instead.
> 
> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> ---
>  .../crypto/qcom,inline-crypto-engine.yaml     | 27 ++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)

So this is v2? But previous was v6? Look:

b4 diff '20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com'
Looking up https://lore.kernel.org/all/20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com/
Grabbing thread from lore.kernel.org/all/20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com/t.mbox.gz
Checking for older revisions
Grabbing search results from lore.kernel.org
---
Analyzing 8 messages in the thread
Could not find lower series to compare against.


> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index 876bf90ed96e..4e7d9111d0eb 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml

This should go to its own binding file just like in all other
SCMI-variant cases. And if you looked how these other files are done,
you would see my complains already that generic fallback is most likely
wrong.

Otherwise explain me what the generic fallback means here and how is it
supposed to work?

Best regards,
Krzysztof

