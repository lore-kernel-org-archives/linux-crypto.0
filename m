Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494574D0CF9;
	Fri,  2 Oct 2026 14:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790950818; cv=none; b=QdsJ3trRd5TYUKRuJozJOsw45cmJr/iMR6Jaa9UXZ4lXAIDJDBu3MOmcyL9SN3MFsEs4nXWqKdX+bhEzm/SP0EIjVf2NyNYoNOmg7n67fkDU/6+KhEVzq/18YekCJ0bk7Lt8VHgXiZxNSdlyYWBORKshBwkEg5a5y31vgrXWn4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790950818; c=relaxed/simple;
	bh=ggbz9FX2tgErZnK4914QFVjccv8z/VxHr/twQ2pIaZk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qNTnYa6xxJhQlJ0ihArx/rUSCzOFIDU+1YWsK8xTwPYOYWuGXlbLIVik7TAz4qzoaORqj0bsBCZIMtHTF2/5jBVsjHeX8OEeoSaYiXQYQeH7fI4c/YNwxlrdQvf75qSnwnBjKgwl4byk6knfiu8wWTywAa7Hr0hT4SnEJcQ6MRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dx7YVTg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dx7YVTg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3AC1F00898;
	Fri,  2 Oct 2026 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790950815;
	bh=jtKFI+wm5GDO4FBlr6o6o2Ki/IyY0N1f4S1f5Graqgg=;
	h=From:To:Cc:Subject:Date;
	b=dx7YVTg2sjiUOud3Hj239dSisH6wb8FsUhF5va+Y9anwDF5zwG5MsF8lFoZpjJXFL
	 ZmUbLj1qdD7qfxqZXQqeb1jIaHm8fpqDhPl0eXAs2SdFjyWiO+4Fz8PkeTNOILyXTe
	 vHw8/c4IE4ZO1+FSw1gLfkpBn8N8eQG2++bqX2IBSkLKRRZKboavAe5OFq9Yn2Fmdg
	 ffPnJNkNFz6bLDbE1FS7Vv/sz4l93CVxuNaXWFZdiVPls+K+ahoCQOe001+rO4ht/O
	 rBA0ge7QVDfAE0zv9pBXxPbfcmAtcU+zkhZa5HWLcsyVDRnOU4PgqMaZs4fXoBMZii
	 Pg6+VKlW21xPg==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Kees Cook <kees@kernel.org>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: amd - simplify control flow in amd_rng_mod_init()
Date: Fri,  2 Oct 2026 16:19:51 +0200
Message-ID: <20261002141952.169528-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1687; i=blum@kernel.org; h=from:subject; bh=ggbz9FX2tgErZnK4914QFVjccv8z/VxHr/twQ2pIaZk=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFn793ZUHpP9mR7xrWr9+ahNu1KzpCbpbYpw//Et1/XBx VldTI+EOkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAiarsZGX5dsPVdeJB/jvb/ Ix2Re3K+PE95k2BoGXpNJfXG1mVmdQcY/lfXC0v6/MhTCz/Gvm+9ZM6N8B9rNA8brZSdE37ogUt xNzsA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Replace the goto found statement with a break and check pdev after the
loop. Also consolidate the cleanup paths.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/amd-rng.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index dff80daae587..a4c027dd8df2 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -129,19 +129,15 @@ static int __init amd_rng_mod_init(void)
 {
 	int err;
 	struct pci_dev *pdev = NULL;
-	const struct pci_device_id *ent;
 	u32 pmbase;
 	struct amd768_priv *priv;
 
-	for_each_pci_dev(pdev) {
-		ent = pci_match_id(pci_tbl, pdev);
-		if (ent)
-			goto found;
-	}
-	/* Device not found. */
-	return -ENODEV;
+	for_each_pci_dev(pdev)
+		if (pci_match_id(pci_tbl, pdev))
+			break;
+	if (!pdev)
+		return -ENODEV;
 
-found:
 	err = pci_read_config_dword(pdev, 0x58, &pmbase);
 	if (err) {
 		err = pcibios_err_to_errno(err);
@@ -171,7 +167,7 @@ static int __init amd_rng_mod_init(void)
 	if (!priv->iobase) {
 		pr_err(DRV_NAME "Cannot map ioport\n");
 		err = -EINVAL;
-		goto err_iomap;
+		goto err;
 	}
 
 	amd_rng.priv = (unsigned long)priv;
@@ -182,13 +178,12 @@ static int __init amd_rng_mod_init(void)
 	err = hwrng_register(&amd_rng);
 	if (err) {
 		pr_err(DRV_NAME " registering failed (%d)\n", err);
-		goto err_hwrng;
+		ioport_unmap(priv->iobase);
+		goto err;
 	}
 	return 0;
 
-err_hwrng:
-	ioport_unmap(priv->iobase);
-err_iomap:
+err:
 	release_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 out:
 	kfree(priv);
