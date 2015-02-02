From: zibo zhao <chinabull@gmail.com>
Subject: [PATCH] crypto: make public_key_subtype data structure read only
Date: Sun,  1 Feb 2015 21:52:11 -0500
Message-ID: <1422845531-23895-1-git-send-email-chinabull@gmail.com>
Cc: zibo zhao <chinabull@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:64753 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbBBCwg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Feb 2015 21:52:36 -0500
Received: by mail-ig0-f173.google.com with SMTP id a13so15138265igq.0
        for <linux-crypto@vger.kernel.org>; Sun, 01 Feb 2015 18:52:35 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

During the attempt to disable the kernel module signing
verification in some android kernel, I came across that
the public_key_subtype in asymmetric_keys/public_key.c
which has following declarations:
struct asymmetric_key_subtype public_key_subtype = {
...
        .describe               = public_key_describe,
        .destroy                = public_key_destroy,
        .verify_signature       = public_key_verify_signature_2,
};

As long as I have root access and /dev/mem access available,
it seems to be quite easy to have kernel module signing
verification workarounded by just simply assign the address
of public_key_describe() to the .verify_signature data member.

This could be avoided by adding const to the data structure to
make all the data members ready only.

Signed-off-by: zibo zhao <chinabull@gmail.com>
---
 crypto/asymmetric_keys/public_key.c | 2 +-
 crypto/asymmetric_keys/public_key.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 2f6e4fb..bf921b8 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -118,7 +118,7 @@ static int public_key_verify_signature_2(const struct key *key,
 /*
  * Public key algorithm asymmetric key subtype
  */
-struct asymmetric_key_subtype public_key_subtype = {
+const struct asymmetric_key_subtype public_key_subtype = {
 	.owner			= THIS_MODULE,
 	.name			= "public_key",
 	.name_len		= sizeof("public_key") - 1,
diff --git a/crypto/asymmetric_keys/public_key.h b/crypto/asymmetric_keys/public_key.h
index 5c37a22..751f5c3 100644
--- a/crypto/asymmetric_keys/public_key.h
+++ b/crypto/asymmetric_keys/public_key.h
@@ -13,7 +13,7 @@
 
 #include <crypto/public_key.h>
 
-extern struct asymmetric_key_subtype public_key_subtype;
+extern const struct asymmetric_key_subtype public_key_subtype;
 
 /*
  * Public key algorithm definition.
-- 
1.9.1
