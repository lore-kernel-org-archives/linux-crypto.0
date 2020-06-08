Return-Path: <SRS0=xc0K=7W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B265C433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jun 2020 00:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05CAE20737
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jun 2020 00:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591660805;
	bh=yKkzUylOknIwecsv8r1l0CYmrdBOv5/1gOFSrHKSh6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bX2YS29CEv06Ld5Zmqr86bkhlZgfZ0JJYq0Y+38RQLc+mtdtIsZb652f2jZBvQ/Qg
	 /+ziYye0qTAetQABSiqJG4DMGFMT+ZI90OEf/DYKhzPwBa0Se3Pb3JPMu6G9qPhJiO
	 /0ReW4H7PemlT5ArV+jl0tjMOWIqoY/J4wFfsPMA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgFHX7w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jun 2020 19:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731360AbgFHXWn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0454E2072F;
        Mon,  8 Jun 2020 23:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658563;
        bh=yKkzUylOknIwecsv8r1l0CYmrdBOv5/1gOFSrHKSh6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9UDFavuNbrBdLPPhUN75J9gco6ObsPjUcn31GslbH18hnXG9vjQ5KU8+c7B5HwMF
         7EkeXPGBppo1/SRDF7sLj/R6qSv6dFYN7E704Nb+76V+yHOMvTVrnWFf7jJOlH1W1R
         mB/uO6xF4+83EP/eGNlt8+vXucOoxfTP5GAdRJBw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 004/106] crypto: ccp -- don't "select" CONFIG_DMADEVICES
Date:   Mon,  8 Jun 2020 19:20:56 -0400
Message-Id: <20200608232238.3368589-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
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
index b9dfae47aefd..7f5fc705503d 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -9,10 +9,9 @@ config CRYPTO_DEV_CCP_DD
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

