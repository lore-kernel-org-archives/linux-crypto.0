Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53ED139937C;
	Tue, 28 Apr 2026 02:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777344430; cv=none; b=WlF01d0hhRM1W6qcuPiPXSkf+u6AJ61g3YdHHJt12nPdxNL+BIGZCv/4D1iZtVXq4m12i9bO68708GsJCC9ip1/Os2iHtb5JH9tHloTRFmDfJBJBs7qCxJZnzhxK2y2d3H5C3jg3U2s9TwJdjb1AVmwxd2oLa/V+y+lKSDpSa3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777344430; c=relaxed/simple;
	bh=842IZUQ4iXjwFOIojHtZSHXTwjAvjWdSfv4o4FSvA9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuZjB5PRrCjxU84VepFzZceP+42QpfwJ9wxbGbrInTlA039NPCLYhOmzl8r4QubPC3oD8b8H+3gJekOhU5P37KiJ1d01o1aD4nhxUDQeDYpET4Dfz1jbodb0DGAMAWtodWuI0OnHShgiR4EAWMY8KuoD1HaC6GmHPzimrH03mdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rqAOoGJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rqAOoGJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0596C2BCB9;
	Tue, 28 Apr 2026 02:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777344430;
	bh=842IZUQ4iXjwFOIojHtZSHXTwjAvjWdSfv4o4FSvA9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqAOoGJDVIKjnln82EO5gcame3Bx7+X5ESrLHMA+6KPb4mptYGT2SOIiGJn2BKqDk
	 WvrjMtEXKyVyAEu6efUNZYul1mKMgP3mdb6gLrNLkJE5Qub7IrouHBEGdP9EFyYSYc
	 ye8SZvHpLrhIGaeHhocu3CW91iKdw/xI94ml7RI3F5TOe5sWbJulW+P/NK1ODAOfyF
	 /lUq0f2mngc9Uq5XNoDvMBY2eeCJnq4fOjvoXIfl3TN1vJUUxUMISqbVQ3jRd9OcQ0
	 JxGPouHD4hLQWSRx+uu0yVRJ4Z9KqjVDGE0KvHTfJJdIlzV+oe2aM8owUIKLQy7PKU
	 iFYGILTNqGpQQ==
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
Subject: [PATCH net-next 2/5] net/rxrpc: Use local FCrypt-PCBC implementation
Date: Mon, 27 Apr 2026 19:43:55 -0700
Message-ID: <20260428024400.123337-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260428024400.123337-1-ebiggers@kernel.org>
References: <20260428024400.123337-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the local implementation of FCrypt-PCBC instead of the crypto API
one.  This will allow the crypto API one to be removed.  It also
simplifies the code quite a bit.

The local FCrypt-PCBC implementation is also significantly faster than
the crypto API one, since the crypto API one had a lot of overhead.  For
example, benchmarking on an x86_64 CPU, I see that FCrypt-PCBC
decryption throughput improved from 83 MB/s to 157 MB/s.

(Meanwhile, AES-256-GCM decryption is 8064 MB/s on the same CPU.
Clearly, anyone looking for good performance, or anything that is
actually secure for that matter, needs to look elsewhere anyway.)

Note that in rxkad_verify_packet_2(), we start linearizing the skb.
That makes decryption much simpler to implement.  The case where the skb
is already linear becomes much more efficient, as well, since we no
longer do all the scatterlist stuff in that case.  Linearization has its
disadvantages, of course, but in this particular case it seems like a
reasonable trade-off to simplify this insecure legacy code and keep it
working for backwards compatibility.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/rxrpc/Kconfig       |   1 -
 net/rxrpc/ar-internal.h |   2 +-
 net/rxrpc/rxkad.c       | 403 ++++++++++------------------------------
 3 files changed, 95 insertions(+), 311 deletions(-)

diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index 82cc8cc9427e..911219807152 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -58,11 +58,10 @@ config RXKAD
 	bool "RxRPC Kerberos security"
 	select CRYPTO
 	select CRYPTO_MANAGER
 	select CRYPTO_SKCIPHER
 	select CRYPTO_PCBC
