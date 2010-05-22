From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 05/12] crypto: omap: remove unused #include <linux/version.h>
Date: Sun, 23 May 2010 01:12:15 +0800
Message-ID: <1274548335-2656-1-git-send-email-weiyi.huang@gmail.com>
Cc: linux-crypto@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39406 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab0EVRMU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 22 May 2010 13:12:20 -0400
Received: by mail-pw0-f46.google.com with SMTP id 5so874903pwi.19
        for <linux-crypto@vger.kernel.org>; Sat, 22 May 2010 10:12:19 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove unused #include <linux/version.h>('s) in
  drivers/crypto/omap-sham.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/crypto/omap-sham.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 8b03433..7d14856 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -15,7 +15,6 @@
 
 #define pr_fmt(fmt) "%s: " fmt, __func__
 
-#include <linux/version.h>
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/module.h>
-- 
1.6.1.3
