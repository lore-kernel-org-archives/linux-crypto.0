Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793779281;
	b=tPb2Ylbi+833IgxXmwndPiO/BIeGOnlKfYIaGz4Cg0TJOltgQ6b+rDlQwl0I8UBdFkcc
	 59YbE8MJcHPyoJVNXnlRR+87C0v1SSaMRkuden3bgOOOwQ/c19jAmqD0RKKY+2xqyP5OD
	 SOTKxfaupFvf0Wz8dlK18oSfx7BGWKSFfmE31r3udV5j9YP6bVFzcwaoeIt/qJyjJE7Jm
	 6ETYjKXftnHh07pcxpWJIplAHDyjh3tyP9nssQBWnT2hWpqxVfAUM3fsnmmURFbqZvvv0
	 ZIWgftI/8IdHs80d6tCZCA7KtjC/XSFqM52r233LfMS7zxa/bbNTw5VR/nlBB7ZuaTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779281;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RehpVaIZJLMsniKIOhAwB3jjiUyRPkFw2fOFW68uz3w=;
	b=C6wJw+3vEYPkWp1zefpTTxWHFgcIQ8mSsdNjL2K2K6yfBSaG1iUfkXEdLHvgGFua1bB/
	 rJ0pem8gqjMlFH3KUQ91aEApy7In0fQFSgow6NPKubdmhfVU4ZfwlUwjjj+3Wd11WWt+8
	 BZxBSLxko8kf7KfQVGT/m9ZlG7FWFT2qbYa+saS/fkElEtruMx1x+qMHJMthuKQsZjIv0
	 hd0gfkWw+QRpMwyxEShcU1O9KxBgUypJkB+pz5zNclhD5WEZF2fSAWdolB6RWs4oNuAsS
	 5GnjV1u4zZEOgv2fwazob7E6mTNuRyQd2ppzMu+QA5BkHwWwpf/wjSaNJlZvlGdg5YA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PyfNDeBX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544ED606A332;
	Wed,  4 Nov 2026 08:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PyfNDeBX
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793779281;
	b=H+z8awfonZEPLRu9xXdZvPw8CYUn4ifJRkYgo9HB+ajXoDwBHwywNLCwlZ8ZLrFKluWG
	 EF3kMZn2GvrCjrtKh77Y//ip1wOUTMHtnZfu1PW2EKNMU8zipARQ1yy9KwuA0Fklvz1kh
	 c8C7hbhzkwNOAeVxaVNZn41euS7VSk1eKVsSLF/XQM/dhiPNVNUAFTVSHkAdlN+qs0zsm
	 QmWGuPaIoIeqtRwcd6yNqSNCpHOdbv7Fz6szbbV6lQvQ/hNUwdXtpjiFmgHctwAB2I0Zl
	 +0b3MlfZfLOkPMrsVNMAyPMtkMLCuX3UrLcw1yOhfNI0pmOmV4mVb3SQ6nHsdmzrTjw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793779281;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RehpVaIZJLMsniKIOhAwB3jjiUyRPkFw2fOFW68uz3w=;
	b=L0bJuRma+Kj4jZkVEzKhtnsz7kyMVPKChAD0SX9K+rnX3E2dZLo/kFIhfbAFgW8Hs1KT
	 6WmBm28o1x19enXycEUGUfYupJ8Q+1gXc7Gy8h0qSBGv6KBq8152CGwbuPs5dx+/qvIgj
	 jfvGqxeY6pvgW6NoORfUvp8t8Q14IsrRYILzCYakURaPyCTLUh2kaC0KxEoNPLOgP/OQb
	 TrOGpwIt6BjO77/TUQukOQY/d7DNmQqJro1i+JRJ9x8hPctOmires/depItP03wtfe43A
	 m3rJ45uJWATgLJHDzvOG8EBRfvAbjXe3mQf+uhFF9pRVKcTVQPjK17yenajm1tAL+kQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BF4D71F00919;
	Wed,  4 Nov 2026 08:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779281;
	bh=RehpVaIZJLMsniKIOhAwB3jjiUyRPkFw2fOFW68uz3w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PyfNDeBX6GaPi4NZ9aro9VXAwyIXFUpnnomshpn3i+bmY0qG7h5xKjz7i6oze3C4w
	 wH4Pun22/BggRNWQ/lAf7VyoZvDr7SkUSxE0kWVa/AdU59jwTfMpYd5LX6ksu3rEsj
	 qeTOI6QvE/xmbx3bVliUEt3ZZbV0QmpTw7/KUIFLbN84SQEDXgv97hS/EFoBqLgHiW
	 ip3FvIw+CNyxUQhbcseHIEu7TMPmoNBc9u0Fmkecl0JVepjowJIHlNiPTKXkPSj/mS
	 345Q6g/nCYzTRMkR2n5CbqBlF4yhX/ew6EWPYnoTQJKvR8sDaleZCnVI1P2KXB5vZk
	 fM1HNgmYDRhzw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2EA3F46D35;
	Wed,  4 Nov 2026 08:01:19 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Date: Wed, 04 Nov 2026 08:00:36 +0000
Subject: [PATCH 1/2] dt-bindings: crypto: ice: Document sm8150 inline
 crypto engine
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
Message-Id: <20261104-sm8150-ice-rfc-v1-1-5737b6c2ecc0@andrewgigena.dev>
References: <20261104-sm8150-ice-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev>
In-Reply-To: <20261104-sm8150-ice-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev>
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andrew Gigena <mail@andrewgigena.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793779278; l=988;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=F8s437Z3nIDoc5R/gC/zrE3eZUnjXTfM1bgguwb+UAI=;
 b=BTfnKy2Z7jzAO1sNnD/q0Nf3QCFO8wX6vW0MNokD8vLe1NONdcB5onHz2uAym5Y/lEgAnwzW+
 c1FUbeNLgUqAHB7X71Pd3+QatGaWadO65qcx5OkQCdKpnySowt3iPRL
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev
Content-Transfer-Encoding: 7bit

From: Andrew Gigena <mail@andrewgigena.dev>

Document the compatible used for the inline crypto engine found on
SM8150.

Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 23bf98c2b9fa..1918f18fe8b1 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -23,6 +23,7 @@ properties:
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
           - qcom,sc7280-inline-crypto-engine
+          - qcom,sm8150-inline-crypto-engine
           - qcom,shikra-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine

-- 
2.56.0


