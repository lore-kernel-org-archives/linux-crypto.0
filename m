Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=152.53.16.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793261865;
	b=O+lt7IF/chHRS00G+Jgz+suhaIRMn2kzmC0MxmtUwpfMpWI8OQy1Xoy73PtFrvanAlYI
	 Od8qJLrBxw/PmhdgrqvQ4EXHEpaFMigRtN3ASgJSB9hwfar/lwsDsuS64PINHvHV6qoVL
	 5Oyw2xPXfzD3U4ok5VII1NfQLvL5bADacPB0kGP4S7w/1HMOWcXNJLhz77G8IQnk3yliR
	 jgYOxDykxC7eXh9rRCoOknns67bUDZiwfFjlgGogR13Tff1w3mTzZsbKFQqt6+F5FBusx
	 nPDsaUOaBXmOk2EUfkb6GF6r5YW7l0m4RJ2tfBJLlWC+6utM15sfWvzul0U6eHyAGPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793261865;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eaLXaFDiT+JD0gpjw1PqvYETYiZWeo+rCz60su31FNE=;
	b=3L8deM+FGcenl9iUr0qEBVjngocVx6v/K6eweZklnLhhFtS/pNkU/yhp2s5zmUJethIy
	 COwz1r2soBEUd03Xwq1YfrCqNFlFrBRKjTALDjEFbs/96btSzCCzB2yX91WkQGTP/LW3d
	 wiy5XWnjtkddtjiNvCVPsDcARBEGucNNco5PulNWJBKkvjtPO9Y8YhXaVkLfErFEXUjR/
	 OXzWIk14UbUMdi0j+R1uo5O6vEXGordI5bs5L1ITB6e0x285d863kYYa1CAmRBnYbhasi
	 c7VZ4uLVXaQOueIn5WZUCv7nxyPBoSGWaI3QahjBvjD8RXX4AL7yzDIrhbr4vXZQMZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kaiser.cx;
	spf=pass smtp.mailfrom=kaiser.cx;
	arc=none smtp.remote-ip=152.53.16.207
Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86396606A31D;
	Thu, 29 Oct 2026 08:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86396606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from ipservice-092-209-185-051.092.209.pools.vodafone-ip.de ([92.209.185.51] helo=nb282.user.codasip.com)
	by akranes.kaiser.cx with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <martin@kaiser.cx>)
	id 1xMLKD-00000001lfj-0vRa;
	Thu, 29 Oct 2026 09:17:29 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Hadar Gat <hadar.gat@arm.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Martin Kaiser <martin@kaiser.cx>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: cctrng - fix usage counter in error path
Date: Thu, 29 Oct 2026 09:15:31 +0100
Message-ID: <20261029081644.1897897-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.43.7
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

If probe fails after the runtime pm usage counter was incremented,
we have to decrement it before we exit.

Remove the cc_trng_pm_fini call in the error path. It calls
pm_runtime_disable before runtime pm is enabled.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
based on sashiko review
https://lore.kernel.org/linux-crypto/67844d9d-d4d4-4026-9549-73589afcc1ff@wanadoo.fr/T/#m1a770f5f9eeed95b48cad7545580aed4fa74e6fa

compile-tested only

 drivers/char/hw_random/cctrng.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 03401ee59a8e..d9492d25ecbb 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -533,9 +533,9 @@ static int cctrng_probe(struct platform_device *pdev)
 	/* registration of the hwrng device */
 	rc = devm_hwrng_register(dev, &drvdata->rng);
 	if (rc) {
-		dev_err(dev, "Could not register hwrng device.\n");
-		cc_trng_pm_fini(drvdata);
-		return rc;
+		pm_runtime_put_noidle(dev);
+		return dev_err_probe(dev, rc,
+				     "Could not register hwrng device: %d\n", rc);
 	}
 
 	/* trigger HW to start generate data */
-- 
2.43.7

