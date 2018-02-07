From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 1/9] PKCS#7: fix certificate chain verification
Date: Tue,  6 Feb 2018 17:10:04 -0800
Message-ID: <20180207011012.5928-2-ebiggers3@gmail.com>
References: <20180207011012.5928-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180207011012.5928-1-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When pkcs7_verify_sig_chain() is building the certificate chain for a
SignerInfo using the certificates in the PKCS#7 message, it is passing
the wrong arguments to public_key_verify_signature().  Consequently,
when the next certificate is supposed to be used to verify the previous
certificate, the next certificate is actually used to verify itself.

An attacker can use this bug to create a bogus certificate chain that
has no cryptographic relationship between the beginning and end.

Fortunately I couldn't quite find a way to use this to bypass the
overall signature verification, though it comes very close.  Here's the
reasoning: due to the bug, every certificate in the chain beyond the
first actually has to be self-signed (where "self-signed" here refers to
the actual key and signature; an attacker might still manipulate the
certificate fields such that the self_signed flag doesn't actually get
set, and thus the chain doesn't end immediately).  But to pass trust
validation (pkcs7_validate_trust()), either the SignerInfo or one of the
certificates has to actually be signed by a trusted key.  Since only
self-signed certificates can be added to the chain, the only way for an
attacker to introduce a trusted signature is to include a self-signed
trusted certificate.

But, when pkcs7_validate_trust_one() reaches that certificate, instead
of trying to verify the signature on that certificate, it will actually
look up the corresponding trusted key, which will succeed, and then try
to verify the *previous* certificate, which will fail.  Thus, disaster
is narrowly averted (as far as I could tell).

Fixes: 6c2dc5ae4ab7 ("X.509: Extract signature digest and make self-signed cert checks earlier")
Cc: <stable@vger.kernel.org> # v4.7+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 39e6de0c2761..2f6a768b91d7 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -270,7 +270,7 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 				sinfo->index);
 			return 0;
 		}
-		ret = public_key_verify_signature(p->pub, p->sig);
+		ret = public_key_verify_signature(p->pub, x509->sig);
 		if (ret < 0)
 			return ret;
 		x509->signer = p;
-- 
2.16.0.rc1.238.g530d649a79-goog
