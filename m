Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.122.197.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792881407;
	b=xU4KzExgAasE+A1KlYCn2A73ZEeTigIPkl92/f9hDw5ehWLVQwi6ic/yCpds0DFmLCvk
	 q456Ustnp2o8n5PPWSIIYZ8NymnrA837G2IIN+S+oxLrgXg6WdEwqG1JcbIHpjdKdZEYf
	 2xElzwItt1arIZnylRgDNbXn9K18Fp96A6Z3/ta/MVry9zO2vagfNf3rDMosp/MrC577o
	 xR37yx626PfrsVQqPDFHrW+fwyyprcaSAOEoYfwYiznBL2mp6rLJM29s1IM0N017Oo4Do
	 4/TJpkgMg2oghkUY9uM2znDHE1NuHAbOZoS0DHfBUAcLqE7oJVNNmXQZax6wVc229fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792881407;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Iuu7E7YXnqEoC5jNAcArn+FZajHQizTWifkQmvC8/LE=;
	b=S7zia8JQCZ29zgYfWAsjk9TerSRfOVAvLKCRDpcDpR4Ne0pCoUnus3Ui/o49tyhkKm9Y
	 NpEZxwDwpq0zmF1qhcAE0UFpXO/kAJLQX7T2VLGJhnUSPCpa1iDGBY9lIjcY5+cWfAMK4
	 UAB9dZEhZZxOgLYi8F1syVqjuY/pFEK2V8iAgSGW53MVZJ5mMkoW9n60X6Ah7qw605H50
	 DP38GYb6SA4kGLKSAIWxIL6teOn8jHGNSDnZgdB9g5hKun1GL7BrpTkwVspe6dFlISU0X
	 5tFSe6yckeELWmRzzDd8TmdsI5fmm0x8hh1u+eubOq8eGc+1KyHOqULCRdcdJjbYDUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ptudor.net;
	spf=pass smtp.mailfrom=ptudor.net;
	dkim=pass header.d=ptudor.net header.i=@ptudor.net header.a=rsa-sha256 header.s=epistula202610 header.b="T/idGWVQ";
	arc=none smtp.remote-ip=74.122.197.115
Received: from junia.packetexport.com (unknown [74.122.197.115])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A4333606A31A;
	Sat, 24 Oct 2026 22:36:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4333606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ptudor.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ptudor.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ptudor.net header.i=@ptudor.net header.a=rsa-sha256 header.s=epistula202610 header.b=T/idGWVQ
