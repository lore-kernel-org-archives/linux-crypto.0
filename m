From: "Shasi Pulijala" <spulijala@amcc.com>
Subject: Updated Openssl Patch to support Linux CryptoAPI
Date: Thu, 20 Nov 2008 17:58:15 -0800
Message-ID: <DB599F406D04E34389140B7D99C71B1B0679695D@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Loc Ho" <lho@amcc.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:31710 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYKUB6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Nov 2008 20:58:38 -0500
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, 
 
OpenSSL patch to support Linux CryptoAPI via CryptoDev interface. This patch needs to be applied after the ocf patch is applied to the OpenSSL source. This patch is being resubmitted with some changes to support the changes that have been made to the Linux Cryptodev interface, since the last Openssl patch submission.

--- /user/spulijala/openssl/openssl-0.9.8g/crypto/cryptodev.h	2008-11-20 17:00:19.511566000 -0800
+++ /user/spulijala/linux/openssl-0.9.8g/crypto/cryptodev.h	2008-11-20 15:07:10.853009000 -0800
@@ -61,6 +61,8 @@
#ifndef _CRYPTO_CRYPTO_H_
#define _CRYPTO_CRYPTO_H_
 
+#include <linux/types.h>
+
 /* Some initial values */
#define CRYPTO_DRIVERS_INITIAL	4
#define CRYPTO_SW_SESSIONS	32
@@ -128,6 +130,7 @@
 
 /* Max size of data that can be processed */
#define CRYPTO_MAX_DATA_LEN		64*1024 - 1
+#define CRYPTO_MAX_ALG_NAME		20
 
 
#define CRYPTO_ALGORITHM_MIN		1
@@ -178,16 +181,13 @@
#define CRYPTO_FLAG_SOFTWARE	0x02000000	/* software implementation */
 
 /* NB: deprecated */
-struct session_op {
-	u_int32_t	cipher;		/* ie. CRYPTO_DES_CBC */
-	u_int32_t	mac;		/* ie. CRYPTO_MD5_HMAC */
 
-	u_int32_t	keylen;		/* cipher key */
-	caddr_t		key;
-	int		mackeylen;	/* mac key */
-	caddr_t		mackey;
-
-  	u_int32_t	ses;		/* returns: session # */ 
+struct session_op {
+	__u16		algo_size;
+	__u16		key_size;	/* cipher key length */
+	__u16		hmackey_size;	/* mac key length */
+	__u16		icv_size;	/* authsize (ccm, gcm) */
+	__u8		data[0];
};

 struct crypt_op {
-	u_int32_t	ses;
-	u_int16_t	op;		/* i.e. COP_ENCRYPT */
#define COP_NONE	0
#define COP_ENCRYPT	1
#define COP_DECRYPT	2
-	u_int16_t	flags;
-#define	COP_F_BATCH	0x0008		/* Batch op if possible */
-	u_int		len;
-	caddr_t		src, dst;	/* become iov[] inside kernel */
-	caddr_t		mac;		/* must be big enough for chosen MAC */
-	caddr_t		iv;
+	__u16		op;		/* i.e. COP_ENCRYPT */
+	__u16		flags;
+	__u16		iv_size;
+	__u16 		assoc_size;
+	__u8		data[0];	/* must be big enough for chosen MAC */
};
-
 /*
  * Parameters for looking up a crypto driver/device by
  * device name or by id.  The latter are returned for
@@ -267,9 +263,8 @@
#define CRIOFINDDEV	CIOCFINDDEV
 
 /* the following are done against the cloned descriptor */
-#define CIOCGSESSION	_IOWR('c', 101, struct session_op)
-#define CIOCFSESSION	_IOW('c', 102, u_int32_t)
-#define CIOCCRYPT	_IOWR('c', 103, struct crypt_op)
+/* create crypto session */
+#define CIOCGSESSION    _IOWR('c', 101, struct session_op)
#define CIOCKEY		_IOWR('c', 104, struct crypt_kop)
#define CIOCASYMFEAT	_IOR('c', 105, u_int32_t)
#define CIOCGSESSION2	_IOWR('c', 106, struct session2_op)

--- /user/spulijala/openssl/openssl-0.9.8g/crypto/engine/eng_cryptodev.c	2008-07-08 13:43:16.643710000 -0700
+++ /user/spulijala/linux/openssl-0.9.8g/crypto/engine/eng_cryptodev.c	2008-11-20 17:10:08.850713000 -0800
@@ -31,6 +31,9 @@
 #include <openssl/evp.h>
 #include <openssl/bn.h>
 
+#define CRYPTODEV_LINUX
+#define USE_CRYPTODEV_DIGESTS
+
 #if (defined(__unix__) || defined(unix)) && !defined(USG) && \
 	(defined(OpenBSD) || defined(__FreeBSD_version))
 #include <sys/param.h>
@@ -54,6 +57,7 @@
 #else
  
 #include <sys/types.h>
+#include <sys/uio.h>
 #include <crypto/cryptodev.h>
 #include <sys/ioctl.h>
 #include <errno.h>
@@ -136,6 +140,43 @@
 	{ 0, NULL, NULL, 0 }
 };
 
