Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F962914;
	Sun,  9 Mar 2025 00:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741480269; cv=none; b=KT35mMRwvGP5ujGCapTzYaJ7/9F6cKifshEwbvh5lswZ18+Hr0UU7vDxk5as4q0Dow+UUYVgs1iMnRmtKEWd3KzYVtpqA4Ud8NIjeS/iFggeCQmy+d+SFBkAa9h1wLdf0rCzEGr9h0iloki9d+mPqM6pavmtxOtTOvfSfj2keQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741480269; c=relaxed/simple;
	bh=HnksT8mSXFPdsYEwYEbQasBkNVX/yh2ujjHTAjEraco=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=dvhM1Z/2+UFMC3ne4+Vld0oiQnTcCae+TDGJd5yHbQ33dGHktFsqCpJKyIupajWziV7NngJwM1DixgfjoWuXIhf+bbroCGu66B62x3AaPBRBghzOcznwAuzykEsogRr9LIfcSOmwIpQipJKa5eMx3mBRIXE/boXJlnumJvXS8nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com; spf=pass smtp.mailfrom=ethancedwards.com; dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b=sQYvBX8c; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b="sQYvBX8c"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Z9LXy6Tjcz9scd;
	Sun,  9 Mar 2025 01:30:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1741480259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nw5BrMpWLwOkdKLfm5BC4XDDbHFMMDfyo9rI+ZmiLnU=;
	b=sQYvBX8cQof5sXBhThSn//SbOyGSP2UipkdG50cAyiygr8+EkF5bIk2pI/CFs0wMNygbef
	vtX8O5XfMt+SxzCifOihxzZBwOjjlTQ4KlG0AvxQlNFPAOPKg8xi6aVSVVRcTaJ5NkqSKs
	L14Fnd7VkeJgLqE6SO1j9lhvN3GbZEYivTQiHEj5MqgApFXdfQ/dC8+occdUmjb9uy4TM5
	odzw00vTGX6bH3zFaQMDJp0m0t+SHmfw6bYZbtkowvldlRjyWNYtWC0rzdali6DiIy1omy
	7jxgp8tZApggohf7ZlofFh1g4vLJDbZaH1b/9snfGruiCPMjv14zQnYTJur74A==
From: Ethan Carter Edwards <ethan@ethancedwards.com>
Date: Sat, 08 Mar 2025 19:30:52 -0500
Subject: [PATCH] crypto: axis/artpec6: change from kzalloc to kcalloc in
 artpec6_crypto_probe()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250308-artpec6-devm_kcalloc-v1-1-37886eaebd16@ethancedwards.com>
X-B4-Tracking: v=1; b=H4sIADvhzGcC/x3MSQqAMAxA0atI1hZaJ9SriEiMUYNTaUUE8e4Wl
 2/x/wOenbCHOnrA8SVejj3AxBHQjPvESoZgSHSS61SXCt1pmQo18LV1C+G6HqQqNIaoQOrLDEJ
 qHY9y/9umfd8PyZ7im2YAAAA=
X-Change-ID: 20250308-artpec6-devm_kcalloc-9a11cc6acb84
To: Jesper Nilsson <jesper.nilsson@axis.com>, 
 Lars Persson <lars.persson@axis.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-arm-kernel@axis.com, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 Ethan Carter Edwards <ethan@ethancedwards.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1739;
 i=ethan@ethancedwards.com; h=from:subject:message-id;
 bh=HnksT8mSXFPdsYEwYEbQasBkNVX/yh2ujjHTAjEraco=;
 b=LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tCgpvd0o0bkp2QXk4ekFKWGJEOXFoNThlVGp6e
 GhQcXlVeHBKOTVhSnZlVXhEek52UGMzRlc3RGxxdk1lSW9rdWFvCnpPSFcrVy80UDJUU0NqNkgr
 M3M3U2xrWXhMZ1laTVVVV2Y3bktLYzkxSnloc1BPdlN4UE1IRllta0NFTVhKd0MKTUpFSnJZd01
 wMzBaNUthY21zdHJYSGQ3NVZrRDlyTWNHc2ZZOWUxdVBiTHFPTFcxY3Z2TElvYi9EcHZuSG52eg
 phZTlxdzhubkZGaG1mYjl2ZEQvaDg0TFZWdzY5UC9IR2JVSERUVDRBZ1A1Uk9BPT0KPVBpSFAKL
 S0tLS1FTkQgUEdQIE1FU1NBR0UtLS0tLQo=
X-Developer-Key: i=ethan@ethancedwards.com; a=openpgp;
 fpr=2E51F61839D1FA947A7300C234C04305D581DBFE

We are trying to get rid of all multiplications from allocation
functions to prevent potential integer overflows. Here the
multiplication is probably safe, but using kcalloc() is more
appropriate and improves readability. This patch has no effect
on runtime behavior.

Link: https://github.com/KSPP/linux/issues/162 [1]
Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 1c1f57baef0ea9f4ecf7ab39f2c0e9e4327ef568..500b08e42282608348481b759e0b79d25f0b5db0 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2897,13 +2897,13 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 	tasklet_init(&ac->task, artpec6_crypto_task,
 		     (unsigned long)ac);
 
-	ac->pad_buffer = devm_kzalloc(&pdev->dev, 2 * ARTPEC_CACHE_LINE_MAX,
+	ac->pad_buffer = devm_kcalloc(&pdev->dev, 2, ARTPEC_CACHE_LINE_MAX,
 				      GFP_KERNEL);
 	if (!ac->pad_buffer)
 		return -ENOMEM;
 	ac->pad_buffer = PTR_ALIGN(ac->pad_buffer, ARTPEC_CACHE_LINE_MAX);
 
-	ac->zero_buffer = devm_kzalloc(&pdev->dev, 2 * ARTPEC_CACHE_LINE_MAX,
+	ac->zero_buffer = devm_kcalloc(&pdev->dev, 2, ARTPEC_CACHE_LINE_MAX,
 				      GFP_KERNEL);
 	if (!ac->zero_buffer)
 		return -ENOMEM;

---
base-commit: 0a2f889128969dab41861b6e40111aa03dc57014
change-id: 20250308-artpec6-devm_kcalloc-9a11cc6acb84

Best regards,
-- 
Ethan Carter Edwards <ethan@ethancedwards.com>

