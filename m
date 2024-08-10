Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655B74409
	for <linux-crypto@vger.kernel.org>; Sat, 10 Aug 2024 06:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270865; cv=none; b=V+20+sz40NZ2ye/C+MemExZhtqAUvsvO/OoRUyG4XV9qCj8xqs357QJGCWxr9s1J4VJ9rips4ckYZp/809HXc6ciasTwIyMMu9kNyMD/HRlhIUhVlRMDluN+UjgKIO272TJJj1Q190qzxOoq/4LjsfppLCRZWhBN4oBh+xTNY00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270865; c=relaxed/simple;
	bh=F+vvlBIRQUAhcD3bW4Mtl9y8BKHb3gbKH1gxK9HBSQo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=jjktL7CPlYu5IYLhfm/awkKI1OAF5BNm/pde7qw2j2OGrL31m6DUjTJ2YJY0n/QrvLkM45CAz0AAdoFkrNtou9GOtHcwpa+Ms6W81LkbeNosl5zoe0ltnhjZI8ADaGr59kbA/p4ye72iTQ2pECvI5iUzI1eVFfsm8U/hXB25UCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scfKm-003ipO-1q;
	Sat, 10 Aug 2024 14:20:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Aug 2024 14:20:57 +0800
Date: Sat, 10 Aug 2024 14:20:57 +0800
Message-Id: <d6de0f6d0f3d03ba254bc0b223917b5cf857f8c0.1723270405.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1723270405.git.herbert@gondor.apana.org.au>
References: <cover.1723270405.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 2/4] crypto: lib/mpi - Add error checks to extension
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The remaining functions added by commit
a8ea8bdd9df92a0e5db5b43900abb7a288b8a53e did not check for memory
allocation errors.  Add the checks and change the API to allow errors
to be returned.

Fixes: a8ea8bdd9df9 ("lib/mpi: Extend the MPI library")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/linux/mpi.h           | 22 +++++++-------
 lib/crypto/mpi/mpi-add.c      | 38 ++++++++++++++++--------
 lib/crypto/mpi/mpi-bit.c      | 25 +++++++++++-----
 lib/crypto/mpi/mpi-div.c      | 55 +++++++++++++++++++++++++----------
 lib/crypto/mpi/mpi-internal.h | 11 +++----
 lib/crypto/mpi/mpi-mod.c      |  4 +--
 lib/crypto/mpi/mpi-mul.c      | 29 ++++++++++++++----
 lib/crypto/mpi/mpiutil.c      |  2 ++
 8 files changed, 128 insertions(+), 58 deletions(-)

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index e081428b91ef..47be46f36435 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -59,7 +59,7 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sg, unsigned nbytes,
 		     int *sign);
 
 /*-- mpi-mod.c --*/
-void mpi_mod(MPI rem, MPI dividend, MPI divisor);
+int mpi_mod(MPI rem, MPI dividend, MPI divisor);
 
 /*-- mpi-pow.c --*/
 int mpi_powm(MPI res, MPI base, MPI exp, MPI mod);
@@ -75,22 +75,22 @@ int mpi_sub_ui(MPI w, MPI u, unsigned long vval);
 void mpi_normalize(MPI a);
 unsigned mpi_get_nbits(MPI a);
 int mpi_test_bit(MPI a, unsigned int n);
-void mpi_set_bit(MPI a, unsigned int n);
-void mpi_rshift(MPI x, MPI a, unsigned int n);
+int mpi_set_bit(MPI a, unsigned int n);
+int mpi_rshift(MPI x, MPI a, unsigned int n);
 
 /*-- mpi-add.c --*/
-void mpi_add(MPI w, MPI u, MPI v);
-void mpi_sub(MPI w, MPI u, MPI v);
-void mpi_addm(MPI w, MPI u, MPI v, MPI m);
-void mpi_subm(MPI w, MPI u, MPI v, MPI m);
+int mpi_add(MPI w, MPI u, MPI v);
+int mpi_sub(MPI w, MPI u, MPI v);
+int mpi_addm(MPI w, MPI u, MPI v, MPI m);
+int mpi_subm(MPI w, MPI u, MPI v, MPI m);
 
 /*-- mpi-mul.c --*/
-void mpi_mul(MPI w, MPI u, MPI v);
-void mpi_mulm(MPI w, MPI u, MPI v, MPI m);
+int mpi_mul(MPI w, MPI u, MPI v);
+int mpi_mulm(MPI w, MPI u, MPI v, MPI m);
 
 /*-- mpi-div.c --*/
