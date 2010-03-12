From: Roberto Sassu <roberto.sassu@polito.it>
Subject: Re: Converting mac80211 CCMP to packet-at-a-time processing
Date: Fri, 12 Mar 2010 11:49:54 +0100
Message-ID: <201003121149.55037.roberto.sassu@polito.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3009229.Oko97AiT6n";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
To: Pavel Roskin <proski@gnu.org>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:55544 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab0CLKuB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Mar 2010 05:50:01 -0500
Received: by fxm27 with SMTP id 27so1287755fxm.28
        for <linux-crypto@vger.kernel.org>; Fri, 12 Mar 2010 02:49:59 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart3009229.Oko97AiT6n
Content-Type: multipart/mixed;
  boundary="Boundary-01=_SxhmLxKM++R5isF"
Content-Transfer-Encoding: 7bit


--Boundary-01=_SxhmLxKM++R5isF
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello

i'm not expert with cryptographic modules, but i played sometime with the=20
"authenc" module, which is AEAD, and i applied it to the filesystem "ecrypt=
fs".
In the forwarded message i added a brief description of what i do and i hop=
e=20
this can be a useful example for you.=20

--Boundary-01=_SxhmLxKM++R5isF
Content-Type: message/rfc822;
  name="forwarded message"
Content-Transfer-Encoding: 7bit
Content-Description: Roberto Sassu <roberto.sassu@polito.it>: Authenc support for ecryptfs
Content-Disposition: inline

From: Roberto Sassu <roberto.sassu@polito.it>
To: ecryptfs-devel@lists.launchpad.net
Subject: Authenc support for ecryptfs
Date: Fri, 12 Mar 2010 11:42:37 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.32.9-70.fc12.x86_64; KDE/4.4.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2888521.RuA5DiXYQr";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201003121142.41996.roberto.sassu@polito.it>

--nextPart2888521.RuA5DiXYQr
Content-Type: multipart/mixed;
  boundary="Boundary-01=_eqhmLnC2CPiMKIe"
Content-Transfer-Encoding: 7bit


--Boundary-01=_eqhmLnC2CPiMKIe
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello all

i developed a patch for ecryptfs in order to take advantage of the authenc=
=20
module. This permits to use encryption or encryption with authentication wi=
th=20
one single tfm.
In order to use authentication i made the following changes:
=2D Generation of an authentication key (for now only 16-bit keys are=20
supported);
=2D Authentication algorithm tested: "hmac(sha1)" and "digest_null";
=2D modified the file format, adding 20 bytes after each extent;
=2D modified the tag 3 packet format in order to specify if authentication =
on=20
data must be checked;
=2D added parameter "ecryptfs_auth" and "ecryptfs_auth_key_bytes" parameter=
s to=20
mount to specify the algorithm and the size of the key will be used to perf=
orm=20
authentication on data;
=2D backward compatibility with the current ecryptfs code;
=2D no integrity verification on the header for now.

Just a remark: the patch must be applied to the latest kernel (2.6.34-rc1)=
=20
because the 2.6.33 has a bug in the authenc module.

--Boundary-01=_eqhmLnC2CPiMKIe
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ecryptfs_authenc_patch.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ecryptfs_authenc_patch.diff"

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 7cb0a59..d42a59d 100644
=2D-- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -33,19 +33,68 @@
 #include <linux/crypto.h>
 #include <linux/file.h>
 #include <linux/scatterlist.h>
+#include <crypto/authenc.h>
+#include <linux/rtnetlink.h>
 #include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
=20
 static int
 ecryptfs_decrypt_page_offset(struct ecryptfs_crypt_stat *crypt_stat,
 			     struct page *dst_page, int dst_offset,
=2D			     struct page *src_page, int src_offset, int size,
+			     struct page *src_page, int src_offset, int size, unsigned char *au=
th,
 			     unsigned char *iv);
 static int
 ecryptfs_encrypt_page_offset(struct ecryptfs_crypt_stat *crypt_stat,
 			     struct page *dst_page, int dst_offset,
=2D			     struct page *src_page, int src_offset, int size,
+			     struct page *src_page, int src_offset, int size, unsigned char *au=
th,
 			     unsigned char *iv);
+/*
+ * struct for async completion
+ */
+struct crypto_async_completion {
+	struct completion completion;
+	int err;
+};
+
+/*
+ * callback for handling the completion of an async request
+ */
+void crypto_async_request_cb_complete(struct crypto_async_request *req, in=
t err)
+{
+	struct crypto_async_completion *res =3D req->data;
+
+	if (err =3D=3D -EINPROGRESS)
+		return;
+
+	res->err =3D err;
+	complete(&res->completion);
+}
+
+/*
+ * wait completion of async request
+ */
+int crypto_async_wait_for_completion(struct crypto_async_completion *ahash=
_result, int cur_ret)
+{
+	int ret =3D cur_ret;
+
+	switch (ret) {
+		case 0:
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret =3D wait_for_completion_interruptible(&ahash_result->completion);
+			if (!ret && !(ret =3D ahash_result->err)) {
+				INIT_COMPLETION(ahash_result->completion);
+				break;
+			}
+			/* fall through */
+		default:
+			/* error */
+			break;
+	}
+
+	return ret;
+}
=20
 /**
  * ecryptfs_to_hex
@@ -144,21 +193,29 @@ out:
=20
 static int ecryptfs_crypto_api_algify_cipher_name(char **algified_name,
 						  char *cipher_name,
=2D						  char *chaining_modifier)
+						  char *chaining_modifier, char *auth_name)
 {
 	int cipher_name_len =3D strlen(cipher_name);
 	int chaining_modifier_len =3D strlen(chaining_modifier);
+	int auth_name_len =3D auth_name ? strlen(auth_name) : 0;
 	int algified_name_len;
 	int rc;
=20
=2D	algified_name_len =3D (chaining_modifier_len + cipher_name_len + 3);
+	if(auth_name_len)
+		algified_name_len =3D (7 + 3 + auth_name_len + chaining_modifier_len + c=
ipher_name_len + 3);
+	else
+		algified_name_len =3D (chaining_modifier_len + cipher_name_len + 3); =20
 	(*algified_name) =3D kmalloc(algified_name_len, GFP_KERNEL);
 	if (!(*algified_name)) {
 		rc =3D -ENOMEM;
 		goto out;
 	}
=2D	snprintf((*algified_name), algified_name_len, "%s(%s)",
=2D		 chaining_modifier, cipher_name);
+	if(auth_name_len)
+		snprintf((*algified_name), algified_name_len, "authenc(%s,%s(%s))", auth=
_name,
+			chaining_modifier, cipher_name);
+	else
+		snprintf((*algified_name), algified_name_len, "%s(%s)",
+			chaining_modifier, cipher_name);
 	rc =3D 0;
 out:
 	return rc;
@@ -242,7 +299,7 @@ void ecryptfs_destroy_crypt_stat(struct ecryptfs_crypt_=
stat *crypt_stat)
 	struct ecryptfs_key_sig *key_sig, *key_sig_tmp;
=20
 	if (crypt_stat->tfm)
=2D		crypto_free_blkcipher(crypt_stat->tfm);
+		crypto_free_aead(crypt_stat->tfm);
 	if (crypt_stat->hash_tfm)
 		crypto_free_hash(crypt_stat->hash_tfm);
 	list_for_each_entry_safe(key_sig, key_sig_tmp,
@@ -337,11 +394,15 @@ static int encrypt_scatterlist(struct ecryptfs_crypt_=
stat *crypt_stat,
 			       struct scatterlist *src_sg, int size,
 			       unsigned char *iv)
 {
=2D	struct blkcipher_desc desc =3D {
=2D		.tfm =3D crypt_stat->tfm,
=2D		.info =3D iv,
=2D		.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP
=2D	};
+	struct aead_request *req =3D NULL;
+	struct crypto_async_completion result;
+	unsigned char *assoc =3D NULL;
+	struct scatterlist asg;
+	struct rtattr *rta;
+	unsigned char *p;
+	int keylen =3D 0;
+	unsigned char *key =3D NULL;
+	struct crypto_authenc_key_param *param;
 	int rc =3D 0;
=20
 	BUG_ON(!crypt_stat || !crypt_stat->tfm
@@ -352,24 +413,102 @@ static int encrypt_scatterlist(struct ecryptfs_crypt=
_stat *crypt_stat,
 		ecryptfs_dump_hex(crypt_stat->key,
 				  crypt_stat->key_size);
 	}
+
 	/* Consider doing this once, when the file is opened */
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
+=09
+	init_completion(&result.completion);
+=09
+	req =3D aead_request_alloc(crypt_stat->tfm, GFP_KERNEL);
+	if (!req) {
+		ecryptfs_printk(KERN_ERR, "Failed to allocate request; [%d]\n",
+				rc);
+		mutex_unlock(&crypt_stat->cs_tfm_mutex);
+		rc =3D -EINVAL;
+		return rc;
+	}
+
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
+				  crypto_async_request_cb_complete, &result);
+
 	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
