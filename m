Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.12.242.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792782903;
	b=OMBAM2v/f07qBvnkJrtY1hkIMGIVDZXzAXO7SSmpm8ep8id64oPOvKuVhBNcm3E9MPpV
	 E3f2AYqxwS9+9PYA9QTWavNBIBCJpmIqF4QqYPS76pT4D6h3i5sGEzVrq15NyyS3aqD9x
	 afpdtAp9m7jpOeB8z8pjSxbJAXP4QXLrL6EOWN0DaZU/9s1bT9Fm5aM/Uu6Iq2gtQcL0Q
	 I1ZCC+3bVqE6nySSkMRwncPmXSSHBbbIamBvgG451H+QK+G5qapKKzdNfk6ctY6BpGYLD
	 v6M1cj0ylqd3TdDa419OsSCDzjTbssN07WR/9mtD4Go0Xj5f08ZGDS1+JBwvs3gkvUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792782903;
	h=DMARC-Filter:Received:DKIM-Signature:X-ME-Helo:X-ME-Auth:X-ME-Date:
	 X-ME-IP:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7BrCigeCjVwa7nKZbgZrEsTzrqdNK1TrLNI+3mkpPI8=;
	b=hpkjsyiPQBHWRmfKo2QHu4SS27WyoNqFLbh6vV+o4bsgViIcSzL+Y+TPxZCCUP57/vSS
	 PvSSEf5ClIN+vqkYtbEx9uOpk+dnFnmo020WUsC4HyOpaJ1mencdslbf6RP3F7WQ4wnaP
	 I2lazIpHFMFYvIbOyrdjjx44H5tX91FbpRJsFGbvmxkyubBWmsMPvM222B9IeyrnoUq/+
	 SvG1e87Cl7+YM2gFWI++CvGJKw3hbrGZbYkwtGuaFEDd/sLldyLw4ekpFj6csG37uT9Ke
	 bQHIdNLyBF+b2YReD72akEyVoeq3CpkRaxt28bZQt5XOvfu0irvq3q5BO1k5embE9Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wanadoo.fr;
	spf=pass smtp.mailfrom=wanadoo.fr;
	dkim=pass header.d=wanadoo.fr header.i=@wanadoo.fr header.a=rsa-sha256 header.s=t20230301 header.b=lajV+Pi4;
	arc=none smtp.remote-ip=80.12.242.16
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105A6606A31A;
	Fri, 23 Oct 2026 19:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 105A6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wanadoo.fr header.i=@wanadoo.fr header.a=rsa-sha256 header.s=t20230301 header.b=lajV+Pi4
Received: from fedora.home ([IPv6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e])
	by smtp.orange.fr with ESMTPSA
	id KKj3xmY0OmYgsKKj4xUYS7; Fri, 23 Oct 2026 21:14:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1792782894;
	bh=7BrCigeCjVwa7nKZbgZrEsTzrqdNK1TrLNI+3mkpPI8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=lajV+Pi4GD9JUUY2BDrdh2GU7M1v0L5cBgXOTTyrVkPvIKESiw3ZzTRH6nYxjPc+w
	 aGqv81RpjDUqLZwq6Im7MSAFkL/e3bLvvJryIGbP1wZq0xf53fcSKX4Oiehxh4CkaD
	 bpoI5L2ybcXqcw+LJP2onuQcQt3ZkxS0lcd5sCFqRUwls91tDgW0ow0iAXEdCkzfxO
	 KySHn0L9IekD4YFxlA8zi8K6zIY2TD/A6miCzuuFLj9MiqH1pcL9jJfP9vC/4YHZ7L
	 +odjPT6MWLHOl6xDY2S0Z1XtE0NjSaTDs2/XrhpBgD1XzgHapsUDXNqLuo9PszfTLP
	 sIgLPNCn31u3A==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 23 Oct 2026 21:14:54 +0200
X-ME-IP: 2a01:cb10:785:b00:26fb:aefb:6cd2:db0e
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Hadar Gat <hadar.gat@arm.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Kaiser <martin@kaiser.cx>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] hwrng: cctrng - Fix an error handling path in cctrng_probe
Date: Fri, 23 Oct 2026 21:14:46 +0200
Message-ID: <b66b3df3d178a04b35690d0eb36dee409a95aa5d.1792782868.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If an error occurs after a successful cc_trng_pm_init() call, it must be
undone by a corresponding cc_trng_pm_fini() call.

The commit in Fixes has erroneously updated the error handling path if
cc_trng_pm_get() fails.

Fixes: 8bcd96893848 ("hwrng: cctrng - let devres enable the clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.

This patch also undo the clean-up done by commit a7ea3d63e897 ("hwrng:
cctrng - simplify cctrng_probe()"). Keeping an error path makes sense with
2 users. But if preferred, the missing cc_trng_pm_fini() could also be
added after the test for errors in cc_trng_pm_get().
---
 drivers/char/hw_random/cctrng.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 03401ee59a8e..608b3321c05a 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -524,8 +524,10 @@ static int cctrng_probe(struct platform_device *pdev)
 
 	/* increment device's usage counter */
 	rc = cc_trng_pm_get(dev);
-	if (rc)
-		return dev_err_probe(dev, rc, "cc_trng_pm_get returned %x\n", rc);
+	if (rc) {
+		dev_err_probe(dev, rc, "cc_trng_pm_get returned %x\n", rc);
+		goto post_pm_err;
+	}
 
 	/* set pending_hw to verify that HW won't be triggered from read */
 	atomic_set(&drvdata->pending_hw, 1);
@@ -534,8 +536,7 @@ static int cctrng_probe(struct platform_device *pdev)
 	rc = devm_hwrng_register(dev, &drvdata->rng);
 	if (rc) {
 		dev_err(dev, "Could not register hwrng device.\n");
-		cc_trng_pm_fini(drvdata);
-		return rc;
+		goto post_pm_err;
 	}
 
 	/* trigger HW to start generate data */
@@ -548,6 +549,11 @@ static int cctrng_probe(struct platform_device *pdev)
 	dev_info(dev, "ARM cctrng device initialized\n");
 
 	return 0;
+
+post_pm_err:
+	cc_trng_pm_fini(drvdata);
+
+	return rc;
 }
 
 static void cctrng_remove(struct platform_device *pdev)
-- 
2.56.0

