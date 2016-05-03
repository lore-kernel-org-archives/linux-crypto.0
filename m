From: David Howells <dhowells@redhat.com>
Subject: Re: v4.6-rc1 regression bisected, Problem loading in-kernel X.509 certificate (-2)
Date: Tue, 03 May 2016 10:10:13 +0100
Message-ID: <26795.1462266613@warthog.procyon.org.uk>
References: <20160430083248.GA20775@cucamonga.audible.transient.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jamie Heilman <jamie@audible.transient.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160430083248.GA20775@cucamonga.audible.transient.net>
Content-ID: <26794.1462266613.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> Problem loading in-kernel X.509 certificate (-2)

ENOENT?  Hmmm...  The only place that is generated is in the crypto layer.
That suggests missing crypto of some sort.

The attached patch enables some debugging in some relevant files if you can
try applying it to your kernel.

David
---
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 50be2a15e531..573b3960867b 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -8,7 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the Licence, or (at your option) any later version.
  */
-
+#define DEBUG
 #define pr_fmt(fmt) "PKCS7: "fmt
 #include <linux/kernel.h>
 #include <linux/export.h>
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 0f8b264b3961..99f297129381 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -10,7 +10,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the Licence, or (at your option) any later version.
  */
-
+#define DEBUG
 #define pr_fmt(fmt) "PKEY: "fmt
 #include <linux/module.h>
 #include <linux/export.h>
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 733c046aacc6..373d472022ef 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -8,7 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the Licence, or (at your option) any later version.
  */
-
+#define DEBUG
 #define pr_fmt(fmt) "X.509: "fmt
 #include <linux/module.h>
 #include <linux/kernel.h>
