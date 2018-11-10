Return-Path: <SRS0=6FdY=NV=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:48763 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeKKAhf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Nov 2018 19:37:35 -0500
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Eric Anholt <eric@anholt.net>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-rpi-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 03/17] hw_random: bcm2835-rng: Switch to SPDX identifier
Date: Sat, 10 Nov 2018 15:51:16 +0100
Message-Id: <1541861476-6778-1-git-send-email-stefan.wahren@i2se.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adopt the SPDX license identifier headers to ease license compliance
management. While we are at this fix the comment style, too.

Cc: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 6767d96..256b0b1 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -1,10 +1,7 @@
-/**
+// SPDX-License-Identifier: GPL-2.0
+/*
  * Copyright (c) 2010-2012 Broadcom. All rights reserved.
  * Copyright (c) 2013 Lubomir Rintel
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License ("GPL")
- * version 2, as published by the Free Software Foundation.
  */
 
 #include <linux/hw_random.h>
-- 
2.7.4
