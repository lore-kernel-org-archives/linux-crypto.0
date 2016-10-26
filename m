From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [cryptodev:master 41/47] ERROR: "crypto_acomp_scomp_free_ctx"
 [crypto/acompress.ko] undefined!
Date: Wed, 26 Oct 2016 10:56:45 +0100
Message-ID: <20161026095645.GA27004@SILVIXA00369791-F22-1>
References: <201610260803.GIBxWXo3%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9426 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754139AbcJZKAT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 06:00:19 -0400
Content-Disposition: inline
In-Reply-To: <201610260803.GIBxWXo3%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Wed, Oct 26, 2016 at 08:47:16AM +0800, kbuild test robot wrote:
> >> ERROR: "crypto_acomp_scomp_free_ctx" [crypto/acompress.ko] undefined!
> >> ERROR: "crypto_acomp_scomp_alloc_ctx" [crypto/acompress.ko] undefined!
> >> ERROR: "crypto_init_scomp_ops_async" [crypto/acompress.ko] undefined!

Thanks for the report. There is a problem with a dependency between
acomp and scomp. This patch should fix the issue.

Giovanni
---8<---
Subject: [PATCH] crypto: acomp - fix dependency in Makefile

Fix dependency between acomp and scomp that appears when acomp is
built as module

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 5c83f3d..82ffeee 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -50,8 +50,9 @@ rsa_generic-y += rsa_helper.o
 rsa_generic-y += rsa-pkcs1pad.o
 obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o

-obj-$(CONFIG_CRYPTO_ACOMP2) += acompress.o
-obj-$(CONFIG_CRYPTO_ACOMP2) += scompress.o
+crypto_acompress-y := acompress.o
+crypto_acompress-y += scompress.o
+obj-$(CONFIG_CRYPTO_ACOMP2) += crypto_acompress.o

 cryptomgr-y := algboss.o testmgr.o

--
