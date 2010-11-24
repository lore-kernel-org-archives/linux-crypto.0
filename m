From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 3/5] Add "alg_name" operation to af_alg_type.
Date: Wed, 24 Nov 2010 18:05:53 +0100
Message-ID: <1290618355-31193-4-git-send-email-mitr@redhat.com>
References: <1290618355-31193-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-audit@redhat.com, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: eparis@redhat.com, herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab0KXRGP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Nov 2010 12:06:15 -0500
In-Reply-To: <1290618355-31193-1-git-send-email-mitr@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Miloslav Trma=C4=8D <mitr@redhat.com>
---
 crypto/algif_hash.c     |    6 ++++++
 crypto/algif_skcipher.c |    6 ++++++
 include/crypto/if_alg.h |    1 +
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index f08a42c..3a61e9d 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -243,6 +243,11 @@ static void hash_release(void *private)
 	crypto_free_ahash(private);
 }
=20
+static const char *hash_alg_name(void *private)
+{
+	return crypto_tfm_alg_name(crypto_ahash_tfm(private));
+}
+
 static int hash_setkey(void *private, const u8 *key, unsigned int keyl=
en)
 {
 	return crypto_ahash_setkey(private, key, keylen);
@@ -296,6 +301,7 @@ static int hash_accept_parent(void *private, struct=
 sock *sk)
 static const struct af_alg_type algif_type_hash =3D {
 	.bind		=3D	hash_bind,
 	.release	=3D	hash_release,
+	.alg_name	=3D	hash_alg_name,
 	.setkey		=3D	hash_setkey,
 	.accept		=3D	hash_accept_parent,
 	.ops		=3D	&algif_hash_ops,
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 4069460..e14c8be 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -561,6 +561,11 @@ static void skcipher_release(void *private)
 	crypto_free_ablkcipher(private);
 }
=20
+static const char *skcipher_alg_name(void *private)
+{
+	return crypto_tfm_alg_name(crypto_ablkcipher_tfm(private));
+}
+
 static int skcipher_setkey(void *private, const u8 *key, unsigned int =
keylen)
 {
 	return crypto_ablkcipher_setkey(private, key, keylen);
@@ -619,6 +624,7 @@ static int skcipher_accept_parent(void *private, st=
ruct sock *sk)
 static const struct af_alg_type algif_type_skcipher =3D {
 	.bind		=3D	skcipher_bind,
 	.release	=3D	skcipher_release,
+	.alg_name	=3D	skcipher_alg_name,
 	.setkey		=3D	skcipher_setkey,
 	.accept		=3D	skcipher_accept_parent,
 	.ops		=3D	&algif_skcipher_ops,
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 336b9f2..092c599 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -49,6 +49,7 @@ struct af_alg_control {
 struct af_alg_type {
 	void *(*bind)(const char *name, u32 type, u32 mask);
 	void (*release)(void *private);
+	const char *(*alg_name)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
 	int (*accept)(void *private, struct sock *sk);
=20
--=20
1.7.3.2
