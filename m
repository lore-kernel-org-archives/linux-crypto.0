Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6580A1FCFD3
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080316; cv=none; b=ITXNdeVdxl8Ow8/JE2xbRYL0skZXunhXpOBOjGd8ZF1KZzX3kenxjRC0wRZfwj7A+Re9KM6/hqFTwMwuG+3AK3oxih9drUBzW+3ITdvF4RnJ/HxR08hBA6SVP7eZe1Zg3YZaV5jksEeyLHOww/39b1Yy5a5dmAHMkZ91CE7aOl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080316; c=relaxed/simple;
	bh=fE8/epETeQE+8+IBXF6ncKZ1Q//cKQuQ2w3aNBzt7Sk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=DGDacgTRSimEmCbSpTBh6iZk4JP60CekA78A05f/HiJusG6ykC+8q3XBaVgGcGdsqpmqOMBSYSZYNp3rjB5f+JmxrWXgNODUXsAAkRjqxM9NwUY6DG2KwMUYNGrwYFWVSD/5ubYDSRwFccS8Q3kAO9YTCUhxm49M5pazfQrf7x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Q9EVmGfr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Q9EVmGfr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=eTZx4aOK1a37IAWLFenpLkzeTZn5evzAew323HFadZI=; b=Q9EVmGfr4Kc06EYJbAV4sLHcdy
	FoN7OeMZgMecze9AfevntfnAKXf2wPZA5f3E/xSvivSSIo5xhgK0oOZmg9ikYWVq5yNmB22pSX5HF
	rZimQWMGwu9A7fRzsOOIo7vZujH+SbjrmAnFo6baukNb2tlFT+o6MAjbRmbEgopG137ryGIBWlwPw
	fdI0WpFzRlKRrGYYt2m/tJ3GyniMZSgIe6+ei6d/HVl+S9Y7fU4dsaLuMdteGW2oC3AT2y8XnJATr
	/o38LAr0LRziVybQBhEFIE4bMtyGPvdylsOYLVKeA1GM4d/phI1M3s8XkvBsKf+M6MzHk3tA5AtAh
	qu2h4bkg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpOWU-003a2v-2P;
	Tue, 04 Mar 2025 17:25:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Mar 2025 17:25:10 +0800
Date: Tue, 04 Mar 2025 17:25:10 +0800
Message-Id: <b4b4de79a2e0d3e3424ea6ec4a9fb85437814ea9.1741080140.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741080140.git.herbert@gondor.apana.org.au>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 4/7] crypto: testmgr - Remove NULL dst acomp tests
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

In preparation for the partial removal of NULL dst acomp support,
remove the tests for them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b69877db3f33..95b973a391cc 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3522,21 +3522,6 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
-		crypto_init_wait(&wait);
-		sg_init_one(&src, input_vec, ilen);
-		acomp_request_set_params(req, &src, NULL, ilen, 0);
-
-		ret = crypto_wait_req(crypto_acomp_compress(req), &wait);
-		if (ret) {
-			pr_err("alg: acomp: compression failed on NULL dst buffer test %d for %s: ret=%d\n",
-			       i + 1, algo, -ret);
-			kfree(input_vec);
-			acomp_request_free(req);
-			goto out;
-		}
-#endif
-
 		kfree(input_vec);
 		acomp_request_free(req);
 	}
@@ -3598,20 +3583,6 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
-		crypto_init_wait(&wait);
-		acomp_request_set_params(req, &src, NULL, ilen, 0);
-
-		ret = crypto_wait_req(crypto_acomp_decompress(req), &wait);
-		if (ret) {
-			pr_err("alg: acomp: decompression failed on NULL dst buffer test %d for %s: ret=%d\n",
-			       i + 1, algo, -ret);
-			kfree(input_vec);
-			acomp_request_free(req);
-			goto out;
-		}
-#endif
-
 		kfree(input_vec);
 		acomp_request_free(req);
 	}
-- 
2.39.5

