Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BC223746
	for <linux-crypto@vger.kernel.org>; Sat, 10 Aug 2024 06:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270864; cv=none; b=ur3xrnu/HByk8HYFloOeqrqdJ/nftXCYfTMuUXravvlAPiMDTjIkdnLQGvZKn/VBzMmDC3FpsBJN8iaf/vKqdzE7D2tV2FJQVDTPqF6L4vJhI/3B0BVUzo/zTFcxtsAd5HnNupf+RmNtE9OMKHat/ylCtVhKEnTReC//208/c5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270864; c=relaxed/simple;
	bh=CDa0Dg1tpWcu/ZtD8w9j+tWG93qwZyvF+TwO59bpuHs=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=mGO0WNI8C+zxhj7PL67NpCKiVh6I7/u5F7MSpUTFA/O6m6gYSwLmhj8kAthtE/yJ25/d1LnMXODcIhOrlrLk2/sXFbZcdKt/ydhy5TrpKXINscguzfB4keuMimSz3ncB6o0+wgIiDmtfm9SINPKJZlmzVwofhrNZxKPos9uxrJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scfKk-003ipE-0p;
	Sat, 10 Aug 2024 14:20:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Aug 2024 14:20:55 +0800
Date: Sat, 10 Aug 2024 14:20:55 +0800
Message-Id: <a5ea187d5f4eb04e9b0db6956f9955bcf182f1ba.1723270405.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1723270405.git.herbert@gondor.apana.org.au>
References: <cover.1723270405.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 1/4] Revert "lib/mpi: Extend the MPI library"
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This partially reverts commit a8ea8bdd9df92a0e5db5b43900abb7a288b8a53e.

Most of it is no longer needed since sm2 has been removed.  However,
the following functions have been kept as they have developed other
uses:

mpi_copy

mpi_mod

mpi_test_bit
mpi_set_bit
mpi_rshift

mpi_add
mpi_sub
mpi_addm
mpi_subm

mpi_mul
mpi_mulm

mpi_tdiv_r
mpi_fdiv_r

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/linux/mpi.h           |  65 -------
 lib/crypto/mpi/Makefile       |   1 -
 lib/crypto/mpi/mpi-add.c      |  51 ------
 lib/crypto/mpi/mpi-bit.c      | 143 ---------------
 lib/crypto/mpi/mpi-cmp.c      |  46 +----
 lib/crypto/mpi/mpi-div.c      |  29 ---
 lib/crypto/mpi/mpi-internal.h |  10 -
 lib/crypto/mpi/mpi-inv.c      | 143 ---------------
 lib/crypto/mpi/mpi-mod.c      | 144 ---------------
 lib/crypto/mpi/mpicoder.c     | 336 ----------------------------------
 lib/crypto/mpi/mpih-mul.c     |  25 ---
 lib/crypto/mpi/mpiutil.c      | 182 ------------------
 12 files changed, 10 insertions(+), 1165 deletions(-)
 delete mode 100644 lib/crypto/mpi/mpi-inv.c

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index 89b720893e12..e081428b91ef 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -40,87 +40,33 @@ struct gcry_mpi {
 typedef struct gcry_mpi *MPI;
 
 #define mpi_get_nlimbs(a)     ((a)->nlimbs)
-#define mpi_has_sign(a)       ((a)->sign)
 
 /*-- mpiutil.c --*/
 MPI mpi_alloc(unsigned nlimbs);
-void mpi_clear(MPI a);
 void mpi_free(MPI a);
 int mpi_resize(MPI a, unsigned nlimbs);
 
-static inline MPI mpi_new(unsigned int nbits)
-{
-	return mpi_alloc((nbits + BITS_PER_MPI_LIMB - 1) / BITS_PER_MPI_LIMB);
-}
-
 MPI mpi_copy(MPI a);
-MPI mpi_alloc_like(MPI a);
-void mpi_snatch(MPI w, MPI u);
-MPI mpi_set(MPI w, MPI u);
-MPI mpi_set_ui(MPI w, unsigned long u);
-MPI mpi_alloc_set_ui(unsigned long u);
-void mpi_swap_cond(MPI a, MPI b, unsigned long swap);
-
-/* Constants used to return constant MPIs.  See mpi_init if you
- * want to add more constants.
- */
-#define MPI_NUMBER_OF_CONSTANTS 6
-enum gcry_mpi_constants {
-	MPI_C_ZERO,
-	MPI_C_ONE,
-	MPI_C_TWO,
-	MPI_C_THREE,
-	MPI_C_FOUR,
-	MPI_C_EIGHT
-};
-
-MPI mpi_const(enum gcry_mpi_constants no);
 
 /*-- mpicoder.c --*/
-
-/* Different formats of external big integer representation. */
-enum gcry_mpi_format {
-	GCRYMPI_FMT_NONE = 0,
-	GCRYMPI_FMT_STD = 1,    /* Twos complement stored without length. */
-	GCRYMPI_FMT_PGP = 2,    /* As used by OpenPGP (unsigned only). */
-	GCRYMPI_FMT_SSH = 3,    /* As used by SSH (like STD but with length). */
-	GCRYMPI_FMT_HEX = 4,    /* Hex format. */
-	GCRYMPI_FMT_USG = 5,    /* Like STD but unsigned. */
-	GCRYMPI_FMT_OPAQUE = 8  /* Opaque format (some functions only). */
-};
-
 MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes);
 MPI mpi_read_from_buffer(const void *buffer, unsigned *ret_nread);
-int mpi_fromstr(MPI val, const char *str);
-MPI mpi_scanval(const char *string);
 MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int len);
 void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign);
 int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 		    int *sign);
 int mpi_write_to_sgl(MPI a, struct scatterlist *sg, unsigned nbytes,
 		     int *sign);
-int mpi_print(enum gcry_mpi_format format, unsigned char *buffer,
-			size_t buflen, size_t *nwritten, MPI a);
 
 /*-- mpi-mod.c --*/
 void mpi_mod(MPI rem, MPI dividend, MPI divisor);
 
-/* Context used with Barrett reduction.  */
-struct barrett_ctx_s;
-typedef struct barrett_ctx_s *mpi_barrett_t;
-
-mpi_barrett_t mpi_barrett_init(MPI m, int copy);
-void mpi_barrett_free(mpi_barrett_t ctx);
-void mpi_mod_barrett(MPI r, MPI x, mpi_barrett_t ctx);
-void mpi_mul_barrett(MPI w, MPI u, MPI v, mpi_barrett_t ctx);
-
 /*-- mpi-pow.c --*/
 int mpi_powm(MPI res, MPI base, MPI exp, MPI mod);
 
 /*-- mpi-cmp.c --*/
 int mpi_cmp_ui(MPI u, ulong v);
 int mpi_cmp(MPI u, MPI v);
