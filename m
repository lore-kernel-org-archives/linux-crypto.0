From: Shane Wang <shane.wang@intel.com>
Subject: [RFC PATCH] Add VMAC(AES) to Linux for intel_txt support
Date: Thu, 16 Jul 2009 23:05:40 +0800
Message-ID: <4A5F41C4.3050808@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: joseph.cihula@intel.com, shane.wang@intel.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60603 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576AbZGPPFp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jul 2009 11:05:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi community,

The following VMAC(AES) patch, ported from http://fastcrypto.org/vmac, 
is used to support S3 memory integrity verification for Intel(R) Trusted 
Execution Technology (for more about Intel(R) TXT patches, see 
http://lkml.org/lkml/2009/6/22/578), since the VMAC algorithm is very 
fast to MAC the memory during S3 sleep, compared with other MAC algorithms.

We request your feedback and suggestions.

Thanks.
Shane

Signed-off-by: Shane Wang <shane.wang@intel.com>
Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>



diff -r 973795c2770b crypto/Kconfig
--- a/crypto/Kconfig	Mon Jul 13 20:57:01 2009 -0700
+++ b/crypto/Kconfig	Thu Jul 16 02:56:25 2009 -0700
@@ -261,6 +261,18 @@ config CRYPTO_XCBC
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

diff -r 973795c2770b crypto/Makefile
--- a/crypto/Makefile	Mon Jul 13 20:57:01 2009 -0700
+++ b/crypto/Makefile	Thu Jul 16 02:56:25 2009 -0700
@@ -33,6 +33,7 @@ cryptomgr-objs := algboss.o testmgr.o

  obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
  obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
+obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
  obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
  obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o
  obj-$(CONFIG_CRYPTO_MD4) += md4.o
diff -r 973795c2770b crypto/tcrypt.c
--- a/crypto/tcrypt.c	Mon Jul 13 20:57:01 2009 -0700
+++ b/crypto/tcrypt.c	Thu Jul 16 02:56:25 2009 -0700
@@ -700,6 +700,9 @@ static void do_test(int m)
  	case 108:
  		tcrypt_test("hmac(rmd160)");
  		break;
+	case 109:
+		tcrypt_test("vmac(aes)");
+		break;

  	case 200:
  		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
diff -r 973795c2770b crypto/testmgr.c
--- a/crypto/testmgr.c	Mon Jul 13 20:57:01 2009 -0700
+++ b/crypto/testmgr.c	Thu Jul 16 02:56:25 2009 -0700
@@ -1968,6 +1968,15 @@ static const struct alg_test_desc alg_te
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
diff -r 973795c2770b crypto/testmgr.h
--- a/crypto/testmgr.h	Mon Jul 13 20:57:01 2009 -0700
+++ b/crypto/testmgr.h	Thu Jul 16 02:56:25 2009 -0700
@@ -1639,6 +1639,22 @@ static struct hash_testvec aes_xcbc128_t
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
diff -r 973795c2770b crypto/vmac.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/crypto/vmac.c	Thu Jul 16 02:56:25 2009 -0700
@@ -0,0 +1,682 @@
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
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public 
License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License 
along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+/* 
--------------------------------------------------------------------------
+ * VMAC and VHASH Implementation by Ted Krovetz (tdk@acm.org) and Wei Dai.
+ * This implementation is herby placed in the public domain.
+ * The authors offers no warranty. Use at your own risk.
+ * Please send bug reports to the authors.
+ * Last modified: 17 APR 08, 1700 PDT
+ * 
----------------------------------------------------------------------- */
+
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/vmac.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/vmac.h>
+
+/*
+ * Enable code tuned for 64-bit registers; otherwise tuned for 32-bit
+ */
+#ifndef VMAC_ARCH_64
+#define VMAC_ARCH_64 (__x86_64__ || __ppc64__ || _M_X64)
+#endif
+
+/*
+ * Native word reads. Update (or define via compiler) if incorrect
+ */
+#ifndef VMAC_ARCH_BIG_ENDIAN	/* Assume big-endian unless on the list */
+#define VMAC_ARCH_BIG_ENDIAN \
+	(!(__x86_64__ || __i386__ || _M_IX86 || \
+	_M_X64 || __ARMEL__ || __MIPSEL__))
+#endif
+
+/*
+ * Constants and masks
+ */
+#define UINT64_C(x) x##ULL
+const uint64_t p64   = UINT64_C(0xfffffffffffffeff);  /* 2^64 - 257 
prime  */
+const uint64_t m62   = UINT64_C(0x3fffffffffffffff);  /* 62-bit mask 
     */
+const uint64_t m63   = UINT64_C(0x7fffffffffffffff);  /* 63-bit mask 
     */
+const uint64_t m64   = UINT64_C(0xffffffffffffffff);  /* 64-bit mask 
     */
+const uint64_t mpoly = UINT64_C(0x1fffffff1fffffff);  /* Poly key mask 
     */
+
+
+#if (VMAC_ARCH_BIG_ENDIAN)
+#define get64BE(ptr) (*(uint64_t *)(ptr))
+#define get64LE(ptr) GET_REVERSED_64(ptr)
+#define INDEX_HIGH 0
+#define INDEX_LOW 1
+#else /* assume little-endian */
+#define get64BE(ptr) GET_REVERSED_64(ptr)
+#define get64LE(ptr) (*(uint64_t *)(ptr))
+#define INDEX_HIGH 1
+#define INDEX_LOW 0
+#endif
+
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
+#if VMAC_ARCH_64
+
+#define nh_16(mp, kp, nw, rh, rl)					\
+{	int i; uint64_t th, tl;						\
+	rh = rl = 0;							\
+	for (i = 0; i < nw; i+= 2) {					\
+		MUL64(th,tl,get64LE((mp)+i  )+(kp)[i  ],		\
+			get64LE((mp)+i+1)+(kp)[i+1]);			\
+		ADD128(rh,rl,th,tl);					\
+	}								\
+}
+
+#define nh_16_2(mp, kp, nw, rh, rl, rh1, rl1)				\
+{	int i; uint64_t th, tl;						\
+	rh1 = rl1 = rh = rl = 0;					\
+	for (i = 0; i < nw; i+= 2) {					\
+		MUL64(th,tl,get64LE((mp)+i  )+(kp)[i  ],		\
+			get64LE((mp)+i+1)+(kp)[i+1]);			\
+		ADD128(rh,rl,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i  )+(kp)[i+2],		\
+			get64LE((mp)+i+1)+(kp)[i+3]);			\
+		ADD128(rh1,rl1,th,tl);					\
+	}								\
+}
+
+#if (VMAC_NHBYTES >= 64) /* These versions do 64-bytes of message at a 
time */
+#define nh_vmac_nhbytes(mp, kp, nw, rh, rl)				\
+{	int i; uint64_t th, tl;						\
+	rh = rl = 0;							\
+	for (i = 0; i < nw; i+= 8) {					\
+		MUL64(th,tl,get64LE((mp)+i  )+(kp)[i  ],		\
+			get64LE((mp)+i+1)+(kp)[i+1]);			\
+     		ADD128(rh,rl,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i+2)+(kp)[i+2],		\
+			get64LE((mp)+i+3)+(kp)[i+3]);			\
+		ADD128(rh,rl,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i+4)+(kp)[i+4],		\
+			get64LE((mp)+i+5)+(kp)[i+5]);			\
+		ADD128(rh,rl,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i+6)+(kp)[i+6],		\
+			get64LE((mp)+i+7)+(kp)[i+7]);			\
+		ADD128(rh,rl,th,tl);					\
+	}								\
+}
+
+#define nh_vmac_nhbytes_2(mp, kp, nw, rh, rl, rh1, rl1)			\
+{	int i; uint64_t th, tl;						\
+	rh1 = rl1 = rh = rl = 0;					\
+	for (i = 0; i < nw; i+= 8) {					\
+		MUL64(th,tl,get64LE((mp)+i  )+(kp)[i  ],		\
+			get64LE((mp)+i+1)+(kp)[i+1]);			\
+		ADD128(rh,rl,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i  )+(kp)[i+2],		\
+			get64LE((mp)+i+1)+(kp)[i+3]);			\
+		ADD128(rh1,rl1,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i+2)+(kp)[i+2],		\
+			get64LE((mp)+i+3)+(kp)[i+3]);			\
+		ADD128(rh,rl,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i+2)+(kp)[i+4],		\
+			get64LE((mp)+i+3)+(kp)[i+5]);			\
+		ADD128(rh1,rl1,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i+4)+(kp)[i+4],		\
+			get64LE((mp)+i+5)+(kp)[i+5]);			\
+		ADD128(rh,rl,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i+4)+(kp)[i+6],		\
+			get64LE((mp)+i+5)+(kp)[i+7]);			\
+		ADD128(rh1,rl1,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i+6)+(kp)[i+6],		\
+			get64LE((mp)+i+7)+(kp)[i+7]);			\
+		ADD128(rh,rl,th,tl);					\
+		MUL64(th,tl,get64LE((mp)+i+6)+(kp)[i+8],		\
+			get64LE((mp)+i+7)+(kp)[i+9]);			\
+		ADD128(rh1,rl1,th,tl);					\
+	}								\
+}
+#endif
+
+#define poly_step(ah, al, kh, kl, mh, ml)				\
+{	uint64_t t1h, t1l, t2h, t2l, t3h, t3l, z=0;			\
+	/* compute ab*cd, put bd into result registers */		\
+	PMUL64(t3h,t3l,al,kh);						\
+	PMUL64(t2h,t2l,ah,kl);						\
+	PMUL64(t1h,t1l,ah,2*kh);					\
+	PMUL64(ah,al,al,kl);						\
+	/* add 2 * ac to result */					\
+	ADD128(ah,al,t1h,t1l);						\
+	/* add together ad + bc */					\
+	ADD128(t2h,t2l,t3h,t3l);					\
+	/* now (ah,al), (t2l,2*t2h) need summing */			\
+	/* first add the high registers, carrying into t2h */		\
+	ADD128(t2h,ah,z,t2l);						\
+	/* double t2h and add top bit of ah */				\
+	t2h = 2 * t2h + (ah >> 63);					\
+	ah &= m63;							\
+	/* now add the low registers */					\
+	ADD128(ah,al,mh,ml);						\
+	ADD128(ah,al,z,t2h);						\
+}
+
+#else /* not VMAC_ARCH_64 */
+
+#ifndef nh_16
+#define nh_16(mp, kp, nw, rh, rl)					\
+{	uint64_t t1,t2,m1,m2,t;						\
+	int i;								\
+	rh = rl = t = 0;						\
+	for (i = 0; i < nw; i+=2)  {					\
+		t1  = get64LE(mp+i) + kp[i];				\
+		t2  = get64LE(mp+i+1) + kp[i+1];			\
+		m2  = MUL32(t1 >> 32, t2);				\
+		m1  = MUL32(t1, t2 >> 32);				\
+		ADD128(rh,rl,MUL32(t1 >> 32,t2 >> 32),MUL32(t1,t2));	\
+		rh += (uint64_t)(uint32_t)(m1 >> 32)			\
+			+ (uint32_t)(m2 >> 32);				\
+		t  += (uint64_t)(uint32_t)m1 + (uint32_t)m2;		\
+	}								\
+	ADD128(rh,rl,(t >> 32),(t << 32));				\
+}
+#endif
+
+static void poly_step_func(uint64_t *ahi, uint64_t *alo,
+			const uint64_t *kh, const uint64_t *kl,
+			const uint64_t *mh, const uint64_t *ml)
+{
+#define a0 *(((uint32_t*)alo)+INDEX_LOW)
+#define a1 *(((uint32_t*)alo)+INDEX_HIGH)
+#define a2 *(((uint32_t*)ahi)+INDEX_LOW)
+#define a3 *(((uint32_t*)ahi)+INDEX_HIGH)
+#define k0 *(((uint32_t*)kl)+INDEX_LOW)
+#define k1 *(((uint32_t*)kl)+INDEX_HIGH)
+#define k2 *(((uint32_t*)kh)+INDEX_LOW)
+#define k3 *(((uint32_t*)kh)+INDEX_HIGH)
+
+	uint64_t p, q, t;
+	uint32_t t2;
+
+	p = MUL32(a3, k3);
+	p += p;
+	p += *(uint64_t *)mh;
+	p += MUL32(a0, k2);
+	p += MUL32(a1, k1);
+	p += MUL32(a2, k0);
+	t = (uint32_t)(p);
+	p >>= 32;
+	p += MUL32(a0, k3);
+	p += MUL32(a1, k2);
+	p += MUL32(a2, k1);
+	p += MUL32(a3, k0);
+	t |= ((uint64_t)((uint32_t)p & 0x7fffffff)) << 32;
+	p >>= 31;
+	p += (uint64_t)(((uint32_t*)ml)[INDEX_LOW]);
+	p += MUL32(a0, k0);
+	q =  MUL32(a1, k3);
+	q += MUL32(a2, k2);
+	q += MUL32(a3, k1);
+	q += q;
+	p += q;
+	t2 = (uint32_t)(p);
+	p >>= 32;
+	p += (uint64_t)(((uint32_t*)ml)[INDEX_HIGH]);
+	p += MUL32(a0, k1);
+	p += MUL32(a1, k0);
+	q =  MUL32(a2, k3);
+	q += MUL32(a3, k2);
+	q += q;
+	p += q;
+	*(uint64_t *)(alo) = (p << 32) | t2;
+	p >>= 32;
+	*(uint64_t *)(ahi) = p + t;
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
+#define poly_step(ah, al, kh, kl, mh, ml)   \
+	poly_step_func(&(ah), &(al), &(kh), &(kl), &(mh), &(ml))
+
+#endif  /* end of specialized NH and poly definitions */
+
+/* At least nh_16 is defined. Defined others as needed here */
+#ifndef nh_16_2
+#define nh_16_2(mp, kp, nw, rh, rl, rh2, rl2)				\
+	nh_16(mp, kp, nw, rh, rl);					\
+	nh_16(mp, ((kp)+2), nw, rh2, rl2);
+#endif
+#ifndef nh_vmac_nhbytes
+#define nh_vmac_nhbytes(mp, kp, nw, rh, rl)				\
+	nh_16(mp, kp, nw, rh, rl)
+#endif
+#ifndef nh_vmac_nhbytes_2
+#define	nh_vmac_nhbytes_2(mp, kp, nw, rh, rl, rh2, rl2)			\
+	nh_vmac_nhbytes(mp, kp, nw, rh, rl);				\
+	nh_vmac_nhbytes(mp, ((kp)+2), nw, rh2, rl2);
+#endif
+
+static void vhash_abort(struct vmac_ctx *ctx)
+{
+	ctx->polytmp[0] = ctx->polykey[0] ;
+	ctx->polytmp[1] = ctx->polykey[1] ;
+	ctx->first_block_processed = 0;
+}
+
+static uint64_t l3hash(	uint64_t p1, uint64_t p2,
+			uint64_t k1, uint64_t k2, uint64_t len)
+{
+	uint64_t rh, rl, t, z=0;
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
+	t += (uint32_t)t > 0xfffffffeu;
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
+static void vhash_update(unsigned char *m,
+			unsigned int mbytes, /* Pos multiple of VMAC_NHBYTES */
+			struct vmac_ctx *ctx)
+{
+	uint64_t rh, rl, *mptr;
+	const uint64_t *kptr = (uint64_t *)ctx->nhkey;
+	int i;
+	uint64_t ch, cl;
+	uint64_t pkh = ctx->polykey[0];
+	uint64_t pkl = ctx->polykey[1];
+
+	mptr = (uint64_t *)m;
+	i = mbytes / VMAC_NHBYTES;  /* Must be non-zero */
+
+	ch = ctx->polytmp[0];
+	cl = ctx->polytmp[1];
+
+	if ( ! ctx->first_block_processed) {
+		ctx->first_block_processed = 1;
+		nh_vmac_nhbytes(mptr,kptr,VMAC_NHBYTES/8,rh,rl);
+		rh &= m62;
+		ADD128(ch,cl,rh,rl);
+		mptr += (VMAC_NHBYTES/sizeof(uint64_t));
+		i--;
+	}
+
+	while (i--) {
+		nh_vmac_nhbytes(mptr,kptr,VMAC_NHBYTES/8,rh,rl);
+		rh &= m62;
+		poly_step(ch,cl,pkh,pkl,rh,rl);
+		mptr += (VMAC_NHBYTES/sizeof(uint64_t));
+	}
+
+	ctx->polytmp[0] = ch;
+	ctx->polytmp[1] = cl;
+}
+
+static uint64_t vhash(unsigned char m[], unsigned int mbytes,
+			uint64_t *tagl, struct vmac_ctx *ctx)
+{
+	uint64_t rh, rl, *mptr;
+	const uint64_t *kptr = (uint64_t *)ctx->nhkey;
+	int i, remaining;
+	uint64_t ch, cl;
+	uint64_t pkh = ctx->polykey[0];
+	uint64_t pkl = ctx->polykey[1];
+
+	mptr = (uint64_t *)m;
+	i = mbytes / VMAC_NHBYTES;
+	remaining = mbytes % VMAC_NHBYTES;
+
+	if (ctx->first_block_processed) {
+		ch = ctx->polytmp[0];
+		cl = ctx->polytmp[1];
+	}
+	else if (i) {
+		nh_vmac_nhbytes(mptr,kptr,VMAC_NHBYTES/8,ch,cl);
+		ch &= m62;
+		ADD128(ch,cl,pkh,pkl);
+		mptr += (VMAC_NHBYTES/sizeof(uint64_t));
+		i--;
+    	}
+	else if (remaining) {
+		nh_16(mptr,kptr,2*((remaining+15)/16),ch,cl);
+		ch &= m62;
+		ADD128(ch,cl,pkh,pkl);
+		mptr += (VMAC_NHBYTES/sizeof(uint64_t));
+		goto do_l3;
+	}
+	else {/* Empty String */
+		ch = pkh; cl = pkl;
+		goto do_l3;
+	}
+
+	while (i--) {
+		nh_vmac_nhbytes(mptr,kptr,VMAC_NHBYTES/8,rh,rl);
+		rh &= m62;
+		poly_step(ch,cl,pkh,pkl,rh,rl);
+		mptr += (VMAC_NHBYTES/sizeof(uint64_t));
+	}
+	if (remaining) {
+		nh_16(mptr,kptr,2*((remaining+15)/16),rh,rl);
+		rh &= m62;
+		poly_step(ch,cl,pkh,pkl,rh,rl);
+	}
+
+do_l3:
+	vhash_abort(ctx);
+	remaining *= 8;
+	return l3hash(ch, cl, ctx->l3key[0], ctx->l3key[1],remaining);
+}
+
+static uint64_t vmac(	unsigned char m[], unsigned int mbytes,
+			unsigned char n[16], uint64_t *tagl,
+			vmac_ctx_t *ctx)
+{
+	uint64_t *in_n, *out_p;
+	uint64_t p, h;
+	int i;
+
+	in_n = ctx->__vmac_ctx.cached_nonce;
+	out_p = ctx->__vmac_ctx.cached_aes;
+
+	i = n[15] & 1;
+	if (	(*(uint64_t *)(n+8) != in_n[1]) ||
+		(*(uint64_t *)(n  ) != in_n[0])) {
+
+		in_n[0] = *(uint64_t *)(n  );
+		in_n[1] = *(uint64_t *)(n+8);
+		((unsigned char *)in_n)[15] &= 0xFE;
+		crypto_cipher_encrypt_one(ctx->child,
+			(unsigned char *)out_p, (unsigned char *)in_n);
+
+		((unsigned char *)in_n)[15] |= (unsigned char)(1-i);
+	}
+	p = get64BE(out_p + i);
+	h = vhash(m, mbytes, (uint64_t *)0, &ctx->__vmac_ctx);
+	return p + h;
+}
+
+static int vmac_set_key(unsigned char user_key[], vmac_ctx_t *ctx)
+{
+	uint64_t in[2] = {0}, out[2];
+	unsigned i;
+	int err = 0;
+
+	if ((err = crypto_cipher_setkey(ctx->child, user_key, VMAC_KEY_LEN)))
+		return err;
+
+	/* Fill nh key */
+	((unsigned char *)in)[0] = 0x80;
+	for (i = 0; i < sizeof(ctx->__vmac_ctx.nhkey)/8; i+=2) {
+		crypto_cipher_encrypt_one(ctx->child,
+			(unsigned char *)out, (unsigned char *)in);
+		ctx->__vmac_ctx.nhkey[i  ] = get64BE(out);
+		ctx->__vmac_ctx.nhkey[i+1] = get64BE(out+1);
+		((unsigned char *)in)[15] += 1;
+	}
+
+	/* Fill poly key */
+	((unsigned char *)in)[0] = 0xC0;
+	in[1] = 0;
+	for (i = 0; i < sizeof(ctx->__vmac_ctx.polykey)/8; i+=2) {
+		crypto_cipher_encrypt_one(ctx->child,
+			(unsigned char *)out, (unsigned char *)in);
+		ctx->__vmac_ctx.polytmp[i  ] =
+			ctx->__vmac_ctx.polykey[i  ] = get64BE(out) & mpoly;
+		ctx->__vmac_ctx.polytmp[i+1] =
+			ctx->__vmac_ctx.polykey[i+1] = get64BE(out+1) & mpoly;
+		((unsigned char *)in)[15] += 1;
+	}
+
+	/* Fill ip key */
+	((unsigned char *)in)[0] = 0xE0;
+	in[1] = 0;
+	for (i = 0; i < sizeof(ctx->__vmac_ctx.l3key)/8; i+=2) {
+		do {
+			crypto_cipher_encrypt_one(ctx->child,
+				(unsigned char *)out, (unsigned char *)in);
+			ctx->__vmac_ctx.l3key[i  ] = get64BE(out);
+			ctx->__vmac_ctx.l3key[i+1] = get64BE(out+1);
+			((unsigned char *)in)[15] += 1;
+		} while (ctx->__vmac_ctx.l3key[i] >= p64
+			|| ctx->__vmac_ctx.l3key[i+1] >= p64);
+	}
+
+	/* Invalidate nonce/aes cache and reset other elements */
+	ctx->__vmac_ctx.cached_nonce[0] = (uint64_t)-1; /* Ensure illegal nonce */
+	ctx->__vmac_ctx.cached_nonce[1] = (uint64_t)0;  /* Ensure illegal nonce */
+	ctx->__vmac_ctx.first_block_processed = 0;
+
+	return err;
+}
+
+static int vmac_setkey(struct crypto_hash *parent,
+		const u8 *key, unsigned int keylen)
+{
+	vmac_ctx_t *ctx = crypto_hash_ctx(parent);
+
+	if (keylen != VMAC_KEY_LEN) {
+		crypto_hash_set_flags(parent, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	return vmac_set_key((u8 *)key, ctx);
+}
+
+static int vmac_init(struct hash_desc *desc)
+{
+	vmac_ctx_t *ctx = crypto_hash_ctx(desc->tfm);
+
+	memset(&ctx->__vmac_ctx, 0, sizeof(struct vmac_ctx));
+	return 0;
+}
+
+static int vmac_update2(struct hash_desc *desc,
+		struct scatterlist *sg,	unsigned int nbytes)
+{
+	vmac_ctx_t *ctx = crypto_hash_ctx(desc->tfm);
+
+	for (;;) {
+		struct page *pg = sg_page(sg);
+		unsigned int offset = sg->offset;
+		unsigned int slen = sg->length;
+		char *data;
+
+		if (unlikely(slen > nbytes))
+			slen = nbytes;
+
+		nbytes -= slen;
+		data = crypto_kmap(pg, 0) + offset;
+		vhash_update((u8 *)data, slen, &ctx->__vmac_ctx);
+		crypto_kunmap(data, 0);
+		crypto_yield(desc->flags);
+
+		if (!nbytes)
+			break;
+		sg = scatterwalk_sg_next(sg);
+	}
+
+	return 0;
+}
+
+static int vmac_update(struct hash_desc *desc,
+		struct scatterlist *sg, unsigned int nbytes)
+{
+	if (WARN_ON_ONCE(in_irq()))
+		return -EDEADLK;
+
+	return vmac_update2(desc, sg, nbytes);
+}
+
+static int vmac_final(struct hash_desc *desc, u8 *out)
+{
+	vmac_ctx_t *ctx = crypto_hash_ctx(desc->tfm);
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
+static int vmac_digest(struct hash_desc *desc,
+	struct scatterlist *sg, unsigned int nbytes, u8 *out)
+{
+	if (WARN_ON_ONCE(in_irq()))
+		return -EDEADLK;
+
+	vmac_init(desc);
+	vmac_update2(desc, sg, nbytes);
+	return vmac_final(desc, out);
+}
+
+static int vmac_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_cipher *cipher;
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	vmac_ctx_t *ctx = crypto_hash_ctx(__crypto_hash_cast(tfm));
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
+	vmac_ctx_t *ctx = crypto_hash_ctx(__crypto_hash_cast(tfm));
+	crypto_free_cipher(ctx->child);
+}
+
+static void vmac_free(struct crypto_instance *inst)
+{
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(inst);
+}
+
+static struct crypto_instance *vmac_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_HASH);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+			CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(alg))
+		return ERR_CAST(alg);
+
+	inst = crypto_alloc_instance("vmac", alg);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_HASH;
+	inst->alg.cra_priority = alg->cra_priority;
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+	inst->alg.cra_type = &crypto_hash_type;
+
+	inst->alg.cra_hash.digestsize = sizeof(vmac_t);
+	inst->alg.cra_ctxsize = sizeof(vmac_ctx_t);
+	inst->alg.cra_init = vmac_init_tfm;
+	inst->alg.cra_exit = vmac_exit_tfm;
+
+	inst->alg.cra_hash.init = vmac_init;
+	inst->alg.cra_hash.update = vmac_update;
+	inst->alg.cra_hash.final = vmac_final;
+	inst->alg.cra_hash.digest = vmac_digest;
+	inst->alg.cra_hash.setkey = vmac_setkey;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return inst;
+}
+
+static struct crypto_template vmac_tmpl = {
+	.name = "vmac",
+	.alloc = vmac_alloc,
+	.free = vmac_free,
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
diff -r 973795c2770b include/crypto/internal/vmac.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/crypto/internal/vmac.h	Thu Jul 16 02:56:25 2009 -0700
@@ -0,0 +1,186 @@
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
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public 
License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License 
along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+/* 
--------------------------------------------------------------------------
+ * VMAC and VHASH Implementation by Ted Krovetz (tdk@acm.org) and Wei Dai.
+ * This implementation is herby placed in the public domain.
+ * The authors offers no warranty. Use at your own risk.
+ * Please send bug reports to the authors.
+ * Last modified: 17 APR 08, 1700 PDT
+ * 
----------------------------------------------------------------------- */
+
+#ifndef _CRYPTO_INTERNAL_VMAC_H
+#define _CRYPTO_INTERNAL_VMAC_H
+
+/*
+ * The following routines are used in this implementation. They are
+ * written via macros to simulate zero-overhead call-by-reference.
+ * All have default implemantations for when they are not defined in an
+ * architecture-specific manner.
+ *
+ * MUL64: 64x64->128-bit multiplication
+ * PMUL64: assumes top bits cleared on inputs
+ * ADD128: 128x128->128-bit addition
+ * GET_REVERSED_64: load and byte-reverse 64-bit word
+ */
+
+/* x86_64 or amd64 */
+#if (__GNUC__ && (__x86_64__ || __amd64__))
+
+#define ADD128(rh,rl,ih,il)						\
+	asm ("addq %3, %1 \n\t"						\
+	"adcq %2, %0"							\
+	: "+r"(rh),"+r"(rl)						\
+	: "r"(ih),"r"(il) : "cc");
+
+#define MUL64(rh,rl,i1,i2)						\
+    asm ("mulq %3" : "=a"(rl), "=d"(rh) : "a"(i1), "r"(i2) : "cc")
+
+#define PMUL64 MUL64
+
+#define GET_REVERSED_64(p)						\
+	({uint64_t x;							\
+	asm ("bswapq %0" : "=r" (x) : "0"(*(uint64_t *)(p))); x;})
+/* i386 */
+#elif (__GNUC__ && __i386__)
+
+#define GET_REVERSED_64(p)						\
+	({ uint64_t x;							\
+	uint32_t *tp = (uint32_t *)(p);					\
+	asm  (	"bswap %%edx\n\t"					\
+		"bswap %%eax"						\
+		: "=A"(x)						\
+		: "a"(tp[1]), "d"(tp[0]));				\
+		x; })
+/* ppc64 */
+#elif (__GNUC__ && __ppc64__)
+
+#define ADD128(rh,rl,ih,il)\
+	asm volatile (	"addc %1, %1, %3 \n\t"				\
+			"adde %0, %0, %2"				\
+			: "+r"(rh),"+r"(rl)				\
+			: "r"(ih),"r"(il));
+
+#define MUL64(rh,rl,i1,i2)						\
+{									\
+	uint64_t _i1 = (i1), _i2 = (i2);				\
+	rl = _i1 * _i2;							\
+	asm volatile (	"mulhdu %0, %1, %2"				\
+			: "=r" (rh)					\
+			: "r" (_i1), "r" (_i2));			\
+}
+
+#define PMUL64 MUL64
+
+#define GET_REVERSED_64(p)						\
+	({ 	uint32_t hi, lo, *_p = (uint32_t *)(p);			\
+		asm volatile ("	lwbrx %0, %1, %2"			\
+				: "=r"(lo)				\
+				: "b%"(0), "r"(_p) );  			\
+		asm volatile ("	lwbrx %0, %1, %2"			\
+				: "=r"(hi)				\
+				: "b%"(4), "r"(_p) );			\
+		((uint64_t)hi << 32) | (uint64_t)lo; } )
+
+/* ppc */
+#elif (__GNUC__ && (__ppc__ || __PPC__))
+
+#define GET_REVERSED_64(p)\
+	({ 	uint32_t hi, lo, *_p = (uint32_t *)(p);			\
+		asm volatile ("	lwbrx %0, %1, %2"			\
+				: "=r"(lo)				\
+				: "b%"(0), "r"(_p) );			\
+		asm volatile ("	lwbrx %0, %1, %2"			\
+				: "=r"(hi)				\
+				: "b%"(4), "r"(_p) );			\
+		((uint64_t)hi << 32) | (uint64_t)lo; } )
+
+/* armel or arm */
+#elif (__GNUC__ && (__ARMEL__ || __ARM__))
+
+#define bswap32(v)							\
+	({	uint32_t tmp,out;					\
+		asm volatile (	"eor    %1, %2, %2, ror #16\n"		\
+				"bic    %1, %1, #0x00ff0000\n"		\
+				"mov    %0, %2, ror #8\n"		\
+				"eor    %0, %0, %1, lsr #8"		\
+				: "=r" (out), "=&r" (tmp)		\
+				: "r" (v));				\
+		out; } )
+#endif
+
+/*
+ * Default implementations, if not defined above
+ */
+
+#ifndef ADD128
+#define ADD128(rh,rl,ih,il)						\
+	{	uint64_t _il = (il);					\
+		(rl) += (_il);						\
+		if ((rl) < (_il)) (rh)++;				\
+			(rh) += (ih);					\
+	}
+#endif
+
+#ifndef MUL32
+#define MUL32(i1,i2)	((uint64_t)(uint32_t)(i1)*(uint32_t)(i2))
+#endif
+
+#ifndef PMUL64		/* rh may not be same as i1 or i2 */
+#define PMUL64(rh,rl,i1,i2)	/* Assumes m doesn't overflow */	\
+	{	uint64_t _i1 = (i1), _i2 = (i2);			\
+		uint64_t m = MUL32(_i1,_i2>>32) + MUL32(_i1>>32,_i2);	\
+		rh = MUL32(_i1>>32,_i2>>32);				\
+		rl = MUL32(_i1,_i2);					\
+		ADD128(rh,rl,(m >> 32),(m << 32));			\
+    }
+#endif
+
+#ifndef MUL64
+#define MUL64(rh,rl,i1,i2)						\
+	{	uint64_t _i1 = (i1), _i2 = (i2);			\
+		uint64_t m1= MUL32(_i1,_i2>>32);			\
+		uint64_t m2= MUL32(_i1>>32,_i2);			\
+		rh = MUL32(_i1>>32,_i2>>32);				\
+		rl = MUL32(_i1,_i2);					\
+		ADD128(rh,rl,(m1 >> 32),(m1 << 32));			\
+		ADD128(rh,rl,(m2 >> 32),(m2 << 32));			\
+	}
+#endif
+
+#ifndef GET_REVERSED_64
+#ifndef bswap64
+#ifndef bswap32
+#define bswap32(x)							\
+	({	uint32_t bsx = (x);					\
+		((((bsx) & 0xff000000u) >> 24)				\
+		| (((bsx) & 0x00ff0000u) >>  8)				\
+		| (((bsx) & 0x0000ff00u) <<  8)				\
+		| (((bsx) & 0x000000ffu) << 24));	})
+#endif
+#define bswap64(x)\
+	({	union { uint64_t ll; uint32_t l[2]; } w, r;		\
+         	w.ll = (x);						\
+         	r.l[0] = bswap32 (w.l[1]);				\
+         	r.l[1] = bswap32 (w.l[0]);				\
+         	r.ll;	})
+#endif
+#define GET_REVERSED_64(p) bswap64(*(uint64_t *)(p))
+#endif
+
+#endif /* _CRYPTO_INTERNAL_VMAC_H */
diff -r 973795c2770b include/crypto/vmac.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/crypto/vmac.h	Thu Jul 16 02:56:25 2009 -0700
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
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public 
License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License 
along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#ifndef __CRYPTO_VMAC_H
+#define __CRYPTO_VMAC_H
+
+/* 
--------------------------------------------------------------------------
+ * VMAC and VHASH Implementation by Ted Krovetz (tdk@acm.org) and Wei Dai.
+ * This implementation is herby placed in the public domain.
+ * The authors offers no warranty. Use at your own risk.
+ * Please send bug reports to the authors.
+ * Last modified: 17 APR 08, 1700 PDT
+ * 
----------------------------------------------------------------------- */
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
+ * This implementation uses uint32_t and uint64_t as names for unsigned 32-
+ * and 64-bit integer types. These are defined in C99 stdint.h. The
+ * following may need adaptation if you are not running a C99 or
+ * Microsoft C environment.
+ */
+struct vmac_ctx {
+	uint64_t nhkey  [(VMAC_NHBYTES/8)+2*(VMAC_TAG_LEN/64-1)];
+	uint64_t polykey[2*VMAC_TAG_LEN/64];
+	uint64_t l3key  [2*VMAC_TAG_LEN/64];
+	uint64_t polytmp[2*VMAC_TAG_LEN/64];
+	uint64_t cached_nonce[2];
+	uint64_t cached_aes[2];
+	int first_block_processed;
+};
+
+typedef uint64_t vmac_t;
+
+typedef struct {
+        struct crypto_cipher *child;
+        struct vmac_ctx __vmac_ctx;
+} vmac_ctx_t;
+
+#endif /* __CRYPTO_VMAC_H */
