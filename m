Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF9AC433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 11:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B77061406
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 11:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhDVLU0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Apr 2021 07:20:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40927 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235818AbhDVLUZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Apr 2021 07:20:25 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210422111948euoutp012e6277bb059571b4faf09fdf63a381f1~4KiFZxhcB2144121441euoutp01J
        for <linux-crypto@vger.kernel.org>; Thu, 22 Apr 2021 11:19:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210422111948euoutp012e6277bb059571b4faf09fdf63a381f1~4KiFZxhcB2144121441euoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619090388;
        bh=/40vp3pB/gxCPcqee6NJ5uROj1+28vx9EiJ6ZBfEAJ0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=jAI+ooG+hgISLvBUA9WSMicU+uwqEqNGIACCNSExedkyYmCb7EEm6jf2hQLsGe93M
         Kik9Z5g5TZO8iSghNh+qsdeJPFHRrUc3lyM4KEhw5K41kzg+g3GSi9RLTpxBlCBUeu
         6aPBWVQd3Krh4nbuXMnOxzEIJjZOsbYjB1HgOeB8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210422111948eucas1p26da0f37f1ecb4413e04432b2d298fb42~4KiE4p0Dc3264232642eucas1p2u;
        Thu, 22 Apr 2021 11:19:48 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 30.3E.09439.4DB51806; Thu, 22
        Apr 2021 12:19:48 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210422111947eucas1p1eda720a62ffcb6dc525558ab99721668~4KiERDF_a2499924999eucas1p12;
        Thu, 22 Apr 2021 11:19:47 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210422111947eusmtrp1369a9c042d4ba377e457bf3df1453a8d~4KiEQWEFI0316903169eusmtrp1W;
        Thu, 22 Apr 2021 11:19:47 +0000 (GMT)
X-AuditID: cbfec7f5-c1bff700000024df-60-60815bd4ad5c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 3E.B7.08696.3DB51806; Thu, 22
        Apr 2021 12:19:47 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210422111946eusmtip24b6f9cf08219ac1073b1c5b608dd82d4~4KiDopUK63142331423eusmtip2I;
        Thu, 22 Apr 2021 11:19:46 +0000 (GMT)
Subject: Re: [PATCH v2] hwrng: exynos - Fix runtime PM imbalance on error
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?Q?Bart=c5=82omiej_=c5=bbolnierkiewicz?= 
        <b.zolnierkie@samsung.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <cdeb89aa-d876-f00d-529c-95456c5b2397@samsung.com>
