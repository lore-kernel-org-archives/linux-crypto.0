Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC02C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  5 May 2022 11:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbiEELiY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 May 2022 07:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355476AbiEELiX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 May 2022 07:38:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA0B053B63
        for <linux-crypto@vger.kernel.org>; Thu,  5 May 2022 04:34:43 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-405-O9jIg1gzOYiRDVV0CyY18A-1; Thu, 05 May 2022 12:34:41 +0100
X-MC-Unique: O9jIg1gzOYiRDVV0CyY18A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Thu, 5 May 2022 12:34:40 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Thu, 5 May 2022 12:34:40 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jason A. Donenfeld'" <Jason@zx2c4.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [patch 3/3] x86/fpu: Make FPU protection more robust
Thread-Topic: [patch 3/3] x86/fpu: Make FPU protection more robust
Thread-Index: AQHYYG+YWY1FRr4hzkKhJKBT7m/w1q0QJdtA
Date:   Thu, 5 May 2022 11:34:40 +0000
Message-ID: <1f4918f734d14e3896071d3c7de1441d@AcuMS.aculab.com>
References: <YnDwjjdiSQ5Yml6E@hirez.programming.kicks-ass.net>
 <87fslpjomx.ffs@tglx> <YnKh96isoB7jiFrv@zx2c4.com> <87czgtjlfq.ffs@tglx>
 <YnLOXZp6WgH7ULVU@zx2c4.com> <87wnf1huwj.ffs@tglx>
 <YnMRwPFfvB0RlBow@zx2c4.com> <87mtfwiyqp.ffs@tglx>
 <YnMkRLcxczMxdE5z@zx2c4.com> <87h764ixjs.ffs@tglx>
 <YnOuqh4YZT8ww96W@zx2c4.com>
In-Reply-To: <YnOuqh4YZT8ww96W@zx2c4.com>
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
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Li4uDQo+ICsJY3ljbGVzX3QgZW5kLCBzdGFydCA9IGdldF9jeWNsZXMoKTsNCj4gIAlibGFrZTJz
X3VwZGF0ZSgmaW5wdXRfcG9vbC5oYXNoLCBpbiwgbmJ5dGVzKTsNCj4gKwllbmQgPSBnZXRfY3lj
bGVzKCk7DQoNCklmIGdldF9jeWNsZXMoKSBpcyByZHRzYyB0aGVuIHRoYXQgZ2l2ZXMgbWVhbmlu
Z2xlc3MgbnVtYmVycy4NClRoZSBjcHUgY2xvY2sgZnJlcXVlbmN5IHdpbGwgY2hhbmdlIG9uIHlv
dS4NCg0KWW91IGNhbiB1c2Ugb25lIG9mIHRoZSBwZXJmb3JtYW5jZSBjb3VudGVycyB0byBnZXQg
YW4gYWN0dWFsDQpjeWNsZSBjb3VudCAtIGFsdGhvdWdoIHRoYXQgaXMgb25seSBzdGFibGUgZm9y
ICdob3QgY2FjaGUnDQphcyBhbnkgbWVtb3J5IGFjY2Vzc2VzIGFyZSBjbG9jayBzcGVlZCBkZXBl
bmRhbnQuDQoNCk9UT0ggdGhlIGVudHJvcHkgbWl4aW5nIGlzIHZlcnkgbGlrZWx5IHRvIGJlICdj
b2xkIGNhY2hlJw0KYW5kIGFsbCB0aGUgdW5yb2xsaW5nIGluIGJsYWtlczcgd2lsbCBjb21wbGV0
ZWx5IGtpbGwNCnBlcmZvcm1hbmNlLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