-int mpi_cmpabs(MPI u, MPI v);
 
 /*-- mpi-sub-ui.c --*/
 int mpi_sub_ui(MPI w, MPI u, unsigned long vval);
@@ -130,16 +76,9 @@ void mpi_normalize(MPI a);
 unsigned mpi_get_nbits(MPI a);
 int mpi_test_bit(MPI a, unsigned int n);
 void mpi_set_bit(MPI a, unsigned int n);
-void mpi_set_highbit(MPI a, unsigned int n);
-void mpi_clear_highbit(MPI a, unsigned int n);
-void mpi_clear_bit(MPI a, unsigned int n);
-void mpi_rshift_limbs(MPI a, unsigned int count);
 void mpi_rshift(MPI x, MPI a, unsigned int n);
-void mpi_lshift_limbs(MPI a, unsigned int count);
-void mpi_lshift(MPI x, MPI a, unsigned int n);
 
 /*-- mpi-add.c --*/
-void mpi_add_ui(MPI w, MPI u, unsigned long v);
 void mpi_add(MPI w, MPI u, MPI v);
 void mpi_sub(MPI w, MPI u, MPI v);
 void mpi_addm(MPI w, MPI u, MPI v, MPI m);
@@ -152,10 +91,6 @@ void mpi_mulm(MPI w, MPI u, MPI v, MPI m);
 /*-- mpi-div.c --*/
 void mpi_tdiv_r(MPI rem, MPI num, MPI den);
 void mpi_fdiv_r(MPI rem, MPI dividend, MPI divisor);
-void mpi_fdiv_q(MPI quot, MPI dividend, MPI divisor);
-
-/*-- mpi-inv.c --*/
-int mpi_invm(MPI x, MPI a, MPI n);
 
 /* inline functions */
 
diff --git a/lib/crypto/mpi/Makefile b/lib/crypto/mpi/Makefile
index 477debd7ed50..9ad84079025a 100644
--- a/lib/crypto/mpi/Makefile
+++ b/lib/crypto/mpi/Makefile
@@ -19,7 +19,6 @@ mpi-y = \
 	mpi-cmp.o			\
 	mpi-sub-ui.o			\
 	mpi-div.o			\
-	mpi-inv.o			\
 	mpi-mod.o			\
 	mpi-mul.o			\
 	mpih-cmp.o			\
diff --git a/lib/crypto/mpi/mpi-add.c b/lib/crypto/mpi/mpi-add.c
index 9056fc5167fc..b47c8c35f5fe 100644
--- a/lib/crypto/mpi/mpi-add.c
+++ b/lib/crypto/mpi/mpi-add.c
@@ -13,57 +13,6 @@
 
 #include "mpi-internal.h"
 
-/****************
- * Add the unsigned integer V to the mpi-integer U and store the
- * result in W. U and V may be the same.
- */
-void mpi_add_ui(MPI w, MPI u, unsigned long v)
-{
-	mpi_ptr_t wp, up;
-	mpi_size_t usize, wsize;
-	int usign, wsign;
-
-	usize = u->nlimbs;
-	usign = u->sign;
-	wsign = 0;
-
-	/* If not space for W (and possible carry), increase space.  */
-	wsize = usize + 1;
-	if (w->alloced < wsize)
-		mpi_resize(w, wsize);
-
-	/* These must be after realloc (U may be the same as W).  */
-	up = u->d;
-	wp = w->d;
-
-	if (!usize) {  /* simple */
-		wp[0] = v;
-		wsize = v ? 1:0;
-	} else if (!usign) {  /* mpi is not negative */
-		mpi_limb_t cy;
-		cy = mpihelp_add_1(wp, up, usize, v);
-		wp[usize] = cy;
-		wsize = usize + cy;
-	} else {
-		/* The signs are different.  Need exact comparison to determine
-		 * which operand to subtract from which.
-		 */
-		if (usize == 1 && up[0] < v) {
-			wp[0] = v - up[0];
-			wsize = 1;
-		} else {
-			mpihelp_sub_1(wp, up, usize, v);
-			/* Size can decrease with at most one limb. */
-			wsize = usize - (wp[usize-1] == 0);
-			wsign = 1;
-		}
-	}
-
-	w->nlimbs = wsize;
-	w->sign   = wsign;
-}
-
-
 void mpi_add(MPI w, MPI u, MPI v)
 {
 	mpi_ptr_t wp, up, vp;
diff --git a/lib/crypto/mpi/mpi-bit.c b/lib/crypto/mpi/mpi-bit.c
index e08fc202ea5c..c29b85362664 100644
--- a/lib/crypto/mpi/mpi-bit.c
+++ b/lib/crypto/mpi/mpi-bit.c
@@ -32,7 +32,6 @@ void mpi_normalize(MPI a)
 	for (; a->nlimbs && !a->d[a->nlimbs - 1]; a->nlimbs--)
 		;
 }
-EXPORT_SYMBOL_GPL(mpi_normalize);
 
 /****************
  * Return the number of bits in A.
@@ -93,85 +92,6 @@ void mpi_set_bit(MPI a, unsigned int n)
 	a->d[limbno] |= (A_LIMB_1<<bitno);
 }
 
-/****************
- * Set bit N of A. and clear all bits above
- */
-void mpi_set_highbit(MPI a, unsigned int n)
-{
-	unsigned int i, limbno, bitno;
-
-	limbno = n / BITS_PER_MPI_LIMB;
-	bitno  = n % BITS_PER_MPI_LIMB;
-
-	if (limbno >= a->nlimbs) {
-		for (i = a->nlimbs; i < a->alloced; i++)
-			a->d[i] = 0;
-		mpi_resize(a, limbno+1);
-		a->nlimbs = limbno+1;
-	}
-	a->d[limbno] |= (A_LIMB_1<<bitno);
-	for (bitno++; bitno < BITS_PER_MPI_LIMB; bitno++)
-		a->d[limbno] &= ~(A_LIMB_1 << bitno);
-	a->nlimbs = limbno+1;
-}
-EXPORT_SYMBOL_GPL(mpi_set_highbit);
-
-/****************
- * clear bit N of A and all bits above
- */
-void mpi_clear_highbit(MPI a, unsigned int n)
-{
-	unsigned int limbno, bitno;
-
-	limbno = n / BITS_PER_MPI_LIMB;
-	bitno  = n % BITS_PER_MPI_LIMB;
-
-	if (limbno >= a->nlimbs)
-		return; /* not allocated, therefore no need to clear bits :-) */
-
-	for ( ; bitno < BITS_PER_MPI_LIMB; bitno++)
-		a->d[limbno] &= ~(A_LIMB_1 << bitno);
-	a->nlimbs = limbno+1;
-}
-
-/****************
- * Clear bit N of A.
- */
-void mpi_clear_bit(MPI a, unsigned int n)
-{
-	unsigned int limbno, bitno;
-
-	limbno = n / BITS_PER_MPI_LIMB;
-	bitno  = n % BITS_PER_MPI_LIMB;
-
-	if (limbno >= a->nlimbs)
-		return; /* Don't need to clear this bit, it's far too left.  */
-	a->d[limbno] &= ~(A_LIMB_1 << bitno);
-}
-EXPORT_SYMBOL_GPL(mpi_clear_bit);
-
-
-/****************
- * Shift A by COUNT limbs to the right
- * This is used only within the MPI library
- */
-void mpi_rshift_limbs(MPI a, unsigned int count)
-{
-	mpi_ptr_t ap = a->d;
-	mpi_size_t n = a->nlimbs;
-	unsigned int i;
-
-	if (count >= n) {
-		a->nlimbs = 0;
-		return;
-	}
-
-	for (i = 0; i < n - count; i++)
-		ap[i] = ap[i+count];
-	ap[i] = 0;
-	a->nlimbs -= count;
-}
-
 /*
  * Shift A by N bits to the right.
  */
