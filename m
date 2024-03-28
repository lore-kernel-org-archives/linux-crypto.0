Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9E61DFF7
	for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 16:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643558; cv=none; b=rFm5zE6/mpIbvk/+gDVHxdovf2HE41dpx6Ba2M8FIyiQWiLepn49f03vN6W+I1JH9VvxNRCtzsJPxoV6p6Hd5J4Re4UdTB1ZYR9426asKDvyWXmjolToXwiAFtkBRhET6llQsxM378azA7XVhqgAJ4VlimNS6uiUmgoT+it/HvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643558; c=relaxed/simple;
	bh=8Bb1vXRiN8jH6s3xUvWUMXCBqYrUaRHYie8gB+fEojQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dlY6fsYopIfBnHuF6f20P0Mrj7QY90FQ3pRrPThXSxJar47XnG8lQGzxVCRie5usxwaaSnTY9ex/O2QXs81tHbVFsXmSy2GrfwR4/NsvP38hx1g08kFaHqNZ6QhouhLaANAC+j8uEiVz+kPtjcRCrv+PfmZpTd78zjmRjX9p9+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
From: Joachim Vandersmissen <git@jvdsn.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Salvator Benedetto <salvatore.benedetto@intel.com>,
	Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH v2] crypto: ecdh - explicitly zeroize private_key
Date: Thu, 28 Mar 2024 11:24:30 -0500
Message-ID: <20240328162430.28657-1-git@jvdsn.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

private_key is overwritten with the key parameter passed in by the
caller (if present), or alternatively a newly generated private key.
However, it is possible that the caller provides a key (or the newly
generated key) which is shorter than the previous key. In that
scenario, some key material from the previous key would not be
overwritten. The easiest solution is to explicitly zeroize the entire
private_key array first.

Note that this patch slightly changes the behavior of this function:
previously, if the ecc_gen_privkey failed, the old private_key would
remain. Now, the private_key is always zeroized. This behavior is
consistent with the case where params.key is set and ecc_is_key_valid
fails.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
---
 crypto/ecdh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 80afee3234fb..3049f147e011 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -33,6 +33,8 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	    params.key_size > sizeof(u64) * ctx->ndigits)
 		return -EINVAL;
 
+	memset(ctx->private_key, 0, sizeof(ctx->private_key));
+
 	if (!params.key || !params.key_size)
 		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
 				       ctx->private_key);
-- 
2.44.0

