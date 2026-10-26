Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793043906;
	b=vIHqEy7DZRYF6/UzDs0TFetYV5/+C+me7yKUW5GkDQVr5J9FEj4qCqL/89kwYQjMhGrJ
	 Ij2F2ydPxTi1xq+dBUvxe4ZS3dc5/cFzqV5POCmWi2qpqx9gxbpu7EhnVvyDxyzKogBy3
	 XRT3ptEaLMr8dUxxvqnf5SQjt97jhwcNrCj0UAXR8D4LSS3tRW6lPLDhxYA9hJl3Dv8dE
	 H0VGUHr4/9oSTg5VVU5Bw8UwaoZ2fh7EqlEEDl2FosZkrA+q1UNunZgSk2V3PTZaNZUXx
	 bPMKHxMJz3neBmBu/5m6GeDuZVUbKt2bHW7ZhKH7NL8AENPSkQZy6FDLYsZGNBW6ImA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793043906;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=WRB3kp2zfg/I1dGl0HrgzRa2RnMe1q9qDNgnwDkdTP0=;
	b=sY85piaUElhCfvBlyxr2VHWQHRsqTR3NVZKK0OaodJhntlXrTCc7bnLHW2l68zVOfDa1
	 jBW8yOiD4cAZpyo4gm44k1au8CGoFH2vq2PRnatjobNSYgUWdjYpyfvtXnzJUisLfdHoW
	 SOcJtEi4GR69yFOxZuAduvwHbPr+ijHYMybsIi1uDeBhJZ+oSewTl0E4JYnQzFvZnUwKe
	 bJum7HLHoB/WncaaGKM1IYeGR2n2VZCeEAt/zflHLL+nL5SUdEqXUUMXGTvMGitJvbCGc
	 cotZyicQGj1s7TbXPwUlVp3CWY60tN3RfQzlBqEeSDshfCCMszxpfKJuvSOyOhkYcXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e3SwdKx8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A87F606A331;
	Mon, 26 Oct 2026 19:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e3SwdKx8
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793043905;
	b=NhS24vPNcL4PrthnOZe7O1RJ/16qfLX4aiuuThMV9cOcIdBiRrp+p60sFEMqenI85x/h
	 UNC4sZS0fotRFR2XJGStvVfU/oQ7uS0+uMjv1EmB2QgWi0Ir0aD+DsEiqpy9KXNBclhXs
	 ArMwUWQUNhcW3DPrkI7oqgbHPzLGNqAHADuI5EL69IRWnlMPFheo/wmdbiWd5OecnALPx
	 0yPUHoIwh8UoTvHF63FmgWd8xRLEdHPVFgG/j/oeM/aY0XsDdx2sIAd1N/4YFoP9RHFR4
	 s8D9nAC1rN/mEFKgNwYrQV4/VEcyhCqHTeCdQjLFcuKkTHi+RSl6zC2r5zUPBAhpSpg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793043905;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=WRB3kp2zfg/I1dGl0HrgzRa2RnMe1q9qDNgnwDkdTP0=;
	b=zGuOpeAMkYt8wuW0aU4TzkXLOzf7Is2LE2Y08PHpFObn1mXLOSZp04NODiCnFXoRxy+y
	 xMumoc8ZD/zliPXwFOugsJuvietPW7qdQPTOtx0Fca9ZdoLhVK3PX0lC+G1jFahYkjtbA
	 Ii8QpsWWOMSmpJ5GqlVi7R6TOEGLU1CsA1KUJrCDgvnDD4CQ0pEp61krquizzYdT0iGuV
	 78PuQ+7bEpToUW4ZeeRcY1EXGAXdYfyP6Uv+CzmWCy1lPJWHAJY0OEA1ztxQau2y8eDEU
	 ns2TpM6P8fLhk72bc2jF5GUBP2k9+xlysF7XiOB+fQ1ISV6ZcKt0Fal1ldIZQXR6VjQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F2A741F031E2;
	Mon, 26 Oct 2026 19:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793043905;
	bh=WRB3kp2zfg/I1dGl0HrgzRa2RnMe1q9qDNgnwDkdTP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=e3SwdKx8PedB78cH24lTdQOC/FPzv9JMXLRDHS09X6yogDa8BEROGmUBzvbE6hh9O
	 OAK+g6o5P5+vZR8ky07XXy2SsLxFMO9gLZIAMh/7ZezHAGan6lmKjXKoRItwLWlMOv
	 gfWjt92oozLiXxUpwhv5b/1hVHISA7X5onWIEm8n2WmA3KxjnetW9+w9l9WoJNzFru
	 lb4Wsa1IJFLUM4rVEzNXQeezZSBqA7XvvyR5QCo101HvIZdtSj/2qmxNGI+RJwrqOG
	 7NRK8trZFp/XqVYTFJkH5Oc25ynyVFUkeF4+GjFz9VZMP9Xtof5N2iB20cV1CkS0yn
	 i0CuZ/+VFk2Nw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2EBC844E81;
	Mon, 26 Oct 2026 19:45:03 +0000 (UTC)
