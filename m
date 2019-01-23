Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8CCC282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 16:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02DA721726
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 16:18:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QCz0wgBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfAWQSJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 11:18:09 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57062 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfAWQSJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 11:18:09 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190123161807euoutp02a18fdd4b10d14ba842d3ce57111dc1f5~8hodORmFl2890728907euoutp02A
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 16:18:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190123161807euoutp02a18fdd4b10d14ba842d3ce57111dc1f5~8hodORmFl2890728907euoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548260287;
        bh=7srUykYsH5XWfQLiprudhZFB2RwL5AzLL2W7P35vA4k=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=QCz0wgBLhGz1ZC6oxg/MALZft6xQgLb/CwBG7aUTTN8KZCJlaTrfkOC3n9MCilMBW
         I1zfP3eTDt3XIOX9d2qNDY2Pe0HlfXM8CEg0xq6Cn2UbNGQWK5rSNAIyRRC95ioNga
         icGqzeURa0vFv+6D3MLVrmqa8s1KVMYOcxuBJ08U=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190123161806eucas1p17123cbed6e54809dfc325fb7497b7611~8hocUqgAV2026720267eucas1p1e;
        Wed, 23 Jan 2019 16:18:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id D4.13.04441.EB3984C5; Wed, 23
        Jan 2019 16:18:06 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190123161805eucas1p28b9ddf6aa9878bf7f9f6d38c4500a59f~8hobcctlA3064630646eucas1p2T;
        Wed, 23 Jan 2019 16:18:05 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190123161805eusmtrp175b54f80de4000e7e173773e1210da37~8hobNn_Hh2372823728eusmtrp16;
        Wed, 23 Jan 2019 16:18:05 +0000 (GMT)
X-AuditID: cbfec7f2-5c9ff70000001159-43-5c4893beff10
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 3F.3F.04284.DB3984C5; Wed, 23
        Jan 2019 16:18:05 +0000 (GMT)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190123161804eusmtip168354a08ea36cced3d8f03ba403dbb43~8hoaq4WS52986429864eusmtip1v;
        Wed, 23 Jan 2019 16:18:04 +0000 (GMT)
