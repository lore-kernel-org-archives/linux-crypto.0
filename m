Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF5FC433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 09:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82152078B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 09:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIBJhH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:37:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42616 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726124AbgIBJhF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 05:37:05 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3702C20DA70D8773C1F1;
        Wed,  2 Sep 2020 17:37:03 +0800 (CST)
Received: from [127.0.0.1] (10.74.173.29) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 2 Sep 2020
 17:36:56 +0800
Subject: Re: [PATCH RESEND 00/10] crypto: hisilicon/zip - misc clean up
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
References: <1598238709-58699-1-git-send-email-shenyang39@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <a926ab4c-fbe6-a6c5-055d-4a605c075699@huawei.com>
Date:   Wed, 2 Sep 2020 17:36:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <1598238709-58699-1-git-send-email-shenyang39@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.173.29]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

any comment?

Thanks,
Yang

On 2020/8/24 11:11, Yang Shen wrote:
> This patchset make some clean up:
> patch 1:remove useless parameters
> patch 4:replace 'sprintf' with 'scnprintf'
> patch 7:fix static check warning
> and the rest patch fix some coding style
>
> Resend this patch series because it depends on
> https://patchwork.kernel.org/cover/11715927/
> (crypto: hisilicon/qm - misc fixes).
> Now the patch series(crypto: hisilicon/qm - misc fixes) has been applied.
> So this patch series will apply against cryptodev.
>
> Shukun Tan (1):
>    crypto: hisilicon/zip - modify debugfs interface parameters
>
> Yang Shen (9):
>    crypto: hisilicon/zip - remove some useless parameters
>    crypto: hisilicon/zip - unify naming style for functions and macros
>    crypto: hisilicon/zip - replace 'sprintf' with 'scnprintf'
>    crypto: hisilicon/zip - use a enum parameter instead of some macros
>    crypto: hisilicon/zip - add print for error branch
>    crypto: hisilicon/zip - fix static check warning
>    crypto: hisilicon/zip - move some private macros from 'zip.h' to
>      'zip_crypto.c'
>    crypto: hisilicon/zip - supplement some comments
>    crypto: hisilicon/zip - fix some coding styles
>
>   drivers/crypto/hisilicon/zip/zip.h        |  15 ----
>   drivers/crypto/hisilicon/zip/zip_crypto.c | 126 ++++++++++++++++++++---------
>   drivers/crypto/hisilicon/zip/zip_main.c   | 130 ++++++++++++++----------------
>   3 files changed, 148 insertions(+), 123 deletions(-)
>
> --
> 2.7.4
>
>
> .
>


