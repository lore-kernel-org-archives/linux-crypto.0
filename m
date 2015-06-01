From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 9/9] xfrm: Define ChaCha20-Poly1305 AEAD XFRM algo for IPsec users
Date: Mon,  1 Jun 2015 13:44:04 +0200
Message-ID: <1433159044-30753-10-git-send-email-martin@strongswan.org>
References: <1433159044-30753-1-git-send-email-martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:40463 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbbFAMYR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 08:24:17 -0400
In-Reply-To: <1433159044-30753-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 net/xfrm/xfrm_algo.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 67266b7..42f7c76 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -159,6 +159,18 @@ static struct xfrm_algo_desc aead_list[] = {
 		.sadb_alg_maxbits = 256
 	}
 },
+{
+	.name = "rfc7539esp(chacha20,poly1305)",
+
+	.uinfo = {
+		.aead = {
+			.geniv = "seqniv",
+			.icv_truncbits = 128,
+		}
+	},
+
+	.pfkey_supported = 0,
+},
 };
 
 static struct xfrm_algo_desc aalg_list[] = {
-- 
1.9.1
