Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3E4C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 16:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9C84218A4
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 16:55:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hLBcjd/v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfAWQzy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 11:55:54 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36750 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfAWQzx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 11:55:53 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190123165552euoutp02456c47804e7a3db96f54e234c36e04b3~8iJacbwyr1410214102euoutp02S
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 16:55:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190123165552euoutp02456c47804e7a3db96f54e234c36e04b3~8iJacbwyr1410214102euoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548262552;
        bh=RkoOt0oX5YN6cG8lna4P3L0zCXBH0Dvj9mhMNweZGnE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=hLBcjd/vvSv/pUYvzp9Vwka+OAkTmRDzjGSbGrPzjixTpPfafhYxWdzm4SvG5+Chs
         F8a0qBMQ5RXD1D4rB3go/Yt+slqj2DOPZVgXroDsDmgGXvOBluAYwlw9VUC+sPz722
         yamDXzvbq7mh6WiTPrFX3kRlx3aF0kGAl+AxR5ow=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190123165551eucas1p136833794537c86578e6b468325bd99fa~8iJZP7g2p1655316553eucas1p13;
        Wed, 23 Jan 2019 16:55:51 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 3B.42.04806.69C984C5; Wed, 23
        Jan 2019 16:55:50 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190123165550eucas1p117692111e84223f957597903f9f1640d~8iJYWpIPJ1656916569eucas1p1x;
        Wed, 23 Jan 2019 16:55:50 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190123165549eusmtrp2bf274dc7ba9e08f106b231b594a0a621~8iJYH5sQa0112001120eusmtrp2H;
        Wed, 23 Jan 2019 16:55:49 +0000 (GMT)
X-AuditID: cbfec7f5-367ff700000012c6-81-5c489c960473
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 22.58.04128.59C984C5; Wed, 23
        Jan 2019 16:55:49 +0000 (GMT)
