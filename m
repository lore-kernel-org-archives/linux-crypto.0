From: Shane Wang <shane.wang@intel.com>
Subject: Re: [RFC PATCH v2] crypto: Add VMAC(AES) to Linux for intel_txt support
Date: Sat, 22 Aug 2009 21:02:29 +0800
Message-ID: <4A8FEC65.1080806@intel.com>
References: <4A5F41C4.3050808@intel.com> <4A5F431B.6060307@intel.com> <4A805375.4030902@intel.com> <20090814032201.GA2544@gondor.apana.org.au> <4A85955F.3040807@intel.com> <20090820100949.GA31928@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Cihula, Joseph" <joseph.cihula@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbZHVNCa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 22 Aug 2009 09:02:30 -0400
In-Reply-To: <20090820100949.GA31928@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> In this case, you may not even need them as gcc is capable of
> optimising
> 
Yes, I agree.

Thanks.
Shane


Resend:
This patch adds VMAC (a fast MAC) support into crypto framework.

---

  b/crypto/vmac.c         |  678 ++++++++++++++++++++++++++++++++++++++++++++++++
  b/include/crypto/vmac.h |   61 ++++
  crypto/Kconfig          |   12
  crypto/Makefile         |    1
  crypto/tcrypt.c         |    4
  crypto/testmgr.c        |    9
  crypto/testmgr.h        |   16 +
  7 files changed, 781 insertions(+)

Signed-off-by: Shane Wang <shane.wang@intel.com>
Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>


diff -r 7ccb4aa6908f crypto/Kconfig
--- a/crypto/Kconfig	Wed Aug 05 15:43:38 2009 -0700
+++ b/crypto/Kconfig	Thu Aug 20 19:56:44 2009 -0700
@@ -267,6 +267,18 @@ config CRYPTO_XCBC
  		http://www.ietf.org/rfc/rfc3566.txt
  		http://csrc.nist.gov/encryption/modes/proposedmodes/
  		 xcbc-mac/xcbc-mac-spec.pdf
+
+config CRYPTO_VMAC
+	tristate "VMAC support"
+	depends on EXPERIMENTAL
+	select CRYPTO_HASH
+	select CRYPTO_MANAGER
+	help
+	  VMAC is a message authentication algorithm designed for
+	  very high speed on 64-bit architectures.
+
+	  See also:
+	  <http://fastcrypto.org/vmac>

  comment "Digest"

diff -r 7ccb4aa6908f crypto/Makefile
--- a/crypto/Makefile	Wed Aug 05 15:43:38 2009 -0700
+++ b/crypto/Makefile	Thu Aug 20 19:56:44 2009 -0700
@@ -32,6 +32,7 @@ cryptomgr-objs := algboss.o testmgr.o

  obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
  obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
+obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
  obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
  obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o
  obj-$(CONFIG_CRYPTO_MD4) += md4.o
diff -r 7ccb4aa6908f crypto/tcrypt.c
--- a/crypto/tcrypt.c	Wed Aug 05 15:43:38 2009 -0700
+++ b/crypto/tcrypt.c	Thu Aug 20 19:56:44 2009 -0700
@@ -719,6 +719,10 @@ static int do_test(int m)
  		ret += tcrypt_test("hmac(rmd160)");
  		break;

+	case 109:
+		ret += tcrypt_test("vmac(aes)");
+		break;
+
  	case 150:
  		ret += tcrypt_test("ansi_cprng");
  		break;
