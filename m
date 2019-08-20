Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC837C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 11:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83DBA214DA
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 11:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Av80D5WB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbfHTLji (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:39:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34402 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729421AbfHTLji (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 07:39:38 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190820113936euoutp028cd2a6af7e9fb788becc9a7909f4fb97~8np75qquy0730307303euoutp02g
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2019 11:39:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190820113936euoutp028cd2a6af7e9fb788becc9a7909f4fb97~8np75qquy0730307303euoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566301176;
        bh=n6I429CajscHYniAY3jHYsJDaBT8WBSam7UO0dax+jM=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Av80D5WBlShR59ahNBniCTi2y5pm0SLCBBRz++K+5ejxdVgh9jDYlb3T5YTWgUCs3
         UN/tGehxJVpckvdtDgIR7CFYS263U2m9gEbCUNmzg6aanrggJDJS7qWwnFuEF0GFtp
         NxDA8AofRAtbNq1zRDjuqQc/Qo9KQzUNwGoyCjWk=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190820113935eucas1p1722022e5f58ff56139b3adc79be53dc5~8np7dMl3M1692416924eucas1p18;
        Tue, 20 Aug 2019 11:39:35 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 2F.9E.04374.7FBDB5D5; Tue, 20
        Aug 2019 12:39:35 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190820113934eucas1p174389a9f248459b987f7ef08204a2944~8np6tAP_I0897608976eucas1p14;
        Tue, 20 Aug 2019 11:39:34 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190820113934eusmtrp225acf21e3379a91ffef8555cc379b04d~8np6e9QPE0719607196eusmtrp2H;
        Tue, 20 Aug 2019 11:39:34 +0000 (GMT)
X-AuditID: cbfec7f5-4ddff70000001116-8d-5d5bdbf7dbd1
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 86.D7.04117.6FBDB5D5; Tue, 20
        Aug 2019 12:39:34 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190820113934eusmtip10616ae24cff511076d0077dcfdaebd64~8np6KdosB2413824138eusmtip1A;
        Tue, 20 Aug 2019 11:39:34 +0000 (GMT)
Subject: Re: [PATCH 2/2] crypto: s5p - use correct block size of 1 for
 ctr(aes)
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Vladimir Zapolskiy <vz@mleia.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <1f932022-0335-1d00-b651-83c82d77fa7a@partner.samsung.com>
Date:   Tue, 20 Aug 2019 13:39:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAJKOXPevJjBuRJjUX=6BfuMZSLUyqP3fpi7_eWDF170RfPvL+g@mail.gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsWy7djPc7rfb0fHGqzZIGTx/8NuRovuVzIW
        589vYLe4f+8nk8WM8/uYLP7/amZ2YPPYdkDVY9OqTjaPO9f2sHn8WziFxePzJrkA1igum5TU
        nMyy1CJ9uwSujBf34wt281TM7L7P2MA4m7OLkZNDQsBE4uz6VvYuRi4OIYEVjBKrr79hgnC+
        MEps7VrMCOF8ZpTYs7qZFaZlZsdvFojEckaJVyf/QlW9ZZTY0n+GBaRKWCBQomPWYqAODg4R
        gXCJb+36IDXMAmsZJV5eOMkGUsMmYC7xaPsZJhCbV8BNomXmLEaQehYBVYmJW4xBwqICERKf
        HhxmhSgRlDg58wnYeE6g8Q/v7wcbwywgLnHryXwmCFteYvvbOcwguyQEVrFL3D52mgniaheJ
        x9N3sUPYwhKvjm+BsmUk/u+cD1VTLvF0YR87RHMLo8SD9o8sEAlricPHL4I9wyygKbF+lz5E
        2FHi48tTLCBhCQE+iRtvBSFu4JOYtG06M0SYV6KjTQiiWlXi+akeqE3SEl3/17FOYFSaheSz
        WUi+mYXkm1kIexcwsqxiFE8tLc5NTy02zkst1ytOzC0uzUvXS87P3cQITDmn/x3/uoNx35+k
        Q4wCHIxKPLwJ16NjhVgTy4orcw8xSnAwK4nwVsyJihXiTUmsrEotyo8vKs1JLT7EKM3BoiTO
        W83wIFpIID2xJDU7NbUgtQgmy8TBKdXAqPplfZiY6b/lgmmiHO83vby8uT58Q9fp6afXLzmh
        2bYjYuKWax9PH9msJL9wy8HpP5N8bTX2GvNVSx6Ulfa5ueDO/3uqFcbzTIU3LLAx8D1x03TZ
        op7f90o2Kgep3uT9/utpo/ZhFkUX82vPb4tfsKg0esC7SiF7WehSjw8fT629ztH8pIr/rbAS
        S3FGoqEWc1FxIgAmz/mZNQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t/xu7rfbkfHGpyeLWfx/8NuRovuVzIW
        589vYLe4f+8nk8WM8/uYLP7/amZ2YPPYdkDVY9OqTjaPO9f2sHn8WziFxePzJrkA1ig9m6L8
        0pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jBf34wt281TM
        7L7P2MA4m7OLkZNDQsBEYmbHb5YuRi4OIYGljBJfti1nhUhISzSeXs0EYQtL/LnWxQZR9JpR
        ov/AfLCEsECgRMesxWANIgLhEhseLWQHKWIWWMso8WDhC0aIjh4mie3zfrODVLEJmEs82n4G
        rJtXwE2iZeYsoCIODhYBVYmJW4xBwqICERKHd4CEQUoEJU7OfMICYnMCLXt4fz8biM0soC7x
        Z94lZghbXOLWE4iDmAXkJba/ncM8gVFoFpL2WUhaZiFpmYWkZQEjyypGkdTS4tz03GIjveLE
        3OLSvHS95PzcTYzAONt27OeWHYxd74IPMQpwMCrx8O64GR0rxJpYVlyZe4hRgoNZSYS3Yk5U
        rBBvSmJlVWpRfnxRaU5q8SFGU6DfJjJLiSbnA1NAXkm8oamhuYWlobmxubGZhZI4b4fAwRgh
        gfTEktTs1NSC1CKYPiYOTqkGxuVmKs+2TuZrymP/0L4oIlSCNahx98s5Ke8Xqfo9nbrA8bV9
        +CeJLz9Cz8ROFX82SyFhb0ryMvXPrv4Takwfh0klegutX/XN76PDx64jx3+uWJgcJey9vOO5
        hUBkbPfyjvvF8dMDdj5uZhBymuT/74P/3QQGKW7bYz2KYVOcI6/6lbdt1YtiUWIpzkg01GIu
        Kk4EAKeo1UTJAgAA
X-CMS-MailID: 20190820113934eucas1p174389a9f248459b987f7ef08204a2944
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
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 20.08.2019 12:24, Krzysztof Kozlowski wrote:
> On Mon, 19 Aug 2019 at 16:24, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>
>> Align the s5p ctr(aes) implementation with other implementations
>> of the same mode, by setting the block size to 1.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  drivers/crypto/s5p-sss.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>> index ef90c58edb1f..010f1bb20dad 100644
>> --- a/drivers/crypto/s5p-sss.c
>> +++ b/drivers/crypto/s5p-sss.c
>> @@ -2173,7 +2173,7 @@ static struct crypto_alg algs[] = {
>>                 .cra_flags              = CRYPTO_ALG_TYPE_ABLKCIPHER |
>>                                           CRYPTO_ALG_ASYNC |
>>                                           CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -               .cra_blocksize          = AES_BLOCK_SIZE,
>> +               .cra_blocksize          = 1,
> 
> This makes sense but I wonder how does it work later with
> s5p_aes_crypt() and its check for request length alignment
> (AES_BLOCK_SIZE). With block size of 1 byte, I understand that
> req->nbytes can be for example 4 bytes which is not AES block
> aligned... If my reasoning is correct, then the CTR mode in s5p-sss is
> not fully working.

As I remember this case there are allocated buffers with len aligned up
AES_BLOCK_SIZE, source data copy to one buf, hw encrypts full block, 
then nbytes are copy back.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