Subject: Re: [PATCH v1 2/3] dt-bindings: crypto: document Exynos5433 SlimSSS
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <d2476a98-837c-68a0-5091-14865605f4dd@partner.samsung.com>
Date:   Wed, 23 Jan 2019 17:18:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJKOXPfGJxzPVcAitU=uDFfrmtwQZD1dcbbhy+BjEUF_6exx2g@mail.gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SeUgUcRj1N8fOuLUyrppfalYLEhVelDSRRUHpQEIJQWGCrTqoebbjWRmC
        W6iZmAflbYqZ5pWZinllHnmQrGGa5BViIIl54YFHrqPkf++9733v9z340bi8njShfQKCeVWA
        0k8hkRLV7Su9lo3JnKvN0MYB9t3LcpLN7FUTbE7rV5J9OmXG9vZWUOzoyArGfqvLlLClrcMU
        WzCgwdjHDa3URSlXkl2CuKqiHxhX3WzBVRbHSriEqmLEzVeaX5e4SO09eT+fUF5lfeGO1Ls/
        IxYLGtkXvjmWiEchjW4c0qWBOQ2VWZ+oOCSl5cwbBKV93TtkAUF+0TgmknkEa13PsN2V77V5
        hDgoRPB8fBAXyTSC5bweSusyYJxgqDmb0GJD5jgMrC+RWhPOjGMwl/l32yRhzsCvmp7tWBnj
        AOqi1C2dpgnGAlImnbWyEXMLYkbfSkSLPnSmTWxn6jLOUD/TQGoxzhjD0EQOJuLDUDOduX0Q
        MH0UFMyqkTYTmMvQtuAlNjCAqY4qSsRm0J0cT4g4DD5+mKTEXTWCrOS8ncrn4HOHhtTm4Ftl
        yuusRfkSNK7nU2K8HgxO64sn6EFS9QtclGUQ80Quui0he7OHFLEpxG2WkYlIkb6nWPqeMul7
        yqT/fzcXEcXImA8R/L14wTaAD7MSlP5CSICXlUegfyXa+lPdGx1ztWixz70FMTRS7JfR9zhX
        OakMFSL8WxDQuMJQdkXj4CqXeSoj7vOqQDdViB8vtCBTmlAYyx7ojN2WM17KYN6X54N41e4U
        o3VNopCto33GctfGWqGv5cpVuy/u78M1nUkWAy5OqwVRTTx9bNGxea3wfJlT2usbB+1e3T0b
        lzEj7WkzTegKWv0df7LwVOcfSUqsyU3cI/9I5NGaXJ1BdVV7RZqrQw3hmKeK7i6fXfJQqB6Z
        48JoanT/tTQ6cMKoNfLn2qGHw1yTs5vNvIIQvJW2J3CVoPwHS0qBZU8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t/xu7p7J3vEGBz+LmqxccZ6Vos551tY
        LOYfOcdq0f1KxuL8+Q3sFvfv/WSyuLxrDpvF2iN32S2WXr/IZNG69wi7A5fHmnlrGD22rLzJ
        5LHtgKrHplWdbB59W1YxenzeJBfAFqVnU5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5r
        ZWSqpG9nk5Kak1mWWqRvl6CXcXV2J1PBPe6K/w8mMDcwXuTsYuTkkBAwkbi2YxFLFyMXh5DA
        UkaJcxcWsUEkpCUaT69mgrCFJf5c62KDKHrNKLFmxUl2kISwgI/ErQPzWEBsEQFNiet/v7OC
        FDELPGSSaOmaADV2BpNE/6dDYB1sAuYSj7afARvLK+Am0bJyKlCcg4NFQFViyrNAkLCoQITE
        2ZfrGCFKBCVOznwCtoBTIFBiz/u9rCA2s4C6xJ95l5ghbHGJW0/mM0HY8hLb385hnsAoNAtJ
        +ywkLbOQtMxC0rKAkWUVo0hqaXFuem6xoV5xYm5xaV66XnJ+7iZGYGxuO/Zz8w7GSxuDDzEK
        cDAq8fBuyPOIEWJNLCuuzD3EKMHBrCTC63rRLUaINyWxsiq1KD++qDQntfgQoynQbxOZpUST
        84FpI68k3tDU0NzC0tDc2NzYzEJJnPe8QWWUkEB6YklqdmpqQWoRTB8TB6dUA6MuQ/bivk/V
        s6dEB85W2ua3R+aWUUpRa5XwG6vqcGbdhnnNL85Urv7lkqZtueiVkuDf4EOHyy+YFnx6HNX8
        r6Bgrfq9J7MtkqRU0nj9j791Ybx86/b54/tyJtZslLK4+9C3K9Kh471u/LeFx076zA7uZpZi
        917uz98tIvD9VbNWqejmlTMXcSuxFGckGmoxFxUnAgBkD0kI4wIAAA==
X-CMS-MailID: 20190123161805eucas1p28b9ddf6aa9878bf7f9f6d38c4500a59f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190122152608eucas1p27cff7b53eb3bb23447ef7ba2b3f69671
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190122152608eucas1p27cff7b53eb3bb23447ef7ba2b3f69671
References: <CGME20190122152608eucas1p27cff7b53eb3bb23447ef7ba2b3f69671@eucas1p2.samsung.com>
        <20190122152553.1537-1-k.konieczny@partner.samsung.com>
        <20190122152553.1537-3-k.konieczny@partner.samsung.com>
        <CAJKOXPfGJxzPVcAitU=uDFfrmtwQZD1dcbbhy+BjEUF_6exx2g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23.01.2019 08:59, Krzysztof Kozlowski wrote:
> On Tue, 22 Jan 2019 at 16:26, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
>>
>> Document DT bindings for crypto Samsung Exynos5433 SlimSSS (Slim Security
>> SubSystem) IP.
>>
>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>> ---
>>  .../devicetree/bindings/crypto/samsung-sss.txt      | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>> [...]
>>  - compatible : Should contain entries for this and backward compatible
>> @@ -22,11 +27,13 @@ Required properties:
>>    - "samsung,s5pv210-secss" for S5PV210 SoC.
>>    - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
>>                 Exynos5260 and Exynos5420 SoCs.
>> +  - "samsung,exynos5433-slim-sss" for Exynos542x and Exynos5433 SoCs.
> 
> For Exynos5420 there is a driver for regular/full SSS module. It would
> be nice to explain what is the difference between them and/or mention
> potential conflicts of usage.
> 
> The point is that previously we added drivers/bindings for SSS and now
> you use the other interface. It might be pretty confusing for users...

By the way, Exynos4 (Exynos4210, 4412) SSS do not have ARCFOUR (ARC4), nor
TRNG nor Secure Key Manager.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

