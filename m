Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2A7C83F2C
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Sep 2023 20:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjIDURm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Sep 2023 16:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbjIDURl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Sep 2023 16:17:41 -0400
Received: from smtp.smtpout.orange.fr (smtp-17.smtpout.orange.fr [80.12.242.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC10CD4
        for <linux-crypto@vger.kernel.org>; Mon,  4 Sep 2023 13:17:37 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id dG0pqeKoS8SVPdG0pq4cey; Mon, 04 Sep 2023 22:17:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1693858656;
        bh=CYs6Pi9ip+Z9VKoEozhkP3TrOf4OP+Jsrs8iY7ts6Eo=;
        h=From:To:Cc:Subject:Date;
        b=GgtgJbiGZv1ULNPAttm/j2ejlI3/Q6oll65cb0wqmMwari4AaTI5Vxwlq7XXyWRn2
         6tJt9BBlwfUhvXuXHahouMwTVZk/NI40f7DorR0huRlFK81QruYm8rGaVKBo1JFfbW
         GE67WvtsvAjS8h0Yq0vgLKXrkjAB9gzVh74v4QVNqhQUl3M9lYtOh+8TaCauFj6S+J
         4qUYBI7EdZ1PWw4sn26ajCR0kBm5EjIcpK96fvq3bPEgojFMBhCGX4GCdNRgPEReFO
         AxHIEl6vHOgvPLFCP0P6+Ho7Sfp2ragATygkonB47/kIQmEQrfkL0MqcjJLFLFpufp
         Iy2/IOBVFA1sg==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 04 Sep 2023 22:17:36 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Longfang Liu <liulongfang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: hisilicon/hpre - Fix a erroneous check after snprintf()
Date:   Mon,  4 Sep 2023 22:17:29 +0200
Message-Id: <73534cb1713f58228d54ea53a8a137f4ef939bad.1693858632.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This error handling looks really strange.
Check if the string has been truncated instead.

Fixes: 02ab994635eb ("crypto: hisilicon - Fixed some tiny bugs of HPRE")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 39297ce70f44..db44d889438a 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1033,7 +1033,7 @@ static int hpre_cluster_debugfs_init(struct hisi_qm *qm)
 
 	for (i = 0; i < clusters_num; i++) {
 		ret = snprintf(buf, HPRE_DBGFS_VAL_MAX_LEN, "cluster%d", i);
-		if (ret < 0)
+		if (ret >= HPRE_DBGFS_VAL_MAX_LEN)
 			return -EINVAL;
 		tmp_d = debugfs_create_dir(buf, qm->debug.debug_root);
 
-- 
2.34.1

