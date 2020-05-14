Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016DCC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D72FD206F1
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 19:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CClJ+Fyo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgENTIA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 15:08:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57869 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgENTHk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 15:07:40 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200514190739euoutp01e2f4c72f9c8d369bbee76c9777d45761~O_ppNMVdv1498914989euoutp01B
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2020 19:07:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200514190739euoutp01e2f4c72f9c8d369bbee76c9777d45761~O_ppNMVdv1498914989euoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589483259;
        bh=CXFOnCSMo4ZePs1sWzgaCbirikPXXnubVCNzMYCfGBA=;
        h=From:To:Cc:Subject:Date:References:From;
        b=CClJ+FyobMDurEP5yKu624eumo8GvTzP8ChA5fSE9+1wiFgNQuxpmx/E0ST0igXxj
         tZTQkS+3D2KqSutEbtIgkxiaEehVWkcH1QEBLQOVRoAqu3qC7lpETQ7kQSOil5N3K3
         auZIU4ZmlvR/Q39YBVCbiXzbOnifgxsOFsJ5Biu4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200514190737eucas1p266af3c9f52a7fcb960981451ed8a6ed4~O_poBhODy0442904429eucas1p25;
        Thu, 14 May 2020 19:07:37 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 41.A1.60679.9F69DBE5; Thu, 14
        May 2020 20:07:37 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200514190737eucas1p18ccdddb185ea7611683a6859e17bc721~O_pniwfV-0234402344eucas1p1o;
        Thu, 14 May 2020 19:07:37 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200514190737eusmtrp1dfac399447ada06f75e580787e9cef7f~O_pnh-Vnd2577025770eusmtrp1m;
        Thu, 14 May 2020 19:07:37 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-6a-5ebd96f9c12d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id C8.32.08375.9F69DBE5; Thu, 14
        May 2020 20:07:37 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200514190737eusmtip2b2b24273eb8b84ed3db9c7ab6359c5ef~O_pnXZPj81371813718eusmtip2A;
        Thu, 14 May 2020 19:07:37 +0000 (GMT)
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
Subject: [PATCH 0/2] Set the quality value for two HW RNGs
Date:   Thu, 14 May 2020 21:07:32 +0200
Message-Id: <20200514190734.32746-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjm81x2sk4dp+DLiqJRQaZmF+OjMhKCTpRd6EdhZK06qeSNHc2K
        SMtmac2NLVNnkWWheFttNnRpl5WuElslZWEl6TQ0FETJS/d51uXf8z2X93lf+BhC/pNSMPFJ
        qYI6SZWgpH1JW/O4K2T8YmNMWIMxBH83NMvwrUIzhau1TSR25ZQReGLwkQxnlZppfK5/FtZ1
        fyawy3VTht86yhG2dL+mcOeHcR/cZr9E40LXXR9cYnRTuMSWh3BPkZXGg5VuhJ2Pc4i1/vzX
        CQPiTZ2tNF9vei/jSy33aN52fz5vqcih+XuXq2S89XoGn1dbgfi8vpuIN9e+IvlTT89Q/LBl
        9lY22nf1ASEh/rCgXrxmr29c5UMrlWInj5zucNOZyEnkoikMcMshr671N/Zl5Fw5An1lPZIe
        Iwh6y796lWEEdz92/Y3UVNd7hTIEo+OnvZFPCCxtLymPi+YiQXfjMeURAjgNBcYhPekRCC4d
        NB/dkyZ/biU4uzJ9chHDkNx8yOyiPTTLrYKu3Aek1DYHik+2eHk/eFLknuRncEFQdardO3IO
        ZN0untwIuBsM5A9ZaSm8DrKzc7yD/KHfWSuT8CxoMZ4nPb3AZYDRsELKnkdguzTm9a+Cd88m
        aI+H4BaC2b5YoiOhorRfJkWnw5sBP2mF6WCwFRASzcLZbLnkngc1ugbvQAVo+8uRhHl4/vkn
        pUdzTf8dZvrvGNO/3hJEVKBAIU1MjBXEpUlCeqioShTTkmJD9ycnWtDvb9nywzlSh+zf9jkQ
        xyDlNDYsvzFGTqkOi0cTHQgYQhnAbjbfiZGzB1RHjwnq5D3qtARBdKCZDKkMZJdd69st52JV
        qcIhQUgR1H9UH2aKIhOdCT/YtzZwYJHik13RsMO4IWvk6vYOw1hwcJrGb5NGGxFVE5ldVnd1
        q+7LVPbkFs22qJ4m9oquVxsrLjB1VzVst7s7o2G2vr66g2XQkJYuu7MueqnjwkRPY24CET5t
        fdtOfemLKwX7T4zSuzYebzconLZ9yRFBoe2GQsp6qyVCSYpxqiVBhFpU/QIQF34jkgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t/xe7o/p+2NM7i8Xsji76Rj7BYbZ6xn
        tVjbe5TF4nzncmaLX++OsFs0L17PZtH9Ssai//FrZovz5zewW9w8tILRYtPja6wW9+/9ZLK4
        vGsOm8WM8/uYLBZMfsJqsWBbH6PF05mb2SzerX7CaHH8RCezg7DH71+TGD1m3T/L5rFz1l12
        j8Wb9rN5bDug6rFpVSebx/65a9g9Ni+p9+jbsorRo+/lBkaP9Vuusng0nWpn9fi8SS6AN0rP
        pii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7MstUjfLkEvY/XhzawF
        u1gqWm4/YWtgPM7cxcjJISFgIrFu7U4gm4tDSGApo8TH5WdYuxg5gBJSEivnpkPUCEv8udbF
        BlHzlFFiyeapYM1sAo4S/UtPsIIkRAQms0q82dPKBJJgFiiXaH34hBXEFhawkjj+qIEJZCiL
        gKpEwyM2kDCvgLXEo66DLBAL5CVmN56GigtKnJz5hAWknFlAXWL9PCGQML+AlsSapussENPl
        JZq3zmaewCgwC0nHLISOWUiqFjAyr2IUSS0tzk3PLTbUK07MLS7NS9dLzs/dxAiM9G3Hfm7e
        wXhpY/AhRgEORiUeXoOpe+OEWBPLiitzDzFKcDArifD6rd8dJ8SbklhZlVqUH19UmpNafIjR
        FOibicxSosn5wCSUVxJvaGpobmFpaG5sbmxmoSTO2yFwMEZIID2xJDU7NbUgtQimj4mDU6qB
        ken00bNaRVM4Ft4Rm/W65OIyfjcRm+sbJ9w6m83yz8wpsi8+VXr3bkE1ffZfF+4/7rm5/saz
        qbZeZbOXzF9/Jk7hi5zztlVbp/aYLVnlPanr386+tsU/73fMfmtV+9D/57bgfPnYeqWo9x/u
        xXT57DSadqH6YE20V37ilxpfS6/6zl82vNEd3kosxRmJhlrMRcWJAG2FeAMKAwAA
X-CMS-MailID: 20200514190737eucas1p18ccdddb185ea7611683a6859e17bc721
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200514190737eucas1p18ccdddb185ea7611683a6859e17bc721
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200514190737eucas1p18ccdddb185ea7611683a6859e17bc721
References: <CGME20200514190737eucas1p18ccdddb185ea7611683a6859e17bc721@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rng structure contains the quality field which tells how many bits
of entropy can be obtained from 1024 bits read from a device. With the
quality value set the hw_random framework starts a kernel thread to feed
the entropy pool in the CRNG, which helps to initialize it quickly
especially during boot.

Łukasz Stelmach (2):
  hwrng: iproc-rng200 - Set the quality value
  hwrng: exynos - Set the quality value

 drivers/char/hw_random/exynos-trng.c  | 1 +
 drivers/char/hw_random/iproc-rng200.c | 1 +
 2 files changed, 2 insertions(+)

-- 
2.25.0