Received: from AMDC3218.DIGITAL.local (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190123165549eusmtip12603c382d3e189755b615776c24ba20e~8iJXWYIO60728707287eusmtip1I;
        Wed, 23 Jan 2019 16:55:48 +0000 (GMT)
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
To:     k.konieczny@partner.samsung.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2 0/3] add AES support for Exynos5433
Date:   Wed, 23 Jan 2019 17:55:30 +0100
Message-Id: <20190123165533.29645-1-k.konieczny@partner.samsung.com>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7djPc7rT5njEGNzcZmCxccZ6Vos551tY
        LOYfOcdq0f1KxqJv339Gi/7Hr5ktzp/fwG6x6fE1Vov7934yWVzeNYfNYsb5fUwWa4/cZbdY
        ev0ik0Xr3iPsFv9/NTM78HusmbeG0WPLyptMHtsOqHpsWtXJ5rF5Sb3Hv4VTWDwOvtvD5NG3
        ZRWjx+dNcgGcUVw2Kak5mWWpRfp2CVwZf388ZS44w1Yx5c5ypgbGaaxdjBwcEgImEmsPmXYx
        cnIICaxglDg5J6qLkQvI/sIo8ff1XRYI5zOjxKqWC6wgVSANF092sUMkljNKnFrTzwLXMufM
        S2aQKjYBc4lH288wgdgiAsoSk+9NZwYpYhaYziJx48dsdpCEsICZxJ9Ti1lAbBYBVYkLb08w
        gtzEK+AiMXt5CMQ2eYlpq7vA5vAKCEqcnPkErJwZKN68dTbYTAmBc+wSS5YeZ4RocJE4+v4A
        G4QtLPHq+BZ2CFtG4v/O+UwQdrnE7q3P2CGaWxgl5k5eBJWwljh8/CI4YJgFNCXW79KHCDtK
        PG18xw4JLz6JG28FIW7gk5i0DeQvkDCvREebEES1rsS8/2eggSUt0fV/HZTtIXFp70p2SFDH
        Sqy/doN5AqPCLCSfzULy2SyEGxYwMq9iFE8tLc5NTy02zkst1ytOzC0uzUvXS87P3cQITG2n
        /x3/uoNx35+kQ4wCHIxKPLwb8jxihFgTy4orcw8xSnAwK4nwul50ixHiTUmsrEotyo8vKs1J
        LT7EKM3BoiTOW83wIFpIID2xJDU7NbUgtQgmy8TBKdXAyCf5dYrZ1MNlvob77kqeE1b1U4jb
        /2TZp0Ua1x7/XLdqZY/pWV3BQtV5r2cdUNTWtdz2zHyf45GrDWddwt+qmS10/eq0zSaHJ2pn
        aVlTlw47+8l9GoUhjlo3HxX7+4XsDA78GOO24972giv9Sr9l/3eX6Spennjn062qHdMW8apv
        U3Fc93T9CSWW4oxEQy3mouJEANgSEO9pAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t/xu7pT53jEGHx+qG+xccZ6Vos551tY
        LOYfOcdq0f1KxqJv339Gi/7Hr5ktzp/fwG6x6fE1Vov7934yWVzeNYfNYsb5fUwWa4/cZbdY
        ev0ik0Xr3iPsFv9/NTM78HusmbeG0WPLyptMHtsOqHpsWtXJ5rF5Sb3Hv4VTWDwOvtvD5NG3
        ZRWjx+dNcgGcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWp
        Rfp2CXoZf388ZS44w1Yx5c5ypgbGaaxdjJwcEgImEhdPdrF3MXJxCAksZZSYPH8rE0RCWqLx
        9GooW1jiz7UuNoiiT4wSy97eBetmEzCXeLT9DFiRiICyxOR705lBipgFFrNIHHj3ASwhLGAm
        8efUYhYQm0VAVeLC2xOMXYwcHLwCLhKzl4dALJCXmLa6C6ycV0BQ4uTMJ2DlzEDx5q2zmScw
        8s1CkpqFJLWAkWkVo0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYFxtO/Zzyw7GrnfBhxgFOBiV
        eHg5Cj1ihFgTy4orcw8xSnAwK4nwul50ixHiTUmsrEotyo8vKs1JLT7EaAp060RmKdHkfGDM
        55XEG5oamltYGpobmxubWSiJ8543qIwSEkhPLEnNTk0tSC2C6WPi4JRqYFxbrWT9m+OA+O9H
        zA6TAxZeWds5c8ezzw9n8e0sTOC9yNPauDLxf093T9ds2wyV0KCq9RcXmv0VVfhts5hfRHbu
        mubDk7cKRB55slJ2esON4IuTlguJfAp6O+/5NV7rh41x1zmcbsR9CBKePSlbu6XYXvXurQ/f
        JidyF9b5715U7+G+rm1f1AslluKMREMt5qLiRAAYv4M7wQIAAA==
X-CMS-MailID: 20190123165550eucas1p117692111e84223f957597903f9f1640d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190123165550eucas1p117692111e84223f957597903f9f1640d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190123165550eucas1p117692111e84223f957597903f9f1640d
References: <CGME20190123165550eucas1p117692111e84223f957597903f9f1640d@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add slimSSS node to DT and crypto AES support for Exynos5433. Tested on
Exynos5433 board with crypto run-time self tests and with tcrypt with
command insmod tcrypt.ko mode=500 sec=1

Changes since v1:
- address Krzysztof Kozlowski review: add missing comma in struct
  definition, add goto for error code path, correct indentation,
  in documentation add that Exynos5433 has both slimSSS and SSS IPs.

Kamil Konieczny (3):
  arm64: dts: exynos: add SlimSSS for Exynos5433
  dt-bindings: crypto: document Exynos5433 SlimSSS
  crypto: s5p: add AES support for Exynos5433

 .../bindings/crypto/samsung-sss.txt           | 14 ++++--
 arch/arm64/boot/dts/exynos/exynos5433.dtsi    |  9 ++++
 drivers/crypto/s5p-sss.c                      | 50 +++++++++++++++++--
 3 files changed, 66 insertions(+), 7 deletions(-)

-- 
2.20.0

