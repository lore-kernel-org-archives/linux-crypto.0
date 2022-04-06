Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C623C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 17:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbiDFREV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbiDFREC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 13:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B12490FFA
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 07:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64ABB619BF
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 14:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64EAC385A3;
        Wed,  6 Apr 2022 14:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255245;
        bh=9ACSIxSqAOiR/DBYbDGfE1IBJTvqVYFmb2NFi/alMqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVDIuY9WD8D/oz3HmaaIV28h2HfUEAmQQmz8R0z+r0MPxNkwmdIoZpM42ClZWF/F8
         tcYssnnPnOLUWRCwneEj8I/3oeFSQ8XLZAHY3I3xZYBpwZK74NJFVzk8EQScphqhr1
         lnxbXSYcsGnPoAb/y5bS2VCFS+48Lp7cvySvpbhl4yJKT2PjsWYc3U/GcBbx3udji8
         xDjIfH9xnT+9m7m/6GY/+m27Q5zBkS5WiTGPvhUqKpRalC2R1nUU/VtuxEADWUJ52f
         ViRjMOms2nnJZbM6Y2gp3oYg65YpVfUUp9tPTLVIxChw0u/BdtHWJul3C7aAKLvZNf
         VqIMFHRLQeNyA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/8] crypto: add flag for algos that need DMA aligned context buffers
Date:   Wed,  6 Apr 2022 16:27:08 +0200
Message-Id: <20220406142715.2270256-2-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406142715.2270256-1-ardb@kernel.org>
References: <20220406142715.2270256-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1464; h=from:subject; bh=9ACSIxSqAOiR/DBYbDGfE1IBJTvqVYFmb2NFi/alMqA=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiTaM3OzTjBGhpBJh1MftlN1sJ3GUHAYiIFEE5j6WW OuV5Ic2JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYk2jNwAKCRDDTyI5ktmPJELXC/ oDq7t+Je2fBkhksPgtE4/qngfLsI/uoTGq+qRcw98NkTWXpYMbSIeZ5K9kV46+nZLRqOf8T0DL6xUM dO+IgCF4/GtoGKkXh1GOe+rnfj4kuEmZ1OSdZfmB/8yu1nSjbKqC40txzM/iBRN6GhbwE4nLMllp39 Ygk6AoaBe9ci85LI4Lh1Nj6pgeFBqDpIhGCsM4NhkWqFzokAbgvcc9wNoh2ivF9e3UoZsU8ApNJk62 YQXOJl98LNw9Ak6FznHL3ZpzCD5TN2Zh26LRnItfWYPxYCXDhgLeDg18PETTgZtxmajMpR2T8/S6is dTOxZSUAEOSm8cZw7+bV4BuxSUbQW2SkK9QTLOBnBpa8VWMzDRHLeFyq/MaD3+xnxim6BH30TVe9zO tjSX1lMIejjVPk6UxvkHOF2hjL3MlJ6VzUif+niK2eJmN9XIVCUcseia0pCHPKWEB6F63VpUFVvfr6 h3is68J+MeMqp8FGPTHdWvv6mh++M/nYJvBdWvO44nsUA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On architectures that support non-coherent DMA, we align and round up
all dynamically allocated request and TFM structures to the worst case
DMA alignment, which is 128 bytes on arm64, even though most systems
only have 64 byte cachelines, are cache coherent for DMA, don't use
use accelerators for crypto, or the driver for the accelerator does not
DMA into the request context buffer to begin with.

We can relax this requirement, by only performing this rounding for
algorithms that are backed by an implementation that actually requires
it. So introduce CRYPTO_ALG_NEED_DMA_ALIGNMENT for this purpose, which
will be wired up in subsequent patches.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/crypto.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 2324ab6f1846..f2e95fb6cedb 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -100,6 +100,13 @@
  */
 #define CRYPTO_NOLOAD			0x00008000
 
+/*
+ * Whether context buffers require DMA alignment. This is the case for
+ * drivers that perform non-coherent inbound DMA on the context buffer
+ * directly, but should not be needed otherwise.
+ */
+#define CRYPTO_ALG_NEED_DMA_ALIGNMENT	0x00010000
+
 /*
  * The algorithm may allocate memory during request processing, i.e. during
  * encryption, decryption, or hashing.  Users can request an algorithm with this
-- 
2.30.2