Date:   Thu, 22 Apr 2021 13:19:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <bc20ae4c-3e62-7b07-506c-ce8d90f65754@canonical.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsWy7djP87pXohsTDPZt5LTYOGM9q0X3KxmL
        jW9/MFncPLSC0WLT42usFvfv/WSyuLxrDpvFjPP7mCwWbOtjdOD0mNXQy+ax7YCqx+Yl9R59
        W1YxevS93MDo8XmTXABbFJdNSmpOZllqkb5dAlfG2oefWQr+sFU8WHqJrYHxMWsXIyeHhICJ
        xJp/R4BsLg4hgRWMEr+XvGaBcL4wSjTvmQnlfGaUuDzlGTtMy6Pja5hAbCGB5YwSr59bQBR9
        ZJR4+/0IC0hCWMBTYnbzIbC5IgJnmSR2z1zABpJgFgiQ6Jn8DayITcBQouttF1icV8BO4uK7
        vWBHsQioSnz7sg2sRlQgSeLmpf/MEDWCEidnPgGLcwo4Slza38wIMVNeonnrbGYIW1zi1pP5
        TCCLJQRecEh8uzSFCeJsF4nZrfOgbGGJV8e3QL0jI3F6cg8LREMzo8TDc2vZIZweoKebZjBC
        VFlL3Dn3C+hUDqAVmhLrd+lDhB0lXi/9zgQSlhDgk7jxVhDiCD6JSdumM0OEeSU62oQgqtUk
        Zh1fB7f24IVLzBMYlWYheW0WkndmIXlnFsLeBYwsqxjFU0uLc9NTi43zUsv1ihNzi0vz0vWS
        83M3MQLT0+l/x7/uYFzx6qPeIUYmDsZDjBIczEoivGuLGxKEeFMSK6tSi/Lji0pzUosPMUpz
        sCiJ8+7auiZeSCA9sSQ1OzW1ILUIJsvEwSnVwJSzy++fk+bPnqiDOtuzNZn1Fq313RAc/9ZD
        cXPVrPDXrNOu6E9+tcj3WsZSwbtOS6tuW+Scu1Xxe5fuj7I677xXbp7m6nKMDS2ejyIv/ZFj
        W7qn3enzpAXHRSZ+8CsxfHWL6cA8qdfN6YFbi286JM6bMeFPyql1CfWFhjvl77lNT/E9qN73
        YscNzSyfn+6fj77zvim10ELVsK937s7989keaE6+c4rv2Fy5yKKo6GVr29X373yTvNOa98mH
        2L2KATu0Eo7lPOd6vK7Uab5c3oZ04UC3lsIAuYY/gV/jwiNupc28kLtjxnOLpCefNt/60yKm
        +rb1rOBeH1W5DP1JjjoFio9nvWvOuRd6eo/kDG4lluKMREMt5qLiRAA4PW4lvgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t/xe7qXoxsTDLa1SVpsnLGe1aL7lYzF
        xrc/mCxuHlrBaLHp8TVWi/v3fjJZXN41h81ixvl9TBYLtvUxOnB6zGroZfPYdkDVY/OSeo++
        LasYPfpebmD0+LxJLoAtSs+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384m
        JTUnsyy1SN8uQS9j7cPPLAV/2CoeLL3E1sD4mLWLkZNDQsBE4tHxNUxdjFwcQgJLGSU2rv/I
        BJGQkTg5rQGqSFjiz7UuNhBbSOA9o8TmVmUQW1jAU2J28yFWkGYRgbNMEmf3LGMESTAL+El0
        rnwNNfUYo0TTvwVgU9kEDCW63kJM4hWwk7j4bi/YBhYBVYlvX7axgNiiAkkS9y6vZIaoEZQ4
        OfMJWJxTwFHi0v5mqAVmEvM2P2SGsOUlmrfOhrLFJW49mc80gVFoFpL2WUhaZiFpmYWkZQEj
        yypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzAeNx27OeWHYwrX33UO8TIxMF4iFGCg1lJhHdt
        cUOCEG9KYmVValF+fFFpTmrxIUZToH8mMkuJJucDE0JeSbyhmYGpoYmZpYGppZmxkjivyZE1
        8UIC6YklqdmpqQWpRTB9TBycUg1Ma2afKTTeocT2PUx+yZIlScnqXC5Mlbt/H/39cAebjSTX
        imtrfGITPm7y0d0c9PrLnowzve2/vmaFzjUXveWiJ9wXMeug1JU1Wo8mXBJfqxYh7mh1NiUs
        TyfDRGtfvfEPp94LFUXih/Udrj04tay9vOz1jCM9T7TYz0pc697s0/htBdPSbiuNhcL3blvL
        n1u34EZ/vtUdppaj55993VqfENbE7/r/kPj1Y6wyosH3RX2P+wXMP7LgV+rl3rsq73gk96xU
        WZt6Q/b7OY9TCwraNnN7bbki69Z1a218TELbjb49t+dKnrz1mZF16zpeRdvQDfv1V93OE3/b
        n5fhZPdzlhzL9oD/ienlp5dv9b9xX4mlOCPRUIu5qDgRAKaiExVQAwAA
X-CMS-MailID: 20210422111947eucas1p1eda720a62ffcb6dc525558ab99721668
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210422104145eucas1p17f46c95b72f3568761a9f7911bf072e1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210422104145eucas1p17f46c95b72f3568761a9f7911bf072e1
References: <CGME20210422104145eucas1p17f46c95b72f3568761a9f7911bf072e1@eucas1p1.samsung.com>
        <20210422104141.17668-1-l.stelmach@samsung.com>
        <bc20ae4c-3e62-7b07-506c-ce8d90f65754@canonical.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22.04.2021 12:46, Krzysztof Kozlowski wrote:
> On 22/04/2021 12:41, Łukasz Stelmach wrote:
>> pm_runtime_get_sync() increments the runtime PM usage counter even
>> the call returns an error code. Thus a pairing decrement is needed
>> on the error handling path to keep the counter balanced.
> It's exactly the same as Dinghao's patch:
> https://lore.kernel.org/linux-samsung-soc/20200522011659.26727-1-dinghao.liu@zju.edu.cn/
> which you reviewed. It has even the same commit msg
> (although it's difficult to be creative here).
>
> I think it's better to resend his patch instead.

Frankly speaking I would get rid of the pm_runtime_get_sync() calls in 
the drivers and replace them with pm_runtime_resume_and_get() to finish 
that never ending pm_runtime get/put misunderstanding soap opea...

Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