=2D		rc =3D crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
=2D					     crypt_stat->key_size);
+		keylen =3D crypt_stat->key_size + crypt_stat->auth_key_size + RTA_SPACE(=
sizeof(*param));
+		key =3D kzalloc(keylen, GFP_KERNEL);
+		if(!key) {
+			rc =3D -ENOMEM;
+			ecryptfs_printk(KERN_ERR, "Out of memory\n");
+			mutex_unlock(&crypt_stat->cs_tfm_mutex);
+			goto out;
+		}
+	 =20
+		p =3D key;
+		rta =3D (void *)p;
+		rta->rta_type =3D CRYPTO_AUTHENC_KEYA_PARAM;
+		rta->rta_len =3D RTA_LENGTH(sizeof(*param));
+		param =3D RTA_DATA(rta);
+		p +=3D RTA_SPACE(sizeof(*param));
+
+		if(crypt_stat->auth_key_size) {
+			memcpy(p, crypt_stat->key, crypt_stat->auth_key_size);
+			p +=3D crypt_stat->auth_key_size;
+		}
+=09
+		param->enckeylen =3D cpu_to_be32(crypt_stat->key_size);
+		memcpy(p, crypt_stat->key + crypt_stat->auth_key_size, crypt_stat->key_s=
ize);
+
+		rc =3D crypto_aead_setkey(crypt_stat->tfm, key, keylen);	=09
+		if (rc) {
+			ecryptfs_printk(KERN_ERR, "Error setting key; rc =3D [%d]\n",
+					rc);
+			mutex_unlock(&crypt_stat->cs_tfm_mutex);
+			rc =3D -EINVAL;
+			goto out;
+		}
 		crypt_stat->flags |=3D ECRYPTFS_KEY_SET;
 	}
=2D	if (rc) {
=2D		ecryptfs_printk(KERN_ERR, "Error setting key; rc =3D [%d]\n",
=2D				rc);
+
+	if(crypt_stat->authsize) {
+		rc =3D crypto_aead_setauthsize(crypt_stat->tfm, crypt_stat->authsize);
+		if (rc) {
+			ecryptfs_printk(KERN_ERR, "alg: aead: Failed to set "
+					"authsize to %u\n", crypt_stat->authsize);
+			mutex_unlock(&crypt_stat->cs_tfm_mutex);
+			rc =3D -EINVAL;
+			goto out;
+		}
+	}
+=09
+	ecryptfs_printk(KERN_DEBUG, "Encrypting [%d] bytes.\n", size);
+
+	assoc =3D kstrdup(ECRYPTFS_ASSOC_STRING, GFP_KERNEL);
+	if(!assoc) {
+		rc =3D -ENOMEM;
+		ecryptfs_printk(KERN_ERR, "Out of memory\n");
 		mutex_unlock(&crypt_stat->cs_tfm_mutex);
=2D		rc =3D -EINVAL;
 		goto out;
 	}
=2D	ecryptfs_printk(KERN_DEBUG, "Encrypting [%d] bytes.\n", size);
=2D	crypto_blkcipher_encrypt_iv(&desc, dest_sg, src_sg, size);
+	=09
+	sg_init_one(&asg, assoc, ECRYPTFS_ASSOC_LEN);
+
+	aead_request_set_crypt(req, src_sg, dest_sg, size, iv);
+	aead_request_set_assoc(req, &asg, ECRYPTFS_ASSOC_LEN);
+=09
+	rc =3D crypto_aead_encrypt(req);
+	if(rc =3D=3D -EBUSY || rc =3D=3D -EINPROGRESS) {
+		rc =3D wait_for_completion_interruptible(&result.completion);
+		if (!rc && !(rc =3D result.err)) {
+			INIT_COMPLETION(result.completion);
+		}
+	}
+
 	mutex_unlock(&crypt_stat->cs_tfm_mutex);
 out:
+	if(assoc)
+		kfree(assoc);
+	if(key)
+		kfree(key);
+
+	aead_request_free(req);
 	return rc;
 }
=20
@@ -381,8 +520,8 @@ out:
 static void ecryptfs_lower_offset_for_extent(loff_t *offset, loff_t extent=
_num,
 					     struct ecryptfs_crypt_stat *crypt_stat)
 {
=2D	(*offset) =3D (crypt_stat->num_header_bytes_at_front
=2D		     + (crypt_stat->extent_size * extent_num));
+	(*offset) =3D (crypt_stat->num_header_bytes_at_front + crypt_stat->authsi=
ze
+		     + ((crypt_stat->extent_size + crypt_stat->authsize) * extent_num));
 }
=20
 /**
@@ -400,7 +539,7 @@ static void ecryptfs_lower_offset_for_extent(loff_t *of=
fset, loff_t extent_num,
  */
 static int ecryptfs_encrypt_extent(struct page *enc_extent_page,
 				   struct ecryptfs_crypt_stat *crypt_stat,
=2D				   struct page *page,
+				   struct page *page, unsigned char *auth,
 				   unsigned long extent_offset)
 {
 	loff_t extent_base;
@@ -432,7 +571,7 @@ static int ecryptfs_encrypt_extent(struct page *enc_ext=
ent_page,
 	rc =3D ecryptfs_encrypt_page_offset(crypt_stat, enc_extent_page, 0,
 					  page, (extent_offset
 						 * crypt_stat->extent_size),
=2D					  crypt_stat->extent_size, extent_iv);
+					  crypt_stat->extent_size, auth, extent_iv);
 	if (rc < 0) {
 		printk(KERN_ERR "%s: Error attempting to encrypt page with "
 		       "page->index =3D [%ld], extent_offset =3D [%ld]; "
@@ -448,6 +587,8 @@ static int ecryptfs_encrypt_extent(struct page *enc_ext=
ent_page,
 		ecryptfs_printk(KERN_DEBUG, "First 8 bytes after "
 				"encryption:\n");
 		ecryptfs_dump_hex((char *)(page_address(enc_extent_page)), 8);
+		ecryptfs_printk(KERN_DEBUG, "Auth: \n");
+		ecryptfs_dump_hex(auth, crypt_stat->authsize);
 	}
 out:
 	return rc;
@@ -477,7 +618,8 @@ int ecryptfs_encrypt_page(struct page *page)
 	struct page *enc_extent_page =3D NULL;
 	loff_t extent_offset;
 	int rc =3D 0;
=2D
+	unsigned char *auth =3D NULL;
+=09
 	ecryptfs_inode =3D page->mapping->host;
 	crypt_stat =3D
 		&(ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat);
@@ -490,34 +632,57 @@ int ecryptfs_encrypt_page(struct page *page)
 		goto out;
 	}
 	enc_extent_virt =3D kmap(enc_extent_page);
+	if(crypt_stat->authsize) {
+		auth =3D kzalloc(crypt_stat->authsize, GFP_KERNEL);
+		if(!auth) {
+			rc =3D -ENOMEM;
+			ecryptfs_printk(KERN_ERR, "Error allocating memory for "
+					"auth\n");
+			goto out;
+		}
+	}
 	for (extent_offset =3D 0;
 	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
 	     extent_offset++) {
 		loff_t offset;
=20
=2D		rc =3D ecryptfs_encrypt_extent(enc_extent_page, crypt_stat, page,
+		rc =3D ecryptfs_encrypt_extent(enc_extent_page, crypt_stat, page, auth,
 					     extent_offset);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting extent; "
 			       "rc =3D [%d]\n", __func__, rc);
 			goto out;
 		}
+	=09
 		ecryptfs_lower_offset_for_extent(
 			&offset, ((((loff_t)page->index)
 				   * (PAGE_CACHE_SIZE
 				      / crypt_stat->extent_size))
 				  + extent_offset), crypt_stat);
+
 		rc =3D ecryptfs_write_lower(ecryptfs_inode, enc_extent_virt,
=2D					  offset, crypt_stat->extent_size);
+					  offset, crypt_stat->extent_size); =20
 		if (rc < 0) {
 			ecryptfs_printk(KERN_ERR, "Error attempting "
 					"to write lower page; rc =3D [%d]"
 					"\n", rc);
 			goto out;
 		}
+		if(crypt_stat->authsize) {
+			rc =3D ecryptfs_write_lower(ecryptfs_inode, auth,
+						offset + crypt_stat->extent_size, crypt_stat->authsize); =20
+			if (rc < 0) {
+				ecryptfs_printk(KERN_ERR, "Error attempting "
+						"to write auth; rc =3D [%d]"
+						"\n", rc);
+				goto out;
+			}
+		}
 	}
 	rc =3D 0;
 out:
