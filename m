Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793892583;
	b=T1H1yMSNrDvtqTlcrKrz7z3Hc19tpBsjfSffn8kVxX9b24vEiCwb+7IhAzQt907zC0IA
	 OCSXIYxW9e8X/okweyPATLj7CWXh1V6idK3Apyk1rU/cBn85/UOFmTIiKeLGk2SdGxoQt
	 hQYnnIpZhPKRPTAcsrqEFdiKaNIxl8tkmiyncTSUgiFY47p8khnVr6OiMEHUz/mX/XvF6
	 lVtMCKAj0AXkyZqktjcfwi4EmryjDZkG2Pf410NtNB6zSGgz4YmxNLbm2RFzMKq+B8rLO
	 f02yiqQQAMNXCrFry9kPo6Mh2XQ82u9l3+6CYpsx7w7vAkpBU3kkNOz6QnpU8IFdzaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793892583;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=p8znggyP8TNEWctP7+xxym7mFvo17c6l2+VQxXmXKY4=;
	b=Qd1lnGo7EgMFCyXgOaAytCFHrmzv9vu3PUJpNp9S2lgYU3wz9foLP5FE/q/ZNqVE0Yzq
	 sBc6QoH2aceoaWHxnEOrpn4wCFfYDqLylhFGCSGPOcYnPF2FUZSJ1DNDye0NvzzszQtLm
	 KQvlyQHTj+APbUEEaaOQnjOKrQkLzi3Uvea4ZPLnyzEtX7Cm7VGjA4eZSw9FNqbqmh98G
	 92YNkhjsaPiIzR0TiKZG//6+HY4Q2H5tM1eXEa9FJAEjCxnspzeA+5yEppdsOp6BeXtJM
	 O28r7OpISA7f8h1070UZ5V8wbhDNDLl1eNofPx7yUZww7hdYAfCe8bQRwg61wZ2xXBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LgD4lnvd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F95606D837;
	Thu,  5 Nov 2026 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LgD4lnvd
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793892582;
	b=uvx4spL/f3FEuIbNoFZ7nIaImZ/AzfguTywMPbse0kbT4cBGZTm4NkmVcHkShSye5BPD
	 AWXbGRMDAryKAvLd/UHFrGk9RMRno9P8MYz2mf/cxc6gCXxCIkMJ8J+DGKelAusXAacm6
	 2CbJOba/IuuqTAn7+KQOP5gZRuavoGAQLmANdTp5CToyFEhXQvdDl3w+My5aaglwVEpnF
	 NGyZjlhd4wnKPF7Sj2WYPgpFc/zrBliu53rBZ0e6LOlseNybDEiamzCs06icEUaxQJ+hQ
	 1v7miMKloG6X1DjyBknFYTnNoLCcgKYOITYsFB8Z6hiLpBymqefUCuLIkhh3i3KSn6w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793892582;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=p8znggyP8TNEWctP7+xxym7mFvo17c6l2+VQxXmXKY4=;
	b=lH1ZwIuabbwX82hd1LkwlR7mkhvX8zKbOBrM2MBdCK1W+rlg/tpeb2A2PIS98iXruSHW
	 VKiUp6LBMMFplieP2Lr0LaP6iZfwucAVyiu1ltZi3wvTL86qlHadETdehuw7Ezm9MEhIL
	 n8oee0rwDNN94647HuXxbm4tGxp9m2TX8ivmxvaFA7dnmDZyPRSLzXdcTy8z3txMMtGTE
	 niYo+I/OhgMLc90eKcVdyeZ8ZJEgRbvKKV8ZQsool+4EpZXcLXVg5pBDXqdS/ai69sOUY
	 NiMCwpXv8g8lSXJzF1vAFbn7mmueShkwcPlEoIRX7JS9ShOq0d0gdRs5y4XEGmL/UsA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BEB611F00A16;
	Thu,  5 Nov 2026 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793892582;
	bh=p8znggyP8TNEWctP7+xxym7mFvo17c6l2+VQxXmXKY4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=LgD4lnvdL10fY0x86lflbuz1L36jeK/iyZFFhwSsoorU/zCG5ERdYeH5ExO4wfZFA
	 oCzEzZLp7P6Mk2u3VWLgW1df7XGB+1K1eN7on8U+lxUDK4pNb1Pn2CA5+0EN2oxs+t
	 FEOXuQubHiPyRNd7hRm2wDg/ekPO9Y9zFTcxtsFYXVf1HUOP2wSiiC5168rt165/dm
	 WKM9/wKI1/pofhd1V35iXM1vAHkOdxMj8Jt0Jcu9BLU7MshEtlPHUZPwcPXGo+Tk5y
	 Dka22hgNur4jmqSvQCkifw20YIN1cMNfV3Yv2Ec0mf9QJUAcMDU6MsqE8CBFRjc2sP
	 Xih52RxRA1xGg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 38E6D472DF;
	Thu,  5 Nov 2026 15:29:41 +0000 (UTC)
From: Demeter Barna via B4 Relay <devnull+me.fromdisposition.org@kernel.org>
Date: Thu, 05 Nov 2026 15:29:30 +0000
Subject: [PATCH 1/2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 SM8350
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
Message-Id: <20261105-b4-sm8350-ice-v1-1-f55e6ea8e1ca@fromdisposition.org>
References: <20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org>
In-Reply-To: <20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793892578; l=1578;
 i=me@fromdisposition.org; s=20261012; h=from:subject:message-id;
 bh=u0v3UH3x9W1mbgQNCdGqZvEY20x04vN6GLy9V/2qshY=;
 b=dAdTT0nm4q2Cv6G9ukR940p10kW9bV2xHiVLHSIqZsUscmv2d9Ceo4rs/VMm/ky01MIJtNABd
 BG9sX1axPMKAHc/tc/dffEB7FL9mMpcLIoSVv29UauC40OaFBwRt8J6
X-Developer-Key: i=me@fromdisposition.org; a=ed25519;
 pk=S0QFlGq1BQEaAtPPdAH8YKEOXMeRuSkTgctXuvtU+1Y=
X-Endpoint-Received: by B4 Relay for me@fromdisposition.org/20261012 with
 auth_id=1163
X-Original-From: Demeter Barna <me@fromdisposition.org>
Reply-To: me@fromdisposition.org
Content-Transfer-Encoding: 7bit

From: Demeter Barna <me@fromdisposition.org>

SM8350's UFS host has an inline crypto engine, version 3.2.0, with a
hardware key manager behind it, clocked by the UFS ICE core and AHB
clocks and powered by the UFS PHY GDSC. Document the compatible and
require the power domain and clock names for it, as for SM8450.

Signed-off-by: Demeter Barna <me@fromdisposition.org>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 23bf98c2b..198002f58 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -24,6 +24,7 @@ properties:
           - qcom,sc7180-inline-crypto-engine
           - qcom,sc7280-inline-crypto-engine
           - qcom,shikra-inline-crypto-engine
+          - qcom,sm8350-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine
@@ -74,6 +75,7 @@ allOf:
                 - qcom,sa8775p-inline-crypto-engine
                 - qcom,sc7180-inline-crypto-engine
                 - qcom,sc7280-inline-crypto-engine
+                - qcom,sm8350-inline-crypto-engine
                 - qcom,sm8450-inline-crypto-engine
                 - qcom,sm8550-inline-crypto-engine
                 - qcom,sm8650-inline-crypto-engine

-- 
2.53.0


