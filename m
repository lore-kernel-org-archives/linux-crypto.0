Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793892583;
	b=WADyo/Gu/QV/H65Y9sTJQKf7sh/+MER2o4KTsILohpxj05k3YfsHUmUnLAIXv4xvAWvX
	 Z+nMdpbiUv6wN4Rja7haazxmK48wSUZafT8mJycENVj/Nghht4tB00st/haaFCicGY5ek
	 ouSq0vqCHNQsM7adtTf1Y9TKQWBMFpL/tA2Nkjs7oRudsv3ENuSRxInuhIR+Te4PJWbWe
	 Q/lKhNp8N8v652LXu7aivcdzMlt1kYytM5u9Pt2535McqqNy4TnUMM10oVVJftvVk3Yim
	 S2ebZyOXtT4Ww2wTY/kjBpgnce2xvooQhnhkhjtGV4urNIYh+B7eD2yifTJ9bDZYOVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793892583;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=bizg8nXSrF877Om64bX/m79m7mPaW/iGKz1ARahMme4=;
	b=z6ofG+xXSEtjRKcdEv7PlOaSq31X1yRbh3kvXLw2qUdunKZUeMGxkmZwnizX4+GzZvUn
	 pCWwQ1CPXi8pIWCHlb37/HWhm13DBNOvIhqmWqPEE1y1RVPi+o6IExlSD2OYWAa47GfaW
	 M2OwO53xuGdrZaq1KGG1AMIq7j4FbIEV/RuryIygVuY3wZR4nBSZfBiCwDjoXcT+bodnU
	 eKRVK0ybNu2K9rGr2bQ60Ttta5d3Gbm1JrEbQSuRjTLZaq8hJgLJq0BH6G3O3InSgaDef
	 hXkB3pVeBl2pGdFkT+dSupVp6CHHGFcRFO0O0gbnJcLXSTizLG8qiri/JTR8W+TTCDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HywIhXfg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1F7606D80A;
	Thu,  5 Nov 2026 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HywIhXfg
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793892582;
	b=gkj7+mO3SGT2LX+jODHlIsjpnPLF0iy2WCLpYsCkixxQoy1TvamgMQdzY5VvnYpX+yRE
	 7VwNPdS27KnkAQBJSL8sUiTc+ht+NENfDIN0OTNhTCcYRd/dK1vOkjZSR9Q1yD0pCGE8u
	 RIw/CXL54Cv9RS+LMmvfaO/7BaFh8fpfwU6/OfCI6fEj+Ug4PI4OmfiZ5OfUHVNzV6aCc
	 /7PACSWwatJVHf5QT36ix4phWLcKIfBqpCP0ZJ0mQmp+SHLbr1zg7img4QdLld0Mb5wvM
	 s9+/y/EYMLkY1P57zo7jAQG/fc2YV71wOzeMFOMZyECnSjEGH8+e9lBGmzgr74D59nQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793892582;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=bizg8nXSrF877Om64bX/m79m7mPaW/iGKz1ARahMme4=;
	b=FPWIkTxnA2uAItRxC0tfwzcrBbbNwhm9lbzJwgrtjwOaZthbHxKcxOsaLxUtrCxlVWpQ
	 gHJqBpvSaDYeug/xBClV8sRBnMBRYj8xS5Sn2/ynO1K9jNQ+c/r3F+9kRaeI7+0nqb5RJ
	 UAsk33K7rHRr8GTettzj8Nczryboz8HeQfXMDt0Vu018MEXXNbpNrlq9hTDqZM/SLfcbZ
	 U6DKk9SBfq7HsWyMakxgY1rt36xUPd8a3HeUHORkkhtA2VsVMBCYqlYhsdc8VcscTv3zX
	 14a8yt3h9vpWe+yOXELLVkig2wf1dPeErEA/xxWqpY+8BVXVhK/ffwZ48DEHaA3SQ8A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BE8741F00A15;
	Thu,  5 Nov 2026 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793892582;
	bh=bizg8nXSrF877Om64bX/m79m7mPaW/iGKz1ARahMme4=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=HywIhXfgYRoggo+52lGjkmJUxL0eVwZVh9S+f3uP4VA39QTSgy8jgRc9Oylz49d2Y
	 6dzaXruy94t2hB7N/zHK/MwTBcNOPQN4eBIQKjasIatBpK4UJqVywXzUG0De04AoP3
	 Dc0BoZ3Sdo4iNPSKGFwrFBRfOcGacgO+Aur4IJ7S5PkkPEp4OoJDYbb3tLkm6U+mID
	 Ysqg1MrCErSWbo0IhkzyTNv8S7NUZYm0VKbAa4TJ2XL81hrTXfE7/FjGlvKW+4sPHP
	 EakdQ1fVnQbFNnac+0asaEQ997HDPOECrRcYtKUtJ7BYmn0HFoJoX/rC69tSRsSLDl
	 EmNF8E2DanuCQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 23F3D472EE;
	Thu,  5 Nov 2026 15:29:41 +0000 (UTC)
