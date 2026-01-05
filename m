Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B332F2D8DC3
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 20:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767645739; cv=none; b=fPkLsxuQINV/tsG5OHocVU1Ifd3byQadh+RDaeH0vfl0G0CUi1cNbu4q2I7y9PLxCL437COuDXwB58oZGo5mpLJQlUMdMnxEV55Y2WAsHXLjIjOAk756EXKMTrE43Kq0yuc6c5kfTjq049i4TnIiBEpeWklxNJH6H1jWeRkIcz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767645739; c=relaxed/simple;
	bh=rZaKdT7REU/v1FQ0Q18s6fICKFuqwy+AacWHDVMQX5Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bfZdbRfNL2PwEq0PZnYwzIx0c/xy8CGjcPV7dw4tTWY45ZAXx7tM8NHj05X3qkLtKI7Q9r35S9uy/H0Zxinc4AtuPYp0uxK3HgePYeVNg0iypaTPvpDGLDXWOB76LZpvpQ7MFGJnaU14fQ9hH+LLxppeK0xaPMHXaqFi/OXZLco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=dYSve3an; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="dYSve3an"
Received: (wp-smtpd smtp.wp.pl 13219 invoked from network); 5 Jan 2026 21:42:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1767645726; bh=Kb2XNoHQRT4LpxJhS8GdX9iYmZhFzAz/9dDLUJhtd98=;
          h=From:To:Subject;
          b=dYSve3ansBCww6paYg83InU6mb26Fll+dqqgTHS+h/rp8StMb685H+9hycHkftoZL
           2tpVEr3toACar8xN9VbGBAc1K/ovzmHySzGqFU1UTD8K3tTzzpQ9BgBSurrxTUbAXH
           Nj4YSgcRbtoq6m7LdSkti754hzMMnNI5UIqI3mTFtksHPpHoBV4cvvBk3BrkpLzRp6
           ig9D5UkloMb0LTEjmZ6dS8K2VPK8sTiapg+ULNEPQ27aGO4EsbrfoRfWkrqhiotjYT
           tJIvotzzgVQnsyZnL6VQNSYO18aHtAs+uFd6DME5Jf1WboqSdJVvU/29K1vS9XWYJh
           Gq3huAvEmgWWA==
Received: from 83.5.241.112.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.241.112])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <benjamin.larsson@genexis.eu>; 5 Jan 2026 21:42:06 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: benjamin.larsson@genexis.eu,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	olek2@wp.pl,
	martin@kaiser.cx,
	ansuelsmth@gmail.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: airoha set rng quality to 900
Date: Mon,  5 Jan 2026 21:41:49 +0100
Message-ID: <20260105204204.2430571-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: ebf74c62ddf4bb8f02e4a410b70d961b
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [IVN0]                               

Airoha uses RAW mode to collect noise from the TRNG. These appear to
be unprocessed oscillations from the tero loop. For this reason, they
do not have a perfect distribution and entropy. Simple noise compression
reduces its size by 9%, so setting the quality to 900 seems reasonable.
The same value is used by the downstream driver.

Compare the size before and after compression:
$ ls -l random_airoha*
-rw-r--r-- 1 aleksander aleksander 76546048 Jan  3 23:43 random_airoha
-rw-rw-r-- 1 aleksander aleksander 69783562 Jan  5 20:23 random_airoha.zip

FIPS test results:
$ cat random_airoha | rngtest -c 10000
rngtest 2.6
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 200000032
rngtest: FIPS 140-2 successes: 0
rngtest: FIPS 140-2 failures: 10000
rngtest: FIPS 140-2(2001-10-10) Monobit: 9957
rngtest: FIPS 140-2(2001-10-10) Poker: 10000
rngtest: FIPS 140-2(2001-10-10) Runs: 10000
rngtest: FIPS 140-2(2001-10-10) Long run: 4249
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=953.674; avg=27698.935; max=19073.486)Mibits/s
rngtest: FIPS tests speed: (min=59.791; avg=298.028; max=328.853)Mibits/s
rngtest: Program run time: 647638 microseconds

In general, these data look like real noise, but with lower entropy
than expected.

Fixes: e53ca8efcc5e ("hwrng: airoha - add support for Airoha EN7581 TRNG")
Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/char/hw_random/airoha-trng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/airoha-trng.c b/drivers/char/hw_random/airoha-trng.c
index 1dbfa9505c21..9a648f6d9fd4 100644
--- a/drivers/char/hw_random/airoha-trng.c
+++ b/drivers/char/hw_random/airoha-trng.c
@@ -212,6 +212,7 @@ static int airoha_trng_probe(struct platform_device *pdev)
 	trng->rng.init = airoha_trng_init;
 	trng->rng.cleanup = airoha_trng_cleanup;
 	trng->rng.read = airoha_trng_read;
+	trng->rng.quality = 900;
 
 	ret = devm_hwrng_register(dev, &trng->rng);
 	if (ret) {
-- 
2.47.3

