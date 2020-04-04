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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E00BC2BA1A
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Apr 2020 14:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48154206D4
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Apr 2020 14:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="pV/4ZGEP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgDDO5X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Apr 2020 10:57:23 -0400
Received: from mout.web.de ([212.227.17.11]:37347 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgDDO5X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Apr 2020 10:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586012220;
        bh=C2KveFWKzUHHIjPTMkE7LjhJpUU2YKMSuSmnzYsVjWw=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=pV/4ZGEPFPYOpDMrLirSpicQAvAYwyBaWACxbD0KPyJMyRKX1qEUiu+B8M+dDf331
         i49QqyWeRk3h79sqLnjU8ZnrnSXZU0f5ufDKd6fUeM2xVwx5jR6D0xoYZYTSMnRJay
         ZcVn48JmgMa/Bafdtvq3bbhv13rM9jMJiBZObd6s=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.132.181.229]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Lh6QF-1j0WYV2rWp-00oU5K; Sat, 04
 Apr 2020 16:57:00 +0200
To:     linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Deepak Saxena <dsaxena@plexity.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] hwrng: omap - Delete an error message in
 of_get_omap_rng_device_details()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <eae7170c-4371-4865-7b85-589c0ed2b5b6@web.de>
Date:   Sat, 4 Apr 2020 16:56:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1mPM05PZGf5upbNmlHG8hg8fF92RQEBvmnzWQrYIkEaPD85ry/M
 OaaBtZmMOttnAg7hdNThgh7MoUQC50mmeRC+5VGkP6ahJTkIadEJsYTawavxEy9w45Cacug
 0PjpH0ioVyCWfo1G7V4OfN6SAkkkgF5nvW4zx/kAaGEchlUXdnZZNOYosEhVWx68cbwjp4N
 5NRRzAWlGVcrd1pJAIvMw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gvGdsMt4DYg=:FhU4m91UNfE5Wl3rFdrB2g
 eNgBUC8hZTdYQ3ZeLTcMiiy6c/saA/8U/MvxiOtgZgLKbXW0N+w/gJee2wTh4oFABoh8GnkZQ
 qOXdUsaZz83yFeXfkHneidHgjMRWsCp2r88ls2IITBMP4SAnL6KPgD5SK09wNQmTVJjyieqYr
 5XuB8mnET1GqVhwkIO3BnfeFnfYzTzgYTnRx69oeWzV102u09LpHMLcw989Tc7hGp1Vg+wph9
 0brzN4RAIQDOUEPkeErHd9nEecpqHJxhHrkmhcAG7XFo2SGX7OOqa0URNJ4umqkjFUVEvhdmi
 X/zZZ0pPee6ZNpywNkfjg4I+20qpsliPq3PbpdYFNAN6St6dabHDmzSN345H1BM08mRlqoSpF
 oqAkjD7mozkiHqshzUIsS2rAgAoVfxL2b+EGhqE7QSOXGA39P8T0C9k4trb1umC3x/Nkd7MeT
 EQqCB1N1x1Vjh+vVxqxKO+PLU50jlX1/Sugk/wNHCVhIyrkr03GjlEHzwQY7EJt5SqAcWZ3Du
 G0AgAPuZaOeFNPkazaUl+1cy0C0L2Xw37psx4yaKfkPTuOT2q/tn+zA1tUqQOSyXD3ltZuLAh
 3ogLFpBu5s+2uJfJ40ekvgmuQE0DVPN/v0DakYtNYf05Jy38+o6IWBxyKazXhRZnR4zqzgYHm
 VUcTPr35HwANTGHn8HsnuDULXEsk7eW6/iSRJAYf9XZUi2cSSEN2CQFC01w5izIJDN3VpaIhw
 t5xj3+W4X1YZpAnuin5FIf7kezU6iP96VgoxJc/JC5SovAXasxs5kcpeKIdZKWR/91lHCc6h3
 xYOIi71PfvEN1i0pIYPGXgYP0izqinowbH5taDenBdxM3gP4hyXUo+cBK0L2chOsug6t0SSYK
 Oos0il+5k620NH2MJuJCI0jaX9QnPdd6XjhUoFVjGMgx6wASUVliaIPyqC9e3oDI7pJs06ObJ
 Lc3G0WRCNuWNnYdGcVX5CK1KH73QwZXc6N7c2vbIYdCXgDNj1ItqMpUymsAEFqxpB2Xwjo1Ks
 Rmzkz9MUClyOorQRzIUq6Xlw1/A8VMbGKcxc1yenyxxEv8JKoPbHaR6DztbqnBIjPY/GMT/Wb
 r/c/70Icp5NjSpk8Ycc+g4Sl5vGb4LmlqvmEDR6NlYOrnk4grAT4nyZwxuU0IEMBIabmn8NAZ
 XdumufQjU/3BDI2dkfUMZPfm3mug1ML1j+T1lZdUeqWKFl+qek6ZxA60o+GxhJnijfCVfJT6W
 OQyrugSeNEloQqnGW
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 4 Apr 2020 16:45:57 +0200

The function =E2=80=9Cplatform_get_irq=E2=80=9D can log an error already.
Thus omit a redundant message for the exception handling in the
calling function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/char/hw_random/omap-rng.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/om=
ap-rng.c
index 65952393e1bb..7290c603fcb8 100644
=2D-- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -392,11 +392,8 @@ static int of_get_omap_rng_device_details(struct omap=
_rng_dev *priv,
 	if (of_device_is_compatible(dev->of_node, "ti,omap4-rng") ||
 	    of_device_is_compatible(dev->of_node, "inside-secure,safexcel-eip76"=
)) {
 		irq =3D platform_get_irq(pdev, 0);
-		if (irq < 0) {
-			dev_err(dev, "%s: error getting IRQ resource - %d\n",
-				__func__, irq);
+		if (irq < 0)
 			return irq;
-		}

 		err =3D devm_request_irq(dev, irq, omap4_rng_irq,
 				       IRQF_TRIGGER_NONE, dev_name(dev), priv);
=2D-
2.26.0

