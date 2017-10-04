From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH] KEYS: checking the input id parameters before finding asymmetric key
Date: Wed,  4 Oct 2017 16:45:09 +0800
Message-ID: <20171004084509.28481-1-jlee@suse.com>
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35090 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdJDIpQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Oct 2017 04:45:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For finding asymmetric key, the input id_0 and id_1 parameters can
not be NULL at the same time. This patch adds the BUG_ON checking
for id_0 and id_1.

Cc: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 crypto/asymmetric_keys/asymmetric_type.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index e4b0ed3..3a3b028 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -57,6 +57,8 @@ struct key *find_asymmetric_key(struct key *keyring,
 	char *req, *p;
 	int len;
 
+	BUG_ON(!id_0 && !id_1);
+
 	if (id_0) {
 		lookup = id_0->data;
 		len = id_0->len;
-- 
2.10.2