-void mpi_tdiv_r(MPI rem, MPI num, MPI den);
-void mpi_fdiv_r(MPI rem, MPI dividend, MPI divisor);
+int mpi_tdiv_r(MPI rem, MPI num, MPI den);
+int mpi_fdiv_r(MPI rem, MPI dividend, MPI divisor);
 
 /* inline functions */
 
diff --git a/lib/crypto/mpi/mpi-add.c b/lib/crypto/mpi/mpi-add.c
index b47c8c35f5fe..3015140d4860 100644
--- a/lib/crypto/mpi/mpi-add.c
+++ b/lib/crypto/mpi/mpi-add.c
@@ -13,11 +13,12 @@
 
 #include "mpi-internal.h"
 
-void mpi_add(MPI w, MPI u, MPI v)
+int mpi_add(MPI w, MPI u, MPI v)
 {
 	mpi_ptr_t wp, up, vp;
 	mpi_size_t usize, vsize, wsize;
 	int usign, vsign, wsign;
+	int err;
 
 	if (u->nlimbs < v->nlimbs) { /* Swap U and V. */
 		usize = v->nlimbs;
@@ -25,7 +26,9 @@ void mpi_add(MPI w, MPI u, MPI v)
 		vsize = u->nlimbs;
 		vsign = u->sign;
 		wsize = usize + 1;
-		RESIZE_IF_NEEDED(w, wsize);
+		err = RESIZE_IF_NEEDED(w, wsize);
+		if (err)
+			return err;
 		/* These must be after realloc (u or v may be the same as w).  */
 		up = v->d;
 		vp = u->d;
@@ -35,7 +38,9 @@ void mpi_add(MPI w, MPI u, MPI v)
 		vsize = v->nlimbs;
 		vsign = v->sign;
 		wsize = usize + 1;
-		RESIZE_IF_NEEDED(w, wsize);
+		err = RESIZE_IF_NEEDED(w, wsize);
+		if (err)
+			return err;
 		/* These must be after realloc (u or v may be the same as w).  */
 		up = u->d;
 		vp = v->d;
@@ -77,28 +82,37 @@ void mpi_add(MPI w, MPI u, MPI v)
 
 	w->nlimbs = wsize;
 	w->sign = wsign;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mpi_add);
 
-void mpi_sub(MPI w, MPI u, MPI v)
+int mpi_sub(MPI w, MPI u, MPI v)
 {
-	MPI vv = mpi_copy(v);
+	int err;
+	MPI vv;
+
+	vv = mpi_copy(v);
+	if (!vv)
+		return -ENOMEM;
+
 	vv->sign = !vv->sign;
-	mpi_add(w, u, vv);
+	err = mpi_add(w, u, vv);
 	mpi_free(vv);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(mpi_sub);
 
-void mpi_addm(MPI w, MPI u, MPI v, MPI m)
+int mpi_addm(MPI w, MPI u, MPI v, MPI m)
 {
-	mpi_add(w, u, v);
-	mpi_mod(w, w, m);
+	return mpi_add(w, u, v) ?:
+	       mpi_mod(w, w, m);
 }
 EXPORT_SYMBOL_GPL(mpi_addm);
 
-void mpi_subm(MPI w, MPI u, MPI v, MPI m)
+int mpi_subm(MPI w, MPI u, MPI v, MPI m)
 {
-	mpi_sub(w, u, v);
-	mpi_mod(w, w, m);
+	return mpi_sub(w, u, v) ?:
+	       mpi_mod(w, w, m);
 }
 EXPORT_SYMBOL_GPL(mpi_subm);
diff --git a/lib/crypto/mpi/mpi-bit.c b/lib/crypto/mpi/mpi-bit.c
index c29b85362664..835a2f0622a0 100644
--- a/lib/crypto/mpi/mpi-bit.c
+++ b/lib/crypto/mpi/mpi-bit.c
@@ -76,9 +76,10 @@ EXPORT_SYMBOL_GPL(mpi_test_bit);
 /****************
  * Set bit N of A.
  */
-void mpi_set_bit(MPI a, unsigned int n)
+int mpi_set_bit(MPI a, unsigned int n)
 {
 	unsigned int i, limbno, bitno;
+	int err;
 
 	limbno = n / BITS_PER_MPI_LIMB;
 	bitno  = n % BITS_PER_MPI_LIMB;
@@ -86,27 +87,31 @@ void mpi_set_bit(MPI a, unsigned int n)
 	if (limbno >= a->nlimbs) {
 		for (i = a->nlimbs; i < a->alloced; i++)
 			a->d[i] = 0;
-		mpi_resize(a, limbno+1);
+		err = mpi_resize(a, limbno+1);
+		if (err)
+			return err;
 		a->nlimbs = limbno+1;
 	}
 	a->d[limbno] |= (A_LIMB_1<<bitno);
+	return 0;
 }
 
 /*
  * Shift A by N bits to the right.
  */
-void mpi_rshift(MPI x, MPI a, unsigned int n)
+int mpi_rshift(MPI x, MPI a, unsigned int n)
 {
 	mpi_size_t xsize;
 	unsigned int i;
 	unsigned int nlimbs = (n/BITS_PER_MPI_LIMB);
 	unsigned int nbits = (n%BITS_PER_MPI_LIMB);
+	int err;
 
 	if (x == a) {
 		/* In-place operation.  */
 		if (nlimbs >= x->nlimbs) {
 			x->nlimbs = 0;
-			return;
+			return 0;
 		}
 
 		if (nlimbs) {
@@ -121,7 +126,9 @@ void mpi_rshift(MPI x, MPI a, unsigned int n)
 		/* Copy and shift by more or equal bits than in a limb. */
 		xsize = a->nlimbs;
 		x->sign = a->sign;
-		RESIZE_IF_NEEDED(x, xsize);
+		err = RESIZE_IF_NEEDED(x, xsize);
+		if (err)
+			return err;
 		x->nlimbs = xsize;
 		for (i = 0; i < a->nlimbs; i++)
 			x->d[i] = a->d[i];
@@ -129,7 +136,7 @@ void mpi_rshift(MPI x, MPI a, unsigned int n)
 
 		if (nlimbs >= x->nlimbs) {
 			x->nlimbs = 0;
-			return;
+			return 0;
 		}
 
 		for (i = 0; i < x->nlimbs - nlimbs; i++)
@@ -143,7 +150,9 @@ void mpi_rshift(MPI x, MPI a, unsigned int n)
 		/* Copy and shift by less than bits in a limb.  */
 		xsize = a->nlimbs;
 		x->sign = a->sign;
-		RESIZE_IF_NEEDED(x, xsize);
+		err = RESIZE_IF_NEEDED(x, xsize);
+		if (err)
+			return err;
 		x->nlimbs = xsize;
 
 		if (xsize) {
@@ -159,5 +168,7 @@ void mpi_rshift(MPI x, MPI a, unsigned int n)
 		}
 	}
 	MPN_NORMALIZE(x->d, x->nlimbs);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mpi_rshift);
diff --git a/lib/crypto/mpi/mpi-div.c b/lib/crypto/mpi/mpi-div.c
index 2ff0ebd74fd7..6e5044e72595 100644
--- a/lib/crypto/mpi/mpi-div.c
+++ b/lib/crypto/mpi/mpi-div.c
@@ -14,12 +14,13 @@
 #include "mpi-internal.h"
 #include "longlong.h"
 
-void mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den);
+int mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den);
 
-void mpi_fdiv_r(MPI rem, MPI dividend, MPI divisor)
+int mpi_fdiv_r(MPI rem, MPI dividend, MPI divisor)
 {
 	int divisor_sign = divisor->sign;
 	MPI temp_divisor = NULL;
+	int err;
 
 	/* We need the original value of the divisor after the remainder has been
 	 * preliminary calculated.	We have to copy it to temporary space if it's
@@ -27,16 +28,22 @@ void mpi_fdiv_r(MPI rem, MPI dividend, MPI divisor)
 	 */
 	if (rem == divisor) {
 		temp_divisor = mpi_copy(divisor);
+		if (!temp_divisor)
+			return -ENOMEM;
 		divisor = temp_divisor;
 	}
 
-	mpi_tdiv_r(rem, dividend, divisor);
+	err = mpi_tdiv_r(rem, dividend, divisor);
+	if (err)
+		goto free_temp_divisor;
 
 	if (((divisor_sign?1:0) ^ (dividend->sign?1:0)) && rem->nlimbs)
-		mpi_add(rem, rem, divisor);
+		err = mpi_add(rem, rem, divisor);
 
-	if (temp_divisor)
-		mpi_free(temp_divisor);
+free_temp_divisor:
+	mpi_free(temp_divisor);
+
+	return err;
 }
 
 /* If den == quot, den needs temporary storage.
@@ -46,12 +53,12 @@ void mpi_fdiv_r(MPI rem, MPI dividend, MPI divisor)
  *   i.e no extra storage should be allocated.
  */
 
-void mpi_tdiv_r(MPI rem, MPI num, MPI den)
+int mpi_tdiv_r(MPI rem, MPI num, MPI den)
 {
-	mpi_tdiv_qr(NULL, rem, num, den);
+	return mpi_tdiv_qr(NULL, rem, num, den);
 }
 
-void mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den)
+int mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den)
 {
 	mpi_ptr_t np, dp;
 	mpi_ptr_t qp, rp;
@@ -64,13 +71,16 @@ void mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den)
 	mpi_limb_t q_limb;
 	mpi_ptr_t marker[5];
 	int markidx = 0;
