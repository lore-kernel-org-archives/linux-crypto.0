From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: doc - fix documentation for bulk registration functions
Date: Wed, 17 Aug 2016 15:47:11 -0700
Message-ID: <1471474031-87352-1-git-send-email-ebiggers@google.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@google.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Update the documentation for crypto_register_algs() and
crypto_unregister_algs() to match the actual behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/DocBook/crypto-API.tmpl | 38 ++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index fb2a152..088b79c 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -797,7 +797,8 @@ kernel crypto API            |       Caller
      include/linux/crypto.h and their definition can be seen below.
      The former function registers a single transformation, while
      the latter works on an array of transformation descriptions.
-     The latter is useful when registering transformations in bulk.
+     The latter is useful when registering transformations in bulk,
+     for example when a driver implements multiple transformations.
     </para>
 
     <programlisting>
@@ -822,18 +823,31 @@ kernel crypto API            |       Caller
     </para>
 
     <para>
-     The bulk registration / unregistration functions require
-     that struct crypto_alg is an array of count size. These
-     functions simply loop over that array and register /
-     unregister each individual algorithm. If an error occurs,
-     the loop is terminated at the offending algorithm definition.
-     That means, the algorithms prior to the offending algorithm
-     are successfully registered. Note, the caller has no way of
-     knowing which cipher implementations have successfully
-     registered. If this is important to know, the caller should
-     loop through the different implementations using the single
-     instance *_alg functions for each individual implementation.
+     The bulk registration/unregistration functions
+     register/unregister each transformation in the given array of
+     length count.  They handle errors as follows:
     </para>
+    <itemizedlist>
+     <listitem>
+      <para>
+       crypto_register_algs() succeeds if and only if it
+       successfully registers all the given transformations. If an
+       error occurs partway through, then it rolls back successful
+       registrations before returning the error code. Note that if
+       a driver needs to handle registration errors for individual
+       transformations, then it will need to use the non-bulk
+       function crypto_register_alg() instead.
+      </para>
+     </listitem>
+     <listitem>
+      <para>
+       crypto_unregister_algs() tries to unregister all the given
+       transformations, continuing on error. It logs errors and
+       always returns zero.
+      </para>
+     </listitem>
+    </itemizedlist>
+
    </sect1>
 
    <sect1><title>Single-Block Symmetric Ciphers [CIPHER]</title>
-- 
2.8.0.rc3.226.g39d4020

