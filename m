From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] CRC32C: crc32c module soft dependency
Date: Mon, 10 Feb 2014 12:17:12 -0800
Message-ID: <1392063432.27116.10.camel@schen9-DESK>
References: <1390505720.3138.77.camel@schen9-DESK>
	 <20140209011616.GA16905@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38718 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486AbaBJURb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Feb 2014 15:17:31 -0500
In-Reply-To: <20140209011616.GA16905@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2014-02-09 at 09:16 +0800, Herbert Xu wrote:
> On Thu, Jan 23, 2014 at 11:35:20AM -0800, Tim Chen wrote:
> > Herbert,
> > 
> > It seems like we haven't folded in changes for adding
> > soft dependency to crc32c to ensure that the accelerated
> > version is loaded when available.
> > 
> > I take a crack with the patch below.
> 
> Thanks for the patch Tim.  We should also rename it to crc32c_generic
> while we're at it.

How about the following version.  Thanks.

Tim

--->o---

>From 5fa1b1ae614577c6e3c1acf02447f81d2d7a66dd Mon Sep 17 00:00:00 2001
From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Thu, 23 Jan 2014 03:25:47 -0800
Subject: [PATCH] CRC32C: Add soft module dependency to load other accelerated
 crc32c modules
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org

We added the soft module dependency of crc32c module alias
to generic crc32c module so other hardware accelerated crc32c
modules could get loaded and used before the generic version.
We also renamed the crypto/crc32c.c containing the generic
crc32c crypto computation to crypto/crc32c_generic.c according
to convention.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/Makefile                       | 2 +-
 crypto/{crc32c.c => crc32c_generic.c} | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)
 rename crypto/{crc32c.c => crc32c_generic.c} (98%)

diff --git a/crypto/Makefile b/crypto/Makefile
index b29402a..38e64231 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -81,7 +81,7 @@ obj-$(CONFIG_CRYPTO_SALSA20) += salsa20_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_ZLIB) += zlib.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
-obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
+obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
 obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_common.o crct10dif_generic.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
diff --git a/crypto/crc32c.c b/crypto/crc32c_generic.c
similarity index 98%
rename from crypto/crc32c.c
rename to crypto/crc32c_generic.c
index 06f7018..d9c7beb 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c_generic.c
@@ -170,3 +170,5 @@ module_exit(crc32c_mod_fini);
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations wrapper for lib/crc32c");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("crc32c");
+MODULE_SOFTDEP("pre: crc32c");
-- 
1.7.11.7