-	select CRYPTO_FCRYPT
 	help
 	  Provide kerberos 4 and AFS kaserver security handling for AF_RXRPC
 	  through the use of the key retention service.
 
 	  See Documentation/networking/rxrpc.rst.
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 7efd52f0420d..f505065c4720 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -576,11 +576,11 @@ struct rxrpc_connection {
 
 	struct mutex		security_lock;	/* Lock for security management */
 	const struct rxrpc_security *security;	/* applied security module */
 	union {
 		struct {
-			struct crypto_sync_skcipher *cipher;	/* encryption handle */
+			struct fcrypt_key *cipher; /* encryption key */
 			struct rxrpc_crypt csum_iv;	/* packet checksum base */
 			u32	nonce;		/* response re-use preventer */
 		} rxkad;
 		struct {
 			struct rxgk_context *keys[4]; /* (Re-)keying buffer */
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index cba7935977f0..3c9e7f636b42 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -6,10 +6,11 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <crypto/skcipher.h>
+#include <linux/fips.h>
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/skbuff.h>
 #include <linux/udp.h>
 #include <linux/scatterlist.h>
@@ -28,30 +29,23 @@
 #define INST_SZ				40	/* size of principal's instance */
 #define REALM_SZ			40	/* size of principal's auth domain */
 #define SNAME_SZ			40	/* size of service name */
 #define RXKAD_ALIGN			8
 
+static const u8 zero_iv[FCRYPT_BSIZE];
+
 struct rxkad_level1_hdr {
 	__be32	data_size;	/* true data size (excluding padding) */
 };
 
 struct rxkad_level2_hdr {
 	__be32	data_size;	/* true data size (excluding padding) */
 	__be32	checksum;	/* decrypted data checksum */
 };
 
-static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
-				       struct crypto_sync_skcipher *ci);
-
-/*
- * this holds a pinned cipher so that keventd doesn't get called by the cipher
- * alloc routine, but since we have it to hand, we use it to decrypt RESPONSE
- * packets
- */
-static struct crypto_sync_skcipher *rxkad_ci;
-static struct skcipher_request *rxkad_ci_req;
-static DEFINE_MUTEX(rxkad_ci_mutex);
+static void rxkad_prime_packet_security(struct rxrpc_connection *conn,
+					const struct fcrypt_key *cipher);
 
 /*
  * Parse the information from a server key
  *
  * The data should be the 8-byte secret key.
@@ -98,47 +92,41 @@ static void rxkad_destroy_server_key(struct key *key)
  * initialise connection security
  */
 static int rxkad_init_connection_security(struct rxrpc_connection *conn,
 					  struct rxrpc_key_token *token)
 {
-	struct crypto_sync_skcipher *ci;
+	struct fcrypt_key *ci;
 	int ret;
 
 	_enter("{%d},{%x}", conn->debug_id, key_serial(conn->key));
 
 	conn->security_ix = token->security_index;
 
-	ci = crypto_alloc_sync_skcipher("pcbc(fcrypt)", 0, 0);
-	if (IS_ERR(ci)) {
-		_debug("no cipher");
-		ret = PTR_ERR(ci);
+	ci = kmalloc_obj(*ci);
+	if (!ci) {
+		ret = -ENOMEM;
 		goto error;
 	}
-
-	if (crypto_sync_skcipher_setkey(ci, token->kad->session_key,
-				   sizeof(token->kad->session_key)) < 0)
-		BUG();
+	fcrypt_preparekey(ci, token->kad->session_key);
 
 	switch (conn->security_level) {
 	case RXRPC_SECURITY_PLAIN:
 	case RXRPC_SECURITY_AUTH:
 	case RXRPC_SECURITY_ENCRYPT:
 		break;
 	default:
 		ret = -EKEYREJECTED;
-		goto error;
+		goto error_ci;
 	}
 
-	ret = rxkad_prime_packet_security(conn, ci);
-	if (ret < 0)
-		goto error_ci;
+	rxkad_prime_packet_security(conn, ci);
 
 	conn->rxkad.cipher = ci;
 	return 0;
 
 error_ci:
-	crypto_free_sync_skcipher(ci);
+	kfree_sensitive(ci);
 error:
 	_leave(" = %d", ret);
 	return ret;
 }
 
@@ -186,66 +174,32 @@ static struct rxrpc_txbuf *rxkad_alloc_txbuf(struct rxrpc_call *call, size_t rem
 
 /*
  * prime the encryption state with the invariant parts of a connection's
  * description
  */
-static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
-				       struct crypto_sync_skcipher *ci)
+static void rxkad_prime_packet_security(struct rxrpc_connection *conn,
+					const struct fcrypt_key *cipher)
 {
-	struct skcipher_request *req;
 	struct rxrpc_key_token *token;
-	struct scatterlist sg;
-	struct rxrpc_crypt iv;
-	__be32 *tmpbuf;
-	size_t tmpsize = 4 * sizeof(__be32);
-	int ret;
+	__be32 tmpbuf[4];
 
 	_enter("");
 
 	if (!conn->key)
-		return 0;
-
-	tmpbuf = kmalloc(tmpsize, GFP_KERNEL);
-	if (!tmpbuf)
-		return -ENOMEM;
-
-	req = skcipher_request_alloc(&ci->base, GFP_NOFS);
-	if (!req) {
-		kfree(tmpbuf);
-		return -ENOMEM;
-	}
-
+		return;
 	token = conn->key->payload.data[0];
-	memcpy(&iv, token->kad->session_key, sizeof(iv));
 
 	tmpbuf[0] = htonl(conn->proto.epoch);
 	tmpbuf[1] = htonl(conn->proto.cid);
 	tmpbuf[2] = 0;
 	tmpbuf[3] = htonl(conn->security_ix);
 
-	sg_init_one(&sg, tmpbuf, tmpsize);
-	skcipher_request_set_sync_tfm(req, ci);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sg, &sg, tmpsize, iv.x);
-	ret = crypto_skcipher_encrypt(req);
-	skcipher_request_free(req);
-
-	memcpy(&conn->rxkad.csum_iv, tmpbuf + 2, sizeof(conn->rxkad.csum_iv));
-	kfree(tmpbuf);
-	_leave(" = %d", ret);
-	return ret;
-}
-
-/*
- * Allocate and prepare the crypto request on a call.  For any particular call,
- * this is called serially for the packets, so no lock should be necessary.
- */
-static struct skcipher_request *rxkad_get_call_crypto(struct rxrpc_call *call)
-{
-	struct crypto_skcipher *tfm = &call->conn->rxkad.cipher->base;
-
-	return skcipher_request_alloc(tfm, GFP_NOFS);
+	static_assert(sizeof(tmpbuf) % FCRYPT_BSIZE == 0);
+	fcrypt_pcbc_encrypt(cipher, /* iv= */ token->kad->session_key, tmpbuf,
+			    tmpbuf, sizeof(tmpbuf) / FCRYPT_BSIZE);
+	memcpy(&conn->rxkad.csum_iv, &tmpbuf[2], sizeof(conn->rxkad.csum_iv));
+	_leave("");
 }
 
 /*
  * Clean up the crypto on a call.
  */
@@ -254,20 +208,16 @@ static void rxkad_free_call_crypto(struct rxrpc_call *call)
 }
 
 /*
  * partially encrypt a packet (level 1 security)
  */
-static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
-				    struct rxrpc_txbuf *txb,
-				    struct skcipher_request *req)
+static void rxkad_secure_packet_auth(const struct rxrpc_call *call,
+				     struct rxrpc_txbuf *txb)
 {
 	struct rxkad_level1_hdr *hdr = txb->data;
-	struct rxrpc_crypt iv;
-	struct scatterlist sg;
 	size_t pad;
 	u16 check;
-	int ret;
 
 	_enter("");
 
 	check = txb->seq ^ call->call_id;
 	hdr->data_size = htonl((u32)check << 16 | txb->len);
@@ -280,72 +230,52 @@ static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
 		memset(txb->data + txb->offset, 0, pad);
 		txb->pkt_len += pad;
 	}
 
 	/* start the encryption afresh */
