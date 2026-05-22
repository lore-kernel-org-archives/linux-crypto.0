Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077BD363C62;
	Fri, 22 May 2026 05:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779426474; cv=none; b=B10oTr2YCnV6eykBKkEBoNh4oF9xf8pq5F4QI58K+c6mMWlLhLK+Iwg97KynJ2ebBnSrm6dokvhzWT9aIgz+TM1YLu2eYJj+vj2F3448on0ln9/qpwCuVAQChOX/iEWBSV29MxoLXVynaO4MH5b1kWewic+jxldDJFadi5pPjwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779426474; c=relaxed/simple;
	bh=YVdkVt5Q1YzEU8xrOBXwbZfk33BrOMnk8Av8x9/Q5GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FypmmScQeqlru4OUCqzUqM8QjmXaceFlX8bawC81EPjx2+0Mot3Zxk4pOrjCis6nibq6qaRosr1Lw9sT9iTx3zFRen+17azojNswpvnkim1dhMFYIX7A4NDDz03os8dkU5AQl/wTarfBxc88CIgPLHazNMggFON3eJG60VR7zh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5KhvOaR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5KhvOaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE6B1F000E9;
	Fri, 22 May 2026 05:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779426470;
	bh=RE8zw7SGnqcTYHAWD5IFxg3YX4EJ1yXQvTpVYApC2cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5KhvOaRDC5m/tGa2iffIaMQbveX+3P3ENxtWDNSopJdluWzZJuNG3afn0b0guj5y
	 9+J1vA5beXnVhdn1Yyila9dXizk6yoXBuPDugeJa6Cl1rybA8CPfkvef5cLEQHhOre
	 2EucQ++daE456JzSVp2YTA78+c0PhKtu5zCtvCn6dky0NOnHPeakGsGtttwRf8/+K+
	 STMcGvURc27ZGIfniO2067Ga9ysuAEOfRDvpVlVAIhZLdbbnmgjfHhUdbwloCgcxqc
	 DqGHDus8jtm3ub2YuF9LuzjgH+Zxx5AWwZu9/DcVMfdxbIKhd3A4TgIunUwrcMii4m
	 yYoKuIFc5KC/w==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	linux-afs@lists.infradead.org
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next v2 3/5] net/rxrpc: Reimplement DES-PCBC using DES library
Date: Fri, 22 May 2026 00:07:34 -0500
Message-ID: <20260522050740.84561-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522050740.84561-1-ebiggers@kernel.org>
References: <20260522050740.84561-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the use of "pcbc(des)" in rxkad_decrypt_ticket() is the only
remaining user of the crypto API "pcbc" template, just implement
DES-PCBC by locally implementing PCBC mode on top of the DES library.
Note that only the decryption direction is needed.

This will allow support for the obsolete PCBC mode to be removed from
the crypto API.

Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/rxrpc/Kconfig             |  5 +--
 net/rxrpc/ar-internal.h       |  5 +++
 net/rxrpc/key.c               |  1 -
 net/rxrpc/rxkad.c             | 76 +++++++++++++++++++----------------
 net/rxrpc/server_key.c        |  1 -
 net/rxrpc/tests/rxrpc_kunit.c | 31 ++++++++++++++
 6 files changed, 79 insertions(+), 40 deletions(-)

diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index de19c67dc965..2cebb666dc07 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -5,10 +5,11 @@
 
 config AF_RXRPC
 	tristate "RxRPC session sockets"
 	depends on INET
 	select CRYPTO
