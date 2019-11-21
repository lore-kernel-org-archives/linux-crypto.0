Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553A1C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 10:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F83E206CB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 10:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bh8aX3M9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfKUKvx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 05:51:53 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54965 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUKvw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 05:51:52 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20191121105150euoutp01b1f7aa4111338993bdc404f36662008f~ZJ-ykVmSR1558915589euoutp01g
        for <linux-crypto@vger.kernel.org>; Thu, 21 Nov 2019 10:51:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20191121105150euoutp01b1f7aa4111338993bdc404f36662008f~ZJ-ykVmSR1558915589euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574333510;
        bh=VK5BETXoh+owHaEYvSwcp6bB4KTJnFLs5Im7oFh2S4E=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=bh8aX3M9uC4kCeMZAZrgHhfMLvg0AXvp5gO52KPCKeNmF4UpLh62RJwduAWt0K0RL
         51vTai8RMUjJpZcwBK4wRGKQKsvbXUAxHYAH8gkJuWGkZE451gS9s0Gz/tMpMm23+G
         sdCZTPgbxKsDNHX3YwQ5IBhjOJ8HywynHO3IbuYM=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20191121105150eucas1p1ecb54481436fe634903d19d84c4abfab~ZJ-yYbRSE1817918179eucas1p1e;
        Thu, 21 Nov 2019 10:51:50 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 9B.39.04469.64C66DD5; Thu, 21
        Nov 2019 10:51:50 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20191121105150eucas1p1fcb74b96f07541573eaaf5008e0648c0~ZJ-x8Fmup0748807488eucas1p1M;
        Thu, 21 Nov 2019 10:51:50 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191121105150eusmtrp1db97523583f3ab59d63271be7dff8440~ZJ-x7ad5G0875708757eusmtrp1j;
        Thu, 21 Nov 2019 10:51:50 +0000 (GMT)
X-AuditID: cbfec7f2-54fff70000001175-8a-5dd66c4686bb
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id AB.0E.04117.64C66DD5; Thu, 21
        Nov 2019 10:51:50 +0000 (GMT)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191121105149eusmtip2e5aff3cf8b85c6f268556e4d6315547d~ZJ-xhKjH91865018650eusmtip24;
        Thu, 21 Nov 2019 10:51:49 +0000 (GMT)
Subject: Re: [RESEND PATCH] MAINTAINERS: update my e-mail address
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>
From:   Kamil Konieczny <k.konieczny@samsung.com>
Message-ID: <1bd50b4b-a40a-a0c1-48ce-60e69b11ec3f@samsung.com>
Date:   Thu, 21 Nov 2019 11:51:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAJKOXPefL_nyNaUExCJv6zKmhPTvgiPaaPT-sRoyyOw59aTZiQ@mail.gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsWy7djP87puOddiDbZ9U7TYOGM9q8Wc8y0s
        Ft2vZCzOn9/AbnH/3k8mi8u75rBZzDi/j8ni/69mZgcOjy0rbzJ5bDug6rFpVSebx7+FU1g8
        +rasYvT4vEkugC2KyyYlNSezLLVI3y6BK+PhzweMBZf4Kj5ffsDewPiSu4uRk0NCwETizJdF
        bF2MXBxCAisYJR5Ovw3lfGGUuLL6BCOE85lR4tiKe+wwLU+WP2GHSCxnlPgx+yArhPOWUeLV
        oa3MIFXCAo4Sl481s4HYIgKaEtf/fgcrYha4wyTx9thpsCI2AX2Jg2dPsoDYvAJ2EgcfbAJq
        4OBgEVCVePWYCcQUFYiQOP01EaJCUOLkzCdg1ZwCgRJTJq9iBbGZBcQlbj2ZzwRhy0tsfzuH
        GWSVhMAhdon1Vz+BzZEQcJF4ttQH4gFhiVfHt0A9IyNxenIPC4RdLvF0YR87RG8Lo8SD9o9Q
        CWuJw8cvsoLMYQb6Zf0ufYiwo8TytlVsEOP5JG68FYQ4gU9i0rbpzBBhXomONiGIalWJ56d6
        mCBsaYmu/+tYJzAqzULy2Cwkz8xC8swshL0LGFlWMYqnlhbnpqcWG+allusVJ+YWl+al6yXn
        525iBCak0/+Of9rB+PVS0iFGAQ5GJR5eAbWrsUKsiWXFlbmHGCU4mJVEePdcvxIrxJuSWFmV
        WpQfX1Sak1p8iFGag0VJnLea4UG0kEB6YklqdmpqQWoRTJaJg1OqgTGsb41OSlWN6oPHN9yC
        TsXw8NoYbpmyY4vYWq8cFTG56XktWTmzAuuf3O28sUXg2Ocom6wN6/bKLly06qnRl4XeuWH7
        VE7YWq38nC4rN6so65rGhh/zag2/REwvPfJS1sZ+3p56O+sdq/TFlzzusVUW9OH7Y/v9dqnn
        l7q6mPadE+8nb3183FqJpTgj0VCLuag4EQDlotqiRAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t/xe7puOddiDfY8ZLHYOGM9q8Wc8y0s
        Ft2vZCzOn9/AbnH/3k8mi8u75rBZzDi/j8ni/69mZgcOjy0rbzJ5bDug6rFpVSebx7+FU1g8
        +rasYvT4vEkugC1Kz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSez
        LLVI3y5BL+PhzweMBZf4Kj5ffsDewPiSu4uRk0NCwETiyfIn7F2MXBxCAksZJd58m8IEkZCW
        aDy9GsoWlvhzrYsNoug1o8T+/Q/YQRLCAo4Sl481s4HYIgKaEtf/fmcFKWIWuMMk0XT3AlTH
        NUaJK1MPgnWwCehLHDx7kgXE5hWwkzj4YBNQEQcHi4CqxKvHYNtEBSIknm+/wQhRIihxcuYT
        sHJOgUCJKZNXsYLYzALqEn/mXWKGsMUlbj2ZzwRhy0tsfzuHeQKj0Cwk7bOQtMxC0jILScsC
        RpZVjCKppcW56bnFRnrFibnFpXnpesn5uZsYgXG47djPLTsYu94FH2IU4GBU4uHdrXw1Vog1
        say4MvcQowQHs5II757rV2KFeFMSK6tSi/Lji0pzUosPMZoC/TaRWUo0OR+YIvJK4g1NDc0t
        LA3Njc2NzSyUxHk7BA7GCAmkJ5akZqemFqQWwfQxcXBKNTDO5s9doOYf5S/0z5LZnEeUL27C
        np1bt3GJhgk/2T+tOSvMYbnp78pVM6yK1l73l3rHc6xlnfnkE39SnDI8X0aky3izb9hR+vmi
        Y9av9D+J51dIThOYfzi8oO8Pm+60qy/Llh1pLHrHUG/58NvlJOG3VyKnZ/YJJj+weDLxUJus
        jpaHRXb2LBslluKMREMt5qLiRACZRDmD2QIAAA==
