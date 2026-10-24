Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.122.197.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792881244;
	b=G6W+d/Rkzy4+8HEf7VyCW8QmFAMiZHUWGmDy+WHoBlczsEwceOF0Eq21vbdTWcEuB7HK
	 4tyvNdzXsp537j4OyoO1Rw/CS/lbpFwXPLlqaJMvYgYZlLLbA4Rw0giOKk01CMBPmeqYj
	 v0voRHNO5wP4C5Q8dJMXnxssoG2FlPJz0wyjaDXnwrI1kQ4d/lqF5USwkj/LssKi8EdPv
	 8ngWTIee01DNxbY+V8kicxk3kCQbrNqcJ4ZZTlzWfXWs1O0QIQMPiITP7yyoJ/qyEGucq
	 NAaCcafkhT0cyoReE4JnAwcHz5gKfBUAn3CLvogBNhrAVpoAYO0fh/5VW/Xf04iK0Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792881244;
	h=DMARC-Filter:Received:DKIM-Signature:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=9FKFT4GV4wTq0oAbEu1SN4x45q9hHNfBb4/xX4YHDwU=;
	b=gbOvu8x4LxopiMLaQa7g/C/crl8K3hjKSxUClsWTzqYJBNpxsdPTg3mU7C4nXwSoKaqq
	 9b7W4wImj7XmOWTa1pi9tjFEh3SkIjYSg3WBXT/+fxiPyI6omCDbJUO0frR4n4DIX50Dn
	 tMnqIi3ayFNLnFa9nMtT34gYZF3TSQ7Jjogs6ItgbZNlA4sZLbWGxRnfFfapwYoKLX59P
	 GM9bfFapfW41Jx3wAm+DGgLzkSTuFUVrla7TyuyXB1npmN8UvwAO90v27jjqcctcWztfg
	 5YimQpgve1W1aNFE12m77Zi+wfrhDanjTKfolr/19gQGxq8lG5643Eqmwg2Y/LRw0+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ptudor.net;
	spf=pass smtp.mailfrom=ptudor.net;
	dkim=pass header.d=ptudor.net header.i=@ptudor.net header.a=rsa-sha256 header.s=epistula202610 header.b=u9v3+Y3Q;
	arc=none smtp.remote-ip=74.122.197.115
Received: from junia.packetexport.com (unknown [74.122.197.115])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3210C606A31B;
	Sat, 24 Oct 2026 22:34:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3210C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ptudor.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ptudor.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ptudor.net header.i=@ptudor.net header.a=rsa-sha256 header.s=epistula202610 header.b=u9v3+Y3Q