@@ -241,66 +161,3 @@ void mpi_rshift(MPI x, MPI a, unsigned int n)
 	MPN_NORMALIZE(x->d, x->nlimbs);
 }
 EXPORT_SYMBOL_GPL(mpi_rshift);
-
-/****************
- * Shift A by COUNT limbs to the left
- * This is used only within the MPI library
- */
-void mpi_lshift_limbs(MPI a, unsigned int count)
-{
-	mpi_ptr_t ap;
-	int n = a->nlimbs;
-	int i;
-
-	if (!count || !n)
-		return;
-
-	RESIZE_IF_NEEDED(a, n+count);
-
-	ap = a->d;
-	for (i = n-1; i >= 0; i--)
-		ap[i+count] = ap[i];
-	for (i = 0; i < count; i++)
-		ap[i] = 0;
-	a->nlimbs += count;
-}
-
-/*
- * Shift A by N bits to the left.
- */
-void mpi_lshift(MPI x, MPI a, unsigned int n)
-{
-	unsigned int nlimbs = (n/BITS_PER_MPI_LIMB);
-	unsigned int nbits = (n%BITS_PER_MPI_LIMB);
-
-	if (x == a && !n)
-		return;  /* In-place shift with an amount of zero.  */
-
-	if (x != a) {
-		/* Copy A to X.  */
-		unsigned int alimbs = a->nlimbs;
-		int asign = a->sign;
-		mpi_ptr_t xp, ap;
-
-		RESIZE_IF_NEEDED(x, alimbs+nlimbs+1);
-		xp = x->d;
-		ap = a->d;
-		MPN_COPY(xp, ap, alimbs);
-		x->nlimbs = alimbs;
-		x->flags = a->flags;
-		x->sign = asign;
-	}
-
-	if (nlimbs && !nbits) {
-		/* Shift a full number of limbs.  */
-		mpi_lshift_limbs(x, nlimbs);
-	} else if (n) {
-		/* We use a very dump approach: Shift left by the number of
-		 * limbs plus one and than fix it up by an rshift.
-		 */
-		mpi_lshift_limbs(x, nlimbs+1);
-		mpi_rshift(x, x, BITS_PER_MPI_LIMB - nbits);
-	}
-
-	MPN_NORMALIZE(x->d, x->nlimbs);
-}
diff --git a/lib/crypto/mpi/mpi-cmp.c b/lib/crypto/mpi/mpi-cmp.c
index 0835b6213235..ceaebe181cd7 100644
--- a/lib/crypto/mpi/mpi-cmp.c
+++ b/lib/crypto/mpi/mpi-cmp.c
@@ -45,54 +45,28 @@ int mpi_cmp_ui(MPI u, unsigned long v)
 }
 EXPORT_SYMBOL_GPL(mpi_cmp_ui);
 
-static int do_mpi_cmp(MPI u, MPI v, int absmode)
+int mpi_cmp(MPI u, MPI v)
 {
-	mpi_size_t usize;
-	mpi_size_t vsize;
-	int usign;
-	int vsign;
+	mpi_size_t usize, vsize;
 	int cmp;
 
 	mpi_normalize(u);
 	mpi_normalize(v);
-
 	usize = u->nlimbs;
 	vsize = v->nlimbs;
-	usign = absmode ? 0 : u->sign;
-	vsign = absmode ? 0 : v->sign;
-
-	/* Compare sign bits.  */
-
-	if (!usign && vsign)
+	if (!u->sign && v->sign)
 		return 1;
-	if (usign && !vsign)
+	if (u->sign && !v->sign)
 		return -1;
-
-	/* U and V are either both positive or both negative.  */
-
-	if (usize != vsize && !usign && !vsign)
+	if (usize != vsize && !u->sign && !v->sign)
 		return usize - vsize;
-	if (usize != vsize && usign && vsign)
-		return vsize + usize;
+	if (usize != vsize && u->sign && v->sign)
+		return vsize - usize;
 	if (!usize)
 		return 0;
 	cmp = mpihelp_cmp(u->d, v->d, usize);
-	if (!cmp)
-		return 0;
-	if ((cmp < 0?1:0) == (usign?1:0))
-		return 1;
-
-	return -1;
-}
-
-int mpi_cmp(MPI u, MPI v)
-{
-	return do_mpi_cmp(u, v, 0);
+	if (u->sign)
+		return -cmp;
+	return cmp;
 }
 EXPORT_SYMBOL_GPL(mpi_cmp);
-
-int mpi_cmpabs(MPI u, MPI v)
-{
-	return do_mpi_cmp(u, v, 1);
-}
-EXPORT_SYMBOL_GPL(mpi_cmpabs);
diff --git a/lib/crypto/mpi/mpi-div.c b/lib/crypto/mpi/mpi-div.c
index 45beab8b9e9e..2ff0ebd74fd7 100644
--- a/lib/crypto/mpi/mpi-div.c
+++ b/lib/crypto/mpi/mpi-div.c
@@ -15,7 +15,6 @@
 #include "longlong.h"
 
 void mpi_tdiv_qr(MPI quot, MPI rem, MPI num, MPI den);
