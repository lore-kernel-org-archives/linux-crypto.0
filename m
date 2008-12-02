From: "Shasi Pulijala" <spulijala@amcc.com>
Subject: Updated Openssl Patch to support Linux CryptoAPI v3
Date: Mon, 1 Dec 2008 16:28:49 -0800
Message-ID: <DB599F406D04E34389140B7D99C71B1B068407A2@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:15145 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYLBA2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2008 19:28:55 -0500
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This Openssl patch is the version 3 which incorporates some changes suggested by the Linux Crypto Maintainer. Openssl still needs to be patched with OCF first to use the linux cryptodev interface. The major changes in this patch include:

1) Addition of a header file that defines the crypto and hash algorithm/modes as a bitmap.
2) The structures session_op and crypt_op need to be included from the linux kernel headers.

--- /user/cryptodev/cryptodev-2.6/include/cryptodev.h	1969-12-31 16:00:00.000000000 -0800
+++ /user/linux/openssl-0.9.8g/include/openssl/cryptodev_macro.h	2008-12-01 11:51:28.037294000 -0800
@@ -0,0 +1,165 @@
+#ifndef __CRYPTODEV_MACRO_H__
+#define __CRYPTODEV_MACRO_H__
+#define CRYPTODEV_LINUX
+#define CRYPTO_ALGORITHM_MAX		20
+#define CRYPTO_MAX_ALG_NAME		20
+/*	___________________________  ____________________________
+ *	|_Hash Mode____|_Hash Alg__|__Cipher Mode__|_Cipher Alg__|
+ *
+ */
+#define CD_CRYPT_ALG_MASK		0x000000FF	/* algorithm: */
+#define CD_CRYPT_ALG_DES		0x00000001	/*   DES */
+#define CD_CRYPT_ALG_3DES		0x00000002	/*   3DES */
+#define CD_CRYPT_ALG_RC4		0x00000003	/*   RC4 */
+#define CD_CRYPT_ALG_AES		0x00000004	/*   AES */
+#define CD_CRYPT_ALG_BFISH		0x00000005	/*   Blowfish */
+#define CD_CRYPT_ALG_CAST		0x00000006	/*   Cast */
+#define CD_CRYPT_ALG_CAMELLIA	0x00000007	/*   Camellia */
+#define CD_CRYPT_ALG_SKIPJACK	0x00000008
+
+#define CD_CRYPT_ALGS		{ "", "des", "des3_ede", "arc4", "aes",\
+ 				"blowfish", "cast5", "camellia" }
+#define CD_CRYPT_ALG_SHIFT		0
+#define CD_CRYPT_ALG_MASK_INDEX	(CD_CRYPT_ALG_MASK >> CD_CRYPT_ALG_SHIFT)
+
+#define CD_CRYPT_MODE_MASK		0x0000FF00	/* Encrypt mode: */
+#define CD_CRYPT_MODE_ECB		0x00000000	/*   ECB */
+#define CD_CRYPT_MODE_CBC		0x00000100	/*   CBC */
+#define CD_CRYPT_MODE_CFB		0x00000200	/*   CFB */
+#define CD_CRYPT_MODE_OFB		0x00000300	/*   OFB */
+#define CD_CRYPT_MODE_CTR		0x00000400	/*   CTR */
+
+#define CD_CRYPT_MODES	 	{ "ecb", "cbc", "cfb", "ofb", "ctr" }
+#define CD_CRYPT_MODE_SHIFT		8
+#define CD_CRYPT_MODE_MASK_INDEX	(CD_CRYPT_MODE_MASK >> CD_CRYPT_MODE_SHIFT)
+
+/*Hasing Modes (2 bits) and Algorithms(4 bits) */
+#define CD_MAC_ALG_MASK		0x00FF0000
+#define CD_MAC_ALG_SHA1		0x00000000
+#define CD_MAC_ALG_MD5			0x00010000
+#define CD_MAC_ALG_RIPEMD		0x00020000
+#define CD_MAC_ALG_SHA224		0x00030000
+#define CD_MAC_ALG_SHA256		0x00040000
+#define CD_MAC_ALG_SHA384		0X00050000
+#define CD_MAC_ALG_SHA512		0x00060000
+
+#define CD_MAC_ALGS		{ "sha1", "md5", "ripemd160", \
+				"sha224", "sha256", "sha384", "sha512" }
+#define CD_MAC_ALG_SHIFT		16
+#define CD_MAC_ALG_MASK_INDEX	(CD_MAC_ALG_MASK >> CD_MAC_ALG_SHIFT)
+
+#define CD_MAC_MODE_MASK		0xFF000000
+#define CD_MAC_MODE_NORMAL		0x01000000
+#define CD_MAC_MODE_HMAC		0x02000000
+
+
+#define CD_MAC_MODES		{ "", "", "hmac" }
+#define CD_MAC_MODE_SHIFT		24
+#define CD_MAC_MODE_MASK_INDEX	(CD_MAC_MODE_MASK >> CD_MAC_MODE_SHIFT)
+
+/*
+ * Cipher Algorithms
+ */
+#define CRYPTO_DES_CBC			(CD_CRYPT_ALG_DES | CD_CRYPT_MODE_CBC)
+#define CRYPTO_3DES_CBC			(CD_CRYPT_ALG_3DES | CD_CRYPT_MODE_CBC)
+#define CRYPTO_AES_CBC			(CD_CRYPT_ALG_AES | CD_CRYPT_MODE_CBC)
+#define CRYPTO_BLF_CBC			(CD_CRYPT_ALG_BFISH | CD_CRYPT_MODE_CBC)
+#define CRYPTO_CAST_CBC			(CD_CRYPT_ALG_CAST | CD_CRYPT_MODE_CBC)
+#define CRYPTO_DES_ECB			(CD_CRYPT_ALG_DES | CD_CRYPT_MODE_ECB)
+#define CRYPTO_3DES_ECB			(CD_CRYPT_ALG_3DES | CD_CRYPT_MODE_ECB)
+#define CRYPTO_AES_ECB			(CD_CRYPT_ALG_AES | CD_CRYPT_MODE_ECB)
+#define CRYPTO_DES_CFB			(CD_CRYPT_ALG_DES | CD_CRYPT_MODE_CFB)
+#define CRYPTO_3DES_CFB			(CD_CRYPT_ALG_3DES | CD_CRYPT_MODE_CFB)
+#define CRYPTO_AES_CFB			(CD_CRYPT_ALG_AES | CD_CRYPT_MODE_CFB)
+#define CRYPTO_DES_OFB			(CD_CRYPT_ALG_DES | CD_CRYPT_MODE_OFB)
+#define CRYPTO_3DES_OFB			(CD_CRYPT_ALG_3DES | CD_CRYPT_MODE_OFB)
+#define CRYPTO_AES_OFB			(CD_CRYPT_ALG_AES | CD_CRYPT_MODE_OFB)
+#define CRYPTO_AES_CTR			(CD_CRYPT_ALG_AES | CD_CRYPT_MODE_CTR)
+#define CRYPTO_SKIPJACK_CBC		(CD_CRYPT_ALG_SKIPJACK | \
+							CD_CRYPT_MODE_CBC)
+/*
+ * Hash Algorithms
+ */
+#define CRYPTO_SHA1			(CD_MAC_ALG_SHA1 | CD_MAC_MODE_NORMAL)
+#define CRYPTO_MD5			(CD_MAC_ALG_MD5 | CD_MAC_MODE_NORMAL)
+#define CRYPTO_SHA1_HMAC		(CD_MAC_ALG_SHA1 | CD_MAC_MODE_HMAC)
+#define CRYPTO_MD5_HMAC			(CD_MAC_ALG_MD5 | CD_MAC_MODE_HMAC)
+#define CRYPTO_RIPEMD160_HMAC		(CD_MAC_ALG_RIPEMD | CD_MAC_MODE_HMAC)
+#define CRYPTO_MD5_KPDK			(CD_MAC_ALG_MD5 | CD_MAC_MODE_NORMAL)
+#define CRYPTO_SHA1_KPDK		(CD_MAC_ALG_SHA1 | CD_MAC_MODE_NORMAL)
+
+/* create crypto session */
+#define CIOCGSESSION    _IOWR('c', 101, struct session_op)
+
+#endif
--- /user/openssl/openssl-0.9.8g/crypto/cryptodev.h	2008-11-20 17:00:19.511566000 -0800
+++ /user/linux/openssl-0.9.8g/crypto/cryptodev.h	2008-12-01 13:34:02.483702000 -0800
@@ -128,8 +128,9 @@
 
 /* Max size of data that can be processed */
