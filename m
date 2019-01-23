Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E256C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 15:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 080BE21852
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 15:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="umWN4+a+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfAWPXo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 10:23:44 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41471 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfAWPXo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 10:23:44 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190123152342euoutp027645bcebd5fee102dc86dce062c86331~8g48VoUTf0171801718euoutp02V
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 15:23:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190123152342euoutp027645bcebd5fee102dc86dce062c86331~8g48VoUTf0171801718euoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548257022;
        bh=37GzLsduwG1JDVXT7dHW2UjCbxbzSqW8HaI22aeSCNk=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=umWN4+a+1irbSwNHO4ghzw8qLOJSDaAj8bC/QEcqanLBFROsDMcp/QYBnSEAYnosz
         H3s/IWEz6qpSuRbneUD5Xtof4tWxls1Z6otcmyMe5xT2i17TXn+TtRGv+cskSxJCHG
         PAvBChu8iGQ6Bd5i+mJSYYJ/cD4PWTcLlftZI3uo=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190123152341eucas1p2d5e2631387ddbf4bfba47c46bec95d1c~8g47NGcJk0455504555eucas1p2x;
        Wed, 23 Jan 2019 15:23:41 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 9F.A8.04806.CF6884C5; Wed, 23
        Jan 2019 15:23:40 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190123152340eucas1p260dceb994fecb1af6733b31ba5d61a77~8g46Qif4D1968519685eucas1p2W;
        Wed, 23 Jan 2019 15:23:40 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190123152339eusmtrp215dfae3713732265a26240702c9cc7f5~8g45-Fg6C0873908739eusmtrp25;
        Wed, 23 Jan 2019 15:23:39 +0000 (GMT)
X-AuditID: cbfec7f5-367ff700000012c6-05-5c4886fc12fe
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id F2.49.04284.BF6884C5; Wed, 23
        Jan 2019 15:23:39 +0000 (GMT)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190123152339eusmtip28eee6c6066f82050bf4b69538d28b6c4~8g45cyS5j1330213302eusmtip2O;
        Wed, 23 Jan 2019 15:23:39 +0000 (GMT)
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
Message-ID: <d2b9b8cd-4b34-743f-dfd7-9bab6a50a5da@partner.samsung.com>
Date:   Wed, 23 Jan 2019 16:23:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJKOXPfGJxzPVcAitU=uDFfrmtwQZD1dcbbhy+BjEUF_6exx2g@mail.gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsWy7djP87p/2jxiDD7OtLTYOGM9q8Wc8y0s
        FvOPnGO16H4lY3H+/AZ2i/v3fjJZXN41h81i7ZG77BZLr19ksmjde4Tdgctjzbw1jB5bVt5k
        8th2QNVj06pONo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKWLLrBFPBPLGK+/P3sTUwLhHq
        YuTgkBAwkfg4x6uLkYtDSGAFo8T2WfeZIJwvjBJtd08BOZxAzmdGiaV9mSA2SMPh559YIIqW
        M0qsn3WKBaLoLaPE3V2eILawgI/ErQPzwOIiApoS1/9+ZwVpYBZ4yCTxac4HdpAEm4C5xKPt
        Z8A28Aq4Sdx/9pAZxGYRUJV4e+8mWFxUIEKi4/5qNogaQYmTM5+ADeUUCJTY834vK4jNLCAu
        cevJfCYIW15i+9s5zCDLJATOsUvc3rqVHeJsF4mby3awQdjCEq+Ob4GKy0j83wnRLCFQLrF7
        6zN2iOYWRom5kxdBJawlDh+/yAoKMGagd9bv0ocIO0rs+7uYHRKOfBI33gpC3MAnMWnbdGaI
        MK9ER5sQRLWuxLz/Z1ghbGmJrv/rWCcwKs1C8tksJN/MQvLNLIS9CxhZVjGKp5YW56anFhvn
        pZbrFSfmFpfmpesl5+duYgQmqdP/jn/dwbjvT9IhRgEORiUe3g15HjFCrIllxZW5hxglOJiV
        RHhdL7rFCPGmJFZWpRblxxeV5qQWH2KU5mBREuetZngQLSSQnliSmp2aWpBaBJNl4uCUamCc
        oR67qLrq4um9IiWHXrNUvpDuL3fewW7eIDVT7p/W0Q73+TMm78/55+07z7rj2ZIlC0ymrNnl
        aFraNlvJOO7kpo9Vdzev9LLxDWb0feY0IXTSrc6nBok/vJ99F6mXmLRlqdfvky6SYh8nlgfr
        /rht/1znw7UXxZYHLMSnmdqxiMx2PP3mqvJbJZbijERDLeai4kQAB7iAZU4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t/xe7q/2zxiDFrOGltsnLGe1WLO+RYW
        i/lHzrFadL+SsTh/fgO7xf17P5ksLu+aw2ax9shddoul1y8yWbTuPcLuwOWxZt4aRo8tK28y
        eWw7oOqxaVUnm0ffllWMHp83yQWwRenZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8da
        GZkq6dvZpKTmZJalFunbJehlLNl1gqlgnljF/fn72BoYlwh1MXJySAiYSBx+/omli5GLQ0hg
        KaPEri8/GSES0hKNp1czQdjCEn+udbFBFL1mlJj+qx2sSFjAR+LWgXksILaIgKbE9b/fWUGK
        mAUeMkm0dE2AGjuDSaL/0yF2kCo2AXOJR9vPgI3lFXCTuP/sITOIzSKgKvH23k2wuKhAhMTZ
        l+sYIWoEJU7OfAK2gVMgUGLP+72sIDazgLrEn3mXmCFscYlbT+YzQdjyEtvfzmGewCg0C0n7
        LCQts5C0zELSsoCRZRWjSGppcW56brGhXnFibnFpXrpecn7uJkZgdG479nPzDsZLG4MPMQpw
        MCrx8G7I84gRYk0sK67MPcQowcGsJMLretEtRog3JbGyKrUoP76oNCe1+BCjKdBzE5mlRJPz
        gYkjryTe0NTQ3MLS0NzY3NjMQkmc97xBZZSQQHpiSWp2ampBahFMHxMHp1QDo+pRryyDP4cP
        3Xz+ljP8ocf5HUquPc71dteuxH3wUfA5pVok0BUnGccvsz62ms+h7Kqnf/3ZxWc/Pf6n4sle
        Zv7p1O+qtNm5JanykzVr0rfE/HKVPhVdfnRD/MQ/rRkej+8K5m1u3rcsrELixdJV4r4axs2X
        D9RznMv+5R1QYb0wbP8U9ohfSizFGYmGWsxFxYkAH1fdO+QCAAA=
