From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH 1/5][CRYPTO] RIPEMD: fix Makefile entry for rmd128.o
Date: Wed,  7 May 2008 23:58:35 +0200
Message-ID: <1210197519-18432-2-git-send-email-rueegsegger@swiss-it.ch>
References: <>
 <1210197519-18432-1-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2363 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbYEGV6m (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 17:58:42 -0400
In-Reply-To: <1210197519-18432-1-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes module building for rmd128.o.
---
 crypto/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index c21b455..1efb556 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -27,7 +27,7 @@ obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o
 obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
-obj-$(CONFIG_CRYPTO_RMD160) += rmd128.o
+obj-$(CONFIG_CRYPTO_RMD128) += rmd128.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
-- 
1.5.2.5

