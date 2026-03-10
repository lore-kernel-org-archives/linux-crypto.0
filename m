Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2E33B8D69;
	Tue, 10 Mar 2026 03:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773112380; cv=none; b=lUwmYDn1z9ulXB0QC92UvZ22F2fJ7QGxt2MCUM45IkJXnt3dxDgX7mv09FlLTTPHyyZnXcYjj5xXINlqxlJ5vZnNxTFgbK0A6WJw7Q+7uPyiM7cPGhE87oDO6K0Kq1LJHj6d1eNSxfU/YTo7sG1iGNRVSFGbnQjiRAOJyWruyAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773112380; c=relaxed/simple;
	bh=tisTtLGJmaOakmdvHaPq79g47Z/8EY66GLxvsnj2iAE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hy1e8jmi1Zv2TJQhQRLfvy3btPAfrfA2YF1RXklRko8w1gx8y8A5EHEUXBLDv7uZtO3u+dzJ08ekMnTYa2na9vSyrZ0HVXuFfaBknNAXpqQDp1SInIOSMtMAk7tdtGk0iLLllxgSidAHLmi2P/sPfr8Fb0Fir3oy7Xo0XiyWztc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=doi+cDFV; arc=none smtp.client-ip=109.224.244.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="doi+cDFV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773112378; x=1773371578;
	bh=WTv0FfVezxnSMTKCIL0xb72uuwWAQ2fhL7TOd9c4MKA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=doi+cDFVhMWsm5T07YpisKzwGBwLS+AMpfMIw2mBPk2LKIAcsLxsu4EV9dIsE27xS
	 CF/GU96fE0EdAA4/l2O1xdhbpkb4wVN8s5tVxWwczLuImPmb0WjPMD4upDv9gF0DwY
	 XSbLm6H6qQBlCV12dk4vAavaGyBvwT6GxiqyglylaeOoS0j9bmu2JQuM0xXdY6rFB2
	 G7bJhBJIdUOfhhuWoOqkrTx6PHs5BXJICNigro10obhEe/Z8hMmB8m9KmURZCN7jxm
	 VY9VHMHO9g0/eHe35PGZqDDLIzzF/aOJ2SjfUilvQg4lhtFkxbJYB1K28Wd9xjRDWx
	 gJajAw+BB78UQ==
Date: Tue, 10 Mar 2026 03:12:53 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
From: Alexander Koskovich <akoskovich@pm.me>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>
Subject: [PATCH v3 1/2] dt-bindings: crypto: ice: Document sm8250 inline crypto engine
Message-ID: <20260309-sm8250-ice-v3-1-418bf5c5c042@pm.me>
In-Reply-To: <20260309-sm8250-ice-v3-0-418bf5c5c042@pm.me>
References: <20260309-sm8250-ice-v3-0-418bf5c5c042@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: b8471758f83a588283df9e51475d5c99405d5a3d
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Document the compatible used for the inline crypto engine found on
SM8250.

Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | =
1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-en=
gine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-eng=
ine.yaml
index 061ff718b23d..ccb74ea14ce8 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.ya=
ml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.ya=
ml
@@ -19,6 +19,7 @@ properties:
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
           - qcom,sc7280-inline-crypto-engine
+          - qcom,sm8250-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine

--=20
2.53.0


