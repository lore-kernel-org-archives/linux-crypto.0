From: Michal Marek <mmarek@suse.com>
Subject: [PATCH] X.509: Fix test for self-signed certificate
Date: Thu, 11 Feb 2016 14:34:25 +0100
Message-ID: <1455197665-11199-1-git-send-email-mmarek@suse.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbcBKNe7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Feb 2016 08:34:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If either the Subject + subjectKeyId or the Issuer + Serial number
differs between the certificate and the CA, the certificate is not
self-signed. In practice, both will be equal for self-signed
certificates and both will differ for CA-signed certificates. It is only
an issue if the CA used the same serial number for its own self-signed
certificate and the certificate we are checking. This is probably not
valid / recommended, but we should not assume that the certificate is
self-signed because of that.

Fixes: 4573b64a31cd ("X.509: Support X.509 lookup by Issuer+Serial form AuthorityKeyIdentifier")
Signed-off-by: Michal Marek <mmarek@suse.com>
---
 crypto/asymmetric_keys/x509_public_key.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 7092d5cbb5d3..2c46e022a2a3 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -308,9 +308,10 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key if it appears to be self-signed */
-	if ((!cert->akid_skid && !cert->akid_id) ||
-	    asymmetric_key_id_same(cert->skid, cert->akid_skid) ||
-	    asymmetric_key_id_same(cert->id, cert->akid_id)) {
+	if ((!cert->akid_skid ||
+			asymmetric_key_id_same(cert->skid, cert->akid_skid)) &&
+	    (!cert->akid_id ||
+			asymmetric_key_id_same(cert->id, cert->akid_id))) {
 		ret = x509_check_signature(cert->pub, cert); /* self-signed */
 		if (ret < 0)
 			goto error_free_cert;
-- 
2.1.4
