Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEA41F0E5A;
	Wed, 11 Dec 2024 22:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733954551; cv=none; b=K89GUlOseJZRowK2RJ3CwqvF3dqdxCekzfjHhkmhKZzcB0eN1qTNLcQp+d2vzZ7lPGeyTMi5qV5Puf6HRt6Z70huKZ4NtI1lYV196I3W1r4oJABKOcIMGLBnQ41U+dovNm9KXkFcUWN3hGfUfbBBaK41EwLkfyrnUFcTkxssC9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733954551; c=relaxed/simple;
	bh=HlCKWLdI+GU05LKzYNwgUMS4EpX5rXj3VH4NpDOQ5VY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bjTwEMPeKvhR3ZlLzHFu/cE063rAmGfy2HZu7g6bdfLq5TNWPe8rrD4wtq3D2WZisrs2DeN0+TwI9sUU2iIS7riLffghr/Vz7XThrD0NiY5Zr4m+CjyXEmjLSG6Z6Yy48NXCtIHg8C1F69ox2yDBiBm60l7xSzdodXokxgo1TYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=QPRNj1Je; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="QPRNj1Je"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=HxEgA1qhpnM+73w6gjo0cgwAWhBtqqCkg0uUG05ThNA=; b=QPRNj1Je+MKDa6Yv
	RtD5RZi+ENXM237GR5+27bSs7dlNFZ0mq41AZ1K3zgxy8Ilcgjgw7l73ORVwnNiunm/6E6fCzFiDV
	QLKEj5FJ5u/f1d5NFD4LrLlakjEu/wvttqEYXO4pXln7HCxNSw+z0FncYi+/kQYD9/6ZdmtXzJyGI
	MzgAY90YegqXBUcxPGAddIRuoiO7WafPqR97IBLuNo7Nz+mJyJv1cvMaGC1iPApk/RBLdo3VnAeqI
	9acfZN1v3pejCZHD7C2EzF2EuKNgc/JST7A3pSKHCc9mbEnt4yApbdSgFKY/oRhn34uuTt2a54jmO
	VPkidH2ZjOqwUzSYiw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tLUmk-004rlK-0Z;
	Wed, 11 Dec 2024 22:02:22 +0000
From: linux@treblig.org
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: lib/gf128mul - Remove some bbe deadcode
Date: Wed, 11 Dec 2024 22:02:18 +0000
Message-ID: <20241211220218.129099-1-linux@treblig.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

