Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729EBB658
	for <linux-crypto@vger.kernel.org>; Sun,  6 Oct 2024 01:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728177907; cv=none; b=uhqVMTKN2L7f6S1inles/M1dpSrQh4NN0igJb8yh0G/6gSIMUdayV0bo0NqecQ5/0BeVXqzXko108duHHGWZa6ZgFKnLyJ2461FNoFZBa8NWhrQDTwPhtVT+TU01YpcIuw7InI0jGyj0FV11a12vc7BuGH/bmFwgIoZtgLqDP9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728177907; c=relaxed/simple;
	bh=NgyMGWuVDsqMcX0gVOE8CfmF1/5YjkBAWpWdPpnj+XE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NKEvbMQBkktC5HIdujuGFzR4Cr2dZ9B0JPpjKirr/y19XHlDY6z9pIRK/8vBgqTpKTz5+jjTd2YWbUizMVghen5M0ggBq2SvecwuaVgmwMMayg0VZ2GiQVONUGGieVRM84n1FGLOw1SLLRa7uyCoZqhkYXjE65mHHYzfabXH4gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IS/sHfCi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IS/sHfCi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mvwxycEr4/t/SbF/TdQVO0NHl7aAFTAoRfuDpBeWsMI=; b=IS/sHfCi25UJrj5iQA5gNx2VLa
	phdJlE9vQQkPLvaFmOE4RnKlbq6afoLydQpHREvfMHyYQO7AOTBR64uoF9UIt0f9g5h73uAEzNSbC
	O4A13IAxpjbynDHy6vqA3LjgmmqwvJJOyQNeYKWg2TuaNqLTVXw8i2PkpbP5TYdG6uthiivi39pAV
	NqHbUXTd30y5pMYcePc/sZIE/qJjxPR667UiVoqMQZt/TIpIMb+In1G4m8+DpbGtrHzobofD2VX3+
	yU7LWb8nf4oivC0h5LgcKW/7SoKuxulKbEDsXSHPe8bRpI1bkQC1nQkDzQJpGK2zfOfSJTc0NBs9n
	ktIIIyvQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sxFr9-007AmV-00;
	Sun, 06 Oct 2024 09:24:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 06 Oct 2024 09:24:56 +0800
Date: Sun, 6 Oct 2024 09:24:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: testmgr - Hide ENOENT errors better
Message-ID: <ZwHm6Inde0ttS2in@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The previous patch removed the ENOENT warning at the point of
allocation, but the overall self-test warning is still there.

Fix all of them by returning zero as the test result.  This is
safe because if the algorithm has gone away, then it cannot be
marked as tested.

Fixes: 4eded6d14f5b ("crypto: testmgr - Hide ENOENT errors")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7d768f0ed81f..3ea4b2257b23 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1947,7 +1947,7 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	atfm = crypto_alloc_ahash(driver, type, mask);
 	if (IS_ERR(atfm)) {
 		if (PTR_ERR(atfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		pr_err("alg: hash: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(atfm));
 		return PTR_ERR(atfm);
@@ -2713,7 +2713,7 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 	tfm = crypto_alloc_aead(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		pr_err("alg: aead: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3292,7 +3292,7 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 	tfm = crypto_alloc_skcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		pr_err("alg: skcipher: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3707,7 +3707,7 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 	tfm = crypto_alloc_cipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		printk(KERN_ERR "alg: cipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3733,7 +3733,7 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 		acomp = crypto_alloc_acomp(driver, type, mask);
 		if (IS_ERR(acomp)) {
 			if (PTR_ERR(acomp) == -ENOENT)
-				return -ENOENT;
+				return 0;
 			pr_err("alg: acomp: Failed to load transform for %s: %ld\n",
 			       driver, PTR_ERR(acomp));
 			return PTR_ERR(acomp);
@@ -3747,7 +3747,7 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 		comp = crypto_alloc_comp(driver, type, mask);
 		if (IS_ERR(comp)) {
 			if (PTR_ERR(comp) == -ENOENT)
-				return -ENOENT;
+				return 0;
 			pr_err("alg: comp: Failed to load transform for %s: %ld\n",
 			       driver, PTR_ERR(comp));
 			return PTR_ERR(comp);
@@ -3825,7 +3825,7 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 	rng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(rng)) {
 		if (PTR_ERR(rng) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(rng));
 		return PTR_ERR(rng);
@@ -3853,12 +3853,11 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 
 	drng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(drng)) {
+		kfree_sensitive(buf);
 		if (PTR_ERR(drng) == -ENOENT)
-			goto out_no_rng;
+			return 0;
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
-out_no_rng:
-		kfree_sensitive(buf);
 		return PTR_ERR(drng);
 	}
 
@@ -4102,7 +4101,7 @@ static int alg_test_kpp(const struct alg_test_desc *desc, const char *driver,
 	tfm = crypto_alloc_kpp(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		pr_err("alg: kpp: Failed to load tfm for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -4285,7 +4284,7 @@ static int alg_test_akcipher(const struct alg_test_desc *desc,
 	tfm = crypto_alloc_akcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT)
-			return -ENOENT;
+			return 0;
 		pr_err("alg: akcipher: Failed to load tfm for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
