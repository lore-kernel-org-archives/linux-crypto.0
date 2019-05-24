Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72A0C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 10:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A09E217D7
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 10:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oDEQbAZL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390657AbfEXKnq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 06:43:46 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59091 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390578AbfEXKnq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 06:43:46 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190524104344euoutp013ad230e46aceacc68a7d2eb471aa262d~hmIDAdpHa2786127861euoutp01J
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 10:43:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190524104344euoutp013ad230e46aceacc68a7d2eb471aa262d~hmIDAdpHa2786127861euoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1558694624;
        bh=Co3KwE6OhgnHBO2mjrKcI196rNeBY2o1NPtUjUIXoGQ=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=oDEQbAZLm5+Kh9H2a4qV5fXlI2jtDpvyLZbIBQoOBiiFkNipLdsQF9sEGd+25kbjX
         5md0JXNDLdyoDujbtRmG7W5OS9HmEvnbal1JoQp8ojJ8keTmEG6FNXRMB7rad4v6vy
         Pt7RQhMzEwffSKEjNmO5CuinpOPCPmFAjZEZlZx0=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190524104344eucas1p2d39cb3daa38f0e74fc3d2b0efac0d52c~hmICin3QA1736317363eucas1p2J;
        Fri, 24 May 2019 10:43:44 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id ED.8E.04377.0EAC7EC5; Fri, 24
        May 2019 11:43:44 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190524104343eucas1p2035c2f0223826189ad0550ca18304e0d~hmIB32ubC1130611306eucas1p2a;
        Fri, 24 May 2019 10:43:43 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190524104343eusmtrp168707c7ecba40ab6af1b3876cf0e7948~hmIBp4qHm1053010530eusmtrp1g;
        Fri, 24 May 2019 10:43:43 +0000 (GMT)
X-AuditID: cbfec7f4-12dff70000001119-02-5ce7cae09063
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id C0.C9.04140.FDAC7EC5; Fri, 24
        May 2019 11:43:43 +0100 (BST)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190524104343eusmtip104e4756c6aa13f15a6d2d397876dfcef~hmIBb3Qnq1836618366eusmtip1e;
        Fri, 24 May 2019 10:43:43 +0000 (GMT)
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From:   Kamil Konieczny <k.konieczny@partner.samsung.com>
Message-ID: <1786cc8d-187d-e3ce-376b-e728263b1e68@partner.samsung.com>
Date:   Fri, 24 May 2019 12:43:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <AM6PR09MB3523E18FC16E2FFA117127D2D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsWy7djPc7oPTj2PMXjwlsni/4fdjBYdzUwW
        9+/9ZLLo2n2MxYHFo7X/B5tH55udrB53ru1h8/i8SS6AJYrLJiU1J7MstUjfLoEr49eWftaC
        LpaK69NXsTcwLmDuYuTkkBAwkXh0bhNTFyMXh5DACkaJM2+mskI4Xxgl1nSvZoFwPjNKzP/e
        zgTTsvrIRHaIxHJGiavzJzJDOG8ZJe5cPsQIUiUsoCpxcNpmFhBbRCBZ4mTbD7CFzAL5EkuO
        LgeLswmYSzzafgZsKq+Am8TnY+2sIDYLUO/yhhXsILaoQITE/WMbWCFqBCVOznwC1sspECtx
        deoyFoiZ4hK3nsxngrDlJba/nQN2kIRAN7vE5pc7WCHOdpH43nMF6mthiVfHt7BD2DISpyf3
        sEDY5RJPF/axQzS3MEo8aP8IlbCWOHz8ItAgDqANmhLrd+mDmBICjhL7myUgTD6JG28FIU7g
        k5i0bTozRJhXoqNNCGKGrsS8/2egjpGW6Pq/jnUCo9IsJI/NQvLMLCTPzEJYu4CRZRWjeGpp
        cW56arFRXmq5XnFibnFpXrpecn7uJkZgYjn97/iXHYy7/iQdYhTgYFTi4X3Q+CxGiDWxrLgy
        9xCjBAezkghv7H6gEG9KYmVValF+fFFpTmrxIUZpDhYlcd5qhgfRQgLpiSWp2ampBalFMFkm
        Dk6pBkZm7sVfbvQc2SC/3L8o7hGHur7ebg7FdQIixxh6DeTTj2mLbVXbsFFyZcC9+rRHa7Wi
        Hj5MnFfLxfvINeot35G/1yY2Fn2dnyzwYoplnLDthtKesIjgO3dn/vnz1ktk2fI407qnP6U/
        bpqzpfuwpNcpbi7F6ODOt/OzLjX5W5pKTvkkLzDp6yYlluKMREMt5qLiRAB7OXppKAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t/xu7r3Tz2PMehoF7H4/2E3o0VHM5PF
        /Xs/mSy6dh9jcWDxaO3/webR+WYnq8eda3vYPD5vkgtgidKzKcovLUlVyMgvLrFVija0MNIz
        tLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DL+LWln7Wgi6Xi+vRV7A2MC5i7GDk5JARM
        JFYfmcjexcjFISSwlFHiSGsjO0RCWqLx9GomCFtY4s+1LjaIoteMElN2TQLrFhZQlTg4bTML
        iC0ikCwxc/I2sDizQL7E69etUA2X2SVmH1sHNpVNwFzi0fYzYFN5BdwkPh9rZwWxWYAGLW9Y
        AVYjKhAhceb9ChaIGkGJkzOfgNmcArESV6cuY4FYoC7xZ94lqGXiEreezGeCsOUltr+dwzyB
        UWgWkvZZSFpmIWmZhaRlASPLKkaR1NLi3PTcYiO94sTc4tK8dL3k/NxNjMBo2nbs55YdjF3v
        gg8xCnAwKvHwPmh8FiPEmlhWXJl7iFGCg1lJhDd2P1CINyWxsiq1KD++qDQntfgQoynQcxOZ
        pUST84GRnlcSb2hqaG5haWhubG5sZqEkztshcDBGSCA9sSQ1OzW1ILUIpo+Jg1OqgdG4q0Am
        7XC13Pb9e92aFn7uTb8ZvMyJk9/sS5V4w/olaU2Hgs/MqVzp8OrHFj/ZGY3HZ73as0b3QqhP
        lc3MrhVXUzzecM36pb/mzzoZuZM7Tv+rL3Q/ptCe4/z/enhTdfqliyuv+4vmX1/ntaTntJyD
        vf/fE5ZNhm37JN9ksBzmX8N3x687/7USS3FGoqEWc1FxIgAP5IonvAIAAA==
X-CMS-MailID: 20190524104343eucas1p2035c2f0223826189ad0550ca18304e0d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190524101331epcas3p2f26e2f0abe56056992646e798a26470c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190524101331epcas3p2f26e2f0abe56056992646e798a26470c
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
        <20190523185833.GA243994@google.com>
        <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
        <20190523200557.GA248378@gmail.com>
        <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
        <20190523234853.GC248378@gmail.com>
        <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
        <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
        <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
        <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
        <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
        <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com>
        <CGME20190524101331epcas3p2f26e2f0abe56056992646e798a26470c@epcas3p2.samsung.com>
        <AM6PR09MB3523E18FC16E2FFA117127D2D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 24.05.2019 12:13, Pascal Van Leeuwen wrote:
>> True. Those are the "other" reasons - besides acceleration - to use hardware
>> offload which we often use to sell our IP.
>> But the honest story there is that that only works out for situations
>> where there's enough work to do to make the software overhead for actually
>> starting and managing that work insignificant. [...]

Hmm, is there any HW which support hash of zero-len message ?

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

