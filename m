Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20EFC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 09:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiKVJIM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 04:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiKVJIF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 04:08:05 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E2D13E3D
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 01:08:03 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-314-HiSSCabqNqq1AfhFkRhZFw-1; Tue, 22 Nov 2022 09:08:01 +0000
X-MC-Unique: HiSSCabqNqq1AfhFkRhZFw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 22 Nov
 2022 09:07:59 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Tue, 22 Nov 2022 09:07:59 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Elliott, Robert (Servers)'" <elliott@hpe.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 10/24] crypto: x86/poly - limit FPU preemption
Thread-Topic: [PATCH v4 10/24] crypto: x86/poly - limit FPU preemption
Thread-Index: AQHY+XHqfLLvXNGxcESumjNg7U4Mn65BZh+AgAjYNxCAAG7pIA==
Date:   Tue, 22 Nov 2022 09:07:59 +0000
Message-ID: <7a0e89ad75334d90ba5b9c0623ed573b@AcuMS.aculab.com>
References: <20221103042740.6556-1-elliott@hpe.com>
 <20221116041342.3841-1-elliott@hpe.com>
 <20221116041342.3841-11-elliott@hpe.com> <Y3TF7/+DejcnN0eV@zx2c4.com>
 <MW5PR84MB1842625D9ECAF4F6244F558BAB0D9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <MW5PR84MB1842625D9ECAF4F6244F558BAB0D9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RnJvbTogRWxsaW90dCwgUm9iZXJ0DQo+IFNlbnQ6IDIyIE5vdmVtYmVyIDIwMjIgMDU6MDYNCi4u
Lg0KPiBTaW5jZSBlbnVtIGRvZXNuJ3QgZ3VhcmFudGVlIGFueSBwYXJ0aWN1bGFyIHR5cGUsIHRo
b3NlIHZhcmlhdGlvbnMNCj4gdXBzZXQgdGhlIG1pbigpIG1hY3JvLiBtaW5fdCgpIGlzIG5lY2Vz
c2FyeSB0byBlbGltaW5hdGUgdGhlDQo+IGNvbXBpbGVyIHdhcm5pbmcuDQoNClllcywgbWluKCkg
aXMgZnVuZGFtZW50YWxseSBicm9rZW4uIG1pbl90KCkgaXNuJ3QgcmVhbGx5IGEgc29sdXRpb24u
DQpJIHRoaW5rIG1pbigpIG5lZWRzIHRvIGluY2x1ZGUgc29tZXRoaW5nIGxpa2U6DQoNCiNkZWZp
bmUgbWluKGEsIGIpIFwNCglfX2J1aWx0aW5fY29uc3RhbnQoYikgJiYgKGIpICsgMHUgPD0gTUFY
X0lOVCA/IFwNCgkJKChhKSA8IChpbnQpKGIpID8gKGEpIDogKGludCkoYikpIDogXA0KCQkuLi4N
Cg0KU28gaW4gdGhlIGNvbW1vbiBjYXNlIHdoZXJlICdiJyBpcyBhIHNtYWxsIGNvbnN0YW50IGlu
dGVnZXIgaXQNCmRvZXNuJ3QgbWF0dGVyIHdoZXRoZXIgdGhlIGlzIGl0IHNpZ25lZCBvciB1bnNp
Z25lZC4NCg0KSSBtaWdodCB0cnkgY29tcGlsaW5nIGEga2VybmVsIHdoZXJlIG1pbl90KCkgZG9l
cyB0aGF0IGluc3RlYWQNCm9mIHRoZSBjYXN0cyAtIGp1c3QgdG8gc2VlIGhvdyBtYW55IG9mIHRo
ZSBjYXN0cyBhcmUgYWN0dWFsbHkNCm5lZWRlZC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQg
QWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVz
LCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

