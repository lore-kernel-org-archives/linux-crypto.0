Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DEDC4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Nov 2023 13:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjKBNEk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Nov 2023 09:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjKBNEj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2023 09:04:39 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B865125;
        Thu,  2 Nov 2023 06:04:33 -0700 (PDT)
Received: from dggpemm500018.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SLkbT1RWSzvQVW;
        Thu,  2 Nov 2023 21:04:05 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500018.china.huawei.com (7.185.36.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 2 Nov 2023 21:04:07 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2507.031;
 Thu, 2 Nov 2023 21:04:07 +0800
From:   "Gonglei (Arei)" <arei.gonglei@huawei.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: RE: virtcrypto_dataq_callback calls crypto_finalize_request() from
 irq context
Thread-Topic: virtcrypto_dataq_callback calls crypto_finalize_request() from
 irq context
Thread-Index: AQHZ7VsjRTMxo/hUEkmU1GjtoDjS1rAp3v1A///cYoCAO3GWgIACEayQ
Date:   Thu, 2 Nov 2023 13:04:07 +0000
Message-ID: <5d9ebbdb042845009b47e6a9ee149231@huawei.com>
References: <20230922154546.4f7447ce.pasic@linux.ibm.com>
 <ed47fb73ad634ca395bd6c8e979dda8e@huawei.com>
 <20230924193941.6a02237f.pasic@linux.ibm.com>
 <20231101092521-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231101092521-mutt-send-email-mst@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.149.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Michael S. Tsirkin [mailto:mst@redhat.com]
> Sent: Wednesday, November 1, 2023 9:26 PM
> To: Halil Pasic <pasic@linux.ibm.com>
> Cc: Gonglei (Arei) <arei.gonglei@huawei.com>; Herbert Xu
> <herbert@gondor.apana.org.au>; Jason Wang <jasowang@redhat.com>;
> virtualization@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; Marc Hartmayer <mhartmay@linux.ibm.com>
> Subject: Re: virtcrypto_dataq_callback calls crypto_finalize_request() from irq
> context
> 
> On Sun, Sep 24, 2023 at 07:39:41PM +0200, Halil Pasic wrote:
> > On Sun, 24 Sep 2023 11:56:25 +0000
> > "Gonglei (Arei)" <arei.gonglei@huawei.com> wrote:
> >
> > > Hi Halil,
> > >
> > > Commit 4058cf08945 introduced a check for detecting crypto
> > > completion function called with enable BH, and indeed the
> > > virtio-crypto driver didn't disable BH, which needs a patch to fix it.
> > >
> > > P.S.:
> > > https://lore.kernel.org/lkml/20220221120833.2618733-5-clabbe@baylibr
> > > e.com/T/
> > >
> > > Regards,
> > > -Gonglei
> >
> > Thanks Gonglei!
> >
> > Thanks! I would be glad to test that fix on s390x. Are you about to
> > send one?
> >
> > Regards,
> > Halil
> 
> 
> Gonglei did you intend to send a fix?

Actually I sent a patch a month ago, pls see another thread.


Regards,
-Gonglei