#define CRYPTO_MAX_DATA_LEN		64*1024 - 1
 
-
+#ifndef CRYPTODEV_LINUX
#define CRYPTO_ALGORITHM_MIN		1
#define CRYPTO_DES_CBC			1
#define CRYPTO_3DES_CBC			2
@@ -160,7 +161,7 @@
#define CRYPTO_AES_GCM			26
#define CRYPTO_AES_CCM			27
#define CRYPTO_ALGORITHM_MAX		28 /* Keep last */
-
+#endif
 /* Algorithm flags */
#define CRYPTO_ALG_FLAG_SUPPORTED	0x01 /* Algorithm is supported */
#define CRYPTO_ALG_FLAG_RNG_ENABLE	0x02 /* Has HW RNG for DH/DSA */
@@ -178,6 +179,7 @@
#define CRYPTO_FLAG_SOFTWARE	0x02000000	/* software implementation */
 
 /* NB: deprecated */
+#ifndef CRYPTODEV_LINUX
 struct session_op {
 	u_int32_t	cipher;		/* ie. CRYPTO_DES_CBC */
 	u_int32_t	mac;		/* ie. CRYPTO_MD5_HMAC */
@@ -187,8 +189,9 @@
 	int		mackeylen;	/* mac key */
 	caddr_t		mackey;
 
-  	u_int32_t	ses;		/* returns: session # */ 
+	u_int32_t	ses;		/* returns: session # */
};
+#endif
 
 struct session2_op {
 	u_int32_t	cipher;		/* ie. CRYPTO_DES_CBC */
@@ -199,11 +202,12 @@
 	int		mackeylen;	/* mac key */
 	caddr_t		mackey;
 
-  	u_int32_t	ses;		/* returns: session # */
+	u_int32_t	ses;		/* returns: session # */
 	int		crid;		/* driver id + flags (rw) */
 	int		pad[4];		/* for future expansion */
};
 