-void mpi_fdiv_qr(MPI quot, MPI rem, MPI dividend, MPI divisor);
 
 void mpi_fdiv_r(MPI rem, MPI dividend, MPI divisor)
 {
@@ -40,34 +39,6 @@ void mpi_fdiv_r(MPI rem, MPI dividend, MPI divisor)
 		mpi_free(temp_divisor);
 }
 
-void mpi_fdiv_q(MPI quot, MPI dividend, MPI divisor)
-{
-	MPI tmp = mpi_alloc(mpi_get_nlimbs(quot));
-	mpi_fdiv_qr(quot, tmp, dividend, divisor);
-	mpi_free(tmp);
-}
-
-void mpi_fdiv_qr(MPI quot, MPI rem, MPI dividend, MPI divisor)
-{
-	int divisor_sign = divisor->sign;
-	MPI temp_divisor = NULL;
-
-	if (quot == divisor || rem == divisor) {
-		temp_divisor = mpi_copy(divisor);
-		divisor = temp_divisor;
-	}
-
-	mpi_tdiv_qr(quot, rem, dividend, divisor);
-
-	if ((divisor_sign ^ dividend->sign) && rem->nlimbs) {
-		mpi_sub_ui(quot, quot, 1);
-		mpi_add(rem, rem, divisor);
-	}
-
-	if (temp_divisor)
-		mpi_free(temp_divisor);
-}
-
 /* If den == quot, den needs temporary storage.
  * If den == rem, den needs temporary storage.
  * If num == quot, num needs temporary storage.
diff --git a/lib/crypto/mpi/mpi-internal.h b/lib/crypto/mpi/mpi-internal.h
index 554002182db1..b6fbb43afbc8 100644
--- a/lib/crypto/mpi/mpi-internal.h
+++ b/lib/crypto/mpi/mpi-internal.h
@@ -66,14 +66,6 @@ typedef int mpi_size_t;		/* (must be a signed type) */
 			(d)[_i] = (s)[_i];	\
 	} while (0)
 
