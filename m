Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D63C433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 429E220675
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:07:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OuKiGx3+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgENTHy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 15:07:54 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57880 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbgENTHl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 15:07:41 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200514190740euoutp01415eaa59cfcaa20d259fad728cc20313~O_pqOUg8O1335313353euoutp01S
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2020 19:07:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200514190740euoutp01415eaa59cfcaa20d259fad728cc20313~O_pqOUg8O1335313353euoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589483260;
        bh=0ZTSEZCdZQmmB3Cuf4f7fDeYUffZn+GsVAdbdhxdQ5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuKiGx3+2JiS7BvGECbc+jyku4zGJDdZ5m9YG4MSrDREE8kitFBoCiuKvlLcDxUH9
         YnbokNDaW6Q0hzI2Dt9bpZzNBO1N0UyWvHpF+MRnADy0789en/GHNQVv1/PTX1sxbT
         BrQB4/l8t1uFnMNAydoZU2919kid093HrwTW2Y3s=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200514190739eucas1p128e1f360ca382919779973520cc2d026~O_ppzoPtB2658126581eucas1p1E;
        Thu, 14 May 2020 19:07:39 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D4.98.60698.BF69DBE5; Thu, 14
        May 2020 20:07:39 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200514190738eucas1p2695c0d8af064ee702209ca03696ef438~O_po-9KUX0444904449eucas1p2n;
        Thu, 14 May 2020 19:07:38 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200514190738eusmtrp1af5f742bc66af38419c76ed7d1f90ba7~O_po55Wqj2577025770eusmtrp1n;
        Thu, 14 May 2020 19:07:38 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-b3-5ebd96fb75c4
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id D4.BE.07950.AF69DBE5; Thu, 14
        May 2020 20:07:38 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200514190738eusmtip1e02e9ee08457f754ba2db3422c2673cc~O_pordu_C0350703507eusmtip1P;
        Thu, 14 May 2020 19:07:38 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Matthias Brugger <mbrugger@suse.com>,
        Stefan Wahren <wahrenst@gmx.net>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH 1/2] hwrng: iproc-rng200 - Set the quality value
