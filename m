Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86D836D
	for <linux-crypto@vger.kernel.org>; Mon,  2 Sep 2024 23:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725320028; cv=none; b=NzOPeswCAvg16kpq+Q8b2BbTtOg+04jRCpKW322JYCVEyIJnn85LiglVo1gBqF1WXhUzCOk1Yfs8QHZWCJyDtLJqS+5XWAAjOXCzbfUCsVzQyHLxq2D/VN5wiStYcvDfWwnuZPCX33zhqyFwYwT0INrHvrjU0ccI02d3bKuH8HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725320028; c=relaxed/simple;
	bh=9KUO2ayoWSmnU8AVyDomjzVVU7KJTPXx3wt2uZN4PjM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uiSath8lFlFLTWB8W4XW3tFAkyDZwhHGyyLjtKlis8WP7mnHOvXlgVtYNf16Nvm2sV01ZC2f64UTqtboqVDCGJZfwLeHbtDXx9fm73KRIimvGV8pDJ/I7uTL32cGumzt5VbED3lH1EFqjf+Vn3T8B6IjSd375fFJxms/3ZrHPcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Nv2Kx5dL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Nv2Kx5dL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=M9CUD+DLUOXSRxpAMUA0D2qGRBBNDGOnNRO12IynCfo=; b=Nv2Kx5dLW2zbtMnF6j9u7vte06
	AK58PENIy1A/HLPvPFDIyhrdIc8iq0F05nGQUEP7TelDi6aYtu1VYrxFx4HEfGciYqgHl61LrDhVM
	PRJgpO2CEiXfXjlk4+F1BmpLBn/izXM0yZNqEmSqroBQC7oqcomNwo3MaPFlvw8Ho9IxBYJowbYd5
	TdB7sKhWRlHBszvQHLhNzrQAcALLEkfCkhbhO2cnc922/exsAFaKoAw1fiiyZkPixB9r/KQiME4nJ
	uSJq86KK/2Udapr4SuMMQzF6/zpXyzqx++5XTyo1gW1nvNcS4v4Jl9knbAdD/u/paGM+NJYmkMb9z
	yTICxLoA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1slGYG-009D45-32;
	Tue, 03 Sep 2024 07:33:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Sep 2024 07:33:40 +0800
Date: Tue, 3 Sep 2024 07:33:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: testmgr - Hide ENOENT errors
Message-ID: <ZtZLVG-0E6KX5BhB@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When a crypto algorithm with a higher priority is registered, it
kills the spawns of all lower-priority algorithms.  Thus it is to
be expected for an algorithm to go away at any time, even during
a self-test.  This is now much more common with asynchronous testing.

Remove the printk when an ENOENT is encountered during a self-test.
This is not really an error since the algorithm being tested is no
longer there (i.e., it didn't fail the test which is what we care
about).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f02cb075bd68..ee8da628e9da 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1939,6 +1939,8 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 
 	atfm = crypto_alloc_ahash(driver, type, mask);
 	if (IS_ERR(atfm)) {
+		if (PTR_ERR(atfm) == -ENOENT)
+			return -ENOENT;
 		pr_err("alg: hash: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(atfm));
 		return PTR_ERR(atfm);
@@ -2703,6 +2705,8 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 
 	tfm = crypto_alloc_aead(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT)
+			return -ENOENT;
 		pr_err("alg: aead: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3280,6 +3284,8 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 
 	tfm = crypto_alloc_skcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT)
+			return -ENOENT;
 		pr_err("alg: skcipher: failed to allocate transform for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3693,6 +3699,8 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 
 	tfm = crypto_alloc_cipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT)
+			return -ENOENT;
 		printk(KERN_ERR "alg: cipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -3717,6 +3725,8 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 	if (algo_type == CRYPTO_ALG_TYPE_ACOMPRESS) {
 		acomp = crypto_alloc_acomp(driver, type, mask);
 		if (IS_ERR(acomp)) {
+			if (PTR_ERR(acomp) == -ENOENT)
+				return -ENOENT;
 			pr_err("alg: acomp: Failed to load transform for %s: %ld\n",
 			       driver, PTR_ERR(acomp));
 			return PTR_ERR(acomp);
@@ -3729,6 +3739,8 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 	} else {
 		comp = crypto_alloc_comp(driver, type, mask);
 		if (IS_ERR(comp)) {
+			if (PTR_ERR(comp) == -ENOENT)
+				return -ENOENT;
 			pr_err("alg: comp: Failed to load transform for %s: %ld\n",
 			       driver, PTR_ERR(comp));
 			return PTR_ERR(comp);
@@ -3805,6 +3817,8 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 
 	rng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(rng)) {
+		if (PTR_ERR(rng) == -ENOENT)
+			return -ENOENT;
 		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(rng));
 		return PTR_ERR(rng);
@@ -3832,10 +3846,13 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 
 	drng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(drng)) {
+		if (PTR_ERR(drng) == -ENOENT)
+			goto out_no_rng;
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
+out_no_rng:
 		kfree_sensitive(buf);
-		return -ENOMEM;
+		return PTR_ERR(drng);
 	}
 
 	test_data.testentropy = &testentropy;
@@ -4077,6 +4094,8 @@ static int alg_test_kpp(const struct alg_test_desc *desc, const char *driver,
 
 	tfm = crypto_alloc_kpp(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT)
+			return -ENOENT;
 		pr_err("alg: kpp: Failed to load tfm for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -4305,6 +4324,8 @@ static int alg_test_akcipher(const struct alg_test_desc *desc,
 
 	tfm = crypto_alloc_akcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT)
+			return -ENOENT;
 		pr_err("alg: akcipher: Failed to load tfm for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