X-CMS-MailID: 20190123152340eucas1p260dceb994fecb1af6733b31ba5d61a77
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

Hi Krzysztof,

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
>> index 7a5ca56683cc..75718f86fe50 100644
>> --- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>> @@ -1,4 +1,4 @@
>> -Samsung SoC SSS (Security SubSystem) module
>> +Samsung SoC SSS (Security SubSystem) and SlimSSS module
>>
>>  The SSS module in S5PV210 SoC supports the following:
>>  -- Feeder (FeedCtrl)
>> @@ -15,6 +15,11 @@ supports the following also:
>>  -- True Random Number Generator (TRNG)
>>  -- Secure Key Manager
>>
>> +The SlimSSS module in Exynos5 (Exynos5433) supports:
>> +-- Feeder (FeedCtrl)
>> +-- Advanced Encryption Standard (AES)
>> +-- SHA-1/SHA-256/HMAC (SHA-1/SHA-256)
>> +
>>  Required properties:
>>
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

If Exynos has SlimSSS, it has also SSS. SlimSSS is separated from SSS, it is like SSS
limited to only AES and HASH, and HASH got limited in capabilities. In Exynos5420 SSS
HASH has SHA-1,SHA-256,md5 with/without HMAC, but slimSSS has only SHA-1,SHA-256/HMAC.
SlimSSS AES has all modes present in SSS, these are ECB, CBC, CTR, XTS and CMAC.
The same goes for Exynos5433.

There are no conflicts between SlimSSS and SSS.

> The point is that previously we added drivers/bindings for SSS and now
> you use the other interface. It might be pretty confusing for users...

SlimSSS has same AES registers offsets from base as in SSS, so the s5p-sss driver can
reuse code. It is preferred to use SSS but on Exynos5433 I was unable to read its register
(FEEDCTRL) with all clocks enabled, maybe because firmware loaded secureOS (trustzone).

>[...]
>>[...]

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

