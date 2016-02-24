From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] X.509: Fix test for self-signed certificate
Date: Wed, 24 Feb 2016 14:54:13 +0000
Message-ID: <16658.1456325653@warthog.procyon.org.uk>
References: <1455197665-11199-1-git-send-email-mmarek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Michal Marek <mmarek@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455197665-11199-1-git-send-email-mmarek@suse.com>
Content-ID: <16657.1456325653.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Michal,

I have the attached patch already in my queue.

David
---
commit d19fcb825912c67e09e0575b95accaa42899e07f
Author: David Howells <dhowells@redhat.com>
Date:   Wed Feb 24 14:37:54 2016 +0000

    X.509: Don't treat self-signed keys specially
    
    Trust for a self-signed certificate can normally only be determined by
    whether we obtained it from a trusted location (ie. it was built into the
    kernel at compile time), so there's not really any point in checking it -
    we could verify that the signature is valid, but it doesn't really tell us
    anything if the signature checks out.
    
    However, there's a bug in the code determining whether a certificate is
    self-signed or not - if they have neither AKID nor SKID then we just assume
    that the cert is self-signed, which may not be true.
    
    Given this, remove the code that treats self-signed certs specially when it
    comes to evaluating trustability and attempt to evaluate them as ordinary
    signed certificates.  We then expect self-signed certificates to fail the
    trustability check and be marked as untrustworthy in x509_key_preparse().
    
    Note that there is the possibility of the trustability check on a
    self-signed cert then succeeding.  This is most likely to happen when a
    duplicate of the certificate is already on the trust keyring - in which
    case it shouldn't be a problem.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
    cc: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 9e9e5a6a9ed6..fd76eca902b8 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -255,6 +255,9 @@ static int x509_validate_trust(struct x509_certificate *cert,
 	struct key *key;
 	int ret = 1;
 
+	if (!cert->akid_id || !cert->akid_skid)
+		return 1;
+
 	if (!trust_keyring)
 		return -EOPNOTSUPP;
 
@@ -312,19 +315,23 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
-	/* Check the signature on the key if it appears to be self-signed */
-	if ((!cert->akid_skid && !cert->akid_id) ||
-	    asymmetric_key_id_same(cert->skid, cert->akid_skid) ||
-	    asymmetric_key_id_same(cert->id, cert->akid_id)) {
-		ret = x509_check_signature(cert->pub, cert); /* self-signed */
-		if (ret < 0)
-			goto error_free_cert;
-	} else if (!prep->trusted) {
+	/* See if we can derive the trustability of this certificate.
+	 *
+	 * When it comes to self-signed certificates, we cannot evaluate
+	 * trustedness except by the fact that we obtained it from a trusted
+	 * location.  So we just rely on x509_validate_trust() failing in this
+	 * case.
+	 *
+	 * Note that there's a possibility of a self-signed cert matching a
+	 * cert that we have (most likely a duplicate that we already trust) -
+	 * in which case it will be marked trusted.
+	 */
+	if (!prep->trusted) {
 		ret = x509_validate_trust(cert, get_system_trusted_keyring());
 		if (ret)
 			ret = x509_validate_trust(cert, get_ima_mok_keyring());
 		if (!ret)
-			prep->trusted = 1;
+			prep->trusted = true;
 	}
 
 	/* Propose a description */
