Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C83C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 14:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26137218AE
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 14:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rIbxFzjH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbfAXOei (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:34:38 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36346 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbfAXOei (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 09:34:38 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190124143436euoutp02018d05c10e4d1b061f3686a89ac759f1~8z3W3Y8bK1230012300euoutp02F
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 14:34:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190124143436euoutp02018d05c10e4d1b061f3686a89ac759f1~8z3W3Y8bK1230012300euoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548340476;
        bh=fLft92XOvAmxHSW9w72md68dqA+cokNFROfhpO9NeV0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=rIbxFzjHjJEgzA/1TtDJosgD4FTSfo1z+AqvgsZs9n+aHTmOS7kSmRjrBIngJX837
         EQsUtL4mshAxGJlvKryp23TiRIjVPeWgEuRhfkibeuGzXxpf/t+E8q66cYH0DNMaRY
         tTgbBChAeBiQegq/3GUyaFnCNML5wQczPoEqYLm0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190124143435eucas1p10144f4932b17047cd0d478dfd91d15b1~8z3Vzs_mZ1088910889eucas1p1S;
        Thu, 24 Jan 2019 14:34:35 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 12.87.04806.AFCC94C5; Thu, 24
        Jan 2019 14:34:34 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190124143434eucas1p240b84938182676e4450e88a70753e814~8z3U_eZcb1173311733eucas1p2S;
        Thu, 24 Jan 2019 14:34:34 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190124143434eusmtrp12f5687187a71eb7f4ab75afee2093c80~8z3Uv4FBP1630716307eusmtrp1G;
        Thu, 24 Jan 2019 14:34:34 +0000 (GMT)
X-AuditID: cbfec7f5-367ff700000012c6-76-5c49ccfaac8c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 7B.60.04284.AFCC94C5; Thu, 24
        Jan 2019 14:34:34 +0000 (GMT)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190124143433eusmtip2cf7442d236a8fe9962ca45d1f1ec1be7~8z3UT6b_-0640606406eusmtip2w;
        Thu, 24 Jan 2019 14:34:33 +0000 (GMT)
Subject: Re: [PATCH v2 3/3] crypto: s5p: add AES support for Exynos5433
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <75f3be00-8035-0586-1611-99e5da53a8e7@partner.samsung.com>
Date:   Thu, 24 Jan 2019 15:34:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190124133729.GB13624@Red>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7djPc7q/znjGGMy7ZG2xccZ6Vou/fyst
        5pxvYbHofiVjcf78BnaL+/d+Mllc3jWHzWLG+X1MFmuP3GW3+P+rmdmBy2PLyptMHjtn3WX3
        2HZA1WPTqk42j38Lp7B49G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV8atOQ+ZC75yVOxruMbW
        wLiUvYuRk0NCwETi4+ZTjF2MXBxCAisYJfbe3M8K4XxhlNjSf40JpEpI4DOjxL5LZjAdZ/8c
        Y4WIL2eUePbOBKLhLaPEi8MzwBLCAu4Sl5bcAVshIqAn0TbrENgKZoHXTBIbbr8Cm8omYC7x
        aPsZMJtXwE3ixb7LLF2MHBwsAqoSf28ogIRFBSIkOu6vZoMoEZQ4OfMJC4jNKaAp8fvNWmYQ
        m1lAXOLWk/lMELa8xPa3c5hBdkkIXGOXmD5hN5DDDuS4SFw0gbhfWOLV8S1Q38tInJ7cwwJh
        l0vs3vqMHaK1hVFi7uRFTBAJa4nDxy+ygpzGDLR3/S59iLCjxOKeFrCLJQT4JG68FYS4gE9i
        0rbpzBBhXomONiGIal2Jef/PsELY0hJd/9exTmBUmoXkr1lIfpmF5JdZCHsXMLKsYhRPLS3O
        TU8tNs5LLdcrTswtLs1L10vOz93ECExUp/8d/7qDcd+fpEOMAhyMSjy8HYc8Y4RYE8uKK3MP
        MUpwMCuJ8LpedIsR4k1JrKxKLcqPLyrNSS0+xCjNwaIkzlvN8CBaSCA9sSQ1OzW1ILUIJsvE
        wSnVwOhwwcll8anae8dO6CquPP3zf7u2Vv+bhDN/7B+eNLlY1PwpKK0+gf3FduUZkv85Zd44
        vmA9U6nLbPXqMavEvsOum7Xil+6Y2ff+Q5gEo1fNFc/w9kMHml/FlrscV1i10a2PV8r4eOeq
        Y4812pN9Vz59Hi4UldFQm3L/OH+UnMRJnRLlKTGSmkosxRmJhlrMRcWJAHMdF8xQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xe7q/znjGGFzby2axccZ6Vou/fyst
        5pxvYbHofiVjcf78BnaL+/d+Mllc3jWHzWLG+X1MFmuP3GW3+P+rmdmBy2PLyptMHjtn3WX3
        2HZA1WPTqk42j38Lp7B49G1ZxejxeZNcAHuUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWe
        obF5rJWRqZK+nU1Kak5mWWqRvl2CXsatOQ+ZC75yVOxruMbWwLiUvYuRk0NCwETi7J9jrF2M
        XBxCAksZJSb3bmKCSEhLNJ5eDWULS/y51sUGUfSaUaKht5sRJCEs4C5xackdsEkiAnoSbbMO
        MYIUMQu8ZpI4fPABC0THJ0aJxlcrmUGq2ATMJR5tPwM2llfATeLFvstARRwcLAKqEn9vKICE
        RQUiJM6+XMcIUSIocXLmExYQm1NAU+L3m7VgY5gF1CX+zLsEZYtL3HoynwnClpfY/nYO8wRG
        oVlI2mchaZmFpGUWkpYFjCyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcxAmN027Gfm3cwXtoY
        fIhRgINRiYe345BnjBBrYllxZe4hRgkOZiURXteLbjFCvCmJlVWpRfnxRaU5qcWHGE2BfpvI
        LCWanA9MH3kl8YamhuYWlobmxubGZhZK4rznDSqjhATSE0tSs1NTC1KLYPqYODilGhi91c4F
        66zXMxM1tr2pave/+tbRy92s098az2laZXJxbr7DlZl/nhu6RT8+ufNg9wXr1r1yys8vPv+p
        9Exp3x5Ly5rH9YXx+myrJjVaODaK6fX5FDlan7LIWtAS1hbN1JOz4fPbfQfL16Zu0vRuC5ye
        5mARvJ57+3wf08x9+j5ST3eWvbpwY48SS3FGoqEWc1FxIgBoANYW5wIAAA==
X-CMS-MailID: 20190124143434eucas1p240b84938182676e4450e88a70753e814
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21
References: <20190123165533.29645-1-k.konieczny@partner.samsung.com>
        <CGME20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21@eucas1p1.samsung.com>
        <20190123165533.29645-4-k.konieczny@partner.samsung.com>
        <20190124133729.GB13624@Red>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 24.01.2019 14:37, Corentin Labbe wrote:
> On Wed, Jan 23, 2019 at 05:55:33PM +0100, Kamil Konieczny wrote:
>> Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
>>
>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>> ---
>>  drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 46 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>> index 0064be0e3941..e2d247f59254 100644
>> [...]
>> @@ -240,6 +241,7 @@
>>  struct samsung_aes_variant {
>>  	unsigned int			aes_offset;
>>  	unsigned int			hash_offset;
>> +	char				*clk_names[];
> 
> Hello
> 
> this could be set as const

Definitions sets const:

grep "static const" drivers/crypto/s5p-sss.c

static const struct samsung_aes_variant s5p_aes_data = {
static const struct samsung_aes_variant exynos_aes_data = {
static const struct samsung_aes_variant exynos5433_slim_aes_data = {

so it is not needed at struct declaration, or am I missing something ?

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