Date:   Thu, 14 May 2020 21:07:33 +0200
Message-Id: <20200514190734.32746-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200514190734.32746-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUyMcRz363ntOD1d0Vde2o7mZVNZzX7mEGN7Zmb+sDGrOHp2opI7Hdm8
        hd670qG6iqaoJR1355YoLVS0ujAulkLpzbJZjM5LunvO+O/z/X7eft/txxKyCcqfjYk/JKjj
        lbFyWkJam8c7lv64WB8VYutdhH/lNTP4VoGRwjeyH5HYll5BYMenhww+XWakcebIHJzT95HA
        NttNBr9qqkTY1PeSwr094x74eV0xjQtsDR64VN9P4VKrDuEPhWYaf7rej3BLazoR7sP/cOQh
        3tDbTvN3DG8Yvsx0n+atjYG8qSqd5u+XVDO8ufwEr7NUIV43fBPxRssLkk9+kkrxY6Z5W6Q7
        JIpoITZGK6iDV++S7L2m+0glXGaOPJ/IJE+ic3QG8mSBC4PfFrsLy7hKBA+uqDOQZBJ/QTDR
        ncaIwxiCnqed1F/Hpc/lpEhUIMhPLXQPgwiGB+4gp4rm1kLO1VbKSfhyZynQf84lnQTBHYaz
        7/pdUT5cOJhSslzlJBcI1okXrr2UWwm5BTnuugAoOtXm0nhyCrAPOTxEjTc8Lux3ZXpxS6A6
        2e7OD4DTt4sIZzFwjSz0vi93X7oeUh70uLEPjLRYGBHPgTZ91qSZncQnQJ+3XPRmIbAWfydF
        zUro7nDQTg3BLQZjXbC4Xgv6y88Y0Toduka9xSdMhzxrPiGupZCWIhPVC6Am55470B+yRypR
        LpIb/jvG8N8Bhn9dpYioQn5CoiZOJWhC44XDQRplnCYxXhW050CcCU1+y7bfLV9rUcPP3U2I
        Y5F8mjTkQn2UjFJqNUlxTQhYQu4r3Wy8GyWTRiuTjgrqAzvVibGCpgnNZkm5nzT0ynCkjFMp
        Dwn7BSFBUP9lPVhP/5NIImjbZ6lqJAf5sW2lfrsGA1Z492yvauno5n5m79Z6Lnfsa1atmuGb
        +nXqW7BET9Mlb7W/Gpg6f8dxa722Mm3oXp/C6/xo7aIOvXl0f1Kx15mwhog687bODPuxyKsz
        jYEb13UhRe23rpCy3IxN+Wb53Cnzby30YRUlERvOkWvG/V/LSc1e5bIlhFqj/AOwdzj4kgMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e/4Xd1f0/bGGcxYpW3xd9IxdouNM9az
        WqztPcpicb5zObPFr3dH2C2aF69ns+h+JWPR//g1s8X58xvYLW4eWsFosenxNVaL+/d+Mllc
        3jWHzWLG+X1MFgsmP2G1WLCtj9Hi6czNbBbvVj9htDh+opPZQdjj969JjB6z7p9l89g56y67
        x+JN+9k8th1Q9di0qpPNY//cNewem5fUe/RtWcXo0fdyA6PH+i1XWTyaTrWzenzeJBfAG6Vn
        U5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9nk5Kak1mWWqRvl6CXsazvNWvB
        fPaKy/+7WRoYJ7J1MXJySAiYSMz7uISli5GLQ0hgKaPEzi2ngBIcQAkpiZVz0yFqhCX+XOsC
        qxcSeApU89MAxGYTcJToX3qCFaRXRGAyq8SbPa1MIAlmgXKJ1odPWEFsYQEHiU1tPWDNLAKq
        Etv+XwWL8wpYS0yY0c8KsUBeYnbjabAaTgEbiesvfjFBLLOWuPNlLlS9oMTJmU9YQG5jFlCX
        WD9PCCTML6AlsabpOgvEWnmJ5q2zmScwCs1C0jELoWMWkqoFjMyrGEVSS4tz03OLjfSKE3OL
        S/PS9ZLzczcxAhPDtmM/t+xg7HoXfIhRgINRiYfXYOreOCHWxLLiytxDjBIczEoivH7rd8cJ
        8aYkVlalFuXHF5XmpBYfYjQFenMis5Rocj4waeWVxBuaGppbWBqaG5sbm1koifN2CByMERJI
        TyxJzU5NLUgtgulj4uCUamDc6Bnd/f4Rb9E2S0XxfoavT97lrJYWeJGavOdAdc+3T//EbX4r
        9VfbL/mudnfGjQjz39v11dL3Fc68rXlzVpTNmhNbXp3gUbnf0fNthXi8zYL/n82+xF6X1Ant
        zpssuejVnsMrInhTuZSfV802Ud0nz/I8pPGf8tfqzrwLTBOPlX6z3PlkU/0JJZbijERDLeai
        4kQAVkcDliIDAAA=
X-CMS-MailID: 20200514190738eucas1p2695c0d8af064ee702209ca03696ef438
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200514190738eucas1p2695c0d8af064ee702209ca03696ef438
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200514190738eucas1p2695c0d8af064ee702209ca03696ef438
References: <20200514190734.32746-1-l.stelmach@samsung.com>
        <CGME20200514190738eucas1p2695c0d8af064ee702209ca03696ef438@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value has been estimaded by obtainig 1024 chunks of data 128 bytes
(1024 bits) each from the generator and finding chunk with minimal
entropy using the ent(1) tool. The value was 6.327820 bits of entropy
in each 8 bits of data.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 drivers/char/hw_random/iproc-rng200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index 32d9fe61a225..7eb02a23f744 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -199,6 +199,7 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 	priv->rng.read = iproc_rng200_read,
 	priv->rng.init = iproc_rng200_init,
 	priv->rng.cleanup = iproc_rng200_cleanup,
+	priv->rng.quality = 800,
 
 	/* Register driver */
 	ret = devm_hwrng_register(dev, &priv->rng);
-- 
2.25.0

