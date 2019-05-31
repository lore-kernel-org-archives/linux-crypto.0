Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624DFC04AB6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 11:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B3C026875
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 11:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfEaLzL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 07:55:11 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:53637 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbfEaLzL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 07:55:11 -0400
Received: from orion.localdomain ([77.7.63.28]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MFKCV-1hLQmx2HX7-00Fnq7; Fri, 31 May 2019 13:54:58 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     axboe@kernel.dk, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 2/3] drivers: block: xsysace: use MODULE_OF_TABLE() and of_match_ptr()
Date:   Fri, 31 May 2019 13:54:49 +0200
Message-Id: <1559303690-8108-3-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559303690-8108-1-git-send-email-info@metux.net>
References: <1559303690-8108-1-git-send-email-info@metux.net>
X-Provags-ID: V03:K1:D2txiZ08lZTasONYZwAW9/SDAd0hMmlUXLshcp0223K5r7Keezl
 kkAGpS/A7R/+w0T36OnlGTztprsvEX4WC5b1RrPJOuszCA6jB3E2TIxyPeZANIVG8GHKGnO
 woM1JBnbLViQ9o8R5wSryvy1detRT2WTxy/Bh1vdbClBylnihWosZJCXAz5webqalg9FnzY
 eK8mo66hFpB78b1bkl+YQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:cya3aVD2p+k=:8rD8iK6n7Qb6JsqgQsrHxU
 cQJDEHyQmeCRRk16HeBrbJIP4CR8n+7PWyMXDuNag6CwHNUnroAa7T0olaRAAnpm+nOoXPJA+
 OivUuojFkgkwdH8saV9vehAhW5DFXFeyiMjQe1zFQ0rthN9XUlR/+GEgyiVx+IFA/Ypmupgd8
 ydO6jDFrbkC3Q7OxooqzJ7UPikmrSvxkyqt8uRUmeE5ryJ/T9L8I3q4po7+ZgK/M4ubJqKiUh
 xYPF6a/5vWS9pBaLx3OkdNjLYM/D6ztBYVsE1X+gX8iKkTLgNtZj8uSBcx2D0rQYdzTyRvmo7
 jUQ1ABeiwNGK78H30OsYPGYqZUSJs3jd2+GkPJBWikqNrpMlsQpu1MM66E3QQImVs2U9bRJgD
 ZUJZ1QqedSslD0TSU8cl98e2/BCsgttbZ9mB+HmXL7CIps0WBgTy1khvCbd1PiZXBYX8S4NDG
 KSScomToDW6I3rb9Glm4Xu/Dr2Qqr2jNhBe5qGtgrha3GLsXS5OyENVh3eE1QMY5n9+waH3U3
 mEVqk8oGXXccqAbFbC7InmL+6EaeU4PVxOLJocbtkE4ErdIQ5tpFueQ8ftQUYUhPFpTqogIgq
 sfLlS7osrP4UJh2tRSY8SpydhH1ZTKTyFPl/o4epQYzC8E21sJ7GFGVIsfxif9BBlBPaj8myz
 YWnuPOuylRJauxmogp8CBjeBYrYuM1Bn2eUWSoIHuHBxZe2bYO9KzMgXmInvb/fYOIE0iIRLs
 smAS0Qcx9jNrlO0L5c9xcjO+JUZfuqKb+AE/Bg==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using MODULE_OF_TABLE() and of_match_ptr() macros to get rid of
some #ifdef CONFIG_OF and thus make the code a bit slimmer.

These macros already check whether CONFIG_OF is set and if it's
not, just no-op. The compiler then should be able to optimize-
away unreferenced structs.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 drivers/block/xsysace.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 464c9092..6ebd656 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1219,7 +1219,6 @@ static int ace_remove(struct platform_device *dev)
 	return 0;
 }
 
-#if defined(CONFIG_OF)
 /* Match table for of_platform binding */
 static const struct of_device_id ace_of_match[] = {
 	{ .compatible = "xlnx,opb-sysace-1.00.b", },
@@ -1228,17 +1227,14 @@ static int ace_remove(struct platform_device *dev)
 	{ .compatible = "xlnx,sysace", },
 	{},
 };
-MODULE_DEVICE_TABLE(of, ace_of_match);
-#else /* CONFIG_OF */
-#define ace_of_match NULL
-#endif /* CONFIG_OF */
+MODULE_OF_TABLE(ace_of_match);
 
 static struct platform_driver ace_platform_driver = {
 	.probe = ace_probe,
 	.remove = ace_remove,
 	.driver = {
 		.name = "xsysace",
-		.of_match_table = ace_of_match,
+		.of_match_table = of_match_ptr(ace_of_match),
 	},
 };
 
-- 
1.9.1