From: Alex Ousherovitch via B4 Relay <devnull+aousherovitch.rambus.com@kernel.org>
Date: Mon, 26 Oct 2026 12:45:01 -0700
Subject: [PATCH v7 5/5] MAINTAINERS: add Rambus CryptoManager Hub (CMH)
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
Message-Id: <20261026-cmh-b4-a-v7-v7-5-500a83faf500@rambus.com>
References: <20261026-cmh-b4-a-v7-v7-0-500a83faf500@rambus.com>
In-Reply-To: <20261026-cmh-b4-a-v7-v7-0-500a83faf500@rambus.com>
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>, 
 Joel Wittenauer <Joel.Wittenauer@cryptography.com>, 
 Thi Nguyen <thin@rambus.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 Alex Ousherovitch <aousherovitch@rambus.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793043902; l=1310;
 i=aousherovitch@rambus.com; s=20261026; h=from:subject:message-id;
 bh=dgueTQsK9wIwgcKIQgHilK9irQV6fL/qq/pSePk/7A4=;
 b=q/GuuokYWIbpwqksRzqM3X32r7VqWkn4efeSgdkdwBn6ropn0yPBy5LfoFXISxNtq0gZ7imvY
 rEviUpwk5t5Ds9ytvDqNztVdA5O4bKsc+sfLleBU9Q71NcYDtRKd7Bp
X-Developer-Key: i=aousherovitch@rambus.com; a=ed25519;
 pk=ECFtTdQUPAolK+qGZ6v7Xm3sRf7rnM7wxpTeFzbqpmA=
X-Endpoint-Received: by B4 Relay for aousherovitch@rambus.com/20261026 with
 auth_id=1330
X-Original-From: Alex Ousherovitch <aousherovitch@rambus.com>
Reply-To: aousherovitch@rambus.com
Content-Transfer-Encoding: 7bit

From: Alex Ousherovitch <aousherovitch@rambus.com>

Add MAINTAINERS entry for the Rambus CryptoManager Hub (CMH) hardware
crypto accelerator driver under drivers/crypto/cmh/.

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3bcdcaa9b92..a803cd2a3c9a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22760,6 +22760,19 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/ralink/
 
+RAMBUS CRYPTOMANAGER HUB (CMH) HARDWARE CRYPTO ACCELERATOR
+M:	Alex Ousherovitch <aousherovitch@rambus.com>
+M:	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
+R:	Joel Wittenauer <Joel.Wittenauer@cryptography.com>
+R:	Thi Nguyen <thin@rambus.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	Documentation/ABI/testing/debugfs-driver-cmh
+F:	Documentation/ABI/testing/sysfs-driver-cmh
+F:	Documentation/crypto/device_drivers/cmh.rst
+F:	Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
+F:	drivers/crypto/cmh/
+
 RAMDISK RAM BLOCK DEVICE DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
 S:	Maintained

-- 
2.43.7