+	int err;
 
 	/* Ensure space is enough for quotient and remainder.
 	 * We need space for an extra limb in the remainder, because it's
 	 * up-shifted (normalized) below.
 	 */
 	rsize = nsize + 1;
-	mpi_resize(rem, rsize);
+	err = mpi_resize(rem, rsize);
+	if (err)
+		return err;
 
 	qsize = rsize - dsize;	  /* qsize cannot be bigger than this.	*/
 	if (qsize <= 0) {
@@ -86,11 +96,14 @@ void mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den)
 			quot->nlimbs = 0;
 			quot->sign = 0;
 		}
-		return;
+		return 0;
 	}
 
-	if (quot)
-		mpi_resize(quot, qsize);
+	if (quot) {
+		err = mpi_resize(quot, qsize);
+		if (err)
+			return err;
+	}
 
 	/* Read pointers here, when reallocation is finished.  */
 	np = num->d;
@@ -112,10 +125,10 @@ void mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den)
 		rsize = rlimb != 0?1:0;
 		rem->nlimbs = rsize;
 		rem->sign = sign_remainder;
-		return;
+		return 0;
 	}
 
-
+	err = -ENOMEM;
 	if (quot) {
 		qp = quot->d;
 		/* Make sure QP and NP point to different objects.  Otherwise the
@@ -123,6 +136,8 @@ void mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den)
 		 */
 		if (qp == np) { /* Copy NP object to temporary space.  */
 			np = marker[markidx++] = mpi_alloc_limb_space(nsize);
+			if (!np)
+				goto out_free_marker;
 			MPN_COPY(np, qp, nsize);
 		}
 	} else /* Put quotient at top of remainder. */
