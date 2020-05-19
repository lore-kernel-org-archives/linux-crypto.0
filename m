Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258FCC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 21:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFAD6207FB
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 21:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="H7F9ahBC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgESV0Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 17:26:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35643 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgESV0X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 17:26:23 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200519212621euoutp013ff48141c05fe3a8095c9fb5959df98e~QixLbiOfh2114821148euoutp011
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 21:26:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200519212621euoutp013ff48141c05fe3a8095c9fb5959df98e~QixLbiOfh2114821148euoutp011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589923581;
        bh=8xXZu8KwJk4sk0qFMS95EUYNTZd+JYVuM8QsDA9u3E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7F9ahBCKUGfCGmWulahyKuCVWR6GajpYRHuKK9hI62/af0WJG+94344PjlUbgOVG
         VYLDHdc7tIJgvORIJ8G666jnMk4x8SYYcOMiz/WoEDldCbpVgv4rx9O8H+XU65/U6F
         ywRl+SHicya9BfxC3k5hvuNLqhQd4sw4I9uZqTVE=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200519212620eucas1p19083ebe06068f2df9d92c89dd411c130~QixKJrBRv2659526595eucas1p1U;
        Tue, 19 May 2020 21:26:20 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 1B.EB.60679.CFE44CE5; Tue, 19
        May 2020 22:26:20 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200519212619eucas1p22fa5d3db2521096dc4b79f6e53016d17~QixJiNzIA1745917459eucas1p2P;
        Tue, 19 May 2020 21:26:19 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200519212619eusmtrp12c03ca924274527851ee90af96fc896a~QixJhaGtF2223622236eusmtrp1M;
        Tue, 19 May 2020 21:26:19 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-31-5ec44efc18f7
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id F8.D4.07950.BFE44CE5; Tue, 19
        May 2020 22:26:19 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200519212619eusmtip2245d2c1bb185ae2415f0e2571978fc74~QixJUQ9CC0582005820eusmtip2b;
        Tue, 19 May 2020 21:26:19 +0000 (GMT)
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
        linux-samsung-soc@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 1/2] hwrng: iproc-rng200 - Set the quality value