diff -r 7ccb4aa6908f crypto/testmgr.c
--- a/crypto/testmgr.c	Wed Aug 05 15:43:38 2009 -0700
+++ b/crypto/testmgr.c	Thu Aug 20 19:56:44 2009 -0700
@@ -2248,6 +2248,15 @@ static const struct alg_test_desc alg_te
  			}
  		}
  	}, {
+		.alg = "vmac(aes)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = aes_vmac128_tv_template,
+				.count = VMAC_AES_TEST_VECTORS
+			}
+		}
+	}, {
  		.alg = "wp256",
  		.test = alg_test_hash,
  		.suite = {
diff -r 7ccb4aa6908f crypto/testmgr.h
--- a/crypto/testmgr.h	Wed Aug 05 15:43:38 2009 -0700
+++ b/crypto/testmgr.h	Thu Aug 20 19:56:44 2009 -0700
@@ -1652,6 +1652,22 @@ static struct hash_testvec aes_xcbc128_t
  		.np	= 2,
  		.ksize	= 16,
  	}
+};
+
+#define VMAC_AES_TEST_VECTORS	1
+static char vmac_string[128] = {'\x01', '\x01', '\x01', '\x01',
+				'\x02', '\x03', '\x02', '\x02',
+				'\x02', '\x04', '\x01', '\x07',
+				'\x04', '\x01', '\x04', '\x03',};
+static struct hash_testvec aes_vmac128_tv_template[] = {
+	{
+		.key    = "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.plaintext = vmac_string,
+		.digest = "\xcb\xd7\x8a\xfd\xb7\x33\x79\xe7",
+		.psize  = 128,
+		.ksize  = 16,
+	},
  };

  /*
diff -r 7ccb4aa6908f crypto/vmac.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/crypto/vmac.c	Thu Aug 20 19:56:44 2009 -0700
@@ -0,0 +1,678 @@
+/*
+ * Modified to interface to the Linux kernel
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+/* --------------------------------------------------------------------------
+ * VMAC and VHASH Implementation by Ted Krovetz (tdk@acm.org) and Wei Dai.
+ * This implementation is herby placed in the public domain.
+ * The authors offers no warranty. Use at your own risk.
+ * Please send bug reports to the authors.
+ * Last modified: 17 APR 08, 1700 PDT
+ * ----------------------------------------------------------------------- */
+
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <asm/byteorder.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/vmac.h>
+#include <crypto/internal/hash.h>
+
+/*
+ * Constants and masks
+ */
+#define UINT64_C(x) x##ULL
+const u64 p64   = UINT64_C(0xfffffffffffffeff);  /* 2^64 - 257 prime  */
+const u64 m62   = UINT64_C(0x3fffffffffffffff);  /* 62-bit mask       */
+const u64 m63   = UINT64_C(0x7fffffffffffffff);  /* 63-bit mask       */
+const u64 m64   = UINT64_C(0xffffffffffffffff);  /* 64-bit mask       */
+const u64 mpoly = UINT64_C(0x1fffffff1fffffff);  /* Poly key mask     */
+
+#ifdef __LITTLE_ENDIAN
+#define INDEX_HIGH 1
+#define INDEX_LOW 0
+#else
+#define INDEX_HIGH 0
+#define INDEX_LOW 1
+#endif
+
+/*
+ * The following routines are used in this implementation. They are
+ * written via macros to simulate zero-overhead call-by-reference.
+ *
+ * MUL64: 64x64->128-bit multiplication
+ * PMUL64: assumes top bits cleared on inputs
+ * ADD128: 128x128->128-bit addition
+ */
+
+#define ADD128(rh, rl, ih, il)						\
+	do {								\
+		u64 _il = (il);						\
+		(rl) += (_il);						\
+		if ((rl) < (_il))					\
+			(rh)++;						\
+		(rh) += (ih);						\
+	} while (0)
+
+#define MUL32(i1, i2)	((u64)(u32)(i1)*(u32)(i2))
+
+#define PMUL64(rh, rl, i1, i2)	/* Assumes m doesn't overflow */	\
+	do {								\
+		u64 _i1 = (i1), _i2 = (i2);				\
+		u64 m = MUL32(_i1, _i2>>32) + MUL32(_i1>>32, _i2);	\
+		rh = MUL32(_i1>>32, _i2>>32);				\
+		rl = MUL32(_i1, _i2);					\
+		ADD128(rh, rl, (m >> 32), (m << 32));			\
+	} while (0)
+
+#define MUL64(rh, rl, i1, i2)						\
+	do {								\
+		u64 _i1 = (i1), _i2 = (i2);				\
+		u64 m1 = MUL32(_i1, _i2>>32);				\
+		u64 m2 = MUL32(_i1>>32, _i2);				\
+		rh = MUL32(_i1>>32, _i2>>32);				\
+		rl = MUL32(_i1, _i2);					\
+		ADD128(rh, rl, (m1 >> 32), (m1 << 32));			\
+		ADD128(rh, rl, (m2 >> 32), (m2 << 32));			\
+	} while (0)
+
+/*
+ * For highest performance the L1 NH and L2 polynomial hashes should be
+ * carefully implemented to take advantage of one's target architechture.
+ * Here these two hash functions are defined multiple time; once for
+ * 64-bit architectures, once for 32-bit SSE2 architectures, and once
+ * for the rest (32-bit) architectures.
+ * For each, nh_16 *must* be defined (works on multiples of 16 bytes).
+ * Optionally, nh_vmac_nhbytes can be defined (for multiples of
+ * VMAC_NHBYTES), and nh_16_2 and nh_vmac_nhbytes_2 (versions that do two
+ * NH computations at once).
+ */
+
+#ifdef CONFIG_64BIT
+
+#define nh_16(mp, kp, nw, rh, rl)					\
+	do {								\
+		int i; u64 th, tl;					\
+		rh = rl = 0;						\
+		for (i = 0; i < nw; i += 2) {				\
+			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i],	\
+				le64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
+			ADD128(rh, rl, th, tl);				\
+		}							\
+	} while (0)
+
+#define nh_16_2(mp, kp, nw, rh, rl, rh1, rl1)				\
+	do {								\
+		int i; u64 th, tl;					\
+		rh1 = rl1 = rh = rl = 0;				\
+		for (i = 0; i < nw; i += 2) {				\
+			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i],	\
+				le64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
+			ADD128(rh, rl, th, tl);				\
+			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i+2],	\
+				le64_to_cpup((mp)+i+1)+(kp)[i+3]);	\
+			ADD128(rh1, rl1, th, tl);			\
+		}							\
+	} while (0)
+
+#if (VMAC_NHBYTES >= 64) /* These versions do 64-bytes of message at a time */
+#define nh_vmac_nhbytes(mp, kp, nw, rh, rl)				\
+	do {								\
+		int i; u64 th, tl;					\
+		rh = rl = 0;						\
+		for (i = 0; i < nw; i += 8) {				\
+			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i],	\
+				le64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
+			ADD128(rh, rl, th, tl);				\
+			MUL64(th, tl, le64_to_cpup((mp)+i+2)+(kp)[i+2],	\
+				le64_to_cpup((mp)+i+3)+(kp)[i+3]);	\
+			ADD128(rh, rl, th, tl);				\
+			MUL64(th, tl, le64_to_cpup((mp)+i+4)+(kp)[i+4],	\
+				le64_to_cpup((mp)+i+5)+(kp)[i+5]);	\
+			ADD128(rh, rl, th, tl);				\
+			MUL64(th, tl, le64_to_cpup((mp)+i+6)+(kp)[i+6],	\
+				le64_to_cpup((mp)+i+7)+(kp)[i+7]);	\
+			ADD128(rh, rl, th, tl);				\
+		}							\
+	} while (0)
+
+#define nh_vmac_nhbytes_2(mp, kp, nw, rh, rl, rh1, rl1)			\
+	do {								\
+		int i; u64 th, tl;					\
+		rh1 = rl1 = rh = rl = 0;				\
+		for (i = 0; i < nw; i += 8) {				\
+			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i],	\
+				le64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
+			ADD128(rh, rl, th, tl);				\
+			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i+2],	\
+				le64_to_cpup((mp)+i+1)+(kp)[i+3]);	\
+			ADD128(rh1, rl1, th, tl);			\
+			MUL64(th, tl, le64_to_cpup((mp)+i+2)+(kp)[i+2],	\
+				le64_to_cpup((mp)+i+3)+(kp)[i+3]);	\
+			ADD128(rh, rl, th, tl);				\
+			MUL64(th, tl, le64_to_cpup((mp)+i+2)+(kp)[i+4],	\
+				le64_to_cpup((mp)+i+3)+(kp)[i+5]);	\
+			ADD128(rh1, rl1, th, tl);			\
+			MUL64(th, tl, le64_to_cpup((mp)+i+4)+(kp)[i+4],	\
+				le64_to_cpup((mp)+i+5)+(kp)[i+5]);	\
+			ADD128(rh, rl, th, tl);				\
+			MUL64(th, tl, le64_to_cpup((mp)+i+4)+(kp)[i+6],	\
+				le64_to_cpup((mp)+i+5)+(kp)[i+7]);	\
+			ADD128(rh1, rl1, th, tl);			\
+			MUL64(th, tl, le64_to_cpup((mp)+i+6)+(kp)[i+6],	\
+				le64_to_cpup((mp)+i+7)+(kp)[i+7]);	\
+			ADD128(rh, rl, th, tl);				\
+			MUL64(th, tl, le64_to_cpup((mp)+i+6)+(kp)[i+8],	\
+				le64_to_cpup((mp)+i+7)+(kp)[i+9]);	\
+			ADD128(rh1, rl1, th, tl);			\
+		}							\
+	} while (0)
+#endif
+
+#define poly_step(ah, al, kh, kl, mh, ml)				\
+	do {								\
+		u64 t1h, t1l, t2h, t2l, t3h, t3l, z = 0;		\
+		/* compute ab*cd, put bd into result registers */	\
+		PMUL64(t3h, t3l, al, kh);				\
+		PMUL64(t2h, t2l, ah, kl);				\
+		PMUL64(t1h, t1l, ah, 2*kh);				\
+		PMUL64(ah, al, al, kl);					\
+		/* add 2 * ac to result */				\
+		ADD128(ah, al, t1h, t1l);				\
+		/* add together ad + bc */				\
+		ADD128(t2h, t2l, t3h, t3l);				\
+		/* now (ah,al), (t2l,2*t2h) need summing */		\
+		/* first add the high registers, carrying into t2h */	\
+		ADD128(t2h, ah, z, t2l);				\
+		/* double t2h and add top bit of ah */			\
+		t2h = 2 * t2h + (ah >> 63);				\
+		ah &= m63;						\
+		/* now add the low registers */				\
+		ADD128(ah, al, mh, ml);					\
+		ADD128(ah, al, z, t2h);					\
+	} while (0)
+
+#else /* ! CONFIG_64BIT */
+
+#ifndef nh_16
+#define nh_16(mp, kp, nw, rh, rl)					\
+	do {								\
+		u64 t1, t2, m1, m2, t;					\
+		int i;							\
+		rh = rl = t = 0;					\
+		for (i = 0; i < nw; i += 2)  {				\
+			t1 = le64_to_cpup(mp+i) + kp[i];		\
+			t2 = le64_to_cpup(mp+i+1) + kp[i+1];		\
+			m2 = MUL32(t1 >> 32, t2);			\
+			m1 = MUL32(t1, t2 >> 32);			\
+			ADD128(rh, rl, MUL32(t1 >> 32, t2 >> 32),	\
+				MUL32(t1, t2));				\
+			rh += (u64)(u32)(m1 >> 32)			\
+				+ (u32)(m2 >> 32);			\
+			t += (u64)(u32)m1 + (u32)m2;			\
+		}							\
+		ADD128(rh, rl, (t >> 32), (t << 32));			\
+	} while (0)
+#endif
+
+static void poly_step_func(u64 *ahi, u64 *alo,
+			const u64 *kh, const u64 *kl,
+			const u64 *mh, const u64 *ml)
+{
+#define a0 (*(((u32 *)alo)+INDEX_LOW))
+#define a1 (*(((u32 *)alo)+INDEX_HIGH))
+#define a2 (*(((u32 *)ahi)+INDEX_LOW))
+#define a3 (*(((u32 *)ahi)+INDEX_HIGH))
+#define k0 (*(((u32 *)kl)+INDEX_LOW))
+#define k1 (*(((u32 *)kl)+INDEX_HIGH))
+#define k2 (*(((u32 *)kh)+INDEX_LOW))
+#define k3 (*(((u32 *)kh)+INDEX_HIGH))
+
+	u64 p, q, t;
+	u32 t2;
+
+	p = MUL32(a3, k3);
+	p += p;
+	p += *(u64 *)mh;
+	p += MUL32(a0, k2);
+	p += MUL32(a1, k1);
+	p += MUL32(a2, k0);
+	t = (u32)(p);
+	p >>= 32;
+	p += MUL32(a0, k3);
+	p += MUL32(a1, k2);
+	p += MUL32(a2, k1);
+	p += MUL32(a3, k0);
+	t |= ((u64)((u32)p & 0x7fffffff)) << 32;
+	p >>= 31;
+	p += (u64)(((u32 *)ml)[INDEX_LOW]);
+	p += MUL32(a0, k0);
+	q =  MUL32(a1, k3);
+	q += MUL32(a2, k2);
+	q += MUL32(a3, k1);
+	q += q;
+	p += q;
+	t2 = (u32)(p);
+	p >>= 32;
+	p += (u64)(((u32 *)ml)[INDEX_HIGH]);
+	p += MUL32(a0, k1);
+	p += MUL32(a1, k0);
+	q =  MUL32(a2, k3);
+	q += MUL32(a3, k2);
+	q += q;
+	p += q;
+	*(u64 *)(alo) = (p << 32) | t2;
+	p >>= 32;
+	*(u64 *)(ahi) = p + t;
+
+#undef a0
+#undef a1
+#undef a2
+#undef a3
+#undef k0
+#undef k1
+#undef k2
+#undef k3
+}
+
+#define poly_step(ah, al, kh, kl, mh, ml)				\
+	poly_step_func(&(ah), &(al), &(kh), &(kl), &(mh), &(ml))
+
+#endif  /* end of specialized NH and poly definitions */
+
+/* At least nh_16 is defined. Defined others as needed here */
+#ifndef nh_16_2
+#define nh_16_2(mp, kp, nw, rh, rl, rh2, rl2)				\
+	do { 								\
+		nh_16(mp, kp, nw, rh, rl);				\
+		nh_16(mp, ((kp)+2), nw, rh2, rl2);			\
+	} while (0)
+#endif
+#ifndef nh_vmac_nhbytes
+#define nh_vmac_nhbytes(mp, kp, nw, rh, rl)				\
+	nh_16(mp, kp, nw, rh, rl)
+#endif
+#ifndef nh_vmac_nhbytes_2
+#define nh_vmac_nhbytes_2(mp, kp, nw, rh, rl, rh2, rl2)			\
+	do {								\
+		nh_vmac_nhbytes(mp, kp, nw, rh, rl);			\
+		nh_vmac_nhbytes(mp, ((kp)+2), nw, rh2, rl2);		\
+	} while (0)
+#endif
+
+static void vhash_abort(struct vmac_ctx *ctx)
+{
+	ctx->polytmp[0] = ctx->polykey[0] ;
+	ctx->polytmp[1] = ctx->polykey[1] ;
+	ctx->first_block_processed = 0;
+}
+
+static u64 l3hash(u64 p1, u64 p2,
+			u64 k1, u64 k2, u64 len)
+{
+	u64 rh, rl, t, z = 0;
+
+	/* fully reduce (p1,p2)+(len,0) mod p127 */
+	t = p1 >> 63;
+	p1 &= m63;
+	ADD128(p1, p2, len, t);
+	/* At this point, (p1,p2) is at most 2^127+(len<<64) */
+	t = (p1 > m63) + ((p1 == m63) && (p2 == m64));
+	ADD128(p1, p2, z, t);
+	p1 &= m63;
+
+	/* compute (p1,p2)/(2^64-2^32) and (p1,p2)%(2^64-2^32) */
+	t = p1 + (p2 >> 32);
+	t += (t >> 32);
+	t += (u32)t > 0xfffffffeu;
+	p1 += (t >> 32);
+	p2 += (p1 << 32);
+
+	/* compute (p1+k1)%p64 and (p2+k2)%p64 */
+	p1 += k1;
+	p1 += (0 - (p1 < k1)) & 257;
+	p2 += k2;
+	p2 += (0 - (p2 < k2)) & 257;
+
+	/* compute (p1+k1)*(p2+k2)%p64 */
+	MUL64(rh, rl, p1, p2);
+	t = rh >> 56;
+	ADD128(t, rl, z, rh);
+	rh <<= 8;
+	ADD128(t, rl, z, rh);
+	t += t << 8;
+	rl += t;
+	rl += (0 - (rl < t)) & 257;
+	rl += (0 - (rl > p64-1)) & 257;
+	return rl;
+}
+
+static void vhash_update(const unsigned char *m,
+			unsigned int mbytes, /* Pos multiple of VMAC_NHBYTES */
+			struct vmac_ctx *ctx)
+{
+	u64 rh, rl, *mptr;
+	const u64 *kptr = (u64 *)ctx->nhkey;
+	int i;
+	u64 ch, cl;
+	u64 pkh = ctx->polykey[0];
+	u64 pkl = ctx->polykey[1];
+
+	mptr = (u64 *)m;
+	i = mbytes / VMAC_NHBYTES;  /* Must be non-zero */
+
+	ch = ctx->polytmp[0];
+	cl = ctx->polytmp[1];
+
+	if (!ctx->first_block_processed) {
+		ctx->first_block_processed = 1;
+		nh_vmac_nhbytes(mptr, kptr, VMAC_NHBYTES/8, rh, rl);
+		rh &= m62;
+		ADD128(ch, cl, rh, rl);
+		mptr += (VMAC_NHBYTES/sizeof(u64));
+		i--;
+	}
+
+	while (i--) {
+		nh_vmac_nhbytes(mptr, kptr, VMAC_NHBYTES/8, rh, rl);
+		rh &= m62;
+		poly_step(ch, cl, pkh, pkl, rh, rl);
+		mptr += (VMAC_NHBYTES/sizeof(u64));
+	}
+
+	ctx->polytmp[0] = ch;
+	ctx->polytmp[1] = cl;
+}
+
+static u64 vhash(unsigned char m[], unsigned int mbytes,
+			u64 *tagl, struct vmac_ctx *ctx)
+{
+	u64 rh, rl, *mptr;
+	const u64 *kptr = (u64 *)ctx->nhkey;
+	int i, remaining;
+	u64 ch, cl;
+	u64 pkh = ctx->polykey[0];
+	u64 pkl = ctx->polykey[1];
+
+	mptr = (u64 *)m;
+	i = mbytes / VMAC_NHBYTES;
+	remaining = mbytes % VMAC_NHBYTES;
+
+	if (ctx->first_block_processed) {
+		ch = ctx->polytmp[0];
+		cl = ctx->polytmp[1];
+	} else if (i) {
+		nh_vmac_nhbytes(mptr, kptr, VMAC_NHBYTES/8, ch, cl);
+		ch &= m62;
+		ADD128(ch, cl, pkh, pkl);
+		mptr += (VMAC_NHBYTES/sizeof(u64));
+		i--;
+	} else if (remaining) {
+		nh_16(mptr, kptr, 2*((remaining+15)/16), ch, cl);
+		ch &= m62;
+		ADD128(ch, cl, pkh, pkl);
+		mptr += (VMAC_NHBYTES/sizeof(u64));
+		goto do_l3;
+	} else {/* Empty String */
+		ch = pkh; cl = pkl;
+		goto do_l3;
+	}
+
+	while (i--) {
+		nh_vmac_nhbytes(mptr, kptr, VMAC_NHBYTES/8, rh, rl);
+		rh &= m62;
+		poly_step(ch, cl, pkh, pkl, rh, rl);
+		mptr += (VMAC_NHBYTES/sizeof(u64));
+	}
+	if (remaining) {
+		nh_16(mptr, kptr, 2*((remaining+15)/16), rh, rl);
+		rh &= m62;
+		poly_step(ch, cl, pkh, pkl, rh, rl);
+	}
+
+do_l3:
+	vhash_abort(ctx);
+	remaining *= 8;
+	return l3hash(ch, cl, ctx->l3key[0], ctx->l3key[1], remaining);
+}
+
+static u64 vmac(unsigned char m[], unsigned int mbytes,
+			unsigned char n[16], u64 *tagl,
+			struct vmac_ctx_t *ctx)
+{
+	u64 *in_n, *out_p;
+	u64 p, h;
+	int i;
+
+	in_n = ctx->__vmac_ctx.cached_nonce;
+	out_p = ctx->__vmac_ctx.cached_aes;
+
+	i = n[15] & 1;
+	if ((*(u64 *)(n+8) != in_n[1]) || (*(u64 *)(n) != in_n[0])) {
+		in_n[0] = *(u64 *)(n);
+		in_n[1] = *(u64 *)(n+8);
+		((unsigned char *)in_n)[15] &= 0xFE;
+		crypto_cipher_encrypt_one(ctx->child,
+			(unsigned char *)out_p, (unsigned char *)in_n);
+
+		((unsigned char *)in_n)[15] |= (unsigned char)(1-i);
+	}
+	p = be64_to_cpup(out_p + i);
+	h = vhash(m, mbytes, (u64 *)0, &ctx->__vmac_ctx);
+	return p + h;
+}
+
+static int vmac_set_key(unsigned char user_key[], struct vmac_ctx_t *ctx)
+{
+	u64 in[2] = {0}, out[2];
+	unsigned i;
+	int err = 0;
+
+	err = crypto_cipher_setkey(ctx->child, user_key, VMAC_KEY_LEN);
+	if (err)
+		return err;
+
+	/* Fill nh key */
+	((unsigned char *)in)[0] = 0x80;
+	for (i = 0; i < sizeof(ctx->__vmac_ctx.nhkey)/8; i += 2) {
+		crypto_cipher_encrypt_one(ctx->child,
+			(unsigned char *)out, (unsigned char *)in);
+		ctx->__vmac_ctx.nhkey[i] = be64_to_cpup(out);
+		ctx->__vmac_ctx.nhkey[i+1] = be64_to_cpup(out+1);
+		((unsigned char *)in)[15] += 1;
+	}
+
+	/* Fill poly key */
+	((unsigned char *)in)[0] = 0xC0;
+	in[1] = 0;
+	for (i = 0; i < sizeof(ctx->__vmac_ctx.polykey)/8; i += 2) {
+		crypto_cipher_encrypt_one(ctx->child,
+			(unsigned char *)out, (unsigned char *)in);
+		ctx->__vmac_ctx.polytmp[i] =
+			ctx->__vmac_ctx.polykey[i] =
+				be64_to_cpup(out) & mpoly;
+		ctx->__vmac_ctx.polytmp[i+1] =
+			ctx->__vmac_ctx.polykey[i+1] =
+				be64_to_cpup(out+1) & mpoly;
+		((unsigned char *)in)[15] += 1;
+	}
+
+	/* Fill ip key */
+	((unsigned char *)in)[0] = 0xE0;
+	in[1] = 0;
+	for (i = 0; i < sizeof(ctx->__vmac_ctx.l3key)/8; i += 2) {
+		do {
+			crypto_cipher_encrypt_one(ctx->child,
+				(unsigned char *)out, (unsigned char *)in);
+			ctx->__vmac_ctx.l3key[i] = be64_to_cpup(out);
+			ctx->__vmac_ctx.l3key[i+1] = be64_to_cpup(out+1);
+			((unsigned char *)in)[15] += 1;
+		} while (ctx->__vmac_ctx.l3key[i] >= p64
+			|| ctx->__vmac_ctx.l3key[i+1] >= p64);
+	}
+
+	/* Invalidate nonce/aes cache and reset other elements */
+	ctx->__vmac_ctx.cached_nonce[0] = (u64)-1; /* Ensure illegal nonce */
+	ctx->__vmac_ctx.cached_nonce[1] = (u64)0;  /* Ensure illegal nonce */
+	ctx->__vmac_ctx.first_block_processed = 0;
+
+	return err;
+}
+
+static int vmac_setkey(struct crypto_shash *parent,
+		const u8 *key, unsigned int keylen)
+{
+	struct vmac_ctx_t *ctx = crypto_shash_ctx(parent);
+
+	if (keylen != VMAC_KEY_LEN) {
+		crypto_shash_set_flags(parent, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	return vmac_set_key((u8 *)key, ctx);
+}
+
+static int vmac_init(struct shash_desc *pdesc)
+{
+	struct crypto_shash *parent = pdesc->tfm;
+	struct vmac_ctx_t *ctx = crypto_shash_ctx(parent);
+
+	memset(&ctx->__vmac_ctx, 0, sizeof(struct vmac_ctx));
+	return 0;
+}
+
+static int vmac_update(struct shash_desc *pdesc, const u8 *p,
+		unsigned int len)
+{
+	struct crypto_shash *parent = pdesc->tfm;
+	struct vmac_ctx_t *ctx = crypto_shash_ctx(parent);
+
+	vhash_update(p, len, &ctx->__vmac_ctx);
+
+	return 0;
+}
+
+static int vmac_final(struct shash_desc *pdesc, u8 *out)
+{
+	struct crypto_shash *parent = pdesc->tfm;
+	struct vmac_ctx_t *ctx = crypto_shash_ctx(parent);
+	vmac_t mac;
+	u8 nonce[16] = {};
+
+	mac = vmac(NULL, 0, nonce, NULL, ctx);
+	memcpy(out, &mac, sizeof(vmac_t));
+	memset(&mac, 0, sizeof(vmac_t));
+	memset(&ctx->__vmac_ctx, 0, sizeof(struct vmac_ctx));
+	return 0;
+}
+
+static int vmac_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_cipher *cipher;
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct vmac_ctx_t *ctx = crypto_tfm_ctx(tfm);
+
+	cipher = crypto_spawn_cipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+	return 0;
+}
+
+static void vmac_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct vmac_ctx_t *ctx = crypto_tfm_ctx(tfm);
+	crypto_free_cipher(ctx->child);
+}
+
+static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	struct shash_instance *inst;
+	struct crypto_alg *alg;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
+	if (err)
+		return err;
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+			CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(alg))
+		return PTR_ERR(alg);
+
+	inst = shash_alloc_instance("vmac", alg);
+	err = PTR_ERR(inst);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	err = crypto_init_spawn(shash_instance_ctx(inst), alg,
+			shash_crypto_instance(inst),
+			CRYPTO_ALG_TYPE_MASK);
+	if (err)
+		goto out_free_inst;
+
+	inst->alg.base.cra_priority = alg->cra_priority;
+	inst->alg.base.cra_blocksize = alg->cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->cra_alignmask;
+
+	inst->alg.digestsize = sizeof(vmac_t);
+	inst->alg.base.cra_ctxsize = sizeof(struct vmac_ctx_t);
+	inst->alg.base.cra_init = vmac_init_tfm;
+	inst->alg.base.cra_exit = vmac_exit_tfm;
+
+	inst->alg.init = vmac_init;
+	inst->alg.update = vmac_update;
+	inst->alg.final = vmac_final;
+	inst->alg.setkey = vmac_setkey;
+
+	err = shash_register_instance(tmpl, inst);
+	if (err) {
+out_free_inst:
+		shash_free_instance(shash_crypto_instance(inst));
+	}
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return err;
+}
+
+static struct crypto_template vmac_tmpl = {
+	.name = "vmac",
+	.create = vmac_create,
+	.free = shash_free_instance,
+	.module = THIS_MODULE,
+};
+
+static int __init vmac_module_init(void)
+{
+	return crypto_register_template(&vmac_tmpl);
+}
+
+static void __exit vmac_module_exit(void)
+{
+	crypto_unregister_template(&vmac_tmpl);
+}
+
+module_init(vmac_module_init);
+module_exit(vmac_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("VMAC hash algorithm");
+
diff -r 7ccb4aa6908f include/crypto/vmac.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/crypto/vmac.h	Thu Aug 20 19:56:44 2009 -0700
@@ -0,0 +1,61 @@
+/*
+ * Modified to interface to the Linux kernel
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#ifndef __CRYPTO_VMAC_H
+#define __CRYPTO_VMAC_H
+
+/* --------------------------------------------------------------------------
+ * VMAC and VHASH Implementation by Ted Krovetz (tdk@acm.org) and Wei Dai.
+ * This implementation is herby placed in the public domain.
+ * The authors offers no warranty. Use at your own risk.
+ * Please send bug reports to the authors.
+ * Last modified: 17 APR 08, 1700 PDT
+ * ----------------------------------------------------------------------- */
+
+/*
+ * User definable settings.
+ */
+#define VMAC_TAG_LEN	64
+#define VMAC_KEY_SIZE	128/* Must be 128, 192 or 256			*/
+#define VMAC_KEY_LEN	(VMAC_KEY_SIZE/8)
+#define VMAC_NHBYTES	128/* Must 2^i for any 3 < i < 13 Standard = 128*/
+
+/*
+ * This implementation uses u32 and u64 as names for unsigned 32-
+ * and 64-bit integer types. These are defined in C99 stdint.h. The
+ * following may need adaptation if you are not running a C99 or
+ * Microsoft C environment.
+ */
+struct vmac_ctx {
+	u64 nhkey[(VMAC_NHBYTES/8)+2*(VMAC_TAG_LEN/64-1)];
+	u64 polykey[2*VMAC_TAG_LEN/64];
+	u64 l3key[2*VMAC_TAG_LEN/64];
+	u64 polytmp[2*VMAC_TAG_LEN/64];
+	u64 cached_nonce[2];
+	u64 cached_aes[2];
+	int first_block_processed;
+};
+
+typedef u64 vmac_t;
+
+struct vmac_ctx_t {
+	struct crypto_cipher *child;
+	struct vmac_ctx __vmac_ctx;
+};
+
+#endif /* __CRYPTO_VMAC_H */

