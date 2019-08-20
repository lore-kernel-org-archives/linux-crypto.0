Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F780C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 12:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03EA422DA7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 12:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Yz9BRSEa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfHTM2I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 08:28:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53177 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbfHTM2H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 08:28:07 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190820122806euoutp0253733d450cfd090e105b5714d153f232~8oUSP8edi0316503165euoutp02G
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2019 12:28:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190820122806euoutp0253733d450cfd090e105b5714d153f232~8oUSP8edi0316503165euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566304086;
        bh=jI7d1mBEIuGFt/vrXYXtHNRuvzqsbpDIe8skBRbjdpU=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Yz9BRSEaTRLEvV/gdl33uTSgcDOdEsJ1O8s9neeRsRNwSVIH+Rq4OOuu9elfbPQxa
         Q0+u4uEtTrDv56vt0+ngkA3btlbe8Oq/38g8TgVf84myh7kVOw4m2OQZZGDMH2DwYk
         /RhidM62xsGkqKSMmURJrnnua2PF/Gy1gfJ1aPEM=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190820122805eucas1p2679e27eb3a2fd94159758e941fb2d75e~8oUR6ehZF1331213312eucas1p2o;
        Tue, 20 Aug 2019 12:28:05 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 2B.BA.04309.557EB5D5; Tue, 20
        Aug 2019 13:28:05 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190820122804eucas1p2c65ce7b97d168329118c0a61a0651407~8oUQ9zHKS2607826078eucas1p2N;
        Tue, 20 Aug 2019 12:28:04 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190820122804eusmtrp1f8525afcac35468b77ddec6340683ee1~8oUQvgYfk1557015570eusmtrp1O;
        Tue, 20 Aug 2019 12:28:04 +0000 (GMT)
X-AuditID: cbfec7f4-afbff700000010d5-54-5d5be755ed73
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id D4.FD.04117.457EB5D5; Tue, 20
        Aug 2019 13:28:04 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190820122804eusmtip1d90ecc5c515a5c111d53ba9a6c55191c~8oUQcg_NQ1835218352eusmtip1H;
        Tue, 20 Aug 2019 12:28:04 +0000 (GMT)
Subject: Re: [PATCH 2/2] crypto: s5p - use correct block size of 1 for
 ctr(aes)
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Vladimir Zapolskiy <vz@mleia.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <f7f1babd-5c74-5561-4771-49809398da5f@partner.samsung.com>
Date:   Tue, 20 Aug 2019 14:28:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAJKOXPfR_L4z=sE8ETUB3_6sVV=ab=vntqh-_KvNmsKacEa4qQ@mail.gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsWy7djPc7qhz6NjDVbPV7H4/2E3o0X3KxmL
        8+c3sFvcv/eTyWLG+X1MFv9/NTM7sHlsO6DqsWlVJ5vHnWt72Dz+LZzC4vF5k1wAaxSXTUpq
        TmZZapG+XQJXxuHXT9gLOoUqJrx+wdbA+JG3i5GTQ0LAROLhoidsXYxcHEICKxgl3k+czgzh
        fGGUaLrSzQThfGaUuPn8AztMy7OX16GqljNK/PrazwrhvGWUmDepnQWkSlggUKJj1mJWEFtE
        QFPi+t/vYEXMArcZJc7dbGADSbAJmEs82n6GCcTmFXCTOHu0E2wFi4CqxLQ57WA1ogIREp8e
        HGaFqBGUODnzCdACDg5OoAXHp9mAhJkFxCVuPZnPBGHLS2x/OwfsOgmBdewSX+acY4U420Wi
        ZcZhJghbWOLV8S1Q78hInJ7cwwJhl0s8XdjHDtHcwijxoP0jVMJa4vDxi6wgi5mBvlm/Sx8i
        7Cjx8eUpsHskBPgkbrwVhLiBT2LSNlA4goR5JTrahCCqVSWen+qBukBaouv/OtYJjEqzkDw2
        C8k3s5B8Mwth7wJGllWM4qmlxbnpqcVGeanlesWJucWleel6yfm5mxiBaef0v+NfdjDu+pN0
        iFGAg1GJh3fHzehYIdbEsuLK3EOMEhzMSiK8FXOiYoV4UxIrq1KL8uOLSnNSiw8xSnOwKInz
        VjM8iBYSSE8sSc1OTS1ILYLJMnFwSjUw5k2avmFC1Imc+Fv+3/bYvy/4VfZlxXMdq60uqcsf
        Tf25/6axTyYH3785nZ9Pf7NZ29Vsqqjs9uvuLq/+Ys1OubuPGTM5JuRpvE35HDpd85iIzvwH
        Z5VbK+u/Mhh++PSuoSw44mpHa3yWhfuyCZtf/3qy78beT5NM9tx+F8kc8sSj2XG9lc6zVUos
        xRmJhlrMRcWJAFHOam03AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t/xu7ohz6NjDSavUbX4/2E3o0X3KxmL
        8+c3sFvcv/eTyWLG+X1MFv9/NTM7sHlsO6DqsWlVJ5vHnWt72Dz+LZzC4vF5k1wAa5SeTVF+
        aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZapG+XYJexuHXT9gLOoUq
        Jrx+wdbA+JG3i5GTQ0LAROLZy+vMXYxcHEICSxklVs9qZoFISEs0nl7NBGELS/y51sUGYgsJ
        vGaUWPjYF8QWFgiU6Ji1mBXEFhHQlLj+9zsryCBmgZuMEkfOzYeaOoFZ4t3eDewgVWwC5hKP
        tp8Bm8or4CZx9mgnWJxFQFVi2px2sA2iAhESh3fMYoSoEZQ4OfMJ0EUcHJxA245PswEJMwuo
        S/yZd4kZwhaXuPVkPhOELS+x/e0c5gmMQrOQdM9C0jILScssJC0LGFlWMYqklhbnpucWG+kV
        J+YWl+al6yXn525iBMbZtmM/t+xg7HoXfIhRgINRiYd3x83oWCHWxLLiytxDjBIczEoivBVz
        omKFeFMSK6tSi/Lji0pzUosPMZoC/TaRWUo0OR+YAvJK4g1NDc0tLA3Njc2NzSyUxHk7BA7G
        CAmkJ5akZqemFqQWwfQxcXBKNTDuP5vKn5VnWNvn5rhxeZnN7C797PuuJTVVYcx+ryxenNM0
        dYr2DTvBdG/XvTeTmHO+C6aJXVze5DQ1+Bpn9pXSY09fzv3ULuH4anKZNNuDq5wsrT2fea9o
        qCbeznt1zU9B6INrkOGVXbfVOzxyZLNT7+n8tTvDkDPpwZsoEwamBYt023/FMyixFGckGmox
        FxUnAgDKjX16yQIAAA==
