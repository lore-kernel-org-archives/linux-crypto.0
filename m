From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 0/5] hwrng: amd: rework of the amd hwrng driver
Date: Thu, 25 Aug 2016 14:16:30 +0200
Message-ID: <1472127395-32195-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Changes since v1:
 - Keep the hwrng name as "amd"

LABBE Corentin (5):
  hwrng: amd: Fix style problem with blank line
  hwrng: amd: use the BIT macro
  hwrng: amd: Be consitent with the driver name
  hwrng: amd: Remove asm/io.h
  hwrng: amd: Rework of the amd768-hwrng driver

 drivers/char/hw_random/amd-rng.c | 173 ++++++++++++++++++++++++---------------
 1 file changed, 107 insertions(+), 66 deletions(-)

-- 
2.7.3
