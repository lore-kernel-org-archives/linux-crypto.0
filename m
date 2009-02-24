From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH] crypto: Fix dead links.
Date: Tue, 24 Feb 2009 23:22:26 +0100
Message-ID: <1235514146-7554-1-git-send-email-ken@codelabs.ch>
References: <1235506239.2501.46.camel@localhost>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: joe@perches.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.codelabs.ch ([217.150.249.120]:41421 "EHLO
	fenrir.codelabs.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbZBXWhd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2009 17:37:33 -0500
In-Reply-To: <1235506239.2501.46.camel@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/gf128mul.c       |    2 +-
 crypto/sha256_generic.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index ecbeaa1..a90d260 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2006, Rik Snel <rsnel@cube.dyndns.org>
  *
  * Based on Dr Brian Gladman's (GPL'd) work published at
- * http://fp.gladman.plus.com/cryptography_technology/index.htm
+ * http://gladman.plushost.co.uk/oldsite/cryptography_technology/index.php
  * See the original copyright notice below.
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index caa3542..6349d83 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -2,7 +2,7 @@
  * Cryptographic API.
  *
  * SHA-256, as specified in
- * http://csrc.nist.gov/cryptval/shs/sha256-384-512.pdf
+ * http://csrc.nist.gov/groups/STM/cavp/documents/shs/sha256-384-512.pdf
  *
  * SHA-256 code by Jean-Luc Cooke <jlcooke@certainkey.com>.
  *
-- 
1.5.4.3