+	if (auth)
+		kfree(auth);
 	if (enc_extent_page) {
 		kunmap(enc_extent_page);
 		__free_page(enc_extent_page);
@@ -527,7 +692,7 @@ out:
=20
 static int ecryptfs_decrypt_extent(struct page *page,
 				   struct ecryptfs_crypt_stat *crypt_stat,
=2D				   struct page *enc_extent_page,
+				   struct page *enc_extent_page, unsigned char *auth,
 				   unsigned long extent_offset)
 {
 	loff_t extent_base;
@@ -555,12 +720,14 @@ static int ecryptfs_decrypt_extent(struct page *page,
 				  (page_address(enc_extent_page)
 				   + (extent_offset * crypt_stat->extent_size)),
 				  8);
+		ecryptfs_printk(KERN_DEBUG, "Auth: \n");
+		ecryptfs_dump_hex(auth, crypt_stat->authsize);
 	}
 	rc =3D ecryptfs_decrypt_page_offset(crypt_stat, page,
 					  (extent_offset
 					   * crypt_stat->extent_size),
 					  enc_extent_page, 0,
=2D					  crypt_stat->extent_size, extent_iv);
+					  crypt_stat->extent_size, auth, extent_iv);
 	if (rc < 0) {
 		printk(KERN_ERR "%s: Error attempting to decrypt to page with "
 		       "page->index =3D [%ld], extent_offset =3D [%ld]; "
@@ -607,6 +774,7 @@ int ecryptfs_decrypt_page(struct page *page)
 	struct page *enc_extent_page =3D NULL;
 	unsigned long extent_offset;
 	int rc =3D 0;
+	unsigned char *auth =3D NULL;
=20
 	ecryptfs_inode =3D page->mapping->host;
 	crypt_stat =3D
@@ -619,6 +787,15 @@ int ecryptfs_decrypt_page(struct page *page)
 				"encrypted extent\n");
 		goto out;
 	}
+	if(crypt_stat->authsize) {
+		auth =3D kzalloc(crypt_stat->authsize, GFP_KERNEL);
+		if(!auth) {
+			rc =3D -ENOMEM;
+			ecryptfs_printk(KERN_ERR, "Error allocating memory for "
+					"auth\n");
+			goto out;
+		}
+	}
 	enc_extent_virt =3D kmap(enc_extent_page);
 	for (extent_offset =3D 0;
 	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
@@ -629,6 +806,7 @@ int ecryptfs_decrypt_page(struct page *page)
 			&offset, ((page->index * (PAGE_CACHE_SIZE
 						  / crypt_stat->extent_size))
 				  + extent_offset), crypt_stat);
+
 		rc =3D ecryptfs_read_lower(enc_extent_virt, offset,
 					 crypt_stat->extent_size,
 					 ecryptfs_inode);
@@ -638,7 +816,22 @@ int ecryptfs_decrypt_page(struct page *page)
 					"\n", rc);
 			goto out;
 		}
=2D		rc =3D ecryptfs_decrypt_extent(page, crypt_stat, enc_extent_page,
+		if(!rc)		/* No need to decrypt extent if there's nothing to read from th=
e lower file */
+			break;
+
+		if(crypt_stat->authsize) {
+			rc =3D ecryptfs_read_lower(auth, offset +
+						crypt_stat->extent_size, crypt_stat->authsize,
+						ecryptfs_inode);
+			if (rc < 0) {
+				ecryptfs_printk(KERN_ERR, "Error attempting "
+						"to read lower page auth; rc =3D [%d]"
+						"\n", rc);
+				goto out;
+			}
+		}
+	=09
+		rc =3D ecryptfs_decrypt_extent(page, crypt_stat, enc_extent_page, auth,
 					     extent_offset);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting extent; "
@@ -647,6 +840,8 @@ int ecryptfs_decrypt_page(struct page *page)
 		}
 	}
 out:
+	if (auth)
+		kfree(auth);
 	if (enc_extent_page) {
 		kunmap(enc_extent_page);
 		__free_page(enc_extent_page);
@@ -669,27 +864,101 @@ static int decrypt_scatterlist(struct ecryptfs_crypt=
_stat *crypt_stat,
 			       struct scatterlist *src_sg, int size,
 			       unsigned char *iv)
 {
=2D	struct blkcipher_desc desc =3D {
=2D		.tfm =3D crypt_stat->tfm,
=2D		.info =3D iv,
=2D		.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP
=2D	};
+	struct aead_request *req =3D NULL;
+	struct crypto_async_completion result;
+	unsigned char *assoc =3D NULL;
+	struct scatterlist asg;
+	struct rtattr *rta;
+	unsigned char *p;
+	int keylen =3D 0;
+	unsigned char *key =3D NULL;
+	struct crypto_authenc_key_param *param;
 	int rc =3D 0;
=20
 	/* Consider doing this once, when the file is opened */
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
=2D	rc =3D crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
=2D				     crypt_stat->key_size);
+
+	init_completion(&result.completion);
+=09
+	req =3D aead_request_alloc(crypt_stat->tfm, GFP_KERNEL);
+	if (!req) {
+		rc =3D PTR_ERR(req);
+		ecryptfs_printk(KERN_ERR, "Failed to allocate request; [%d]\n", rc);
+		mutex_unlock(&crypt_stat->cs_tfm_mutex);
+		return rc;
+	}
+=09
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
+				  crypto_async_request_cb_complete, &result);
+
+	keylen =3D crypt_stat->key_size + crypt_stat->auth_key_size + RTA_SPACE(s=
izeof(*param));
+
+	key =3D kzalloc(keylen, GFP_KERNEL);
+	if(!key) {
+		rc =3D -ENOMEM;
+		ecryptfs_printk(KERN_ERR, "Out of memory\n");
+		mutex_unlock(&crypt_stat->cs_tfm_mutex);
+		goto out;
+	}
+ =20
+	p =3D key;
+	rta =3D (void *)p;
+	rta->rta_type =3D CRYPTO_AUTHENC_KEYA_PARAM;
+	rta->rta_len =3D RTA_LENGTH(sizeof(*param));
+	param =3D RTA_DATA(rta);
+	p +=3D RTA_SPACE(sizeof(*param));
+
+	if(crypt_stat->auth_key_size) {
+		memcpy(p, crypt_stat->key, crypt_stat->auth_key_size);
+		p +=3D crypt_stat->auth_key_size;
+	}
+=09
+	param->enckeylen =3D cpu_to_be32(crypt_stat->key_size);
+	memcpy(p, crypt_stat->key + crypt_stat->auth_key_size, crypt_stat->key_si=
ze);
+
+	rc =3D crypto_aead_setkey(crypt_stat->tfm, key, keylen);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error setting key; rc =3D [%d]\n",
 				rc);
 		mutex_unlock(&crypt_stat->cs_tfm_mutex);
