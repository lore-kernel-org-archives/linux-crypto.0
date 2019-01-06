Return-Path: <SRS0=Z4qA=PO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:54534 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbfAFR0f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 12:26:35 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id D9784B76
        for <linux-crypto@vger.kernel.org>; Sun,  6 Jan 2019 17:26:33 +0000 (UTC)
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FQbag6Ul6bCd for <linux-crypto@vger.kernel.org>;
        Sun,  6 Jan 2019 11:26:33 -0600 (CST)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id B0B07B72
        for <linux-crypto@vger.kernel.org>; Sun,  6 Jan 2019 11:26:33 -0600 (CST)
Received: by mail-it1-f197.google.com with SMTP id k133so6365869ite.4
        for <linux-crypto@vger.kernel.org>; Sun, 06 Jan 2019 09:26:33 -0800 (PST)
From: Aditya Pakki <pakki001@umn.edu>
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Michael Buesch <m@bues.ch>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] hwrng: core: Fix missing check during driver release
Date: Sun,  6 Jan 2019 11:26:12 -0600
Message-Id: <20190106172613.10913-1-pakki001@umn.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

devres_release can return -ENOENT if the device is not freed. The fix
throws a warning consistent with other invocations.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/char/hw_random/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 95be7228f327..1b05da40626a 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -578,7 +578,8 @@ EXPORT_SYMBOL_GPL(devm_hwrng_register);
 
 void devm_hwrng_unregister(struct device *dev, struct hwrng *rng)
 {
-	devres_release(dev, devm_hwrng_release, devm_hwrng_match, rng);
+	WARN_ON(devres_release(dev, devm_hwrng_release,
+				devm_hwrng_match, rng));
 }
 EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
 
-- 
2.17.1
