Return-Path: <SRS0=xc0K=7W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2519AC433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jun 2020 00:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3AA82085B
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jun 2020 00:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591661816;
	bh=1ZqBWfgeh7FOkLqgoKPI+U9m04VMyCuq7dbiqJMlu9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Vr/hLEx7gf5GmPDyl+SpA8ETqpHUP9k6ERueyxOFqSUFLV2zaHnws6rLDsHyPCtni
	 VFWSqutafxNBMkCTCmS+LdJ8QZXBYX3OI+c/bCl5FRlSuYUAnTKAsgjihjk7NbkT/I
	 zIDe3WxfjtVRmFkDZg2KxbmgYiBJZGc1sffs/g40=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbgFIAQh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730736AbgFHXTA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3AC320872;
        Mon,  8 Jun 2020 23:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658340;
        bh=1ZqBWfgeh7FOkLqgoKPI+U9m04VMyCuq7dbiqJMlu9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSo/jl9zZMj+PXdHPX9ALpvQFHBTL7j2pwLUj22wsq7g+bhxPQ9zr+0hKSZZQalUi
         sKV4Mhi1IVXmlcGq+ILwo6Ys9XQxpaHI2ixpg49HCySneMcCcIs1YCRLUU17lMfNGb
         Bs1z+khzCO3aBfBgBFoxALim9WPbnnWzy3BP2NDI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 009/175] crypto: ccp -- don't "select" CONFIG_DMADEVICES
Date:   Mon,  8 Jun 2020 19:16:02 -0400
Message-Id: <20200608231848.3366970-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit eebac678556d6927f09a992872f4464cf3aecc76 ]

DMADEVICES is the top-level option for the slave DMA
subsystem, and should not be selected by device drivers,
as this can cause circular dependencies such as:

drivers/net/ethernet/freescale/Kconfig:6:error: recursive dependency detected!
drivers/net/ethernet/freescale/Kconfig:6:	symbol NET_VENDOR_FREESCALE depends on PPC_BESTCOMM
drivers/dma/bestcomm/Kconfig:6:	symbol PPC_BESTCOMM depends on DMADEVICES
drivers/dma/Kconfig:6:	symbol DMADEVICES is selected by CRYPTO_DEV_SP_CCP
drivers/crypto/ccp/Kconfig:10:	symbol CRYPTO_DEV_SP_CCP depends on CRYPTO
crypto/Kconfig:16:	symbol CRYPTO is selected by LIBCRC32C
lib/Kconfig:222:	symbol LIBCRC32C is selected by LIQUIDIO
drivers/net/ethernet/cavium/Kconfig:65:	symbol LIQUIDIO depends on PTP_1588_CLOCK
drivers/ptp/Kconfig:8:	symbol PTP_1588_CLOCK is implied by FEC
drivers/net/ethernet/freescale/Kconfig:23:	symbol FEC depends on NET_VENDOR_FREESCALE

The LIQUIDIO driver causing this problem is addressed in a
separate patch, but this change is needed to prevent it from
happening again.

Using "depends on DMADEVICES" is what we do for all other
implementations of slave DMA controllers as well.

Fixes: b3c2fee5d66b ("crypto: ccp - Ensure all dependencies are specified")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 8fec733f567f..63e227adbb13 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -10,10 +10,9 @@ config CRYPTO_DEV_CCP_DD
 config CRYPTO_DEV_SP_CCP
 	bool "Cryptographic Coprocessor device"
 	default y
-	depends on CRYPTO_DEV_CCP_DD
+	depends on CRYPTO_DEV_CCP_DD && DMADEVICES
 	select HW_RANDOM
 	select DMA_ENGINE
-	select DMADEVICES
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	help
-- 
2.25.1

