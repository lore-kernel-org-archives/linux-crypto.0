From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH] crypto: ripemd - Set module author and update email address.
Date: Sun, 26 Dec 2010 22:50:30 +0100
Message-ID: <1293400230-5705-1-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.codelabs.ch ([217.150.249.120]:54838 "EHLO
	fenrir.codelabs.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0LZV5z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 26 Dec 2010 16:57:55 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/rmd128.c |    3 ++-
 crypto/rmd160.c |    3 ++-
 crypto/rmd256.c |    3 ++-
 crypto/rmd320.c |    3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 1ceb673..8a0f68b 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -5,7 +5,7 @@
  *
  * Based on the reference implementation by Antoon Bosselaers, ESAT-COSIC
  *
- * Copyright (c) 2008 Adrian-Ken Rueegsegger <rueegsegger (at) swiss-it.ch>
+ * Copyright (c) 2008 Adrian-Ken Rueegsegger <ken@codelabs.ch>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -325,4 +325,5 @@ module_init(rmd128_mod_init);
 module_exit(rmd128_mod_fini);
 
 MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Adrian-Ken Rueegsegger <ken@codelabs.ch>");
 MODULE_DESCRIPTION("RIPEMD-128 Message Digest");
diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index 472261f..525d7bb 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -5,7 +5,7 @@
  *
  * Based on the reference implementation by Antoon Bosselaers, ESAT-COSIC
  *
- * Copyright (c) 2008 Adrian-Ken Rueegsegger <rueegsegger (at) swiss-it.ch>
+ * Copyright (c) 2008 Adrian-Ken Rueegsegger <ken@codelabs.ch>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -369,4 +369,5 @@ module_init(rmd160_mod_init);
 module_exit(rmd160_mod_fini);
 
 MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Adrian-Ken Rueegsegger <ken@codelabs.ch>");
 MODULE_DESCRIPTION("RIPEMD-160 Message Digest");
diff --git a/crypto/rmd256.c b/crypto/rmd256.c
index 72eafa8..69293d9 100644
--- a/crypto/rmd256.c
+++ b/crypto/rmd256.c
@@ -5,7 +5,7 @@
  *
  * Based on the reference implementation by Antoon Bosselaers, ESAT-COSIC
  *
- * Copyright (c) 2008 Adrian-Ken Rueegsegger <rueegsegger (at) swiss-it.ch>
+ * Copyright (c) 2008 Adrian-Ken Rueegsegger <ken@codelabs.ch>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -344,4 +344,5 @@ module_init(rmd256_mod_init);
 module_exit(rmd256_mod_fini);
 
 MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Adrian-Ken Rueegsegger <ken@codelabs.ch>");
 MODULE_DESCRIPTION("RIPEMD-256 Message Digest");
diff --git a/crypto/rmd320.c b/crypto/rmd320.c
index 86becab..09f97df 100644
--- a/crypto/rmd320.c
+++ b/crypto/rmd320.c
@@ -5,7 +5,7 @@
  *
  * Based on the reference implementation by Antoon Bosselaers, ESAT-COSIC
  *
- * Copyright (c) 2008 Adrian-Ken Rueegsegger <rueegsegger (at) swiss-it.ch>
+ * Copyright (c) 2008 Adrian-Ken Rueegsegger <ken@codelabs.ch>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -393,4 +393,5 @@ module_init(rmd320_mod_init);
 module_exit(rmd320_mod_fini);
 
 MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Adrian-Ken Rueegsegger <ken@codelabs.ch>");
 MODULE_DESCRIPTION("RIPEMD-320 Message Digest");
-- 
1.6.5
