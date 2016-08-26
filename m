From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 0/8] hwrng: amd: rework of the amd hwrng driver
Date: Fri, 26 Aug 2016 13:11:28 +0200
Message-ID: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33751 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbcHZLLv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2016 07:11:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes since v2:
 - split the latest patch in 4
Changes since v1:
 - Keep the hwrng name as "amd"

LABBE Corentin (8):
  hwrng: amd: Fix style problem with blank line
  hwrng: amd: use the BIT macro
  hwrng: amd: Be consitent with the driver name
  hwrng: amd: Remove asm/io.h
  hwrng: amd: release_region must be called after hwrng_unregister
  hwrng: amd: Replace global variable with private struct
  hwrng: amd: Access hardware via ioread32/iowrite32
  hwrng: amd: Convert to new hwrng read() API

 drivers/char/hw_random/amd-rng.c | 150 +++++++++++++++++++++++++--------------
 1 file changed, 96 insertions(+), 54 deletions(-)

-- 
2.7.3