-	memset(&iv, 0, sizeof(iv));
-
-	sg_init_one(&sg, hdr, 8);
-	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
-	ret = crypto_skcipher_encrypt(req);
-	skcipher_request_zero(req);
-
-	_leave(" = %d", ret);
-	return ret;
+	fcrypt_pcbc_encrypt(call->conn->rxkad.cipher, zero_iv, hdr, hdr, 1);
+	_leave("");
 }
 
 /*
  * wholly encrypt a packet (level 2 security)
  */
-static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
-				       struct rxrpc_txbuf *txb,
-				       struct skcipher_request *req)
+static void rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
+					struct rxrpc_txbuf *txb)
 {
 	const struct rxrpc_key_token *token;
 	struct rxkad_level2_hdr *rxkhdr = txb->data;
-	struct rxrpc_crypt iv;
-	struct scatterlist sg;
 	size_t content, pad;
 	u16 check;
-	int ret;
 
 	_enter("");
 
 	check = txb->seq ^ call->call_id;
 
 	rxkhdr->data_size = htonl(txb->len | (u32)check << 16);
 	rxkhdr->checksum = 0;
 
 	content = sizeof(struct rxkad_level2_hdr) + txb->len;
+	static_assert(RXKAD_ALIGN == FCRYPT_BSIZE);
 	txb->pkt_len = round_up(content, RXKAD_ALIGN);
 	pad = txb->pkt_len - content;
 	if (pad)
 		memset(txb->data + txb->offset, 0, pad);
+	/* Now txb->pkt_len % FCRYPT_BSIZE == 0. */
 
 	/* encrypt from the session key */
 	token = call->conn->key->payload.data[0];
-	memcpy(&iv, token->kad->session_key, sizeof(iv));
-
-	sg_init_one(&sg, rxkhdr, txb->pkt_len);
-	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sg, &sg, txb->pkt_len, iv.x);
-	ret = crypto_skcipher_encrypt(req);
-	skcipher_request_zero(req);
-	return ret;
+	fcrypt_pcbc_encrypt(call->conn->rxkad.cipher, token->kad->session_key,
+			    rxkhdr, rxkhdr, txb->pkt_len / FCRYPT_BSIZE);
+	_leave("");
 }
 
 /*
  * checksum an RxRPC packet header
  */
 static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 {
-	struct skcipher_request	*req;
-	struct rxrpc_crypt iv;
-	struct scatterlist sg;
 	union {
 		__be32 buf[2];
 	} crypto __aligned(8);
 	u32 x, y = 0;
 	int ret;
@@ -359,31 +289,20 @@ static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 
 	ret = key_validate(call->conn->key);
 	if (ret < 0)
 		return ret;
 
-	req = rxkad_get_call_crypto(call);
-	if (!req)
-		return -ENOMEM;
-
-	/* continue encrypting from where we left off */
-	memcpy(&iv, call->conn->rxkad.csum_iv.x, sizeof(iv));
-
 	/* calculate the security checksum */
 	x = (call->cid & RXRPC_CHANNELMASK) << (32 - RXRPC_CIDSHIFT);
 	x |= txb->seq & 0x3fffffff;
 	crypto.buf[0] = htonl(call->call_id);
 	crypto.buf[1] = htonl(x);
 
-	sg_init_one(&sg, crypto.buf, 8);
-	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
-	ret = crypto_skcipher_encrypt(req);
-	skcipher_request_zero(req);
-	if (ret < 0)
-		goto out;
+	/* continue encrypting from where we left off */
+	fcrypt_pcbc_encrypt(call->conn->rxkad.cipher,
+			    call->conn->rxkad.csum_iv.x, crypto.buf, crypto.buf,
+			    1);
 
 	y = ntohl(crypto.buf[1]);
 	y = (y >> 16) & 0xffff;
 	if (y == 0)
 		y = 1; /* zero checksums are not permitted */
@@ -393,18 +312,20 @@ static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	case RXRPC_SECURITY_PLAIN:
 		txb->pkt_len = txb->len;
 		ret = 0;
 		break;
 	case RXRPC_SECURITY_AUTH:
-		ret = rxkad_secure_packet_auth(call, txb, req);
+		rxkad_secure_packet_auth(call, txb);
 		if (txb->alloc_size == RXRPC_JUMBO_DATALEN)
 			txb->jumboable = true;
+		ret = 0;
 		break;
 	case RXRPC_SECURITY_ENCRYPT:
-		ret = rxkad_secure_packet_encrypt(call, txb, req);
+		rxkad_secure_packet_encrypt(call, txb);
 		if (txb->alloc_size == RXRPC_JUMBO_DATALEN)
 			txb->jumboable = true;
+		ret = 0;
 		break;
 	default:
 		ret = -EPERM;
 		break;
 	}