@@ -143,6 +158,8 @@ void mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den)
 		 * the original contents of the denominator.
 		 */
 		tp = marker[markidx++] = mpi_alloc_limb_space(dsize);
+		if (!tp)
+			goto out_free_marker;
 		mpihelp_lshift(tp, dp, dsize, normalization_steps);
 		dp = tp;
 
@@ -164,6 +181,8 @@ void mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den)
 			mpi_ptr_t tp;
 
 			tp = marker[markidx++] = mpi_alloc_limb_space(dsize);
+			if (!tp)
+				goto out_free_marker;
 			MPN_COPY(tp, dp, dsize);
 			dp = tp;
 		}
@@ -198,8 +217,14 @@ void mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den)
 
 	rem->nlimbs = rsize;
 	rem->sign	= sign_remainder;
+
+	err = 0;
+
+out_free_marker:
 	while (markidx) {
 		markidx--;
 		mpi_free_limb_space(marker[markidx]);
 	}
+
+	return err;
 }
diff --git a/lib/crypto/mpi/mpi-internal.h b/lib/crypto/mpi/mpi-internal.h
index b6fbb43afbc8..8a4f49e3043c 100644
--- a/lib/crypto/mpi/mpi-internal.h
+++ b/lib/crypto/mpi/mpi-internal.h
@@ -52,11 +52,12 @@
 typedef mpi_limb_t *mpi_ptr_t;	/* pointer to a limb */
 typedef int mpi_size_t;		/* (must be a signed type) */
 
-#define RESIZE_IF_NEEDED(a, b)			\
-	do {					\
-		if ((a)->alloced < (b))		\
-			mpi_resize((a), (b));	\
-	} while (0)
+static inline int RESIZE_IF_NEEDED(MPI a, unsigned b)
+{
+	if (a->alloced < b)
+		return mpi_resize(a, b);
+	return 0;
+}
 
 /* Copy N limbs from S to D.  */
 #define MPN_COPY(d, s, n) \
diff --git a/lib/crypto/mpi/mpi-mod.c b/lib/crypto/mpi/mpi-mod.c
index 691bbdc52fc6..d5fdaec3d0b6 100644
--- a/lib/crypto/mpi/mpi-mod.c
+++ b/lib/crypto/mpi/mpi-mod.c
@@ -7,7 +7,7 @@
 
 #include "mpi-internal.h"
 
