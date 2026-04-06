Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090342DB79C;
	Mon,  6 Apr 2026 02:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775441415; cv=none; b=J60lLQ9QUKkHjntIqKK13IPD/KcINMmnqJi702Us9QaNE3jaHQiIufdYgrk9A1pSGE6auQdANiQCZo7bR15fySOYYl0ODOpkRwz9vYtJRceip5oFE8+0zkKoiehtd1vAkU3VDZ0ezRVlJ40Zg/RAB6yyU6sUiChfGuZJ+qsMA+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775441415; c=relaxed/simple;
	bh=M2DzvR2pqqgSNprHop37s8cCZKNrqRkfQSkL/KA9VlE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qgJeTBnUA8fG3UmfXItpCBfoTMyp9jUvTlzjZEznBdmrxJX7KAUBebSdd482YJC+Fe1JLiqTeXMPmaCxu61OHeiJETYGjlR/SWPcgjB3bkXvDKT5g/7WNUJ+hhLqPi5qeN6EOrlkJVnQIQbkrn/KNbVXW/w3xcHFDlavxP7ZosE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=WWX4DVla; arc=none smtp.client-ip=109.224.244.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="WWX4DVla"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1775441412; x=1775700612;
	bh=SzY4W/b23UB8fXq48UN8sr1oOliTCVU3QLXbOpsh2mU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=WWX4DVla5QCjbHhxkivvOUkJ+63R9ItwGsrRiZnCMQW7VJro0aULETJPOFTqkVNyk
	 AXrHlSY81JzX37/8d0E677UFKBMYNBRIqlF/fNn2M2dj3ZhtYPw3IgBVHX+ZnyQouJ
	 oqS0i3nGTa5v/MLOCnGEGHLtEW6y8rJTM977o3sGuJQtSYI/6+P4nhk9OJHb8BAvNj
	 W33y6qGNyFJjmSgDfqEkbrRO4joVeRRmySzS13IOZBVaSPF9c3pYnE/PXHnjGCErLm
	 3mEKwfAq0VzRuJAR2x/UUvPDI6v1KgC/3kXV1P6FXtqM7GVpqR6oAhPriOwZe+un1W
	 IBzRAIeLuTF6Q==
Date: Mon, 06 Apr 2026 02:10:07 +0000
To: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
From: Alexander Koskovich <akoskovich@pm.me>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>
Subject: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Document the Milos crypto engine
Message-ID: <20260405-milos-qce-v1-1-6996fb0b8a9c@pm.me>
In-Reply-To: <20260405-milos-qce-v1-0-6996fb0b8a9c@pm.me>
References: <20260405-milos-qce-v1-0-6996fb0b8a9c@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: 1629e35ed17ef3e4aa90601004f87f3a03c836b5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Document the crypto engine on the Milos platform.

Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Docum=
entation/devicetree/bindings/crypto/qcom-qce.yaml
index 79d5be2548bc..74a121d8b2a5 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -46,6 +46,7 @@ properties:
       - items:
           - enum:
               - qcom,kaanapali-qce
+              - qcom,milos-qce
               - qcom,qcs615-qce
               - qcom,qcs8300-qce
               - qcom,sa8775p-qce

--=20
2.53.0


