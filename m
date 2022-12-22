Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD4BC4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Dec 2022 16:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiLVQZb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Dec 2022 11:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiLVQZ3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2022 11:25:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25253248E9
        for <linux-crypto@vger.kernel.org>; Thu, 22 Dec 2022 08:25:28 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1p8ONm-00068N-SX; Thu, 22 Dec 2022 17:25:22 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1p8ONj-0012y7-UN; Thu, 22 Dec 2022 17:25:19 +0100
Received: from ukl by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1p8ONj-00GsId-4k; Thu, 22 Dec 2022 17:25:19 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] crypto: caam - Prevent fortify error
Date:   Thu, 22 Dec 2022 17:25:13 +0100
Message-Id: <20221222162513.4021928-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When compiling arm64 allmodconfig  with gcc 10.2.1 I get

	drivers/crypto/caam/desc_constr.h: In function ‘append_data.constprop’:
	include/linux/fortify-string.h:57:29: error: argument 2 null where non-null expected [-Werror=nonnull]

Fix this by skipping the memcpy if data is NULL and add a BUG_ON instead
that triggers on a problematic call that is now prevented to trigger.
After data == NULL && len != 0 is known to be false, logically

	if (len)
		memcpy(...)

could be enough to know that memcpy is not called with dest=NULL, but
gcc doesn't seem smart enough for that conclusion. gcc 12 doesn't have a
problem with the original code.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/caam/desc_constr.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 62ce6421bb3f..163e0e740b11 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -163,7 +163,13 @@ static inline void append_data(u32 * const desc, const void *data, int len)
 {
 	u32 *offset = desc_end(desc);
 
-	if (len) /* avoid sparse warning: memcpy with byte count of 0 */
+	/*
+	 * avoid sparse warning: "memcpy with byte count of 0" and
+	 * and "error: argument 2 null where non-null expected
+	 * [-Werror=nonnull]" with fortify enabled.
+	 */
+	BUG_ON(data == NULL && len != 0);
+	if (len && data)
 		memcpy(offset, data, len);
 
 	(*desc) = cpu_to_caam32(caam32_to_cpu(*desc) +

base-commit: 9d2f6060fe4c3b49d0cdc1dce1c99296f33379c8
-- 
2.30.2

