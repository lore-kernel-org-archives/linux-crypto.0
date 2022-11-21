Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4414C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Nov 2022 17:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiKURXg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Nov 2022 12:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiKURXL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2022 12:23:11 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F11B12AFB
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 09:22:54 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oxAVM-0006BK-Ke; Mon, 21 Nov 2022 18:22:48 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oxAVF-005hJG-NB; Mon, 21 Nov 2022 18:22:42 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oxAVF-000coT-Tf; Mon, 21 Nov 2022 18:22:41 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Gaosheng Cui <cuigaosheng1@huawei.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] crypto: ccree - Make cc_debugfs_global_fini() available for module init function
Date:   Mon, 21 Nov 2022 18:22:36 +0100
Message-Id: <20221121172236.114438-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1076; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=6RWoSe9WYi2FqQcm+WxERMmr+hQomFQz0YQ5v/qzrq4=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBje7PZfEmQrMx3TfD0vupku+gArlBngxg10VTpVbTk 2UWUZ9mJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY3uz2QAKCRDB/BR4rcrsCVPvCA CX4cYSQc+mzvap0UaTA77iqBvjYw15uCz9iV6IvcT+31616O02/fFMFDuuCDQRRePTZ6JfbOO8wEbF RAvAisByLGCj67iYXGzZ6vRqsqbGzwUti9EewSj/h5MeAc7dNvQcMj1t3dJkq+Ibk0ZJGAaDkaoql6 9pbIG1otKTBNq5D5Uw7r5iXS4d2CK7y6AJzOIa8ocJyynoxDAxAUw4dpkgLuLmrglfhhUgd4MCKmra Dlme3MHT7Q4Zv64aE+j6oHa2lj+medeS3n1kSmpuVDZvJauQMl6C6BGtfmljgQNTYkz8hUZwlrExF0 XnEEOmI/rwsycLSmlgEhFqdYNIffEV
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ccree_init() calls cc_debugfs_global_fini(), the former is an init
function and the latter an exit function though.

A modular build emits:

	WARNING: modpost: drivers/crypto/ccree/ccree.o: section mismatch in reference: init_module (section: .init.text) -> cc_debugfs_global_fini (section: .exit.text)

(with CONFIG_DEBUG_SECTION_MISMATCH=y).

Fixes: 4f1c596df706 ("crypto: ccree - Remove debugfs when platform_driver_register failed")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/ccree/cc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
index 7083767602fc..8f008f024f8f 100644
--- a/drivers/crypto/ccree/cc_debugfs.c
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -55,7 +55,7 @@ void __init cc_debugfs_global_init(void)
 	cc_debugfs_dir = debugfs_create_dir("ccree", NULL);
 }
 
-void __exit cc_debugfs_global_fini(void)
+void cc_debugfs_global_fini(void)
 {
 	debugfs_remove(cc_debugfs_dir);
 }
-- 
2.38.1