=2D		rc =3D -EINVAL;
 		goto out;
 	}
+
+	if(crypt_stat->authsize) {
+		rc =3D crypto_aead_setauthsize(crypt_stat->tfm, crypt_stat->authsize);
+		if (rc) {
+			ecryptfs_printk(KERN_ERR, "alg: aead: Failed to set "
+					"authsize to %u\n", crypt_stat->authsize);
+			mutex_unlock(&crypt_stat->cs_tfm_mutex);
+			goto out;
+		}
+	}
+=09
 	ecryptfs_printk(KERN_DEBUG, "Decrypting [%d] bytes.\n", size);
=2D	rc =3D crypto_blkcipher_decrypt_iv(&desc, dest_sg, src_sg, size);
+
+	assoc =3D kstrdup(ECRYPTFS_ASSOC_STRING, GFP_KERNEL);
+	if(!assoc) {
+		rc =3D -ENOMEM;
+		ecryptfs_printk(KERN_ERR, "Out of memory\n");
+		mutex_unlock(&crypt_stat->cs_tfm_mutex);
+		goto out;
+	}
+	=09
+	sg_init_one(&asg, assoc, ECRYPTFS_ASSOC_LEN);
+
+	aead_request_set_crypt(req, src_sg, dest_sg, size + crypt_stat->authsize,=
 iv);
+	aead_request_set_assoc(req, &asg, ECRYPTFS_ASSOC_LEN);
+
+	rc =3D crypto_aead_decrypt(req);
+	if(rc =3D=3D -EBUSY || rc =3D=3D -EINPROGRESS) {
+		rc =3D wait_for_completion_interruptible(&result.completion);
+		if (!rc && !(rc =3D result.err)) {
+			INIT_COMPLETION(result.completion);
+		}
+	}
+
 	mutex_unlock(&crypt_stat->cs_tfm_mutex);
+=09
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error decrypting; rc =3D [%d]\n",
 				rc);
@@ -697,6 +966,12 @@ static int decrypt_scatterlist(struct ecryptfs_crypt_s=
tat *crypt_stat,
 	}
 	rc =3D size;
 out:
+	if(assoc)
+		kfree(assoc);
+	if(key)
+		kfree(key);
+
+	aead_request_free(req);
 	return rc;
 }
=20
@@ -715,17 +990,22 @@ out:
 static int
 ecryptfs_encrypt_page_offset(struct ecryptfs_crypt_stat *crypt_stat,
 			     struct page *dst_page, int dst_offset,
=2D			     struct page *src_page, int src_offset, int size,
+			     struct page *src_page, int src_offset, int size, unsigned char *au=
th,
 			     unsigned char *iv)
 {
=2D	struct scatterlist src_sg, dst_sg;
=2D
=2D	sg_init_table(&src_sg, 1);
=2D	sg_init_table(&dst_sg, 1);
=2D
=2D	sg_set_page(&src_sg, src_page, size, src_offset);
=2D	sg_set_page(&dst_sg, dst_page, size, dst_offset);
=2D	return encrypt_scatterlist(crypt_stat, &dst_sg, &src_sg, size, iv);
+	struct scatterlist src_sg[2], dst_sg[2];
+
+	sg_init_table(src_sg, 2);
+	sg_init_table(dst_sg, 2);
+
+	sg_set_page(&src_sg[0], src_page, size, src_offset);
+	if(auth)
+		sg_set_buf(&src_sg[1], auth, crypt_stat->authsize);
+	sg_set_page(&dst_sg[0], dst_page, size, dst_offset);
+	if(auth)
+		sg_set_buf(&dst_sg[1], auth, crypt_stat->authsize);
+=09
+	return encrypt_scatterlist(crypt_stat, dst_sg, src_sg, size, iv);
 }
