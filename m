From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 16/18] rxrpc: Reuse SKCIPHER_REQUEST_ON_STACK buffer
Date: Tue, 24 Jul 2018 09:49:34 -0700
Message-ID: <20180724164936.37477-17-keescook@chromium.org>
References: <20180724164936.37477-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowe
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180724164936.37477-1-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The use of SKCIPHER_REQUEST_ON_STACK() will trigger FRAME_WARN warnings
(when less than 2048) once the VLA is no longer hidden from the check:

net/rxrpc/rxkad.c:398:1: warning: the frame size of 1152 bytes is larger than 1024 bytes [-Wframe-larger-than=]
net/rxrpc/rxkad.c:242:1: warning: the frame size of 1152 bytes is larger than 1024 bytes [-Wframe-larger-than=]

This passes the initial SKCIPHER_REQUEST_ON_STACK allocation to the leaf
functions for reuse. Two requests allocated on the stack is not needed
when only one is used at a time.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 net/rxrpc/rxkad.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 278ac0807a60..6393391fac86 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -146,10 +146,10 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
 static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
 				    struct sk_buff *skb,
 				    u32 data_size,
-				    void *sechdr)
+				    void *sechdr,
+				    struct skcipher_request *req)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	SKCIPHER_REQUEST_ON_STACK(req, call->conn->cipher);
 	struct rxkad_level1_hdr hdr;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg;
@@ -183,12 +183,12 @@ static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
 static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 				       struct sk_buff *skb,
 				       u32 data_size,
-				       void *sechdr)
+				       void *sechdr,
+				       struct skcipher_request *req)
 {
 	const struct rxrpc_key_token *token;
 	struct rxkad_level2_hdr rxkhdr;
 	struct rxrpc_skb_priv *sp;
-	SKCIPHER_REQUEST_ON_STACK(req, call->conn->cipher);
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[16];
 	struct sk_buff *trailer;
@@ -296,11 +296,12 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
 		ret = 0;
 		break;
 	case RXRPC_SECURITY_AUTH:
-		ret = rxkad_secure_packet_auth(call, skb, data_size, sechdr);
+		ret = rxkad_secure_packet_auth(call, skb, data_size, sechdr,
+					       req);
 		break;
 	case RXRPC_SECURITY_ENCRYPT:
 		ret = rxkad_secure_packet_encrypt(call, skb, data_size,
-						  sechdr);
+						  sechdr, req);
 		break;
 	default:
 		ret = -EPERM;
@@ -316,10 +317,10 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
  */
 static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 				 unsigned int offset, unsigned int len,
-				 rxrpc_seq_t seq)
+				 rxrpc_seq_t seq,
+				 struct skcipher_request *req)
 {
 	struct rxkad_level1_hdr sechdr;
-	SKCIPHER_REQUEST_ON_STACK(req, call->conn->cipher);
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[16];
 	struct sk_buff *trailer;
@@ -402,11 +403,11 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
  */
 static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 				 unsigned int offset, unsigned int len,
-				 rxrpc_seq_t seq)
+				 rxrpc_seq_t seq,
+				 struct skcipher_request *req)
 {
 	const struct rxrpc_key_token *token;
 	struct rxkad_level2_hdr sechdr;
-	SKCIPHER_REQUEST_ON_STACK(req, call->conn->cipher);
 	struct rxrpc_crypt iv;
 	struct scatterlist _sg[4], *sg;
 	struct sk_buff *trailer;
@@ -549,9 +550,9 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	case RXRPC_SECURITY_PLAIN:
 		return 0;
 	case RXRPC_SECURITY_AUTH:
-		return rxkad_verify_packet_1(call, skb, offset, len, seq);
+		return rxkad_verify_packet_1(call, skb, offset, len, seq, req);
 	case RXRPC_SECURITY_ENCRYPT:
-		return rxkad_verify_packet_2(call, skb, offset, len, seq);
+		return rxkad_verify_packet_2(call, skb, offset, len, seq, req);
 	default:
 		return -ENOANO;
 	}
-- 
2.17.1
