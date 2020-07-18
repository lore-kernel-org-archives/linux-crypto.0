Return-Path: <SRS0=nnFP=A5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A105C433DF
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Jul 2020 10:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E36932073A
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Jul 2020 10:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgGRKkM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Jul 2020 06:40:12 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:39270 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgGRKkM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Jul 2020 06:40:12 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 3D570BC064;
        Sat, 18 Jul 2020 10:40:05 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        corbet@lwn.net, herbert@gondor.apana.org.au, davem@davemloft.net,
        leitao@debian.org, nayna@linux.ibm.com, pfsmorigo@gmail.com,
        grandmaster@al2klimov.de, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH] powerpc: Replace HTTP links with HTTPS ones
Date:   Sat, 18 Jul 2020 12:39:58 +0200
Message-Id: <20200718103958.5455-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spamd-Bar: /
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.


 Documentation/powerpc/mpc52xx.rst       | 2 +-
 arch/powerpc/crypto/crc32-vpmsum_core.S | 2 +-
 arch/powerpc/include/asm/hydra.h        | 2 +-
 drivers/crypto/vmx/aesp8-ppc.pl         | 2 +-
 drivers/crypto/vmx/ghashp8-ppc.pl       | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/powerpc/mpc52xx.rst b/Documentation/powerpc/mpc52xx.rst
index 8676ac63e077..30260707c3fe 100644
--- a/Documentation/powerpc/mpc52xx.rst
+++ b/Documentation/powerpc/mpc52xx.rst
@@ -2,7 +2,7 @@
 Linux 2.6.x on MPC52xx family
 =============================
 
-For the latest info, go to http://www.246tNt.com/mpc52xx/
+For the latest info, go to https://www.246tNt.com/mpc52xx/
 
 To compile/use :
 
diff --git a/arch/powerpc/crypto/crc32-vpmsum_core.S b/arch/powerpc/crypto/crc32-vpmsum_core.S
index c3524eba4d0d..a16a717c809c 100644
--- a/arch/powerpc/crypto/crc32-vpmsum_core.S
+++ b/arch/powerpc/crypto/crc32-vpmsum_core.S
@@ -19,7 +19,7 @@
  * We then use fixed point Barrett reduction to compute a mod n over GF(2)
  * for n = CRC using POWER8 instructions. We use x = 32.
  *
- * http://en.wikipedia.org/wiki/Barrett_reduction
+ * https://en.wikipedia.org/wiki/Barrett_reduction
  *
  * Copyright (C) 2015 Anton Blanchard <anton@au.ibm.com>, IBM
 */
diff --git a/arch/powerpc/include/asm/hydra.h b/arch/powerpc/include/asm/hydra.h
index b3b0f2d020f0..ae02eb53d6ef 100644
--- a/arch/powerpc/include/asm/hydra.h
+++ b/arch/powerpc/include/asm/hydra.h
@@ -10,7 +10,7 @@
  *
  *	© Copyright 1995 Apple Computer, Inc. All rights reserved.
  *
- *  It's available online from http://www.cpu.lu/~mlan/ftp/MacTech.pdf
+ *  It's available online from https://www.cpu.lu/~mlan/ftp/MacTech.pdf
  *  You can obtain paper copies of this book from computer bookstores or by
  *  writing Morgan Kaufmann Publishers, Inc., 340 Pine Street, Sixth Floor, San
  *  Francisco, CA 94104. Reference ISBN 1-55860-393-X.
diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
index db874367b602..50a0a18f35da 100644
--- a/drivers/crypto/vmx/aesp8-ppc.pl
+++ b/drivers/crypto/vmx/aesp8-ppc.pl
@@ -50,7 +50,7 @@
 # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
 # project. The module is, however, dual licensed under OpenSSL and
 # CRYPTOGAMS licenses depending on where you obtain it. For further
-# details see http://www.openssl.org/~appro/cryptogams/.
+# details see https://www.openssl.org/~appro/cryptogams/.
 # ====================================================================
 #
 # This module implements support for AES instructions as per PowerISA
diff --git a/drivers/crypto/vmx/ghashp8-ppc.pl b/drivers/crypto/vmx/ghashp8-ppc.pl
index 38b06503ede0..09bba1852eec 100644
--- a/drivers/crypto/vmx/ghashp8-ppc.pl
+++ b/drivers/crypto/vmx/ghashp8-ppc.pl
@@ -13,7 +13,7 @@
 # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
 # project. The module is, however, dual licensed under OpenSSL and
 # CRYPTOGAMS licenses depending on where you obtain it. For further
-# details see http://www.openssl.org/~appro/cryptogams/.
+# details see https://www.openssl.org/~appro/cryptogams/.
 # ====================================================================
 #
 # GHASH for for PowerISA v2.07.
-- 
2.27.0