@@ -415,64 +336,47 @@ static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 		void *p = txb->data;
 
 		memset(p + txb->pkt_len, 0, gap);
 	}
 
-out:
-	skcipher_request_free(req);
 	_leave(" = %d [set %x]", ret, y);
 	return ret;
 }
 
 /*
  * decrypt partial encryption on a packet (level 1 security)
  */
 static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
-				 rxrpc_seq_t seq,
-				 struct skcipher_request *req)
+				 rxrpc_seq_t seq)
 {
-	struct rxkad_level1_hdr sechdr;
+	union {
+		struct rxkad_level1_hdr sechdr;
+		u8 data[FCRYPT_BSIZE];
+	} crypt;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	struct rxrpc_crypt iv;
-	struct scatterlist sg[16];
 	u32 data_size, buf;
 	u16 check;
-	int ret;
 
 	_enter("");
 
-	if (sp->len < 8)
+	/* Decrypt the first 8-byte block of the packet, using the zero IV. */
+	if (sp->len < FCRYPT_BSIZE ||
+	    skb_copy_bits(skb, sp->offset, crypt.data, FCRYPT_BSIZE) < 0)
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_1_short_header);
-
-	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
-	 * directly into the target buffer.
-	 */
-	sg_init_table(sg, ARRAY_SIZE(sg));
-	ret = skb_to_sgvec(skb, sg, sp->offset, 8);
-	if (unlikely(ret < 0))
-		return ret;
-
 	/* start the decryption afresh */
