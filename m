Return-Path: <SRS0=TurE=5U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF73C2BA15
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Apr 2020 15:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6778206D4
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Apr 2020 15:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="GqYW9/Vn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgDDPSP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Apr 2020 11:18:15 -0400
Received: from mout.web.de ([212.227.17.11]:40331 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgDDPSO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Apr 2020 11:18:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586013443;
        bh=9o5auQpdZ+ebmoPBCRpyWY8Ck41no0lRg9eca/cxAtg=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=GqYW9/VnkUj7uNWFUvTZXtNaqeLfxU4fE/huTvY6nzO6l0BQ5AmdrdwPKzZ5aWC1E
         q4VkGK7Ez1luYCwwpNGfoNYgnpFJTdO2ckVeFdIMxfMveMdLYNlLoDhD+x0NCB7MAb
         TX2q75KmfVeKkFWPkOsgR8SfyZ0LdzkBr6qF1ydE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.132.181.229]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MWAwH-1jngNO1qyf-00XLwT; Sat, 04
 Apr 2020 17:17:23 +0200
To:     linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Chuhong Yuan <hslester96@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        YueHaibing <yuehaibing@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] hwrng: xgene - Delete an error message in xgene_rng_probe()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Message-ID: <45447185-d64f-027c-7bca-c59ea21e6021@web.de>
Date:   Sat, 4 Apr 2020 17:17:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ICiuDRervWvfHNDOGNrIJBPt2UeeahgtYMoQNGl/ppqs7kpIXV9
 kTXSd/l+zkLv1+r+fXtvVmyId5GMp0DJqfkdnJ/M0qYFnsyadsuc/GswesTY+DCCSYVWIxA
 odWARvWEKSKsgxUpWpGOUeBgzlj8M/hntphOjXhAkv1Fl0PUPEOqoH5fc+0EGX8bvJhmTrb
 AVoQYqrOT4ersrYQck3Dw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:E/os88pyrlo=:bUAzhJ0jz4zVoP4Mdg19Ku
 ogyjTEg/ylgfMMDuFiUVo8T6mkRyMZVIMo1EKm7cQWW9JH0olIU3JETB2bEDmNcoKj9+3V1Un
 iXe2krYLGPEriOHVU49GZvDDovxaG45Wt3byRyStwgMziGJqphBw/AuhuGoFoJHvUH5xeHbzP
 9ToipsP/25hw6k511abQUlObdSnVwBKaqbosvUr4+6SNqfSvYACM88+Ww39jEw/fUuBktprHV
 LeO3j8i9A5mXiAF/zQfAdDvkwkNHX6BXVtY4BV6YCsJ2wXv46T13NO+uus3cZv1O7LIJSJsTs
 Ta60d3QvYUHG2Kz3+XT4XDBc8ytfo+fQ58uHJNHF9NL9xMvqRPZq8oZe/DmnnkOdZG3UbyXUW
 Scxzc0lBmlLlAGvzrbCjdUCRY1kQYr4oRdNSvlLEfm6IeeGND09pFoLSYKk+gegFwj3NICjJr
 FK/QnGGaWhAdQfxulax4QnEygsc12tQYtefHWbo+vv+AB1SGihKlLQBNF+0kdF5I8B5GUF7r3
 BtzrqroK3zSR7FPlyGS0WOuqfh9wNWxn4MI2jnRkM+C/MRPG4JLCxpsy8M/BwgcDnMfh7jQ0U
 o2bnLT+7EA71tstdZKWSKBrcoFgE0T5/oaynpZCIe/GihKqkJ4GP/MmujmCXjzo81hIfxbOzM
 aVc/mCJZlI7oqj9NkZyMwpPZ5abks+c6hvr0+B5UeiHXpVOKZYTFzo3sRdjzF06p8xEpKkPwR
 SJWN1HHt8pEBaMg76DyU8WWC4Zf+6hMDEsNHqjp4g2GIopee0oNlj9jICSM4wS211sgaF5I7z
 MokglkGRCSZseOQoLmLhPW28k6fAWVakHZ4+BspSSJWSgdSanQH8h6rdRfGvTkIBTkVExYy9C
 Nwbc2udgFWVzTktQXJp35qmq6/lIUWQUrvyt9an+apBk56dBKGqnaHZESB/SRalOS0JVyZroH
 fJvV2S5+yy59VCASg3XV1AnSW6eyXDUChi5G++amf/Xp0wZpPyf50B/QyHypD3ur3J9MDAMyL
 x8jCKFnj4Ot1LKVhUZksJkhHUkc5ARPQBW0hFugalVfUpjNYI7XEzet2tGY8s6lleTvfQyyhp
 Aq96C24kkgHCB8zglVkY+7AprcLEIOsUUr6sEt0hq20W4Lr6wL6haybbW+duyj3apS440PMg5
 rNj/FEiFhFPBdrOzes9nlG2e0O7rpiZihUdqwyOxQfmHUuLLEnfHMCnumB9Nle/Wznf1DdWwZ
 YzhK9InsFeExI4K1v
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 4 Apr 2020 17:07:34 +0200

The function =E2=80=9Cplatform_get_irq=E2=80=9D can log an error already.
Thus omit a redundant message for the exception handling in the
calling function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/char/hw_random/xgene-rng.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/x=
gene-rng.c
index d7516a446987..008e6db9ce01 100644
=2D-- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -328,10 +328,8 @@ static int xgene_rng_probe(struct platform_device *pd=
ev)
 		return PTR_ERR(ctx->csr_base);

 	rc =3D platform_get_irq(pdev, 0);
-	if (rc < 0) {
-		dev_err(&pdev->dev, "No IRQ resource\n");
+	if (rc < 0)
 		return rc;
-	}
 	ctx->irq =3D rc;

 	dev_dbg(&pdev->dev, "APM X-Gene RNG BASE %p ALARM IRQ %d",
=2D-
2.26.0

