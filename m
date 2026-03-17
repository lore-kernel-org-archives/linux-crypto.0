Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D13785C4A
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 08:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773734751; cv=none; b=DqdlmcpSwniwhCSiWWxLibD1bxXMFy0223e0lBF1rmfN9vrQiBLDgY0lWXzEiZW8qlgrk2xSaVn5wSqoijno+0YYlJ8RVD0eMrVXbU/Y3bMMHH6zVv7X/EacYebx1AcJrxCdMuDoD6RIHNVVoqUf39uSw3lxzRNt/YfW7+5cMJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773734751; c=relaxed/simple;
	bh=UoBHFDV6KAty38YDok17qJnO2LdtWNfLIBSm6hgsh8M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sDlWZWVf0rEVjq9TriGSeyGMTq9OwmfGSQkGstfBYUk6wmRksX83UPieGFcsychEBvUJoQAipClZpPr2GkiaxO9PUFLevedmmmhags4u5KDCsYcfxTOoXiPNRYGWZRyHLvqOpJdZaW0Y1RDsHihpBLpo51p1bvIHqVJOAMYOr1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mOFEVgzQ; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mOFEVgzQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773734738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fddtB/Fpq+ZR9FjEtMR4zVfNk8SwKdnpXOvIRqb90N4=;
	b=mOFEVgzQN8xhFn5Hs8cqyrc60Xhu6VJfL75095SgyFIiy84Y+Kw83dPqirSCZDTb1vB5eh
	i8nNZyas24EJcsLX08X2x8mgC/YDT/W3cT4ESZmArD3zTsaDiIRx0OrPF7qn8iARad7gf4
	uy2rnSZwhuZWP4d6dyEeDD5bD2PvJJ4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Krzysztof Kozlowski <krzk@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: s5p-sss - use unregister_{ahashes,skciphers} in probe/remove
Date: Tue, 17 Mar 2026 09:04:52 +0100
Message-ID: <20260317080450.1054742-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2610; i=thorsten.blum@linux.dev; h=from:subject; bh=UoBHFDV6KAty38YDok17qJnO2LdtWNfLIBSm6hgsh8M=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJk7uZVkT3Gt8pqbwq4x6Y5H6hnvVInyzMe7BKN9Lb599 s9PnTSho5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACbic4vhn80krqLN1sVvTjFr VPx/90wmKd/veEzvwT1/Snw+zP61cCsjw7Maawn1xW9kj0+vtn+psLaI735o8sI3Jo7ewhW75+z /xQUA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace multiple for loops with calls to crypto_unregister_ahashes() and
crypto_unregister_skciphers().

If crypto_register_skcipher() fails in s5p_aes_probe(), log the error
directly instead of checking 'i < ARRAY_SIZE(algs)' later.  Also drop
now-unused local index variables.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/s5p-sss.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index eece1ff6c62f..bdda7b39af85 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2131,7 +2131,7 @@ static struct skcipher_alg algs[] = {
 static int s5p_aes_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	int i, j, err;
+	int i, err;
 	const struct samsung_aes_variant *variant;
 	struct s5p_aes_dev *pdata;
 	struct resource *res;
@@ -2237,8 +2237,11 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(algs); i++) {
 		err = crypto_register_skcipher(&algs[i]);
-		if (err)
+		if (err) {
+			dev_err(dev, "can't register '%s': %d\n",
+				algs[i].base.cra_name, err);
 			goto err_algs;
+		}
 	}
 
 	if (pdata->use_hash) {
@@ -2265,20 +2268,12 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	return 0;
 
 err_hash:
-	for (j = hash_i - 1; j >= 0; j--)
-		crypto_unregister_ahash(&algs_sha1_md5_sha256[j]);
-
+	crypto_unregister_ahashes(algs_sha1_md5_sha256, hash_i);
 	tasklet_kill(&pdata->hash_tasklet);
 	res->end -= 0x300;
 
 err_algs:
-	if (i < ARRAY_SIZE(algs))
-		dev_err(dev, "can't register '%s': %d\n", algs[i].base.cra_name,
-			err);
-
-	for (j = 0; j < i; j++)
-		crypto_unregister_skcipher(&algs[j]);
-
+	crypto_unregister_skciphers(algs, i);
 	tasklet_kill(&pdata->tasklet);
 
 err_irq:
@@ -2294,15 +2289,13 @@ static int s5p_aes_probe(struct platform_device *pdev)
 static void s5p_aes_remove(struct platform_device *pdev)
 {
 	struct s5p_aes_dev *pdata = platform_get_drvdata(pdev);
-	int i;
 
-	for (i = 0; i < ARRAY_SIZE(algs); i++)
-		crypto_unregister_skcipher(&algs[i]);
+	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 
 	tasklet_kill(&pdata->tasklet);
 	if (pdata->use_hash) {
-		for (i = ARRAY_SIZE(algs_sha1_md5_sha256) - 1; i >= 0; i--)
-			crypto_unregister_ahash(&algs_sha1_md5_sha256[i]);
+		crypto_unregister_ahashes(algs_sha1_md5_sha256,
+					  ARRAY_SIZE(algs_sha1_md5_sha256));
 
 		pdata->res->end -= 0x300;
 		tasklet_kill(&pdata->hash_tasklet);
