From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [6 PATCHes] IXP4xx crypto driver fixes.
Date: Sun, 10 Jan 2010 18:30:53 +0100
Message-ID: <m3vdf93m0i.fsf@intrepid.localdomain>
References: <m34omu3rf7.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:35810 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab0AJRa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jan 2010 12:30:56 -0500
In-Reply-To: <m34omu3rf7.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Sun, 10 Jan 2010 16:35:38 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IXP4xx: Fix ixp4xx_crypto little-endian operation.

Signed-off-by: Krzysztof Ha=C5=82asa <khc@pm.waw.pl>

=46ixes the following on IXP425 little-endian:

NPE-C: firmware functionality 0x5, revision 0x2:1
alg: skcipher: Test 1 failed on encryption for ecb(des)-ixp4xx
00000000: 01 23 45 67 89 ab cd e7
alg: skcipher: Test 1 failed on encryption for ecb(des3_ede)-ixp4xx
00000000: 73 6f 6d 65 64 61 74 61
alg: skcipher: Test 1 failed on encryption for ecb(aes)-ixp4xx
00000000: 00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_cry=
pto.c
index 6c6656d..cac026a 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -96,8 +96,13 @@
=20
 struct buffer_desc {
 	u32 phys_next;
+#ifdef __ARMEB__
 	u16 buf_len;
 	u16 pkt_len;
+#else
+	u16 pkt_len;
+	u16 buf_len;
+#endif
 	u32 phys_addr;
 	u32 __reserved[4];
 	struct buffer_desc *next;
@@ -105,17 +110,30 @@ struct buffer_desc {
 };
=20
 struct crypt_ctl {
+#ifdef __ARMEB__
 	u8 mode;		/* NPE_OP_*  operation mode */
 	u8 init_len;
 	u16 reserved;
+#else
+	u16 reserved;
+	u8 init_len;
+	u8 mode;		/* NPE_OP_*  operation mode */
+#endif
 	u8 iv[MAX_IVLEN];	/* IV for CBC mode or CTR IV for CTR mode */
 	u32 icv_rev_aes;	/* icv or rev aes */
 	u32 src_buf;
 	u32 dst_buf;
+#ifdef __ARMEB__
 	u16 auth_offs;		/* Authentication start offset */
 	u16 auth_len;		/* Authentication data length */
 	u16 crypt_offs;		/* Cryption start offset */
 	u16 crypt_len;		/* Cryption data length */
+#else
+	u16 auth_len;		/* Authentication data length */
+	u16 auth_offs;		/* Authentication start offset */
+	u16 crypt_len;		/* Cryption data length */
+	u16 crypt_offs;		/* Cryption start offset */
+#endif
 	u32 aadAddr;		/* Additional Auth Data Addr for CCM mode */
 	u32 crypto_ctx;		/* NPE Crypto Param structure address */
=20
@@ -651,6 +669,9 @@ static int setup_auth(struct crypto_tfm *tfm, int e=
ncrypt, unsigned authsize,
=20
 	/* write cfg word to cryptinfo */
 	cfgword =3D algo->cfgword | ( authsize << 6); /* (authsize/4) << 8 */
+#ifndef __ARMEB__
+	cfgword ^=3D 0xAA000000; /* change the "byte swap" flags */
+#endif
 	*(u32*)cinfo =3D cpu_to_be32(cfgword);
 	cinfo +=3D sizeof(cfgword);
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
