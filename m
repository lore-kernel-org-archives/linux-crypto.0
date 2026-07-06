Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEC22F5313
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 17:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783358003; cv=none; b=EQuTuwIOX5yvZYUPX39duDznSiDX/iS7hs0fogvxZNDQ7pLbQikBuLyASBZjdGj1L7nXcRbc9zSyHrWzyrk7vapXl26eQRXnKdXtSbcslIk1Cg+T3qzoc0DsdIU75Y1u9gralinxr/Jvr+TBfMmnK2UZSph2pHEX353HG64NuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783358003; c=relaxed/simple;
	bh=e6qWc66kU+xXDmvKGlirsKMaIbvc1QxArJkePbV+wf4=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BC0YR0O2PmSVhxDS5SW+eaaCgGZPTJgUQtCYrVt65UHB2SdW9nTO5fsajoXxtXiva1URuzFXPP4A5Ryg0WnftvIgBetdyoxx4JDx/2t3KxnhiFTslh0Xrxz2KGC5O3Lp5uKgw961JzEaeFqTf/3NG2puE7dhz58cA/gmRl7LNHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUwJ1iel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUwJ1iel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F5B1F00AC4
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 17:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783358002;
	bh=mpqsxHTdNQuABlRbSrSTXdX6rgBTyZ1QRwkSHQqkvs8=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=aUwJ1ielEp9fKqMoRpbf7+KlsAEkx1ItUo/4tUkjlvyTMT/NZIU/Sfs9aLmDyh/pU
	 dws1njqufItlb4Ts99FlfeGkNaAmFAP7jmRVp9CFbufRmxNFLiMPUqN9dVeeQezBJp
	 27WL0AcS7DIU9vkvih713YctIfY+JQ6QonKsU8skRLVL5z/6z3EAp4XBXQsVEryUe5
	 hYHk5hc4FyjFw8sKxD7w8NaMdcn3Hn0U7HTHVjCh6VhngzLmp3012I/7OCSheRIjY7
	 cDatDpx7O8gSH3cDoY+eDfHzEnfSJhGwNxBdfiyXteiz3VS3hxmUmZKRt3SHYb3CXI
	 wA/fAxKf5T3GA==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39b03d41976so27699821fa.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 10:13:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpnMXi7wgBgCHEPC8eZhej3rweU8eHj2jLbnh//AWx8DKupQIO5885jILzG9iyAwx4S6PfMBQrrWH4s0tA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFAGX0i6iOl8EnweRgbzRxOdxgwlnqmvZJmytJvdJrjc8izaTx
	EbAqquVOIyFS4QSsM5HGsFZJbI4pOOZvmM9AEoewPU007SUBYOWbR/erIhycWyI0txJIy7w78C+
	aPaCodVTfzaV99HXnlfYncwyoTOu/OxGfkzI7mwp28g==
X-Received: by 2002:a05:651c:546:b0:39b:32b3:b31f with SMTP id
 38308e7fff4ca-39c5fd2f09bmr3944171fa.5.1783358001073; Mon, 06 Jul 2026
 10:13:21 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 6 Jul 2026 13:13:19 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 6 Jul 2026 13:13:19 -0400
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260706-busy-grumpy-limpet-c59789@quoll>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260704004408.2303468-1-shengchao.guo@oss.qualcomm.com>
 <b693a9d2-4f1d-4c17-8a63-99c7ac79ed41@oss.qualcomm.com> <20260706-busy-grumpy-limpet-c59789@quoll>
Date: Mon, 6 Jul 2026 13:13:19 -0400
X-Gmail-Original-Message-ID: <CAMRc=Mcg-6XajFJCjTDgGACQ7YLGggw5TEtHv4QMEA=dFLOhTg@mail.gmail.com>
X-Gm-Features: AVVi8Ce2TYLFYmgt3xidz5HirHvkB2ef9twCkJ6HFyZf4MtkHSN7YtUE_SSftbg
Message-ID: <CAMRc=Mcg-6XajFJCjTDgGACQ7YLGggw5TEtHv4QMEA=dFLOhTg@mail.gmail.com>
Subject: Re: [PATCH RESEND] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Nord ICE
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Shawn Guo <shengchao.guo@oss.qualcomm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Dmitry Baryshkov <lumag@kernel.org>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
	Harshal Dev <harshal.dev@oss.qualcomm.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Jul 2026 08:54:22 +0200, Krzysztof Kozlowski <krzk@kernel.org> said:
> On Sun, Jul 05, 2026 at 11:15:45PM +0530, Kuldeep Singh wrote:
>> On 04-07-2026 06:14, Shawn Guo wrote:
>> > Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC.
>> >
>> > Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>> > Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> > Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
>> > ---
>> > It was included in the Nord SA8797P DTS series [1] due to that
>> > the prerequisite changes were picked up by Bjorn for 7.2. Resend it to
>> > Herbert as the dependency is gone now with 7.2-rc1.
>> >
>> > [1] https://lore.kernel.org/all/20260526051300.1669201-1-shengchao.guo@oss.qualcomm.com/
>> >
>> >  .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml   | 2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> > index db895c50e2d2..d690eff2e86d 100644
>> > --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> > +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> > @@ -17,6 +17,7 @@ properties:
>> >            - qcom,hawi-inline-crypto-engine
>> >            - qcom,kaanapali-inline-crypto-engine
>> >            - qcom,milos-inline-crypto-engine
>> > +          - qcom,nord-inline-crypto-engine
>> >            - qcom,qcs8300-inline-crypto-engine
>> >            - qcom,sa8775p-inline-crypto-engine
>> >            - qcom,sc7180-inline-crypto-engine
>> > @@ -63,6 +64,7 @@ allOf:
>> >              enum:
>> >                - qcom,eliza-inline-crypto-engine
>> >                - qcom,milos-inline-crypto-engine
>> > +              - qcom,nord-inline-crypto-engine
>>
>> With below patch, we don't need nord entry here.
>> https://lore.kernel.org/lkml/20260702-b4-shikra_crypto_changse-v2-1-66173f2f28b3@qti.qualcomm.com/
>
> Patch has conflict. This (Nord) should go after above one, with this
> fixed.
>

The other series still hasn't made its way upstream. This one's simple, can we
queue it now and rebase the other one?

Bart