-	memset(&iv, 0, sizeof(iv));
-
-	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, sg, 8, iv.x);
-	ret = crypto_skcipher_decrypt(req);
-	skcipher_request_zero(req);
-	if (ret < 0)
-		return ret;
+	fcrypt_pcbc_decrypt(call->conn->rxkad.cipher, zero_iv, crypt.data,
+			    crypt.data, 1);
+	if (skb_store_bits(skb, sp->offset, crypt.data, FCRYPT_BSIZE) < 0)
+		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
+					  rxkad_abort_1_short_header);
 
 	/* Extract the decrypted packet length */
-	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0)
-		return rxrpc_abort_eproto(call, skb, RXKADDATALEN,
-					  rxkad_abort_1_short_encdata);
-	sp->offset += sizeof(sechdr);
-	sp->len    -= sizeof(sechdr);
+	sp->offset += sizeof(crypt.sechdr);
+	sp->len -= sizeof(crypt.sechdr);
 
-	buf = ntohl(sechdr.data_size);
+	buf = ntohl(crypt.sechdr.data_size);
 	data_size = buf & 0xffff;
 
 	check = buf >> 16;
 	check ^= seq ^ call->call_id;
 	check &= 0xffff;
@@ -490,74 +394,40 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 
 /*
  * wholly decrypt a packet (level 2 security)
  */
 static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
