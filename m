Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C047C22097
	for <linux-crypto@vger.kernel.org>; Sun,  9 Mar 2025 02:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741488209; cv=none; b=rMSRQz5xCEMuvzb2M1/xuO7S1fzPVGSJyG8dZLcT56e/gVCOzmpCnzM3adxfmFM4LlOTimhrb1ToN17XFjSvd35p7s7xlwQlU1WGAmSPojCavGqQySmCE5NZ6elLk4IQit/Qj6w4ztB/Ywejq8K82Ap6cUWkSvq5t4nWL5xcHdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741488209; c=relaxed/simple;
	bh=eJbtYG0QyFkjgodgUgb6lbaczCI2joNkozoajkLR4HY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=rN2frk7Ti8AW8e6iC6+OKNVkQi/kFZXjAsB946PflYb1XX1nQ2DUPTneO0xNO+elTY7RICDkHGJZNRrVIOa931BaIq1SpiqU0QY1/sMso0LWXcLX/uuNtN2xnHBSERdwiBgWCd/VBdeUzWiLh6O9adAtwYtfJLhLYaUEx/hLGeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qS/IiqLk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qS/IiqLk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SaM5nA/t2VageQTp9KONJJTIrMlNnOHSgAnFB1YqhFE=; b=qS/IiqLkLxKpv2ufX7+SC4dJ1p
	cEYUGFCBioApjm74Uxq1lXfS9+5sY0Y7DOlyiuqN78zDW9arOUYq3g57DWu4rL+NmMycC4Rc06PhA
	gD5Sj9DfspxNQZIcKL6M5rs9WVIFfwcstRJlb5zGWUOBJF2gwXjLOQ4dlYPmMF94ft27QC+gVa93t
	vMtA3oXX9Znsrt5M8X3tzEAxFc/Xn8dnr4NKTHsxRS33kLe0xkJEPi1WaONwEGhvdPQu2TqWbSG50
	lVCiw9qnpK1VfT8vV/dzR9rIrj7b6QVcMy2S1pR16AzgZeUzIYZBpcesgEMr15q+6w8KoRQjS9alg
	NBhvPAPQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tr6dQ-004zHn-0D;
	Sun, 09 Mar 2025 10:43:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Mar 2025 10:43:24 +0800
Date: Sun, 09 Mar 2025 10:43:24 +0800
Message-Id: <8b9786bc1694f97cbd7c5ffc99ab72b515eec3cb.1741488107.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741488107.git.herbert@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 6/8] crypto: testmgr - Remove NULL dst acomp tests
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
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
index cbce769b16ef..140872765dcd 100644
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