-#define MPN_COPY_INCR(d, s, n)		\
-	do {					\
-		mpi_size_t _i;			\
-		for (_i = 0; _i < (n); _i++)	\
-			(d)[_i] = (s)[_i];	\
-	} while (0)
-
-
 #define MPN_COPY_DECR(d, s, n) \
 	do {					\
 		mpi_size_t _i;			\
@@ -181,8 +173,6 @@ int mpihelp_mul(mpi_ptr_t prodp, mpi_ptr_t up, mpi_size_t usize,
 void mpih_sqr_n_basecase(mpi_ptr_t prodp, mpi_ptr_t up, mpi_size_t size);
 void mpih_sqr_n(mpi_ptr_t prodp, mpi_ptr_t up, mpi_size_t size,
 		mpi_ptr_t tspace);
-void mpihelp_mul_n(mpi_ptr_t prodp,
-		mpi_ptr_t up, mpi_ptr_t vp, mpi_size_t size);
 
 int mpihelp_mul_karatsuba_case(mpi_ptr_t prodp,
 			       mpi_ptr_t up, mpi_size_t usize,
diff --git a/lib/crypto/mpi/mpi-inv.c b/lib/crypto/mpi/mpi-inv.c
deleted file mode 100644
index 61e37d18f793..000000000000
--- a/lib/crypto/mpi/mpi-inv.c
+++ /dev/null
@@ -1,143 +0,0 @@
-/* mpi-inv.c  -  MPI functions
- *	Copyright (C) 1998, 2001, 2002, 2003 Free Software Foundation, Inc.
- *
- * This file is part of Libgcrypt.
- *
- * Libgcrypt is free software; you can redistribute it and/or modify
- * it under the terms of the GNU Lesser General Public License as
- * published by the Free Software Foundation; either version 2.1 of
- * the License, or (at your option) any later version.
- *
- * Libgcrypt is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-
-#include "mpi-internal.h"
-
-/****************
- * Calculate the multiplicative inverse X of A mod N
- * That is: Find the solution x for
- *		1 = (a*x) mod n
- */
-int mpi_invm(MPI x, MPI a, MPI n)
-{
-	/* Extended Euclid's algorithm (See TAOCP Vol II, 4.5.2, Alg X)
-	 * modified according to Michael Penk's solution for Exercise 35
-	 * with further enhancement
-	 */
-	MPI u, v, u1, u2 = NULL, u3, v1, v2 = NULL, v3, t1, t2 = NULL, t3;
-	unsigned int k;
-	int sign;
-	int odd;
-
-	if (!mpi_cmp_ui(a, 0))
-		return 0; /* Inverse does not exists.  */
-	if (!mpi_cmp_ui(n, 1))
-		return 0; /* Inverse does not exists.  */
-
-	u = mpi_copy(a);
-	v = mpi_copy(n);
-
-	for (k = 0; !mpi_test_bit(u, 0) && !mpi_test_bit(v, 0); k++) {
-		mpi_rshift(u, u, 1);
-		mpi_rshift(v, v, 1);
-	}
-	odd = mpi_test_bit(v, 0);
-
-	u1 = mpi_alloc_set_ui(1);
-	if (!odd)
-		u2 = mpi_alloc_set_ui(0);
-	u3 = mpi_copy(u);
-	v1 = mpi_copy(v);
-	if (!odd) {
-		v2 = mpi_alloc(mpi_get_nlimbs(u));
-		mpi_sub(v2, u1, u); /* U is used as const 1 */
-	}
-	v3 = mpi_copy(v);
-	if (mpi_test_bit(u, 0)) { /* u is odd */
-		t1 = mpi_alloc_set_ui(0);
-		if (!odd) {
-			t2 = mpi_alloc_set_ui(1);
-			t2->sign = 1;
-		}
-		t3 = mpi_copy(v);
-		t3->sign = !t3->sign;
-		goto Y4;
-	} else {
-		t1 = mpi_alloc_set_ui(1);
-		if (!odd)
-			t2 = mpi_alloc_set_ui(0);
-		t3 = mpi_copy(u);
-	}
-
-	do {
-		do {
-			if (!odd) {
-				if (mpi_test_bit(t1, 0) || mpi_test_bit(t2, 0)) {
-					/* one is odd */
-					mpi_add(t1, t1, v);
-					mpi_sub(t2, t2, u);
-				}
-				mpi_rshift(t1, t1, 1);
-				mpi_rshift(t2, t2, 1);
-				mpi_rshift(t3, t3, 1);
-			} else {
-				if (mpi_test_bit(t1, 0))
-					mpi_add(t1, t1, v);
-				mpi_rshift(t1, t1, 1);
-				mpi_rshift(t3, t3, 1);
-			}
-Y4:
-			;
-		} while (!mpi_test_bit(t3, 0)); /* while t3 is even */
-
-		if (!t3->sign) {
-			mpi_set(u1, t1);
-			if (!odd)
-				mpi_set(u2, t2);
-			mpi_set(u3, t3);
-		} else {
-			mpi_sub(v1, v, t1);
-			sign = u->sign; u->sign = !u->sign;
-			if (!odd)
-				mpi_sub(v2, u, t2);
-			u->sign = sign;
-			sign = t3->sign; t3->sign = !t3->sign;
-			mpi_set(v3, t3);
-			t3->sign = sign;
-		}
-		mpi_sub(t1, u1, v1);
-		if (!odd)
-			mpi_sub(t2, u2, v2);
-		mpi_sub(t3, u3, v3);
-		if (t1->sign) {
-			mpi_add(t1, t1, v);
-			if (!odd)
-				mpi_sub(t2, t2, u);
-		}
-	} while (mpi_cmp_ui(t3, 0)); /* while t3 != 0 */
-	/* mpi_lshift( u3, k ); */
-	mpi_set(x, u1);
-
-	mpi_free(u1);
-	mpi_free(v1);
-	mpi_free(t1);
-	if (!odd) {
-		mpi_free(u2);
-		mpi_free(v2);
-		mpi_free(t2);
-	}
-	mpi_free(u3);
-	mpi_free(v3);
-	mpi_free(t3);
-
-	mpi_free(u);
-	mpi_free(v);
-	return 1;
-}
-EXPORT_SYMBOL_GPL(mpi_invm);
diff --git a/lib/crypto/mpi/mpi-mod.c b/lib/crypto/mpi/mpi-mod.c
index 54fcc01564d9..691bbdc52fc6 100644
--- a/lib/crypto/mpi/mpi-mod.c
+++ b/lib/crypto/mpi/mpi-mod.c
@@ -5,153 +5,9 @@
  * This file is part of Libgcrypt.
  */
 
-
 #include "mpi-internal.h"
-#include "longlong.h"
-
-/* Context used with Barrett reduction.  */
-struct barrett_ctx_s {
-	MPI m;   /* The modulus - may not be modified. */
-	int m_copied;   /* If true, M needs to be released.  */
-	int k;
-	MPI y;
-	MPI r1;  /* Helper MPI. */
-	MPI r2;  /* Helper MPI. */
-	MPI r3;  /* Helper MPI allocated on demand. */
-};
-
-
 
 void mpi_mod(MPI rem, MPI dividend, MPI divisor)
 {
 	mpi_fdiv_r(rem, dividend, divisor);
 }
-
-/* This function returns a new context for Barrett based operations on
- * the modulus M.  This context needs to be released using
- * _gcry_mpi_barrett_free.  If COPY is true M will be transferred to
- * the context and the user may change M.  If COPY is false, M may not
- * be changed until gcry_mpi_barrett_free has been called.
- */
-mpi_barrett_t mpi_barrett_init(MPI m, int copy)
-{
-	mpi_barrett_t ctx;
-	MPI tmp;
-
-	mpi_normalize(m);
-	ctx = kcalloc(1, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return NULL;
-
-	if (copy) {
-		ctx->m = mpi_copy(m);
-		ctx->m_copied = 1;
-	} else
-		ctx->m = m;
-
-	ctx->k = mpi_get_nlimbs(m);
-	tmp = mpi_alloc(ctx->k + 1);
-
-	/* Barrett precalculation: y = floor(b^(2k) / m). */
-	mpi_set_ui(tmp, 1);
-	mpi_lshift_limbs(tmp, 2 * ctx->k);
-	mpi_fdiv_q(tmp, tmp, m);
-
-	ctx->y  = tmp;
-	ctx->r1 = mpi_alloc(2 * ctx->k + 1);
-	ctx->r2 = mpi_alloc(2 * ctx->k + 1);
-
-	return ctx;
-}
-
-void mpi_barrett_free(mpi_barrett_t ctx)
-{
-	if (ctx) {
-		mpi_free(ctx->y);
-		mpi_free(ctx->r1);
-		mpi_free(ctx->r2);
-		if (ctx->r3)
-			mpi_free(ctx->r3);
-		if (ctx->m_copied)
-			mpi_free(ctx->m);
-		kfree(ctx);
-	}
-}
-
-
-/* R = X mod M
- *
- * Using Barrett reduction.  Before using this function
- * _gcry_mpi_barrett_init must have been called to do the
- * precalculations.  CTX is the context created by this precalculation
- * and also conveys M.  If the Barret reduction could no be done a
- * straightforward reduction method is used.
- *
- * We assume that these conditions are met:
- * Input:  x =(x_2k-1 ...x_0)_b
- *     m =(m_k-1 ....m_0)_b	  with m_k-1 != 0
- * Output: r = x mod m
- */
-void mpi_mod_barrett(MPI r, MPI x, mpi_barrett_t ctx)
-{
-	MPI m = ctx->m;
-	int k = ctx->k;
-	MPI y = ctx->y;
-	MPI r1 = ctx->r1;
-	MPI r2 = ctx->r2;
-	int sign;
-
-	mpi_normalize(x);
-	if (mpi_get_nlimbs(x) > 2*k) {
-		mpi_mod(r, x, m);
-		return;
-	}
-
-	sign = x->sign;
-	x->sign = 0;
-
-	/* 1. q1 = floor( x / b^k-1)
-	 *    q2 = q1 * y
-	 *    q3 = floor( q2 / b^k+1 )
-	 * Actually, we don't need qx, we can work direct on r2
-	 */
-	mpi_set(r2, x);
-	mpi_rshift_limbs(r2, k-1);
-	mpi_mul(r2, r2, y);
-	mpi_rshift_limbs(r2, k+1);
-
-	/* 2. r1 = x mod b^k+1
-	 *	r2 = q3 * m mod b^k+1
-	 *	r  = r1 - r2
-	 * 3. if r < 0 then  r = r + b^k+1
-	 */
-	mpi_set(r1, x);
-	if (r1->nlimbs > k+1) /* Quick modulo operation.  */
-		r1->nlimbs = k+1;
-	mpi_mul(r2, r2, m);
-	if (r2->nlimbs > k+1) /* Quick modulo operation. */
-		r2->nlimbs = k+1;
-	mpi_sub(r, r1, r2);
-
-	if (mpi_has_sign(r)) {
-		if (!ctx->r3) {
-			ctx->r3 = mpi_alloc(k + 2);
-			mpi_set_ui(ctx->r3, 1);
-			mpi_lshift_limbs(ctx->r3, k + 1);
-		}
-		mpi_add(r, r, ctx->r3);
-	}
-
-	/* 4. while r >= m do r = r - m */
-	while (mpi_cmp(r, m) >= 0)
-		mpi_sub(r, r, m);
-
-	x->sign = sign;
-}
-
-
-void mpi_mul_barrett(MPI w, MPI u, MPI v, mpi_barrett_t ctx)
-{
-	mpi_mul(w, u, v);
-	mpi_mod_barrett(w, w, ctx);
-}
diff --git a/lib/crypto/mpi/mpicoder.c b/lib/crypto/mpi/mpicoder.c
index 3cb6bd148fa9..dde01030807d 100644
--- a/lib/crypto/mpi/mpicoder.c
+++ b/lib/crypto/mpi/mpicoder.c
@@ -25,7 +25,6 @@
 #include <linux/string.h>
 #include "mpi-internal.h"
 
-#define MAX_EXTERN_SCAN_BYTES (16*1024*1024)
 #define MAX_EXTERN_MPI_BITS 16384
 
 /**
@@ -110,112 +109,6 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 }
 EXPORT_SYMBOL_GPL(mpi_read_from_buffer);
 
-/****************
- * Fill the mpi VAL from the hex string in STR.
- */
-int mpi_fromstr(MPI val, const char *str)
-{
-	int sign = 0;
-	int prepend_zero = 0;
-	int i, j, c, c1, c2;
-	unsigned int nbits, nbytes, nlimbs;
-	mpi_limb_t a;
-
-	if (*str == '-') {
-		sign = 1;
-		str++;
-	}
-
-	/* Skip optional hex prefix.  */
-	if (*str == '0' && str[1] == 'x')
-		str += 2;
-
-	nbits = strlen(str);
-	if (nbits > MAX_EXTERN_SCAN_BYTES) {
-		mpi_clear(val);
-		return -EINVAL;
-	}
-	nbits *= 4;
-	if ((nbits % 8))
-		prepend_zero = 1;
-
-	nbytes = (nbits+7) / 8;
-	nlimbs = (nbytes+BYTES_PER_MPI_LIMB-1) / BYTES_PER_MPI_LIMB;
-
-	if (val->alloced < nlimbs)
-		mpi_resize(val, nlimbs);
-
-	i = BYTES_PER_MPI_LIMB - (nbytes % BYTES_PER_MPI_LIMB);
-	i %= BYTES_PER_MPI_LIMB;
-	j = val->nlimbs = nlimbs;
-	val->sign = sign;
-	for (; j > 0; j--) {
-		a = 0;
-		for (; i < BYTES_PER_MPI_LIMB; i++) {
-			if (prepend_zero) {
-				c1 = '0';
-				prepend_zero = 0;
-			} else
-				c1 = *str++;
-
-			if (!c1) {
-				mpi_clear(val);
-				return -EINVAL;
-			}
-			c2 = *str++;
-			if (!c2) {
-				mpi_clear(val);
-				return -EINVAL;
-			}
-			if (c1 >= '0' && c1 <= '9')
-				c = c1 - '0';
-			else if (c1 >= 'a' && c1 <= 'f')
-				c = c1 - 'a' + 10;
-			else if (c1 >= 'A' && c1 <= 'F')
-				c = c1 - 'A' + 10;
-			else {
-				mpi_clear(val);
-				return -EINVAL;
-			}
-			c <<= 4;
-			if (c2 >= '0' && c2 <= '9')
-				c |= c2 - '0';
-			else if (c2 >= 'a' && c2 <= 'f')
-				c |= c2 - 'a' + 10;
-			else if (c2 >= 'A' && c2 <= 'F')
-				c |= c2 - 'A' + 10;
-			else {
-				mpi_clear(val);
-				return -EINVAL;
-			}
-			a <<= 8;
-			a |= c;
-		}
-		i = 0;
-		val->d[j-1] = a;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mpi_fromstr);
-
-MPI mpi_scanval(const char *string)
-{
-	MPI a;
-
-	a = mpi_alloc(0);
-	if (!a)
-		return NULL;
-
-	if (mpi_fromstr(a, string)) {
-		mpi_free(a);
-		return NULL;
-	}
-	mpi_normalize(a);
-	return a;
-}
-EXPORT_SYMBOL_GPL(mpi_scanval);
-
 static int count_lzeros(MPI a)
 {
 	mpi_limb_t alimb;
@@ -521,232 +414,3 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 	return val;
 }
 EXPORT_SYMBOL_GPL(mpi_read_raw_from_sgl);
-
-/* Perform a two's complement operation on buffer P of size N bytes.  */
-static void twocompl(unsigned char *p, unsigned int n)
-{
-	int i;
-
-	for (i = n-1; i >= 0 && !p[i]; i--)
-		;
-	if (i >= 0) {
-		if ((p[i] & 0x01))
-			p[i] = (((p[i] ^ 0xfe) | 0x01) & 0xff);
-		else if ((p[i] & 0x02))
-			p[i] = (((p[i] ^ 0xfc) | 0x02) & 0xfe);
-		else if ((p[i] & 0x04))
-			p[i] = (((p[i] ^ 0xf8) | 0x04) & 0xfc);
-		else if ((p[i] & 0x08))
-			p[i] = (((p[i] ^ 0xf0) | 0x08) & 0xf8);
-		else if ((p[i] & 0x10))
-			p[i] = (((p[i] ^ 0xe0) | 0x10) & 0xf0);
-		else if ((p[i] & 0x20))
-			p[i] = (((p[i] ^ 0xc0) | 0x20) & 0xe0);
-		else if ((p[i] & 0x40))
-			p[i] = (((p[i] ^ 0x80) | 0x40) & 0xc0);
-		else
-			p[i] = 0x80;
-
-		for (i--; i >= 0; i--)
-			p[i] ^= 0xff;
-	}
-}
-
-int mpi_print(enum gcry_mpi_format format, unsigned char *buffer,
-			size_t buflen, size_t *nwritten, MPI a)
-{
-	unsigned int nbits = mpi_get_nbits(a);
-	size_t len;
-	size_t dummy_nwritten;
-	int negative;
-
-	if (!nwritten)
-		nwritten = &dummy_nwritten;
-
-	/* Libgcrypt does no always care to set clear the sign if the value
-	 * is 0.  For printing this is a bit of a surprise, in particular
-	 * because if some of the formats don't support negative numbers but
-	 * should be able to print a zero.  Thus we need this extra test
-	 * for a negative number.
-	 */
-	if (a->sign && mpi_cmp_ui(a, 0))
-		negative = 1;
-	else
-		negative = 0;
-
-	len = buflen;
-	*nwritten = 0;
-	if (format == GCRYMPI_FMT_STD) {
-		unsigned char *tmp;
-		int extra = 0;
-		unsigned int n;
-
-		tmp = mpi_get_buffer(a, &n, NULL);
-		if (!tmp)
-			return -EINVAL;
-
-		if (negative) {
-			twocompl(tmp, n);
-			if (!(*tmp & 0x80)) {
-				/* Need to extend the sign.  */
-				n++;
-				extra = 2;
-			}
-		} else if (n && (*tmp & 0x80)) {
-			/* Positive but the high bit of the returned buffer is set.
-			 * Thus we need to print an extra leading 0x00 so that the
-			 * output is interpreted as a positive number.
-			 */
-			n++;
-			extra = 1;
-		}
-
-		if (buffer && n > len) {
-			/* The provided buffer is too short. */
-			kfree(tmp);
-			return -E2BIG;
-		}
-		if (buffer) {
-			unsigned char *s = buffer;
-
-			if (extra == 1)
-				*s++ = 0;
-			else if (extra)
-				*s++ = 0xff;
-			memcpy(s, tmp, n-!!extra);
-		}
-		kfree(tmp);
-		*nwritten = n;
-		return 0;
-	} else if (format == GCRYMPI_FMT_USG) {
-		unsigned int n = (nbits + 7)/8;
-
-		/* Note:  We ignore the sign for this format.  */
-		/* FIXME: for performance reasons we should put this into
-		 * mpi_aprint because we can then use the buffer directly.
-		 */
-
-		if (buffer && n > len)
-			return -E2BIG;
-		if (buffer) {
-			unsigned char *tmp;
-
-			tmp = mpi_get_buffer(a, &n, NULL);
-			if (!tmp)
-				return -EINVAL;
-			memcpy(buffer, tmp, n);
-			kfree(tmp);
-		}
-		*nwritten = n;
-		return 0;
-	} else if (format == GCRYMPI_FMT_PGP) {
-		unsigned int n = (nbits + 7)/8;
-
-		/* The PGP format can only handle unsigned integers.  */
-		if (negative)
-			return -EINVAL;
-
-		if (buffer && n+2 > len)
-			return -E2BIG;
-
-		if (buffer) {
-			unsigned char *tmp;
-			unsigned char *s = buffer;
-
-			s[0] = nbits >> 8;
-			s[1] = nbits;
-
-			tmp = mpi_get_buffer(a, &n, NULL);
-			if (!tmp)
-				return -EINVAL;
-			memcpy(s+2, tmp, n);
-			kfree(tmp);
-		}
-		*nwritten = n+2;
-		return 0;
-	} else if (format == GCRYMPI_FMT_SSH) {
-		unsigned char *tmp;
-		int extra = 0;
-		unsigned int n;
-
-		tmp = mpi_get_buffer(a, &n, NULL);
-		if (!tmp)
-			return -EINVAL;
-
-		if (negative) {
-			twocompl(tmp, n);
-			if (!(*tmp & 0x80)) {
-				/* Need to extend the sign.  */
-				n++;
-				extra = 2;
-			}
-		} else if (n && (*tmp & 0x80)) {
-			n++;
-			extra = 1;
-		}
-
-		if (buffer && n+4 > len) {
-			kfree(tmp);
-			return -E2BIG;
-		}
-
-		if (buffer) {
-			unsigned char *s = buffer;
-
-			*s++ = n >> 24;
-			*s++ = n >> 16;
-			*s++ = n >> 8;
-			*s++ = n;
-			if (extra == 1)
-				*s++ = 0;
-			else if (extra)
-				*s++ = 0xff;
-			memcpy(s, tmp, n-!!extra);
-		}
-		kfree(tmp);
-		*nwritten = 4+n;
-		return 0;
-	} else if (format == GCRYMPI_FMT_HEX) {
-		unsigned char *tmp;
-		int i;
-		int extra = 0;
-		unsigned int n = 0;
-
-		tmp = mpi_get_buffer(a, &n, NULL);
-		if (!tmp)
-			return -EINVAL;
-		if (!n || (*tmp & 0x80))
-			extra = 2;
-
-		if (buffer && 2*n + extra + negative + 1 > len) {
-			kfree(tmp);
-			return -E2BIG;
-		}
-		if (buffer) {
-			unsigned char *s = buffer;
-
-			if (negative)
-				*s++ = '-';
-			if (extra) {
-				*s++ = '0';
-				*s++ = '0';
-			}
-
-			for (i = 0; i < n; i++) {
-				unsigned int c = tmp[i];
-
-				*s++ = (c >> 4) < 10 ? '0'+(c>>4) : 'A'+(c>>4)-10;
-				c &= 15;
-				*s++ = c < 10 ? '0'+c : 'A'+c-10;
-			}
-			*s++ = 0;
-			*nwritten = s - buffer;
-		} else {
-			*nwritten = 2*n + extra + negative + 1;
-		}
-		kfree(tmp);
-		return 0;
-	} else
-		return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(mpi_print);
diff --git a/lib/crypto/mpi/mpih-mul.c b/lib/crypto/mpi/mpih-mul.c
index e5f1c84e3c48..a93647564054 100644
--- a/lib/crypto/mpi/mpih-mul.c
+++ b/lib/crypto/mpi/mpih-mul.c
@@ -317,31 +317,6 @@ mpih_sqr_n(mpi_ptr_t prodp, mpi_ptr_t up, mpi_size_t size, mpi_ptr_t tspace)
 	}
 }
 
-
-void mpihelp_mul_n(mpi_ptr_t prodp,
-		mpi_ptr_t up, mpi_ptr_t vp, mpi_size_t size)
-{
-	if (up == vp) {
-		if (size < KARATSUBA_THRESHOLD)
-			mpih_sqr_n_basecase(prodp, up, size);
-		else {
-			mpi_ptr_t tspace;
-			tspace = mpi_alloc_limb_space(2 * size);
-			mpih_sqr_n(prodp, up, size, tspace);
-			mpi_free_limb_space(tspace);
-		}
-	} else {
-		if (size < KARATSUBA_THRESHOLD)
-			mul_n_basecase(prodp, up, vp, size);
-		else {
-			mpi_ptr_t tspace;
-			tspace = mpi_alloc_limb_space(2 * size);
-			mul_n(prodp, up, vp, size, tspace);
-			mpi_free_limb_space(tspace);
-		}
-	}
-}
-
 int
 mpihelp_mul_karatsuba_case(mpi_ptr_t prodp,
 			   mpi_ptr_t up, mpi_size_t usize,
diff --git a/lib/crypto/mpi/mpiutil.c b/lib/crypto/mpi/mpiutil.c
index aa8c46544af8..d57fd8afef64 100644
--- a/lib/crypto/mpi/mpiutil.c
+++ b/lib/crypto/mpi/mpiutil.c
@@ -20,63 +20,6 @@
 
 #include "mpi-internal.h"
 
-/* Constants allocated right away at startup.  */
-static MPI constants[MPI_NUMBER_OF_CONSTANTS];
-
-/* Initialize the MPI subsystem.  This is called early and allows to
- * do some initialization without taking care of threading issues.
- */
-static int __init mpi_init(void)
-{
-	int idx;
-	unsigned long value;
-
-	for (idx = 0; idx < MPI_NUMBER_OF_CONSTANTS; idx++) {
-		switch (idx) {
-		case MPI_C_ZERO:
-			value = 0;
-			break;
-		case MPI_C_ONE:
-			value = 1;
-			break;
-		case MPI_C_TWO:
-			value = 2;
-			break;
-		case MPI_C_THREE:
-			value = 3;
-			break;
-		case MPI_C_FOUR:
-			value = 4;
-			break;
-		case MPI_C_EIGHT:
-			value = 8;
-			break;
-		default:
-			pr_err("MPI: invalid mpi_const selector %d\n", idx);
-			return -EFAULT;
-		}
-		constants[idx] = mpi_alloc_set_ui(value);
-		constants[idx]->flags = (16|32);
-	}
-
-	return 0;
-}
-postcore_initcall(mpi_init);
-
-/* Return a constant MPI descripbed by NO which is one of the
- * MPI_C_xxx macros.  There is no need to copy this returned value; it
- * may be used directly.
- */
-MPI mpi_const(enum gcry_mpi_constants no)
-{
-	if ((int)no < 0 || no > MPI_NUMBER_OF_CONSTANTS)
-		pr_err("MPI: invalid mpi_const selector %d\n", no);
-	if (!constants[no])
-		pr_err("MPI: MPI subsystem not initialized\n");
-	return constants[no];
-}
-EXPORT_SYMBOL_GPL(mpi_const);
-
 /****************
  * Note:  It was a bad idea to use the number of limbs to allocate
  *	  because on a alpha the limbs are large but we normally need
@@ -163,15 +106,6 @@ int mpi_resize(MPI a, unsigned nlimbs)
 	return 0;
 }
 
-void mpi_clear(MPI a)
-{
-	if (!a)
-		return;
-	a->nlimbs = 0;
-	a->flags = 0;
-}
-EXPORT_SYMBOL_GPL(mpi_clear);
-
 void mpi_free(MPI a)
 {
 	if (!a)
@@ -210,121 +144,5 @@ MPI mpi_copy(MPI a)
 	return b;
 }
 
-/****************
- * This function allocates an MPI which is optimized to hold
- * a value as large as the one given in the argument and allocates it
- * with the same flags as A.
- */
-MPI mpi_alloc_like(MPI a)
-{
-	MPI b;
-
-	if (a) {
-		b = mpi_alloc(a->nlimbs);
-		b->nlimbs = 0;
-		b->sign = 0;
-		b->flags = a->flags;
-	} else
-		b = NULL;
-
-	return b;
-}
-
-
-/* Set U into W and release U.  If W is NULL only U will be released. */
-void mpi_snatch(MPI w, MPI u)
-{
-	if (w) {
-		mpi_assign_limb_space(w, u->d, u->alloced);
-		w->nlimbs = u->nlimbs;
-		w->sign   = u->sign;
-		w->flags  = u->flags;
-		u->alloced = 0;
-		u->nlimbs = 0;
-		u->d = NULL;
-	}
-	mpi_free(u);
-}
-
-
-MPI mpi_set(MPI w, MPI u)
-{
-	mpi_ptr_t wp, up;
-	mpi_size_t usize = u->nlimbs;
-	int usign = u->sign;
-
-	if (!w)
-		w = mpi_alloc(mpi_get_nlimbs(u));
-	RESIZE_IF_NEEDED(w, usize);
-	wp = w->d;
-	up = u->d;
-	MPN_COPY(wp, up, usize);
-	w->nlimbs = usize;
-	w->flags = u->flags;
-	w->flags &= ~(16|32); /* Reset the immutable and constant flags.  */
-	w->sign = usign;
-	return w;
-}
-EXPORT_SYMBOL_GPL(mpi_set);
-
-MPI mpi_set_ui(MPI w, unsigned long u)
-{
-	if (!w)
-		w = mpi_alloc(1);
-	/* FIXME: If U is 0 we have no need to resize and thus possible
-	 * allocating the limbs.
-	 */
-	RESIZE_IF_NEEDED(w, 1);
-	w->d[0] = u;
-	w->nlimbs = u ? 1 : 0;
-	w->sign = 0;
-	w->flags = 0;
-	return w;
-}
-EXPORT_SYMBOL_GPL(mpi_set_ui);
-
-MPI mpi_alloc_set_ui(unsigned long u)
-{
-	MPI w = mpi_alloc(1);
-	w->d[0] = u;
-	w->nlimbs = u ? 1 : 0;
-	w->sign = 0;
-	return w;
-}
-
-/****************
- * Swap the value of A and B, when SWAP is 1.
- * Leave the value when SWAP is 0.
- * This implementation should be constant-time regardless of SWAP.
- */
-void mpi_swap_cond(MPI a, MPI b, unsigned long swap)
-{
-	mpi_size_t i;
-	mpi_size_t nlimbs;
-	mpi_limb_t mask = ((mpi_limb_t)0) - swap;
-	mpi_limb_t x;
-
-	if (a->alloced > b->alloced)
-		nlimbs = b->alloced;
-	else
-		nlimbs = a->alloced;
-	if (a->nlimbs > nlimbs || b->nlimbs > nlimbs)
-		return;
-
-	for (i = 0; i < nlimbs; i++) {
-		x = mask & (a->d[i] ^ b->d[i]);
-		a->d[i] = a->d[i] ^ x;
-		b->d[i] = b->d[i] ^ x;
-	}
-
-	x = mask & (a->nlimbs ^ b->nlimbs);
-	a->nlimbs = a->nlimbs ^ x;
-	b->nlimbs = b->nlimbs ^ x;
-
-	x = mask & (a->sign ^ b->sign);
-	a->sign = a->sign ^ x;
-	b->sign = b->sign ^ x;
-}
-
 MODULE_DESCRIPTION("Multiprecision maths library");
 MODULE_LICENSE("GPL");
-- 
2.39.2

