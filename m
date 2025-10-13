Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07F319E81F
	for <linux-crypto@vger.kernel.org>; Mon, 13 Oct 2025 11:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760355667; cv=none; b=W4qbTM38gDq7dkWcymJ2/hTQWGjo8G3H4Dx7qJOA11pBfMeB7LeYBJMfm5piUTLSsN3Gp8A4Gx9k4bUpYfzg9HFzBuXV6ONpmRweVxNtJ3yhl14n5MG0lKQBD+1gr8azkNAqnuKfasTHvcS19dEnFJUsl3D+jXcBttdyyco5uAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760355667; c=relaxed/simple;
	bh=YIhRZUMEmVTbbTq0qn+Wub1X6vQ1RDEZasIjBykI58w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a/RhjbN6vJnDgp3T6lSNALvtisEWUML4D5UpeFfLTwdNT6Ej2LDCo841FRP83yF53px9t9N3X9hPz6AXz6LR7UejPF+Fi9fHGMKu5CJWHU76uAqHFZ931QhstpVb6N4BS0Ex2m38f5HzLmF5Gk27CvJ+FjfaHao7s39Plud156k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qc8+Kz2T; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qc8+Kz2T"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760355649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9Vu1Cpg8he0xK6peV8K87vsvIV7h3hjSS/e58iVfYGw=;
	b=Qc8+Kz2T30hBKGXDUI1IEyKZjPYMLuHrMVsW+fT91ZmxlTBt5XAQwDixGEB93hgAMNWgv3
	Q5V5RqAJgV77UHBzBNCt1XukA6yChd9OWYdsWYUDds28caojAKkyg48ZKDeOowHwamd2ge
	LN2kcm+nPyldBiMBG8+Y6lzwbZaolEI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vivek Goyal <vgoyal@redhat.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] crypto: asymmetric_keys - prevent overflow in asymmetric_key_generate_id
Date: Mon, 13 Oct 2025 13:40:10 +0200
Message-ID: <20251013114010.28983-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use check_add_overflow() to guard against potential integer overflows
when adding the binary blob lengths and the size of an asymmetric_key_id
structure and return ERR_PTR(-EOVERFLOW) accordingly. This prevents a
possible buffer overflow when copying data from potentially malicious
X.509 certificate fields that can be arbitrarily large, such as ASN.1
INTEGER serial numbers, issuer names, etc.

Fixes: 7901c1a8effb ("KEYS: Implement binary asymmetric key ID handling")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v3:
- Also use check_add_overflow() for adding the struct size itself as
  suggested by Lukas
- Drop struct_size()
- Update patch description
- Drop patch 2/2
- Link to v2: https://lore.kernel.org/lkml/20251012203841.60230-1-thorsten.blum@linux.dev/

Changes in v2:
- Use check_add_overflow() and error out as suggested by Lukas
- Update patch description
- Add Fixes: tag and @stable for backporting
- Link to v1: https://lore.kernel.org/lkml/20251007185220.234611-2-thorsten.blum@linux.dev/
---
 crypto/asymmetric_keys/asymmetric_type.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index ba2d9d1ea235..348966ea2175 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -11,6 +11,7 @@
 #include <crypto/public_key.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
+#include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <keys/system_keyring.h>
@@ -141,12 +142,17 @@ struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
 						     size_t len_2)
 {
 	struct asymmetric_key_id *kid;
-
-	kid = kmalloc(sizeof(struct asymmetric_key_id) + len_1 + len_2,
-		      GFP_KERNEL);
+	size_t kid_sz;
+	size_t len;
+
+	if (check_add_overflow(len_1, len_2, &len))
+		return ERR_PTR(-EOVERFLOW);
+	if (check_add_overflow(sizeof(struct asymmetric_key_id), len, &kid_sz))
+		return ERR_PTR(-EOVERFLOW);
+	kid = kmalloc(kid_sz, GFP_KERNEL);
 	if (!kid)
 		return ERR_PTR(-ENOMEM);
-	kid->len = len_1 + len_2;
+	kid->len = len;
 	memcpy(kid->data, val_1, len_1);
 	memcpy(kid->data + len_1, val_2, len_2);
 	return kid;
-- 
2.51.0

