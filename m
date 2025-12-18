Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C181D5CD4
	for <linux-crypto@vger.kernel.org>; Thu, 18 Dec 2025 21:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766093293; cv=none; b=D2HlSH20VyQhsLBviLPdKzRL1WTsPzGQ1tAwKGJToiyhAa1duLqbxJ54Yz1B3/Ig7VxBJXCiqs9YgTRk8vgUG2jamXTGfkjoBhadrtJCNTTgvYv/wphFxH653sIBUVGXWfe113ZLTCftUGaKnoX2Zo2CECKsTkbsyL9VBWP77Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766093293; c=relaxed/simple;
	bh=kE5wg91+uyOPxBCoJr+1oXkzJ4R5+p6hlH2VDxfoO5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d6QEt/XCb08WWwfrra+1FwtOhkeKp8laNsy3sRK6fb6qTxXn52SFNwf9JmXpbTFFMNmayYlImJ21k2RaCdZYZaznR7I+YN6jhoRlANCfnLt6PLugxIbplsNLxwzcjGOc0B9GORqPx5I3UmE01XZw3dfzg5aflrTExoiW/MTUbvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NTx/HZIP; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NTx/HZIP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766093283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XUfrJ43WHQN7AVXcXnhjCn4Zi+rcBTlLBBZ3vZeTUFI=;
	b=NTx/HZIPhrPAEgD4QygsRPnCxb8+DDzsSihRu3iMV4e0vwWbRI+OZNHMHGQR3dbNNG4yqQ
	s2X4ZdVGqjrDGLV4gM13qc7KyxvUoXuol+P9N0fG8jEr/Bi8DX+XUawAFNPzXUWCHcO6Lm
	LuZAmvKXDpqeU7Qk4VcKNVgvL/6V+7E=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ecc - Streamline alloc_point and remove {alloc,free}_digits_space
Date: Thu, 18 Dec 2025 22:27:13 +0100
Message-ID: <20251218212713.1616-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Check 'ndigits' before allocating 'struct ecc_point' to return early if
needed. Inline the code from and remove ecc_alloc_digits_space() and
ecc_free_digits_space(), respectively.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/ecc.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 6cf9a945fc6c..9b8e4ba9719a 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -90,33 +90,24 @@ void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
 }
 EXPORT_SYMBOL(ecc_digits_from_bytes);
 
-static u64 *ecc_alloc_digits_space(unsigned int ndigits)
+struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 {
-	size_t len = ndigits * sizeof(u64);
+	struct ecc_point *p;
+	size_t ndigits_sz;
 
-	if (!len)
+	if (!ndigits)
 		return NULL;
 
-	return kmalloc(len, GFP_KERNEL);
-}
-
-static void ecc_free_digits_space(u64 *space)
-{
-	kfree_sensitive(space);
-}
-
-struct ecc_point *ecc_alloc_point(unsigned int ndigits)
-{
-	struct ecc_point *p = kmalloc(sizeof(*p), GFP_KERNEL);
-
+	p = kmalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return NULL;
 
-	p->x = ecc_alloc_digits_space(ndigits);
+	ndigits_sz = ndigits * sizeof(u64);
+	p->x = kmalloc(ndigits_sz, GFP_KERNEL);
 	if (!p->x)
 		goto err_alloc_x;
 
-	p->y = ecc_alloc_digits_space(ndigits);
+	p->y = kmalloc(ndigits_sz, GFP_KERNEL);
 	if (!p->y)
 		goto err_alloc_y;
 
@@ -125,7 +116,7 @@ struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 	return p;
 
 err_alloc_y:
-	ecc_free_digits_space(p->x);
+	kfree_sensitive(p->x);
 err_alloc_x:
 	kfree(p);
 	return NULL;
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

