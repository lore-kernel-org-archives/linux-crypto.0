Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06334846A
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 00:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780531883; cv=none; b=Gq8Y8Xtp1lOGNOFnDa4GBRqdeyS/pKH4qA26jIdJTTet7+bgh1TZjTJETFNT1JieD2tw6ox7SQEhbngKrmrK1wBxoHpAfVBzJ8jliPAJuIzSj3Zw/7UH90b7CWhkvvR7CrDTgUIZUou8PcJdLwZRRRYIhb2BrQE6bgITqj1PNZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780531883; c=relaxed/simple;
	bh=X4zBS/0rIRr5kJf5yJUMlfYBwrqmipKAekQvJYznmqY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ffw3QiwTsAFMCxWZEN/JwWwH7s6E0lb6p+sb27Zb7qoaiExX+jB1QdXhwtSfOGUeZs6fRC9cO5pvVzmaYGxBu3QGe9/omxgGjYBO7W/h25g5gTYsxOSMJpbgnRg1WhipwL1vMTr91mMdkvPBCwGDBeXv3kySDkaiVJXdMNbhpK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d1xJgGHG; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d1xJgGHG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780531870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kY0JOrGKHWHsX/V5r+8L8q5T7CTQVdqKxlvXCGnw9d4=;
	b=d1xJgGHGd90+WyhadqaFVXdRBXuW1YqkxBH17jkNjJRvfVJx4717dkVqUzrQ5r+XK0NFEE
	CaOjzW0b2T9aPLeHwq0vl+2smQGaBTMKBmDbIOwFW9lrPsVPYU5l9HFgrC7bakimziO9gb
	/z7pYt4Z6hJWwdBeiB9RV4TvYoXn0MU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: omap - use min3 to simplify omap_crypto_copy_data
Date: Thu,  4 Jun 2026 02:10:36 +0200
Message-ID: <20260604001035.1256238-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2263; i=thorsten.blum@linux.dev; h=from:subject; bh=X4zBS/0rIRr5kJf5yJUMlfYBwrqmipKAekQvJYznmqY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkKh6ptEvc4P897GDh/yVovZitPTp+Zp/89bdrjuvsQ8 75zv9Y+6ChlYRDjYpAVU2R5MOvHDN/SmspNJhE7YeawMoEMYeDiFICJbHrByDBFf9VEg0z279tl zZum+NRI1dvNvlWeld1xsYfVayKXxCqG36zBkmvqyxLvGWyPD65NYEnNFhLf8mqC8ZX3XPP1v/4 tZAcA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace two consecutive min() calls with min3() to simplify the code.

Change the function parameters and local variables from int to size_t
since these represent unsigned values and to prevent a signedness error.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/omap-crypto.c | 12 ++++++------
 drivers/crypto/omap-crypto.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/omap-crypto.c b/drivers/crypto/omap-crypto.c
index 0345c9383d50..c0400fbe313e 100644
--- a/drivers/crypto/omap-crypto.c
+++ b/drivers/crypto/omap-crypto.c
@@ -156,11 +157,11 @@ EXPORT_SYMBOL_GPL(omap_crypto_align_sg);
 
 static void omap_crypto_copy_data(struct scatterlist *src,
 				  struct scatterlist *dst,
-				  int offset, int len)
+				  size_t offset, size_t len)
 {
-	int amt;
+	size_t amt;
 	void *srcb, *dstb;
-	int srco = 0, dsto = offset;
+	size_t srco = 0, dsto = offset;
 
 	while (src && dst && len) {
 		if (srco >= src->length) {
@@ -175,8 +176,7 @@ static void omap_crypto_copy_data(struct scatterlist *src,
 			continue;
 		}
 
-		amt = min(src->length - srco, dst->length - dsto);
-		amt = min(len, amt);
+		amt = min3(src->length - srco, dst->length - dsto, len);
 
 		srcb = kmap_atomic(sg_page(src)) + srco + src->offset;
 		dstb = kmap_atomic(sg_page(dst)) + dsto + dst->offset;
@@ -195,7 +195,7 @@ static void omap_crypto_copy_data(struct scatterlist *src,
 }
 
 void omap_crypto_cleanup(struct scatterlist *sg, struct scatterlist *orig,
-			 int offset, int len, u8 flags_shift,
+			 size_t offset, size_t len, u8 flags_shift,
 			 unsigned long flags)
 {
 	void *buf;
diff --git a/drivers/crypto/omap-crypto.h b/drivers/crypto/omap-crypto.h
index 506ccde6f380..436f45f3bb7d 100644
--- a/drivers/crypto/omap-crypto.h
+++ b/drivers/crypto/omap-crypto.h
@@ -28,7 +28,7 @@ int omap_crypto_align_sg(struct scatterlist **sg, int total, int bs,
 			 struct scatterlist *new_sg, u16 flags,
 			 u8 flags_shift, unsigned long *dd_flags);
 void omap_crypto_cleanup(struct scatterlist *sg, struct scatterlist *orig,
-			 int offset, int len, u8 flags_shift,
+			 size_t offset, size_t len, u8 flags_shift,
 			 unsigned long flags);
 
 #endif