From: Demeter Barna via B4 Relay <devnull+me.fromdisposition.org@kernel.org>
Subject: [PATCH 0/2] arm64: dts: qcom: sm8350: Add the inline crypto engine
Date: Thu, 05 Nov 2026 15:29:29 +0000
Message-Id: <20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBG4avIrB1IohHbq0gXGn91CrUlU0UQ7
 25al9/ivZ0UUaB0z3aKWEXlPSfYPKMwtfMIlj6ZnHGVtcZzV7K+6sIblgDG0Palx61wlaPUfCI
 G2f6/5nFZl+6J8P1N6DhOIthlk3EAAAA=
X-Change-ID: 20261105-b4-sm8350-ice-efad45e93262
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Demeter Barna <me@fromdisposition.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793892578; l=1321;
 i=me@fromdisposition.org; s=20261012; h=from:subject:message-id;
 bh=suhANv7bOMWCMhQ8xWZ6gPrL/h1+3YpM+oSA0xcQSBk=;
 b=Lit8UbrinNlhQJDYfrDII+oLqibmjgAWVno/4aiYqq5Nz9BX7KLkgZUl0bztXoJBkV5NCQPRs
 LQzq48Aekn2BdADzCUZsBQY5LTfjNg8Gd+bP+qKQvy6LHUJ4o3pR1gh
X-Developer-Key: i=me@fromdisposition.org; a=ed25519;
 pk=S0QFlGq1BQEaAtPPdAH8YKEOXMeRuSkTgctXuvtU+1Y=
X-Endpoint-Received: by B4 Relay for me@fromdisposition.org/20261012 with
 auth_id=1163
X-Original-From: Demeter Barna <me@fromdisposition.org>
Reply-To: me@fromdisposition.org

SM8350 has an inline crypto engine (ICE v3.2.0) next to its UFS host,
but sm8350.dtsi does not describe it, so ufs-qcom runs without inline
encryption. Add the compatible to the binding and the node to
sm8350.dtsi, as on SM8450.

The region covers the engine (0x1d88000, 0x8000) and its key manager
(0x1d90000, 0x9000), as in Qualcomm's SM8350 device tree; the clocks and
the power domain are those of SM8450. The TrustZone offers the raw-key
SCM calls but not GENERATE/PREPARE/IMPORT_ICE_KEY, so qcom-ice uses raw
keys.

Tested on a Razer Edge 5G with fscrypt v2 on ext4: "AES-256-XTS using
blk-crypto (native)", and files written with and without inlinecrypt
read back correctly either way. dtbs_check is clean for all SM8350
boards.

Signed-off-by: Demeter Barna <me@fromdisposition.org>
---
Demeter Barna (2):
      dt-bindings: crypto: qcom,inline-crypto-engine: Add SM8350
      arm64: dts: qcom: sm8350: Add the inline crypto engine

 .../bindings/crypto/qcom,inline-crypto-engine.yaml          |  2 ++
 arch/arm64/boot/dts/qcom/sm8350.dtsi                        | 13 +++++++++++++
 2 files changed, 15 insertions(+)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261105-b4-sm8350-ice-efad45e93262

Best regards,
--  
Demeter Barna <me@fromdisposition.org>


