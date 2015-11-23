From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH] crypto: Docs blurb about templates.
Date: Mon, 23 Nov 2015 11:07:02 +0100
Message-ID: <1448273222-9914-1-git-send-email-andrew.zaborowski@intel.com>
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34610 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbbKWKHQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Nov 2015 05:07:16 -0500
Received: by wmvv187 with SMTP id v187so152596648wmv.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2015 02:07:15 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
These are some notes about the template structs that can take some
head-scratching to figure out from the code.  Please check that this is
the current intended use.
---
 Documentation/crypto/api-intro.txt | 40 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/crypto/api-intro.txt b/Documentation/crypto/api-intro.txt
index 8b49302..39b5caa 100644
--- a/Documentation/crypto/api-intro.txt
+++ b/Documentation/crypto/api-intro.txt
@@ -117,6 +117,46 @@ Also check the TODO list at the web site listed below to see what people
 might already be working on.
 
 
+TEMPLATE ALGORITHMS
+
+Templates dynamically create algorithms based on algorithm names passed
+as parameters.  In most cases they modify how another algorithm works by
+wrapping around an instance of the other algorithm and operating on its
+inputs, outputs, and/or the keys.  They can call the child transform's
+operations in an arbitrary order.  The template can convert one algorithm
+type to another and may also combine multiple instances of one or
+multiple algorithms.
+
+The following additional types are used with templates:
+
+* struct crypto_template
+  Describes the template and has methods to create actual algorithms as
+  crypto_instance structures.  These are not instances of algorithms
+  (transforms), instances of the template are algorithms.  The template
+  does not appear in /proc/crypto but the algorithms do.  The struct
+  crypto_template does not statically determine the resulting crypto
+  types.
+
+* struct crypto_instance
+  Represents an instance of a template.  Its first member is the
+  "struct crypto_alg alg" which is a dynamically created algorithm that
+  behaves like any other.  The structure also points back to the template
+  used.  The crypto type-specific methods and other algorithm context is
+  prepended to struct crypto_instance in a way that it's also prepended
+  to the .alg member.  The children algorithm(s) used by the template
+  instance are pointed to by the crypto_spawn structure(s) normally
+  appended after the crypto_instance.
+
+  Actual transforms are created when the context is allocated and .init_tfm
+  is called same as with non-template algorithms, but the .init_tfm
+  function will need to trigger creation of child transform(s) from the
+  crypto_spawn structure(s).
+
+* struct crypto_spawn
+  Links a template algorithm (crypto_instance) and a reference to one child
+  algorithm.
+
+
 BUGS
 
 Send bug reports to:
-- 
2.1.4