=20
 /**
@@ -743,18 +1023,22 @@ ecryptfs_encrypt_page_offset(struct ecryptfs_crypt_s=
tat *crypt_stat,
 static int
 ecryptfs_decrypt_page_offset(struct ecryptfs_crypt_stat *crypt_stat,
 			     struct page *dst_page, int dst_offset,
=2D			     struct page *src_page, int src_offset, int size,
+			     struct page *src_page, int src_offset, int size, unsigned char *au=
th,
 			     unsigned char *iv)
 {
=2D	struct scatterlist src_sg, dst_sg;
=2D
=2D	sg_init_table(&src_sg, 1);
=2D	sg_set_page(&src_sg, src_page, size, src_offset);
=2D
=2D	sg_init_table(&dst_sg, 1);
=2D	sg_set_page(&dst_sg, dst_page, size, dst_offset);
=2D
=2D	return decrypt_scatterlist(crypt_stat, &dst_sg, &src_sg, size, iv);
+	struct scatterlist src_sg[2], dst_sg[2];
+
+	sg_init_table(src_sg, 2);
+	sg_set_page(&src_sg[0], src_page, size, src_offset);
+	if(auth)
+		sg_set_buf(&src_sg[1], auth, crypt_stat->authsize);
+=09
+	sg_init_table(dst_sg, 2);
+	sg_set_page(&dst_sg[0], dst_page, size, dst_offset);
+	if(auth)
+		sg_set_buf(&dst_sg[1], auth, crypt_stat->authsize);
+
+	return decrypt_scatterlist(crypt_stat, dst_sg, src_sg, size, iv);
 }
=20
 #define ECRYPTFS_MAX_SCATTERLIST_LEN 4
@@ -772,7 +1056,7 @@ int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat=
 *crypt_stat)
 {
 	char *full_alg_name;
 	int rc =3D -EINVAL;
=2D
+=09
 	if (!crypt_stat->cipher) {
 		ecryptfs_printk(KERN_ERR, "No cipher specified\n");
 		goto out;
@@ -782,17 +1066,28 @@ int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_st=
at *crypt_stat)
 			"key_size_bits =3D [%d]\n",
 			crypt_stat->cipher, (int)strlen(crypt_stat->cipher),
 			crypt_stat->key_size << 3);
+
+	ecryptfs_printk(KERN_DEBUG,		=09
+			"Initializing auth [%s]; strlen =3D [%d]; "
+			"key_size_bits =3D [%d]\n",
+			crypt_stat->auth, (int)strlen(crypt_stat->auth),
+			crypt_stat->auth_key_size << 3
+			);
 	if (crypt_stat->tfm) {
 		rc =3D 0;
 		goto out;
 	}
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
=2D	rc =3D ecryptfs_crypto_api_algify_cipher_name(&full_alg_name,
=2D						    crypt_stat->cipher, "cbc");
+	if(strcmp(crypt_stat->cipher, "cipher_null") =3D=3D 0)
+		rc =3D ecryptfs_crypto_api_algify_cipher_name(&full_alg_name,
+								crypt_stat->cipher, "ecb", crypt_stat->auth);
+	else
+		rc =3D ecryptfs_crypto_api_algify_cipher_name(&full_alg_name,
+								crypt_stat->cipher, "cbc", crypt_stat->auth);
 	if (rc)
 		goto out_unlock;
=2D	crypt_stat->tfm =3D crypto_alloc_blkcipher(full_alg_name, 0,
=2D						 CRYPTO_ALG_ASYNC);
+	crypt_stat->tfm =3D crypto_alloc_aead(full_alg_name, 0, 0);
+=20
 	kfree(full_alg_name);
 	if (IS_ERR(crypt_stat->tfm)) {
 		rc =3D PTR_ERR(crypt_stat->tfm);
@@ -802,7 +1097,10 @@ int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_sta=
t *crypt_stat)
 				crypt_stat->cipher);
 		goto out_unlock;
 	}
=2D	crypto_blkcipher_set_flags(crypt_stat->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+	crypto_aead_clear_flags(crypt_stat->tfm, ~0);
+	crypto_aead_set_flags(crypt_stat->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+=09
+	crypt_stat->authsize =3D crypto_aead_authsize(crypt_stat->tfm);
 	rc =3D 0;
 out_unlock:
 	mutex_unlock(&crypt_stat->cs_tfm_mutex);
@@ -881,12 +1179,15 @@ out:
=20
 static void ecryptfs_generate_new_key(struct ecryptfs_crypt_stat *crypt_st=
at)
 {
=2D	get_random_bytes(crypt_stat->key, crypt_stat->key_size);
+	get_random_bytes(crypt_stat->key, crypt_stat->auth_key_size + crypt_stat-=
>key_size);
 	crypt_stat->flags |=3D ECRYPTFS_KEY_VALID;
 	ecryptfs_compute_root_iv(crypt_stat);
 	if (unlikely(ecryptfs_verbosity > 0)) {
=2D		ecryptfs_printk(KERN_DEBUG, "Generated new session key:\n");
+		ecryptfs_printk(KERN_DEBUG, "Generated new auth key:\n");
 		ecryptfs_dump_hex(crypt_stat->key,
+				  crypt_stat->auth_key_size);	 =20
+		ecryptfs_printk(KERN_DEBUG, "Generated new session key:\n");
+		ecryptfs_dump_hex(crypt_stat->key + crypt_stat->auth_key_size,
 				  crypt_stat->key_size);
 	}
 }
@@ -994,6 +1295,7 @@ int ecryptfs_new_file_context(struct dentry *ecryptfs_=
dentry)
 	    &ecryptfs_superblock_to_private(
 		    ecryptfs_dentry->d_sb)->mount_crypt_stat;
 	int cipher_name_len;
+	int auth_name_len;
 	int rc =3D 0;
=20
 	ecryptfs_set_default_crypt_stat_vals(crypt_stat, mount_crypt_stat);
@@ -1013,8 +1315,19 @@ int ecryptfs_new_file_context(struct dentry *ecryptf=
s_dentry)
 	       mount_crypt_stat->global_default_cipher_name,
 	       cipher_name_len);
 	crypt_stat->cipher[cipher_name_len] =3D '\0';
+	memcpy(crypt_stat->cipher,
+	       mount_crypt_stat->global_default_cipher_name,
+	       cipher_name_len);
 	crypt_stat->key_size =3D
 		mount_crypt_stat->global_default_cipher_key_size;
+	auth_name_len =3D
+		strlen(mount_crypt_stat->global_default_auth_name);
+	memcpy(crypt_stat->auth,
+	       mount_crypt_stat->global_default_auth_name,
+	       auth_name_len);
+	crypt_stat->auth[auth_name_len] =3D '\0';
+	crypt_stat->auth_key_size =3D
+		mount_crypt_stat->global_default_auth_key_size;
 	ecryptfs_generate_new_key(crypt_stat);
 	rc =3D ecryptfs_init_crypt_ctx(crypt_stat);
 	if (rc)
@@ -1141,7 +1454,8 @@ ecryptfs_cipher_code_str_map[] =3D {
 	{"twofish", RFC2440_CIPHER_TWOFISH},
 	{"cast6", RFC2440_CIPHER_CAST_6},
 	{"aes", RFC2440_CIPHER_AES_192},
=2D	{"aes", RFC2440_CIPHER_AES_256}
+	{"aes", RFC2440_CIPHER_AES_256},
+	{"cipher_null", ECRYPTFS_CRYPTO_NULL_CODE}
 };
=20
 /**
@@ -1314,9 +1628,14 @@ ecryptfs_write_metadata_to_contents(struct dentry *e=
cryptfs_dentry,
 				    char *virt, size_t virt_len)
 {
 	int rc;
=2D
+	char auth[ECRYPTFS_AUTHSIZE];
+=09
 	rc =3D ecryptfs_write_lower(ecryptfs_dentry->d_inode, virt,
 				  0, virt_len);
+
+  	rc =3D ecryptfs_write_lower(ecryptfs_dentry->d_inode, auth,
+					  virt_len, ECRYPTFS_AUTHSIZE);
+ =20
 	if (rc < 0)
 		printk(KERN_ERR "%s: Error attempting to write header "
 		       "information to lower file; rc =3D [%d]\n", __func__, rc);
@@ -1582,6 +1901,8 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_de=
ntry)
 {
 	int rc =3D 0;
 	char *page_virt =3D NULL;
+	char auth[ECRYPTFS_AUTHSIZE];
+=09
 	struct inode *ecryptfs_inode =3D ecryptfs_dentry->d_inode;
 	struct ecryptfs_crypt_stat *crypt_stat =3D
 	    &ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
@@ -1601,6 +1922,10 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_d=
entry)
 	}
 	rc =3D ecryptfs_read_lower(page_virt, 0, crypt_stat->extent_size,
 				 ecryptfs_inode);
+
+	rc =3D ecryptfs_read_lower(auth, crypt_stat->extent_size, ECRYPTFS_AUTHSI=
ZE,
+				 ecryptfs_inode);
+=20
 	if (rc >=3D 0)
 		rc =3D ecryptfs_read_headers_virt(page_virt, crypt_stat,
 						ecryptfs_dentry,
@@ -1759,7 +2084,7 @@ ecryptfs_process_key_cipher(struct crypto_blkcipher *=
*key_tfm,
 		goto out;
 	}
 	rc =3D ecryptfs_crypto_api_algify_cipher_name(&full_alg_name, cipher_name,
=2D						    "ecb");
+						    "ecb", NULL);
 	if (rc)
 		goto out;
 	*key_tfm =3D crypto_alloc_blkcipher(full_alg_name, 0, CRYPTO_ALG_ASYNC);
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 542f625..73b2ab3 100644
=2D-- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -96,6 +96,9 @@
=20
 #define RFC2440_CIPHER_RSA 0x01
=20
+#define ECRYPTFS_HMAC_AUTH_MASK 0x10
+#define ECRYPTFS_CRYPTO_NULL_CODE 0x0c
+
 /**
  * For convenience, we may need to pass around the encrypted session
  * key between kernel and userspace because the authentication token
@@ -194,6 +197,7 @@ ecryptfs_get_key_payload_data(struct key *key)
 #define ECRYPTFS_SUPER_MAGIC 0xf15f
 #define ECRYPTFS_MAX_KEYSET_SIZE 1024
 #define ECRYPTFS_MAX_CIPHER_NAME_SIZE 32
+#define ECRYPTFS_MAX_AUTH_NAME_SIZE 32
 #define ECRYPTFS_MAX_NUM_ENC_KEYS 64
 #define ECRYPTFS_MAX_IV_BYTES 16	/* 128 bits */
 #define ECRYPTFS_SALT_BYTES 2
@@ -203,6 +207,8 @@ ecryptfs_get_key_payload_data(struct key *key)
 #define ECRYPTFS_DEFAULT_CIPHER "aes"
 #define ECRYPTFS_DEFAULT_KEY_BYTES 16
 #define ECRYPTFS_DEFAULT_HASH "md5"
+#define ECRYPTFS_DEFAULT_AUTH "digest_null"
+#define ECRYPTFS_DEFAULT_AUTH_KEY_BYTES 0
 #define ECRYPTFS_TAG_70_DIGEST ECRYPTFS_DEFAULT_HASH
 #define ECRYPTFS_TAG_1_PACKET_TYPE 0x01
 #define ECRYPTFS_TAG_3_PACKET_TYPE 0x8C
@@ -230,6 +236,14 @@ ecryptfs_get_key_payload_data(struct key *key)
 #define ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX "ECRYPTFS_FNEK_ENCRYPTED."
 #define ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE 24
 #define ECRYPTFS_ENCRYPTED_DENTRY_NAME_LEN (18 + 1 + 4 + 1 + 32)
