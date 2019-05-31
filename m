Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B42C28CC2
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 11:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 099D526875
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 11:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfEaLzL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 07:55:11 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:35767 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfEaLzL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 07:55:11 -0400
Received: from orion.localdomain ([77.7.63.28]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1McY4R-1h0eIJ3kSb-00czVP; Fri, 31 May 2019 13:54:59 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     axboe@kernel.dk, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 3/3] drivers: crypto: picoxcell_crypto: use MODULE_OF_TABLE()
Date:   Fri, 31 May 2019 13:54:50 +0200
Message-Id: <1559303690-8108-4-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559303690-8108-1-git-send-email-info@metux.net>
References: <1559303690-8108-1-git-send-email-info@metux.net>
X-Provags-ID: V03:K1:Z6c1otDiTNvUfwOuHqha8BpkR4bhVZXrx+Nd5UJ+38AdPk5i7a6
 Uf8PqxlaEioT72Dzl8OTgXnweMyPE/u+7DiXRbdc1EiAG81trgGasXM6LB7+GxmjkObJ7eC
 xSdAnLMrH0YzzrpBUhLAu57HOb+byTpj5GJPis7uw3Xm/RGAUmL47VwLag3XKWEWYBRt9m1
 /K/RJ1AY48ySg7Zt1k0aQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4QTsQ4K3Qs4=:KyD82KBShjukXcY7/uboSK
 HnSHzsiycu0FBTOlte7XmZVIU+Rb3Q3ROWHSnBUUjijhPTxeo6brqaowNwQ4up2syGXbMkvdF
 H7HKhNBPtZ/5/GGTpOQ/sVxUlWP8wdtWp3hsmoqajioL/c/cw9tXq+Waq4hk1wQC/cvtxAal8
 cojlrcfWG+z0dUL5vJozsXi+cwTdrYGkp5OvzRtoaLyPLRP4Ni05Gp8Mf/ZXIHoKt/1aet/by
 16+F7SSpUFK3tB+fqqYjIMW5JSHulOwhVxfflU09daSkczy3F1fcy8lhkmX2kMPP1XS/ZNE4H
 huFttf4kYuoiIh2nPHjH2ZjuvGA+cKYrfP3ryt5NGM8O4RGpj1ZEW876A09QlRK+/bopYfFtV
 q65i0S1bxAYMhwyeX1tn8PgJB68yJ+7W+ftE2NOdHjTyJfLx1ctLFPI+jsT/DOL8gAXclVBN2
 xeCh2bHjqAv67QYdlbTMm1Yk6wPMg36BLVyxUC7iFxZnZNyULjt1JkqorIORNT4I1j0kgwF3w
 6xIosKoEfxGgPXkAYzTpVS4TH8UcqGW2q68wMTLsFOKkDAqP0NkDtkjKsxAJDqfQl/BLrcVk7
 1WuJSXMjE9xosBd8YedmyZZ2Foby84DrKZqxUYY5kTIrBJ55fSmnRz+9DKm5M4RCQwec6Alde
 lv4M2S3HXQiPSNOdJmCmw+K0006Vk0GbhiQfB+44V/RtRG4jf5L/ExxR1WtqgtgOKoY9EjUzD
 2GZXXVr0BnFR0/0cD8JaexS7f87TCPIZUYFTfw==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using MODULE_OF_TABLE() macro to get rid of some #ifdef
CONFIG_OF and thus make the code a bit slimmer.

These macros already check whether CONFIG_OF is set and if it's
not, just no-op. The compiler then should be able to optimize-
away unreferenced structs.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 drivers/crypto/picoxcell_crypto.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 05b89e7..e637f6f 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1625,14 +1625,12 @@ static DEVICE_ATTR(stat_irq_thresh, 0644, spacc_stat_irq_thresh_show,
 	},
 };
 
-#ifdef CONFIG_OF
 static const struct of_device_id spacc_of_id_table[] = {
 	{ .compatible = "picochip,spacc-ipsec" },
 	{ .compatible = "picochip,spacc-l2" },
 	{}
 };
-MODULE_DEVICE_TABLE(of, spacc_of_id_table);
-#endif /* CONFIG_OF */
+MODULE_OF_TABLE(spacc_of_id_table);
 
 static int spacc_probe(struct platform_device *pdev)
 {
-- 
1.9.1

