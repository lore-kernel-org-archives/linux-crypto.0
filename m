Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF4515530C
	for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 01:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758589405; cv=none; b=H6UCvWez6LN5CO+AIsEdwN6Vs8NQS0NQKOQLnSasfmIhDEd3OBFdD/2QfZRh31kQ0JgYXsKkidcYVUtDGdKvTPZ2qmEd/XptVStsxYjOH7uAzQYFcDk16GTRkges0/Byw8UZEKzbzJyv//KTnRIE8c6AbDin2LyiRsDe+d/oWSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758589405; c=relaxed/simple;
	bh=DCZByZUM218m1aPb4zS7/pNhuVawywi67kLVqSOMqXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LdB5q12M31HVTYVz9hbm+CApreAmq+e5VJlsbNLcJ/bzrnK2XVSWJjMf6NW6j/rP3+FXSPvk2Ou8mXDaDH4XzR4lYFnrR9BzAxNtSZndKbBZU6fGujb92B/0PX+LrZ+ETFTGkM7V1e7Ly2E+renYlrpN13ifKwBRpFIwFuv5rz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kdv3It1p; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kdv3It1p"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758589400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D6aiJooutNvBVVNDeWrLcstPGHxftOncefVM4uKXAjg=;
	b=Kdv3It1pPhzq0eqsGkU09DmOuDe4E4NYNNGg+FZuOpBi4HMKr+tZ0z0GeAwZUrkFh1idI4
	ZaLWz28EUhrFaDpJEpd+xoqI1EfpXpS1wNILHWHOZG8sOQ00GZREEKLRZqFbqF01OJ0Bl+
	ObIl3bigvP7AEcpBH/ZVKHuYcYLwkcU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hifn_795x - replace simple_strtoul with kstrtouint
Date: Tue, 23 Sep 2025 03:03:04 +0200
Message-ID: <20250923010304.1796713-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace simple_strtoul() with the recommended kstrtouint() for parsing
the 'hifn_pll_ref=' module parameter. Unlike simple_strtoul(), which
returns an unsigned long, kstrtouint() converts the string directly to
an unsigned integer and avoids implicit casting.

Check the return value of kstrtouint() and fall back to 66 MHz if
parsing fails. This adds error handling while preserving existing
behavior for valid values, and removes use of the deprecated
simple_strtoul() helper.

Add a space in the log message to correctly format "66 MHz" while we're
at it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/hifn_795x.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 925991526745..edf36f6add52 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -913,11 +913,10 @@ static void hifn_init_pll(struct hifn_device *dev)
 	else
 		pllcfg |= HIFN_PLL_REF_CLK_HBI;
 
-	if (hifn_pll_ref[3] != '\0')
-		freq = simple_strtoul(hifn_pll_ref + 3, NULL, 10);
-	else {
+	if (hifn_pll_ref[3] == '\0' ||
+	    kstrtouint(hifn_pll_ref + 3, 10, &freq)) {
 		freq = 66;
-		dev_info(&dev->pdev->dev, "assuming %uMHz clock speed, override with hifn_pll_ref=%.3s<frequency>\n",
+		dev_info(&dev->pdev->dev, "assuming %u MHz clock speed, override with hifn_pll_ref=%.3s<frequency>\n",
 			 freq, hifn_pll_ref);
 	}
 
-- 
2.51.0

