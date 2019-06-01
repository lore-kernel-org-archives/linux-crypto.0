Return-Path: <SRS0=xfQ5=UA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65836C28CC1
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 13:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3829327729
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 13:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFANxa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Jun 2019 09:53:30 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54109 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfFANx3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jun 2019 09:53:29 -0400
Received: from orion.localdomain ([95.114.112.19]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MTw02-1h6Dtx1pq6-00R0rf; Sat, 01 Jun 2019 15:53:07 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     vireshk@kernel.org, b.zolnierkie@samsung.com, axboe@kernel.dk,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 3/4] drivers: crypto: picoxcell_crypto: use MODULE_DECLARE_OF_TABLE()
Date:   Sat,  1 Jun 2019 15:52:58 +0200
Message-Id: <1559397179-5833-4-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559397179-5833-1-git-send-email-info@metux.net>
References: <1559397179-5833-1-git-send-email-info@metux.net>
X-Provags-ID: V03:K1:qwswbfsbvcAggPFe5jRUevX7/A5BbeCTENYHWUVjYy9ksEyQhA9
 OxftUN0YxwjGzkm7dnhtXTUp4VGMvBnf5s5uog1bOvoNoVDeRjKjdu7UV3ggR7tWzI0551l
 BIBn0W+KoFTrEnrQZVvGHDj4GV3aOZujsZQIwmjD9tLRLjIaGjQ74hOvn/gpoLukASgwrCP
 EfVLAfcbVALxSiQBDuciQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OXM7CkWxg4A=:poWmuNctcuGgq2p8sHSagT
 YncLYj93yDEF5hQ7MYor5eLIrYS3v44+0x6m3HysZGCWoSMC9gOc1ZKxwWG4xrlyTD4GfeXik
 pifkdZ0wiGov9BdsXRlyh28txjb7ZkCAq69j0Y9wp/I40GXD/3bLDM6awSisE5alWDGEeMjks
 CgD0YzIdYNbpvtPEl3qfAvRn4JIu0Z89u+lrccoLDzIHC+Q+cgy4xY783Za2M2wi5s/lPPRwU
 GtH4tbDZFJv3z4YOtxHloeg1oN+dADDqT5+3hq4mIbEcJHI58yVOO2CnofVNlaV1+W80ES3Gn
 WPjPdv9FD1EbAiZBF6Lzo3+Xy32Ioqr1logauTJBL8RMTO43shroi0fKtIwedj5Rf4JeXxuwm
 BFayYW9PQ9Knuahc6Bzi1p7YYx5ddJFkO+/KgmV1kiOmOZAOMm32EDBXS73l2h3vgA9u9NdgZ
 yXVYYpvrIZNuigM3VvYUB560uCK0XhOb8ibNvtkGFBwX2dvHfnMpji0O1b6c0OQcwPJstus7q
 72+6qWjcLu/7LnOnniO1NQMLR6WKsMJGjbpV5NmkQzfaWx8/J6Bj6HoUCc+VmdRWt/9oJ46/O
 CvX2Gtpw4K4n0npAyc7YHASxqSIPzvE//nBE41GusxWshI3RwnTOM/7wRDwkzIx81wwZNFao9
 f3mr0CZapnBAJhlfFqe7wCQiwW8e/ppajAtRPyPH/PztxfVv39+ifnN6zm41lNguzHngvBfs8
 CS/lifrJCPXnTVqoSiyD97FNNMQF4Z+cw5reCw==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using MODULE_DECLARE_OF_TABLE() macro to get rid of some #ifdef CONFIG_OF
and make the code a bit slimmer.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 drivers/crypto/picoxcell_crypto.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index b985cb85..3c299f2 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1612,14 +1612,9 @@ static DEVICE_ATTR(stat_irq_thresh, 0644, spacc_stat_irq_thresh_show,
 	},
 };
 
-#ifdef CONFIG_OF
-static const struct of_device_id spacc_of_id_table[] = {
+MODULE_DECLARE_OF_TABLE(spacc_of_id_table,
 	{ .compatible = "picochip,spacc-ipsec" },
-	{ .compatible = "picochip,spacc-l2" },
-	{}
-};
-MODULE_DEVICE_TABLE(of, spacc_of_id_table);
-#endif /* CONFIG_OF */
+	{ .compatible = "picochip,spacc-l2" });
 
 static int spacc_probe(struct platform_device *pdev)
 {
-- 
1.9.1

