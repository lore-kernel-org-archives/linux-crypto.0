Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED2D136643
	for <linux-crypto@vger.kernel.org>; Sun,  1 Sep 2024 08:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725178023; cv=none; b=CetH0Zvjeif6g9caunAs9nY28nh9VqyY9K+btf//XpMcrJbXdTsbPBHxlK3JeRDCCQJM/rlA8G5ffBppn3A0Od9TOpbBe2WG8JGOkvWXS+RAliblWKwHpAvia2n7zVVFAvXRtCnoC0egCMXP0i5JyXiRRUuJ9vf7DX4dBw5sTA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725178023; c=relaxed/simple;
	bh=JwXMOZKFGQRBTW4nMIcti5JMra7LAKvcxr1xKaUK/0c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FBjr5XNAk1Id9Skn8nKqpO/3egSM/d8D6Lq1Uuj+Oa03dj0DiBgR59sw/eyj2YW26B6Q/HaKhKoCXlAFIiczS93D/NCFzcheOwjpVFquIEni0/BQy5wMcHk3E53CzsQcK6vEh1rAygg8LWl96rD6/wB5WhNkr7O4Ms2m/FUhVy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1skfTP-008rgW-1p;
	Sun, 01 Sep 2024 16:06:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 01 Sep 2024 16:06:56 +0800
Date: Sun, 1 Sep 2024 16:06:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: algboss - Pass instance creation error up
Message-ID: <ZtQgoIhvZUvpI8K4@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Pass any errors we get during instance creation up through the
larval.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algboss.c b/crypto/algboss.c
index d05a5aad2176..a20926bfd34e 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -51,7 +51,7 @@ static int cryptomgr_probe(void *data)
 {
 	struct cryptomgr_param *param = data;
 	struct crypto_template *tmpl;
-	int err;
+	int err = -ENOENT;
 
 	tmpl = crypto_lookup_template(param->template);
 	if (!tmpl)
@@ -64,6 +64,7 @@ static int cryptomgr_probe(void *data)
 	crypto_tmpl_put(tmpl);
 
 out:
+	param->larval->adult = ERR_PTR(err);
 	param->larval->alg.cra_flags |= CRYPTO_ALG_DEAD;
 	complete_all(&param->larval->completion);
 	crypto_alg_put(&param->larval->alg);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
