Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C372C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 07:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E28F5206A3
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 07:04:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nVgZDtAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388957AbfEXHEF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 03:04:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37569 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388872AbfEXHEF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 03:04:05 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190524070403euoutp01cebf8a0f165b2f8331c1f8e729d135a5~hjIO0PZIc0556105561euoutp01o
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 07:04:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190524070403euoutp01cebf8a0f165b2f8331c1f8e729d135a5~hjIO0PZIc0556105561euoutp01o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1558681443;
        bh=srtcpvW0EUb8Wk8jlJTeu8b1uqm9JXsDimO5od25VVU=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=nVgZDtAgKsdC3QnuO75UAezUk95L1aJ6IdnIQy5I42glvKPVl28qqnyKvsHqdokNa
         kmwFuLGpSAq0wbF4p4BSR5g9r+sH20e+AcyWR/Tcg1IBeHF3fQcQLBN3swuBkTjpnx
         1jLLS4myZaQgmku86FsxpC0wCjbNgtL961o2/xJs=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190524070403eucas1p19b1048d59849af288dfd91feb9f251f6~hjIOgMmzt1540615406eucas1p17;
        Fri, 24 May 2019 07:04:03 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id AF.03.04325.26797EC5; Fri, 24
        May 2019 08:04:02 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190524070402eucas1p2612b7719b36f305e6769db2f898bdc0c~hjINwiQji2321423214eucas1p2R;
        Fri, 24 May 2019 07:04:02 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190524070401eusmtrp2bef37a166f5f6fa9b1fbb735f602fd01~hjINigojR1709717097eusmtrp2r;
        Fri, 24 May 2019 07:04:01 +0000 (GMT)
X-AuditID: cbfec7f5-b8fff700000010e5-35-5ce797623e28
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 90.0F.04146.16797EC5; Fri, 24
        May 2019 08:04:01 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190524070401eusmtip213b9ae7a279f7a84b023694ce8199b95~hjINSCNPF2226722267eusmtip25;
        Fri, 24 May 2019 07:04:01 +0000 (GMT)
Subject: Re: another testmgr question
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <bbf4749b-9f7c-90d3-9adc-72e96467d0c4@partner.samsung.com>
Date:   Fri, 24 May 2019 09:04:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9F8EcDE8GRSyHFUh_pPXPJDziw7hXO=G4nA31PomDZ1g@mail.gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsWy7djP87pJ05/HGPydr2Px/8NuRou1e/4w
        W9y/95PJomv3MRYHFo/ONztZPTat6mTzuHNtD5vH501yASxRXDYpqTmZZalF+nYJXBkvlsQU
        bGOt6Nl9ga2BcTVLFyMnh4SAicT95eeYuhi5OIQEVjBKzPvUwQ7hfGGUuDd1FTOE85lR4snz
        FWwwLTuvPmKFSCxnlLjVuhzKecsosfXudyaQKmEBVYmD0zaDLRERSJZ4dOAWUDcHB7NAukT/
        nkiQMJuAucSj7WfAynkF3CS+b97ACFLCAtS65a4aSFhUIELi/rENrBAlghInZz4Bm8gpECgx
        8X4PM4jNLCAucevJfCYIW15i+9s5zBB3drNLrJphCWG7SMzc/I8JwhaWeHV8CzuELSPxf+d8
        qHi5xNOFfWDfSwi0MEo8aP8IDSNricPHL7JCnK8psX6XPkTYUeL40k1gJ0sI8EnceCsIcQKf
        xKRt05khwrwSHW1CENW6EvP+n2GFsKUluv6vY53AqDQLyWOzkDwzC8kzsxD2LmBkWcUonlpa
        nJueWmycl1quV5yYW1yal66XnJ+7iRGYVE7/O/51B+O+P0mHGAU4GJV4eLvqn8UIsSaWFVfm
        HmKU4GBWEuGN3Q8U4k1JrKxKLcqPLyrNSS0+xCjNwaIkzlvN8CBaSCA9sSQ1OzW1ILUIJsvE
        wSnVwDglUfBNU+/WLFsO+ZZpi/oVNh0sdzw2ccbL3Bn7ePhPXdrm/zX+e8xBT23zrclH1U5p
        NOy3PJ/cvka0fPmz58nf1mXMj+XMmef/tnXL90Va+xUEpcRzJ31u9vl/tbdB8c6WBLb4DQFL
        n206xPCgVsSZ+8a9p5EzBdIcGuY08mx4FJVw0/LyRRslluKMREMt5qLiRAAUYoXbJgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t/xe7qJ05/HGBxotLT4/2E3o8XaPX+Y
        Le7f+8lk0bX7GIsDi0fnm52sHptWdbJ53Lm2h83j8ya5AJYoPZui/NKSVIWM/OISW6VoQwsj
        PUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsEvYwXS2IKtrFW9Oy+wNbAuJqli5GTQ0LA
        RGLn1UesXYxcHEICSxklln54zg6RkJZoPL2aCcIWlvhzrYsNoug1o8SvF49ZQRLCAqoSB6dt
        BpskIpAscet2F1icWSBdYvOEz4wQDa+YJd6fWwiWYBMwl3i0/QzYVF4BN4nvmzcAFXFwsAAN
        2nJXDSQsKhAhceb9ChaIEkGJkzOfgNmcAoESE+/3MEPMV5f4M+8SlC0ucevJfCYIW15i+9s5
        zBMYhWYhaZ+FpGUWkpZZSFoWMLKsYhRJLS3OTc8tNtQrTswtLs1L10vOz93ECIylbcd+bt7B
        eGlj8CFGAQ5GJR7eB43PYoRYE8uKK3MPMUpwMCuJ8MbuBwrxpiRWVqUW5ccXleakFh9iNAX6
        bSKzlGhyPjDO80riDU0NzS0sDc2NzY3NLJTEeTsEDsYICaQnlqRmp6YWpBbB9DFxcEo1MAZd
        XL3shfLfFF0h9tromvfaZ5JjrrTl+Ylk6PydZvWL88ai49OnBj0W4OKU3Pjyn9dqtfK9Svpz
        5mqF/Yq7o7RMaP/Fmr2eDhuj5h6aWhNT4hu4wLQtPuxIcVj7yv6yzRuer/p8UZw3lcVv+bOr
        8y0N7vZp88prvtCa1iFa7eTCpSzA5l1+VImlOCPRUIu5qDgRAO0YIqi7AgAA
X-CMS-MailID: 20190524070402eucas1p2612b7719b36f305e6769db2f898bdc0c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190524052451epcas1p29029f5e2916daf9ade9c0c545886b432
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190524052451epcas1p29029f5e2916daf9ade9c0c545886b432
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
        <20190523185833.GA243994@google.com>
        <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
        <20190523200557.GA248378@gmail.com>
        <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
        <CGME20190524052451epcas1p29029f5e2916daf9ade9c0c545886b432@epcas1p2.samsung.com>
        <CAKv+Gu9F8EcDE8GRSyHFUh_pPXPJDziw7hXO=G4nA31PomDZ1g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 24.05.2019 07:24, Ard Biesheuvel wrote:
> On Thu, 23 May 2019 at 22:44, Pascal Van Leeuwen
> <pvanleeuwen@insidesecure.com> wrote:
>>
> [...]
> In fact, given the above, I am slightly shocked that your hardware
> does not handle empty messages correctly. [...]

Imho hardware handles it in the way it was designed, for Exynos
writing non-zero value to len message register starts hash/hmac.
Writing zero and waiting for result will cause hang, as there will be
no result ever.
It can be done in HW to handle zero with additional register and more wires,
but it was left to software driver as trivial case.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

