Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E2FC31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 21:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C7AD20861
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 21:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="JwgvZg6y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbfFQVOr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 17:14:47 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:32976 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfFQVOr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 17:14:47 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45SP9f02Ltz9v32g;
        Mon, 17 Jun 2019 23:14:46 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=JwgvZg6y; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id M44yvhiIU-Ru; Mon, 17 Jun 2019 23:14:45 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45SP9d60bkz9v32f;
        Mon, 17 Jun 2019 23:14:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560806085; bh=Bq8+e+ZHY2owo39xAffBIeXBw2Hyd+Wrg1isVQ+Tz/4=;
        h=From:Subject:To:Cc:Date:From;
        b=JwgvZg6yYXMrwAaVc3rYYA6LKcwJj5PDCtHcB2CCGaNW6zjxIDOOlTZ3XNWvglcSu
         ebHmVPgAHlL6swUETk/HEADfCadqwZWpNGG0oe7pKmDEGCdfXOVGvTIVUpyHoX0LFL
         qYU+x722wUHKBFKFqf32ndb/ce63mwAoInv5Ai9w=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0EE0B8B84B;
        Mon, 17 Jun 2019 23:14:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id EeGksXHfm0Z2; Mon, 17 Jun 2019 23:14:45 +0200 (CEST)
Received: from po16838vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D32A98B7FF;
        Mon, 17 Jun 2019 23:14:45 +0200 (CEST)
Received: by localhost.localdomain (Postfix, from userid 0)
        id 7D40C682B3; Mon, 17 Jun 2019 21:14:45 +0000 (UTC)
Message-Id: <2cb226d8a3e4876ff3d66c32aa4de9c0008b6cb8.1560805489.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH] crypto: talitos - eliminate unneeded 'done' functions at
 build time
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Mon, 17 Jun 2019 21:14:45 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When building for SEC1 only, talitos2_done functions are unneeded
and should go away.

For this, use has_ftr_sec1() which will always return true when only
SEC1 support is being built, allowing GCC to drop TALITOS2 functions.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
---
 taken out of the "Additional fixes on Talitos driver" series as it can be applied independently

 drivers/crypto/talitos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 3b3e99f1cddb..b0ddf2e19e7f 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3414,7 +3414,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	if (err)
 		goto err_out;
 
-	if (of_device_is_compatible(np, "fsl,sec1.0")) {
+	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
 			tasklet_init(&priv->done_task[0], talitos1_done_ch0,
 				     (unsigned long)dev);
-- 
2.13.3