-void mpi_mod(MPI rem, MPI dividend, MPI divisor)
+int mpi_mod(MPI rem, MPI dividend, MPI divisor)
 {
-	mpi_fdiv_r(rem, dividend, divisor);
+	return mpi_fdiv_r(rem, dividend, divisor);
 }
diff --git a/lib/crypto/mpi/mpi-mul.c b/lib/crypto/mpi/mpi-mul.c
index 7f4eda8560dc..892a246216b9 100644
--- a/lib/crypto/mpi/mpi-mul.c
+++ b/lib/crypto/mpi/mpi-mul.c
@@ -13,7 +13,7 @@
 
 #include "mpi-internal.h"
 
-void mpi_mul(MPI w, MPI u, MPI v)
+int mpi_mul(MPI w, MPI u, MPI v)
 {
 	mpi_size_t usize, vsize, wsize;
 	mpi_ptr_t up, vp, wp;
@@ -21,6 +21,7 @@ void mpi_mul(MPI w, MPI u, MPI v)
 	int usign, vsign, sign_product;
 	int assign_wp = 0;
 	mpi_ptr_t tmp_limb = NULL;
+	int err;
 
 	if (u->nlimbs < v->nlimbs) {
 		/* Swap U and V. */
@@ -46,15 +47,21 @@ void mpi_mul(MPI w, MPI u, MPI v)
 	if (w->alloced < wsize) {
 		if (wp == up || wp == vp) {
 			wp = mpi_alloc_limb_space(wsize);
+			if (!wp)
+				return -ENOMEM;
 			assign_wp = 1;
 		} else {
-			mpi_resize(w, wsize);
+			err = mpi_resize(w, wsize);
+			if (err)
+				return err;
 			wp = w->d;
 		}
 	} else { /* Make U and V not overlap with W.	*/
 		if (wp == up) {
 			/* W and U are identical.  Allocate temporary space for U. */
 			up = tmp_limb = mpi_alloc_limb_space(usize);
+			if (!up)
+				return -ENOMEM;
 			/* Is V identical too?  Keep it identical with U.  */
 			if (wp == vp)
 				vp = up;
@@ -63,6 +70,8 @@ void mpi_mul(MPI w, MPI u, MPI v)
 		} else if (wp == vp) {
 			/* W and V are identical.  Allocate temporary space for V. */
 			vp = tmp_limb = mpi_alloc_limb_space(vsize);
+			if (!vp)
+				return -ENOMEM;
 			/* Copy to the temporary space.  */
 			MPN_COPY(vp, wp, vsize);
 		}
@@ -71,7 +80,12 @@ void mpi_mul(MPI w, MPI u, MPI v)
 	if (!vsize)
 		wsize = 0;
 	else {
-		mpihelp_mul(wp, up, usize, vp, vsize, &cy);
+		err = mpihelp_mul(wp, up, usize, vp, vsize, &cy);
+		if (err) {
+			if (assign_wp)
+				mpi_free_limb_space(wp);
+			goto free_tmp_limb;
+		}
 		wsize -= cy ? 0:1;
 	}
 
@@ -79,14 +93,17 @@ void mpi_mul(MPI w, MPI u, MPI v)
 		mpi_assign_limb_space(w, wp, wsize);
 	w->nlimbs = wsize;
 	w->sign = sign_product;
+
+free_tmp_limb:
 	if (tmp_limb)
 		mpi_free_limb_space(tmp_limb);
+	return err;
 }
 EXPORT_SYMBOL_GPL(mpi_mul);
 
-void mpi_mulm(MPI w, MPI u, MPI v, MPI m)
+int mpi_mulm(MPI w, MPI u, MPI v, MPI m)
 {
-	mpi_mul(w, u, v);
-	mpi_tdiv_r(w, w, m);
+	return mpi_mul(w, u, v) ?:
+	       mpi_tdiv_r(w, w, m);
 }
 EXPORT_SYMBOL_GPL(mpi_mulm);
diff --git a/lib/crypto/mpi/mpiutil.c b/lib/crypto/mpi/mpiutil.c
index d57fd8afef64..979ece5a81d2 100644
--- a/lib/crypto/mpi/mpiutil.c
+++ b/lib/crypto/mpi/mpiutil.c
@@ -133,6 +133,8 @@ MPI mpi_copy(MPI a)
 
 	if (a) {
 		b = mpi_alloc(a->nlimbs);
+		if (!b)
+			return NULL;
 		b->nlimbs = a->nlimbs;
 		b->sign = a->sign;
 		b->flags = a->flags;
-- 
2.39.2

