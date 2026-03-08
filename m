Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66CD1DE2AD
	for <linux-crypto@vger.kernel.org>; Sun,  8 Mar 2026 04:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772945347; cv=none; b=DxF89j2jiPTI+0tQtVaH0YAn/XLnz9XRngLal/JTxagD1HgEw3iI/SqXphFugvbo02QaWYK2riJpBvaFIRifwVF/WUEVqCqm4TTjPQJR/FGSqiN9nNSV5g5R+K/2koGSshNH9oA/vWeNFXV2wOaVfjqYJrL/D5ZdLZxHgt7BVlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772945347; c=relaxed/simple;
	bh=6JeeYlto55tw5It5MGlrPDCoUkfBdv38SDTYHh1eJso=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=pRgHrNfKZd9kzqZMIDDgu9uh32oAv8fa6eR1cOUOOBChi7UkHg1qjqzlYf4CI8PGY/FWYrnDufXC0T/JQYxO/ulqMNRx50Y2ckEu48XoHACMNvucnSd4387GWLAb2f0V3ckXMVnmolTrCJbCw0pzv406k2HejcIlj58ogTWMSEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=fWg22Wd7; arc=none smtp.client-ip=109.224.244.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="fWg22Wd7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1772945337; x=1773204537;
	bh=cYQrsXzgLSd31P1ag5JFJCM7VtyfZCiaqgRdlzE5iGA=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=fWg22Wd7W5nKn0oKbLtIGPqGXFr3DqISOSLuBbX0fXrn8A4hxiRUi7+SxmjAhlRh8
	 2OQVM15eMuPvuQPv0iLsh6Hq9rXklR+s3fJGzDL0gmXn5qKfhYCnyd5JDZPpGEWgpI
	 3O/XCc/GfvaSarEdmfqR6bwWQGj+Xi+Ae7Kp0LIwz1qK3tRx+qYAXuMU6F6EGG3aj+
	 qTFtVkA4d7eJ8o+Qnpi73jaSL2g1lRszlzCd1j/e5vRixxdl28e5LSE9oCkUNCZOIY
	 bgXOtjaPsKTrqyNZ0TkPYB1dNpPEVrAvEcS4O/HFwH7SS/c+tAHbRp/ADtfWFOzsEE
	 NY+8o948cJN6Q==
Date: Sun, 08 Mar 2026 04:48:53 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
From: Alexander Koskovich <AKoskovich@pm.me>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>
Subject: [PATCH 0/2] Enable inline crypto engine on SM8250
Message-ID: <20260307-sm8250-ice-v1-0-a0c987371c62@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: 595daca7817f06859e87b3207bb4b00d1fd4af3d
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add the ICE found on SM8250 to DTS and link it to the UFS node,
and document the compatible used for the inline crypto engine.

Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
---
Alexander Koskovich (2):
      dt-bindings: crypto: ice: Document sm8250 inline crypto engine
      arm64: dts: qcom: sm8250: Add inline crypto engine

 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml    | 1 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi                             | 9 +++++=
++++
 2 files changed, 10 insertions(+)
---
base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
change-id: 20260307-sm8250-ice-800e656d7321

Best regards,
--=20
Alexander Koskovich <akoskovich@pm.me>


