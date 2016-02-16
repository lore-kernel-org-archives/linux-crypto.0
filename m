From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 2/4] Documentation: crypto - add crypto_rng_generate
Date: Tue, 16 Feb 2016 11:32:34 +0100
Message-ID: <3596491.s7jozHvv2z@positron.chronox.de>
References: <1550901.OUzcZboqul@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1550901.OUzcZboqul@positron.chronox.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add new crypto API call crypto_rng_generate to DocBook.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/DocBook/crypto-API.tmpl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index 297e280..a2986b2 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -1815,6 +1815,7 @@ read(opfd, out, outlen);
 !Finclude/crypto/rng.h crypto_alloc_rng
 !Finclude/crypto/rng.h crypto_rng_alg
 !Finclude/crypto/rng.h crypto_free_rng
+!Finclude/crypto/rng.h crypto_rng_generate
 !Finclude/crypto/rng.h crypto_rng_get_bytes
 !Finclude/crypto/rng.h crypto_rng_reset
 !Finclude/crypto/rng.h crypto_rng_seedsize
-- 
2.5.0


