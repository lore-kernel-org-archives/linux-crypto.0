Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464FC377A80;
	Tue,  6 Oct 2026 17:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791307606; cv=none; b=nOOH2NxTW0C+dmlot9s0rwxsDFjU9gLegfgaTmCz5ERa9s2EkkMn4wR1GXhSJYVybgG0KNKnmfDX670AJey2nsuRpwHLGSvW/LVbPMFL7Y8jdZFUkG5xBe+CYrfKAaV3g/gGaS38/p3W+oaMCn6gYGk/qimmwutpcdVDb6qwA5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791307606; c=relaxed/simple;
	bh=FodDoie6fWj1l+m/6kbl9hn7MgwpFNPnAUkhfGtlanY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M0qGhURIGYMpfRI1AvuHw8JWkI6LmL5YLLtdZD13AnwfLPAircU/KY7YvQePb59sZZ+TRNNpga0XVbSKgv/GmF7m2vFuOWHx0Ra0g3t8RgDAzQhMlu4ndDnG8QlaDonNqqiBM+66/26Of11HnNLfoJnIoJWNEdBcR24+XwNuBT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jv3AINXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jv3AINXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535AF1F0089B;
	Tue,  6 Oct 2026 17:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791307604;
	bh=IE6O5c7XWLLU6nQOD5z+C8o3JrdyW05AK1pNT+bwlg4=;
	h=From:To:Cc:Subject:Date;
	b=Jv3AINXjsJc1MraatkZZlwWKpqYoqr8gBvG/dIq4C+Kt3Oc74PJQUmbhIUw9QFVRx
	 lKzDCqigl57SmUhI9uIRzVVu+3GG4m/QT1dAFeCHeiewKS88Cud6Prn9efCeLyAItZ
	 fXDpgh2ZkITHCh51ZpbrDmh4IGqzVrGb7p4fZyJJ28jcCh6OhaVp/Ahw5m+pgPkJGu
	 +H5FmeGAU7/riPn5ItIXBh9D0sOnahTks9P7OHGYIquw8pw3zo+IbPUpLTbLSlrKxO
	 5PDxBXiv5qtdJB8WYI2lclg3zWRXN/80x09l7ogaLXl1U3YDOR9Kn5zci+hRQXNUgD
	 QRf19VIKEoLJw==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thorsten Blum <blum@kernel.org>,
	Kees Cook <kees@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: intel - simplify intel_rng_mod_init()
Date: Tue,  6 Oct 2026 19:26:27 +0200
Message-ID: <20261006172628.103594-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2240; i=blum@kernel.org; h=from:subject; bh=FodDoie6fWj1l+m/6kbl9hn7MgwpFNPnAUkhfGtlanY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlH9V2WnMw/Z3xEb7PDovzJUwNZdjpaKZpE1hRMb5jQJ zM/bf/hjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiIx1pGhtbte4I2Sm2RCfSq +/Tw9I/dq3NlQuestJqcKP8zgUPV6Tkjwzv+mPUzPMW52Vwkbh3eXabiahERypam+63kwvtzWvx xvAA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Return errors directly to simplify intel_rng_mod_init().

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index bc4aa9ea1195..b6a50e3e7a6a 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -327,7 +327,7 @@ static int __init intel_init_hw_struct(struct intel_rng_hw *intel_rng_hw,
 
 static int __init intel_rng_mod_init(void)
 {
-	int err = -ENODEV;
+	int err;
 	int i;
 	struct pci_dev *dev = NULL;
 	void __iomem *mem;
@@ -339,7 +339,7 @@ static int __init intel_rng_mod_init(void)
 				     NULL);
 
 	if (!dev)
-		goto out; /* Device not found. */
+		return -ENODEV;
 
 	if (no_fwh_detect < 0) {
 		pci_dev_put(dev);
@@ -349,8 +349,7 @@ static int __init intel_rng_mod_init(void)
 	intel_rng_hw = kmalloc_obj(*intel_rng_hw);
 	if (!intel_rng_hw) {
 		pci_dev_put(dev);
-		err = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	err = intel_init_hw_struct(intel_rng_hw, dev);
@@ -359,7 +358,7 @@ static int __init intel_rng_mod_init(void)
 		kfree(intel_rng_hw);
 		if (err == -ENODEV)
 			goto fwh_done;
-		goto out;
+		return err;
 	}
 
 	/*
@@ -375,21 +374,19 @@ static int __init intel_rng_mod_init(void)
 	iounmap(intel_rng_hw->mem);
 	kfree(intel_rng_hw);
 	if (err)
-		goto out;
+		return err;
 
 fwh_done:
-	err = -ENOMEM;
 	mem = ioremap(INTEL_RNG_ADDR, INTEL_RNG_ADDR_LEN);
 	if (!mem)
-		goto out;
+		return -ENOMEM;
 	intel_rng.priv = (unsigned long)mem;
 
 	/* Check for Random Number Generator */
-	err = -ENODEV;
 	hw_status = hwstatus_get(mem);
 	if ((hw_status & INTEL_RNG_PRESENT) == 0) {
 		iounmap(mem);
-		goto out;
+		return -ENODEV;
 	}
 
 	pr_info("Intel 82802 RNG detected\n");
@@ -398,10 +395,10 @@ static int __init intel_rng_mod_init(void)
 		pr_err(PFX "RNG registering failed (%d)\n",
 		       err);
 		iounmap(mem);
+		return err;
 	}
-out:
-	return err;
 
+	return 0;
 }
 
 static void __exit intel_rng_mod_exit(void)

base-commit: 4c3ca7c8c152278332590bfd3df1b0f086364759
