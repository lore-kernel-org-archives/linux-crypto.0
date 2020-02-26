Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82611C4BA10
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 14:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6309E2467B
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 14:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgBZOal (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 09:30:41 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2469 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727112AbgBZOal (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 09:30:41 -0500
Received: from lhreml706-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 2E299AFDB37F24ADCAC6;
        Wed, 26 Feb 2020 14:30:40 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml706-cah.china.huawei.com (10.201.108.47) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 26 Feb 2020 14:30:40 +0000
Received: from localhost (10.202.227.76) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 26 Feb
 2020 14:30:39 +0000
Date:   Wed, 26 Feb 2020 14:30:37 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Xu Zaibo <xuzaibo@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <qianweili@huawei.com>, <tanghui20@huawei.com>,
        <forest.zhouchang@huawei.com>, <linuxarm@huawei.com>,
        <zhangwei375@huawei.com>, <shenyang39@huawei.com>,
        <yekai13@huawei.com>, <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 4/4] crypto: hisilicon/sec2 - Add pbuffer mode for SEC
 driver
Message-ID: <20200226143037.00007ab0@Huawei.com>
In-Reply-To: <1fa85493-0e56-745e-2f24-5a12c2fec496@huawei.com>
References: <1582189495-38051-1-git-send-email-xuzaibo@huawei.com>
        <1582189495-38051-5-git-send-email-xuzaibo@huawei.com>
        <20200224140154.00005967@Huawei.com>
        <80ab5da7-eceb-920e-dc36-1d411ad57a09@huawei.com>
        <20200225151426.000009f5@Huawei.com>
        <1fa85493-0e56-745e-2f24-5a12c2fec496@huawei.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 26 Feb 2020 19:18:51 +0800
Xu Zaibo <xuzaibo@huawei.com> wrote:

> Hi,
> On 2020/2/25 23:14, Jonathan Cameron wrote:
> > On Tue, 25 Feb 2020 11:16:52 +0800
> > Xu Zaibo <xuzaibo@huawei.com> wrote:
> >  
> >> Hi,
> >>
> >>
> >> On 2020/2/24 22:01, Jonathan Cameron wrote:  
> >>> On Thu, 20 Feb 2020 17:04:55 +0800
> >>> Zaibo Xu <xuzaibo@huawei.com> wrote:
> >>>   
> >>>  
> [...]
> >>>>    
> >>>> +static void sec_free_pbuf_resource(struct device *dev, struct sec_alg_res *res)
> >>>> +{
> >>>> +	if (res->pbuf)
> >>>> +		dma_free_coherent(dev, SEC_TOTAL_PBUF_SZ,
> >>>> +				  res->pbuf, res->pbuf_dma);
> >>>> +}
> >>>> +
> >>>> +/*
> >>>> + * To improve performance, pbuffer is used for
> >>>> + * small packets (< 576Bytes) as IOMMU translation using.
> >>>> + */
> >>>> +static int sec_alloc_pbuf_resource(struct device *dev, struct sec_alg_res *res)
> >>>> +{
> >>>> +	int pbuf_page_offset;
> >>>> +	int i, j, k;
> >>>> +
> >>>> +	res->pbuf = dma_alloc_coherent(dev, SEC_TOTAL_PBUF_SZ,
> >>>> +				&res->pbuf_dma, GFP_KERNEL);  
> >>> Would it make more sense perhaps to do this as a DMA pool and have
> >>> it expand on demand?  
> >> Since there exist all kinds of buffer length, I think dma_alloc_coherent
> >> may be better?  
> > As it currently stands we allocate a large buffer in one go but ensure
> > we only have a single dma map that occurs at startup.
> >
> > If we allocate every time (don't use pbuf) performance is hit by
> > the need to set up the page table entries and flush for every request.
> >
> > A dma pool with a fixed size element would at worst (for small messages)
> > mean you had to do a dma map / unmap every time 6 ish buffers.
> > This would only happen if you filled the whole queue.  Under normal operation
> > you will have a fairly steady number of buffers in use at a time, so mostly
> > it would be reusing buffers that were already mapped from a previous request.  
> Agree, dma pool may give a smaller range of mapped memory, which may 
> increase hits
> of IOMMU TLB.
> >
> > You could implement your own allocator on top of dma_alloc_coherent but it'll
> > probably be a messy and cost you more than using fixed size small elements.
> >
> > So a dmapool here would give you a mid point between using lots of memory
> > and never needing to map/unmap vs map/unmap every time.
> >  
> My concern is the spinlock of DMA pool, which adds an exclusion between 
> sending requests
> and receiving responses, since DMA blocks are allocated as sending and 
> freed at receiving.

Agreed.  That may be a bottleneck.  Not clear to me whether that would be a
significant issue or not.

Jonathan


> 
> Thanks,
> Zaibo
> 
> .
> >>>     
> >>>> +	if (!res->pbuf)
> >>>> +		return -ENOMEM;
> >>>> +
> >>>> +	/*
> >>>> +	 * SEC_PBUF_PKG contains data pbuf, iv and
> >>>> +	 * out_mac : <SEC_PBUF|SEC_IV|SEC_MAC>
> >>>> +	 * Every PAGE contains six SEC_PBUF_PKG
> >>>> +	 * The sec_qp_ctx contains QM_Q_DEPTH numbers of SEC_PBUF_PKG
> >>>> +	 * So we need SEC_PBUF_PAGE_NUM numbers of PAGE
> >>>> +	 * for the SEC_TOTAL_PBUF_SZ
> >>>> +	 */
> >>>> +	for (i = 0; i <= SEC_PBUF_PAGE_NUM; i++) {
> >>>> +		pbuf_page_offset = PAGE_SIZE * i;
> >>>> +		for (j = 0; j < SEC_PBUF_NUM; j++) {
> >>>> +			k = i * SEC_PBUF_NUM + j;
> >>>> +			if (k == QM_Q_DEPTH)
> >>>> +				break;
> >>>> +			res[k].pbuf = res->pbuf +
> >>>> +				j * SEC_PBUF_PKG + pbuf_page_offset;
> >>>> +			res[k].pbuf_dma = res->pbuf_dma +
> >>>> +				j * SEC_PBUF_PKG + pbuf_page_offset;
> >>>> +		}
> >>>> +	}
> >>>> +	return 0;
> >>>> +}
> >>>> +  
> [...]
> 