+	select CRYPTO_LIB_DES if RXKAD
 	select KEYS
 	select NET_UDP_TUNNEL
 	help
 	  Say Y or M here to include support for RxRPC session sockets (just
 	  the transport part, not the presentation part: (un)marshalling is
@@ -54,14 +55,10 @@ config AF_RXRPC_DEBUG
 	  See Documentation/networking/rxrpc.rst.
 
 
 config RXKAD
 	bool "RxRPC Kerberos security"
-	select CRYPTO
-	select CRYPTO_MANAGER
-	select CRYPTO_SKCIPHER
-	select CRYPTO_PCBC
 	help
 	  Provide kerberos 4 and AFS kaserver security handling for AF_RXRPC
 	  through the use of the key retention service.
 
 	  See Documentation/networking/rxrpc.rst.
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 29d32aa4ecc7..5802f6f78723 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -34,10 +34,15 @@ void fcrypt_pcbc_encrypt(const struct fcrypt_key *key,
 			 const u8 iv[FCRYPT_BSIZE], const void *src, void *dst,
 			 size_t nblocks);
 void fcrypt_pcbc_decrypt(const struct fcrypt_key *key,
 			 const u8 iv[FCRYPT_BSIZE], const void *src, void *dst,
 			 size_t nblocks);
+#if IS_ENABLED(CONFIG_KUNIT)
+struct des_ctx;
+void des_pcbc_decrypt_inplace(const struct des_ctx *key, __le64 iv, u8 *data,
+			      size_t len);
+#endif
 
 #define rxrpc_queue_work(WS)	queue_work(rxrpc_workqueue, (WS))
 #define rxrpc_queue_delayed_work(WS,D)	\
 	queue_delayed_work(rxrpc_workqueue, (WS), (D))
 
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 3ec3d89fdf14..a0aa78d89289 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -8,11 +8,10 @@
  *	"afs@example.com"
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <crypto/skcipher.h>
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/overflow.h>
 #include <linux/skbuff.h>
 #include <linux/key-type.h>
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index d8bc5ecbfc3d..ca9f0e82cb9a 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -5,20 +5,22 @@
  * Written by David Howells (dhowells@redhat.com)
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <crypto/skcipher.h>
+#include <crypto/des.h>
+#include <kunit/visibility.h>
+#include <linux/export.h>
 #include <linux/fips.h>
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/skbuff.h>
 #include <linux/udp.h>
-#include <linux/scatterlist.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
 #include <linux/key-type.h>
+#include <linux/unaligned.h>
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
 #include <keys/rxrpc-type.h>
 #include "ar-internal.h"
 
@@ -50,44 +52,45 @@ static void rxkad_prime_packet_security(struct rxrpc_connection *conn,
  *
  * The data should be the 8-byte secret key.
  */
 static int rxkad_preparse_server_key(struct key_preparsed_payload *prep)
 {
-	struct crypto_skcipher *ci;
+	struct des_ctx *des_key;
+	int err;
 
 	if (prep->datalen != 8)
 		return -EINVAL;
 
 	memcpy(&prep->payload.data[2], prep->data, 8);
 
-	ci = crypto_alloc_skcipher("pcbc(des)", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(ci)) {
-		_leave(" = %ld", PTR_ERR(ci));
-		return PTR_ERR(ci);
+	des_key = kmalloc_obj(*des_key);
+	if (!des_key) {
+		_leave(" = -ENOMEM");
+		return -ENOMEM;
 	}
 
-	if (crypto_skcipher_setkey(ci, prep->data, 8) < 0)
-		BUG();
+	err = des_expand_key(des_key, prep->data, 8);
+	if (err) {
+		kfree_sensitive(des_key);
+		_leave(" = %d", err);
+		return err;
+	}
 
-	prep->payload.data[0] = ci;
+	prep->payload.data[0] = des_key;
 	_leave(" = 0");
 	return 0;
 }
 
 static void rxkad_free_preparse_server_key(struct key_preparsed_payload *prep)
 {
-
-	if (prep->payload.data[0])
-		crypto_free_skcipher(prep->payload.data[0]);
+	kfree_sensitive(prep->payload.data[0]);
 }
 
 static void rxkad_destroy_server_key(struct key *key)
 {
-	if (key->payload.data[0]) {
-		crypto_free_skcipher(key->payload.data[0]);
-		key->payload.data[0] = NULL;
-	}
+	kfree_sensitive(key->payload.data[0]);
+	key->payload.data[0] = NULL;
 }
 
 /*
  * initialise connection security
  */
@@ -769,51 +772,56 @@ int rxkad_kernel_respond_to_challenge(struct sk_buff *challenge)
 
 	return rxkad_respond_to_challenge(csp->chall.conn, challenge);
 }
 EXPORT_SYMBOL(rxkad_kernel_respond_to_challenge);
 
+/* Decrypt data in-place using DES-PCBC.  @len must be a multiple of 8. */
+VISIBLE_IF_KUNIT void des_pcbc_decrypt_inplace(const struct des_ctx *key,
+					       __le64 iv, u8 *data, size_t len)
+{
+	for (size_t i = 0; i < len; i += DES_BLOCK_SIZE) {
+		__le64 ctext, ptext;
+
+		ctext = get_unaligned((const __le64 *)&data[i]);
+		des_decrypt(key, (u8 *)&ptext, (const u8 *)&ctext);
+		ptext ^= iv;
+		put_unaligned(ptext, (__le64 *)&data[i]);
+		iv = ptext ^ ctext;
+	}
+}
+EXPORT_SYMBOL_IF_KUNIT(des_pcbc_decrypt_inplace);
+
 /*
  * decrypt the kerberos IV ticket in the response
  */
 static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
 				struct key *server_key,
 				struct sk_buff *skb,
 				void *ticket, size_t ticket_len,
 				struct rxrpc_crypt *_session_key,
 				time64_t *_expiry)
 {
-	struct skcipher_request *req;
-	struct rxrpc_crypt iv, key;
-	struct scatterlist sg[1];
+	struct rxrpc_crypt key;
 	struct in_addr addr;
 	unsigned int life;
 	time64_t issue, now;
-	int ret;
 	bool little_endian;
 	u8 *p, *q, *name, *end;
 
 	_enter("{%d},{%x}", conn->debug_id, key_serial(server_key));
 
 	*_expiry = 0;
 
 	ASSERT(server_key->payload.data[0] != NULL);
 
-	memcpy(&iv, &server_key->payload.data[2], sizeof(iv));
-
-	req = skcipher_request_alloc(server_key->payload.data[0], GFP_NOFS);
-	if (!req)
-		return -ENOMEM;
-
-	sg_init_one(&sg[0], ticket, ticket_len);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, sg, ticket_len, iv.x);
-	ret = crypto_skcipher_decrypt(req);
-	skcipher_request_free(req);
-	if (ret < 0)
+	if (ticket_len % DES_BLOCK_SIZE != 0)
 		return rxrpc_abort_conn(conn, skb, RXKADBADTICKET, -EPROTO,
 					rxkad_abort_resp_tkt_short);
-
+	des_pcbc_decrypt_inplace(
+		server_key->payload.data[0],
+		get_unaligned((const __le64 *)&server_key->payload.data[2]),
+		ticket, ticket_len);
 	p = ticket;
 	end = p + ticket_len;
 
 #define Z(field, fieldl)						\
 	({								\
diff --git a/net/rxrpc/server_key.c b/net/rxrpc/server_key.c
index 27491f1e1273..3efe104b1930 100644
--- a/net/rxrpc/server_key.c
+++ b/net/rxrpc/server_key.c
@@ -8,11 +8,10 @@
  *	"afs@CAMBRIDGE.REDHAT.COM>
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <crypto/skcipher.h>
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/skbuff.h>
 #include <linux/key-type.h>
 #include <linux/ctype.h>
diff --git a/net/rxrpc/tests/rxrpc_kunit.c b/net/rxrpc/tests/rxrpc_kunit.c
index 85a9859fae44..95fd05a07d17 100644
--- a/net/rxrpc/tests/rxrpc_kunit.c
+++ b/net/rxrpc/tests/rxrpc_kunit.c
@@ -3,10 +3,11 @@
  * Unit tests for RxRPC crypto functions
  *
  * Copyright 2026 Google LLC
  */
 #include "../ar-internal.h"
+#include <crypto/des.h>
 #include <kunit/test.h>
 
 struct fcrypt_pcbc_testvec {
 	u8 key[FCRYPT_BSIZE];
 	u8 iv[FCRYPT_BSIZE];
@@ -91,12 +92,42 @@ static void test_fcrypt_pcbc(struct kunit *test)
 		fcrypt_pcbc_decrypt(&key, tv->iv, data, data, nblocks);
 		KUNIT_ASSERT_MEMEQ(test, tv->ptext, data, len);
 	}
 }
 
+static void test_des_pcbc(struct kunit *test)
+{
+	/* This was generated from the original pcbc(des) crypto API code. */
+	static const u8 expected_ptext[24] =
+		"\xc8\xe2\x3c\xdf\x80\x61\x8a\xad\xa5\x52\xb4\x20"
+		"\x74\x32\x1f\xe4\x2c\x15\x7d\x21\x57\xda\x3f\x31";
+	u8 key[8];
+	union {
+		__le64 w;
+		u8 b[8];
+	} iv;
+	u8 data[24];
+	struct des_ctx ctx;
+	int err;
+
+	for (int i = 0; i < 8; i++) {
+		key[i] = i;
+		iv.b[i] = 255 - i;
+	}
+	for (int i = 0; i < sizeof(data); i++)
+		data[i] = i;
+
+	err = des_expand_key(&ctx, key, sizeof(key));
+	KUNIT_ASSERT_EQ(test, 0, err);
+
+	des_pcbc_decrypt_inplace(&ctx, iv.w, data, sizeof(data));
+	KUNIT_ASSERT_MEMEQ(test, expected_ptext, data, sizeof(data));
+}
+
 static struct kunit_case rxrpc_test_cases[] = {
 	KUNIT_CASE(test_fcrypt_pcbc),
+	KUNIT_CASE(test_des_pcbc),
 	{},
 };
 
 static struct kunit_suite rxrpc_test_suite = {
 	.name = "rxrpc",
-- 
2.54.0

