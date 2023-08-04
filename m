Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4ADC001DB
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 09:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjHDJZw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 05:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjHDJZV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 05:25:21 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981D54EE0;
        Fri,  4 Aug 2023 02:24:39 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qRr2w-003bIX-M2; Fri, 04 Aug 2023 17:24:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Aug 2023 17:24:34 +0800
Date:   Fri, 4 Aug 2023 17:24:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH] crypto: lib - Move mpi into lib/crypto
Message-ID: <ZMzD0q52dbeXNeaM@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As lib/mpi is mostly used by crypto code, move it under lib/crypto
so that patches touching it get directed to the right mailing list.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/Makefile b/lib/Makefile
index 42d307ade225..1f5235478259 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -253,7 +253,6 @@ obj-$(CONFIG_DQL) += dynamic_queue_limits.o
 obj-$(CONFIG_GLOB) += glob.o
 obj-$(CONFIG_GLOB_SELFTEST) += globtest.o
 
-obj-$(CONFIG_MPILIB) += mpi/
 obj-$(CONFIG_DIMLIB) += dim/
 obj-$(CONFIG_SIGNATURE) += digsig.o
 
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 6ec2d4543d9c..8d1446c2be71 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -53,3 +53,5 @@ libblake2s-y					+= blake2s-selftest.o
 libchacha20poly1305-y				+= chacha20poly1305-selftest.o
 libcurve25519-y					+= curve25519-selftest.o
 endif
