Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E395FC4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Aug 2021 10:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA24A610CB
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Aug 2021 10:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbhHTKEQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Aug 2021 06:04:16 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:34775 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237085AbhHTKEP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Aug 2021 06:04:15 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-138-08xoD29xPr-TFgjlVjHiyg-1; Fri, 20 Aug 2021 11:03:32 +0100
X-MC-Unique: 08xoD29xPr-TFgjlVjHiyg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 20 Aug 2021 11:03:31 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Fri, 20 Aug 2021 11:03:31 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tianjia Zhang' <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Eric Biggers <ebiggers@google.com>,
        "Eric Biggers" <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Subject: RE: [PATCH 0/2] add AES-NI/AVX2/x86_64 implementation
Thread-Topic: [PATCH 0/2] add AES-NI/AVX2/x86_64 implementation
Thread-Index: AQHXk+GFp5jaKaOaxEa6x1rB2t/aG6t8LFCw
Date:   Fri, 20 Aug 2021 10:03:31 +0000
Message-ID: <f7684dd9dc5e4c6081ba8e51f53e0844@AcuMS.aculab.com>
References: <20210818033117.91717-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20210818033117.91717-1-tianjia.zhang@linux.alibaba.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tianjia Zhang
> Sent: 18 August 2021 04:31
> 
> This patchsets exported some of the common functions implemented by
> the SM4 AESNI/AVX algorithm, and reused these functions to achieve
> the acceleration of AESNI/AVX2 implementation.

These functions need bracketing by kernel_fpu_enable()
(or whatever it is called.)
That will significantly affect the performance.

Also the functions look pretty big (I don't know how big
the generic ones are) and will take time to load into the I$
and will displace other code.

So while a hot-cache benchmark might show improvements
for repeated calls is isn't obvious that any significant
gain will be made for real-life calls which could easily
be of single buffers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

