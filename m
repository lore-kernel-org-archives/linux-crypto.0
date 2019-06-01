Return-Path: <SRS0=xfQ5=UA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36148C28CC3
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 13:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 109692771C
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 13:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfFANx3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Jun 2019 09:53:29 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:58567 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfFANx3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jun 2019 09:53:29 -0400
Received: from orion.localdomain ([95.114.112.19]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MIbzB-1hLIkZ45gL-00EggC; Sat, 01 Jun 2019 15:53:07 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     vireshk@kernel.org, b.zolnierkie@samsung.com, axboe@kernel.dk,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 2/4] drivers: block: xsysace: use MODULE_DECLARE_OF_TABLE() and of_match_ptr()
Date:   Sat,  1 Jun 2019 15:52:57 +0200
Message-Id: <1559397179-5833-3-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559397179-5833-1-git-send-email-info@metux.net>
References: <1559397179-5833-1-git-send-email-info@metux.net>
X-Provags-ID: V03:K1:Qws35knXlKzgk+L1gebf0oiijncZZPU9G9DE2m8RHGqmAPjbRcA
 Mhq4EwWUM8vDnhRs6XarGCNQPHg6hZyZ7kcJCkdTNrgJRZ+rUXDDMCTmXZAUMQvrMAsgDgD
 Xmbr8eVRjoviX/kCBksWZDgdHED/Yc0cP1wq0ZUPTixMb6eH0QV0J4twNfGrYthAysMDTSH
 Q1fTYPAaZFaorgEw5bxZg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:uuKrLSRJacE=:/7Ki9GCY77ZmN88TKQhAtt
 OlRRVthFBqWQJJtOLa9CHRGORp/PxILNq7x+jDsxD45M8HWtb/EHWkwRBECt/k/BVvhQB5goE
 QaXRsWqDMr87XXz9NMqtt4zM8niABNYY7txVkcDvy0mOiAuxHj3Po1z7tfkIs2z8xdVjh0d8z
 hfkAFxOsXD219fiMLJuzP+9NCvaL9wjfroU2bZmjZKG//NDuOiQWAWvpXoA4s5IQMrR2dtuJ3
 BVV0Tx6h0v3z6NFymIUK9RwqswD5U+Y1/GzaVMauszPTIk+NS2j1HrgPZBF0S5ezaeJQp8YX2
 IFMnzIeUurxUOBLq/q6/MH73k4RQuBzAYd8hxhufWNtkMC5yTW4hq1MX726KwH4PHq5INhjXt
 VBF2h8KzhM4SuGzjz5ZwTPSFOFLXskBZTZkDzA5Jzt5xT852IPa9r8DKlKdvj4VMwG6+eN8hw
 qTGp2H9U8MpJn9Npz8bwvcpWGo1t/smXEeZNgwFLHokhPt5VYFX7ltnCsEQcz+h/SjORPwV2a
 FgVCwG9YFxN10hD4m/09MX5d559OsSE+oAIVgjuv3l3TDcEsH7LS/8pjGCYdTNxzat83zhV7M
 7pMxKeEScVm2NMwNXd/r9/RAdwG96EmbzZjp5oVugHypMTiX/k8plpmwCLlgWloCsS56fQii+
 0202TEScVy8oHaWwDy7EzHwmg9Oh9S27R00vzngmJiyx9Z3/Qs3ExQSo7L9DFf7lJSdPHyHmE
 uuvuuvmgtJoiRLxpOUMqcCPdlnLmZsbKVel1qw==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using MODULE_DECLARE_OF_TABLE() and of_match_ptr() macros to get
rid of some #ifdef CONFIG_OF and thus make the code a bit slimmer.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 drivers/block/xsysace.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 464c9092..d8e5dd7 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1219,26 +1219,18 @@ static int ace_remove(struct platform_device *dev)
 	return 0;
 }
 
-#if defined(CONFIG_OF)
-/* Match table for of_platform binding */
-static const struct of_device_id ace_of_match[] = {
+MODULE_DECLARE_OF_TABLE(ace_of_match,
 	{ .compatible = "xlnx,opb-sysace-1.00.b", },
 	{ .compatible = "xlnx,opb-sysace-1.00.c", },
 	{ .compatible = "xlnx,xps-sysace-1.00.a", },
-	{ .compatible = "xlnx,sysace", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, ace_of_match);
-#else /* CONFIG_OF */
-#define ace_of_match NULL
-#endif /* CONFIG_OF */
+	{ .compatible = "xlnx,sysace", });
 
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

