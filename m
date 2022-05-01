Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA4DC433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  1 May 2022 13:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbiEANZH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 May 2022 09:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236165AbiEANZG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 May 2022 09:25:06 -0400
X-Greylist: delayed 310 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 01 May 2022 06:21:41 PDT
Received: from condef-09.nifty.com (condef-09.nifty.com [202.248.20.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2303F3CFCF
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 06:21:40 -0700 (PDT)
Received: from conuserg-11.nifty.com ([10.126.8.74])by condef-09.nifty.com with ESMTP id 241DDAp6024990
        for <linux-crypto@vger.kernel.org>; Sun, 1 May 2022 22:13:11 +0900
Received: from grover.sesame (133-32-177-133.west.xps.vectant.ne.jp [133.32.177.133]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id 241D8TQo018740;
        Sun, 1 May 2022 22:08:29 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 241D8TQo018740
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1651410510;
        bh=Fmg4C09ULmcdlCQ7G/HgMU42/2hgN/vUJbg9dyGBwP0=;
        h=From:To:Cc:Subject:Date:From;
        b=Bzc3Aykk50p2V+GC4ErxY+Z5DdBiuLZXJeYATq47uk3XNLduZCcHy0cApl2Rrsb9Z
         CXMDw/soW0HsPCFCwa8GWL5e93ozm7jDX/hGrSknNNjIF7Z975qTs2Cvik18XZ12+s
         rL6O5+ayjD57b/4oHob1wJSaqVi2SbUA/1uL2G7Cmz9Y0AzNWOYdzmv/UZDrUnKmjz
         EAfTdWXzzsjj5hnLzzpLEyTgtw+5vD0BsUG9R9ulxtxzyn4YETcwmRHGLHmYl7iCpm
         xpKmmdkLE7vWgJ2DOjeQT0ltGvmCPG02PnqfzJiSmfe2fZNlvdyNBU8TCABp3cS4Yp
         vvjdHKKtaJ9hQ==
X-Nifty-SrcIP: [133.32.177.133]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] crypto: vmx - Align the short log with Makefile cleanups
Date:   Sun,  1 May 2022 22:07:49 +0900
Message-Id: <20220501130749.1123387-1-masahiroy@kernel.org>
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

 drivers/crypto/vmx/Makefile | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
index 709670d2b553..df93ba63b1cd 100644
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
+      cmd_perl = $(PERL) $< $(if $(CONFIG_LITTLE_ENDIAN), linux-ppc64le, linux-ppc64) > $@
 
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

