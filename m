Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6169277026
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 01:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983921; cv=none; b=Bdy8UR8R2oBDbqXwehU3za6ayjX+giOHDuJU791kYjDlGb9wEMvU+82VQC1w0nBZOTi9/73lRdfCekNi9EsNuekZrjNEOWQwS0v6Lp04tq+ocmyWX1Mk4oauLcB7CdJNScso43izMtUb+9wvjaLTLSNw9HpICadGjAqFGGMmca0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983921; c=relaxed/simple;
	bh=sYxWiuqbxPLInJ5tjX0Gb5yJof+uTCB5fOXSxFbh27k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W392g++IF/10WK/TtkeZq17rua7D7KYsf/elob0SI3E9u3UJHvNIjqawvRJnl6f0mRccLMvwdAvrByi9gDDLIrmDAkPABRBV1KZJyReySOtt0V6/jjidVch5t1OjnEBRnS6lgGn4ArG7LmDN7HgxeWCt3A0VfhQtYWx5RqkeD04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Og/21CN+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Og/21CN+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bV5GFleAG7vW4sIW1PmjN7dsy/+1Cv5dmhfBBjQDb64=; b=Og/21CN+gTR+D+J8/80Ao4Jf70
	kgNAB7cxbb/GvlS7vbCdKIszUEFXthfo4KsdGWBsC8vAXxE9ZpJsKs6ZzRcz1cCM0XO3c+xCObSYh
	WU+Xb3CKk2Ejwc+Ravb0tThypCBs8XcE8pIdovfLzPhDLfouWV8P8IvRoPzJzmTV35+s0uhoHuCm0
	/lgoxnyQFcSWYS4y+3+DlLoRpTpecMuQjapAG5iLKQ2DVjWlQPkFV6rCi+nNUZXdOlrakx0c1qV5W
	2TqSVkLR5THvSOqqFuB+HzFBfiIlUyNmn/po6mXpimzw1BIkFzuhyCp4X8tzBXgSkBPdtnQuRm0l8
	EqMeiEYA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vv3xm-0000000339G-3inC;
	Wed, 25 Feb 2026 01:45:18 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-crypto@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: des - fix all kernel-doc warnings
Date: Tue, 24 Feb 2026 17:45:18 -0800
Message-ID: <20260225014518.43720-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use correct function parameter names and add Returns: sections to
eliminate all kernel-doc warnings in des.h:

Warning: include/crypto/des.h:41 function parameter 'keylen' not
 described in 'des_expand_key'
Warning: include/crypto/des.h:41 No description found for return value
 of 'des_expand_key'
Warning: include/crypto/des.h:54 function parameter 'keylen' not
 described in 'des3_ede_expand_key'
Warning: include/crypto/des.h:54 No description found for return value
 of 'des3_ede_expand_key'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>

 include/crypto/des.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20260205.orig/include/crypto/des.h
+++ linux-next-20260205/include/crypto/des.h
@@ -34,9 +34,9 @@ void des3_ede_decrypt(const struct des3_
  * des_expand_key - Expand a DES input key into a key schedule
  * @ctx: the key schedule
  * @key: buffer containing the input key
- * @len: size of the buffer contents
+ * @keylen: size of the buffer contents
  *
- * Returns 0 on success, -EINVAL if the input key is rejected and -ENOKEY if
+ * Returns: 0 on success, -EINVAL if the input key is rejected and -ENOKEY if
  * the key is accepted but has been found to be weak.
  */
 int des_expand_key(struct des_ctx *ctx, const u8 *key, unsigned int keylen);
@@ -45,9 +45,9 @@ int des_expand_key(struct des_ctx *ctx,
  * des3_ede_expand_key - Expand a triple DES input key into a key schedule
  * @ctx: the key schedule
  * @key: buffer containing the input key
- * @len: size of the buffer contents
+ * @keylen: size of the buffer contents
  *
- * Returns 0 on success, -EINVAL if the input key is rejected and -ENOKEY if
+ * Returns: 0 on success, -EINVAL if the input key is rejected and -ENOKEY if
  * the key is accepted but has been found to be weak. Note that weak keys will
  * be rejected (and -EINVAL will be returned) when running in FIPS mode.
  */
