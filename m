Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DA0231A23
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 06:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789711217; cv=none; b=pSo4caR6lij57dHw6YbiJjd86Afe8V3TT1NrJR+sAT8z3gAUno5PLndqQuCKXZkuxvab/lW82LqK2LEqQRtKpSyqV1PhbIzk6xwXm7AnkmYsiWVBrTLBpKNbg5eP6PLXPj062YXfzxjvzAGc6j3P8vHFt8uxyrDs898ULFMo0lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789711217; c=relaxed/simple;
	bh=boRVPKF2/M6FWmJLywzBxBCgln5ZVy0sQ1GnH5Pfs5I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Nw37IxDPTKBvo0nc7UzDne3V1XXRZJ5mC2fzcJc/YS8OdUMkY5HxwLhLQYm4fav/SYuZzpudIiW+5vyd7fE/rHy4MGL2T4/Lv5i+q7GGc1bPkmHo65VnRELJw1VFPTCOe2HqjwmFvYpoBihe1+I965R81vNGKPaSaRVpfxX2zKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SQkci/r+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SQkci/r+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	Cc:To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=A6lAoPhpWg6i4SdLs0OqucN1+sIkXvuFvTYz7J1MPdk=; b=SQkci
	/r+P8TH5N6QHbmnWpzkpCk6620PZGZbH0+OtmVHTMujlwDWLaXQCWAyLy7v6vMTzREsYMN5pIVAl+
	wZ1FmvOTN6GQb1fmIPBo/XhjPTcYPdYEMIupsqiSPjjlFDaktCB4NrlTfLP7xbeICmkilhU3NSAQl
	nqmv8RDyBdKOegZ1Cduhgy0IWJGD7dUw8ggG2ChnXxTm1RamFJLDpe6C1N4KxZ3XSCFNtnjLoIG8Z
	1mUUasyrx/TdTOfjBeLmgxHstCbTniGHUZwsTvCwcxgqWG/OzQO1lLw+mg5TzQ5gNuFO5eYUZCvGy
	2ZJiZrVmuQfotwNFNXdtqvhI1c0tA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7Rdn-0000000FHy7-3LJF;
	Fri, 18 Sep 2026 14:00:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 16:00:07 +1000
Date: Fri, 18 Sep 2026 16:00:07 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Chenghai Huang <huangchenghai2@huawei.com>
Subject: [PATCH] crypto: api - Fix DUP_FIRST crash on unregister
Message-ID: <aqzTZ8Zb2VmomjSV@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
index 37de377719ae..4dd0b32375b1 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -424,7 +424,6 @@ static void crypto_free_alg(struct crypto_alg *alg)
 	unsigned int algsize = alg->cra_type->algsize;
 	u8 *p = (u8 *)alg - algsize;
 
-	crypto_destroy_alg(alg);
 	kfree(p);
 }
 
@@ -494,9 +493,29 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	LIST_HEAD(list);
 
 	down_write(&crypto_alg_sem);
+	if (alg->cra_flags & CRYPTO_ALG_DUP_FIRST) {
+		struct crypto_alg *q, *r = NULL;
+
+		list_for_each_entry(q, &crypto_alg_list, cra_list) {
+			if (strcmp(q->cra_driver_name, alg->cra_driver_name))
+				continue;
+			r = q;
+			break;
+		}
+
+		if (WARN_ON_ONCE(!r)) {
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