+#ifndef CRYPTODEV_LINUX
 struct crypt_op {
 	u_int32_t	ses;
 	u_int16_t	op;		/* i.e. COP_ENCRYPT */
@@ -217,7 +221,7 @@
 	caddr_t		mac;		/* must be big enough for chosen MAC */
 	caddr_t		iv;
};
-
+#endif
 /*
  * Parameters for looking up a crypto driver/device by
  * device name or by id.  The latter are returned for
@@ -267,9 +271,14 @@
#define CRIOFINDDEV	CIOCFINDDEV
 
 /* the following are done against the cloned descriptor */
-#define CIOCGSESSION	_IOWR('c', 101, struct session_op)
+/* create crypto session */
+#define CIOCGSESSION    _IOWR('c', 101, struct session_op)
+
+#ifndef CRYPTODEV_LINUX
#define CIOCFSESSION	_IOW('c', 102, u_int32_t)
#define CIOCCRYPT	_IOWR('c', 103, struct crypt_op)
+#endif
+
#define CIOCKEY		_IOWR('c', 104, struct crypt_kop)
#define CIOCASYMFEAT	_IOR('c', 105, u_int32_t)
#define CIOCGSESSION2	_IOWR('c', 106, struct session2_op)

--- /user/openssl/openssl-0.9.8g/crypto/engine/eng_cryptodev.c	2008-07-08 13:43:16.643710000 -0700
+++ /user/linux/openssl-0.9.8g/crypto/engine/eng_cryptodev.c	2008-12-01 13:04:03.748965000 -0800
@@ -30,6 +30,9 @@
 #include <openssl/engine.h>
 #include <openssl/evp.h>
 #include <openssl/bn.h>
+#include <openssl/cryptodev_macro.h>
+
+#define USE_CRYPTODEV_DIGESTS
 
 #if (defined(__unix__) || defined(unix)) && !defined(USG) && \
 	(defined(OpenBSD) || defined(__FreeBSD_version))
@@ -50,10 +53,10 @@
 	/* This is a NOP on platforms without /dev/crypto */
 	return;
 }
-
 #else
  
 #include <sys/types.h>
+#include <sys/uio.h>
 #include <crypto/cryptodev.h>
 #include <sys/ioctl.h>
 #include <errno.h>
@@ -136,6 +139,20 @@
 	{ 0, NULL, NULL, 0 }
 };
 
