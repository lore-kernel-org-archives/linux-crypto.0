Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80F23D5227;
	Mon,  6 Jul 2026 06:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320880; cv=none; b=BUrtX2Qedi1Wk1MHZlrlmkEdaFVJ9z0cPPg8NbFVaaX4v9O5Oc5TVupqedLG9nLvLy/fbIR0Icai9fADBAqhZJO7Rjgq/GvPZaJAbvGYqztpS2VMzMyg7Iq1K+/vRFRl+NwifvM2MXyUW8IXo9ALsnSva9R2gqICL1ULULuKOwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320880; c=relaxed/simple;
	bh=Udqsu6NXNtN6m2Q58o8NG1BYLDR+p/saClDM6K0NL6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lY4B+b55XTTTn0pz/al2RkPc7DZ2lcYyocH0pOx4w/N/DX+jtoeGvZ34EKjAOKwl3Inqk4pRaVA96FXLRTsyu2SSXyWMWci/zyLhk6zSv3GkAr7Ibk6OxTF1i4mtLliHl9Zmkl5sCsSnnJP5/8uSqwgPDp4i9Q5aLxEJmMP3Rrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3Lsx4sT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3Lsx4sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439951F00A3D;
	Mon,  6 Jul 2026 06:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320866;
	bh=mIGZ46OQ8TbJpuW2HOxSd3bMhnJo3TCWU9MeYnhulcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y3Lsx4sTXEj+hV/DhheT8WqDRz231vsXqKL1ZwbvyrgK5kXyhfvIrXbPAojeKeTm8
	 SNeyK+Snw40vJpr59PBG62ow+AySBXnK11J9zXOy0YrOE7P/ppfa9z3/dX6lxfZMGb
	 /zCVnMl12TpsZhCQCfiPuMZXUGChwcCjyc1iyYHTz9BZG47B9EPDx7YQdnGF2euynv
	 lkJ27880r/B1JpB43rUJIZLTuMgUCTvpvu/XbM3YEkzoXb73+m2r/r6FfIHUrNUzeh
	 UCQsUDivuOS9YEfCwPH7YW4LZiTOpZfEwoabUIvHt9yIR15MwdZ8NOvtpK9qUAZUUE
	 PWgcCfkttjLFA==
Date: Mon, 6 Jul 2026 08:54:22 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Shawn Guo <shengchao.guo@oss.qualcomm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Dmitry Baryshkov <lumag@kernel.org>, Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: Re: [PATCH RESEND] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Nord ICE
Message-ID: <20260706-busy-grumpy-limpet-c59789@quoll>
References: <20260704004408.2303468-1-shengchao.guo@oss.qualcomm.com>
 <b693a9d2-4f1d-4c17-8a63-99c7ac79ed41@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b693a9d2-4f1d-4c17-8a63-99c7ac79ed41@oss.qualcomm.com>

On Sun, Jul 05, 2026 at 11:15:45PM +0530, Kuldeep Singh wrote:
> On 04-07-2026 06:14, Shawn Guo wrote:
> > Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC.
> > 
> > Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> > Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> > Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> > ---
> > It was included in the Nord SA8797P DTS series [1] due to that
> > the prerequisite changes were picked up by Bjorn for 7.2. Resend it to
> > Herbert as the dependency is gone now with 7.2-rc1.
> > 
> > [1] https://lore.kernel.org/all/20260526051300.1669201-1-shengchao.guo@oss.qualcomm.com/
> > 
> >  .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml   | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> > index db895c50e2d2..d690eff2e86d 100644
> > --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> > @@ -17,6 +17,7 @@ properties:
> >            - qcom,hawi-inline-crypto-engine
> >            - qcom,kaanapali-inline-crypto-engine
> >            - qcom,milos-inline-crypto-engine
> > +          - qcom,nord-inline-crypto-engine
> >            - qcom,qcs8300-inline-crypto-engine
> >            - qcom,sa8775p-inline-crypto-engine
> >            - qcom,sc7180-inline-crypto-engine
> > @@ -63,6 +64,7 @@ allOf:
> >              enum:
> >                - qcom,eliza-inline-crypto-engine
> >                - qcom,milos-inline-crypto-engine
> > +              - qcom,nord-inline-crypto-engine
> 
> With below patch, we don't need nord entry here.
> https://lore.kernel.org/lkml/20260702-b4-shikra_crypto_changse-v2-1-66173f2f28b3@qti.qualcomm.com/

Patch has conflict. This (Nord) should go after above one, with this
fixed.

> 
> -- 
> Regards
> Kuldeep
> 
