Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AAC394465;
	Mon,  2 Mar 2026 08:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438486; cv=none; b=f7eJs7h1z6MpUfwxym0le7hbpob8TEQ3LV35E5iK2kJEzBQmEqVy2I38wvgeZY6ezRmcghOgctEh6DfTN+/ikchwGlRrRk3Pg7RZkFco5th0BYiMDg9YcU37QuNHbPubie0X90pOxmpHCwRsXexEeCYTIgyi9MSyzV+I64jLt4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438486; c=relaxed/simple;
	bh=o0SzMwmhs68jxLgExtyOWQABbfkTZFlkpk/nVETOC1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqmlAHcUnoVIk2n0nBwhZ/YQAhde9qisXgGSejYPfrsY+629nrgJbBvg/YIl3wBmDc/8SmA8/cH+ktz1GdDjthY6nTXr389jj2Jh2h6ZWc/9AP7PSuO0sJ+/CZ5OYgiZVIp6FWZmXv94EnW+z0sqVCIswFSv0h0DFA16+jbyebI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VJs4g56J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJs4g56J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B08C2BCAF;
	Mon,  2 Mar 2026 08:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438486;
	bh=o0SzMwmhs68jxLgExtyOWQABbfkTZFlkpk/nVETOC1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJs4g56JqYSP4oPFx4omBiRs5/Ajd5OQCvW8QBQNR+1AwfsZCTNdUuWlZCqYM/UaK
	 qGZbE76KFXo3uojwPmPIUFFAuEDN5RRpbcYCB4mxDxWXVnZKstCImKAeNHt13CLzQC
	 5ik5y2OyyQ1+4hhF7FfSdwoq3Ubfw7B1mZZGyqA/9B4Q4Sk7pQitfndYlXWMeTB4fD
	 PgYb+yrGXmlXA/arKUAkh4PdQIPNQ7oFXHrTsxk/uhG8If0MjlQ2zHuaBzL6TxTKOD
	 nQsn/jJHUCywq6T8P9Wzvqbb/d375S+5OBBBvNwkFtoqrPBZEWP3wKgkiF7BQJaWBH
	 dk7BCMWV4niGQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-nvme@lists.infradead.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 15/21] nvme-auth: host: remove allocation of crypto_shash
Date: Sun,  1 Mar 2026 23:59:53 -0800
Message-ID: <20260302075959.338638-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302075959.338638-1-ebiggers@kernel.org>
References: <20260302075959.338638-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the crypto_shash that is being allocated in
nvme_auth_process_dhchap_challenge() and stored in the
struct nvme_dhchap_queue_context is no longer used, remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/host/auth.c | 29 ++---------------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 2f27f550a7442..c8cd633cb0eae 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -5,11 +5,10 @@
 
 #include <linux/crc32.h>
 #include <linux/base64.h>
 #include <linux/prandom.h>
 #include <linux/unaligned.h>
-#include <crypto/hash.h>
 #include <crypto/dh.h>
 #include "nvme.h"
 #include "fabrics.h"
 #include <linux/nvme-auth.h>
 #include <linux/nvme-keyring.h>
@@ -20,11 +19,10 @@ static mempool_t *nvme_chap_buf_pool;
 
 struct nvme_dhchap_queue_context {
 	struct list_head entry;
 	struct work_struct auth_work;
 	struct nvme_ctrl *ctrl;
-	struct crypto_shash *shash_tfm;
 	struct crypto_kpp *dh_tfm;
 	struct nvme_dhchap_key *transformed_key;
 	void *buf;
 	int qid;
 	int error;
@@ -181,42 +179,21 @@ static int nvme_auth_process_dhchap_challenge(struct nvme_ctrl *ctrl,
 			 chap->qid, data->hashid);
 		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
 		return -EPROTO;
 	}
 
-	if (chap->hash_id == data->hashid && chap->shash_tfm &&
-	    !strcmp(crypto_shash_alg_name(chap->shash_tfm), hmac_name) &&
-	    crypto_shash_digestsize(chap->shash_tfm) == data->hl) {
+	if (chap->hash_id == data->hashid && chap->hash_len == data->hl) {
 		dev_dbg(ctrl->device,
 			"qid %d: reuse existing hash %s\n",
 			chap->qid, hmac_name);
 		goto select_kpp;
 	}
 
-	/* Reset if hash cannot be reused */
-	if (chap->shash_tfm) {
-		crypto_free_shash(chap->shash_tfm);
-		chap->hash_id = 0;
-		chap->hash_len = 0;
-	}
-	chap->shash_tfm = crypto_alloc_shash(hmac_name, 0,
-					     CRYPTO_ALG_ALLOCATES_MEMORY);
-	if (IS_ERR(chap->shash_tfm)) {
-		dev_warn(ctrl->device,
-			 "qid %d: failed to allocate hash %s, error %ld\n",
-			 chap->qid, hmac_name, PTR_ERR(chap->shash_tfm));
-		chap->shash_tfm = NULL;
-		chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
-		return -ENOMEM;
-	}
-
-	if (crypto_shash_digestsize(chap->shash_tfm) != data->hl) {
+	if (nvme_auth_hmac_hash_len(data->hashid) != data->hl) {
 		dev_warn(ctrl->device,
 			 "qid %d: invalid hash length %d\n",
 			 chap->qid, data->hl);
-		crypto_free_shash(chap->shash_tfm);
-		chap->shash_tfm = NULL;
 		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
 		return -EPROTO;
 	}
 
 	chap->hash_id = data->hashid;
@@ -656,12 +633,10 @@ static void nvme_auth_reset_dhchap(struct nvme_dhchap_queue_context *chap)
 
 static void nvme_auth_free_dhchap(struct nvme_dhchap_queue_context *chap)
 {
 	nvme_auth_reset_dhchap(chap);
 	chap->authenticated = false;
-	if (chap->shash_tfm)
-		crypto_free_shash(chap->shash_tfm);
 	if (chap->dh_tfm)
 		crypto_free_kpp(chap->dh_tfm);
 }
 
 void nvme_auth_revoke_tls_key(struct nvme_ctrl *ctrl)
-- 
2.53.0

