Return-Path: <SRS0=EbYU=7U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F347BC433DF
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Jun 2020 13:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6B282064C
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Jun 2020 13:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgFGNDu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Jun 2020 09:03:50 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:41682 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726474AbgFGNDu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Jun 2020 09:03:50 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-34-niSo_StSOpacK4VCKZ_DvA-1; Sun, 07 Jun 2020 14:03:46 +0100
X-MC-Unique: niSo_StSOpacK4VCKZ_DvA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 7 Jun 2020 14:03:45 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 7 Jun 2020 14:03:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Herbert Xu' <herbert@gondor.apana.org.au>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        wangzhou1 <wangzhou1@hisilicon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>
Subject: RE: [PATCH] crypto: hisilicon - fix strncpy warning with strlcpy
Thread-Topic: [PATCH] crypto: hisilicon - fix strncpy warning with strlcpy
Thread-Index: AQHWOzNKRLAtoxLytEmaiwfeMuNV66jNIJ6A
Date:   Sun, 7 Jun 2020 13:03:45 +0000
Message-ID: <8c0d8f4e21794d8b80d0a3852830debb@AcuMS.aculab.com>
References: <202006032110.BEbKqovX%lkp@intel.com>
 <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
 <20200604033918.GA2286@gondor.apana.org.au>
 <b6ad8af2-1cb7-faac-0446-5e09e97f3616@linaro.org>
 <20200604061811.GA28759@gondor.apana.org.au>
 <b23433f8-d95d-8142-c830-fb92e5ccd4a1@linaro.org>
 <20200604065009.GA29822@gondor.apana.org.au>
 <f8dceec5-6835-c064-bb43-fd12668c2dbb@linaro.org>
 <20200605121703.GA3792@gondor.apana.org.au>
In-Reply-To: <20200605121703.GA3792@gondor.apana.org.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Herbert Xu
> Sent: 05 June 2020 13:17
...
> Better yet use strscpy which will even return an error for you.

It really ought to return the buffer length on truncation.
Then you can loop:
	while(...)
		buf += strxxxcpy(buf, src, buf_end - buf);
and only check right at the end.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