+/*******************************************************************************
+* Table Lookup for Algorithms name(Crypto/hash name)
+* Helper Structure
+*******************************************************************************
+*/
+
+char *cipher_mode_map_tbl[CD_CRYPT_MODE_MASK_INDEX] = CD_CRYPT_MODES;
+
+char *cipher_alg_map_tbl[CD_CRYPT_ALG_MASK_INDEX] = CD_CRYPT_ALGS;
+
+char *hash_mode_map_tbl[CD_MAC_MODE_MASK_INDEX] = CD_MAC_MODES;
+
+char *hash_alg_map_tbl[CD_MAC_ALG_MASK_INDEX] = CD_MAC_ALGS;
+
 static struct {
 	int	id;
 	int	nid;
@@ -149,7 +166,7 @@
 	{ CRYPTO_BLF_CBC,		NID_bf_cbc,		8,	16, },
 	{ CRYPTO_CAST_CBC,		NID_cast5_cbc,		8,	16, },
 	{ CRYPTO_SKIPJACK_CBC,		NID_undef,		0,	 0, },
-	{ 0,				NID_undef,		0,	 0, },
+	{ 0,				NID_undef,		0,	 0, }
 };
 
 static struct {
@@ -157,19 +174,52 @@
 	int	nid;
 	int 	keylen;
 } digests[] = {
-	{ CRYPTO_SHA1_HMAC,		NID_hmacWithSHA1,	20},
-	{ CRYPTO_RIPEMD160_HMAC,	NID_ripemd160,		16/*?*/},
-	{ CRYPTO_MD5_KPDK,		NID_undef,		0},
-	{ CRYPTO_SHA1_KPDK,		NID_undef,		0},
-	{ CRYPTO_MD5,			NID_md5,		16},
-	{ CRYPTO_SHA1,			NID_sha1,		20},
-	{ 0,				NID_undef,		0},
+	{ CRYPTO_SHA1_HMAC,		NID_hmacWithSHA1,	20,},
+	{ CRYPTO_RIPEMD160_HMAC,	NID_ripemd160,		16,/*?*/},
+	{ CRYPTO_MD5_KPDK,		NID_undef,		0,},
+	{ CRYPTO_SHA1_KPDK,		NID_undef,		0,},
+	{ CRYPTO_MD5,			NID_md5,		0,},
+	{ CRYPTO_SHA1,			NID_sha1,		0,},
+	{ 0,				NID_undef,		0,}
 };
 
+
+void cipher_set_algo(int mode, int cipher, char *alg)
+{
+	mode = mode >> CD_CRYPT_MODE_SHIFT;
+	cipher = cipher  >> CD_CRYPT_ALG_SHIFT;
+	sprintf (alg, "%s(%s)", cipher_mode_map_tbl[mode],
+		 	cipher_alg_map_tbl[cipher]);
+}
+
+void hash_set_algo(int mode, int hash, char *alg)
+{
+	mode = mode >> CD_MAC_MODE_SHIFT;
+	hash = hash  >> CD_MAC_ALG_SHIFT;
+
+	if ( mode == 1)
+		sprintf (alg, "%s", hash_alg_map_tbl[hash]);
+	else 
+		sprintf (alg, "%s(%s)", hash_mode_map_tbl[mode],
+		 hash_alg_map_tbl[hash]);
+}
+
 /*
  * Return a fd if /dev/crypto seems usable, 0 otherwise.
  */
 static int
