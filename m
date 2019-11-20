Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755DDC432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 11:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B1382243F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 11:27:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="bW6nm99p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbfKTL1t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 06:27:49 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:37915 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbfKTL1t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 06:27:49 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 47J0mL5x9bz9sPf; Wed, 20 Nov 2019 22:27:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1574249266;
        bh=Jduwe2SsdV67P5EeS5nGje6t3g/X5IPOQjA2coFz4+k=;
        h=From:To:Cc:Subject:Date:From;
        b=bW6nm99pIXRpwMDjMFq17gWi5zmu6Zwvz91wjIUjb63592//GMMaCZWsipe1xu1y6
         1lgtRyEPDCmoSsyDB/SGlAlV90jzaO2fBrokmEZHNSOxemoSyGVldvLvJXz6t7Bl+G
         qJqXwdm/IrdDvjyAsUFsUpbx/gvYkhIe6hi//HDHX/+UknJEs9p3kHLDxEoCdqoXQU
         tOhM9gWgwiw5xNjov9Yxe9eWQLu2+PX514DYqDGlx+4N1bAx+t/eRa9Bu/xT7eEx1e
         ZDN32qYHi2TszuyXhyj65YgZAgMyrHnnI1HsNn4gZf63TguP1pm+1r1Nj5ODE0QIEx
         QUa44QqHSJVBA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     linuxppc-dev@ozlabs.org, yamada.masahiro@socionext.com
Subject: [PATCH] crypto: vmx - Avoid weird build failures
Date:   Wed, 20 Nov 2019 22:27:38 +1100
Message-Id: <20191120112738.7031-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the vmx crypto Makefile we assign to a variable called TARGET and
pass that to the aesp8-ppc.pl and ghashp8-ppc.pl scripts.

The variable is meant to describe what flavour of powerpc we're
building for, eg. either 32 or 64-bit, and big or little endian.

Unfortunately TARGET is a fairly common name for a make variable, and
if it happens that TARGET is specified as a command line parameter to
make, the value specified on the command line will override our value.

In particular this can happen if the kernel Makefile is driven by an
external Makefile that uses TARGET for something.

This leads to weird build failures, eg:
  nonsense  at /build/linux/drivers/crypto/vmx/ghashp8-ppc.pl line 45.
  /linux/drivers/crypto/vmx/Makefile:20: recipe for target 'drivers/crypto/vmx/ghashp8-ppc.S' failed

Which shows that we passed an empty value for $(TARGET) to the perl
script, confirmed with make V=1:

  perl /linux/drivers/crypto/vmx/ghashp8-ppc.pl  > drivers/crypto/vmx/ghashp8-ppc.S

We can avoid this confusion by using override, to tell make that we
don't want anything to override our variable, even a value specified
on the command line. We can also use a less common name, given the
script calls it "flavour", let's use that.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/crypto/vmx/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
index cab32cfec9c4..709670d2b553 100644
--- a/drivers/crypto/vmx/Makefile
+++ b/drivers/crypto/vmx/Makefile
@@ -3,13 +3,13 @@ obj-$(CONFIG_CRYPTO_DEV_VMX_ENCRYPT) += vmx-crypto.o
 vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o aes_xts.o ghash.o
 
 ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
-TARGET := linux-ppc64le
+override flavour := linux-ppc64le
 else
-TARGET := linux-ppc64
+override flavour := linux-ppc64
 endif
 
 quiet_cmd_perl = PERL $@
-      cmd_perl = $(PERL) $(<) $(TARGET) > $(@)
+      cmd_perl = $(PERL) $(<) $(flavour) > $(@)
 
 targets += aesp8-ppc.S ghashp8-ppc.S
 
-- 
2.21.0