+#define ECRYPTFS_ASSOC_STRING "\x49\x5c\x50\x1f\x1d\x94\xcc\x81 \
+			      \xba\xb7\xb6\x03\xaf\xa5\xc1\xa1  \
+			      \xd8\x5c\x42\x68\xe0\x6c\xda\x89  \
+			      \x05\xac\x56\xac\x1b\x2a\xd3\x86"
+#define ECRYPTFS_ASSOC_LEN 32
+#define ECRYPTFS_AUTHSIZE 20
+#define ECRYPTFS_FIXED_AUTH_KEY_SIZE 16
+#define ECRYPTFS_FIXED_AUTH_NAME "hmac(sha1)"
=20
 struct ecryptfs_key_sig {
 	struct list_head crypt_stat_list;
@@ -276,13 +290,16 @@ struct ecryptfs_crypt_stat {
 	size_t num_header_bytes_at_front;
 	size_t extent_size; /* Data extent size; default is 4096 */
 	size_t key_size;
+	size_t auth_key_size;
+	size_t authsize;
 	size_t extent_shift;
 	unsigned int extent_mask;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
=2D	struct crypto_blkcipher *tfm;
+	struct crypto_aead *tfm;
 	struct crypto_hash *hash_tfm; /* Crypto context for generating
 				       * the initialization vectors */
 	unsigned char cipher[ECRYPTFS_MAX_CIPHER_NAME_SIZE];
+	unsigned char auth[ECRYPTFS_MAX_AUTH_NAME_SIZE];
 	unsigned char key[ECRYPTFS_MAX_KEY_BYTES];
 	unsigned char root_iv[ECRYPTFS_MAX_IV_BYTES];
 	struct list_head keysig_list;
@@ -381,11 +398,14 @@ struct ecryptfs_mount_crypt_stat {
 	struct mutex global_auth_tok_list_mutex;
 	size_t num_global_auth_toks;
 	size_t global_default_cipher_key_size;
+	size_t global_default_auth_key_size;
 	size_t global_default_fn_cipher_key_bytes;
 	unsigned char global_default_cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE
 						 + 1];
 	unsigned char global_default_fn_cipher_name[
 		ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
+	unsigned char global_default_auth_name[ECRYPTFS_MAX_AUTH_NAME_SIZE
+						 + 1];
 	char global_default_fnek_sig[ECRYPTFS_SIG_SIZE_HEX + 1];
 };
=20
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 678172b..8ba50d8 100644
=2D-- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -296,6 +296,7 @@ static int ecryptfs_fasync(int fd, struct file *file, i=
nt flag)
 static int ecryptfs_ioctl(struct inode *inode, struct file *file,
 			  unsigned int cmd, unsigned long arg);
=20
+
 const struct file_operations ecryptfs_dir_fops =3D {
 	.readdir =3D ecryptfs_readdir,
 	.ioctl =3D ecryptfs_ioctl,
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index a0a7847..adc0835 100644
=2D-- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1328,6 +1328,16 @@ parse_tag_3_packet(struct ecryptfs_crypt_stat *crypt=
_stat,
 		rc =3D -EINVAL;
 		goto out_free;
 	}
+	if((u16)data[(*packet_size)] & ECRYPTFS_HMAC_AUTH_MASK) {
+		crypt_stat->auth_key_size =3D ECRYPTFS_FIXED_AUTH_KEY_SIZE;
+		memcpy(crypt_stat->auth, ECRYPTFS_FIXED_AUTH_NAME, strlen(ECRYPTFS_FIXED=
_AUTH_NAME));
+		crypt_stat->auth[strlen(ECRYPTFS_FIXED_AUTH_NAME)]=3D'\0';
+		data[(*packet_size)] &=3D ~ECRYPTFS_HMAC_AUTH_MASK;
+	} else {
+		memcpy(crypt_stat->auth, ECRYPTFS_DEFAULT_AUTH, strlen(ECRYPTFS_DEFAULT_=
AUTH));
+		crypt_stat->auth[strlen(ECRYPTFS_DEFAULT_AUTH)]=3D'\0';	 =20
+	}
+	 =20
 	rc =3D ecryptfs_cipher_code_to_string(crypt_stat->cipher,
 					    (u16)data[(*packet_size)]);
 	if (rc)
@@ -1340,7 +1350,7 @@ parse_tag_3_packet(struct ecryptfs_crypt_stat *crypt_=
stat,
 		break;
 	default:
 		crypt_stat->key_size =3D
=2D			(*new_auth_tok)->session_key.encrypted_key_size;
+			(*new_auth_tok)->session_key.encrypted_key_size - crypt_stat->auth_key_=
size;
 	}
 	rc =3D ecryptfs_init_crypt_ctx(crypt_stat);
 	if (rc)
@@ -2118,13 +2128,13 @@ write_tag_3_packet(char *dest, size_t *remaining_by=
tes,
 			mount_crypt_stat->global_default_cipher_key_size;
 	if (auth_tok->session_key.encrypted_key_size =3D=3D 0)
 		auth_tok->session_key.encrypted_key_size =3D
=2D			crypt_stat->key_size;
+			crypt_stat->auth_key_size + crypt_stat->key_size;
 	if (crypt_stat->key_size =3D=3D 24
 	    && strcmp("aes", crypt_stat->cipher) =3D=3D 0) {
 		memset((crypt_stat->key + 24), 0, 8);
=2D		auth_tok->session_key.encrypted_key_size =3D 32;
+		auth_tok->session_key.encrypted_key_size =3D crypt_stat->auth_key_size +=
 32;
 	} else
=2D		auth_tok->session_key.encrypted_key_size =3D crypt_stat->key_size;
+		auth_tok->session_key.encrypted_key_size =3D crypt_stat->auth_key_size +=
 crypt_stat->key_size;
 	key_rec->enc_key_size =3D
 		auth_tok->session_key.encrypted_key_size;
 	encrypted_session_key_valid =3D 0;
@@ -2149,7 +2159,7 @@ write_tag_3_packet(char *dest, size_t *remaining_byte=
s,
 				session_key_encryption_key_bytes);
 		memcpy(session_key_encryption_key,
 		       auth_tok->token.password.session_key_encryption_key,
=2D		       crypt_stat->key_size);
+		         crypt_stat->key_size);
 		ecryptfs_printk(KERN_DEBUG,
 				"Cached session key " "encryption key: \n");
 		if (ecryptfs_verbosity > 0)
@@ -2217,7 +2227,7 @@ encrypted_session_key_set:
 			   + 1                       /* Hash identifier */
 			   + ECRYPTFS_SALT_SIZE      /* Salt */
 			   + 1                       /* Hash iterations */
=2D			   + key_rec->enc_key_size); /* Encrypted key size */
+			   + key_rec->enc_key_size); /* Encrypted key size (cipher) */
 	if (max_packet_size > (*remaining_bytes)) {
 		printk(KERN_ERR "Packet too large; need up to [%td] bytes, but "
 		       "there are only [%td] available\n", max_packet_size,
@@ -2241,13 +2251,16 @@ encrypted_session_key_set:
 	/* TODO: Break from RFC2440 so that arbitrary ciphers can be
 	 * specified with strings */
 	cipher_code =3D ecryptfs_code_for_cipher_string(crypt_stat->cipher,
=2D						      crypt_stat->key_size);
+						      crypt_stat->key_size);=09
 	if (cipher_code =3D=3D 0) {
 		ecryptfs_printk(KERN_WARNING, "Unable to generate code for "
 				"cipher [%s]\n", crypt_stat->cipher);
 		rc =3D -EINVAL;
 		goto out;
 	}
+	/* WARNING: the following code is not standard */
+	if(crypt_stat->auth_key_size)
+		cipher_code |=3D ECRYPTFS_HMAC_AUTH_MASK;
 	dest[(*packet_size)++] =3D cipher_code;
 	dest[(*packet_size)++] =3D 0x03;	/* S2K */
 	dest[(*packet_size)++] =3D 0x01;	/* MD5 (TODO: parameterize) */
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index ea2f921..51dc3cd 100644
=2D-- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -207,7 +207,9 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
        ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
        ecryptfs_opt_encrypted_view, ecryptfs_opt_fnek_sig,
        ecryptfs_opt_fn_cipher, ecryptfs_opt_fn_cipher_key_bytes,
=2D       ecryptfs_opt_unlink_sigs, ecryptfs_opt_err };
+       ecryptfs_opt_unlink_sigs, ecryptfs_opt_auth,
+       ecryptfs_opt_auth_key_bytes,ecryptfs_opt_err
+       };
=20
 static const match_table_t tokens =3D {
 	{ecryptfs_opt_sig, "sig=3D%s"},
@@ -222,7 +224,9 @@ static const match_table_t tokens =3D {
 	{ecryptfs_opt_fn_cipher, "ecryptfs_fn_cipher=3D%s"},
 	{ecryptfs_opt_fn_cipher_key_bytes, "ecryptfs_fn_key_bytes=3D%u"},
 	{ecryptfs_opt_unlink_sigs, "ecryptfs_unlink_sigs"},
=2D	{ecryptfs_opt_err, NULL}
+	{ecryptfs_opt_auth, "ecryptfs_auth=3D%s"},
+	{ecryptfs_opt_auth_key_bytes, "ecryptfs_auth_key_bytes=3D%u"},=09
+	{ecryptfs_opt_err, NULL},
 };
=20
 static int ecryptfs_init_global_auth_toks(
@@ -304,7 +308,13 @@ static int ecryptfs_parse_options(struct super_block *=
sb, char *options)
 	char *fnek_src;
 	char *cipher_key_bytes_src;
 	char *fn_cipher_key_bytes_src;
=2D
+	char *auth_key_bytes_src;
+	char *auth_name_dst;
+	char *auth_name_src;
+	int auth_key_bytes;
+	int auth_name_set =3D 0;
+	int auth_key_bytes_set =3D 0;
+=09
 	if (!options) {
 		rc =3D -EINVAL;
 		goto out;
@@ -405,6 +415,31 @@ static int ecryptfs_parse_options(struct super_block *=
sb, char *options)
 		case ecryptfs_opt_unlink_sigs:
 			mount_crypt_stat->flags |=3D ECRYPTFS_UNLINK_SIGS;
 			break;
+		case ecryptfs_opt_auth:
+			auth_name_src =3D args[0].from;
+			auth_name_dst =3D
+				mount_crypt_stat->
+				global_default_auth_name;
+			strncpy(auth_name_dst, auth_name_src,
+				ECRYPTFS_MAX_AUTH_NAME_SIZE);
+			auth_name_dst[ECRYPTFS_MAX_AUTH_NAME_SIZE] =3D '\0';
+			auth_name_set =3D 1;
+			break;
+		case ecryptfs_opt_auth_key_bytes:
+			auth_key_bytes_src =3D args[0].from;
+			auth_key_bytes =3D
+				(int)simple_strtol(auth_key_bytes_src,
+						   &auth_key_bytes_src, 0);
+			if(auth_key_bytes !=3D ECRYPTFS_FIXED_AUTH_KEY_SIZE) {
+				ecryptfs_printk(KERN_ERR, "Only %d-bit long hmac keys are"
+							  "currently supported; auth_key_size"
+							  "will be set to %d\n", ECRYPTFS_FIXED_AUTH_KEY_SIZE,=20
+							  ECRYPTFS_FIXED_AUTH_KEY_SIZE);
+			}
+			mount_crypt_stat->global_default_auth_key_size =3D
+				auth_key_bytes;
+			auth_key_bytes_set =3D 1;
+			break;
 		case ecryptfs_opt_err:
 		default:
 			printk(KERN_WARNING
@@ -426,12 +461,25 @@ static int ecryptfs_parse_options(struct super_block =
*sb, char *options)
 		strcpy(mount_crypt_stat->global_default_cipher_name,
 		       ECRYPTFS_DEFAULT_CIPHER);
 	}
+	if (!auth_name_set) {
+		int auth_name_len =3D strlen(ECRYPTFS_DEFAULT_AUTH);
+	=09
+		BUG_ON(auth_name_len >=3D ECRYPTFS_MAX_AUTH_NAME_SIZE);
+		strcpy(mount_crypt_stat->global_default_auth_name,
+		       ECRYPTFS_DEFAULT_AUTH); =20
+	}
 	if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
 	    && !fn_cipher_name_set)
 		strcpy(mount_crypt_stat->global_default_fn_cipher_name,
 		       mount_crypt_stat->global_default_cipher_name);
 	if (!cipher_key_bytes_set)
 		mount_crypt_stat->global_default_cipher_key_size =3D 0;
+	if (!auth_key_bytes_set) {
+		if(auth_name_set && strcmp(mount_crypt_stat-> global_default_auth_name, =
ECRYPTFS_DEFAULT_AUTH))=20
+			mount_crypt_stat->global_default_auth_key_size =3D ECRYPTFS_FIXED_AUTH_=
KEY_SIZE;
+		else
+			mount_crypt_stat->global_default_auth_key_size =3D 0;
+	}
 	if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
 	    && !fn_cipher_key_bytes_set)
 		mount_crypt_stat->global_default_fn_cipher_key_bytes =3D
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index df4ce99..48306fa 100644
=2D-- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -521,6 +521,7 @@ static int ecryptfs_write_end(struct file *file,
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
 				"[0x%.16x]\n", i_size_read(ecryptfs_inode));
 	}
