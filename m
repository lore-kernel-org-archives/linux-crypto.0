Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8973DC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 04:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B1D421872
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 04:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="xUMLAesL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfAYEED (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 23:04:03 -0500
Received: from condef-03.nifty.com ([202.248.20.68]:45251 "EHLO
        condef-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfAYEED (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 23:04:03 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2019 23:04:01 EST
Received: from conuserg-07.nifty.com ([10.126.8.70])by condef-03.nifty.com with ESMTP id x0P3ofj8010465
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jan 2019 12:50:41 +0900
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id x0P3nm2q008098;
        Fri, 25 Jan 2019 12:49:49 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com x0P3nm2q008098
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1548388189;
        bh=7Hvixn4R6rXU1nhVDqmVbi8Imwg4x0RJAUaKJwgwJEs=;
        h=From:To:Cc:Subject:Date:From;
        b=xUMLAesLK22fVkWqMXs3F/P+iQ7O4JKqLYu1RUPyGV9Ub8lAzLreNGzWgU8a/yvLe
         phyFQIgFE3t8xDiDKWCXbgYWe/UO+SIu7Z+pKBu2zyUK8Jpmgrxv/T3RJfloF0UQs6
         ad4SGtqsd5fchOz9SxYj4H3pO/UGDARbxKdFdvfhxOKJICdVVJxVdsCd1FyxLvHmfG
         KlhH2MbCmKx9OQs2xpYJMayBD8jbM6Ol7awFOSKgCAmBI5I8shj87wytLiNlt1NfWb
         d16gBEUlLN0LDgQPe6BSCRH3vOx5yTl0X2iWAMSw75vl0J9cS8mcT1TU2NCo5shMu3
         auPpdqQzdP0XQ==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Harsh Jain <harsh@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: prefix header search paths with $(srctree)/
Date:   Fri, 25 Jan 2019 12:49:36 +0900
Message-Id: <1548388176-11325-1-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, the Kbuild core manipulates header search paths in a crazy
way [1].

To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
the search paths in the srctree. Some Makefiles are already written in
that way, but not all. The goal of this work is to make the notation
consistent, and finally get rid of the gross hacks.

Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
("kbuild: do not drop -I without parameter").

[1]: https://patchwork.kernel.org/patch/9632347/

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/crypto/chelsio/Makefile            | 2 +-
 drivers/crypto/chelsio/chtls/Makefile      | 3 ++-
 drivers/crypto/qat/qat_c3xxx/Makefile      | 2 +-
 drivers/crypto/qat/qat_c3xxxvf/Makefile    | 2 +-
 drivers/crypto/qat/qat_c62x/Makefile       | 2 +-
 drivers/crypto/qat/qat_c62xvf/Makefile     | 2 +-
 drivers/crypto/qat/qat_dh895xcc/Makefile   | 2 +-
 drivers/crypto/qat/qat_dh895xccvf/Makefile | 2 +-
 8 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/chelsio/Makefile b/drivers/crypto/chelsio/Makefile
index 639e571..b7bd980 100644
--- a/drivers/crypto/chelsio/Makefile
+++ b/drivers/crypto/chelsio/Makefile
@@ -1,4 +1,4 @@
-ccflags-y := -Idrivers/net/ethernet/chelsio/cxgb4
+ccflags-y := -I $(srctree)/drivers/net/ethernet/chelsio/cxgb4
 
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chcr.o
 chcr-objs :=  chcr_core.o chcr_algo.o
diff --git a/drivers/crypto/chelsio/chtls/Makefile b/drivers/crypto/chelsio/chtls/Makefile
index df13795..b958f1b 100644
--- a/drivers/crypto/chelsio/chtls/Makefile
+++ b/drivers/crypto/chelsio/chtls/Makefile
@@ -1,4 +1,5 @@
-ccflags-y := -Idrivers/net/ethernet/chelsio/cxgb4 -Idrivers/crypto/chelsio/
+ccflags-y := -I $(srctree)/drivers/net/ethernet/chelsio/cxgb4 \
+	     -I $(srctree)/drivers/crypto/chelsio
 
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO_TLS) += chtls.o
 chtls-objs := chtls_main.o chtls_cm.o chtls_io.o chtls_hw.o
diff --git a/drivers/crypto/qat/qat_c3xxx/Makefile b/drivers/crypto/qat/qat_c3xxx/Makefile
index 8f5fd48..822b5de 100644
--- a/drivers/crypto/qat/qat_c3xxx/Makefile
+++ b/drivers/crypto/qat/qat_c3xxx/Makefile
@@ -1,3 +1,3 @@
-ccflags-y := -I$(src)/../qat_common
+ccflags-y := -I $(srctree)/$(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C3XXX) += qat_c3xxx.o
 qat_c3xxx-objs := adf_drv.o adf_c3xxx_hw_data.o
diff --git a/drivers/crypto/qat/qat_c3xxxvf/Makefile b/drivers/crypto/qat/qat_c3xxxvf/Makefile
index 16d178e..8f56d27 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/Makefile
+++ b/drivers/crypto/qat/qat_c3xxxvf/Makefile
@@ -1,3 +1,3 @@
-ccflags-y := -I$(src)/../qat_common
+ccflags-y := -I $(srctree)/$(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C3XXXVF) += qat_c3xxxvf.o
 qat_c3xxxvf-objs := adf_drv.o adf_c3xxxvf_hw_data.o
diff --git a/drivers/crypto/qat/qat_c62x/Makefile b/drivers/crypto/qat/qat_c62x/Makefile
index bd75ace..6dcd404 100644
--- a/drivers/crypto/qat/qat_c62x/Makefile
+++ b/drivers/crypto/qat/qat_c62x/Makefile
@@ -1,3 +1,3 @@
-ccflags-y := -I$(src)/../qat_common
+ccflags-y := -I $(srctree)/$(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C62X) += qat_c62x.o
 qat_c62x-objs := adf_drv.o adf_c62x_hw_data.o
diff --git a/drivers/crypto/qat/qat_c62xvf/Makefile b/drivers/crypto/qat/qat_c62xvf/Makefile
index ecd708c..1e5d51d 100644
--- a/drivers/crypto/qat/qat_c62xvf/Makefile
+++ b/drivers/crypto/qat/qat_c62xvf/Makefile
@@ -1,3 +1,3 @@
-ccflags-y := -I$(src)/../qat_common
+ccflags-y := -I $(srctree)/$(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C62XVF) += qat_c62xvf.o
 qat_c62xvf-objs := adf_drv.o adf_c62xvf_hw_data.o
diff --git a/drivers/crypto/qat/qat_dh895xcc/Makefile b/drivers/crypto/qat/qat_dh895xcc/Makefile
index 180a00e..0fc06b1 100644
--- a/drivers/crypto/qat/qat_dh895xcc/Makefile
+++ b/drivers/crypto/qat/qat_dh895xcc/Makefile
@@ -1,3 +1,3 @@
-ccflags-y := -I$(src)/../qat_common
+ccflags-y := -I $(srctree)/$(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCC) += qat_dh895xcc.o
 qat_dh895xcc-objs := adf_drv.o adf_dh895xcc_hw_data.o
diff --git a/drivers/crypto/qat/qat_dh895xccvf/Makefile b/drivers/crypto/qat/qat_dh895xccvf/Makefile
index 5c3ccf8..9ce906a 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/Makefile
+++ b/drivers/crypto/qat/qat_dh895xccvf/Makefile
@@ -1,3 +1,3 @@
-ccflags-y := -I$(src)/../qat_common
+ccflags-y := -I $(srctree)/$(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCCVF) += qat_dh895xccvf.o
 qat_dh895xccvf-objs := adf_drv.o adf_dh895xccvf_hw_data.o
-- 
2.7.4