+/*******************************************************************************
+* Table Lookup for Algorithms name(Crypto/hash name)
+* Helper Structure
+*******************************************************************************
+*/
+char *algo_map_tbl[CRYPTO_ALGORITHM_MAX] = {
+	[CRYPTO_DES_CBC]  	= "cbc(des)",
+	[CRYPTO_3DES_CBC] 	= "cbc(des3_ede)",
+	[CRYPTO_MD5_HMAC] 	= "hmac(md5)",
+	[CRYPTO_BLF_CBC]  	= "cbc(blowfish)",
+	[CRYPTO_CAST_CBC]	= "cbc(cast5)",
+	[CRYPTO_SKIPJACK_CBC]	= "camellia",
+	[CRYPTO_MD5_HMAC]	= "hmac(md5)",
+	[CRYPTO_SHA1_HMAC]	= "hmac(sha1)",
+	[CRYPTO_RIPEMD160_HMAC]	= "hmac(rmd160)",
+	[CRYPTO_MD5_KPDK]	= "",
+	[CRYPTO_SHA1_KPDK]	= "",
+	[CRYPTO_RIJNDAEL128_CBC] = "cbc(aes)",
+	[CRYPTO_AES_CBC]	= "cbc(aes)",
+	[CRYPTO_ARC4]		= "ecb(arc4)",
+	[CRYPTO_MD5]		= "md5",
+	[CRYPTO_SHA1]		= "sha1",
+	[CRYPTO_NULL_HMAC]	= "",
+	[CRYPTO_NULL_CBC]	= "",
+	[CRYPTO_DEFLATE_COMP]	= "deflate",
+	[CRYPTO_SHA2_256_HMAC]	= "hmac(sha256)",
+	[CRYPTO_SHA2_384_HMAC]	= "hmac(sha384)",
+	[CRYPTO_SHA2_512_HMAC]	= "hmac(sha512)",
+	[CRYPTO_CAMELLIA_CBC]	= "cbc(camellia)",
+	[CRYPTO_SHA2_256]	= "sha256",
+	[CRYPTO_SHA2_384]	= "sha384",
+	[CRYPTO_SHA2_512]	= "sha512",
+	[CRYPTO_RIPEMD160]	= "rmd160",
+	[CRYPTO_AES_GCM]	= "gcm(aes)",
+	[CRYPTO_AES_CCM]	= "ccm(aes)",
+};
+
 static struct {
 	int	id;
 	int	nid;
@@ -161,8 +202,8 @@
 	{ CRYPTO_RIPEMD160_HMAC,	NID_ripemd160,		16/*?*/},
 	{ CRYPTO_MD5_KPDK,		NID_undef,		0},
 	{ CRYPTO_SHA1_KPDK,		NID_undef,		0},
-	{ CRYPTO_MD5,			NID_md5,		16},
-	{ CRYPTO_SHA1,			NID_sha1,		20},
+	{ CRYPTO_MD5,			NID_md5,		0},
+	{ CRYPTO_SHA1,			NID_sha1,		0},
 	{ 0,				NID_undef,		0},
 };
 