+
 	rc =3D ecryptfs_write_inode_size_to_metadata(ecryptfs_inode);
 	if (rc)
 		printk(KERN_ERR "Error writing inode size to metadata; "

--Boundary-01=_eqhmLnC2CPiMKIe--

--nextPart2888521.RuA5DiXYQr
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGDzCCBgsw
ggTzoAMCAQICAgPBMA0GCSqGSIb3DQEBBQUAMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xp
dGVjbmljbyBkaSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eTAeFw0wODEyMDUxNjAwMDBaFw0xMDEyMzAxMjAwMDBaMHkxCzAJBgNV
BAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8xMTAvBgNVBAsTKERpcGFydGlt
ZW50byBkaSBBdXRvbWF0aWNhIGUgSW5mb3JtYXRpY2ExFzAVBgNVBAMTDlJvYmVydG8gIFNhc3N1
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5L+V4w3Mbm/sUbvfK2Fa00852rwwQWnO
DuaPLgztSxL36xxvtATxM5ffrmr/6YHDFnupb46E0p+C/XgDfL+q6O7k/uaNOZM28pYOmxQGML60
Kz5alayAg9zbHFY+tHtuvThT9Jhg2zHKeHVO07aCxCsciP1L/A2I1E/wYY8ICK5hGVovYJ5JWfgk
QpxPTM54sgip8OncB3dh4GGP5xHdOuY71PIZM8IBvWjKr3C4DVPHTjiupJA1unR7RG86vAAikP/a
Y08/dF5N4HndpKCrSkIegfWzYBxj+NYnWOhgUL2GH/YOplG8w0iwztRx7kiLPayCXUjrUhQPjrnw
djMKYwIDAQABo4ICrzCCAqswgZUGCWCGSAGG+EIBDQSBhxaBhElzc3VlZCB1bmRlciBwb2xpY2ll
czoKIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Evcm9vdC9jcHMvMS4xLwogaHR0cDovL3d3dy5l
dXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLwogaHR0cDovL2NhLnBvbGl0by5pdC9jcHMvMi4xLzAR
BglghkgBhvhCAQEEBAMCALAwYwYIKwYBBQUHAQEEVzBVMCgGCCsGAQUFBzABhhxodHRwOi8vb2Nz
cC5ldXJvcGtpLm9yZzo4MDI2MCkGCCsGAQUFBzAChh1odHRwOi8vd3d3LmV1cm9wa2kub3JnL2Nh
L2l0LzAyBgNVHR8EKzApMCegJaAjhiFodHRwOi8vY2EucG9saXRvLml0L2NybDAzL2NybC5kZXIw
DAYDVR0TAQH/BAIwADA6BgNVHREEMzAxgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdKAWBgorBgEE
AZViAgEBoAgWBjAyMTMwNTCBzQYDVR0gBIHFMIHCMEMGCisGAQQBqQcBAQEwNTAzBggrBgEFBQcC
ARYnaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9yb290L2Nwcy8xLjEvMEEGCisGAQQBqQcCAQEw
MzAxBggrBgEFBQcCARYlaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLzA4Bgor
BgEEAZViAQIBMCowKAYIKwYBBQUHAgEWHGh0dHA6Ly9jYS5wb2xpdG8uaXQvY3BzLzIuMS8wCwYD
VR0PBAQDAgTwMB0GA1UdDgQWBBQ/7fsOlEvqvkE2OCyAWMjwwe8ZNzAfBgNVHSMEGDAWgBQJ/SUZ
b+NofIJrNXO8KAC+LDw6ODANBgkqhkiG9w0BAQUFAAOCAQEANGPQ5YyCXMtdM+4o0P2AxMd3WJE/
NE0jVOJgU39YjK5reY16/rnAqfflXFtsxXqTvO7HF0Luj6JhEt6lU6enD3QB/9KIlFz1AjiuTy3N
KvnEgju8jR8+9yWuNIzKZcK/AqttjCsp7QWEGdJnwCh7BegcNDx/riF4shTyYta7CjX5uurSklQf
lD7r1YAYPTeWf6UWGTYqq9W/zIAPbU/J2tLtSTZksTuXv/4FNAFjxmOk1FnjgLr6juWi7bM3qWRa
1UcHBQ1V1+7fCRJN20Kb/LFHxdSUXJmQsd+FjX1VbiW7FvspngaI8oMRF1DAFvSSNrh6pI4GQA9Z
n1jzOm/hsDGCAhwwggIYAgEBMGswZTELMAkGA1UEBhMCSVQxHjAcBgNVBAoTFVBvbGl0ZWNuaWNv
IGRpIFRvcmlubzE2MDQGA1UEAxMtUG9saXRlY25pY28gZGkgVG9yaW5vIENlcnRpZmljYXRpb24g
QXV0aG9yaXR5AgIDwTAJBgUrDgMCGgUAoIGHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTEwMDMxMjEwNDIzOFowIwYJKoZIhvcNAQkEMRYEFPpQQqqOSbFMDrCGse8L
coEeppq/MCgGCSqGSIb3DQEJDzEbMBkwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA0GCSqGSIb3
DQEBAQUABIIBAJWHWolrzUCPCvWjZS0+UEiXAwr9WiQHXa1K5aGjUxjW5w/QmFTEd1FmI2d8Ai0O
R1D0Rq2W+c2Ei0qCjXXZKe+tH7NvvU03uafwgUaDZaLjOUA5kWz6kKFAivpNsLV62Ghb/utpVoF1
bBU6vrudCLZ8RYFoZbx7uew6s/dI9iTIha8AUm9b1qIP21L6iVDTwEpMpXmIZ+m/6+rBYdDd0eiA
RbU5+ea5ENWTnRGhDSZFbkY8gkZi1oZn68wgs2mdB6MYZ2lk9g/16tPkqqyYyGRKlmT7FJTNwJ9S
SS2tY3hJwYBWn+OSD5sMJ6HcXrDzs/JyPVz7Owm2rI6YBSOa4X0AAAAAAAA=

--nextPart2888521.RuA5DiXYQr--

--Boundary-01=_SxhmLxKM++R5isF--

--nextPart3009229.Oko97AiT6n
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGDzCCBgsw
ggTzoAMCAQICAgPBMA0GCSqGSIb3DQEBBQUAMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xp
dGVjbmljbyBkaSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eTAeFw0wODEyMDUxNjAwMDBaFw0xMDEyMzAxMjAwMDBaMHkxCzAJBgNV
BAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8xMTAvBgNVBAsTKERpcGFydGlt
ZW50byBkaSBBdXRvbWF0aWNhIGUgSW5mb3JtYXRpY2ExFzAVBgNVBAMTDlJvYmVydG8gIFNhc3N1
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5L+V4w3Mbm/sUbvfK2Fa00852rwwQWnO
DuaPLgztSxL36xxvtATxM5ffrmr/6YHDFnupb46E0p+C/XgDfL+q6O7k/uaNOZM28pYOmxQGML60
Kz5alayAg9zbHFY+tHtuvThT9Jhg2zHKeHVO07aCxCsciP1L/A2I1E/wYY8ICK5hGVovYJ5JWfgk
QpxPTM54sgip8OncB3dh4GGP5xHdOuY71PIZM8IBvWjKr3C4DVPHTjiupJA1unR7RG86vAAikP/a
Y08/dF5N4HndpKCrSkIegfWzYBxj+NYnWOhgUL2GH/YOplG8w0iwztRx7kiLPayCXUjrUhQPjrnw
djMKYwIDAQABo4ICrzCCAqswgZUGCWCGSAGG+EIBDQSBhxaBhElzc3VlZCB1bmRlciBwb2xpY2ll
czoKIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Evcm9vdC9jcHMvMS4xLwogaHR0cDovL3d3dy5l
dXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLwogaHR0cDovL2NhLnBvbGl0by5pdC9jcHMvMi4xLzAR
BglghkgBhvhCAQEEBAMCALAwYwYIKwYBBQUHAQEEVzBVMCgGCCsGAQUFBzABhhxodHRwOi8vb2Nz
cC5ldXJvcGtpLm9yZzo4MDI2MCkGCCsGAQUFBzAChh1odHRwOi8vd3d3LmV1cm9wa2kub3JnL2Nh
L2l0LzAyBgNVHR8EKzApMCegJaAjhiFodHRwOi8vY2EucG9saXRvLml0L2NybDAzL2NybC5kZXIw
DAYDVR0TAQH/BAIwADA6BgNVHREEMzAxgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdKAWBgorBgEE
AZViAgEBoAgWBjAyMTMwNTCBzQYDVR0gBIHFMIHCMEMGCisGAQQBqQcBAQEwNTAzBggrBgEFBQcC
ARYnaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9yb290L2Nwcy8xLjEvMEEGCisGAQQBqQcCAQEw
MzAxBggrBgEFBQcCARYlaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLzA4Bgor
BgEEAZViAQIBMCowKAYIKwYBBQUHAgEWHGh0dHA6Ly9jYS5wb2xpdG8uaXQvY3BzLzIuMS8wCwYD
VR0PBAQDAgTwMB0GA1UdDgQWBBQ/7fsOlEvqvkE2OCyAWMjwwe8ZNzAfBgNVHSMEGDAWgBQJ/SUZ
b+NofIJrNXO8KAC+LDw6ODANBgkqhkiG9w0BAQUFAAOCAQEANGPQ5YyCXMtdM+4o0P2AxMd3WJE/
NE0jVOJgU39YjK5reY16/rnAqfflXFtsxXqTvO7HF0Luj6JhEt6lU6enD3QB/9KIlFz1AjiuTy3N
KvnEgju8jR8+9yWuNIzKZcK/AqttjCsp7QWEGdJnwCh7BegcNDx/riF4shTyYta7CjX5uurSklQf
lD7r1YAYPTeWf6UWGTYqq9W/zIAPbU/J2tLtSTZksTuXv/4FNAFjxmOk1FnjgLr6juWi7bM3qWRa
1UcHBQ1V1+7fCRJN20Kb/LFHxdSUXJmQsd+FjX1VbiW7FvspngaI8oMRF1DAFvSSNrh6pI4GQA9Z
n1jzOm/hsDGCAhwwggIYAgEBMGswZTELMAkGA1UEBhMCSVQxHjAcBgNVBAoTFVBvbGl0ZWNuaWNv
IGRpIFRvcmlubzE2MDQGA1UEAxMtUG9saXRlY25pY28gZGkgVG9yaW5vIENlcnRpZmljYXRpb24g
QXV0aG9yaXR5AgIDwTAJBgUrDgMCGgUAoIGHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTEwMDMxMjEwNDk1NVowIwYJKoZIhvcNAQkEMRYEFDxFnIoxGHmv9Vy9yZwb
+5zOqSf8MCgGCSqGSIb3DQEJDzEbMBkwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA0GCSqGSIb3
DQEBAQUABIIBAC0NRBgVxn3xjNlJUNsn9ZOTd7e9Xp393RCHsBOe2z2DdrULkV5nCnZq/I40unSZ
ILv1yNPwnIM98doBVBVsyy28wgg54yoGNC952YKXrvwySZw3DbeTI3Du1tBo0+RdM1ZbHCVnHOgi
O4X7a+ACdlPBv8nm4PEtBRRfct44FQYsKqP+G9wuC8tnPgWKlfCvZe1Tckqg8Iqhvdhrb3Nm1rTS
b9K2exO4pu21qxOhBMGgAL0u3gooje6slVJ1fXd84G8bRkcGtGJLC97+m3R633pyONXwizAWTTsh
twH+2xN5ddXEf7znhb9Hkif8BNDG7/LUOvaantoAOMdezvyT6o8AAAAAAAA=

--nextPart3009229.Oko97AiT6n--
