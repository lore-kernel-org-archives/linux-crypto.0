Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793892834;
	b=BdV49bSko7GP+SMBwYHMMXiuzdc330QQiHmRMrKDMKOHHn8tf6/YYSfz0r3aewxsypME
	 hFvHTD/xdzM9feKSgmnwfTzqvtUlleW8b0TyS2gYYinm1hCvh93geuCFIVhA4N20CIXhQ
	 K0uAJaBV+AFbcJNmbLdcLB9Cjx3OPTdP0BurRUg+CfhJYV4CY/90FKztuKXMxDK2DTO58
	 mHf+FFVuxAhKM9i2qiYSNCO8Li/MBix8iUJcPbfb2PthbRPpvqyMMkJ/bTlFpfeRqVtzv
	 TJdquuo3c2Y+AN2PLNHsKc6LnV1sPO115tdyvFlex8Lo5LYIgrdCF/43QpLR5Zhvxtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793892834;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NLJKjEyvSmlxD5pGqZml3zlQsg/e3rwimIqUw9fqZUo=;
	b=ymrOJxeNF3xT5F2IOvngeFpEMIMjsaJbBNJrswg6IgRYPOK9lkbYwmtte0en2bXcmD6s
	 emIlAuF8gMxVaRsTbGPjAr1S0U+0bX/wOKV3Kjh0pxU8WT8TqB8VraawrDtWAO1RsHhlI
	 1EF7b/SYT3vWsgocU2x5fdTiCbcR3Y/jeZh+Gx+9xzI15hPjD/FJFdOpueF02vh1oV8jM
	 sEdgh990H5heoCtoLq2SaQzk5J6eg6pcSxMfCYn+o5mqi70pvHBT9B8n+Wn3sXBGhRVbx
	 /l+U9l6jldk8wVhHlagxZWrs4hKHR3pssQiDqh0hNLv4fvr8SNpaeCatAOioyn9edpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EeeZhdU8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00295606A335;
	Thu,  5 Nov 2026 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EeeZhdU8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55131F00919;
	Thu,  5 Nov 2026 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793892833;
	bh=NLJKjEyvSmlxD5pGqZml3zlQsg/e3rwimIqUw9fqZUo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EeeZhdU8ebHExqiztrJaNJhGb1phacSHrRBOplJ+fQ1OznrQhSoLShLTOnT/rl3J1
	 4Mv4qHenwyWlL0S3F0eBwhAZ34qY3SsgdElTuocC69MZ2KKXdVrbVna4MAVF/huuKL
	 Pi9GYcQ5pUeXnUPZQgA2lLbKGyH8GFXYLhTnVPYYBd4bY1AvqrWnx13ZQqIl35MMdq
	 iYu8zxxbgw5cOkX7bilRDJ9lePmKH8Ifz/JclOtinncnpusgA2RJBqU1BRTUTuEFmo
	 XJwpCOoi9Uho7cDFPSGTADEm8ej8tYjnUMfYovtni7/6txAMq2j564DBHIaA7GUqfH
	 pnmjl36cld9mA==
Message-ID: <sashiko-outbox-199316@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 SM8350
Reply-To: sashiko-reviews@lists.linux.dev
To: "Demeter Barna" <me@fromdisposition.org>, "Abel Vesa" <abelvesa@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Konrad
 Dybcio" <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261105-b4-sm8350-ice-v1-1-f55e6ea8e1ca@fromdisposition.org>
References: <20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org>
 <20261105-b4-sm8350-ice-v1-1-f55e6ea8e1ca@fromdisposition.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 15:33:52 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] dt-bindings: crypto: qcom,inline-crypto-engine: wrong allOf rule=
 for SM8350
--

commit 6fe4d61044ad335d59b80ff5b3c25ea2445e069d
Author: Demeter Barna <me@fromdisposition.org>

dt-bindings: crypto: qcom,inline-crypto-engine: Add SM8350

This commit documents the qcom,sm8350-inline-crypto-engine compatible in the
Qualcomm Inline Crypto Engine DT binding schema.

> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-=
engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-e=
ngine.yaml
> index 23bf98c2b9fa0..198002f582484 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.=
yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.=
yaml

[ ... ]

> @@ -74,6 +75,7 @@ allOf:
>                  - qcom,sa8775p-inline-crypto-engine
>                  - qcom,sc7180-inline-crypto-engine
>                  - qcom,sc7280-inline-crypto-engine
> +                - qcom,sm8350-inline-crypto-engine

[Severity: Medium]
Should qcom,sm8350-inline-crypto-engine be omitted from this allOf list?

The commit message states that this patch requires the power domain and clo=
ck
names for SM8350, However, the allOf block uses a negated condition to exem=
pt
legacy SoCs from requiring power-domains, clock-names, and two clocks:

# Do not extend the list.
# Legacy SoCs are allowed for single clock.
# New SoCs must provide both clocks and power domains.
allOf:
  - if:
      not:
        properties:
          compatible:
            contains:
              enum:
                ...
                - qcom,sm8350-inline-crypto-engine
                ...
    then:
      required:
        - power-domains
        - clock-names
      properties:
        clocks:
          minItems: 2
        clock-names:
          minItems: 2

Adding qcom,sm8350-inline-crypto-engine under the negated if condition caus=
es
dtbs_check to skip the then clause, exempting SM8350 from those requirements
instead of enforcing them.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-b4-sm8350-=
ice-v1-0-f55e6ea8e1ca@fromdisposition.org?part=3D1
