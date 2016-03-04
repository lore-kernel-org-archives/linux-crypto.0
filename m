From: Andreas Ziegler <andreas.ziegler@fau.de>
Subject: [PATCH] security: integrity: Remove select to deleted option PUBLIC_KEY_ALGO_RSA
Date: Fri,  4 Mar 2016 19:00:06 +0100
Message-ID: <1457114406-29804-1-git-send-email-andreas.ziegler@fau.de>
References: <18370.1457105029@warthog.procyon.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
	David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Valentin Rothberg <valentinrothberg@gmail.com>,
	Andreas Ziegler <andreas.ziegler@fau.de>
To: James Morris <james.l.morris@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18370.1457105029@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Commit d43de6c780a8 ("akcipher: Move the RSA DER encoding check to
the crypto layer") removed the Kconfig option PUBLIC_KEY_ALGO_RSA,
but forgot to remove a 'select' to this option in the definition of
INTEGRITY_ASYMMETRIC_KEYS.

Let's remove the select, as it's ineffective now.

Signed-off-by: Andreas Ziegler <andreas.ziegler@fau.de>
---
 security/integrity/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 979be65..da95658 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -35,7 +35,6 @@ config INTEGRITY_ASYMMETRIC_KEYS
 	default n
         select ASYMMETRIC_KEY_TYPE
         select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
-        select PUBLIC_KEY_ALGO_RSA
         select CRYPTO_RSA
         select X509_CERTIFICATE_PARSER
 	help
-- 
1.9.1
