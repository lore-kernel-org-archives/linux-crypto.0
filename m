From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/4] crypto: crypto_user - fix sparse warnings (symbol was not
 declared, should be static?)
Date: Tue, 28 Aug 2012 16:46:54 +0300
Message-ID: <20120828134654.7113.67137.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:47601 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab2H1Nq5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Aug 2012 09:46:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix "symbol 'x' was not declared. Should it be static?" sparse warnings.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/crypto_user.c |    2 +-
 crypto/vmac.c        |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index ba2c611..b590471 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -30,7 +30,7 @@
 
 #include "internal.h"
 
-DEFINE_MUTEX(crypto_cfg_mutex);
+static DEFINE_MUTEX(crypto_cfg_mutex);
 
 /* The crypto netlink socket */
 static struct sock *crypto_nlsk;
diff --git a/crypto/vmac.c b/crypto/vmac.c
index 4243905..f2338ca9 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -38,11 +38,11 @@
  * Constants and masks
  */
 #define UINT64_C(x) x##ULL
-const u64 p64   = UINT64_C(0xfffffffffffffeff);  /* 2^64 - 257 prime  */
-const u64 m62   = UINT64_C(0x3fffffffffffffff);  /* 62-bit mask       */
-const u64 m63   = UINT64_C(0x7fffffffffffffff);  /* 63-bit mask       */
-const u64 m64   = UINT64_C(0xffffffffffffffff);  /* 64-bit mask       */
-const u64 mpoly = UINT64_C(0x1fffffff1fffffff);  /* Poly key mask     */
+static const u64 p64   = UINT64_C(0xfffffffffffffeff);	/* 2^64 - 257 prime  */
+static const u64 m62   = UINT64_C(0x3fffffffffffffff);	/* 62-bit mask       */
+static const u64 m63   = UINT64_C(0x7fffffffffffffff);	/* 63-bit mask       */
+static const u64 m64   = UINT64_C(0xffffffffffffffff);	/* 64-bit mask       */
+static const u64 mpoly = UINT64_C(0x1fffffff1fffffff);	/* Poly key mask     */
 
 #define pe64_to_cpup le64_to_cpup		/* Prefer little endian */
 