gf128mul_4k_bbe(), gf128mul_bbe() and gf128mul_init_4k_bbe()
are part of the library originally added in 2006 by
commit c494e0705d67 ("[CRYPTO] lib: table driven multiplications in
GF(2^128)")

but have never been used.

Remove them.
(BBE is Big endian Byte/Big endian bits
Note the 64k table version is used and I've left that in)

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 include/crypto/gf128mul.h |  6 +---
 lib/crypto/gf128mul.c     | 75 ---------------------------------------
 2 files changed, 1 insertion(+), 80 deletions(-)

diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index 81330c6446f6..b0853f7cada0 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -158,12 +158,10 @@
     64...71 72...79 80...87 88...95  96..103 104.111 112.119 120.127
 */
 
-/*	A slow generic version of gf_mul, implemented for lle and bbe
+/*	A slow generic version of gf_mul, implemented for lle
  * 	It multiplies a and b and puts the result in a */
 void gf128mul_lle(be128 *a, const be128 *b);
 
-void gf128mul_bbe(be128 *a, const be128 *b);
-
 /*
  * The following functions multiply a field element by x in
  * the polynomial field representation.  They use 64-bit word operations
@@ -224,9 +222,7 @@ struct gf128mul_4k {
 };
 
 struct gf128mul_4k *gf128mul_init_4k_lle(const be128 *g);
-struct gf128mul_4k *gf128mul_init_4k_bbe(const be128 *g);
 void gf128mul_4k_lle(be128 *a, const struct gf128mul_4k *t);
-void gf128mul_4k_bbe(be128 *a, const struct gf128mul_4k *t);
 void gf128mul_x8_ble(le128 *r, const le128 *x);
 static inline void gf128mul_free_4k(struct gf128mul_4k *t)
 {
diff --git a/lib/crypto/gf128mul.c b/lib/crypto/gf128mul.c
index 8f8c45e0cdcf..fbe72cb3453a 100644
--- a/lib/crypto/gf128mul.c
+++ b/lib/crypto/gf128mul.c
@@ -225,44 +225,6 @@ void gf128mul_lle(be128 *r, const be128 *b)
 }
 EXPORT_SYMBOL(gf128mul_lle);
 
-void gf128mul_bbe(be128 *r, const be128 *b)
-{
-	be128 p[8];
-	int i;
-
-	p[0] = *r;
-	for (i = 0; i < 7; ++i)
-		gf128mul_x_bbe(&p[i + 1], &p[i]);
-
-	memset(r, 0, sizeof(*r));
-	for (i = 0;;) {
-		u8 ch = ((u8 *)b)[i];
-
-		if (ch & 0x80)
-			be128_xor(r, r, &p[7]);
-		if (ch & 0x40)
-			be128_xor(r, r, &p[6]);
-		if (ch & 0x20)
-			be128_xor(r, r, &p[5]);
-		if (ch & 0x10)
-			be128_xor(r, r, &p[4]);
-		if (ch & 0x08)
-			be128_xor(r, r, &p[3]);
-		if (ch & 0x04)
-			be128_xor(r, r, &p[2]);
-		if (ch & 0x02)
-			be128_xor(r, r, &p[1]);
-		if (ch & 0x01)
-			be128_xor(r, r, &p[0]);
-
-		if (++i >= 16)
-			break;
-
-		gf128mul_x8_bbe(r);
-	}
-}
-EXPORT_SYMBOL(gf128mul_bbe);
-
 /*      This version uses 64k bytes of table space.
     A 16 byte buffer has to be multiplied by a 16 byte key
     value in GF(2^128).  If we consider a GF(2^128) value in
@@ -380,28 +342,6 @@ struct gf128mul_4k *gf128mul_init_4k_lle(const be128 *g)
 }
 EXPORT_SYMBOL(gf128mul_init_4k_lle);
 
-struct gf128mul_4k *gf128mul_init_4k_bbe(const be128 *g)
-{
-	struct gf128mul_4k *t;
-	int j, k;
-
-	t = kzalloc(sizeof(*t), GFP_KERNEL);
-	if (!t)
-		goto out;
-
-	t->t[1] = *g;
-	for (j = 1; j <= 64; j <<= 1)
-		gf128mul_x_bbe(&t->t[j + j], &t->t[j]);
-
-	for (j = 2; j < 256; j += j)
-		for (k = 1; k < j; ++k)
-			be128_xor(&t->t[j + k], &t->t[j], &t->t[k]);
-
-out:
-	return t;
-}
-EXPORT_SYMBOL(gf128mul_init_4k_bbe);
-
 void gf128mul_4k_lle(be128 *a, const struct gf128mul_4k *t)
 {
 	u8 *ap = (u8 *)a;
@@ -417,20 +357,5 @@ void gf128mul_4k_lle(be128 *a, const struct gf128mul_4k *t)
 }
 EXPORT_SYMBOL(gf128mul_4k_lle);
 
-void gf128mul_4k_bbe(be128 *a, const struct gf128mul_4k *t)
-{
-	u8 *ap = (u8 *)a;
-	be128 r[1];
-	int i = 0;
-
-	*r = t->t[ap[0]];
-	while (++i < 16) {
-		gf128mul_x8_bbe(r);
-		be128_xor(r, r, &t->t[ap[i]]);
-	}
-	*a = *r;
-}
-EXPORT_SYMBOL(gf128mul_4k_bbe);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Functions for multiplying elements of GF(2^128)");
-- 
2.47.1

