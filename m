Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795793078;
	b=XwBzIMymH8ZAl18ULJ0BN4MN8LJSQASGMtNssDxc4B0VOiWWA1XOz9ox/SzRLv9qmUVo
	 vD26HvFmJZe8pjUpQoyuCwwPwo8IzyiOIh6/bJeQg5APhOrLhlbG5tsan3mHiEz6Kwbu7
	 BQhl4whvFadQpp8sWHcW20LfattOxtNyICFErji9xZtA+S1KvisbP3H3mKzlaJwlxEakf
	 nMUhr2Nzr7ekfCs2D0M6nfzxl3Hulvr+RS3pH2bCvScPSLYBXqyqhc7b5SCJmYYGH/NqZ
	 VPBdXu2TI5Cfnpg0giiP2QWuDfNh3NIpc5EMYrRYwYQ16Ah6SpU1uM8hT/i+k8WXRUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795793078;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=X5ZoxuDWqqPHcNvCyxZzW/2wl6Aa1nM8Vpbw9e+lcW0=;
	b=Fc4I9b1TIy306LjjzKJzrKxF/xv+ME+hf4cd6Gm1jL+eeFiSldi/FaHYIuvaA9zVexlg
	 vQ9zyNvIj03JMyxq9rW7E9TpJf4pSzMAqZHnVAQv9xhDwRjXOatYFiN4QK23A8TdeOoXH
	 EujXPEN1oLXmjbCKL1Nzin0pcDjeY+IJK1htF1bOre8acRed9VRaN+uGNsTZpUlXSar5j
	 tKdrsPhc+qMUyegeuSBz6ZMf354EOtV65k5BeHCZTmGTkwkrmYW4g8nCCEnbeOgzf5rdh
	 mJI2pRboA+KJ4m/KhU96l8oipsJZflwdsiBL1aZRv02LSTIgEAgO1OqGGWNjcE3j22A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CLfbfw5V;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D587B606A31E;
	Fri, 27 Nov 2026 15:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CLfbfw5V
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795793078;
	b=ehrNQEfjYWQjPqWNMzcAR1iaeyIrA6EUqfcVpguTWDs8c6kvKPrxGP/pUyffvzLh3JKv
	 3izfciIT1fybY7vPYo0VXgXGklWAXVQ6BfDQqFQtK3Zl/lkiu1ovYQlaoW4VPp/umA/34
	 ZzuyYHHewGRAj690FsatjCdlpkP4xOs7q1cknm3e0S7wG/eONDfCG1NRxYpKTWk+LuSbQ
	 VTKAjoDSsl75muNo4sk15DlOu/yvrm63PJBpQra4b4ViJvwjDYmcHGOYNc37y9aoj9D23
	 t9iY6C8l/CFtyU7xJ0fnXmzqIZZpGLyLNWlp5XKZ1Tq9HNxKOaD2xOT7EFJgN6QyFlw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795793078;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=X5ZoxuDWqqPHcNvCyxZzW/2wl6Aa1nM8Vpbw9e+lcW0=;
	b=F6ol6kkyMRGtP4nMOS8rL4clw6MwSav/h4bTIWq3yFAvEZlFiEHty66R1SJ1FuG25TVY
	 ztvXuvIzEFmPsE9qw/xIcrqDiuIv6YkzFUpgHNZZCvs23gANX1vyE4HyFOl9sWq9iVx91
	 R3nzqvQ9iABoELeiwpOGprjUIMT4Ia0brIDO5Kr5Ok/UYtMDqj7ew5dSxmcF6qOmrtL1d
	 KOZotnz8DCdqNFG0QN6qzy5GIpW/hD/bgOTRKOsgZwPGr6DP0Foho2mjr7dlwCDRozoLe
	 40fe7eLD4sPxtjcRriTHQYV1KrcgRa8IKZ2JPdyBrSIAhoBX+9f80TQehWdxd59lcCw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 685A21F00893;
	Fri, 27 Nov 2026 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795793078;
	bh=X5ZoxuDWqqPHcNvCyxZzW/2wl6Aa1nM8Vpbw9e+lcW0=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=CLfbfw5V+P0nIcBF5oRxKIsGUzSQFxpzzjG01j+fMKwn7Qed3gL5E6fd3cExv+bRI
	 v6yUCNobnaD3M3x3TLGhbp3lw4SpQBigjxZNL7np0IGGWJ3mRpQlzx8FSc+yEf1KFL
	 tHHjLi2zTquPhmRrGhXSDn88r/DA+3AxSJkXxJjgzJiWietJwnJi/p6nvKJWVATB8n
	 cFwfIQFIXk3qsKh9W2NN4WhJjVIPKd7UFu5xS1H0INTffAWC/SAEQSa4RFOKVwSULr
	 JJ3AWc2Ferza5eMFj71YI64MDUTQ2hMIHBLV4BLmh7Owqt2ucdHOF63NlBYE4n1ZUl
	 fQJe3sDWTrVAQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DC7A84B85E;
	Fri, 27 Nov 2026 15:24:27 +0000 (UTC)
