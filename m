Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D8C1DA60F
	for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 03:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750822663; cv=none; b=MQKTXYhX9NHZfUKxoCTMBd/ZUpYdoPuWcpkEjP/HlzEPkms9o72awvZCSygHQBhSbJGlOszxFm2AoGXZwz7243xQUMPN+ihEhyPS1BlNpemzbzi5kmEKlYuvMtEN5X34hhIRA2pDfW7gQQgOzMK9BzgaGggh4LW4xRjLdGYQ0uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750822663; c=relaxed/simple;
	bh=RcqwAmH8reITbFxhGQhKgshOEqMaIPoTsuK/iug71/k=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cJWOehjbGV7DefYoqTNFSRUGuvhP/KoLmvHFEcXHRzLeRZQDe+0uS5vScRjBgNI7E5a+zHFuUz6a1yj9Z3gQdP/tfDsqc8N1Xz70Z7TNYO26wMfjoWoZBQFNjAMfm9c+RgmKep9c00NTeBmadH7WbfeZ+OpQUXO6kVEGmxfNXZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GqMaAVfE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GqMaAVfE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yb0X7GhkCHRrVWDPF6d+DINGflgvMKS1G6HPJLHUdG8=; b=GqMaAVfEpSnQN90fpVE31XIzVj
	z8vtXfrUYcXxcfJykNsEk6xU5K8Ue2iJ/RnLlV6Gaqrr0a43vSdan+/rP0y1z+dy020cmbiVXnh/c
	ZbF0VqMUisvS93qcMQaUmoeO3Fh9iQQ1aoTyO66SUYmiygonvVfYA15Hm8N+7KrPwB6GwPlgkVHXK
	qXMzgTphHWM9xRMXVS7GjgGErrzFm/RFHvXu48vlp4n9Dmd8Qf1aPl7QRJ/jrmMCkXBh+NO0Mym7f
	gH2gh5rnEDhAQI5pPwS8fR+4wbBcTzUlMrWqO5/ISheOwhAplcdkUYXN3jl+Km/QfAnyk9/kC2Jmc
	vxREI27w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uUGhe-000n7g-2B;
	Wed, 25 Jun 2025 11:37:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 25 Jun 2025 11:37:35 +0800
Date: Wed, 25 Jun 2025 11:37:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: chelsio - Use crypto_shash_export_core
Message-ID: <aFtu_wFQnjO6j8aX@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use crypto_shash_export_core to export the core hash state without
the partial blocks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index af37477ffd8d..be21e4e2016c 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -314,30 +314,30 @@ static int chcr_compute_partial_hash(struct shash_desc *desc,
 	if (digest_size == SHA1_DIGEST_SIZE) {
 		error = crypto_shash_init(desc) ?:
 			crypto_shash_update(desc, iopad, SHA1_BLOCK_SIZE) ?:
-			crypto_shash_export(desc, (void *)&sha1_st);
+			crypto_shash_export_core(desc, &sha1_st);
 		memcpy(result_hash, sha1_st.state, SHA1_DIGEST_SIZE);
 	} else if (digest_size == SHA224_DIGEST_SIZE) {
 		error = crypto_shash_init(desc) ?:
 			crypto_shash_update(desc, iopad, SHA256_BLOCK_SIZE) ?:
-			crypto_shash_export(desc, (void *)&sha256_st);
+			crypto_shash_export_core(desc, &sha256_st);
 		memcpy(result_hash, sha256_st.state, SHA256_DIGEST_SIZE);
 
 	} else if (digest_size == SHA256_DIGEST_SIZE) {
 		error = crypto_shash_init(desc) ?:
 			crypto_shash_update(desc, iopad, SHA256_BLOCK_SIZE) ?:
-			crypto_shash_export(desc, (void *)&sha256_st);
+			crypto_shash_export_core(desc, &sha256_st);
 		memcpy(result_hash, sha256_st.state, SHA256_DIGEST_SIZE);
 
 	} else if (digest_size == SHA384_DIGEST_SIZE) {
 		error = crypto_shash_init(desc) ?:
 			crypto_shash_update(desc, iopad, SHA512_BLOCK_SIZE) ?:
-			crypto_shash_export(desc, (void *)&sha512_st);
+			crypto_shash_export_core(desc, &sha512_st);
 		memcpy(result_hash, sha512_st.state, SHA512_DIGEST_SIZE);
 
 	} else if (digest_size == SHA512_DIGEST_SIZE) {
 		error = crypto_shash_init(desc) ?:
 			crypto_shash_update(desc, iopad, SHA512_BLOCK_SIZE) ?:
-			crypto_shash_export(desc, (void *)&sha512_st);
+			crypto_shash_export_core(desc, &sha512_st);
 		memcpy(result_hash, sha512_st.state, SHA512_DIGEST_SIZE);
 	} else {
 		error = -EINVAL;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
