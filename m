Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795793087;
	b=3TO2m5BPGJQ97l6fcoBW6n84t0iVJkvVNzb2pUO3ZgHTtrBYg0oqnIQQS5zCnHWfltFc
	 2g+2Q78kLAzP0nGGON0pdANKNKdwMKNjVC1NtLywuLfBQv/sLz9OebYfS703JuZsKQdp+
	 zvSUKc8cSVvUoDXWywNqmQh+e9+fdmUfco7j45HFLThyB7vlHn4gxiNFq8WdLNt4HV8aW
	 w5G+frVT1r8VmGrxVBuDwDItU++F6gSCbUZrVqM429BqtDeaOuKaIdMDM32LN65+hEbYv
	 0dTuEtO+kh7zkm/PEZItceTSAIByxk+R/o9oHSKiYJGYmWncB53PE4s0olpqbAlfR2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795793087;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=oyltaPshj86SQiBIh7ht6WCdgIXYX+7eF9ei2KjJcmc=;
	b=sNMOdBzIFi+fJPGbNZcvrAqZkHYhF7FD/PMJ3Fg0KofzRwUWTAQmvtX7cjBc8h2PvT2d
	 sizP9FOoTyJxB85dzucAveyW9ORxBF7K7QONX4cwiM0dlJT3r+/IpoariJN0JXXM7G7/b
	 ACqHIsqVfKeT6OhaY09kF2XumvgqDcqARxq9N+LS8N07++ZNmBLRci3ggNr26pTVlRK+O
	 Hlf7qiwgz6G19Atn/rpOTmmwF9Rrw94ZLFdubM7a4E25ujTexVTuTeXkxOQajyPdzAT34
	 iGCpBhZV6nfa9EP/mD1M4PkRnu2xz33P9L92LE2FDUCZR59fBGbZxPtS/soNowFqoSA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="dxjQss/i";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0797606A327;
	Fri, 27 Nov 2026 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dxjQss/i
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795793087;
	b=hxn7QJX4IJR6LHhskUeljcd/Bh1YgQi+0nb5+yErOKNRrPnrupYbaOLCjQzA2RMVUdtf
	 iYUEP2eqj5x0Jh6JA7MypSGtyozdCRXi7T26KqqL66rchWhOWdDMYSsWAUiHCz3CvOUGy
	 i789Bz59SDJixfe3t1LnQFXvULaorPnpwo9JGVKnMucVjlkdTtsJN6jnli5p8PyyREQxu
	 kEvjoYWyRXkxvXWAS0eauM2nU+EqqYJGvqkJA1Dtb9ssH1cFC/6l0NDmlGVOKv5vQ8LrL
	 I/jyX8n573ht0TVWNzYX1b8+yK1bJqPPrNOJfmB6jl/jnovF9qY23VZF3W59X7iSnTw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795793087;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=oyltaPshj86SQiBIh7ht6WCdgIXYX+7eF9ei2KjJcmc=;
	b=p9YW03cnPhSp3gPZO/WFipor+rHXz8VG5IGqy/0Rwh85BnuUE+F9bHzgkucsKV91gv4B
	 KUetfSzif9PGoCUXoDUrYWX0g2XUGDn9/AJmnoN7xTu/l06E/oFroXMhhYRIIuSI9kEYQ
	 O6UzDKBh8IG4JST3n91nMFMAfiz/5+OuGU3UJzc2CcjYqw6n10yBsLzPp+QJihIDNMyQQ
	 czjqkMJEUxXfd5LCfb0jwo6zFCjm+aiGKWK//JLi3IJvnsz6YYYYTImNT90fnLL/Inxkn
	 EATp8w5JRHytOkqi1t0aCrM4Z9bAmTxJaIlfVkmcIy64Y5/SP9LLNstkWRhDAuFg/Mw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7DC141F0089A;
	Fri, 27 Nov 2026 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795793087;
	bh=oyltaPshj86SQiBIh7ht6WCdgIXYX+7eF9ei2KjJcmc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dxjQss/iVDkEpaos4EAqNqUI/W5gjHRT7xZJABLMQL10/Jb+8GMixLo2Yjj5TLSyV
	 ZjmM3nBoMxtzSrXnfl8a+uyNY329DaN0rIyo8+HAJ8apNQ8yaiWr/M5DUW4SLKPv7P
	 oPUF+v1UJsrjmQV3QGDqoi4VjXFYjmAbLMo3j7+PsCNf0mVvLCI8yskl7IVeB6N4O8
	 SC/03eylmBt6KHSR101f29Th80WXp8oea2g5T+y33HOOh7iTOpbnmY3KvtbVFJj7Zf
	 spUYoJYIvx/JJ6ZJ7WSACXjuCaTW1B5+LO17Jmhe+KGxTjCz96lpUjmZ3dNTzKwWY4
	 uAfQDzQGccDog==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0AE834D853;
	Fri, 27 Nov 2026 15:24:28 +0000 (UTC)
From: Demeter Barna via B4 Relay <devnull+me.fromdisposition.org@kernel.org>
Date: Fri, 27 Nov 2026 15:24:25 +0000
Subject: [PATCH v3 1/2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
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
Message-Id: <20261127-b4-sm8350-ice-v3-1-39c5b4f562cd@fromdisposition.org>
References: <20261127-b4-sm8350-ice-v3-0-39c5b4f562cd@fromdisposition.org>
In-Reply-To: <20261127-b4-sm8350-ice-v3-0-39c5b4f562cd@fromdisposition.org>
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Demeter Barna <me@fromdisposition.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795793066; l=1295;
 i=me@fromdisposition.org; s=20261012; h=from:subject:message-id;
 bh=jT68xkxxz5/EVqIPjmJKY8VY49FYVLS9vEllgykpp6Y=;
 b=oVptq1TzpVLZzr5nYHObZUa4FX2l/0VGIPaxRY2sW8pLRH7oKRQQ7VoG91ioQ0dQnMGmWtof1
 R8Lz58ciB6KDjtq6vxUhK0Iqslap6MJkw4FOSkQjaL8DtTPwdQYF2Qh
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
clocks and powered by the UFS PHY GDSC. Document the compatible. Being a
new SoC, it stays off the legacy single-clock list, so both clocks and
the power domain are required.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Demeter Barna <me@fromdisposition.org>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index a45a4ac5d..e808af8dd 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -28,6 +28,7 @@ properties:
           - qcom,sc7280-inline-crypto-engine
           - qcom,shikra-inline-crypto-engine
           - qcom,sm8150-inline-crypto-engine
+          - qcom,sm8350-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine

-- 
2.53.0