+
+obj-$(CONFIG_MPILIB) += mpi/
diff --git a/lib/mpi/Makefile b/lib/crypto/mpi/Makefile
similarity index 100%
rename from lib/mpi/Makefile
rename to lib/crypto/mpi/Makefile
diff --git a/lib/mpi/ec.c b/lib/crypto/mpi/ec.c
similarity index 100%
rename from lib/mpi/ec.c
rename to lib/crypto/mpi/ec.c
diff --git a/lib/mpi/generic_mpih-add1.c b/lib/crypto/mpi/generic_mpih-add1.c
similarity index 100%
rename from lib/mpi/generic_mpih-add1.c
rename to lib/crypto/mpi/generic_mpih-add1.c
diff --git a/lib/mpi/generic_mpih-lshift.c b/lib/crypto/mpi/generic_mpih-lshift.c
similarity index 100%
rename from lib/mpi/generic_mpih-lshift.c
rename to lib/crypto/mpi/generic_mpih-lshift.c
diff --git a/lib/mpi/generic_mpih-mul1.c b/lib/crypto/mpi/generic_mpih-mul1.c
similarity index 100%
rename from lib/mpi/generic_mpih-mul1.c
rename to lib/crypto/mpi/generic_mpih-mul1.c
diff --git a/lib/mpi/generic_mpih-mul2.c b/lib/crypto/mpi/generic_mpih-mul2.c
similarity index 100%
rename from lib/mpi/generic_mpih-mul2.c
rename to lib/crypto/mpi/generic_mpih-mul2.c
diff --git a/lib/mpi/generic_mpih-mul3.c b/lib/crypto/mpi/generic_mpih-mul3.c
similarity index 100%
rename from lib/mpi/generic_mpih-mul3.c
rename to lib/crypto/mpi/generic_mpih-mul3.c
diff --git a/lib/mpi/generic_mpih-rshift.c b/lib/crypto/mpi/generic_mpih-rshift.c
similarity index 100%
rename from lib/mpi/generic_mpih-rshift.c
rename to lib/crypto/mpi/generic_mpih-rshift.c
diff --git a/lib/mpi/generic_mpih-sub1.c b/lib/crypto/mpi/generic_mpih-sub1.c
similarity index 100%
rename from lib/mpi/generic_mpih-sub1.c
rename to lib/crypto/mpi/generic_mpih-sub1.c
diff --git a/lib/mpi/longlong.h b/lib/crypto/mpi/longlong.h
similarity index 100%
rename from lib/mpi/longlong.h
rename to lib/crypto/mpi/longlong.h
diff --git a/lib/mpi/mpi-add.c b/lib/crypto/mpi/mpi-add.c
similarity index 100%
rename from lib/mpi/mpi-add.c
rename to lib/crypto/mpi/mpi-add.c
diff --git a/lib/mpi/mpi-bit.c b/lib/crypto/mpi/mpi-bit.c
similarity index 100%
rename from lib/mpi/mpi-bit.c
rename to lib/crypto/mpi/mpi-bit.c
diff --git a/lib/mpi/mpi-cmp.c b/lib/crypto/mpi/mpi-cmp.c
similarity index 100%
rename from lib/mpi/mpi-cmp.c
rename to lib/crypto/mpi/mpi-cmp.c
diff --git a/lib/mpi/mpi-div.c b/lib/crypto/mpi/mpi-div.c
similarity index 100%
rename from lib/mpi/mpi-div.c
rename to lib/crypto/mpi/mpi-div.c
diff --git a/lib/mpi/mpi-inline.h b/lib/crypto/mpi/mpi-inline.h
similarity index 100%
rename from lib/mpi/mpi-inline.h
rename to lib/crypto/mpi/mpi-inline.h
diff --git a/lib/mpi/mpi-internal.h b/lib/crypto/mpi/mpi-internal.h
similarity index 100%
rename from lib/mpi/mpi-internal.h
rename to lib/crypto/mpi/mpi-internal.h
diff --git a/lib/mpi/mpi-inv.c b/lib/crypto/mpi/mpi-inv.c
similarity index 100%
rename from lib/mpi/mpi-inv.c
rename to lib/crypto/mpi/mpi-inv.c
diff --git a/lib/mpi/mpi-mod.c b/lib/crypto/mpi/mpi-mod.c
similarity index 100%
rename from lib/mpi/mpi-mod.c
rename to lib/crypto/mpi/mpi-mod.c
diff --git a/lib/mpi/mpi-mul.c b/lib/crypto/mpi/mpi-mul.c
similarity index 100%
rename from lib/mpi/mpi-mul.c
rename to lib/crypto/mpi/mpi-mul.c
diff --git a/lib/mpi/mpi-pow.c b/lib/crypto/mpi/mpi-pow.c
similarity index 100%
rename from lib/mpi/mpi-pow.c
rename to lib/crypto/mpi/mpi-pow.c
diff --git a/lib/mpi/mpi-sub-ui.c b/lib/crypto/mpi/mpi-sub-ui.c
similarity index 100%
rename from lib/mpi/mpi-sub-ui.c
rename to lib/crypto/mpi/mpi-sub-ui.c
diff --git a/lib/mpi/mpicoder.c b/lib/crypto/mpi/mpicoder.c
similarity index 100%
rename from lib/mpi/mpicoder.c
rename to lib/crypto/mpi/mpicoder.c
diff --git a/lib/mpi/mpih-cmp.c b/lib/crypto/mpi/mpih-cmp.c
similarity index 100%
rename from lib/mpi/mpih-cmp.c
rename to lib/crypto/mpi/mpih-cmp.c
diff --git a/lib/mpi/mpih-div.c b/lib/crypto/mpi/mpih-div.c
similarity index 100%
rename from lib/mpi/mpih-div.c
rename to lib/crypto/mpi/mpih-div.c
diff --git a/lib/mpi/mpih-mul.c b/lib/crypto/mpi/mpih-mul.c
similarity index 100%
rename from lib/mpi/mpih-mul.c
rename to lib/crypto/mpi/mpih-mul.c
diff --git a/lib/mpi/mpiutil.c b/lib/crypto/mpi/mpiutil.c
similarity index 100%
rename from lib/mpi/mpiutil.c
rename to lib/crypto/mpi/mpiutil.c
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