-				 rxrpc_seq_t seq,
-				 struct skcipher_request *req)
+				 rxrpc_seq_t seq)
 {
 	const struct rxrpc_key_token *token;
 	struct rxkad_level2_hdr sechdr;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	struct rxrpc_crypt iv;
-	struct scatterlist _sg[4], *sg;
 	u32 data_size, buf;
 	u16 check;
-	int nsg, ret;
 
 	_enter(",{%d}", sp->len);
 
 	if (sp->len < 8)
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_2_short_header);
 
 	/* Don't let the crypto algo see a misaligned length. */
 	sp->len = round_down(sp->len, 8);
 
-	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
-	 * directly into the target buffer.
-	 */
-	sg = _sg;
-	nsg = skb_shinfo(skb)->nr_frags + 1;
-	if (nsg <= 4) {
-		nsg = 4;
-	} else {
-		sg = kmalloc_objs(*sg, nsg, GFP_NOIO);
-		if (!sg)
-			return -ENOMEM;
-	}
-
-	sg_init_table(sg, nsg);
-	ret = skb_to_sgvec(skb, sg, sp->offset, sp->len);
-	if (unlikely(ret < 0)) {
-		if (sg != _sg)
-			kfree(sg);
-		return ret;
-	}
+	if (sp->offset + sp->len > skb->len)
+		return -EINVAL;
 
 	/* decrypt from the session key */
 	token = call->conn->key->payload.data[0];
-	memcpy(&iv, token->kad->session_key, sizeof(iv));
-
-	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, sg, sp->len, iv.x);
-	ret = crypto_skcipher_decrypt(req);
-	skcipher_request_zero(req);
-	if (sg != _sg)
-		kfree(sg);
-	if (ret < 0) {
-		if (ret == -ENOMEM)
-			return ret;
-		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
-					  rxkad_abort_2_crypto_unaligned);
-	}
+	if (skb_linearize(skb) < 0)
+		return -ENOMEM;
+	fcrypt_pcbc_decrypt(call->conn->rxkad.cipher, token->kad->session_key,
+			    skb->data + sp->offset, skb->data + sp->offset,
+			    sp->len / FCRYPT_BSIZE);
 
 	/* Extract the decrypted packet length */
-	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0)
-		return rxrpc_abort_eproto(call, skb, RXKADDATALEN,
-					  rxkad_abort_2_short_len);
+	memcpy(&sechdr, skb->data + sp->offset, sizeof(sechdr));
 	sp->offset += sizeof(sechdr);
 	sp->len    -= sizeof(sechdr);
 
 	buf = ntohl(sechdr.data_size);
 	data_size = buf & 0xffff;
@@ -582,13 +452,10 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
  * Verify the security on a received packet and the subpackets therein.
  */
 static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	struct skcipher_request	*req;
-	struct rxrpc_crypt iv;
-	struct scatterlist sg;
 	union {
 		__be32 buf[2];
 	} crypto __aligned(8);
 	rxrpc_seq_t seq = sp->hdr.seq;
 	int ret;
@@ -599,31 +466,20 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 	       call->debug_id, key_serial(call->conn->key), seq);
 
 	if (!call->conn->rxkad.cipher)
 		return 0;
 
-	req = rxkad_get_call_crypto(call);
-	if (!req)
-		return -ENOMEM;
-
-	/* continue encrypting from where we left off */
-	memcpy(&iv, call->conn->rxkad.csum_iv.x, sizeof(iv));
-
 	/* validate the security checksum */
 	x = (call->cid & RXRPC_CHANNELMASK) << (32 - RXRPC_CIDSHIFT);
 	x |= seq & 0x3fffffff;
 	crypto.buf[0] = htonl(call->call_id);
 	crypto.buf[1] = htonl(x);
 
-	sg_init_one(&sg, crypto.buf, 8);
-	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
-	ret = crypto_skcipher_encrypt(req);
-	skcipher_request_zero(req);
-	if (ret < 0)
-		goto out;
+	/* continue encrypting from where we left off */
+	fcrypt_pcbc_encrypt(call->conn->rxkad.cipher,
+			    call->conn->rxkad.csum_iv.x, crypto.buf, crypto.buf,
+			    1);
 
 	y = ntohl(crypto.buf[1]);
 	cksum = (y >> 16) & 0xffff;
 	if (cksum == 0)
 		cksum = 1; /* zero checksums are not permitted */
