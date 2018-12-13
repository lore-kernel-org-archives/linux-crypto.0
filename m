Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53926 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbeLMIgr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 03:36:47 -0500
Received: by mail-wm1-f67.google.com with SMTP id y1so1402616wmi.3
        for <linux-crypto@vger.kernel.org>; Thu, 13 Dec 2018 00:36:46 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 2/2] crypto: document missing stats member
Date: Thu, 13 Dec 2018 08:36:38 +0000
Message-Id: <1544690198-21993-2-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1544690198-21993-1-git-send-email-clabbe@baylibre.com>
References: <1544690198-21993-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchs adds missing member of stats documentation.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 include/linux/crypto.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 9850b41e38ae..81e178fb9ed8 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -564,6 +564,13 @@ struct crypto_istat_rng {
  * @cra_destroy: internally used
  *
  * @stats: union of all possible crypto_istat_xxx structures
+ * @stats.aead:		statistics for AEAD algorithm
+ * @stats.akcipher:	statistics for akcipher algorithm
+ * @stats.cipher:	statistics for cipher algorithm
+ * @stats.compress:	statistics for compress algorithm
+ * @stats.hash:		statistics for hash algorithm
+ * @stats.rng:		statistics for rng algorithm
+ * @stats.kpp:		statistics for KPP algorithm
  *
  * The struct crypto_alg describes a generic Crypto API algorithm and is common
  * for all of the transformations. Any variable not documented here shall not
-- 
2.19.2