From: Demeter Barna via B4 Relay <devnull+me.fromdisposition.org@kernel.org>
Subject: [PATCH v3 0/2] arm64: dts: qcom: sm8350: Add the inline crypto
 engine
Date: Fri, 27 Nov 2026 15:24:24 +0000
Message-Id: <20261127-b4-sm8350-ice-v3-0-39c5b4f562cd@fromdisposition.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3XOQQ6CMBAF0KuQrq1pCyXFlfcwLko7hTGBkhaJh
 nB3W9wYo8uf/Hl/VhIhIERyKlYSYMGIfkyhPBTE9HrsgKJNmQgmas6ZpG1F46BKySgaoOC0rSQ
 0pagFSTdTAIeP3btc3zne2xuYOSO50WOcfXjugwvPvX/2wimjTkqoQSvgRp9d8IPFOPmIc/rz6
 ENH8soiPp3m2xHZsRJU1aj0K/vtbNv2ApYFu5QOAQAA
X-Change-ID: 20261105-b4-sm8350-ice-efad45e93262
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Demeter Barna <me@fromdisposition.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
 Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795793066; l=1656;
 i=me@fromdisposition.org; s=20261012; h=from:subject:message-id;
 bh=kWxMQLo7ohxE4T9YHeCEZxmxXgiJKDWlketpNvOdZy0=;
 b=C7JhKntAjq/5VgGVzZy5b05GWrq+4akbyF0Oc/ezuiRaVtUVs8XNLfvBJXH4Xtik6jz3NWzXN
 7mGwodTD32kCZq2xXADVS6t24qhRTMe0G3PuMRlAChPBUEObFDjVLQY
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

The TrustZone offers the raw-key SCM calls but not
GENERATE/PREPARE/IMPORT_ICE_KEY, so qcom-ice uses raw keys.

Tested on a Razer Edge 5G with fscrypt v2 on ext4: "AES-256-XTS using
blk-crypto (native)", and files written with and without inlinecrypt
read back correctly either way. dtbs_check is clean for all SM8350
boards.

Signed-off-by: Demeter Barna <me@fromdisposition.org>
---
Changes in v3:
- dts: region size 0x18000.
- Rebased on next-20261126.
- Picked up the Reviewed-by tags.
- Link to v2: https://patch.msgid.link/20261109-b4-sm8350-ice-v2-0-fd5e84985e90@fromdisposition.org

Changes in v2:
- dt-bindings: drop SM8350 from the legacy single-clock list. It was
  added there by mistake; SM8350 does not need the exemption, its node
  has both clocks and the power domain.
- Link to v1: https://patch.msgid.link/20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org

---
Demeter Barna (2):
      dt-bindings: crypto: qcom,inline-crypto-engine: Add SM8350
      arm64: dts: qcom: sm8350: Add the inline crypto engine

 .../bindings/crypto/qcom,inline-crypto-engine.yaml          |  1 +
 arch/arm64/boot/dts/qcom/sm8350.dtsi                        | 13 +++++++++++++
 2 files changed, 14 insertions(+)
---
base-commit: a9c48428cbd8d96b26f92631d0db6f8519c5fcc5
change-id: 20261105-b4-sm8350-ice-efad45e93262

Best regards,
--  
Demeter Barna <me@fromdisposition.org>