@@ -637,22 +493,20 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 	switch (call->conn->security_level) {
 	case RXRPC_SECURITY_PLAIN:
 		ret = 0;
 		break;
 	case RXRPC_SECURITY_AUTH:
-		ret = rxkad_verify_packet_1(call, skb, seq, req);
+		ret = rxkad_verify_packet_1(call, skb, seq);
 		break;
 	case RXRPC_SECURITY_ENCRYPT:
-		ret = rxkad_verify_packet_2(call, skb, seq, req);
+		ret = rxkad_verify_packet_2(call, skb, seq);
 		break;
 	default:
 		ret = -ENOANO;
 		break;
 	}
-
 out:
-	skcipher_request_free(req);
 	return ret;
 }
 
 /*
  * issue a challenge
@@ -732,45 +586,10 @@ static void rxkad_calc_response_checksum(struct rxkad_response *response)
 		csum = csum * 0x10204081 + *p++;
 
 	response->encrypted.checksum = htonl(csum);
 }
 
-/*
- * encrypt the response packet
- */
-static int rxkad_encrypt_response(struct rxrpc_connection *conn,
-				  struct sk_buff *response,
-				  const struct rxkad_key *s2)
-{
-	struct skcipher_request *req;
-	struct rxrpc_crypt iv;
-	struct scatterlist sg[1];
-	size_t encsize = sizeof(((struct rxkad_response *)0)->encrypted);
-	int ret;
-
-	sg_init_table(sg, ARRAY_SIZE(sg));
-	ret = skb_to_sgvec(response, sg,
-			   sizeof(struct rxrpc_wire_header) +
-			   offsetof(struct rxkad_response, encrypted), encsize);
-	if (ret < 0)
-		return ret;
-
-	req = skcipher_request_alloc(&conn->rxkad.cipher->base, GFP_NOFS);
-	if (!req)
-		return -ENOMEM;
-
-	/* continue encrypting from where we left off */
-	memcpy(&iv, s2->session_key, sizeof(iv));
-
-	skcipher_request_set_sync_tfm(req, conn->rxkad.cipher);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, sg, encsize, iv.x);
-	ret = crypto_skcipher_encrypt(req);
-	skcipher_request_free(req);
-	return ret;
-}
-
 /*
  * Validate a challenge packet.
  */
 static bool rxkad_validate_challenge(struct rxrpc_connection *conn,
 				     struct sk_buff *skb)
@@ -866,10 +685,16 @@ int rxkad_insert_response_header(struct rxrpc_connection *conn,
 	h.resp.kvno			= htonl(token->kad->kvno);
 	h.resp.ticket_len		= htonl(token->kad->ticket_len);
 
 	rxkad_calc_response_checksum(&h.resp);
 
+	/* encrypt the response packet */
+	static_assert(sizeof(h.resp.encrypted) % FCRYPT_BSIZE == 0);
+	fcrypt_pcbc_encrypt(conn->rxkad.cipher, token->kad->session_key,
+			    &h.resp.encrypted, &h.resp.encrypted,
+			    sizeof(h.resp.encrypted) / FCRYPT_BSIZE);
+
 	ret = skb_store_bits(response, *offset, &h, sizeof(h));
 	*offset += sizeof(h);
 	return ret;
 }
 
@@ -910,14 +735,10 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
 	ret = rxkad_insert_response_header(conn, token, challenge, response,
 					   &offset);
 	if (ret < 0)
 		goto error;
 
-	ret = rxkad_encrypt_response(conn, response, token->kad);
-	if (ret < 0)
-		goto error;
-
 	ret = skb_store_bits(response, offset, token->kad->ticket,
 			     token->kad->ticket_len);
 	if (ret < 0)
 		goto error;
 
@@ -1093,43 +914,26 @@ static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
 }
 
 /*
  * decrypt the response packet
  */
