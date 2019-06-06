Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5F0C28EB3
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 11:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7645520868
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 11:31:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="wKNxZuab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfFFLbl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 07:31:41 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:57901 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbfFFLbl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 07:31:41 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45KNlt4kgyzB09ZS;
        Thu,  6 Jun 2019 13:31:38 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=wKNxZuab; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id LGvoxYt9z0Ek; Thu,  6 Jun 2019 13:31:38 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45KNlt3hh9zB09ZF;
        Thu,  6 Jun 2019 13:31:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1559820698; bh=z1F6PHZmuc1YG8A1ts1rr1gl6K/z7hQn1Ct+jqvfadg=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=wKNxZuabiknkjHFhEpNMEBBYKgYEVsqPmVlWVKH23OOngNkAMOXv/WWpirLrthAf4
         dxdL5Ni2QCUIUjzkBGvQIOWCYaej6e6GYGQIsfxPMh/cgCO8fx3vC6p6WamX+EzeFL
         caskyQmrz3JaWNqIIMh45RuODxBm43ZAfoWnKb4k=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id C28508B894;
        Thu,  6 Jun 2019 13:31:39 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id KnPu75gGijjF; Thu,  6 Jun 2019 13:31:39 +0200 (CEST)
Received: from po16838vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9677C8B891;
        Thu,  6 Jun 2019 13:31:39 +0200 (CEST)
Received: by po16838vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 74F2668CFD; Thu,  6 Jun 2019 11:31:39 +0000 (UTC)
Message-Id: <4d6b83bfa9a832229de142551cea779ddc56cf9a.1559819372.git.christophe.leroy@c-s.fr>
In-Reply-To: <cover.1559819372.git.christophe.leroy@c-s.fr>
References: <cover.1559819372.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v1 4/5] crypto: talitos - eliminate unneeded 'done' functions
 at build time
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Thu,  6 Jun 2019 11:31:39 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When building for SEC1 only, talitos2_done functions are unneeded
and should go away.

For this, use has_ftr_sec1() which will always return true when only
SEC1 support is being built, allowing GCC to drop TALITOS2 functions.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4f03baef952b..b2de931de623 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3401,7 +3401,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	if (err)
 		goto err_out;
 
-	if (of_device_is_compatible(np, "fsl,sec1.0")) {
+	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
 			tasklet_init(&priv->done_task[0], talitos1_done_ch0,
 				     (unsigned long)dev);
-- 
2.13.3

