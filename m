Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADB8C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 15:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CDC864F4A
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 15:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237596AbhBDPo0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 10:44:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237583AbhBDPoO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 10:44:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB7AD64F51;
        Thu,  4 Feb 2021 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612453412;
        bh=Knd66ZMj8z26HZKnCluD4hTJCYpgA55COiNsYhL+2aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5RpB5y0amAulQ4cMshw2Oo2q5k9Q0BbADggF08XSDmXR3LClBaeyk5GSMdWJX4HU
         kaKMLZoIGUG8mUvFapfy3JZaQTJ0m2Mee/wDYsmER0MBEZQQthW6Lj3E7Y2Occi405
         1nUIdSUFh350gHDqblf4WvHjtcFqRTcjkRIAB1iuedTZ3NL8jniKqlh0VfQXXxmFSj
         ei2exN43t76UVC69llwPswApJ1pleHXJB+vIx8sIFoNkd8xST5J+YNj9UEjK7P/Ls6
         EyCBKxQVUPqziRVC4TZn47yBqi9fbBzExpR71p+/59vMhA0FsLvlf0KzOGrovYs8VA
         pIi5ey4lgRDwA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        Suheil Chandran <schandran@marvell.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: marvell - fix ethernet driver dependency
Date:   Thu,  4 Feb 2021 16:42:16 +0100
Message-Id: <20210204154230.1702563-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210204154230.1702563-1-arnd@kernel.org>
References: <20210204154230.1702563-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The OcteonTX2 CPT driver force-enables the OCTEONTX2_MBOX symbol,
which fails when network drivers are disabled globally

WARNING: unmet direct dependencies detected for OCTEONTX2_MBOX
  Depends on [n]: NETDEVICES [=n] && ETHERNET [=n] && NET_VENDOR_MARVELL [=n]
  Selected by [y]:
  - CRYPTO_DEV_OCTEONTX2_CPT [=y] && CRYPTO [=y] && CRYPTO_HW [=y] && (ARM64 [=y] || COMPILE_TEST [=y]) && PCI_MSI [=y] && 64BIT [=y] && CRYPTO_LIB_AES [=y]

The crypto driver actually fails to link without the ethernet side,
so this is a hard dependency. Change the 'select' into 'depends on'
to make it build reliably without warnings.

Fixes: 5e8ce8334734 ("crypto: marvell - add Marvell OcteonTX2 CPT PF driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/marvell/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 2efbd79180ce..576d9e46fb88 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -39,9 +39,9 @@ config CRYPTO_DEV_OCTEONTX_CPT
 config CRYPTO_DEV_OCTEONTX2_CPT
 	tristate "Marvell OcteonTX2 CPT driver"
 	depends on ARM64 || COMPILE_TEST
+	depends on OCTEONTX2_MBOX
 	depends on PCI_MSI && 64BIT
 	depends on CRYPTO_LIB_AES
-	select OCTEONTX2_MBOX
 	select CRYPTO_DEV_MARVELL
 	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
-- 
2.29.2