@@ -170,6 +211,18 @@
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
@@ -279,27 +332,31 @@
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
+		op->algo_size = strlen(algo_map_tbl[ciphers[i].id]);
+		op->key_size = ciphers[i].keylen;
+		op->hmackey_size = 0;
+		memcpy(op->data, algo_map_tbl[ciphers[i].id], op->algo_size);
+		op->data[op->algo_size++] = '\0';
+		memcpy(op->data + op->algo_size, key, op->key_size);
+		
+		if (ioctl(fd, CIOCGSESSION, op) != -1)
 			nids[count++] = ciphers[i].nid;
+		close(fd);
 	}
-	close(fd);
 
 	if (count > 0)
 		*cnids = nids;
@@ -318,26 +375,34 @@
 get_cryptodev_digests(const int **cnids)
 {
 	static int nids[CRYPTO_ALGORITHM_MAX];
-	struct session_op sess;
+	char data[100];
+	struct session_op *op = (struct session_op *)data;
 	int fd, i, count = 0;
+	char *mackey = NULL;
 
-	if ((fd = get_dev_crypto()) < 0) {
-		*cnids = NULL;
-		return (0);
-	}
-	memset(&sess, 0, sizeof(sess));
-	sess.mackey = (caddr_t)"123456789abcdefghijklmno";
 	for (i = 0; digests[i].id && count < CRYPTO_ALGORITHM_MAX; i++) {
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
+
+		memset(op, 0, sizeof(struct session_op));
+		op->algo_size = strlen(algo_map_tbl[digests[i].id]);
+		op->key_size = 0;
+		op->hmackey_size = digests[i].keylen;
+		memcpy(op->data, algo_map_tbl[digests[i].id], op->algo_size);
+		if (op->hmackey_size)
+			mackey = (caddr_t) "123456789abcdefghijklmno";
+		op->data[op->algo_size++] = '\0';
+		memcpy(op->data + op->algo_size, mackey, op->hmackey_size);
+
+		if (ioctl(fd, CIOCGSESSION, op) != -1)
 			nids[count++] = digests[i].nid;
+		close(fd);
+		
 	}
-	close(fd);
 
 	if (count > 0)
 		*cnids = nids;
@@ -396,13 +461,19 @@
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
 
@@ -413,31 +484,35 @@
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
+	nr_segs = sizeof(iov) / sizeof(struct iovec);
+
+	ret = writev(state->d_fd, iov, nr_segs);
+	if (ret) {
+		printf("Cipher failed with error = %d\n", ret);
+		return 0;
 	}
 
 	if (ctx->cipher->iv_len) {
@@ -447,45 +522,51 @@
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
-
-	sess->key = (unsigned char *)key;
-	sess->keylen = ctx->key_len;
-	sess->cipher = cipher;
+	if ((state->d_fd = open_cryptodev_fd()) < 0)
+	  return (0);
 
-	if (ioctl(state->d_fd, CIOCGSESSION, sess) == -1) {
-		close(state->d_fd);
-		state->d_fd = -1;
-		return (0);
+	memset(op, 0, sizeof(struct session_op));
+	op->algo_size = strlen(algo_map_tbl[cipher]);
+	op->key_size = ctx->key_len;
+	memcpy(op->data, algo_map_tbl[ciphers[i].id], op->algo_size);
+	op->data[op->algo_size++] = '\0';
+	memcpy(op->data + op->algo_size, (unsigned char *) key, op->key_size);
+
+	if (ioctl(state->d_fd, CIOCGSESSION, op) == -1) {
+			 close(state->d_fd);
+			  state->d_fd = -1;
+			return (0);
 	}
 	return (1);
+
 }
 
 /*
@@ -495,9 +576,9 @@
 static int
 cryptodev_cleanup(EVP_CIPHER_CTX *ctx)
 {
+
 	int ret = 0;
 	struct dev_crypto_state *state = ctx->cipher_data;
-	struct session_op *sess = &state->d_sess;
 
 	if (state->d_fd < 0)
 		return (0);
@@ -513,15 +594,11 @@
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
@@ -616,7 +693,7 @@
  */
 static int
 cryptodev_engine_ciphers(ENGINE *e, const EVP_CIPHER **cipher,
-    const int **nids, int nid)
+				const int **nids, int nid)
 {
 	if (!cipher)
 		return (cryptodev_usable_ciphers(nids));
@@ -678,8 +755,11 @@
 static int cryptodev_digest_init(EVP_MD_CTX *ctx)
 {
 	struct dev_crypto_state *state = ctx->md_data;
-	struct session_op *sess = &state->d_sess;
+	char data[100];
+	struct session_op *sess = (struct session_op *)data;
 	int digest;
+	int ret;
+	
 
 	if ((digest = digest_nid_to_cryptodev(ctx->digest->type)) == NID_undef){
 		printf("cryptodev_digest_init: Can't get digest \n");
@@ -688,16 +768,21 @@
 
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
+	sess->algo_size = strlen(algo_map_tbl[digest]);
+	sess->hmackey_size = digest_key_length(ctx->digest->type);
+	memcpy(sess->data, algo_map_tbl[digest], sess->algo_size);
+	sess->data[sess->algo_size++] = '\0';
+	if (sess->hmackey_size)
+		memcpy(sess->data + sess->algo_size,
+		       state->dummy_mac_key, sess->hmackey_size);
+	
+	if ((ret = ioctl(state->d_fd, CIOCGSESSION, sess)) < 0) {
 		close(state->d_fd);
 		state->d_fd = -1;
 		printf("cryptodev_digest_init: Open session failed\n");
@@ -708,11 +793,14 @@
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
@@ -733,56 +821,65 @@
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
+	nr_segs = sizeof(iov) / sizeof(struct iovec);
+
+	ret = writev(state->d_fd, iov, nr_segs);
+	if (ret) {
+		printf("cryptodev_digest_update: digest failed\n");
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
+		nr_segs = sizeof(iov) / sizeof(struct iovec);
+
+		ret = writev(state->d_fd, iov, nr_segs);
+		if (ret) {
+			printf("cryptodev_digest_final: digest failed Final\n");
 			return (0);
 		}
 
@@ -799,7 +896,6 @@
 {
 	int ret = 1;
 	struct dev_crypto_state *state = ctx->md_data;
-	struct session_op *sess = &state->d_sess;
 
 	if (state->d_fd < 0) {
 		printf("cryptodev_digest_cleanup: illegal input\n");
@@ -815,13 +911,7 @@
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
@@ -880,7 +970,7 @@
 
 static int
 cryptodev_engine_digests(ENGINE *e, const EVP_MD **digest,
-    const int **nids, int nid)
+				const int **nids, int nid)
 {
 	if (!digest)
 		return (cryptodev_usable_digests(nids));
@@ -1336,6 +1426,8 @@
 
 	if (engine == NULL)
 		return;
+	/*Asymmetic Crypto Algorithms not yet supported by Linux Cryptodev*/
+#ifndef CRYPTODEV_LINUX
 	if ((fd = get_dev_crypto()) < 0) {
 		ENGINE_free(engine);
 		return;
@@ -1350,7 +1442,7 @@
 		return;
 	}
 	close(fd);
