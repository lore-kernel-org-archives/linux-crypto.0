Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B828527A92E
	for <linux-crypto@vger.kernel.org>; Sat, 11 Apr 2026 21:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775941718; cv=none; b=lc2YseR4tTH+pL8B9hw2lae/rVy43sUX9Ud3q6D3ZOeQHUUT5tr4febxW5i/dcVSzsVkT7c/lJ+dE0W/uI8oWuuV+ESmV0/xmqgZyi2Q4RJpVQAjCdtA4diH9rsBKQWDNb6HqfkZ6mH1vWK8eYmq/Ds8AY4VNu7JN7XwdwtRvjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775941718; c=relaxed/simple;
	bh=zMQ5DPxyaZAP9mdRuiSzxouc4zZV2CmQHNoXFWzlSAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NjSxMGuT06aIrM2LQXY5o375hdZK5uRq/dGOZA4BPffc2oNqT+AFZM5zFOY0/QEZrHeu6cQgymbwX7sCVKO1mdk25XyrJpQTCRmLvr7jIKE46kimQ76DyfuHSBbW49XZTwdw+wGnxYBhJcJjp651RrPebS0qg7mR6ltPshUu1a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=nSuC7Av/; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="nSuC7Av/"
Received: (wp-smtpd smtp.wp.pl 37263 invoked from network); 11 Apr 2026 23:08:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1775941706; bh=G78d18gUwzDGZWJYQc0zGO+n5au12WKtHa4u5LXEWtY=;
          h=From:To:Cc:Subject;
          b=nSuC7Av/gDzkNFZjNLrwYAYrDdmm1EI01/zphn8iD6bWkN5lB5jZs4Ta8sPVI7Sh2
           v16kcRL/xTU5a6bd0wNmPTaositKLBar3ozOESkSBn3jEqbWN9tXrlKmcCDIZZOIGn
           n1rT4a8R6LsGu5sHIDk3IiiXd6NXEJRd79XSZnZEWhxdlGzFnOJrCDUYLIJi12aGwi
           Rj/xGLZqwWDduauOxJa5uSgEsN3oQZ0mDFapzbYAOS+pN/chnOq2j+9zQzdDwdVzvI
           jPU7NhrjyC8m7scwFG4UNDohsJB0g4F7d3ZvB4G5zOclORUALxt9ksRVY4PDEA2jal
           uL0puwfrRy20g==
Received: from 83.24.120.84.ipv4.supernova.orange.pl (HELO abajkowski.lan) (olek2@wp.pl@[83.24.120.84])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 11 Apr 2026 23:08:26 +0200
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: ansuelsmth@gmail.com,
	atenart@kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vschagen@icloud.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>,
	Kenneth Kasilag <kenneth@kasilag.me>
Subject: [PATCH] crypto: inside-secure/eip93 - eip93: fix hmac setkey algo selection
Date: Sat, 11 Apr 2026 23:08:17 +0200
Message-ID: <20260411210824.881405-1-olek2@wp.pl>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 8a98e2f4c865804799e2f5e1575fb8c6
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000008 [8duw]                               

eip93_hmac_setkey() allocates a temporary ahash transform for
computing HMAC ipad/opad key material. The allocation uses the
driver-specific cra_driver_name (e.g. "sha256-eip93") but passes
CRYPTO_ALG_ASYNC as the mask, which excludes async algorithms.

Since the EIP93 hash algorithms are the only ones registered
under those driver names and they are inherently async, the
lookup is self-contradictory and always fails with -ENOENT.

When called from the AEAD setkey path, this failure leaves the
SA record partially initialized with zeroed digest fields. A
subsequent crypto operation then dereferences a NULL pointer in
the request context, resulting in a kernel panic:

```
  pc : eip93_aead_handle_result+0xc8c/0x1240 [crypto_hw_eip93]
  lr : eip93_aead_handle_result+0xbec/0x1240 [crypto_hw_eip93]
  sp : ffffffc082feb820
  x29: ffffffc082feb820 x28: ffffff8011043980 x27: 0000000000000000
  x26: 0000000000000000 x25: ffffffc078da0bc8 x24: 0000000091043980
  x23: ffffff8004d59e50 x22: ffffff8004d59410 x21: ffffff8004d593c0
  x20: ffffff8004d593c0 x19: ffffff8004d4f300 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000 x15: 0000007fda7aa498
  x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  x11: 0000000000000000 x10: fffffffff8127a80 x9 : 0000000000000000
  x8 : ffffff8004d4f380 x7 : 0000000000000000 x6 : 000000000000003f
  x5 : 0000000000000040 x4 : 0000000000000008 x3 : 0000000000000009
  x2 : 0000000000000008 x1 : 0000000028000003 x0 : ffffff8004d388c0
  Code: 910142b6 f94012e0 f9002aa0 f90006d3 (f9400740)
```

The reported symbol eip93_aead_handle_result+0xc8c is a
resolution artifact from static functions being merged under
the nearest exported symbol. Decoding the faulting sequence:

```
  910142b6  ADD  X22, X21, #0x50
  f94012e0  LDR  X0, [X23, #0x20]
  f9002aa0  STR  X0, [X21, #0x50]
  f90006d3  STR  X19, [X22, #0x8]
  f9400740  LDR  X0, [X26, #0x8]
```

The faulting LDR at [X26, #0x8] is loading ctx->flags
(offset 8 in eip93_hash_ctx), where ctx has been resolved
to NULL from a partially initialized or unreachable
transform context following the failed setkey.

Fix this by dropping the CRYPTO_ALG_ASYNC mask from the
crypto_alloc_ahash() call. The code already handles async
completion correctly via crypto_wait_req(), so there is no
requirement to restrict the lookup to synchronous algorithms.

Note that hashing a single 64-byte block through the hardware
is likely slower than doing it in software due to the DMA
round-trip overhead, but offloading it may still spare CPU
cycles on the slower embedded cores where this IP is found.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
[Detailed investigation report of this bug]
Signed-off-by: Kenneth Kasilag <kenneth@kasilag.me>
---
 drivers/crypto/inside-secure/eip93/eip93-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index f4ad6beff15e..259714a4ee4d 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -731,7 +731,7 @@ int eip93_hmac_setkey(u32 ctx_flags, const u8 *key, unsigned int keylen,
 		return -EINVAL;
 	}
 
-	ahash_tfm = crypto_alloc_ahash(alg_name, 0, CRYPTO_ALG_ASYNC);
+	ahash_tfm = crypto_alloc_ahash(alg_name, 0, 0);
 	if (IS_ERR(ahash_tfm))
 		return PTR_ERR(ahash_tfm);
 
-- 
2.51.0