-static int rxkad_decrypt_response(struct rxrpc_connection *conn,
-				  struct rxkad_response *resp,
-				  const struct rxrpc_crypt *session_key)
+static void rxkad_decrypt_response(struct rxrpc_connection *conn,
+				   struct rxkad_response *resp,
+				   const struct rxrpc_crypt *session_key)
 {
-	struct skcipher_request *req = rxkad_ci_req;
-	struct scatterlist sg[1];
-	struct rxrpc_crypt iv;
-	int ret;
+	struct fcrypt_key cipher;
 
 	_enter(",,%08x%08x",
 	       ntohl(session_key->n[0]), ntohl(session_key->n[1]));
 
-	mutex_lock(&rxkad_ci_mutex);
-	ret = crypto_sync_skcipher_setkey(rxkad_ci, session_key->x,
-					  sizeof(*session_key));
-	if (ret < 0)
-		goto unlock;
-
-	memcpy(&iv, session_key, sizeof(iv));
-
-	sg_init_table(sg, 1);
-	sg_set_buf(sg, &resp->encrypted, sizeof(resp->encrypted));
-	skcipher_request_set_sync_tfm(req, rxkad_ci);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, sg, sizeof(resp->encrypted), iv.x);
-	ret = crypto_skcipher_decrypt(req);
-	skcipher_request_zero(req);
-
-unlock:
-	mutex_unlock(&rxkad_ci_mutex);
+	fcrypt_preparekey(&cipher, session_key->x);
 
+	static_assert(sizeof(resp->encrypted) % FCRYPT_BSIZE == 0);
+	fcrypt_pcbc_decrypt(&cipher, session_key->x, &resp->encrypted,
+			    &resp->encrypted,
+			    sizeof(resp->encrypted) / FCRYPT_BSIZE);
 	_leave("");
-	return ret;
 }
 
 /*
  * verify a response
  */
@@ -1218,13 +1022,11 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	if (ret < 0)
 		goto error;
 
 	/* use the session key from inside the ticket to decrypt the
 	 * response */
-	ret = rxkad_decrypt_response(conn, response, &session_key);
-	if (ret < 0)
-		goto error;
+	rxkad_decrypt_response(conn, response, &session_key);
 
 	if (ntohl(response->encrypted.epoch) != conn->proto.epoch ||
 	    ntohl(response->encrypted.cid) != conn->proto.cid ||
 	    ntohl(response->encrypted.securityIndex) != conn->security_ix) {
 		ret = rxrpc_abort_conn(conn, skb, RXKADSEALEDINCON, -EPROTO,
@@ -1299,48 +1101,31 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
  */
 static void rxkad_clear(struct rxrpc_connection *conn)
 {
 	_enter("");
 
-	if (conn->rxkad.cipher)
-		crypto_free_sync_skcipher(conn->rxkad.cipher);
+	kfree_sensitive(conn->rxkad.cipher);
+	conn->rxkad.cipher = NULL;
 }
 
 /*
  * Initialise the rxkad security service.
  */
 static int rxkad_init(void)
 {
-	struct crypto_sync_skcipher *tfm;
-	struct skcipher_request *req;
-
-	/* pin the cipher we need so that the crypto layer doesn't invoke
-	 * keventd to go get it */
-	tfm = crypto_alloc_sync_skcipher("pcbc(fcrypt)", 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	req = skcipher_request_alloc(&tfm->base, GFP_KERNEL);
-	if (!req)
-		goto nomem_tfm;
-
-	rxkad_ci_req = req;
-	rxkad_ci = tfm;
+	if (fips_enabled) {
+		pr_warn("rxkad support is disabled due to FIPS\n");
+		return -ENOENT;
+	}
 	return 0;
-
-nomem_tfm:
-	crypto_free_sync_skcipher(tfm);
-	return -ENOMEM;
 }
 
 /*
  * Clean up the rxkad security service.
  */
 static void rxkad_exit(void)
 {
-	crypto_free_sync_skcipher(rxkad_ci);
-	skcipher_request_free(rxkad_ci_req);
 }
 
 /*
  * RxRPC Kerberos-based security
  */
-- 
2.54.0

