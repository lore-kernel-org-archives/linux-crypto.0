Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3983C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 15:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442644AbiEFPSZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 11:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347956AbiEFPSY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 11:18:24 -0400
Received: from condef-07.nifty.com (condef-07.nifty.com [202.248.20.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC6B6D1AF
        for <linux-crypto@vger.kernel.org>; Fri,  6 May 2022 08:14:41 -0700 (PDT)
Received: from conuserg-07.nifty.com ([10.126.8.70])by condef-07.nifty.com with ESMTP id 246FC0Fm004105
        for <linux-crypto@vger.kernel.org>; Sat, 7 May 2022 00:12:00 +0900
Received: from grover.sesame (133-32-177-133.west.xps.vectant.ne.jp [133.32.177.133]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id 246F8tNF028085;
        Sat, 7 May 2022 00:08:55 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com 246F8tNF028085
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1651849736;
        bh=VWu6RNovZZlWzjVI82T26ZkYKFtgzo8H7rKhNuRBvqE=;
        h=From:To:Cc:Subject:Date:From;
        b=JjukZl1ajjnROurCI7d4tVD2V+auAAoaTV8eCoq4+DaujU3yMVuUEyuyr6LwWj0L3
         JWLl97Veyic5o1T/O+yEvgIbnvD2oJ53WvLFTekEPE2XGlzuuwxIbV475fhVzZUTXb
         9vLIZRPiAdYKUjzvkJReF1rlOeVZMxRfyRAF8MDhq9pS5gdoENYbaH2VnIlFS3dfVe
         +cJXIXolT3MfRNa6j+tnmjv1arylMYNLmbAsql7Cq51Q/lNrwbg//b+CWaVLXATVox
         aveENEtZzaDGhZeLMdoGW21mQ/qpWaTPmycNecnftbuY+/21XlrCkT0zIcFshfJR8j
         CPEHCRkuH/Ilg==
X-Nifty-SrcIP: [133.32.177.133]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2] crypto: vmx - Align the short log with Makefile cleanups
Date:   Sat,  7 May 2022 00:08:20 +0900
Message-Id: <20220506150820.1310802-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I notieced the log is not properly aligned:

  PERL drivers/crypto/vmx/aesp8-ppc.S
  CC [M]  fs/xfs/xfs_reflink.o
  PERL drivers/crypto/vmx/ghashp8-ppc.S
  CC [M]  drivers/crypto/vmx/aes.o

Add some spaces after 'PERL'.

While I was here, I cleaned up the Makefile:

 - Merge the two similar rules

 - Remove redundant 'clean-files' (Having 'targets' is enough)

 - Move the flavour into the build command

This still avoids the build failures fixed by commit 4ee812f6143d
("crypto: vmx - Avoid weird build failures").

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

Changes in v2:
  - Fix CONFIG_LITTLE_ENDIAN -> CONFIG_CPU_LITTLE_ENDIAN

 drivers/crypto/vmx/Makefile | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
index 709670d2b553..2560cfea1dec 100644
--- a/drivers/crypto/vmx/Makefile
+++ b/drivers/crypto/vmx/Makefile
@@ -2,21 +2,10 @@
 obj-$(CONFIG_CRYPTO_DEV_VMX_ENCRYPT) += vmx-crypto.o
 vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o aes_xts.o ghash.o
 
-ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
-override flavour := linux-ppc64le
-else
-override flavour := linux-ppc64
-endif
-
-quiet_cmd_perl = PERL $@
-      cmd_perl = $(PERL) $(<) $(flavour) > $(@)
+quiet_cmd_perl = PERL    $@
+      cmd_perl = $(PERL) $< $(if $(CONFIG_CPU_LITTLE_ENDIAN), linux-ppc64le, linux-ppc64) > $@
 
 targets += aesp8-ppc.S ghashp8-ppc.S
 
-$(obj)/aesp8-ppc.S: $(src)/aesp8-ppc.pl FORCE
-	$(call if_changed,perl)
-  
-$(obj)/ghashp8-ppc.S: $(src)/ghashp8-ppc.pl FORCE
+$(obj)/aesp8-ppc.S $(obj)/ghashp8-ppc.S: $(obj)/%.S: $(src)/%.pl FORCE
 	$(call if_changed,perl)
-
-clean-files := aesp8-ppc.S ghashp8-ppc.S
-- 
2.32.0

