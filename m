From: Ameen <ameenali023@gmail.com>
Subject: [PATCH 2/2] updating for keypayload null check.
Date: Wed, 25 Nov 2015 21:04:15 +0200
Message-ID: <1448478255-5443-1-git-send-email-AmeenAli023@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ameen <AmeenAli023@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	dhowells@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35755 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbbKYTEW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Nov 2015 14:04:22 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

adding NULL check to make it fail safe.

Signed-Off-By : Ameen Ali <AmeenAli023@gmail.com>
---
 crypto/asymmetric_keys/x509_public_key.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 2a44b37..76610cc 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -286,6 +286,10 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	char *desc = NULL, *p;
 	int ret;
 
+	if(prep == NULL){
+		pr_debug("NULL payload");
+		return PTR_ERR(prep);
+	}
 	cert = x509_cert_parse(prep->data, prep->datalen);
 	if (IS_ERR(cert))
 		return PTR_ERR(cert);
-- 
2.5.0