+open_cryptodev_fd(void)
+{
+	int fd;
+	fd = open("/dev/crypto", O_RDWR, 0);
+	if (fd < 0) {
+		perror("open(/dev/crypto)");
+		return -1;
+	}
+	return fd;
+
+}
+static int
 open_dev_crypto(void)
 {
 	static int fd = -1;
@@ -279,27 +329,37 @@
 get_cryptodev_ciphers(const int **cnids)
 {
 	static int nids[CRYPTO_ALGORITHM_MAX];
-	struct session_op sess;
+	char datam[100];
+	struct session_op *op = (struct session_op *) datam;
 	int fd, i, count = 0;
-
-	if ((fd = get_dev_crypto()) < 0) {
-		*cnids = NULL;
-		return (0);
-	}
-	memset(&sess, 0, sizeof(sess));
-	sess.key = (caddr_t)"123456789abcdefghijklmno";
-
+	char *key;
+	char alg_name[CRYPTO_MAX_ALG_NAME];
+	int mode, alg;
+	
 	for (i = 0; ciphers[i].id && count < CRYPTO_ALGORITHM_MAX; i++) {
 		if (ciphers[i].nid == NID_undef)
 			continue;
-		sess.cipher = ciphers[i].id;
-		sess.keylen = ciphers[i].keylen;
-		sess.mac = 0;
-		if (ioctl(fd, CIOCGSESSION, &sess) != -1 &&
-		    ioctl(fd, CIOCFSESSION, &sess.ses) != -1)
+		if ((fd = open_cryptodev_fd()) < 0) {
+			*cnids = NULL;
+			return (0);
+		}
+		memset(op, 0, sizeof(struct session_op));
+		key = (caddr_t) "123456789abcdefghijklmno";
+		op->key_size = ciphers[i].keylen;
+		op->hmackey_size = 0;
+		alg = (ciphers[i].id) & CD_CRYPT_ALG_MASK;
+		mode = (ciphers[i].id) & CD_CRYPT_MODE_MASK;
+		cipher_set_algo(mode, alg, alg_name);
+		op->algo_size = strlen(alg_name);
+		memcpy(op->data, alg_name, op->algo_size);
+
+		op->data[op->algo_size++] = '\0';
+		memcpy(op->data + op->algo_size, key, op->key_size);
+		
+		if (ioctl(fd, CIOCGSESSION, op) == 0)
 			nids[count++] = ciphers[i].nid;
+		close(fd);
 	}
-	close(fd);
 
 	if (count > 0)
 		*cnids = nids;
@@ -318,27 +378,39 @@
 get_cryptodev_digests(const int **cnids)
 {
 	static int nids[CRYPTO_ALGORITHM_MAX];
-	struct session_op sess;
+	char data[100];
+	struct session_op *op = (struct session_op *)data;
 	int fd, i, count = 0;
+	char *mackey = NULL;
+	int mode, alg;
+	char alg_name[CRYPTO_MAX_ALG_NAME];
 
-	if ((fd = get_dev_crypto()) < 0) {
-		*cnids = NULL;
-		return (0);
-	}
-	memset(&sess, 0, sizeof(sess));
-	sess.mackey = (caddr_t)"123456789abcdefghijklmno";
 	for (i = 0; digests[i].id && count < CRYPTO_ALGORITHM_MAX; i++) {
+		
 		if (digests[i].nid == NID_undef)
 			continue;
-		sess.mac = digests[i].id;
-		sess.mackeylen = digests[i].keylen;
-		sess.cipher = 0;
-		if (ioctl(fd, CIOCGSESSION, &sess) != -1 &&
-		    ioctl(fd, CIOCFSESSION, &sess.ses) != -1)
+		if ((fd = open_cryptodev_fd()) < 0) {
+			*cnids = NULL;
+			return (0);
+		}
+		memset(op, 0, sizeof(struct session_op));
+		op->key_size = 0;
+		op->hmackey_size = digests[i].keylen;
+		if (op->hmackey_size)
+			mackey = (caddr_t) "123456789abcdefghijklmno";
+		alg = digests[i].id & CD_MAC_ALG_MASK;
+		mode = digests[i].id & CD_MAC_MODE_MASK;
+		hash_set_algo(mode, alg, alg_name);
+		op->algo_size = strlen(alg_name);
+		memcpy(op->data, alg_name, op->algo_size);
+		op->data[op->algo_size++] = '\0';
+		memcpy(op->data + op->algo_size, mackey, op->hmackey_size);
+
+		if (ioctl(fd, CIOCGSESSION, op) == 0)
 			nids[count++] = digests[i].nid;
+		close(fd);
+		
 	}
-	close(fd);
-
 	if (count > 0)
 		*cnids = nids;
 	else
@@ -396,13 +468,19 @@
 #endif
 }
 
+
 static int
 cryptodev_cipher(EVP_CIPHER_CTX *ctx, unsigned char *out,
-    const unsigned char *in, unsigned int inl)
+			const unsigned char *in, unsigned int inl)
 {
-	struct crypt_op cryp;
+
 	struct dev_crypto_state *state = ctx->cipher_data;
-	struct session_op *sess = &state->d_sess;
+	char dataop[100];
+	struct crypt_op *cryp = (struct crypt_op *) dataop;
+	int ret;
+	struct iovec iov[3];
+	int nr_segs;
+	
 	void *iiv;
 	unsigned char save_iv[EVP_MAX_IV_LENGTH];
 
@@ -413,31 +491,36 @@
 	if ((inl % ctx->cipher->block_size) != 0)
 		return (0);
 
-	memset(&cryp, 0, sizeof(cryp));
+	memset(cryp, 0, sizeof(struct crypt_op));
 
-	cryp.ses = sess->ses;
-	cryp.flags = 0;
-	cryp.len = inl;
-	cryp.src = (caddr_t) in;
-	cryp.dst = (caddr_t) out;
-	cryp.mac = 0;
+	cryp->iv_size = ctx->cipher->iv_len;
+	cryp->assoc_size = 0;
 
-	cryp.op = ctx->encrypt ? COP_ENCRYPT : COP_DECRYPT;
+	cryp->op = ctx->encrypt ? COP_ENCRYPT : COP_DECRYPT;
 
 	if (ctx->cipher->iv_len) {
-		cryp.iv = (caddr_t) ctx->iv;
+		memcpy(cryp->data, ctx->iv, cryp->iv_size);
 		if (!ctx->encrypt) {
 			iiv = (void *) in + inl - ctx->cipher->iv_len;
 			memcpy(save_iv, iiv, ctx->cipher->iv_len);
 		}
 	} else
-		cryp.iv = NULL;
-
-	if (ioctl(state->d_fd, CIOCCRYPT, &cryp) == -1) {
-		/* XXX need better errror handling
-		 * this can fail for a number of different reasons.
-		 */
-		return (0);
+		cryp->iv_size = 0;
+	
+	iov[0].iov_base = cryp;
+	iov[0].iov_len = sizeof(struct crypt_op) +
+			cryp->iv_size +
+			cryp->assoc_size;
+	iov[1].iov_base = in;
+	iov[1].iov_len = inl;
+	iov[2].iov_base = out;
+	iov[2].iov_len = inl;
+	nr_segs = sizeof(iov) / sizeof(struct iovec);
+
+	ret = writev(state->d_fd, iov, nr_segs);
+	if (ret) {
+		printf("Cipher failed with error = %d\n", errno);
+		return 0;
 	}
 
 	if (ctx->cipher->iv_len) {
@@ -447,45 +530,57 @@
 			iiv = save_iv;
 		memcpy(ctx->iv, iiv, ctx->cipher->iv_len);
 	}
+	
 	return (1);
+
 }
 
 static int
 cryptodev_init_key(EVP_CIPHER_CTX *ctx, const unsigned char *key,
-    const unsigned char *iv, int enc)
+	const unsigned char *iv, int enc)
 {
+
 	struct dev_crypto_state *state = ctx->cipher_data;
-	struct session_op *sess = &state->d_sess;
+	char data[100];
+	struct session_op *op = (struct session_op *)data;
 	int cipher, i;
-
+	int mode, alg;
+	char alg_name[CRYPTO_MAX_ALG_NAME];
+	
 	for (i = 0; ciphers[i].id; i++)
 		if (ctx->cipher->nid == ciphers[i].nid &&
-		    ctx->cipher->iv_len <= ciphers[i].ivmax &&
-		    ctx->key_len == ciphers[i].keylen) {
+				  ctx->cipher->iv_len <= ciphers[i].ivmax &&
+				  ctx->key_len == ciphers[i].keylen) {
 			cipher = ciphers[i].id;
 			break;
 		}
 
 	if (!ciphers[i].id) {
-		state->d_fd = -1;
-		return (0);
+	state->d_fd = -1;
+	return (0);
 	}
 
-	memset(sess, 0, sizeof(struct session_op));
-
-	if ((state->d_fd = get_dev_crypto()) < 0)
-		return (0);
+	if ((state->d_fd = open_cryptodev_fd()) < 0)
+	  return (0);
 
-	sess->key = (unsigned char *)key;
-	sess->keylen = ctx->key_len;
-	sess->cipher = cipher;
+	memset(op, 0, sizeof(struct session_op));
+	op->key_size = ctx->key_len;
+	alg = (ciphers[i].id) & CD_CRYPT_ALG_MASK;
+	mode = (ciphers[i].id) & CD_CRYPT_MODE_MASK;
+	cipher_set_algo(mode, alg, alg_name);
+	op->algo_size = strlen(alg_name);
+	memcpy(op->data, alg_name, op->algo_size);
+	op->data[op->algo_size++] = '\0';
+	memcpy(op->data + op->algo_size, (unsigned char *) key, op->key_size);
 
-	if (ioctl(state->d_fd, CIOCGSESSION, sess) == -1) {
+	if (ioctl(state->d_fd, CIOCGSESSION, op)) {
+		perror("ioctl(CIOCGSESSION)");
 		close(state->d_fd);
 		state->d_fd = -1;
 		return (0);
 	}
 	return (1);
+
 }
 
 /*
@@ -495,9 +590,9 @@
 static int
 cryptodev_cleanup(EVP_CIPHER_CTX *ctx)
 {
+
 	int ret = 0;
 	struct dev_crypto_state *state = ctx->cipher_data;
-	struct session_op *sess = &state->d_sess;
 
 	if (state->d_fd < 0)
 		return (0);
@@ -513,15 +608,11 @@
 	 * print messages to users of the library. hmm..
 	 */
 
-	if (ioctl(state->d_fd, CIOCFSESSION, &sess->ses) == -1) {
-		ret = 0;
-	} else {
-		ret = 1;
-	}
 	close(state->d_fd);
 	state->d_fd = -1;
 
 	return (ret);
+
 }
 
 /*
@@ -616,7 +707,7 @@
  */
 static int
 cryptodev_engine_ciphers(ENGINE *e, const EVP_CIPHER **cipher,
-    const int **nids, int nid)
+				const int **nids, int nid)
 {
 	if (!cipher)
 		return (cryptodev_usable_ciphers(nids));
@@ -678,8 +769,12 @@
 static int cryptodev_digest_init(EVP_MD_CTX *ctx)
 {
 	struct dev_crypto_state *state = ctx->md_data;
-	struct session_op *sess = &state->d_sess;
+	char data[100];
+	struct session_op *sess = (struct session_op *)data;
 	int digest;
+	int ret, alg, mode;
+	char alg_name[CRYPTO_MAX_ALG_NAME];
+	
 
 	if ((digest = digest_nid_to_cryptodev(ctx->digest->type)) == NID_undef){
 		printf("cryptodev_digest_init: Can't get digest \n");
@@ -688,16 +783,26 @@
 
 	memset(state, 0, sizeof(struct dev_crypto_state));
 
-	if ((state->d_fd = get_dev_crypto()) < 0) {
+	if ((state->d_fd = open_cryptodev_fd()) < 0) {
 		printf("cryptodev_digest_init: Can't get Dev \n");
 		return (0);
 	}
 
-	sess->mackey = state->dummy_mac_key;
-	sess->mackeylen = digest_key_length(ctx->digest->type);
-	sess->mac = digest;
-
-	if (ioctl(state->d_fd, CIOCGSESSION, sess) < 0) {
+	memset(sess, 0, sizeof(struct session_op));
+	
+	sess->hmackey_size = digest_key_length(ctx->digest->type);
+	alg = digest & CD_MAC_ALG_MASK;
+	mode = digest & CD_MAC_MODE_MASK;
+	hash_set_algo(mode, alg, alg_name);
+	sess->algo_size = strlen(alg_name);
+	memcpy(sess->data, alg_name, sess->algo_size);
+	sess->data[sess->algo_size++] = '\0';
+	if (sess->hmackey_size)
+		memcpy(sess->data + sess->algo_size,
+		       state->dummy_mac_key, sess->hmackey_size);
+	
+	if ((ret = ioctl(state->d_fd, CIOCGSESSION, sess)) < 0) {
+		perror("ioctl(CIOCGSESSION)");
 		close(state->d_fd);
 		state->d_fd = -1;
 		printf("cryptodev_digest_init: Open session failed\n");
@@ -708,11 +813,14 @@
 }
 
 static int cryptodev_digest_update(EVP_MD_CTX *ctx, const void *data,
-		size_t count)
+					size_t count)
 {
-	struct crypt_op cryp;
+	char datac[100];
+	struct crypt_op *cryp = (struct crypt_op *) datac;
 	struct dev_crypto_state *state = ctx->md_data;
-	struct session_op *sess = &state->d_sess;
+	struct iovec iov[3];
+	int ret = 1;
+	int nr_segs;
 
 	if (!data || state->d_fd < 0) {
 		printf("cryptodev_digest_update: illegal inputs \n");
@@ -733,59 +841,69 @@
 		}
 
 		memcpy(state->mac_data + state->mac_len, data, count);
-   		state->mac_len += count;
+		state->mac_len += count;
 	
 		return (1);
 	}
-
-	memset(&cryp, 0, sizeof(cryp));
-
-	cryp.ses = sess->ses;
-	cryp.flags = 0;
-	cryp.len = count;
-	cryp.src = (caddr_t) data;
-	cryp.dst = NULL;
-	cryp.mac = state->digest_res;
-
-	if (ioctl(state->d_fd, CIOCCRYPT, &cryp) < 0) {
-		printf("cryptodev_digest_update: digest failed xxxxxxx\n");
+	memset(cryp, 0, sizeof(struct crypt_op));
+	
+	cryp->iv_size = 0;
+	cryp->assoc_size = 0;
+	iov[0].iov_base = cryp;
+	iov[0].iov_len = sizeof(struct crypt_op) +
+			cryp->iv_size +
+			cryp->assoc_size;
+	iov[1].iov_base = data;
+	iov[1].iov_len = count;
+	iov[2].iov_base = state->digest_res;
+	iov[2].iov_len = ctx->digest->md_size;
+	nr_segs = sizeof(iov) / sizeof(struct iovec);
+
+	ret = writev(state->d_fd, iov, nr_segs);
+	if (ret) {
+		printf("cryptodev_digest_update: digest failed\n", errno);
 		return (0);
 	}
+
 	return (1);
 }
 
 
 static int cryptodev_digest_final(EVP_MD_CTX *ctx, unsigned char *md)
 {
-	struct crypt_op cryp;
+	char dataop[100];
+	struct crypt_op *cryp = (struct crypt_op *) dataop;
 	struct dev_crypto_state *state = ctx->md_data;
-	struct session_op *sess = &state->d_sess;
-
+	struct iovec iov[3];
 	int ret = 1;
-
+	int nr_segs;
+	
 	if (!md || state->d_fd < 0) {
 		printf("cryptodev_digest_final: illegal input\n");
 		return(0);
 	}
-	/**FIXME**/
-	//printf("Calling Digest Function aaaaaa\n");
 
 	if (! (ctx->flags & EVP_MD_CTX_FLAG_ONESHOT) ) {
 		/* if application doesn't support one buffer */
-		memset(&cryp, 0, sizeof(cryp));
+		memset(cryp, 0, sizeof(struct crypt_op));
 
-		cryp.ses = sess->ses;
-		cryp.flags = 0;
-		cryp.len = state->mac_len;
-		cryp.src = state->mac_data;
-		cryp.dst = NULL;
-		cryp.mac = md;
-
-		if (ioctl(state->d_fd, CIOCCRYPT, &cryp) < 0) {
-			printf("cryptodev_digest_final: digest failed nnnnnnn\n");
+		cryp->iv_size = 0;
+		cryp->assoc_size = 0;
+		iov[0].iov_base = cryp;
+		iov[0].iov_len = sizeof(struct crypt_op) +
+				cryp->iv_size +
+				cryp->assoc_size;
+		iov[1].iov_base = state->mac_data;
+		iov[1].iov_len = state->mac_len;
+		iov[2].iov_base = md;
+		iov[2].iov_len = ctx->digest->md_size;
+		nr_segs = sizeof(iov) / sizeof(struct iovec);
+
+		ret = writev(state->d_fd, iov, nr_segs);
+		if (ret) {
+			printf("Final Digest Failed\n = %d", errno);
 			return (0);
 		}
-
 		return 1;
 	}
 
@@ -799,7 +917,6 @@
 {
 	int ret = 1;
 	struct dev_crypto_state *state = ctx->md_data;
-	struct session_op *sess = &state->d_sess;
 
 	if (state->d_fd < 0) {
 		printf("cryptodev_digest_cleanup: illegal input\n");
@@ -815,13 +932,7 @@
 	if (state->copy)
 		return 1;
 
-	if (ioctl(state->d_fd, CIOCFSESSION, &sess->ses) < 0) {
-		printf("cryptodev_digest_cleanup: failed to close session\n");
-		ret = 0;
-	} else {
-		ret = 1;
-	}
-	close(state->d_fd);	
+	close(state->d_fd);
 	state->d_fd = -1;
 
 	return (ret);
@@ -880,7 +991,7 @@
 
 static int
 cryptodev_engine_digests(ENGINE *e, const EVP_MD **digest,
-    const int **nids, int nid)
+				const int **nids, int nid)
 {
 	if (!digest)
 		return (cryptodev_usable_digests(nids));
@@ -1336,6 +1447,8 @@
 
 	if (engine == NULL)
 		return;
+	/*Asymmetic Crypto Algorithms not yet supported by Linux Cryptodev*/
+#ifndef CRYPTODEV_LINUX
 	if ((fd = get_dev_crypto()) < 0) {
 		ENGINE_free(engine);
 		return;
@@ -1350,7 +1463,7 @@
 		return;
 	}
 	close(fd);
