Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FEBC4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 02:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4FB2214E0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 02:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfJKCQB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 22:16:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3730 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727369AbfJKCQB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 22:16:01 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B4B44EFB568EAF1E59C1;
        Fri, 11 Oct 2019 10:15:57 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 11 Oct 2019
 10:15:48 +0800
Subject: Re: [PATCH 0/4] crypto: hisilicon: misc sgl fixes
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1569827335-21822-1-git-send-email-wangzhou1@hisilicon.com>
 <20191010125413.GB31566@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5D9FE5D4.1080809@hisilicon.com>
Date:   Fri, 11 Oct 2019 10:15:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20191010125413.GB31566@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/10/10 20:54, Herbert Xu wrote:
> On Mon, Sep 30, 2019 at 03:08:51PM +0800, Zhou Wang wrote:
>> This series fixes some preblems in sgl code. The main change is merging sgl
>> code into hisi_qm module. 
>>
>> These problem are also fixed:
>>  - Let user driver to pass the configure of sge number in one sgl when
>>    creating hardware sgl resources.
>>  - When disabling SMMU, it may fail to allocate large continuous memory. We
>>    fixes this by allocating memory by blocks.
>>
>> This series is based on Arnd's patch: https://lkml.org/lkml/2019/9/19/455
>>
>> Shunkun Tan (1):
>>   crypto: hisilicon - add sgl_sge_nr module param for zip
>>
>> Zhou Wang (3):
>>   crypto: hisilicon - merge sgl support to hisi_qm module
>>   crypto: hisilicon - fix large sgl memory allocation problem when
>>     disable smmu
>>   crypto: hisilicon - misc fix about sgl
>>
>>  MAINTAINERS                               |   1 -
>>  drivers/crypto/hisilicon/Kconfig          |   9 --
>>  drivers/crypto/hisilicon/Makefile         |   4 +-
>>  drivers/crypto/hisilicon/qm.h             |  13 +++
>>  drivers/crypto/hisilicon/sgl.c            | 182 +++++++++++++++++++-----------
>>  drivers/crypto/hisilicon/sgl.h            |  24 ----
>>  drivers/crypto/hisilicon/zip/zip.h        |   1 -
>>  drivers/crypto/hisilicon/zip/zip_crypto.c |  44 ++++++--
>>  8 files changed, 167 insertions(+), 111 deletions(-)
>>  delete mode 100644 drivers/crypto/hisilicon/sgl.h
> 
> All applied.  Thanks.

Thanks.

Best,
Zhou

> 