Received: from junia.packetexport.com (unknown [74.122.197.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by junia.packetexport.com (Postfix) with UTF8SMTPSA id C282F1A8F4;
	Sat, 24 Oct 2026 22:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ptudor.net;
	s=epistula202610; t=1792881235;
	bh=9FKFT4GV4wTq0oAbEu1SN4x45q9hHNfBb4/xX4YHDwU=;
	h=From:Subject:Date:To:Cc:From;
	b=u9v3+Y3QBsILPCGvEueHvFsak4yg9Dczx5FmhPGDdQoSl7MtIyh0jgq0c+VjQFjLj
	 fnoMrxM7UDHeMgJ/Vzr6BYGaC8SX5Kqfaz8liF2GBEVXnmRt1dDMl3DtXyhpVUjlso
	 Ze4UPyolYeEl6P4le2qhIPLejcFwmwqItQa02kV8bqdEGFodHHdm2yhYqVkRa2iayh
	 aTrFHfxVnzXQ1f4AfDoHmBSIjD+PRPPFayvCHRhzji7UHs5dDnEr5W05fx9d4KzzSo
	 6cMB8AdIvy9SWnIYtUxco67YyPiP0epwDWfLAh02OV9fDPsDRi2HOX8Gf8kZvraSO7
	 o+uhEwCtgc6FA==
From: Patrick Tudor <ptudor@ptudor.net>
Subject: [PATCH 0/3] hwrng: add Microchip RNG90 support
Date: Sat, 24 Oct 2026 20:18:21 +0000
Message-Id: <20261024-rng90-submit-v1-v1-0-e265cfabc9af@ptudor.net>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MwQ6CMAyA4VchPdvYTYXoqxAP26yjB4ZpkZAQ3
 p3p8Tv8/wbGKmzwaDZQXsRkKhXu1EAaQsmM8qoGT7515K+oJd8J7RtHmXFx2NEtXVJHwbkWavV
 Rfsv6P/bP6hiMMWooafh9JpUs5TwGm1lh3w9KZ9rwgQAAAA==
X-Change-ID: 20261024-rng90-submit-v1-705c3c70a116
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, Patrick Tudor <ptudor@ptudor.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2135; i=ptudor@ptudor.net;
 h=from:subject:message-id; bh=BEsr2UYznJ1f7avw8c0N4xKRrhZmnDrB3+ETAb7s0/s=;
 b=owEBiQJ2/ZANAwAKAUJsSqIaQAcoAcsmYgBq3RLK+lNbgUC3/1zv7/0dgEdwSwWMpc8Ud/5k7
 qZEHeWl0f2JAk8EAAEKADkWIQSMT1jvuUVJAiZ9mz5CbEqiGkAHKAUCat0SyhsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwwLDMACgkQQmxKohpAByjwChAAhyDHVKor77hPmp1XLylHBpeYFRyxaXb
 QuhuOENv42ht8J0PkLbhTc00mpDm3D9ZQuOmXoECyiNTOrxXWRI8BHbamAFUrFq+dgo82d+Pztf
 RmtUPvRegzEMVn1X+Mj6P8HLKryLb4Hdz+w3imzUpFvhoWMkba5qgz7n+Q3QX5Y7+BvzufD32KP
 36+UjMwIV1Jx+7HAaZOmZqGCVZjGgP3+sK4xWqxW9ssxsTwZQ34I1HvRGKCccLBQELESkdlyJMn
 2Kzmv2TsSHeRDavya6sYrVCgvfA6MciMaIa5Tiu3YU+Yy/qfE/KFPcEdoW5nzytFRY2MkSgiXfD
 DxSfjJmJzEOo/rh4hR+sdkAkNNw4JRArbDQm9OQBaO/cVgabfjYL0KejRIA/sgyv78Qeirvvxb/
 YNxdnpIP+7kDZ4tvqjIsqsvApPvp+yJUcKuxS+ms6y1jyt6RmSKpXKLD6pYXa1/MYbzZ5ytiMZn
 XHSbNojXzVhEWwt3ohj0wLDD8XS/QDTcr/dAOV0ygTIauX9yuZvj9ccWQfWGYIrFwVkeCP8DeYT
 apYGkS1X6XjcXFSMVimAJ0gBrvJLjHqQH9quSw3VNd6XZf2WkROkvc4OllkqGFrheAS0tHiw5/g
 91m/vgD1zCsCbRjoplVIYHiNM7v1uezlg+J/zUWyHguovB16/vns=
X-Developer-Key: i=ptudor@ptudor.net; a=openpgp;
 fpr=8C4F58EFB9454902267D9B3E426C4AA21A400728

The Microchip RNG90 is an I2C cryptographic random number generator at
the fixed 0x40 address. It combines a physical noise source with a
SHA-256 Hash_DRBG and returns a 256-bit result for each Random command.
The device performs runtime health tests and self-tests before releasing
output.

This series documents the compatible, adds the hwrng driver, and adds a
KUnit suite using a scripted I2C adapter. The driver wakes and identifies
the part, validates framing and CRCs, polls within data-sheet deadlines,
recovers once from transport or synchronization failures, and withholds
output after any device verdict or malformed response.

The data sheet specifies 128-bit security strength for each 256-bit
result, but that does not establish entropy per output bit. The driver
therefore starts at the hwrng framework's minimum nonzero quality of 1.
An administrator can raise rng_quality after qualifying the complete
platform and its operating conditions.

Validation against the base commit:

  - dt_binding_check for trivial-devices.yaml
  - full x86_64 defconfig build and a separate W=1 module rebuild
  - UML KUnit: 32 tests passed

The driver was also exercised on physical RNG90 hardware through the
in-tree hid-cp2112 adapter: three 500-block streams, hot unplug/replug,
unbind/rebind, and S3 suspend/resume completed without driver errors.

Signed-off-by: Patrick Tudor <ptudor@ptudor.net>
---
Patrick Tudor (3):
      dt-bindings: trivial-devices: add Microchip RNG90
      hwrng: add Microchip RNG90 driver
      hwrng: rng90: add KUnit tests

 .../devicetree/bindings/trivial-devices.yaml       |   2 +
 drivers/char/hw_random/Kconfig                     |  26 +
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/rng90-kunit.c               | 820 +++++++++++++++++++++
 drivers/char/hw_random/rng90.c                     | 555 ++++++++++++++
 5 files changed, 1404 insertions(+)
---
base-commit: 5b0764a53235d3c77e1ed674e836e1b3fe1a4b1f
change-id: 20261024-rng90-submit-v1-705c3c70a116

Best regards,
-- 
Patrick Tudor <ptudor@ptudor.net>