X-CMS-MailID: 20191121105150eucas1p1fcb74b96f07541573eaaf5008e0648c0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20191120135541eucas1p14033edaac4d015cf1d2110d9d08f2f05
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20191120135541eucas1p14033edaac4d015cf1d2110d9d08f2f05
References: <CGME20191120135541eucas1p14033edaac4d015cf1d2110d9d08f2f05@eucas1p1.samsung.com>
        <20191120135527.7636-1-k.konieczny@samsung.com>
        <CAJKOXPefL_nyNaUExCJv6zKmhPTvgiPaaPT-sRoyyOw59aTZiQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 21.11.2019 06:12, Krzysztof Kozlowski wrote:
> On Wed, 20 Nov 2019 at 21:55, Kamil Konieczny <k.konieczny@samsung.com> wrote:
>>
>> Update my e-mail address to @samsung.com in maintainers.
>> Add also map in .mailmap to new e-mail.
>>
>> Signed-off-by: Kamil Konieczny <k.konieczny@samsung.com>
> 
> Hi Kamil,
> 
> To whom are you addressing it? All people are on CC so I am not sure
> if I am the one to pick it up.

Sorry, I should add Herbert in to: field,
my e-mail is in crypto driver so I think it can go by crypto tree.

-- 
Best regards,
Kamil Konieczny

>> ---
>>  .mailmap    | 1 +
>>  MAINTAINERS | 2 +-
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/.mailmap b/.mailmap
>> index fd6219293057..3727a0066bb1 100644
>> --- a/.mailmap
>> +++ b/.mailmap
>> @@ -133,6 +133,7 @@ Juha Yrjola <at solidboot.com>
>>  Juha Yrjola <juha.yrjola@nokia.com>
>>  Juha Yrjola <juha.yrjola@solidboot.com>
>>  Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
>> +Kamil Konieczny <k.konieczny@samsung.com> <k.konieczny@partner.samsung.com>
>>  Kay Sievers <kay.sievers@vrfy.org>
>>  Kenneth W Chen <kenneth.w.chen@intel.com>
>>  Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index e4f170d8bc29..0caf7560c782 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -14294,7 +14294,7 @@ F:      drivers/media/i2c/s5k5baf.c
>>  SAMSUNG S5P Security SubSystem (SSS) DRIVER
>>  M:     Krzysztof Kozlowski <krzk@kernel.org>
>>  M:     Vladimir Zapolskiy <vz@mleia.com>
>> -M:     Kamil Konieczny <k.konieczny@partner.samsung.com>
>> +M:     Kamil Konieczny <k.konieczny@samsung.com>
>>  L:     linux-crypto@vger.kernel.org
>>  L:     linux-samsung-soc@vger.kernel.org
>>  S:     Maintained
>> --
>> 2.24.0
>>
> 
> 