X-CMS-MailID: 20190820122804eucas1p2c65ce7b97d168329118c0a61a0651407
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190820102425epcas2p219b7cac45290fbc87bb62bf446fec345
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190820102425epcas2p219b7cac45290fbc87bb62bf446fec345
References: <20190819142226.1703-1-ard.biesheuvel@linaro.org>
        <20190819142226.1703-3-ard.biesheuvel@linaro.org>
        <CGME20190820102425epcas2p219b7cac45290fbc87bb62bf446fec345@epcas2p2.samsung.com>
        <CAJKOXPevJjBuRJjUX=6BfuMZSLUyqP3fpi7_eWDF170RfPvL+g@mail.gmail.com>
        <1f932022-0335-1d00-b651-83c82d77fa7a@partner.samsung.com>
        <CAJKOXPfR_L4z=sE8ETUB3_6sVV=ab=vntqh-_KvNmsKacEa4qQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20.08.2019 13:48, Krzysztof Kozlowski wrote:
> On Tue, 20 Aug 2019 at 13:39, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
>>
>>
>>
>> On 20.08.2019 12:24, Krzysztof Kozlowski wrote:
>>> On Mon, 19 Aug 2019 at 16:24, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>>>
>>>> Align the s5p ctr(aes) implementation with other implementations
>>>> of the same mode, by setting the block size to 1.
>>>>
>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>> ---
>>>>  drivers/crypto/s5p-sss.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>>>> index ef90c58edb1f..010f1bb20dad 100644
>>>> --- a/drivers/crypto/s5p-sss.c
>>>> +++ b/drivers/crypto/s5p-sss.c
>>>> @@ -2173,7 +2173,7 @@ static struct crypto_alg algs[] = {
>>>>                 .cra_flags              = CRYPTO_ALG_TYPE_ABLKCIPHER |
>>>>                                           CRYPTO_ALG_ASYNC |
>>>>                                           CRYPTO_ALG_KERN_DRIVER_ONLY,
>>>> -               .cra_blocksize          = AES_BLOCK_SIZE,
>>>> +               .cra_blocksize          = 1,
>>>
>>> This makes sense but I wonder how does it work later with
>>> s5p_aes_crypt() and its check for request length alignment
>>> (AES_BLOCK_SIZE). With block size of 1 byte, I understand that
>>> req->nbytes can be for example 4 bytes which is not AES block
>>> aligned... If my reasoning is correct, then the CTR mode in s5p-sss is
>>> not fully working.
>>
>> As I remember this case there are allocated buffers with len aligned up
>> AES_BLOCK_SIZE, source data copy to one buf, hw encrypts full block,
>> then nbytes are copy back.

to be precise, hw encrypts align_up(req->nbytes, AES_BLOCK_SIZE)

> Buffer alignment is different thing and it is defined in cra_alignmask.
> I am talking about req->nbytes which should be aligned according to
> s5p_aes_crypt(). But if blocksize is 1 byte, then what possible values
> for req->nbytes?

For AES-CTR, there are blocks of size multiply of AES_BLOCK_SIZE, with last
one which can be of any size

so for req->nbytes valid values are n*AES_BLOCK_SIZE + 0...AES_BLOCK_SIZE-1

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

