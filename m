Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2675A1D5AC6
	for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 03:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750822953; cv=none; b=gAH4d890IN6jFYzTOgQihqWfAziJ/9+4NReFpREUpO2cZjOreBagloWzqKvlYfkBHILHsoIpaTA/Hsyekx4R6tdJcqVgbj496mgnA2MLKNAQETqFVUU2OCGLgS50nwiVLJd8vPhzm3RZntVBYKZIapHEcuETw2H5uCJv9p7ax/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750822953; c=relaxed/simple;
	bh=dCIZ2S0rW9ho6vq7r7RXAFlObGzQ1wfFwu+Brhm7k4E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=R7VFfJd7Ld8Kn5G9pJbuTTh/+1vGOzCEwr0cCPXqJ+vBHP6L0EXFQCUXcW2s5Fe5x5JGXWKzhpeka+zZ4p3yNP0iHs0p+Jy+VJZhiWHzQwexLQkrq1E25Dk7U0dNrf/akxZYc4sJ9YbbkVKdairwyVLrJocWvjBiiR63g/qUQaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FpxjlZn3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FpxjlZn3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OejMybgH6J0i0ltWOMqSYspLFU12rWq34p/2tK8WK2k=; b=FpxjlZn3MowwLpGkD/09Egurtf
	08AJt8jUdtpX7DdWoWpCo8AE0EM/ejUV7H2RcoFyL1WeXzviUeRXulTIsrf3uNqqq2GDXhGZUgJxm
	z5XyCCFaVm8mHp07XeeBxIZuvVVTpuGyfVmo6XACDbhaOYHs3tTBbobIfUySCQWfk2WbImQmiY1pC
	oynjYgCOyQZWMES2s8pidB8eoKKKnCDP7lUzDOAAhEwXR9sGEHGsJCfU3zauVnYRnMsbTQzGFnK9c
	iEKmJrOHFZMnakRynnQi/itLzmiV3psEUjroF6MdbZ77UaDtYexLJ0wDwxcmnOEtWSMndymao3cWf
	6cMr05WQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uUGmN-000nDR-0Y;
	Wed, 25 Jun 2025 11:42:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 25 Jun 2025 11:42:27 +0800
Date: Wed, 25 Jun 2025 11:42:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: qat - Use crypto_shash_export_core
Message-ID: <aFtwI073-ppQ-P47@gondor.apana.org.au>
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

diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index d69cc1e5e023..43e6dd9b77b7 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -5,11 +5,11 @@
 #include <linux/crypto.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/cipher.h>
+#include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/aes.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
-#include <crypto/hash.h>
 #include <crypto/hmac.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
@@ -154,19 +154,19 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 
 	switch (ctx->qat_hash_alg) {
 	case ICP_QAT_HW_AUTH_ALGO_SHA1:
-		if (crypto_shash_export(shash, &ctx->sha1))
+		if (crypto_shash_export_core(shash, &ctx->sha1))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out = cpu_to_be32(ctx->sha1.state[i]);
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA256:
-		if (crypto_shash_export(shash, &ctx->sha256))
+		if (crypto_shash_export_core(shash, &ctx->sha256))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out = cpu_to_be32(ctx->sha256.state[i]);
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA512:
-		if (crypto_shash_export(shash, &ctx->sha512))
+		if (crypto_shash_export_core(shash, &ctx->sha512))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 3; i++, hash512_state_out++)
 			*hash512_state_out = cpu_to_be64(ctx->sha512.state[i]);
@@ -190,19 +190,19 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 
 	switch (ctx->qat_hash_alg) {
 	case ICP_QAT_HW_AUTH_ALGO_SHA1:
-		if (crypto_shash_export(shash, &ctx->sha1))
+		if (crypto_shash_export_core(shash, &ctx->sha1))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out = cpu_to_be32(ctx->sha1.state[i]);
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA256:
-		if (crypto_shash_export(shash, &ctx->sha256))
+		if (crypto_shash_export_core(shash, &ctx->sha256))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out = cpu_to_be32(ctx->sha256.state[i]);
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA512:
-		if (crypto_shash_export(shash, &ctx->sha512))
+		if (crypto_shash_export_core(shash, &ctx->sha512))
 			return -EFAULT;
 		for (i = 0; i < digest_size >> 3; i++, hash512_state_out++)
 			*hash512_state_out = cpu_to_be64(ctx->sha512.state[i]);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
