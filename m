Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:43998 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbeLKKUP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 05:20:15 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Cc: dt@chelsio.com, atul.gupta@chelsio.com
Subject: [tls 1/5] net/tls: Init routines in create_ctx
Date: Tue, 11 Dec 2018 02:19:40 -0800
Message-Id: <20181211101940.3509-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

create_ctx is called from tls_init and tls_hw_prot
hence initialize function pointers in common routine.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 net/tls/tls_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 311cec8..4920803 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -543,6 +543,9 @@ static struct tls_context *create_ctx(struct sock *sk)
 		return NULL;
 
 	icsk->icsk_ulp_data = ctx;
+	ctx->setsockopt = sk->sk_prot->setsockopt;
+	ctx->getsockopt = sk->sk_prot->getsockopt;
+	ctx->sk_proto_close = sk->sk_prot->close;
 	return ctx;
 }
 
@@ -675,9 +678,6 @@ static int tls_init(struct sock *sk)
 		rc = -ENOMEM;
 		goto out;
 	}
-	ctx->setsockopt = sk->sk_prot->setsockopt;
-	ctx->getsockopt = sk->sk_prot->getsockopt;
-	ctx->sk_proto_close = sk->sk_prot->close;
 
 	/* Build IPv6 TLS whenever the address of tcpv6	_prot changes */
 	if (ip_ver == TLSV6 &&
-- 
1.8.3.1
