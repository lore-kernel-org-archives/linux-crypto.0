Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87FEC4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 07:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 882182064A
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 07:26:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kMAiED8J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfJNH0u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 03:26:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53586 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730376AbfJNH0t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 03:26:49 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20191014072648euoutp02cb029bf33a488a639b0fa8659cc6a539~Ncr6dJGFy0914409144euoutp02S
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 07:26:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20191014072648euoutp02cb029bf33a488a639b0fa8659cc6a539~Ncr6dJGFy0914409144euoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571038008;
        bh=OLk7pXXurAa9FQS13uHV6bqERiGdVKT50sfYsuqEhJI=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=kMAiED8JVWucH+oXtRZoxPfCf+zTCeNg9zkhRBKtHVUu0ytf9P53j/GXFCd1sgZPU
         ilSq9AS83tysP6eo8TLzRNu2oS5KYNiF94ZMN2r7u1vtUWx1lURB3PTWMQB/pbGSaS
         JDHz+8AgBtqtxBzU4Vvm8T1njWlKNMarzLH4qoiY=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20191014072647eucas1p1cd8055e7788e19f004f5ff493e2b02bf~Ncr6VEx871639716397eucas1p1V;
        Mon, 14 Oct 2019 07:26:47 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id B3.9E.04374.73324AD5; Mon, 14
        Oct 2019 08:26:47 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20191014072647eucas1p1053d03cbe658d09170ceef54c443c0fc~Ncr5_Ro9f1094010940eucas1p12;
        Mon, 14 Oct 2019 07:26:47 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191014072647eusmtrp1bbfba05a0d5fc8170918a9ff7e0fe90c~Ncr59sgw71267412674eusmtrp1p;
        Mon, 14 Oct 2019 07:26:47 +0000 (GMT)
X-AuditID: cbfec7f5-4ddff70000001116-0e-5da42337b7d6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 28.C7.04166.73324AD5; Mon, 14
        Oct 2019 08:26:47 +0100 (BST)
