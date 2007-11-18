From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/4] [CRYPTO] doc: Update api-intro.txt
Date: Sun, 18 Nov 2007 21:32:00 +0800
Message-ID: <E1ItkFk-0007Ss-00@gondolin.me.apana.org.au>
References: <20071118133054.GA28619@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4578 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbXKRNcD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 08:32:03 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1ItkFk-00073T-SR
	for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2007 00:32:01 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] doc: Update api-intro.txt

This patch updates the list of transforms we support and clarifies that
the Block Ciphers interface in fact supports all ciphers including stream
ciphers.

It also removes the obsolete Configuration Notes section and adds the
linux-crypto mailing list as the primary bug reporting address.

Finally it documents the fact that setkey should only be called from
user context.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 Documentation/crypto/api-intro.txt |   41 ++++++++++++++-----------------------
 1 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/Documentation/crypto/api-intro.txt b/Documentation/crypto/api-intro.txt
index a2ac6d2..8b49302 100644
--- a/Documentation/crypto/api-intro.txt
+++ b/Documentation/crypto/api-intro.txt
@@ -33,9 +33,16 @@ The idea is to make the user interface and algorithm registration API
 very simple, while hiding the core logic from both.  Many good ideas
 from existing APIs such as Cryptoapi and Nettle have been adapted for this.
 
-The API currently supports three types of transforms: Ciphers, Digests and
-Compressors.  The compression algorithms especially seem to be performing
-very well so far.
+The API currently supports five main types of transforms: AEAD (Authenticated
+Encryption with Associated Data), Block Ciphers, Ciphers, Compressors and
+Hashes.
+
+Please note that Block Ciphers is somewhat of a misnomer.  It is in fact
+meant to support all ciphers including stream ciphers.  The difference
+between Block Ciphers and Ciphers is that the latter operates on exactly
+one block while the former can operate on an arbitrary amount of data,
+subject to block size requirements (i.e., non-stream ciphers can only
+process multiples of blocks).
 
 Support for hardware crypto devices via an asynchronous interface is
 under development.
@@ -69,29 +76,12 @@ Here's an example of how to use the API:
 Many real examples are available in the regression test module (tcrypt.c).
 
 
-CONFIGURATION NOTES
-
-As Triple DES is part of the DES module, for those using modular builds,
-add the following line to /etc/modprobe.conf:
-
-  alias des3_ede des
-
-The Null algorithms reside in the crypto_null module, so these lines
-should also be added:
-
-  alias cipher_null crypto_null
-  alias digest_null crypto_null
-  alias compress_null crypto_null
-
-The SHA384 algorithm shares code within the SHA512 module, so you'll
-also need:
-  alias sha384 sha512
-
-
 DEVELOPER NOTES
 
 Transforms may only be allocated in user context, and cryptographic
-methods may only be called from softirq and user contexts.
+methods may only be called from softirq and user contexts.  For
+transforms with a setkey method it too should only be called from
+user context.
 
 When using the API for ciphers, performance will be optimal if each
 scatterlist contains data which is a multiple of the cipher's block
@@ -130,8 +120,9 @@ might already be working on.
 BUGS
 
 Send bug reports to:
-Herbert Xu <herbert@gondor.apana.org.au>
-Cc: David S. Miller <davem@redhat.com>
+linux-crypto@vger.kernel.org
+Cc: Herbert Xu <herbert@gondor.apana.org.au>,
+    David S. Miller <davem@redhat.com>
 
 
 FURTHER INFORMATION
