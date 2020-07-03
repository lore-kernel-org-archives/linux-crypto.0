Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6495C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 04:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 843AA2075D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 04:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgGCEgu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:36:50 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:55932 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725648AbgGCEgu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jul 2020 00:36:50 -0400
Received: from dggemi401-hub.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id BF6C37BBBC7C0F55BDC1;
        Fri,  3 Jul 2020 12:36:47 +0800 (CST)
Received: from DGGEMI422-HUB.china.huawei.com (10.1.199.151) by
 dggemi401-hub.china.huawei.com (10.3.17.134) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 3 Jul 2020 12:36:47 +0800
Received: from DGGEMI525-MBS.china.huawei.com ([169.254.6.177]) by
 dggemi422-hub.china.huawei.com ([10.1.199.151]) with mapi id 14.03.0487.000;
 Fri, 3 Jul 2020 12:36:41 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Subject: RE: [PATCH v2 1/3] crypto: permit users to specify numa node of
 acomp hardware
Thread-Topic: [PATCH v2 1/3] crypto: permit users to specify numa node of
 acomp hardware
Thread-Index: AQHWSRVMTIoAHOilQkOjx1WnEmLDrqj0x7+AgACMHoA=
Date:   Fri, 3 Jul 2020 04:36:40 +0000
Message-ID: <B926444035E5E2439431908E3842AFD2552A25@DGGEMI525-MBS.china.huawei.com>
References: <20200623041610.7620-1-song.bao.hua@hisilicon.com>
 <20200623041610.7620-2-song.bao.hua@hisilicon.com>
 <20200703041123.GA7774@gondor.apana.org.au>
In-Reply-To: <20200703041123.GA7774@gondor.apana.org.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.200.157]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Friday, July 3, 2020 4:11 PM
> To: Song Bao Hua (Barry Song) <song.bao.hua@hisilicon.com>
> Cc: davem@davemloft.net; Wangzhou (B) <wangzhou1@hisilicon.com>;
> Jonathan Cameron <jonathan.cameron@huawei.com>;
> akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> linux-mm@kvack.org; linux-kernel@vger.kernel.org; Linuxarm
> <linuxarm@huawei.com>; Seth Jennings <sjenning@redhat.com>; Dan
> Streetman <ddstreet@ieee.org>; Vitaly Wool <vitaly.wool@konsulko.com>
> Subject: Re: [PATCH v2 1/3] crypto: permit users to specify numa node of
> acomp hardware
> 
> On Tue, Jun 23, 2020 at 04:16:08PM +1200, Barry Song wrote:
> >
> > -void *crypto_create_tfm(struct crypto_alg *alg,
> > -			const struct crypto_type *frontend)
> > +void *crypto_create_tfm_node(struct crypto_alg *alg,
> > +			const struct crypto_type *frontend,
> > +			int node)
> >  {
> >  	char *mem;
> >  	struct crypto_tfm *tfm = NULL;
> > @@ -451,6 +452,7 @@ void *crypto_create_tfm(struct crypto_alg *alg,
> >
> >  	tfm = (struct crypto_tfm *)(mem + tfmsize);
> >  	tfm->__crt_alg = alg;
> > +	tfm->node = node;
> 
> Should the kzalloc also use node?

Yes, it would be nice since the tfm will mainly be accessed by CPU on the specific node.

> 
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Thanks
Barry

