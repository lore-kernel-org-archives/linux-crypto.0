Return-Path: <SRS0=VXLt=PD=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:49000 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbeLZRXu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Dec 2018 12:23:50 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 779F5788
        for <linux-crypto@vger.kernel.org>; Wed, 26 Dec 2018 17:23:48 +0000 (UTC)
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rnI8TnUsfE5y for <linux-crypto@vger.kernel.org>;
        Wed, 26 Dec 2018 11:23:48 -0600 (CST)
Received: from mail-it1-f198.google.com (mail-it1-f198.google.com [209.85.166.198])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 51EC524E
        for <linux-crypto@vger.kernel.org>; Wed, 26 Dec 2018 11:23:48 -0600 (CST)
Received: by mail-it1-f198.google.com with SMTP id v3so19045287itf.4
        for <linux-crypto@vger.kernel.org>; Wed, 26 Dec 2018 09:23:48 -0800 (PST)
From: Aditya Pakki <pakki001@umn.edu>
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Buesch <m@bues.ch>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] char: hw_random: Fix missing check during driver release
Date: Wed, 26 Dec 2018 11:23:31 -0600
Message-Id: <20181226172332.6365-1-pakki001@umn.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

devres_release can return -ENOENT if the device is not freed. The fix
throws a warning consistent with other invocations.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/char/hw_random/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 95be7228f327..582d983fa93f 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -578,7 +578,11 @@ EXPORT_SYMBOL_GPL(devm_hwrng_register);
 
 void devm_hwrng_unregister(struct device *dev, struct hwrng *rng)
 {
-	devres_release(dev, devm_hwrng_release, devm_hwrng_match, rng);
+	int rc;
+
+	rc = devres_release(dev, devm_hwrng_release, devm_hwrng_match, rng);
+	if (rc)
+		WARN_ON(rc);
 }
 EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
 
-- 
2.17.1
