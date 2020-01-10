Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1146DC33CA2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 10:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9C512082E
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 10:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgAJKIW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 05:08:22 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2249 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727540AbgAJKIW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 05:08:22 -0500
Received: from lhreml701-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 0506D60485352686A595;
        Fri, 10 Jan 2020 10:08:21 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml701-cah.china.huawei.com (10.201.108.42) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 10 Jan 2020 10:08:20 +0000
Received: from localhost (10.202.226.57) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Fri, 10 Jan
 2020 10:08:20 +0000
Date:   Fri, 10 Jan 2020 10:08:18 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     zhangfei <zhangfei.gao@linaro.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <grant.likely@arm.com>, jean-philippe <jean-philippe@linaro.org>,
        "Jerome Glisse" <jglisse@redhat.com>,
        <ilias.apalodimas@linaro.org>, <francois.ozog@linaro.org>,
        <kenneth-lee-2012@foxmail.com>, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        <guodong.xu@linaro.org>, <linux-accelerators@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v10 0/4] Add uacce module for Accelerator
Message-ID: <20200110100818.0000151a@Huawei.com>
In-Reply-To: <9b87edca-dd4e-3fe2-5acd-11f7381593ed@linaro.org>
References: <1576465697-27946-1-git-send-email-zhangfei.gao@linaro.org>
        <20200109174952.000051e1@Huawei.com>
        <9b87edca-dd4e-3fe2-5acd-11f7381593ed@linaro.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.202.226.57]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 10 Jan 2020 15:03:25 +0800
zhangfei <zhangfei.gao@linaro.org> wrote:

> On 2020/1/10 上午1:49, Jonathan Cameron wrote:
> > On Mon, 16 Dec 2019 11:08:13 +0800
> > Zhangfei Gao <zhangfei.gao@linaro.org> wrote:
> >  
> >> Uacce (Unified/User-space-access-intended Accelerator Framework) targets to
> >> provide Shared Virtual Addressing (SVA) between accelerators and processes.
> >> So accelerator can access any data structure of the main cpu.
> >> This differs from the data sharing between cpu and io device, which share
> >> data content rather than address.
> >> Because of unified address, hardware and user space of process can share
> >> the same virtual address in the communication.
> >>
> >> Uacce is intended to be used with Jean Philippe Brucker's SVA
> >> patchset[1], which enables IO side page fault and PASID support.
> >> We have keep verifying with Jean's sva patchset [2]
> >> We also keep verifying with Eric's SMMUv3 Nested Stage patches [3]  
> > Hi Zhangfei Gao,
> >
> > Just to check my understanding...
> >
> > This patch set is not dependent on either 2 or 3?
> >
> > To use it on our hardware, we need 2, but the interfaces used are already
> > upstream, so this could move forwards in parallel.
> >
> >  
> Yes,
> patch 1, 2 is for uacce.
> patch 3, 4 is an example using uacce, which happen to be crypto.
Sorry, I wasn't clear enough.

Question is whether we need Jean's sva patch set [2] to merge this?

> 
> Thanks


