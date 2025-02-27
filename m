Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B143E227EAC
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 10:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740651308; cv=none; b=PL2AAmG4xJKB4lVw/oTmF0GDp2Wgq5t/zMEWD3E1I7yKbu4bdhmIaQjLiMHq2pgAgYcOLsGQqp1+x27VCimUQKE2VXHm+912BdPkCDc4mJscgys4p5UQV/DKVUUEqlsBpSVzmp7sOHLhAfREyZS4ecabM4W/9ASxADw7k3e/1NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740651308; c=relaxed/simple;
	bh=fE8/epETeQE+8+IBXF6ncKZ1Q//cKQuQ2w3aNBzt7Sk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=Egy4yUo/k048uKwyux6i0V/mlLUDorAJP6RhOGlOHoPaey/bv6s2thIn6Gt1ZXc9JuBXWO3IlxiT926a9kIM40k1DkF5FpT7rO+5n3EC3bn86gxofzhBWJK7xWkbXK2bEH2XNkzLp0Y6DGzBcFMI+3J017Nj5yf3HzlPplJQBfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CuQEqmsn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CuQEqmsn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=eTZx4aOK1a37IAWLFenpLkzeTZn5evzAew323HFadZI=; b=CuQEqmsnkuc2JLWqfOjQvMkmSi
	PKsSsKJuY0aStLGHnxot+doJM/VWEB18j3vFwS3Am77HGIsIWjuGGM+N/bgGO+eXDjl9BIfCo1eow
	FiCWm4gEy68ZuCSVm7AiV6aNWGG9EtE1XRV4IQFLq+4hzYAtyHeFT6F1UOMxIKSUy+IosclLco2uY
	d0VOIxD6JvS71pBGMFmqUrQnMZFq86Q4Lmvd2PnUa4T/AZW5fy/yEsBNKvvYdwB1zNW8aJjNQBVaA
	r7qYFwW6K2oAGboHiG3jytM5e9u7eL1EsLmmQ0Ju13N5Xdzx6IcYrHkQwTMe7UBg3+1tDXebT9Zb2
	fBRNCPzQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnav0-002DrC-20;
	Thu, 27 Feb 2025 18:15:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Feb 2025 18:15:02 +0800
Date: Thu, 27 Feb 2025 18:15:02 +0800
Message-Id: <51aac11d47b2fd86166208342c2ef544ed6f7ae6.1740651138.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1740651138.git.herbert@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/7] crypto: testmgr - Remove NULL dst acomp tests
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>
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

