Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EC73624AB;
	Fri, 22 May 2026 05:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779426473; cv=none; b=If1iA5YSGp6bS2Lc63RpJlim0z/taJMPaoBlnqESiX4KS/BITT5QhANjyEyWNkuikpcSentQcyFvBqOUuXcY8OEfb6KvRQ5rWinbt/mQsFXXRtgLcZ+rvdqfR1n8+htG4lHgU+GXUGDHVFTa/TsE2tYd6x5W6tUd1RH3cezqI0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779426473; c=relaxed/simple;
	bh=SuRu5z8lhK3oYz7xQfuIcJRRcKm4R6NLvqduksCiOtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAgkXRQ1lQRA9jVcwd8jh8rgAe1RLEQZU8Roz4vQALSfIqNR7IMlscalZNuWOVylTa3M9aep1YdY3Hck1qyfGMawzSMetidyjt2vEmI4tYeU/w8hbvOYFXxDkeZYjkls3q3EVI4qwAb6e/1CEgLGMTUPW2/tw27rl1lk0mSQXPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUmOKmrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUmOKmrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392FC1F00A3E;
	Fri, 22 May 2026 05:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779426470;
	bh=rR3DeR1uSJhThSMlR8lxO+hM3CrE/ZFTTbFCLgN0AQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUmOKmrPwlVzZi+VrsjX0dmpIRUVkBu36GWkt8D2hBDY/S1mXeRoiIZe18ESc9dVS
	 WudD3bMi3bKvPNA2L6doU1UL2ZYrq/p31Ekq39nFfTpyOWFq3YrD7W5rXi1XBZ8jO3
	 R7OXONW97pGepy0nD+hg9qSpfpCIuIv+gUTYbPAXYoTifWx05d0cRLkrwEzJRFwVb3
	 u1TcFfUTQ22R036cCQeyrfzkmeJvB/nsZYxbO62cBRSsuMN9SzVcMrxo84rQMXOrnq
	 zYrEQWLUBqIw11nEz6/RUdtTrEGMgNbw7iIfbw233zhLOIUDTqyUbiSPZMh6+CN54q
	 UDfxOEjES3t6g==
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
Subject: [PATCH net-next v2 2/5] net/rxrpc: Use local FCrypt-PCBC implementation
Date: Fri, 22 May 2026 00:07:33 -0500
Message-ID: <20260522050740.84561-3-ebiggers@kernel.org>
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

Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/rxrpc/Kconfig       |   1 -
 net/rxrpc/ar-internal.h |   2 +-
 net/rxrpc/rxkad.c       | 353 +++++++++-------------------------------
 3 files changed, 76 insertions(+), 280 deletions(-)

diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index e2bb795cdf0c..de19c67dc965 100644
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
index 30aaf69b4c7c..29d32aa4ecc7 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -575,11 +575,11 @@ struct rxrpc_connection {
 
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
index 6fbd883401ac..d8bc5ecbfc3d 100644
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
@@ -415,53 +336,34 @@ static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
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
 	struct rxkad_level1_hdr *sechdr;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	struct rxrpc_crypt iv;
-	struct scatterlist sg[1];
 	void *data = call->rx_dec_buffer;
 	u32 len = sp->len, data_size, buf;
 	u16 check;
-	int ret;
 
 	_enter("");
 
 	if (len < 8)
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_1_short_header);
 
-	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
-	 * directly into the target buffer.
-	 */
-	sg_init_one(sg, data, len);
-
-	/* start the decryption afresh */
-	memset(&iv, 0, sizeof(iv));
-
-	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, sg, 8, iv.x);
-	ret = crypto_skcipher_decrypt(req);
-	skcipher_request_zero(req);
-	if (ret < 0)
-		return ret;
+	/* Decrypt the first 8-byte block of the packet, using the zero IV. */
+	fcrypt_pcbc_decrypt(call->conn->rxkad.cipher, zero_iv, data, data, 1);
 
 	/* Extract the decrypted packet length */
 	sechdr = data;
 	call->rx_dec_offset = sizeof(*sechdr);
 	len -= sizeof(*sechdr);
@@ -486,52 +388,32 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 
 /*
  * wholly decrypt a packet (level 2 security)
  */
 static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
-				 rxrpc_seq_t seq,
-				 struct skcipher_request *req)
+				 rxrpc_seq_t seq)
 {
 	const struct rxrpc_key_token *token;
 	struct rxkad_level2_hdr *sechdr;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	struct rxrpc_crypt iv;
-	struct scatterlist sg[1];
 	void *data = call->rx_dec_buffer;
 	u32 len = sp->len, data_size, buf;
 	u16 check;
-	int ret;
 
 	_enter(",{%d}", len);
 
 	if (len < 8)
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_2_short_header);
 
 	/* Don't let the crypto algo see a misaligned length. */
 	len = round_down(len, 8);
 
-	/* Decrypt in place in the call's decryption buffer.  TODO: We really
-	 * want to decrypt directly into the target buffer.
-	 */
-	sg_init_one(sg, data, len);
-
 	/* decrypt from the session key */
 	token = call->conn->key->payload.data[0];
-	memcpy(&iv, token->kad->session_key, sizeof(iv));
-
-	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, sg, len, iv.x);
-	ret = crypto_skcipher_decrypt(req);
-	skcipher_request_zero(req);
-	if (ret < 0) {
-		if (ret == -ENOMEM)
-			return ret;
-		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
-					  rxkad_abort_2_crypto_unaligned);
-	}
+	fcrypt_pcbc_decrypt(call->conn->rxkad.cipher, token->kad->session_key,
+			    data, data, len / FCRYPT_BSIZE);
 
 	/* Extract the decrypted packet length */
 	sechdr = data;
 	call->rx_dec_offset = sizeof(*sechdr);
 	len -= sizeof(*sechdr);
@@ -560,13 +442,10 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
  * modifying (e.g. decrypting), it must be copied.
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
@@ -577,31 +456,20 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
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
@@ -615,22 +483,20 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
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
@@ -710,45 +576,10 @@ static void rxkad_calc_response_checksum(struct rxkad_response *response)
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
@@ -844,10 +675,16 @@ int rxkad_insert_response_header(struct rxrpc_connection *conn,
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
 
@@ -888,14 +725,10 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
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
 
@@ -1070,43 +903,26 @@ static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
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
@@ -1189,13 +1005,11 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
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
@@ -1268,48 +1082,31 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
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