Received: from junia.packetexport.com (unknown [74.122.197.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by junia.packetexport.com (Postfix) with UTF8SMTPSA id A59EE1AABF;
	Sat, 24 Oct 2026 22:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ptudor.net;
	s=epistula202610; t=1792881405;
	bh=Iuu7E7YXnqEoC5jNAcArn+FZajHQizTWifkQmvC8/LE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=T/idGWVQRL5jnXFcdmBs8SF09dMjQIdeX7K4ht4PcqfWphafe0MAnhOHGMxWkd1V1
	 0L383tZlEcSkNMx0eXu7lY4QUNTXrM/n9AHeQeagtCnB1uTQa89jQfcFxLzVYoV7JV
	 b3uboYXYxTayXU4vhVeKwUKqnd+agTkpfubLlBSAUtUoKeFakSzkeveUddOwCE8RXB
	 01rhQ5K++x1i4K/ljTe5eZiNAQc9CJeMoVUzr0n8CkF7sH14wiVsIzdJFgjdx566rx
	 EIeJ+kRI0/5/C9e6oxIsVQIzwZqkX1oTe9tJxJY4xcN9sFcMH6DOTmfXTDOdS1yCMM
	 knQhkx4b5ib2A==
From: Patrick Tudor <ptudor@ptudor.net>
Date: Sat, 24 Oct 2026 20:18:22 +0000
Subject: [PATCH 1/3] dt-bindings: trivial-devices: add Microchip RNG90
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
Message-Id: <20261024-rng90-submit-v1-v1-1-e265cfabc9af@ptudor.net>
References: <20261024-rng90-submit-v1-v1-0-e265cfabc9af@ptudor.net>
In-Reply-To: <20261024-rng90-submit-v1-v1-0-e265cfabc9af@ptudor.net>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, Patrick Tudor <ptudor@ptudor.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1051; i=ptudor@ptudor.net;
 h=from:subject:message-id; bh=UCNLq53R9kgRaB6gq/pA6UYlxENeqhBoVYe2f00XX1U=;
 b=owEBiQJ2/ZANAwAKAUJsSqIaQAcoAcsmYgBq3RMNQ68mU89DMJgpQpNc7c5tf4RtP517emoAl
 RJ7r4N9/fyJAk8EAAEKADkWIQSMT1jvuUVJAiZ9mz5CbEqiGkAHKAUCat0TDRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwwLDMACgkQQmxKohpAByjo0Q//UtuMZyTGOcSa7VreJPQsAB79icsCLDL
 ZFFp+QHsNp5ldC8JKuoH2hITQBDKaabxqkNvUGK0CP8fqlcZKaEKxjaXnl0gCafnMPrNBGNiv+T
 ZGLmbXfwqAHgFIEQgY8juWh1rW6hD8mK53oRduVgh10ugwa3Nuxky7Bf7tonmrBmMG4NFSH8Hn5
 q4lwl6I53o37OnsE5jXCSJudTFXksZjXd2gppR5IdC2mlzSpqmkCtNO0tnrqwB3x9Hhe/aW23XL
 9njxg9ZJ+Xxqrp/SsOkq0h+fhXjjP0+utZX+Jrag8XDvllFIGNAJCzmuXRxAvxRBzVcma8ayRrk
 x8/bAY7OStY8h217PIaGI54meXj0JOE4irSyZumAsKTchoGkgWZDkCSeoiNYw6Tt1XVIzxTWUOo
 4rBaGJcouIECNQAy5T62NC+9rYE17/4hdsiKphVtgaQEg1LaFLphsK7cJI+LtyGcek7ZLH+E4my
 U3RJbCt/Dpbs3nAKO/tdW01bWf2uPKNLenjZTbtz/HlPSyopxL7No0BQoud9scPTmBUk5xEVEY8
 RMHR8NVoGZr9Of3xXvrwZ7mMHXvtYCoU7UZfSVS9IYYL+j+TKtFuEbi1zFr0qWBusUAo6NoqtgI
 4RsdOwXFTYYdzJSIsxaBrRPYq52DiR9CpYrzKRUdnjYTOVtdlPcM=
X-Developer-Key: i=ptudor@ptudor.net; a=openpgp;
 fpr=8C4F58EFB9454902267D9B3E426C4AA21A400728

Document the Microchip RNG90 I2C cryptographic random number generator.
The device needs only a compatible string and reg property, so the
trivial-devices schema is sufficient.

Signed-off-by: Patrick Tudor <ptudor@ptudor.net>
---
 Documentation/devicetree/bindings/trivial-devices.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/trivial-devices.yaml b/Documentation/devicetree/bindings/trivial-devices.yaml
index 3b7876c5a..503e18b2b 100644
--- a/Documentation/devicetree/bindings/trivial-devices.yaml
+++ b/Documentation/devicetree/bindings/trivial-devices.yaml
@@ -314,6 +314,8 @@ properties:
           - microchip,mcp4019-502
             # Microchip 7-bit Single I2C Digital POT (50k)
           - microchip,mcp4019-503
+            # Microchip RNG90 random number generator
+          - microchip,rng90
             # PWM Fan Speed Controller With Fan Fault Detection
           - microchip,tc654
             # PWM Fan Speed Controller With Fan Fault Detection

-- 
2.56.0

