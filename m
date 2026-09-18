Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77412304BB3
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 08:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720048; cv=none; b=lmkhgh5Cj+1t/IFVEA4FTos7NIWxmtM4bInExUQwskOkNV3SDUOg9SCS53LNephl5MPgdghTB75+NvBiQAkckg4JxqJpeklDXLOurBr4Bcge1V56E8Kju44AiI/cm07oFPPFMsEkEkvoJCeCGiNiZNLCev+ZCQ7CwKWrSAjNvJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720048; c=relaxed/simple;
	bh=xqWmEqr/m1cXobG6NkY2Unq0RD3lLtWpuO9fAjHbD0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQXtQ8oC2X4G6BspuI2JY0D+VYARvrNJJb00SOFupdoLa7l3h3mMspHUMvxvvioOx5v7tGR9NPY2n63ugy1tClgSqVPTWJxt4X4qSSCPp0x0aSdHMIyNQiULMw6yru4U3rfS0+mqzr4gXvoMC3KuIvQXvIzUZzbsWBzQVpok6dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TlenkHHz; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TlenkHHz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DZeqg+MmIBgY2URzoKDx38v07iPMgv5dvcRPnV9+7cc=; 
	b=TlenkHHzqJoe1fLxR1GWZ7igv6jb6vCPEyKRvPJ65ITV7wOLeLhf6OQGvQKJjmuRa+4wnzXwdVO
	loJCODNAEjvDeEYYEZ0uUuKMKPaWzWFS25jxxdnn9ci9G+5skozb3diJk360I0uIjqMjFz+H+jC93
	dQ7mA7gmkK9H+LPKcKBE2ACUeaK1tqxh0LBfXBxh29Hn2HB8jpZ0G4Vf5PBWCoh1x9A1KVs3lO6Ic
	m7ssTpuR3YRFOCXuroZLan1XHW2HpHnFx7kCBTcz14NT7mAoxS/UBx11SkW45qBbz/5yNxbYVb09f
	0DHJ25hA+WPJPcUxCNNVjIW5PO+DJMMYIHYQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7TwG-0000000FKB6-1lhN;
	Fri, 18 Sep 2026 16:27:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 18:27:20 +1000
Date: Fri, 18 Sep 2026 18:27:20 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Chenghai Huang <huangchenghai2@huawei.com>
Subject: [v2 PATCH] crypto: api - Fix DUP_FIRST crash on unregister
Message-ID: <aqz16NANbkpXWwyb@gondor.apana.org.au>
References: <aqzTZ8Zb2VmomjSV@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqzTZ8Zb2VmomjSV@gondor.apana.org.au>

v2 skips test larvals which may carry the same driver name, and
drops a duplicate warning.

---8<---
The flag CRYPTO_ALG_DUP_FIRST is buggy because upon unregistration
it tries to unregister the original algorithm rather than the
duplicate which was allocated during registration.

Fix this by locating the duplicated algorithm and unregistering
that instead of the original.

Also remove the duplicate crypto_destroy_alg call.

Reported-by: Chenghai Huang <huangchenghai2@huawei.com>
Fixes: f1440a90465b ("crypto: api - Add support for duplicating algorithms before registration")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 37de377719ae..a6839e2a20f3 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -424,7 +424,6 @@ static void crypto_free_alg(struct crypto_alg *alg)
 	unsigned int algsize = alg->cra_type->algsize;
 	u8 *p = (u8 *)alg - algsize;
 
-	crypto_destroy_alg(alg);
 	kfree(p);
 }
 
@@ -494,9 +493,31 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	LIST_HEAD(list);
 
 	down_write(&crypto_alg_sem);
+	if (alg->cra_flags & CRYPTO_ALG_DUP_FIRST) {
+		struct crypto_alg *q, *r = NULL;
+
+		list_for_each_entry(q, &crypto_alg_list, cra_list) {
+			if (crypto_is_larval(q))
+				continue;
+			if (strcmp(q->cra_driver_name, alg->cra_driver_name))
+				continue;
+			r = q;
+			break;
+		}
+
+		if (!r) {
+			up_write(&crypto_alg_sem);
+			ret = -ENOENT;
+			goto not_found;
+		}
+
+		alg = r;
+	}
+
 	ret = crypto_remove_alg(alg, &list);
 	up_write(&crypto_alg_sem);
 
+not_found:
 	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
 		return;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