Date:   Tue, 19 May 2020 23:25:51 +0200
Message-Id: <20200519212552.11671-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519212552.11671-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjm2zk7O0qz0zR8maU18kdKXkriAyW0gk50wR/9qEhr1UHDbeqW
        lhEomZl3USpdViMVxXsnnTWkbK20vKzyVmFJtKiWinkhNcvajpH/nvf9nud5nwc+mpBlUnL6
        lOY0p9UoVQrKlTQ+nevdtLDfEh30vYHCv4qeSvCdkkYxrs97QmJrVhWB58ctEpxe3kjhHPsa
        XPDxG4Gt1iYJfmOuRpj/OCjGI+/nRLjPVEbhEusDETYU28TYYMxH+FPpXQqP19oQvtJVT+KO
        ziwi3IP9OV+EWP1ID8VO9veL2Pv6dxK2nH9IscZ2X5avyaLYhzfqJOzdilQ2v7kGsflfmxDb
        2DxAsheeZ4rZKd470u2wa9hJTnUqmdMGbjvmGts03EskFNJn+9pziDR0UZKNXGhgQuCycZbK
        Rq60jKlGYK/4iYRhGkHuYDflYMmYKQQt1tXZiHYqxgbDBU4VgopbbyXC8BlBXckvp4BiIqCg
        slPswB5Mgxh+VHIOTDBnIOODzbl3Z3ZAWn+zE5OMLyyONpEOLGVCIfvmIiHE84HMqlanpwsT
        BpbZGUrgrIJnpTYnfyXjB3UXhkjB3wfSW64TjkDAvKDBdLuFFIx2wkhuxlJnd7B3NC/hNdBV
        nEsKzVKhuGiroM1FYCybXdKGwnDvPOXgEMxGaDQFCusIsEy+pASpG7weWyVEcIMi4zVCWEvh
        8iWZwN4ADQVtS4ZyyLNXo0Kk0C8ro19WQP//lgERNciTS9KpYzjdZg13JkCnVOuSNDEBJ+LV
        PPr7Pbt+d0zfQ6aF42bE0EixQhrU9jhaJlYm61LUZgQ0ofCQFn4xR8ukJ5Up5zht/FFtkorT
        mZEXTSo8pVtuf42SMTHK01wcxyVw2n+vItpFnobKakNs3QGHvPcOJLS3HUv2PziWuDt0XLtr
        5W+v9rpHfd48cSRxbW+xZbFSNKyZoBZSWkFaKF4n35M65Rdsk22vZQY9RuOsQ96jCSPnDYah
        W1dDbvrfmIqciQ5dz0+MTwa7R23bx/OR9gM95arEMX1lZITqlV9pd5R6uymwNDNWQepilcF+
        hFan/AOEH3DsmgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTURSGvZ2lA1odS43XigJNiIbEYkHoBYG4YDJPxGj0AbVYYQIipaRT
        UHgRiwvUyGZIoAohokERpBQsKHvLJot9EBHcDSWuYFhMZFVKY+Tty/n//yzJoTBhESGmziZq
        WU2iMkFCuuJ9S93vd81HdCh2d7VsRYv5XXxUU1hNoKobnTiyZZVjaG6ig48yyqpJdP2bO8oZ
        /Y4hm83IRyOW+wCZRocI9OH9LA+9eHqbRIW2Fh4qvWknUKk5G6CxoloSTTy0A1TQV4Wj7p4s
        bJ+ImZ/LB4zhwwDJTA0O8pgnhnd8pszUSjLmNm/GVJFFMq3FlXym9u5FJruuAjDZX42Aqa57
        iTO63msEM23afnh9pDREo07Wsp5xak4bKjkhQ35SWRCS+u0Jksr85aeC/QIkvmEhMWzC2RRW
        4xt2WhpnfPscS8qlLrxou46lg8t8PaAoSO+B40P79MCVEtL3AJzJ6COcdTF8UByrBy7L6AYX
        hvSk0zMG4P3e16RDIOn9MOdeD+EQRHQTARuHs3gOAaPPwyuf7ISD3eiDMH2wboVx2hv++WHE
        HSyg90J9yR/MOcEDXiuvX2nqQofAjt+/VlhIq2DewgDh9G+Ez4rsuGM5jN4Bq0uEjvIG2gdW
        6l7hzrEeMOPxLSwXCA2rEob/CcMqVynAKoCITeZUsSrOT8opVVxyYqw0Wq0ygeW3MHfN1jUA
        /cRRC6ApIFkn2N1kVQgJZQqXqrIASGESkSD3i0UhFMQoU9NYjTpKk5zAchYQsHxmHibeFK1e
        frJEbZQsQCZHQTK5v9w/EEk2CzLp9pNCOlapZc+xbBKr+ZfjUS7idPCqOfBIttLglVOepu87
        gK95EzC4wNs53b/o3tAiaA+enGqm+iPBnUeeBV46RdPHGZ21v3JkMvKzSMHIc7vlHuPD1uNJ
        8REa4yc7DL96xjwaGaYSh8/GL83/fN2m22KV0ws69dpQc+ah+l7bVIaofKbTahurmbj0zlx5
        zG1bowTn4pQyH0zDKf8CFUGULSwDAAA=
X-CMS-MailID: 20200519212619eucas1p22fa5d3db2521096dc4b79f6e53016d17
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200519212619eucas1p22fa5d3db2521096dc4b79f6e53016d17
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200519212619eucas1p22fa5d3db2521096dc4b79f6e53016d17
References: <20200514190734.32746-1-l.stelmach@samsung.com>
        <20200519212552.11671-1-l.stelmach@samsung.com>
        <CGME20200519212619eucas1p22fa5d3db2521096dc4b79f6e53016d17@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value was estimaded with ea_iid[1] using on 10485760 bytes read from
the RNG via /dev/hwrng. The min-entropy value calculated using the most
common value estimate (NIST SP 800-90P[2], section 6.3.1) was 7.964464.

[1] https://github.com/usnistgov/SP800-90B_EntropyAssessment
[2] https://csrc.nist.gov/publications/detail/sp/800-90b/final

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 drivers/char/hw_random/iproc-rng200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index 32d9fe61a225..95669ece050f 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -199,6 +199,7 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 	priv->rng.read = iproc_rng200_read,
 	priv->rng.init = iproc_rng200_init,
 	priv->rng.cleanup = iproc_rng200_cleanup,
+	priv->rng.quality = 1000,
 
 	/* Register driver */
 	ret = devm_hwrng_register(dev, &priv->rng);
-- 
2.26.2

