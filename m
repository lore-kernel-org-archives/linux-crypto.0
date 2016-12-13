From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] crypto: asymmetric_keys: set error code on failure
Date: Tue, 13 Dec 2016 09:26:18 +0000
Message-ID: <148162117870.19689.15511298103589902019.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, Pan Bian <bianpan2016@163.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932345AbcLMJ0V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 04:26:21 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Pan Bian <bianpan2016@163.com>

In function public_key_verify_signature(), returns variable ret on
error paths. When the call to kmalloc() fails, the value of ret is 0,
and it is not set to an errno before returning. This patch fixes the
bug.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188891

Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/public_key.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index fd76b5fc3b3a..d3a989e718f5 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -121,6 +121,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_req;
 
+	ret = -ENOMEM;
 	outlen = crypto_akcipher_maxsize(tfm);
 	output = kmalloc(outlen, GFP_KERNEL);
 	if (!output)