Received: from [106.120.51.15] (unknown [106.120.51.15]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191014072647eusmtip24548024565ee507437aeddbab20956bb~Ncr5na2vq2846328463eusmtip2e;
        Mon, 14 Oct 2019 07:26:47 +0000 (GMT)
Subject: Re: [PATCH v2] hwrng: core - move add_early_randomness() out of
 rng_mutex
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-crypto@vger.kernel.org,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <cf2e09ba-108c-819d-cce1-3ee4818254d2@samsung.com>
Date:   Mon, 14 Oct 2019 09:26:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
        Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191012120928.GA24544@gondor.apana.org.au>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsWy7djPc7rmyktiDU5dNbDofiVjcf/eTyaL
        y7vmsFnMOL+PyeJTg5TFgm19jA5sHtsOqHq833eVzaPv5QZGj8+b5AJYorhsUlJzMstSi/Tt
        Ergy9u7ZxFZwg6vi07OLzA2M1zm6GDk5JARMJDZc3MTexcjFISSwglFi48WdzBDOF0aJPWdW
        s0A4nxkl5v94zATTsmr3EUYQW0hgOaPE/kVBEEVvGSW6Hv0BSnBwCAuESNzZHwVSIyIQLLF6
        zT+wQcwCsxklutc2soIk2AQMJbredrGB2LwCdhKNs/8wg9gsAqoSqx9uAYuLCsRK3PtxnBmi
        RlDi5MwnLCA2p4ClxK4l28BqmAXkJba/ncMMYYtL3HoyH+rQRewSSxZaQtguEv1bX7JB2MIS
        r45vYYewZSROT+4BO05CoJlR4uG5tewQTg+jxOWmGYwQVdYSh49fZAX5jFlAU2L9Ln2IsKPE
        jwPf2EDCEgJ8EjfeCkLcwCcxadt0Zogwr0RHmxBEtZrErOPr4NYevHCJeQKj0iwkn81C8s0s
        JN/MQti7gJFlFaN4amlxbnpqsXFearlecWJucWleul5yfu4mRmCiOf3v+NcdjPv+JB1iFOBg
        VOLhPZG8OFaINbGsuDL3EKMEB7OSCC/DhAWxQrwpiZVVqUX58UWlOanFhxilOViUxHmrGR5E
        CwmkJ5akZqemFqQWwWSZODilGhh5/j06P00pX45zS0WQ1nvPjar7Sr6anjPYYHrMIlBt97t+
        be/ZCrn9rqruYfI36w7IO0/eecUtoNny/9flNa4W/Ye70rplOy3DTTaVlnIedouJcI1InSYk
        aPRsBnf4I56Iw7tvWPXl7UmomnlvR4KoOO/+ra4yyg9nbF5uutN4kf1DBbv5xUosxRmJhlrM
        RcWJACHheEQwAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xe7rmyktiDRZPkLLofiVjcf/eTyaL
        y7vmsFnMOL+PyeJTg5TFgm19jA5sHtsOqHq833eVzaPv5QZGj8+b5AJYovRsivJLS1IVMvKL
        S2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQy9u7ZxFZwg6vi07OLzA2M
        1zm6GDk5JARMJFbtPsLYxcjFISSwlFHi/7Gl7BAJGYmT0xpYIWxhiT/Xutggil4zStzvegJU
        xMEhLBAicWd/FEiNiECwxMGl58F6mQVmM0q82BsOUb+LUeLd3iNMIAk2AUOJrrcggzg5eAXs
        JBpn/2EGsVkEVCVWP9zCBjJTVCBWYtNeM4gSQYmTM5+wgNicApYSu5ZsY4OYbyYxb/NDZghb
        XmL72zlQtrjErSfzmSYwCs1C0j4LScssJC2zkLQsYGRZxSiSWlqcm55bbKhXnJhbXJqXrpec
        n7uJERhZ24793LyD8dLG4EOMAhyMSjy8J5IXxwqxJpYVV+YeYpTgYFYS4WWYsCBWiDclsbIq
        tSg/vqg0J7X4EKMp0G8TmaVEk/OBUZ9XEm9oamhuYWlobmxubGahJM7bIXAwRkggPbEkNTs1
        tSC1CKaPiYNTqoHRuXxh7n1vfnERdp5TeqfPnHs+/apK97cLEvve8GiE9HMaKG7cHOPhFbMl
        RNnzxfFyllOKJ6yjNp+8mjsnrySZmcmCr3xC5xKjPUKHmKOYsv8H7dp4f/WMhRFupc82+Mks
        295w/9XSv9Z3jHP5fmtv+/jCawLTF7MniWpp1hv4eras4xJpiTyoxFKckWioxVxUnAgAaamk
        McICAAA=
X-CMS-MailID: 20191014072647eucas1p1053d03cbe658d09170ceef54c443c0fc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20191012120942epcas2p35ece13866825a2a056703882d58ad080
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20191012120942epcas2p35ece13866825a2a056703882d58ad080
References: <20191011134724.28651-1-lvivier@redhat.com>
        <CGME20191012120942epcas2p35ece13866825a2a056703882d58ad080@epcas2p3.samsung.com>
        <20191012120928.GA24544@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi

On 12.10.2019 14:09, Herbert Xu wrote:
> On Fri, Oct 11, 2019 at 03:47:24PM +0200, Laurent Vivier wrote:
>> add_early_randomness() is called every time a new rng backend is added
>> and every time it is set as the current rng provider.
>>
>> add_early_randomness() is called from functions locking rng_mutex,
>> and if it hangs all the hw_random framework hangs: we can't read sysfs,
>> add or remove a backend.
>>
>> This patch moves add_early_randomness() out of the rng_mutex zone.
>> It only needs the reading_mutex.
>>
>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>> ---
>>
>> Notes:
>>      v2: in hwrng_register, take rng->ref only if rng is the new current_rng
>>
>>   drivers/char/hw_random/core.c | 61 +++++++++++++++++++++++++----------
>>   1 file changed, 44 insertions(+), 17 deletions(-)
> Please rebase your patch on top of the cryptodev tree, i.e., make
> this an incremental patch with a Fixes header.

This v2 applied on the linux-next with reverted v1 fixes my issue.


When you prepare the incremental patch, feel free to add:

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: daae28debcb0 ("hwrng: core - move add_early_randomness() out of 
rng_mutex")
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

