Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0C9125B2
	for <linux-crypto@vger.kernel.org>; Wed, 20 Mar 2024 05:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710910916; cv=none; b=iNgCebD6QRDqKewx4w+WlQ0dgMuiti2FhzR51ovXnwuUvvXSWnJ+2bs/Xo+FbqzIIhF5Gd792l0tV88L8fubrbxSBt1DCsOvU0pW9VtcUICjwRPTd5QUuyehM5ThMQ93NIYcaS7+5OKbSO+RbFMaCKzKcGnXfXq2g35LFQRePKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710910916; c=relaxed/simple;
	bh=UshMBCjQNifpf9u5GJlUv26PAWHnLF9Emmdxz12rRk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qvCG6r4ozBM8b26QKdCPaOA9Skch8Ln9t+CwAzGPHq1DaBHTAD2B0o1tqpdW8si6oSFxDTtROFF0mb7cm+esxgII9T1T2HoJ9rPxpv2Dkdz27QgjFiMwAt+Xmgj99ezKM4ebjot8GaRUyEsKsbTMxsX5ZF90zLWlMgKgo2tFt2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
From: Joachim Vandersmissen <git@jvdsn.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Salvator Benedetto <salvatore.benedetto@intel.com>,
	Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH] crypto: ecdh - explicitly zeroize private_key
Date: Tue, 19 Mar 2024 23:51:06 -0500
Message-ID: <20240320045106.61875-1-git@jvdsn.com>
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
index 80afee3234fb..ce332b39b705 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -33,6 +33,8 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	    params.key_size > sizeof(u64) * ctx->ndigits)
 		return -EINVAL;
 
+	memzero_explicit(ctx->private_key, sizeof(ctx->private_key));
+
 	if (!params.key || !params.key_size)
 		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
 				       ctx->private_key);
-- 
2.44.0

