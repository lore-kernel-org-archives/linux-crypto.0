Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794232541;
	b=kC5ASAFxTV9+sVDxeZKfUGkI/0oukd8SxvxP7Wrabd+A71TPRpTBKNQMhgg1gEeCng4X
	 wURoauK/ayKsGjQLkiC6sCJlGDG4K4EncFW4AQi9io+j/K2d3ib1jqM95D4BOx7QGXNPu
	 cdsYR/haGXLqfLzcLSx0RSwCw1SbVEyh6ZTpnE+jQ/lMlbVFsYlj1RqrLjS8qmiZiVQYy
	 I74Elvc3eaiPQGeSWfpi8R/Pe1mCOzYpzJ5teh8RKA2C1B5Z8AJM1DZq+tKPWYKDGhgnf
	 LOiHx/0ADMqdYGiXZqW7Jvlo+CJAoJlFzudrlxGZdFCOE4VEfu8xHyCuDsOuTFrlmTA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794232541;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NvgTRAV4d2CeDrS7buIyn4aEgRFl+F7ycAx9h36HrTA=;
	b=SMtc3S1aU45VSB0/OZkiNi3o1EHpedzCL8jbbyZ4e5gUW59SpnprORn2tko7ODvNJY45
	 AuHVTfNohEZOyBpMOfqgfsO4f0Od8jflTCwpXwSXKBN991dk8XuW6vvINBCJSy2MISRif
	 JG7CGE+j922BTrfmpzVP30I4AFHJJiSdQHtM/YGGXrdcEBhGrccEKhTEWVZwc/FU6Fhaj
	 eY++scygRM0xHQSJKwaqPgLUxfCqBr1oV65QqVwL51fms2/AL/mH4L4KiHZMhZmffWMxt
	 Ofq2m2Wb/1BQwH/akbcUMeYwrWi4nFewNTBsiVH7RuZ1BfTUUHF/OYt6p1lraq9vZBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VNQ1R5Iq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A249606A322;
	Mon,  9 Nov 2026 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VNQ1R5Iq
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794232540;
	b=RxTaDsiB6aap/tKqEhJnNXLb2bqt3r1NnKTmW/fJG7Ib6Nn3p7g6l95i1yN1h6Y6Yf2f
	 C6ZOn4lUWqjZRVX6YdI4bdfABrlNV1ysPtu5VXc6Osd1JK2yBnnY7w/N3jM/zNd0UdF+r
	 mA8ElAAi1ZFj0Ga6Ur9OUJD8UcazOSMft9DrN0XENuhz4MhtCTUI0qx+nVFAF/+rqEVcL
	 OZsqJ8YEFCMO2jXFgWNYu5Ghs3ezBBiKThotKFl0ZDul3uCoiJY+JG/2K0M9+QgUUEOQF
	 yKxSDRFMWNgk2n9A/IcCY5DOLBoPRi4gUWMSSz8toILBlKF43oY+qQMspzOpgt8hTfQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794232540;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NvgTRAV4d2CeDrS7buIyn4aEgRFl+F7ycAx9h36HrTA=;
	b=fmLbUK0MI1f1+WhDBG8xPvpfr6/p9QfNobAxGKQ8+Xv+mUI8hXDncvZ6Bc1MKyJxMK42
	 oeTU9+JNHOIcvQneC0kX4hlSLwDKAxZ15bP0kZj1ZvXBfS45+yCt+am+rTkxuDbjKOVKN
	 S9Su8zJOySAjZn7JVujTOTvZ16+48IU5S+oUP3Iff4hJLtFY8tf2Ts+J8g/6PvrHjj3k0
	 CuBOB3jivjhyO+pBpl+S0SBqLD3FST0ucvYeybMH+64uwnVvvar71Lq75Sk5iJZqwlGF3
	 WcpGzjYRiW4Xq6gbQw9lBcDDjQsfuWsHiAtzvnsH5aehhXJ644Q7PLwcJRVAOXfJDwQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 762211F008A1;
	Mon,  9 Nov 2026 13:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794232540;
	bh=NvgTRAV4d2CeDrS7buIyn4aEgRFl+F7ycAx9h36HrTA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VNQ1R5IqlBNzaRkb2nMToEqi87ykFCkEyVuGgPiP+yIUaIdaU8K8chYR/icQp07Vr
	 jXtAB/5dV6/pymW9AHOZm8jW+1/6N6NDIcd1wF4bmIOXsqDwIZ+11c19SNMpjVo8s5
	 lAuvFmGqrVBDuCXDow262cHwKrBee3HCSYUH6k0p4NAnc+azOCk50c8ecg8EGVM0bJ
	 6GlAjMdB9m9vtDaM7BgU5zBr2cTKbBh/eULocWISrt9TgS2s0WZtDZG9SvdGz/AHo1
	 1SjgPcNJYRTWLxqgQBTPwMt0Cq01nnrxKFzWfj+3ukFGnodserirUmHng/ks/2wulc
	 QJ6giRrcnWUww==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E4C25484CD;
	Mon,  9 Nov 2026 13:55:38 +0000 (UTC)
From: Demeter Barna via B4 Relay <devnull+me.fromdisposition.org@kernel.org>
Date: Mon, 09 Nov 2026 13:55:29 +0000
Subject: [PATCH v2 1/2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
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
Message-Id: <20261109-b4-sm8350-ice-v2-1-fd5e84985e90@fromdisposition.org>
References: <20261109-b4-sm8350-ice-v2-0-fd5e84985e90@fromdisposition.org>
In-Reply-To: <20261109-b4-sm8350-ice-v2-0-fd5e84985e90@fromdisposition.org>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794232535; l=1222;
 i=me@fromdisposition.org; s=20261012; h=from:subject:message-id;
 bh=O8H9CShAkj9Ovw7qSKhxVxcXLgvKHLomuYV1vK0dxiU=;
 b=XV+ZqkfTPsOnsrBbgAxWb88AQs2Y8b6HpCata6VLx6NmLxeWanvpCdCQLW5hpbxbYDLiiFm4Q
 FsaaT4Em3M8Awf0aoi/gPY6gpCjMrpyvclMtURYmlt02wAi2vdnUOLV
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

Signed-off-by: Demeter Barna <me@fromdisposition.org>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 23bf98c2b..2423fd846 100644
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

-- 
2.53.0


