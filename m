Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728213AbfAJUSW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:22 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH 02/11] crypto: rsa-pkcs1pad - include <crypto/internal/rsa.h>
Date: Thu, 10 Jan 2019 12:17:53 -0800
Message-Id: <20190110201802.82442-3-ebiggers@kernel.org>
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Include internal/rsa.h in rsa-pkcs1pad.c to get the declaration of
rsa_pkcs1pad_tmpl.  This fixes the following sparse warning:

    crypto/rsa-pkcs1pad.c:698:24: warning: symbol 'rsa_pkcs1pad_tmpl' was not declared. Should it be static?

Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/rsa-pkcs1pad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index cfc04e15fd975..0a6680ca8cb6f 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -12,6 +12,7 @@
 #include <crypto/algapi.h>
 #include <crypto/akcipher.h>
 #include <crypto/internal/akcipher.h>
+#include <crypto/internal/rsa.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-- 
2.20.1.97.g81188d93c3-goog
